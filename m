Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810Ab2CMAXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:23:12 -0400
Received: from mail.windriver.com ([147.11.1.11]:48070 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758851Ab2CMAXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:10 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        Anil Ravindranath <anil_ravindranath@pmc-sierra.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 105/196] pmcraid: reject negative request size
Date: Mon, 12 Mar 2012 20:20:18 -0400
Message-Id: <1331598109-31424-60-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/pmcraid.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 53aefff..bdb7259 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3528,6 +3528,9 @@ static long pmcraid_ioctl_passthrough(
 			rc = -EFAULT;
 			goto out_free_buffer;
 		}
+	} else if (request_size < 0) {
+		rc = -EINVAL;
+		goto out_free_buffer;
 	}
 
 	/* check if we have any additional command parameters */
-- 
1.7.9.3

