Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab1KGOCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 09:02:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48780 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab1KGOCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 09:02:08 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: tytso@mit.edu
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v2] ext4: fix NULL pointer dereference from orig_data in fill_super and remount.
Date: Mon,  7 Nov 2011 23:01:51 +0900
Message-Id: <1320674511-1980-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix NULL pointer dereference from orig_data in fill_super and remount.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 fs/ext4/super.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9953d80..717b3e8 100644
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
@@ -3125,6 +3124,10 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
 	ext4_group_t first_not_zeroed;
 
+	char *orig_data = kstrdup(data, GFP_KERNEL);
+	if (!orig_data)
+		return ret;
+
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		goto out_free_orig;
@@ -4398,6 +4401,8 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	int i;
 #endif
 	char *orig_data = kstrdup(data, GFP_KERNEL);
+	if (!orig_data)
+		return -ENOMEM;
 
 	/* Store the original options */
 	lock_super(sb);
-- 
1.7.4.4

