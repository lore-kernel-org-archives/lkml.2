Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965862Ab2EOCTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:19:06 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53493 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965314Ab2EOCRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:45 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 129/179] pmcraid: reject negative request size
Date: Mon, 14 May 2012 22:13:45 -0400
Message-ID: <1337048075-6132-130-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit b5b515445f4f5a905c5dd27e6e682868ccd6c09d upstream.

There's a code path in pmcraid that can be reached via device ioctl that
causes all sorts of ugliness, including heap corruption or triggering the
OOM killer due to consecutive allocation of large numbers of pages.

First, the user can call pmcraid_chr_ioctl(), with a type
PMCRAID_PASSTHROUGH_IOCTL.  This calls through to
pmcraid_ioctl_passthrough().  Next, a pmcraid_passthrough_ioctl_buffer
is copied in, and the request_size variable is set to
buffer->ioarcb.data_transfer_length, which is an arbitrary 32-bit
signed value provided by the user.  If a negative value is provided
here, bad things can happen.  For example,
pmcraid_build_passthrough_ioadls() is called with this request_size,
which immediately calls pmcraid_alloc_sglist() with a negative size.
The resulting math on allocating a scatter list can result in an
overflow in the kzalloc() call (if num_elem is 0, the sglist will be
smaller than expected), or if num_elem is unexpectedly large the
subsequent loop will call alloc_pages() repeatedly, a high number of
pages will be allocated and the OOM killer might be invoked.

It looks like preventing this value from being negative in
pmcraid_ioctl_passthrough() would be sufficient.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/pmcraid.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index bdb7259..ba82c0c 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3577,6 +3577,9 @@ static long pmcraid_ioctl_passthrough(
 			pmcraid_err("couldn't build passthrough ioadls\n");
 			goto out_free_buffer;
 		}
+	} else if (request_size < 0) {
+		rc = -EINVAL;
+		goto out_free_buffer;
 	}
 
 	/* If data is being written into the device, copy the data from user
-- 
1.7.9.6

