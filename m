Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab1HTMao (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 08:30:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab1HTMam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 08:30:42 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        torvalds@linux-foundation.org, mingo@kernel.org,
        liubo2009@cn.fujitsu.com
Subject: [PATCH] Btrfs: fix 64 bit divide problem
Date: Sat, 20 Aug 2011 08:29:51 -0400
Message-Id: <1313843391-3904-1-git-send-email-josef@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a regression introduced by

cdcb725c05fe0cb71777c66ddc2445fedbbb3c59

In cases where we need to divide/multiply by 2 we should just left/right shift
respectively, and in cases where theres N number of devices use do_div.  Also
make the counters u64 to match up with rw_devices.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 44a3107..99ab571 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6727,9 +6727,9 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
 	struct btrfs_device *device;
 	u64 min_free;
+	u64 dev_min = 1;
+	u64 dev_nr = 0;
 	int index;
-	int dev_nr = 0;
-	int dev_min = 1;
 	int full = 0;
 	int ret = 0;
 
@@ -6788,14 +6788,16 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 	index = get_block_group_index(block_group);
 	if (index == 0) {
 		dev_min = 4;
-		min_free /= 2;
+		/* Divide by 2 */
+		min_free >>= 1;
 	} else if (index == 1) {
 		dev_min = 2;
 	} else if (index == 2) {
-		min_free *= 2;
+		/* Multiply by 2 */
+		min_free <<= 1;
 	} else if (index == 3) {
 		dev_min = fs_devices->rw_devices;
-		min_free /= dev_min;
+		do_div(min_free, dev_min);
 	}
 
 	mutex_lock(&root->fs_info->chunk_mutex);
-- 
1.7.5.2

