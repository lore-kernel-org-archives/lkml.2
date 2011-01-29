Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab1A2TIg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 14:08:36 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:46732 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab1A2TIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 14:08:34 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V26 01/16] exportfs: Return the minimum required handle size
Date: Sun, 30 Jan 2011 00:38:04 +0530
Message-Id: <1296328099-23263-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296328099-23263-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1296328099-23263-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The exportfs encode handle function should return the minimum required
handle size. This helps user to find out the handle size by passing 0
handle size in the first step and then redoing to the call again with
the returned handle size value.

Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/btrfs/export.c             |    8 ++++++--
 fs/exportfs/expfs.c           |    9 +++++++--
 fs/fat/inode.c                |    4 +++-
 fs/fuse/inode.c               |    4 +++-
 fs/gfs2/export.c              |    8 ++++++--
 fs/isofs/export.c             |    8 ++++++--
 fs/ocfs2/export.c             |    8 ++++++--
 fs/reiserfs/inode.c           |    7 ++++++-
 fs/udf/namei.c                |    7 ++++++-
 fs/xfs/linux-2.6/xfs_export.c |    4 +++-
 include/linux/exportfs.h      |    6 ++++--
 mm/shmem.c                    |    4 +++-
 12 files changed, 59 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 9786963..6ee1d94 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -21,9 +21,13 @@ static int btrfs_encode_fh(struct dentry *dentry, u32 *fh, int *max_len,
 	int len = *max_len;
 	int type;
 
-	if ((len < BTRFS_FID_SIZE_NON_CONNECTABLE) ||
-	    (connectable && len < BTRFS_FID_SIZE_CONNECTABLE))
+	if (connectable && (len < BTRFS_FID_SIZE_CONNECTABLE)) {
+		*max_len = BTRFS_FID_SIZE_CONNECTABLE;
 		return 255;
+	} else if (len < BTRFS_FID_SIZE_NON_CONNECTABLE) {
+		*max_len = BTRFS_FID_SIZE_NON_CONNECTABLE;
+		return 255;
+	}
 
 	len  = BTRFS_FID_SIZE_NON_CONNECTABLE;
 	type = FILEID_BTRFS_WITHOUT_PARENT;
diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index 4b68257..cfe5573 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -320,9 +320,14 @@ static int export_encode_fh(struct dentry *dentry, struct fid *fid,
 	struct inode * inode = dentry->d_inode;
 	int len = *max_len;
 	int type = FILEID_INO32_GEN;
-	
-	if (len < 2 || (connectable && len < 4))
+
+	if (connectable && (len < 4)) {
+		*max_len = 4;
+		return 255;
+	} else if (len < 2) {
+		*max_len = 2;
 		return 255;
+	}
 
 	len = 2;
 	fid->i32.ino = inode->i_ino;
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 86753fe..0e277ec 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -757,8 +757,10 @@ fat_encode_fh(struct dentry *de, __u32 *fh, int *lenp, int connectable)
 	struct inode *inode =  de->d_inode;
 	u32 ipos_h, ipos_m, ipos_l;
 
-	if (len < 5)
+	if (len < 5) {
+		*lenp = 5;
 		return 255; /* no room */
+	}
 
 	ipos_h = MSDOS_I(inode)->i_pos >> 8;
 	ipos_m = (MSDOS_I(inode)->i_pos & 0xf0) << 24;
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 9e3f68c..051b1a0 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -637,8 +637,10 @@ static int fuse_encode_fh(struct dentry *dentry, u32 *fh, int *max_len,
 	u64 nodeid;
 	u32 generation;
 
-	if (*max_len < len)
+	if (*max_len < len) {
+		*max_len = len;
 		return  255;
+	}
 
 	nodeid = get_fuse_inode(inode)->nodeid;
 	generation = inode->i_generation;
diff --git a/fs/gfs2/export.c b/fs/gfs2/export.c
index 9023db8..b5a5e60 100644
--- a/fs/gfs2/export.c
+++ b/fs/gfs2/export.c
@@ -36,9 +36,13 @@ static int gfs2_encode_fh(struct dentry *dentry, __u32 *p, int *len,
 	struct super_block *sb = inode->i_sb;
 	struct gfs2_inode *ip = GFS2_I(inode);
 
-	if (*len < GFS2_SMALL_FH_SIZE ||
-	    (connectable && *len < GFS2_LARGE_FH_SIZE))
+	if (connectable && (*len < GFS2_LARGE_FH_SIZE)) {
+		*len = GFS2_LARGE_FH_SIZE;
 		return 255;
+	} else if (*len < GFS2_SMALL_FH_SIZE) {
+		*len = GFS2_SMALL_FH_SIZE;
+		return 255;
+	}
 
 	fh[0] = cpu_to_be32(ip->i_no_formal_ino >> 32);
 	fh[1] = cpu_to_be32(ip->i_no_formal_ino & 0xFFFFFFFF);
diff --git a/fs/isofs/export.c b/fs/isofs/export.c
index ed752cb..dd4687f 100644
--- a/fs/isofs/export.c
+++ b/fs/isofs/export.c
@@ -124,9 +124,13 @@ isofs_export_encode_fh(struct dentry *dentry,
 	 * offset of the inode and the upper 16 bits of fh32[1] to
 	 * hold the offset of the parent.
 	 */
-
-	if (len < 3 || (connectable && len < 5))
+	if (connectable && (len < 5)) {
+		*max_len = 5;
+		return 255;
+	} else if (len < 3) {
+		*max_len = 3;
 		return 255;
+	}
 
 	len = 3;
 	fh32[0] = ei->i_iget5_block;
diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index 5dbc306..254652a 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -197,8 +197,12 @@ static int ocfs2_encode_fh(struct dentry *dentry, u32 *fh_in, int *max_len,
 		   dentry->d_name.len, dentry->d_name.name,
 		   fh, len, connectable);
 
-	if (len < 3 || (connectable && len < 6)) {
-		mlog(ML_ERROR, "fh buffer is too small for encoding\n");
+	if (connectable && (len < 6)) {
+		*max_len = 6;
+		type = 255;
+		goto bail;
+	} else if (len < 3) {
+		*max_len = 3;
 		type = 255;
 		goto bail;
 	}
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 0bae036..1bba24b 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -1593,8 +1593,13 @@ int reiserfs_encode_fh(struct dentry *dentry, __u32 * data, int *lenp,
 	struct inode *inode = dentry->d_inode;
 	int maxlen = *lenp;
 
-	if (maxlen < 3)
+	if (need_parent && (maxlen < 5)) {
+		*lenp = 5;
 		return 255;
+	} else if (maxlen < 3) {
+		*lenp = 3;
+		return 255;
+	}
 
 	data[0] = inode->i_ino;
 	data[1] = le32_to_cpu(INODE_PKEY(inode)->k_dir_id);
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 2be0f9e..076aef6 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1287,8 +1287,13 @@ static int udf_encode_fh(struct dentry *de, __u32 *fh, int *lenp,
 	struct fid *fid = (struct fid *)fh;
 	int type = FILEID_UDF_WITHOUT_PARENT;
 
-	if (len < 3 || (connectable && len < 5))
+	if (connectable && (len < 5)) {
+		*lenp = 5;
+		return 255;
+	} else if (len < 3) {
+		*lenp = 3;
 		return 255;
+	}
 
 	*lenp = 3;
 	fid->udf.block = location.logicalBlockNum;
diff --git a/fs/xfs/linux-2.6/xfs_export.c b/fs/xfs/linux-2.6/xfs_export.c
index fc0114d..f4f878f 100644
--- a/fs/xfs/linux-2.6/xfs_export.c
+++ b/fs/xfs/linux-2.6/xfs_export.c
@@ -89,8 +89,10 @@ xfs_fs_encode_fh(
 	 * seven combinations work.  The real answer is "don't use v2".
 	 */
 	len = xfs_fileid_length(fileid_type);
-	if (*max_len < len)
+	if (*max_len < len) {
+		*max_len = len;
 		return 255;
+	}
 	*max_len = len;
 
 	switch (fileid_type) {
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index 2802898..65afdfd 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -121,8 +121,10 @@ struct fid {
  *    set, the encode_fh() should store sufficient information so that a good
  *    attempt can be made to find not only the file but also it's place in the
  *    filesystem.   This typically means storing a reference to de->d_parent in
- *    the filehandle fragment.  encode_fh() should return the number of bytes
- *    stored or a negative error code such as %-ENOSPC
+ *    the filehandle fragment.  encode_fh() should return the fileid_type on
+ *    success and on error returns 255 (if the space needed to encode fh is
+ *    greater than @max_len*4 bytes). On error @max_len contains the minimum
+ *    size(in 4 byte unit) needed to encode the file handle.
  *
  * fh_to_dentry:
  *    @fh_to_dentry is given a &struct super_block (@sb) and a file handle
diff --git a/mm/shmem.c b/mm/shmem.c
index 5ee67c9..3437b65 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2144,8 +2144,10 @@ static int shmem_encode_fh(struct dentry *dentry, __u32 *fh, int *len,
 {
 	struct inode *inode = dentry->d_inode;
 
-	if (*len < 3)
+	if (*len < 3) {
+		*len = 3;
 		return 255;
+	}
 
 	if (inode_unhashed(inode)) {
 		/* Unfortunately insert_inode_hash is not idempotent,
-- 
1.7.1

