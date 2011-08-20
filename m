Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab1HTCS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 22:18:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52975 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751462Ab1HTCS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 22:18:26 -0400
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <mingo@kernel.org>, <jwboyer@gmail.com>,
        <josef@redhat.com>, <linux-btrfs@vger.kernel.org>,
        <chris.mason@oracle.com>, <dave@jikos.cz>
Subject: [PATCH v2] Btrfs: use do_div to avoid compile errors on 32bit box
Date: Sat, 20 Aug 2011 10:17:47 +0800
Message-Id: <1313806667-30495-1-git-send-email-liubo2009@cn.fujitsu.com>
X-Mailer: git-send-email 1.6.5.2
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-20 10:17:11,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-20 10:17:12,
	Serialize complete at 2011-08-20 10:17:12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When doing div operation of u64 type, we need to be careful and use do_div
to avoid compile ERROR on 32bit box:

"ERROR: "__udivdi3" [fs/btrfs/btrfs.ko] undefined!
make[1]: *** [__modpost] Error 1

v1->v2:
- fix stupid do_div() with type "signed integer".

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 80d6148..e43e4f1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6735,9 +6735,10 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
 	struct btrfs_device *device;
 	u64 min_free;
+	u32 dev_min = 1;
+	u32 dev_nr = 0;
+	u32 dup = 2;
 	int index;
-	int dev_nr = 0;
-	int dev_min = 1;
 	int full = 0;
 	int ret = 0;
 
@@ -6796,14 +6797,14 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 	index = get_block_group_index(block_group);
 	if (index == 0) {
 		dev_min = 4;
-		min_free /= 2;
+		do_div(min_free, dup);
 	} else if (index == 1) {
 		dev_min = 2;
 	} else if (index == 2) {
-		min_free *= 2;
+		min_free *= dup;
 	} else if (index == 3) {
 		dev_min = fs_devices->rw_devices;
-		min_free /= dev_min;
+		do_div(min_free, dev_min);
 	}
 
 	mutex_lock(&root->fs_info->chunk_mutex);
-- 
1.6.5.2

