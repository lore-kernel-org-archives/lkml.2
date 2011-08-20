Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab1HTBf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 21:35:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51006 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab1HTBfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 21:35:25 -0400
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>
Cc: <linux-btrfs@vger.kernel.org>, <chris.mason@oracle.com>, <dave@jikos.cz>
Subject: [PATCH] Btrfs: use do_div to avoid compile errors on 32bit box
Date: Sat, 20 Aug 2011 09:34:36 +0800
Message-Id: <1313804076-30228-1-git-send-email-liubo2009@cn.fujitsu.com>
X-Mailer: git-send-email 1.6.5.2
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-20 09:34:01,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-20 09:34:01,
	Serialize complete at 2011-08-20 09:34:01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When doing div operation of u64 type, we need to be careful and use do_div
to avoid compile ERROR on 32bit box:

"ERROR: "__udivdi3" [fs/btrfs/btrfs.ko] undefined!
make[1]: *** [__modpost] Error 1

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 80d6148..9b495ce 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6796,14 +6796,14 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 	index = get_block_group_index(block_group);
 	if (index == 0) {
 		dev_min = 4;
-		min_free /= 2;
+		do_div(min_free, 2);
 	} else if (index == 1) {
 		dev_min = 2;
 	} else if (index == 2) {
 		min_free *= 2;
 	} else if (index == 3) {
 		dev_min = fs_devices->rw_devices;
-		min_free /= dev_min;
+		do_div(min_free, dev_min);
 	}
 
 	mutex_lock(&root->fs_info->chunk_mutex);
-- 
1.6.5.2

