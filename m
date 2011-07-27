Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab1G0AfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:35:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:17764 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768Ab1G0AfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:35:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="34855681"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: drosenberg@vsecurity.com, anil_ravindranath@pmc-sierra.com,
        James.Bottomley@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] [19/98] pmcraid: reject negative request size
Message-Id: <20110727003511.4F8032403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:35:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Dan Rosenberg <drosenberg@vsecurity.com>

commit 5f6279da3760ce48f478f2856aacebe0c59a39f3 upstream.

There's a code path in pmcraid that can be reached via device ioctl that
causes all sorts of ugliness, including heap corruption or triggering
the OOM killer due to consecutive allocation of large numbers of pages.
Not especially relevant from a security perspective, since users must
have CAP_SYS_ADMIN to open the character device.

First, the user can call pmcraid_chr_ioctl() with a type
PMCRAID_PASSTHROUGH_IOCTL.  A pmcraid_passthrough_ioctl_buffer
is copied in, and the request_size variable is set to
buffer->ioarcb.data_transfer_length, which is an arbitrary 32-bit signed
value provided by the user.

If a negative value is provided here, bad things can happen.  For
example, pmcraid_build_passthrough_ioadls() is called with this
request_size, which immediately calls pmcraid_alloc_sglist() with a
negative size.  The resulting math on allocating a scatter list can
result in an overflow in the kzalloc() call (if num_elem is 0, the
sglist will be smaller than expected), or if num_elem is unexpectedly
large the subsequent loop will call alloc_pages() repeatedly, a high
number of pages will be allocated and the OOM killer might be invoked.

Prevent this value from being negative in pmcraid_ioctl_passthrough().

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/pmcraid.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.35.y/drivers/scsi/pmcraid.c
===================================================================
--- linux-2.6.35.y.orig/drivers/scsi/pmcraid.c
+++ linux-2.6.35.y/drivers/scsi/pmcraid.c
@@ -3528,6 +3528,9 @@ static long pmcraid_ioctl_passthrough(
 			rc = -EFAULT;
 			goto out_free_buffer;
 		}
+	} else if (request_size < 0) {
+		rc = -EINVAL;
+		goto out_free_buffer;
 	}
 
 	/* check if we have any additional command parameters */
