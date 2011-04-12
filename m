Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab1DLOku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:40:50 -0400
Received: from kroah.org ([198.145.64.141]:57885 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932468Ab1DLOi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:58 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:58 2011
Message-Id: <20110412143558.550111079@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:35:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: [099/105] Squashfs: handle corruption of directory structure
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Phillip Lougher <phillip@lougher.demon.co.uk>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/squashfs/dir.c   |    9 +++++++++
 fs/squashfs/namei.c |   12 ++++++++++++
 2 files changed, 21 insertions(+)

--- a/fs/squashfs/dir.c
+++ b/fs/squashfs/dir.c
@@ -172,6 +172,11 @@ static int squashfs_readdir(struct file
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
@@ -183,6 +188,10 @@ static int squashfs_readdir(struct file
 
 			size = le16_to_cpu(dire->size) + 1;
 
+			/* size should never be larger than SQUASHFS_NAME_LEN */
+			if (size > SQUASHFS_NAME_LEN)
+				goto failed_read;
+
 			err = squashfs_read_metadata(inode->i_sb, dire->name,
 					&block, &offset, size);
 			if (err < 0)
--- a/fs/squashfs/namei.c
+++ b/fs/squashfs/namei.c
@@ -176,6 +176,11 @@ static struct dentry *squashfs_lookup(st
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
@@ -187,6 +192,10 @@ static struct dentry *squashfs_lookup(st
 
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


