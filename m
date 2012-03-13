Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473Ab2CMAWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:22:08 -0400
Received: from mail.windriver.com ([147.11.1.11]:47443 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758450Ab2CMAWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:05 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Phillip Lougher <phillip@lougher.demon.co.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 050/196] Squashfs: handle corruption of directory structure
Date: Mon, 12 Mar 2012 20:19:23 -0400
Message-Id: <1331598109-31424-5-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Phillip Lougher <phillip@lougher.demon.co.uk>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 44cff8a9ee8a974f9e931df910688e7fc1f0b0f9 upstream.

Handle the rare case where a directory metadata block is uncompressed and
corrupted, leading to a kernel oops in directory scanning (memcpy).
Normally corruption is detected at the decompression stage and dealt with
then, however, this will not happen if:

- metadata isn't compressed (users can optionally request no metadata
  compression), or
- the compressed metadata block was larger than the original, in which
  case the uncompressed version was used, or
- the data was corrupt after decompression

This patch fixes this by adding some sanity checks against known maximum
values.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/squashfs/dir.c   |    9 +++++++++
 fs/squashfs/namei.c |   12 ++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/fs/squashfs/dir.c b/fs/squashfs/dir.c
index 12b933a..a37d445 100644
--- a/fs/squashfs/dir.c
+++ b/fs/squashfs/dir.c
@@ -172,6 +172,11 @@ static int squashfs_readdir(struct file *file, void *dirent, filldir_t filldir)
 		length += sizeof(dirh);
 
 		dir_count = le32_to_cpu(dirh.count) + 1;
+
+		/* dir_count should never be larger than 256 */
+		if (dir_count > 256)
+			goto failed_read;
+
 		while (dir_count--) {
 			/*
 			 * Read directory entry.
@@ -183,6 +188,10 @@ static int squashfs_readdir(struct file *file, void *dirent, filldir_t filldir)
 
 			size = le16_to_cpu(dire->size) + 1;
 
+			/* size should never be larger than SQUASHFS_NAME_LEN */
+			if (size > SQUASHFS_NAME_LEN)
+				goto failed_read;
+
 			err = squashfs_read_metadata(inode->i_sb, dire->name,
 					&block, &offset, size);
 			if (err < 0)
diff --git a/fs/squashfs/namei.c b/fs/squashfs/namei.c
index 5266bd8..4fa484d 100644
--- a/fs/squashfs/namei.c
+++ b/fs/squashfs/namei.c
@@ -174,6 +174,11 @@ static struct dentry *squashfs_lookup(struct inode *dir, struct dentry *dentry,
 		length += sizeof(dirh);
 
 		dir_count = le32_to_cpu(dirh.count) + 1;
+
+		/* dir_count should never be larger than 256 */
+		if (dir_count > 256)
+			goto data_error;
+
 		while (dir_count--) {
 			/*
 			 * Read directory entry.
@@ -185,6 +190,10 @@ static struct dentry *squashfs_lookup(struct inode *dir, struct dentry *dentry,
 
 			size = le16_to_cpu(dire->size) + 1;
 
+			/* size should never be larger than SQUASHFS_NAME_LEN */
+			if (size > SQUASHFS_NAME_LEN)
+				goto data_error;
+
 			err = squashfs_read_metadata(dir->i_sb, dire->name,
 					&block, &offset, size);
 			if (err < 0)
@@ -226,6 +235,9 @@ exit_lookup:
 	d_add(dentry, inode);
 	return ERR_PTR(0);
 
+data_error:
+	err = -EIO;
+
 read_failure:
 	ERROR("Unable to read directory block [%llx:%x]\n",
 		squashfs_i(dir)->start + msblk->directory_table,
-- 
1.7.9.3

