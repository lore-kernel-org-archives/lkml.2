Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab2JHDdE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 23:33:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36353 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab2JHDdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 23:33:00 -0400
Date: Sun, 7 Oct 2012 20:32:51 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Sasha Levin <levinsasha928@gmail.com>
cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Jones <davej@redhat.com>,
        Sage Weil <sage@inktank.com>, Steven Whitehouse <swhiteho@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: vfs: oops on open_by_handle_at() in linux-next
In-Reply-To: <5071837C.30208@gmail.com>
Message-ID: <alpine.LSU.2.00.1210072027370.11615@eggly.anvils>
References: <5071837C.30208@gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Oct 2012, Sasha Levin wrote:
> 
> While fuzzing with trinity inside a KVM tools guest using latest linux-next, I've stumbled on the following:
> 
> [   74.082463] BUG: unable to handle kernel paging request at ffff880061cd3000
> [   74.087481] IP: [<ffffffff812190d0>] shmem_alloc_inode+0x40/0x40
> [   74.090032] PGD 4e27063 PUD 1fb7b067 PMD 1fc8a067 PTE 8000000061cd3160
> [   74.090032] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [   74.090032] Dumping ftrace buffer:
> [   74.090032]    (ftrace buffer empty)
> [   74.090032] CPU 1
> [   74.090032] Pid: 7234, comm: trinity-child40 Tainted: G        W    3.6.0-next-20121005-sasha-00001-g1eae105-dirty #34
> [   74.090032] RIP: 0010:[<ffffffff812190d0>]  [<ffffffff812190d0>] shmem_alloc_inode+0x40/0x40
> [   74.109655] RSP: 0018:ffff8800268efd90  EFLAGS: 00010282
> [   74.109655] RAX: ffffffff812190d0 RBX: ffff8800663d8a20 RCX: 0000000000000000
> [   74.109655] RDX: 0000000000000001 RSI: ffff880061cd2ff8 RDI: ffff8800332a9000
> [   74.109655] RBP: ffff8800268efef8 R08: ffffffff812d7450 R09: 0000000000000000
> [   74.109655] R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff83c48340
> [   74.109655] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
> [   74.127365] ircomm_tty_close()
> [   74.127345] FS:  00007fbf37c56700(0000) GS:ffff880033600000(0000) knlGS:0000000000000000
> [   74.127345] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   74.127345] CR2: ffff880061cd3000 CR3: 00000000262c4000 CR4: 00000000000406e0
> [   74.127345] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   74.127345] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   74.127345] Process trinity-child40 (pid: 7234, threadinfo ffff8800268ee000, task ffff880026208000)
> [   74.127345] Stack:
> [   74.127345]  ffffffff81488649 ffffffff85f2e7b0 0000000000000000 ffffffff812d7450
> [   74.127345]  ffff880061cd2ff8 ffff8800268efdc8 ffffffff8117a23e ffff8800268efde8
> [   74.127345]  ffffffff8117ac46 ffff8800261d1108 ffff880026208000 ffff8800268efe88
> [   74.127345] Call Trace:
> [   74.127345]  [<ffffffff81488649>] ? exportfs_decode_fh+0x79/0x2d0
> [   74.127345]  [<ffffffff812d7450>] ? dump_seek+0xf0/0xf0
> [   74.127345]  [<ffffffff8117a23e>] ? put_lock_stats.isra.16+0xe/0x40
> [   74.127345]  [<ffffffff8117ac46>] ? lock_release_holdtime+0x126/0x140
> [   74.127345]  [<ffffffff8117fbfe>] ? lock_release_non_nested+0xde/0x310
> [   74.127345]  [<ffffffff83a5d914>] ? _raw_spin_unlock_irqrestore+0x84/0xb0
> [   74.127345]  [<ffffffff812d77c3>] do_handle_open+0x163/0x2c0
> [   74.127345]  [<ffffffff812d792c>] sys_open_by_handle_at+0xc/0x10
> [   74.127345]  [<ffffffff83a5f3f8>] tracesys+0xe1/0xe6
> [   74.127345] Code: 48 85 c0 74 0e 48 05 78 01 00 00 eb 0e 66 0f 1f 44 00 00 31 c0 66 0f 1f 44 00 00 5d c3 66 66 66 66 66 2e 0f
> 1f 84 00 00 00 00 00 <8b> 46 08 48 89 f1 8b 76 04 48 c1 e0 20 48 09 f0 83 fa 02 7e 46
> [   74.127345] RIP  [<ffffffff812190d0>] shmem_alloc_inode+0x40/0x40
> [   74.127345]  RSP <ffff8800268efd90>
> [   74.127345] CR2: ffff880061cd3000
> [   74.127345] ---[ end trace 60d7f664788c4cb8 ]---
> 
> 
> 
>  # addr2line -i -e vmlinux ffffffff812d792c
> /usr/src/linux/fs/fhandle.c:265
>  # addr2line -i -e vmlinux ffffffff812d77c3
> /usr/src/linux/fs/fhandle.c:155
> /usr/src/linux/fs/fhandle.c:205
> /usr/src/linux/fs/fhandle.c:221
>  # addr2line -i -e vmlinux ffffffff81488649
> /usr/src/linux/fs/exportfs/expfs.c:385
>  # addr2line -i -e vmlinux ffffffff812190d0
> /usr/src/linux/mm/shmem.c:2224

Thank you, Sasha: this should fix it, and similar in other FSes.


[PATCH] tmpfs,ceph,gfs2,isofs,reiserfs,xfs: fix fh_len checking

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
Cc: stable@vger.kernel.org
---

 fs/ceph/export.c    |   18 ++++++++++++++----
 fs/gfs2/export.c    |    4 ++++
 fs/isofs/export.c   |    2 +-
 fs/reiserfs/inode.c |    6 +++++-
 fs/xfs/xfs_export.c |    3 +++
 mm/shmem.c          |    6 ++++--
 6 files changed, 31 insertions(+), 8 deletions(-)

--- 3.6.0/fs/ceph/export.c	2012-07-21 13:58:29.000000000 -0700
+++ linux/fs/ceph/export.c	2012-10-07 17:52:50.846051082 -0700
@@ -99,7 +99,7 @@ static int ceph_encode_fh(struct inode *
  * FIXME: we should try harder by querying the mds for the ino.
  */
 static struct dentry *__fh_to_dentry(struct super_block *sb,
-				     struct ceph_nfs_fh *fh)
+				     struct ceph_nfs_fh *fh, int fh_len)
 {
 	struct ceph_mds_client *mdsc = ceph_sb_to_client(sb)->mdsc;
 	struct inode *inode;
@@ -107,6 +107,9 @@ static struct dentry *__fh_to_dentry(str
 	struct ceph_vino vino;
 	int err;
 
+	if (fh_len < sizeof(*fh) / 4)
+		return ERR_PTR(-ESTALE);
+
 	dout("__fh_to_dentry %llx\n", fh->ino);
 	vino.ino = fh->ino;
 	vino.snap = CEPH_NOSNAP;
@@ -150,7 +153,7 @@ static struct dentry *__fh_to_dentry(str
  * convert connectable fh to dentry
  */
 static struct dentry *__cfh_to_dentry(struct super_block *sb,
-				      struct ceph_nfs_confh *cfh)
+				      struct ceph_nfs_confh *cfh, int fh_len)
 {
 	struct ceph_mds_client *mdsc = ceph_sb_to_client(sb)->mdsc;
 	struct inode *inode;
@@ -158,6 +161,9 @@ static struct dentry *__cfh_to_dentry(st
 	struct ceph_vino vino;
 	int err;
 
+	if (fh_len < sizeof(*cfh) / 4)
+		return ERR_PTR(-ESTALE);
+
 	dout("__cfh_to_dentry %llx (%llx/%x)\n",
 	     cfh->ino, cfh->parent_ino, cfh->parent_name_hash);
 
@@ -207,9 +213,11 @@ static struct dentry *ceph_fh_to_dentry(
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
@@ -230,6 +238,8 @@ static struct dentry *ceph_fh_to_parent(
 
 	if (fh_type == 1)
 		return ERR_PTR(-ESTALE);
+	if (fh_len < sizeof(*cfh) / 4)
+		return ERR_PTR(-ESTALE);
 
 	pr_debug("fh_to_parent %llx/%d\n", cfh->parent_ino,
 		 cfh->parent_name_hash);
--- 3.6.0/fs/gfs2/export.c	2012-07-21 13:58:29.000000000 -0700
+++ linux/fs/gfs2/export.c	2012-10-07 17:57:53.802069983 -0700
@@ -161,6 +161,8 @@ static struct dentry *gfs2_fh_to_dentry(
 	case GFS2_SMALL_FH_SIZE:
 	case GFS2_LARGE_FH_SIZE:
 	case GFS2_OLD_FH_SIZE:
+		if (fh_len < GFS2_SMALL_FH_SIZE)
+			return NULL;
 		this.no_formal_ino = ((u64)be32_to_cpu(fh[0])) << 32;
 		this.no_formal_ino |= be32_to_cpu(fh[1]);
 		this.no_addr = ((u64)be32_to_cpu(fh[2])) << 32;
@@ -180,6 +182,8 @@ static struct dentry *gfs2_fh_to_parent(
 	switch (fh_type) {
 	case GFS2_LARGE_FH_SIZE:
 	case GFS2_OLD_FH_SIZE:
+		if (fh_len < GFS2_LARGE_FH_SIZE)
+			return NULL;
 		parent.no_formal_ino = ((u64)be32_to_cpu(fh[4])) << 32;
 		parent.no_formal_ino |= be32_to_cpu(fh[5]);
 		parent.no_addr = ((u64)be32_to_cpu(fh[6])) << 32;
--- 3.6.0/fs/isofs/export.c	2012-09-30 16:47:46.000000000 -0700
+++ linux/fs/isofs/export.c	2012-10-07 18:02:09.714088416 -0700
@@ -175,7 +175,7 @@ static struct dentry *isofs_fh_to_parent
 {
 	struct isofs_fid *ifid = (struct isofs_fid *)fid;
 
-	if (fh_type != 2)
+	if (fh_len < 2 || fh_type != 2)
 		return NULL;
 
 	return isofs_export_iget(sb,
--- 3.6.0/fs/reiserfs/inode.c	2012-09-30 16:47:46.000000000 -0700
+++ linux/fs/reiserfs/inode.c	2012-10-07 19:30:45.170414925 -0700
@@ -1573,8 +1573,10 @@ struct dentry *reiserfs_fh_to_dentry(str
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
@@ -1583,6 +1585,8 @@ struct dentry *reiserfs_fh_to_dentry(str
 struct dentry *reiserfs_fh_to_parent(struct super_block *sb, struct fid *fid,
 		int fh_len, int fh_type)
 {
+	if (fh_type > fh_len)
+		fh_type = fh_len;
 	if (fh_type < 4)
 		return NULL;
 
--- 3.6.0/fs/xfs/xfs_export.c	2012-07-21 13:58:29.000000000 -0700
+++ linux/fs/xfs/xfs_export.c	2012-10-07 18:25:02.238174209 -0700
@@ -189,6 +189,9 @@ xfs_fs_fh_to_parent(struct super_block *
 	struct xfs_fid64	*fid64 = (struct xfs_fid64 *)fid;
 	struct inode		*inode = NULL;
 
+	if (fh_len < xfs_fileid_length(fileid_type))
+		return NULL;
+
 	switch (fileid_type) {
 	case FILEID_INO32_GEN_PARENT:
 		inode = xfs_nfs_get_inode(sb, fid->i32.parent_ino,
--- 3.6.0/mm/shmem.c	2012-09-30 16:47:46.000000000 -0700
+++ linux/mm/shmem.c	2012-10-07 17:31:03.389958965 -0700
@@ -2366,12 +2366,14 @@ static struct dentry *shmem_fh_to_dentry
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
