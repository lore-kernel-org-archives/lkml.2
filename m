Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab1G0Ak6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:40:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:51164 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091Ab1G0AfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:35:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="31838618"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: drosenberg@vsecurity.com, stable@kernel.org, eric.moore@lsi.com,
        James.Bottomley@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] [11/98] mpt2sas: prevent heap overflows and unchecked reads
Message-Id: <20110727003503.2CC022403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:35:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Dan Rosenberg <drosenberg@vsecurity.com>

[ upstream commit a1f74ae82d133ebb2aabb19d181944b4e83e9960 ]

At two points in handling device ioctls via /dev/mpt2ctl, user-supplied
length values are used to copy data from userspace into heap buffers
without bounds checking, allowing controllable heap corruption and
subsequently privilege escalation.

Additionally, user-supplied values are used to determine the size of a
copy_to_user() as well as the offset into the buffer to be read, with no
bounds checking, allowing users to read arbitrary kernel memory.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: stable@kernel.org
Acked-by: Eric Moore <eric.moore@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/drivers/scsi/mpt2sas/mpt2sas_ctl.c
===================================================================
--- linux-2.6.35.y.orig/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ linux-2.6.35.y/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -637,6 +637,13 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPT
 	data_out_sz = karg.data_out_size;
 	data_in_sz = karg.data_in_size;
 
+	/* Check for overflow and wraparound */
+	if (karg.data_sge_offset * 4 > ioc->request_sz ||
+	    karg.data_sge_offset > (UINT_MAX / 4)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	/* copy in request message frame from user */
 	if (copy_from_user(mpi_request, mf, karg.data_sge_offset*4)) {
 		printk(KERN_ERR "failure at %s:%d/%s()!\n", __FILE__, __LINE__,
@@ -1883,7 +1890,7 @@ _ctl_diag_read_buffer(void __user *arg, 
 	Mpi2DiagBufferPostReply_t *mpi_reply;
 	int rc, i;
 	u8 buffer_type;
-	unsigned long timeleft;
+	unsigned long timeleft, request_size, copy_size;
 	u16 smid;
 	u16 ioc_status;
 	u8 issue_reset = 0;
@@ -1919,6 +1926,8 @@ _ctl_diag_read_buffer(void __user *arg, 
 		return -ENOMEM;
 	}
 
+	request_size = ioc->diag_buffer_sz[buffer_type];
+
 	if ((karg.starting_offset % 4) || (karg.bytes_to_read % 4)) {
 		printk(MPT2SAS_ERR_FMT "%s: either the starting_offset "
 		    "or bytes_to_read are not 4 byte aligned\n", ioc->name,
@@ -1926,13 +1935,23 @@ _ctl_diag_read_buffer(void __user *arg, 
 		return -EINVAL;
 	}
 
+	if (karg.starting_offset > request_size)
+		return -EINVAL;
+
 	diag_data = (void *)(request_data + karg.starting_offset);
 	dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: diag_buffer(%p), "
 	    "offset(%d), sz(%d)\n", ioc->name, __func__,
 	    diag_data, karg.starting_offset, karg.bytes_to_read));
 
+	/* Truncate data on requests that are too large */
+	if ((diag_data + karg.bytes_to_read < diag_data) ||
+	    (diag_data + karg.bytes_to_read > request_data + request_size))
+		copy_size = request_size - karg.starting_offset;
+	else
+		copy_size = karg.bytes_to_read;
+
 	if (copy_to_user((void __user *)uarg->diagnostic_data,
-	    diag_data, karg.bytes_to_read)) {
+	    diag_data, copy_size)) {
 		printk(MPT2SAS_ERR_FMT "%s: Unable to write "
 		    "mpt_diag_read_buffer_t data @ %p\n", ioc->name,
 		    __func__, diag_data);
