Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab1JZHl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 03:41:57 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:42602 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754814Ab1JZHlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 03:41:21 -0400
From: Tao Ma <tm@tao.ma>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, adilger@dilger.ca
Subject: [PATCH V1 15/17] ext4: let empty_dir handle inline dir.
Date: Wed, 26 Oct 2011 15:34:26 +0800
Message-Id: <1319614468-11227-15-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1319614468-11227-1-git-send-email-tm@tao.ma>
References: <4EA7B788.3040503@tao.ma>
 <1319614468-11227-1-git-send-email-tm@tao.ma>
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 182.92.247.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

empty_dir is used when deleting a dir. So it should handle
inline dir properly.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/namei.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index fefd061..343af6c 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2235,6 +2235,50 @@ out_stop:
 	return err;
 }
 
+static int empty_inline_dir(struct inode *dir)
+{
+	int err, inline_size;
+	struct ext4_iloc iloc;
+	void *inline_start;
+	unsigned int offset;
+	struct ext4_dir_entry_2 *de, *de1;
+	int ret = 0;
+
+	err = ext4_get_inode_loc(dir, &iloc);
+	if (err) {
+		EXT4_ERROR_INODE(dir, "error %d getting inode %lu block",
+				 err, dir->i_ino);
+		return 1;
+	}
+
+	inline_start = ext4_get_inline_data_pos(dir, &iloc);
+	inline_size = ext4_get_max_inline_size(dir);
+
+	de = (struct ext4_dir_entry_2 *)inline_start;
+	de1 = ext4_next_entry(de, inline_size);
+	if (le32_to_cpu(de->inode) != dir->i_ino ||
+			!le32_to_cpu(de1->inode) ||
+			strcmp(".", de->name) ||
+			strcmp("..", de1->name)) {
+		ext4_warning(dir->i_sb,
+			     "bad directory (dir #%lu) - no `.' or `..'",
+			     dir->i_ino);
+		ret = 1;
+		goto out;
+	}
+
+	offset = ext4_rec_len_from_disk(de->rec_len, inline_size) +
+		 ext4_rec_len_from_disk(de1->rec_len, inline_size);
+	de = ext4_next_entry(de1, inline_size);
+	/* We should only have 2 entries: . and ... */
+
+	if ((void *)de == inline_start + inline_size)
+		ret = 1;
+
+out:
+	brelse(iloc.bh);
+	return ret;
+}
 /*
  * routine to check that the specified directory is empty (for rmdir)
  */
@@ -2246,6 +2290,9 @@ static int empty_dir(struct inode *inode)
 	struct super_block *sb;
 	int err = 0;
 
+	if (ext4_has_inline_data(inode))
+		return empty_inline_dir(inode);
+
 	sb = inode->i_sb;
 	if (inode->i_size < EXT4_DIR_REC_LEN(1) + EXT4_DIR_REC_LEN(2) ||
 	    !(bh = ext4_bread(NULL, inode, 0, 0, &err))) {
-- 
1.7.0.4

