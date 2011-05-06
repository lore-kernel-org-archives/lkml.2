Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab1EFBBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 21:01:18 -0400
Received: from kroah.org ([198.145.64.141]:36625 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569Ab1EFAY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:27 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:07 2011
Message-Id: <20110506002207.688297455@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Anil Ravindranath <anil_ravindranath@pmc-sierra.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [026/143] [SCSI] pmcraid: reject negative request size
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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

---
 drivers/scsi/pmcraid.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3508,6 +3508,9 @@ static long pmcraid_ioctl_passthrough(
 			rc = -EFAULT;
 			goto out_free_buffer;
 		}
+	} else if (request_size < 0) {
+		rc = -EINVAL;
+		goto out_free_buffer;
 	}
 
 	/* check if we have any additional command parameters */


