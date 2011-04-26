Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab1DZVct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:32:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:44123 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932173Ab1DZVOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="425951105"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: phillip@lougher.demon.co.uk, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [43/106] Squashfs: handle corruption of directory structure
Message-Id: <20110426211323.02EB13E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/squashfs/dir.c   |    9 +++++++++
 fs/squashfs/namei.c |   12 ++++++++++++
 2 files changed, 21 insertions(+)

Index: linux-2.6.35.y/fs/squashfs/dir.c
===================================================================
--- linux-2.6.35.y.orig/fs/squashfs/dir.c
+++ linux-2.6.35.y/fs/squashfs/dir.c
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
Index: linux-2.6.35.y/fs/squashfs/namei.c
===================================================================
--- linux-2.6.35.y.orig/fs/squashfs/namei.c
+++ linux-2.6.35.y/fs/squashfs/namei.c
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
