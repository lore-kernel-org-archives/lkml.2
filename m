Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab2HOTtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:49:46 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62796 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397Ab2HOTtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:49:41 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: NeilBrown <neilb@suse.de>, Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 035/165] md: Fix handling for devices from 2TB to 4TB in 0.90 metadata.
Date: Wed, 15 Aug 2012 15:46:19 -0400
Message-ID: <1345060109-9187-36-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neilb@suse.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 27a7b260f71439c40546b43588448faac01adb93 upstream.

0.90 metadata uses an unsigned 32bit number to count the number of
kilobytes used from each device.
This should allow up to 4TB per device.
However we multiply this by 2 (to get sectors) before casting to a
larger type, so sizes above 2TB get truncated.

Also we allow rdev->sectors to be larger than 4TB, so it is possible
for the array to be resized larger than the metadata can handle.
So make sure rdev->sectors never exceeds 4TB when 0.90 metadata is in
used.

Also the sanity check at the end of super_90_load should include level
1 as it used ->size too. (RAID0 and Linear don't use ->size at all).

Reported-by: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/md/md.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d26df7f..4788c82 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -985,8 +985,11 @@ static int super_90_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version
 			ret = 0;
 	}
 	rdev->sectors = rdev->sb_start;
+	/* Limit to 4TB as metadata cannot record more than that */
+	if (rdev->sectors >= (2ULL << 32))
+		rdev->sectors = (2ULL << 32) - 2;
 
-	if (rdev->sectors < sb->size * 2 && sb->level > 1)
+	if (rdev->sectors < ((sector_t)sb->size) * 2 && sb->level >= 1)
 		/* "this cannot possibly happen" ... */
 		ret = -EINVAL;
 
@@ -1021,7 +1024,7 @@ static int super_90_validate(mddev_t *mddev, mdk_rdev_t *rdev)
 		mddev->clevel[0] = 0;
 		mddev->layout = sb->layout;
 		mddev->raid_disks = sb->raid_disks;
-		mddev->dev_sectors = sb->size * 2;
+		mddev->dev_sectors = ((sector_t)sb->size) * 2;
 		mddev->events = ev1;
 		mddev->bitmap_info.offset = 0;
 		mddev->bitmap_info.default_offset = MD_SB_BYTES >> 9;
@@ -1260,6 +1263,11 @@ super_90_rdev_size_change(mdk_rdev_t *rdev, sector_t num_sectors)
 	rdev->sb_start = calc_dev_sboffset(rdev->bdev);
 	if (!num_sectors || num_sectors > rdev->sb_start)
 		num_sectors = rdev->sb_start;
+	/* Limit to 4TB as metadata cannot record more than that.
+	 * 4TB == 2^32 KB, or 2*2^32 sectors.
+	 */
+	if (num_sectors >= (2ULL << 32))
+		num_sectors = (2ULL << 32) - 2;
 	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
 		       rdev->sb_page);
 	md_super_wait(rdev->mddev);
-- 
1.7.12.rc2

