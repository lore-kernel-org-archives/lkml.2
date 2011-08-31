Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab1HaGpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 02:45:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44609 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735Ab1HaGpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 02:45:17 -0400
Date: Wed, 31 Aug 2011 16:45:07 +1000
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PULL REQUEST] md fixes for 3.1
Message-ID: <20110831164507.02d6f787@notabene.brown>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,
 please pull assorted small md fixes as follows.

Thanks,
NeilBrown


The following changes since commit 14c62e78dc1379185515be41903c4a667efc6d54:

  Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2011-08-23 18:09:08 -0700)

are available in the git repository at:

  git://neil.brown.name/md for-linus

Namhyung Kim (1):
      md: use REQ_NOIDLE flag in md_super_write()

NeilBrown (5):
      md: report failure if a 'set faulty' request doesn't.
      md: ensure changes to 'write-mostly' are reflected in metadata.
      md/linear: avoid corrupting structure while waiting for rcu_free to complete.
      md: fix clearing of 'blocked' flag in the presence of bad blocks.
      md/raid5: fix a hang on device failure.

 drivers/md/linear.h |    2 +-
 drivers/md/md.c     |   16 +++++++++++++---
 drivers/md/raid5.c  |    2 +-
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/md/linear.h b/drivers/md/linear.h
index 0ce29b6..2f2da05 100644
--- a/drivers/md/linear.h
+++ b/drivers/md/linear.h
@@ -10,9 +10,9 @@ typedef struct dev_info dev_info_t;
 
 struct linear_private_data
 {
+	struct rcu_head		rcu;
 	sector_t		array_sectors;
 	dev_info_t		disks[0];
-	struct rcu_head		rcu;
 };
 
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8e221a2..3742ce8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -848,7 +848,7 @@ void md_super_write(mddev_t *mddev, mdk_rdev_t *rdev,
 	bio->bi_end_io = super_written;
 
 	atomic_inc(&mddev->pending_writes);
-	submit_bio(REQ_WRITE | REQ_SYNC | REQ_FLUSH | REQ_FUA, bio);
+	submit_bio(WRITE_FLUSH_FUA, bio);
 }
 
 void md_super_wait(mddev_t *mddev)
@@ -1738,6 +1738,11 @@ static void super_1_sync(mddev_t *mddev, mdk_rdev_t *rdev)
 	sb->level = cpu_to_le32(mddev->level);
 	sb->layout = cpu_to_le32(mddev->layout);
 
+	if (test_bit(WriteMostly, &rdev->flags))
+		sb->devflags |= WriteMostly1;
+	else
+		sb->devflags &= ~WriteMostly1;
+
 	if (mddev->bitmap && mddev->bitmap_info.file == NULL) {
 		sb->bitmap_offset = cpu_to_le32((__u32)mddev->bitmap_info.offset);
 		sb->feature_map = cpu_to_le32(MD_FEATURE_BITMAP_OFFSET);
@@ -2561,7 +2566,10 @@ state_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 	int err = -EINVAL;
 	if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
 		md_error(rdev->mddev, rdev);
-		err = 0;
+		if (test_bit(Faulty, &rdev->flags))
+			err = 0;
+		else
+			err = -EBUSY;
 	} else if (cmd_match(buf, "remove")) {
 		if (rdev->raid_disk >= 0)
 			err = -EBUSY;
@@ -2584,7 +2592,7 @@ state_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 		err = 0;
 	} else if (cmd_match(buf, "-blocked")) {
 		if (!test_bit(Faulty, &rdev->flags) &&
-		    test_bit(BlockedBadBlocks, &rdev->flags)) {
+		    rdev->badblocks.unacked_exist) {
 			/* metadata handler doesn't understand badblocks,
 			 * so we need to fail the device
 			 */
@@ -5983,6 +5991,8 @@ static int set_disk_faulty(mddev_t *mddev, dev_t dev)
 		return -ENODEV;
 
 	md_error(mddev, rdev);
+	if (!test_bit(Faulty, &rdev->flags))
+		return -EBUSY;
 	return 0;
 }
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index dbae459..43709fa 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3336,7 +3336,7 @@ static void handle_stripe(struct stripe_head *sh)
 
 finish:
 	/* wait for this device to become unblocked */
-	if (unlikely(s.blocked_rdev))
+	if (conf->mddev->external && unlikely(s.blocked_rdev))
 		md_wait_for_blocked_rdev(s.blocked_rdev, conf->mddev);
 
 	if (s.handle_bad_blocks)
