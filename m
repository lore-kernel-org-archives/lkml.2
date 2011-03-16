Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab1CPBVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 21:21:18 -0400
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:33977 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750975Ab1CPBVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 21:21:14 -0400
Message-ID: <4D801078.5090104@lougher.demon.co.uk>
Date: Wed, 16 Mar 2011 01:20:56 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] Squashfs: handle corruption of directory structure
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
---
  fs/squashfs/dir.c   |    9 +++++++++
  fs/squashfs/namei.c |   12 ++++++++++++
  2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/fs/squashfs/dir.c b/fs/squashfs/dir.c
index 0dc340a..3f79cd1 100644
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
index 7a9464d..5d922a6 100644
--- a/fs/squashfs/namei.c
+++ b/fs/squashfs/namei.c
@@ -176,6 +176,11 @@ static struct dentry *squashfs_lookup(struct inode *dir, struct dentry *dentry,
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
@@ -187,6 +192,10 @@ static struct dentry *squashfs_lookup(struct inode *dir, struct dentry *dentry,

  			size = le16_to_cpu(dire->size) + 1;

+			/* size should never be larger than SQUASHFS_NAME_LEN */
+			if (size > SQUASHFS_NAME_LEN)
+				goto data_error;
+
  			err = squashfs_read_metadata(dir->i_sb, dire->name,
  					&block, &offset, size);
  			if (err < 0)
@@ -228,6 +237,9 @@ exit_lookup:
  	d_add(dentry, inode);
  	return ERR_PTR(0);

+data_error:
+	err = -EIO;
+
  read_failure:
  	ERROR("Unable to read directory block [%llx:%x]\n",
  		squashfs_i(dir)->start + msblk->directory_table,
-- 
1.7.1

