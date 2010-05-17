Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab0EQTd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:33:56 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:33180 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752565Ab0EQTdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:33:54 -0400
Message-ID: <4BF1999A.5040707@lougher.demon.co.uk>
Date: Mon, 17 May 2010 20:31:38 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] squashfs: add new extended inode types
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add new extended inode types that store the xattr_id field.
Also add the necessary code changes to make xattrs visibile.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
  fs/squashfs/inode.c       |   91 +++++++++++++++++++++++++++++++++++++++++---
  fs/squashfs/namei.c       |    5 ++-
  fs/squashfs/squashfs.h    |   12 +++++-
  fs/squashfs/squashfs_fs.h |   25 ++++++++++++
  fs/squashfs/super.c       |    8 +---
  fs/squashfs/symlink.c     |   10 +++++
  6 files changed, 135 insertions(+), 16 deletions(-)

diff --git a/fs/squashfs/inode.c b/fs/squashfs/inode.c
index 49daaf6..2507011 100644
--- a/fs/squashfs/inode.c
+++ b/fs/squashfs/inode.c
@@ -40,6 +40,7 @@

  #include <linux/fs.h>
  #include <linux/vfs.h>
+#include <linux/xattr.h>

  #include "squashfs_fs.h"
  #include "squashfs_fs_sb.h"
@@ -111,6 +112,7 @@ int squashfs_read_inode(struct inode *inode, long long ino)
  	int err, type, offset = SQUASHFS_INODE_OFFSET(ino);
  	union squashfs_inode squashfs_ino;
  	struct squashfs_base_inode *sqshb_ino = &squashfs_ino.base;
+	int xattr_id = SQUASHFS_INVALID_XATTR;

  	TRACE("Entered squashfs_read_inode\n");

@@ -199,8 +201,10 @@ int squashfs_read_inode(struct inode *inode, long long ino)
  			frag_offset = 0;
  		}

+		xattr_id = le32_to_cpu(sqsh_ino->xattr);
  		inode->i_nlink = le32_to_cpu(sqsh_ino->nlink);
  		inode->i_size = le64_to_cpu(sqsh_ino->file_size);
+		inode->i_op = &squashfs_inode_ops;
  		inode->i_fop = &generic_ro_fops;
  		inode->i_mode |= S_IFREG;
  		inode->i_blocks = ((inode->i_size -
@@ -251,6 +255,7 @@ int squashfs_read_inode(struct inode *inode, long long ino)
  		if (err < 0)
  			goto failed_read;

+		xattr_id = le32_to_cpu(sqsh_ino->xattr);
  		inode->i_nlink = le32_to_cpu(sqsh_ino->nlink);
  		inode->i_size = le32_to_cpu(sqsh_ino->file_size);
  		inode->i_op = &squashfs_dir_inode_ops;
@@ -280,21 +285,33 @@ int squashfs_read_inode(struct inode *inode, long long ino)

  		inode->i_nlink = le32_to_cpu(sqsh_ino->nlink);
  		inode->i_size = le32_to_cpu(sqsh_ino->symlink_size);
-		inode->i_op = &page_symlink_inode_operations;
+		inode->i_op = &squashfs_symlink_inode_ops;
  		inode->i_data.a_ops = &squashfs_symlink_aops;
  		inode->i_mode |= S_IFLNK;
  		squashfs_i(inode)->start = block;
  		squashfs_i(inode)->offset = offset;

+		if (type == SQUASHFS_LSYMLINK_TYPE) {
+			__le32 xattr;
+
+			err = squashfs_read_metadata(sb, NULL, &block,
+						&offset, inode->i_size);
+			if (err < 0)
+				goto failed_read;
+			err = squashfs_read_metadata(sb, &xattr, &block,
+						&offset, sizeof(xattr));
+			if (err < 0)
+				goto failed_read;
+			xattr_id = le32_to_cpu(xattr);
+		}
+
  		TRACE("Symbolic link inode %x:%x, start_block %llx, offset "
  				"%x\n", SQUASHFS_INODE_BLK(ino), offset,
  				block, offset);
  		break;
  	}
  	case SQUASHFS_BLKDEV_TYPE:
-	case SQUASHFS_CHRDEV_TYPE:
-	case SQUASHFS_LBLKDEV_TYPE:
-	case SQUASHFS_LCHRDEV_TYPE: {
+	case SQUASHFS_CHRDEV_TYPE: {
  		struct squashfs_dev_inode *sqsh_ino = &squashfs_ino.dev;
  		unsigned int rdev;

@@ -315,10 +332,32 @@ int squashfs_read_inode(struct inode *inode, long long ino)
  				SQUASHFS_INODE_BLK(ino), offset, rdev);
  		break;
  	}
+	case SQUASHFS_LBLKDEV_TYPE:
+	case SQUASHFS_LCHRDEV_TYPE: {
+		struct squashfs_ldev_inode *sqsh_ino = &squashfs_ino.ldev;
+		unsigned int rdev;
+
+		err = squashfs_read_metadata(sb, sqsh_ino, &block, &offset,
+				sizeof(*sqsh_ino));
+		if (err < 0)
+			goto failed_read;
+
+		if (type == SQUASHFS_LCHRDEV_TYPE)
+			inode->i_mode |= S_IFCHR;
+		else
+			inode->i_mode |= S_IFBLK;
+		xattr_id = le32_to_cpu(sqsh_ino->xattr);
+		inode->i_op = &squashfs_inode_ops;
+		inode->i_nlink = le32_to_cpu(sqsh_ino->nlink);
+		rdev = le32_to_cpu(sqsh_ino->rdev);
+		init_special_inode(inode, inode->i_mode, new_decode_dev(rdev));
+
+		TRACE("Device inode %x:%x, rdev %x\n",
+				SQUASHFS_INODE_BLK(ino), offset, rdev);
+		break;
+	}
  	case SQUASHFS_FIFO_TYPE:
-	case SQUASHFS_SOCKET_TYPE:
-	case SQUASHFS_LFIFO_TYPE:
-	case SQUASHFS_LSOCKET_TYPE: {
+	case SQUASHFS_SOCKET_TYPE: {
  		struct squashfs_ipc_inode *sqsh_ino = &squashfs_ino.ipc;

  		err = squashfs_read_metadata(sb, sqsh_ino, &block, &offset,
@@ -334,14 +373,52 @@ int squashfs_read_inode(struct inode *inode, long long ino)
  		init_special_inode(inode, inode->i_mode, 0);
  		break;
  	}
+	case SQUASHFS_LFIFO_TYPE:
+	case SQUASHFS_LSOCKET_TYPE: {
+		struct squashfs_lipc_inode *sqsh_ino = &squashfs_ino.lipc;
+
+		err = squashfs_read_metadata(sb, sqsh_ino, &block, &offset,
+				sizeof(*sqsh_ino));
+		if (err < 0)
+			goto failed_read;
+
+		if (type == SQUASHFS_LFIFO_TYPE)
+			inode->i_mode |= S_IFIFO;
+		else
+			inode->i_mode |= S_IFSOCK;
+		xattr_id = le32_to_cpu(sqsh_ino->xattr);
+		inode->i_op = &squashfs_inode_ops;
+		inode->i_nlink = le32_to_cpu(sqsh_ino->nlink);
+		init_special_inode(inode, inode->i_mode, 0);
+		break;
+	}
  	default:
  		ERROR("Unknown inode type %d in squashfs_iget!\n", type);
  		return -EINVAL;
  	}

+	if (xattr_id != SQUASHFS_INVALID_XATTR && msblk->xattr_id_table) {
+		err = squashfs_xattr_lookup(sb, xattr_id,
+					&squashfs_i(inode)->xattr_count,
+					&squashfs_i(inode)->xattr_size,
+					&squashfs_i(inode)->xattr);
+		if (err < 0)
+			goto failed_read;
+		inode->i_blocks += ((squashfs_i(inode)->xattr_size - 1) >> 9)
+				+ 1;
+	} else
+		squashfs_i(inode)->xattr_count = 0;
+
  	return 0;

  failed_read:
  	ERROR("Unable to read inode 0x%llx\n", ino);
  	return err;
  }
+
+
+const struct inode_operations squashfs_inode_ops = {
+	.getxattr = generic_getxattr,
+	.listxattr = squashfs_listxattr
+};
+
diff --git a/fs/squashfs/namei.c b/fs/squashfs/namei.c
index 5266bd8..32f5b54 100644
--- a/fs/squashfs/namei.c
+++ b/fs/squashfs/namei.c
@@ -57,6 +57,7 @@
  #include <linux/slab.h>
  #include <linux/string.h>
  #include <linux/dcache.h>
+#include <linux/xattr.h>

  #include "squashfs_fs.h"
  #include "squashfs_fs_sb.h"
@@ -237,5 +238,7 @@ failed:


  const struct inode_operations squashfs_dir_inode_ops = {
-	.lookup = squashfs_lookup
+	.lookup = squashfs_lookup,
+	.getxattr = generic_getxattr,
+	.listxattr = squashfs_listxattr
  };
diff --git a/fs/squashfs/squashfs.h b/fs/squashfs/squashfs.h
index 133befe..7d23810 100644
--- a/fs/squashfs/squashfs.h
+++ b/fs/squashfs/squashfs.h
@@ -73,6 +73,9 @@ extern struct inode *squashfs_iget(struct super_block *, long long,
  				unsigned int);
  extern int squashfs_read_inode(struct inode *, long long);

+/* xattr.c */
+extern ssize_t squashfs_listxattr(struct dentry *, char *, size_t);
+
  /* xattr_id.c */
  extern int squashfs_xattr_lookup(struct super_block *, unsigned int, int *,
  				int *, long long *);
@@ -80,7 +83,7 @@ extern __le64 *squashfs_read_xattr_id_table(struct super_block *, u64,
  				u64 *, int *);

  /*
- * Inodes, files and decompressor operations
+ * Inodes, files,  decompressor and xattr operations
   */

  /* dir.c */
@@ -92,11 +95,18 @@ extern const struct export_operations squashfs_export_ops;
  /* file.c */
  extern const struct address_space_operations squashfs_aops;

+/* inode.c */
+extern const struct inode_operations squashfs_inode_ops;
+
  /* namei.c */
  extern const struct inode_operations squashfs_dir_inode_ops;

  /* symlink.c */
  extern const struct address_space_operations squashfs_symlink_aops;
+extern const struct inode_operations squashfs_symlink_inode_ops;
+
+/* xattr.c */
+extern struct xattr_handler *squashfs_xattr_handlers[];

  /* zlib_wrapper.c */
  extern const struct squashfs_decompressor squashfs_zlib_comp_ops;
diff --git a/fs/squashfs/squashfs_fs.h b/fs/squashfs/squashfs_fs.h
index 6fe940c..8eabb80 100644
--- a/fs/squashfs/squashfs_fs.h
+++ b/fs/squashfs/squashfs_fs.h
@@ -287,6 +287,17 @@ struct squashfs_ipc_inode {
  	__le32			nlink;
  };

+struct squashfs_lipc_inode {
+	__le16			inode_type;
+	__le16			mode;
+	__le16			uid;
+	__le16			guid;
+	__le32			mtime;
+	__le32	 		inode_number;
+	__le32			nlink;
+	__le32			xattr;
+};
+
  struct squashfs_dev_inode {
  	__le16			inode_type;
  	__le16			mode;
@@ -298,6 +309,18 @@ struct squashfs_dev_inode {
  	__le32			rdev;
  };

+struct squashfs_ldev_inode {
+	__le16			inode_type;
+	__le16			mode;
+	__le16			uid;
+	__le16			guid;
+	__le32			mtime;
+	__le32	 		inode_number;
+	__le32			nlink;
+	__le32			rdev;
+	__le32			xattr;
+};
+
  struct squashfs_symlink_inode {
  	__le16			inode_type;
  	__le16			mode;
@@ -375,12 +398,14 @@ struct squashfs_ldir_inode {
  union squashfs_inode {
  	struct squashfs_base_inode		base;
  	struct squashfs_dev_inode		dev;
+	struct squashfs_ldev_inode		ldev;
  	struct squashfs_symlink_inode		symlink;
  	struct squashfs_reg_inode		reg;
  	struct squashfs_lreg_inode		lreg;
  	struct squashfs_dir_inode		dir;
  	struct squashfs_ldir_inode		ldir;
  	struct squashfs_ipc_inode		ipc;
+	struct squashfs_lipc_inode		lipc;
  };

  struct squashfs_dir_entry {
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index c4dfc39..b6425ac 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -140,13 +140,6 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
  	if (msblk->decompressor == NULL)
  		goto failed_mount;

-	/*
-	 * Check if there's xattrs in the filesystem.  These are not
-	 * supported in this version, so warn that they will be ignored.
-	 */
-	if (le64_to_cpu(sblk->xattr_id_table_start) != SQUASHFS_INVALID_BLK)
-		ERROR("Xattrs in filesystem, these will be ignored\n");
-
  	/* Check the filesystem does not extend beyond the end of the
  	   block device */
  	msblk->bytes_used = le64_to_cpu(sblk->bytes_used);
@@ -268,6 +261,7 @@ allocate_lookup_table:
  	sb->s_export_op = &squashfs_export_ops;

  allocate_xattr_table:
+	sb->s_xattr = squashfs_xattr_handlers;
  	xattr_id_table_start = le64_to_cpu(sblk->xattr_id_table_start);
  	if (xattr_id_table_start == SQUASHFS_INVALID_BLK)
  		goto allocate_root;
diff --git a/fs/squashfs/symlink.c b/fs/squashfs/symlink.c
index 32b911f..a7ee68a 100644
--- a/fs/squashfs/symlink.c
+++ b/fs/squashfs/symlink.c
@@ -35,6 +35,7 @@
  #include <linux/kernel.h>
  #include <linux/string.h>
  #include <linux/pagemap.h>
+#include <linux/xattr.h>

  #include "squashfs_fs.h"
  #include "squashfs_fs_sb.h"
@@ -114,3 +115,12 @@ error_out:
  const struct address_space_operations squashfs_symlink_aops = {
  	.readpage = squashfs_symlink_readpage
  };
+
+const struct inode_operations squashfs_symlink_inode_ops = {
+	.readlink = generic_readlink,
+	.follow_link = page_follow_link_light,
+	.put_link = page_put_link,
+	.getxattr = generic_getxattr,
+	.listxattr = squashfs_listxattr
+};
+
-- 
1.6.3.3

