Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab1ABIH5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:07:57 -0500
Received: from mail.windriver.com ([147.11.1.11]:34424 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab1ABHWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:01 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 023/260] ext4: restart ext4_ext_remove_space() after transaction restart
Date: Sun,  2 Jan 2011 02:15:19 -0500
Message-Id: <1293952756-15010-24-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:31.0225 (UTC) FILETIME=[89DB5E90:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit 0617b83fa239db9743a18ce6cc0e556f4d0fd567 upstream.

If i_data_sem was internally dropped due to transaction restart, it is
necessary to restart path look-up because extents tree was possibly
modified by ext4_get_block().

https://bugzilla.kernel.org/show_bug.cgi?id=15827

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/extents.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5e663a7..bb03109 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -107,11 +107,8 @@ static int ext4_ext_truncate_extend_restart(handle_t *handle,
 	if (err <= 0)
 		return err;
 	err = ext4_truncate_restart_trans(handle, inode, needed);
-	/*
-	 * We have dropped i_data_sem so someone might have cached again
-	 * an extent we are going to truncate.
-	 */
-	ext4_ext_invalidate_cache(inode);
+	if (err == 0)
+		err = -EAGAIN;
 
 	return err;
 }
@@ -2361,7 +2358,7 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
 	int depth = ext_depth(inode);
 	struct ext4_ext_path *path;
 	handle_t *handle;
-	int i = 0, err = 0;
+	int i, err;
 
 	ext_debug("truncate since %u\n", start);
 
@@ -2370,23 +2367,26 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
+again:
 	ext4_ext_invalidate_cache(inode);
 
 	/*
 	 * We start scanning from right side, freeing all the blocks
 	 * after i_size and walking into the tree depth-wise.
 	 */
+	depth = ext_depth(inode);
 	path = kzalloc(sizeof(struct ext4_ext_path) * (depth + 1), GFP_NOFS);
 	if (path == NULL) {
 		ext4_journal_stop(handle);
 		return -ENOMEM;
 	}
+	path[0].p_depth = depth;
 	path[0].p_hdr = ext_inode_hdr(inode);
 	if (ext4_ext_check(inode, path[0].p_hdr, depth)) {
 		err = -EIO;
 		goto out;
 	}
-	path[0].p_depth = depth;
+	i = err = 0;
 
 	while (i >= 0 && err == 0) {
 		if (i == depth) {
@@ -2480,6 +2480,8 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
 out:
 	ext4_ext_drop_refs(path);
 	kfree(path);
+	if (err == -EAGAIN)
+		goto again;
 	ext4_journal_stop(handle);
 
 	return err;
-- 
1.7.3.3

