Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab1KFPTr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 10:19:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59001 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab1KFPTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 10:19:46 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: tytso@mit.edu
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH] ext4: fix NULL pointer dereference from orig_data in fill_super and remount.
Date: Mon,  7 Nov 2011 00:19:35 +0900
Message-Id: <1320592775-2046-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix NULL pointer dereference from orig_data in fill_super and remount.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 fs/ext4/super.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9953d80..3770d3f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3102,7 +3102,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 				__releases(kernel_lock)
 				__acquires(kernel_lock)
 {
-	char *orig_data = kstrdup(data, GFP_KERNEL);
 	struct buffer_head *bh;
 	struct ext4_super_block *es = NULL;
 	struct ext4_sb_info *sbi;
@@ -3124,6 +3123,10 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	int err;
 	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
 	ext4_group_t first_not_zeroed;
+
+	char *orig_data = kstrdup(data, GFP_KERNEL);
+	if (!orig_data)
+		return ret;
 
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
@@ -4398,6 +4401,10 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	int i;
 #endif
 	char *orig_data = kstrdup(data, GFP_KERNEL);
+	if (!orig_data) {
+		err = -ENOMEM;
+		goto failed_alloc_orig;
+	}
 
 	/* Store the original options */
 	lock_super(sb);
@@ -4562,6 +4569,8 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	return 0;
 
 restore_opts:
+	kfree(orig_data);
+failed_alloc_orig:
 	sb->s_flags = old_sb_flags;
 	sbi->s_mount_opt = old_opts.s_mount_opt;
 	sbi->s_mount_opt2 = old_opts.s_mount_opt2;
@@ -4580,7 +4589,6 @@ restore_opts:
 	}
 #endif
 	unlock_super(sb);
-	kfree(orig_data);
 	return err;
 }
 
-- 
1.7.4.4

