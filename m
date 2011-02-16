Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550Ab1BPBv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:51:26 -0500
Received: from kroah.org ([198.145.64.141]:49092 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758133Ab1BPBuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:50:46 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:47:01 2011
Message-Id: <20110216014701.088990835@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:45:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>
Subject: [068/115] md: fix regression with re-adding devices to arrays with no metadata
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit bf572541ab44240163eaa2d486b06f306a31d45a upstream.

Commit 1a855a0606 (2.6.37-rc4) fixed a problem where devices were
re-added when they shouldn't be but caused a regression in a less
common case that means sometimes devices cannot be re-added when they
should be.

In particular, when re-adding a device to an array without metadata
we should always access the device, but after the above commit we
didn't.

This patch sets the In_sync flag in that case so that the re-add
succeeds.

This patch is suitable for any -stable kernel to which 1a855a0606 was
applied.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4802,9 +4802,10 @@ static int add_new_disk(mddev_t * mddev,
 		/* set saved_raid_disk if appropriate */
 		if (!mddev->persistent) {
 			if (info->state & (1<<MD_DISK_SYNC)  &&
-			    info->raid_disk < mddev->raid_disks)
+			    info->raid_disk < mddev->raid_disks) {
 				rdev->raid_disk = info->raid_disk;
-			else
+				set_bit(In_sync, &rdev->flags);
+			} else
 				rdev->raid_disk = -1;
 		} else
 			super_types[mddev->major_version].


