Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933491Ab1C3WFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:05:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:4817 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933223Ab1C3VGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903734107"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: kashyap.desai@lsi.com, James.Bottomley@suse.de, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [41/275] mpt2sas: Kernel Panic during Large Topology discovery
Message-Id: <20110330210436.D5CAF3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Kashyap, Desai <kashyap.desai@lsi.com>

commit 4224489f45b503f0a1f1cf310f76dc108f45689a upstream.

There was a configuration page timing out during the initial port
enable at driver load time. The port enable would fail, and this would
result in the driver unloading itself, meanwhile the driver was accessing
freed memory in another context resulting in the panic.  The fix is to
prevent access to freed memory once the driver had issued the diag reset
which woke up the sleeping port enable process.  The routine
_base_reset_handler was reorganized so the last sleeping process woken up was
the port_enable.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/mpt2sas/mpt2sas_base.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/scsi/mpt2sas/mpt2sas_base.c
===================================================================
--- linux-2.6.35.y.orig/drivers/scsi/mpt2sas/mpt2sas_base.c	2011-03-29 23:02:59.029325007 -0700
+++ linux-2.6.35.y/drivers/scsi/mpt2sas/mpt2sas_base.c	2011-03-29 23:02:59.049324495 -0700
@@ -3736,6 +3736,8 @@
 static void
 _base_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
 {
+	mpt2sas_scsih_reset_handler(ioc, reset_phase);
+	mpt2sas_ctl_reset_handler(ioc, reset_phase);
 	switch (reset_phase) {
 	case MPT2_IOC_PRE_RESET:
 		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
@@ -3766,8 +3768,6 @@
 		    "MPT2_IOC_DONE_RESET\n", ioc->name, __func__));
 		break;
 	}
-	mpt2sas_scsih_reset_handler(ioc, reset_phase);
-	mpt2sas_ctl_reset_handler(ioc, reset_phase);
 }
 
 /**
@@ -3821,6 +3821,7 @@
 {
 	int r;
 	unsigned long flags;
+	u8 pe_complete = ioc->wait_for_port_enable_to_complete;
 
 	dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: enter\n", ioc->name,
 	    __func__));
@@ -3845,6 +3846,14 @@
 	if (r)
 		goto out;
 	_base_reset_handler(ioc, MPT2_IOC_AFTER_RESET);
+
+	/* If this hard reset is called while port enable is active, then
+	 * there is no reason to call make_ioc_operational
+	 */
+	if (pe_complete) {
+		r = -EFAULT;
+		goto out;
+	}
 	r = _base_make_ioc_operational(ioc, sleep_flag);
 	if (!r)
 		_base_reset_handler(ioc, MPT2_IOC_DONE_RESET);
