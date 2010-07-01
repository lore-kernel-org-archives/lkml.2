Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833Ab0GAUvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:51:14 -0400
Received: from kroah.org ([198.145.64.141]:47460 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932653Ab0GAUuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:50:13 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:32 2010
Message-Id: <20100701173432.133446880@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:34:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [patch 063/164] md/raid1: fix counting of write targets.
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 964147d5c86d63be79b442c30f3783d49860c078 upstream.

There is a very small race window when writing to a
RAID1 such that if a device is marked faulty at exactly the wrong
time, the write-in-progress will not be sent to the device,
but the bitmap (if present) will be updated to say that
the write was sent.

Then if the device turned out to still be usable as was re-added
to the array, the bitmap-based-resync would skip resyncing that
block, possibly leading to corruption.  This would only be a problem
if no further writes were issued to that area of the device (i.e.
that bitmap chunk).

Suitable for any pending -stable kernel.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid1.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -911,9 +911,10 @@ static int make_request(struct request_q
 			if (test_bit(Faulty, &rdev->flags)) {
 				rdev_dec_pending(rdev, mddev);
 				r1_bio->bios[i] = NULL;
-			} else
+			} else {
 				r1_bio->bios[i] = bio;
-			targets++;
+				targets++;
+			}
 		} else
 			r1_bio->bios[i] = NULL;
 	}


