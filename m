Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab2KZSJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:09:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47322 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189Ab2KZRDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:03:45 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Sage Weil <sage@inktank.com>, Steven Whitehouse <swhiteho@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 063/270] tmpfs,ceph,gfs2,isofs,reiserfs,xfs: fix fh_len checking
Date: Mon, 26 Nov 2012 14:55:53 -0200
Message-Id: <1353949160-26803-64-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

commit 35c2a7f4908d404c9124c2efc6ada4640ca4d5d5 upstream.

Fuzzing with trinity oopsed on the 1st instruction of shmem_fh_to_dentry(),
	u64 inum = fid->raw[2];
which is unhelpfully reported as at the end of shmem_alloc_inode():

BUG: unable to handle kernel paging request at ffff880061cd3000
IP: [<ffffffff812190d0>] shmem_alloc_inode+0x40/0x40
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Call Trace:
 [<ffffffff81488649>] ? exportfs_decode_fh+0x79/0x2d0
 [<ffffffff812d77c3>] do_handle_open+0x163/0x2c0
 [<ffffffff812d792c>] sys_open_by_handle_at+0xc/0x10
 [<ffffffff83a5f3f8>] tracesys+0xe1/0xe6

Right, tmpfs is being stupid to access fid->raw[2] before validating that
fh_len includes it: the buffer kmalloc'ed by do_sys_name_to_handle() may
fall at the end of a page, and the next page not be present.

But some other filesystems (ceph, gfs2, isofs, reiserfs, xfs) are being
careless about fh_len too, in fh_to_dentry() and/or fh_to_parent(), and
could oops in the same way: add the missing fh_len checks to those.

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Sage Weil <sage@inktank.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/ceph/export.c    |   18 ++++++++++++++----
 fs/gfs2/export.c    |    4 ++++
 fs/isofs/export.c   |    2 +-
 fs/reiserfs/inode.c |    6 +++++-
 fs/xfs/xfs_export.c |    3 +++
 mm/shmem.c          |    6 ++++--
 6 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index 8e1b60e..02ce909 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -99,7 +99,7 @@ static int ceph_encode_fh(struct inode *inode, u32 *rawfh, int *max_len,
  * FIXME: we should try harder by querying the mds for the ino.
  */
 static struct dentry *__fh_to_dentry(struct super_block *sb,
-				     struct ceph_nfs_fh *fh)
+				     struct ceph_nfs_fh *fh, int fh_len)
 {
 	struct ceph_mds_client *mdsc = ceph_sb_to_client(sb)->mdsc;
 	struct inode *inode;
@@ -107,6 +107,9 @@ static struct dentry *__fh_to_dentry(struct super_block *sb,
 	struct ceph_vino vino;
 	int err;
 
+	if (fh_len < sizeof(*fh) / 4)
+		return ERR_PTR(-ESTALE);
+
 	dout("__fh_to_dentry %llx\n", fh->ino);
 	vino.ino = fh->ino;
 	vino.snap = CEPH_NOSNAP;
@@ -150,7 +153,7 @@ static struct dentry *__fh_to_dentry(struct super_block *sb,
  * convert connectable fh to dentry
  */
 static struct dentry *__cfh_to_dentry(struct super_block *sb,
-				      struct ceph_nfs_confh *cfh)
+				      struct ceph_nfs_confh *cfh, int fh_len)
 {
 	struct ceph_mds_client *mdsc = ceph_sb_to_client(sb)->mdsc;
 	struct inode *inode;
@@ -158,6 +161,9 @@ static struct dentry *__cfh_to_dentry(struct super_block *sb,
 	struct ceph_vino vino;
 	int err;
 
+	if (fh_len < sizeof(*cfh) / 4)
+		return ERR_PTR(-ESTALE);
+
 	dout("__cfh_to_dentry %llx (%llx/%x)\n",
 	     cfh->ino, cfh->parent_ino, cfh->parent_name_hash);
 
@@ -207,9 +213,11 @@ static struct dentry *ceph_fh_to_dentry(struct super_block *sb, struct fid *fid,
 					int fh_len, int fh_type)
 {
 	if (fh_type == 1)
-		return __fh_to_dentry(sb, (struct ceph_nfs_fh *)fid->raw);
+		return __fh_to_dentry(sb, (struct ceph_nfs_fh *)fid->raw,
+								fh_len);
 	else
-		return __cfh_to_dentry(sb, (struct ceph_nfs_confh *)fid->raw);
+		return __cfh_to_dentry(sb, (struct ceph_nfs_confh *)fid->raw,
+								fh_len);
 }
 
 /*
@@ -230,6 +238,8 @@ static struct dentry *ceph_fh_to_parent(struct super_block *sb,
 
 	if (fh_type == 1)
 		return ERR_PTR(-ESTALE);
+	if (fh_len < sizeof(*cfh) / 4)
+		return ERR_PTR(-ESTALE);
 
 	pr_debug("fh_to_parent %llx/%d\n", cfh->parent_ino,
 		 cfh->parent_name_hash);
diff --git a/fs/gfs2/export.c b/fs/gfs2/export.c
index e8ed6d4..4767774 100644
--- a/fs/gfs2/export.c
+++ b/fs/gfs2/export.c
@@ -161,6 +161,8 @@ static struct dentry *gfs2_fh_to_dentry(struct super_block *sb, struct fid *fid,
 	case GFS2_SMALL_FH_SIZE:
 	case GFS2_LARGE_FH_SIZE:
 	case GFS2_OLD_FH_SIZE:
+		if (fh_len < GFS2_SMALL_FH_SIZE)
+			return NULL;
 		this.no_formal_ino = ((u64)be32_to_cpu(fh[0])) << 32;
 		this.no_formal_ino |= be32_to_cpu(fh[1]);
 		this.no_addr = ((u64)be32_to_cpu(fh[2])) << 32;
@@ -180,6 +182,8 @@ static struct dentry *gfs2_fh_to_parent(struct super_block *sb, struct fid *fid,
 	switch (fh_type) {
 	case GFS2_LARGE_FH_SIZE:
 	case GFS2_OLD_FH_SIZE:
+		if (fh_len < GFS2_LARGE_FH_SIZE)
+			return NULL;
 		parent.no_formal_ino = ((u64)be32_to_cpu(fh[4])) << 32;
 		parent.no_formal_ino |= be32_to_cpu(fh[5]);
 		parent.no_addr = ((u64)be32_to_cpu(fh[6])) << 32;
diff --git a/fs/isofs/export.c b/fs/isofs/export.c
index aa4356d..8cf3f97 100644
--- a/fs/isofs/export.c
+++ b/fs/isofs/export.c
@@ -174,7 +174,7 @@ static struct dentry *isofs_fh_to_parent(struct super_block *sb,
 {
 	struct isofs_fid *ifid = (struct isofs_fid *)fid;
 
-	if (fh_type != 2)
+	if (fh_len < 2 || fh_type != 2)
 		return NULL;
 
 	return isofs_export_iget(sb,
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index a6d4268..0192f86 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -1573,8 +1573,10 @@ struct dentry *reiserfs_fh_to_dentry(struct super_block *sb, struct fid *fid,
 			reiserfs_warning(sb, "reiserfs-13077",
 				"nfsd/reiserfs, fhtype=%d, len=%d - odd",
 				fh_type, fh_len);
-		fh_type = 5;
+		fh_type = fh_len;
 	}
+	if (fh_len < 2)
+		return NULL;
 
 	return reiserfs_get_dentry(sb, fid->raw[0], fid->raw[1],
 		(fh_type == 3 || fh_type >= 5) ? fid->raw[2] : 0);
@@ -1583,6 +1585,8 @@ struct dentry *reiserfs_fh_to_dentry(struct super_block *sb, struct fid *fid,
 struct dentry *reiserfs_fh_to_parent(struct super_block *sb, struct fid *fid,
 		int fh_len, int fh_type)
 {
+	if (fh_type > fh_len)
+		fh_type = fh_len;
 	if (fh_type < 4)
 		return NULL;
 
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 4267922..8c6d1d7 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -189,6 +189,9 @@ xfs_fs_fh_to_parent(struct super_block *sb, struct fid *fid,
 	struct xfs_fid64	*fid64 = (struct xfs_fid64 *)fid;
 	struct inode		*inode = NULL;
 
+	if (fh_len < xfs_fileid_length(fileid_type))
+		return NULL;
+
 	switch (fileid_type) {
 	case FILEID_INO32_GEN_PARENT:
 		inode = xfs_nfs_get_inode(sb, fid->i32.parent_ino,
diff --git a/mm/shmem.c b/mm/shmem.c
index bd10636..06d48ca 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2364,12 +2364,14 @@ static struct dentry *shmem_fh_to_dentry(struct super_block *sb,
 {
 	struct inode *inode;
 	struct dentry *dentry = NULL;
-	u64 inum = fid->raw[2];
-	inum = (inum << 32) | fid->raw[1];
+	u64 inum;
 
 	if (fh_len < 3)
 		return NULL;
 
+	inum = fid->raw[2];
+	inum = (inum << 32) | fid->raw[1];
+
 	inode = ilookup5(sb, (unsigned long)(inum + fid->raw[0]),
 			shmem_match, fid->raw);
 	if (inode) {
-- 
1.7.9.5

