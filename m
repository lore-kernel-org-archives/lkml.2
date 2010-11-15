Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab0KOPlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 10:41:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754421Ab0KOPld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 10:41:33 -0500
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 15 Nov 2010 15:41:29 +0000
Message-ID: <1289835689.2466.29.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following fix from the GFS2 -fixes tree,

Steve.
------------------------------------------------------------------------------------------------------------------


The following changes since commit 0143832cc96d0bf78486297aad5c8fb2c2ead02a:

  Merge branch 'urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6 (2010-11-13 10:00:15 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git master

Steven Whitehouse (1):
      GFS2: Fix inode deallocation race

 fs/gfs2/export.c |   46 ++---------------
 fs/gfs2/glock.c  |   21 ++++----
 fs/gfs2/inode.c  |  152 ++++++++++++-----------------------------------------
 fs/gfs2/inode.h  |    4 +-
 fs/gfs2/rgrp.c   |   91 ++++++++++++++++----------------
 5 files changed, 98 insertions(+), 216 deletions(-)

[Just noticed that git request-pull -p doesn't include the description, so adding that in here]

GFS2: Fix inode deallocation race

This area of the code has always been a bit delicate due to the
subtleties of lock ordering. The problem is that for "normal"
alloc/dealloc, we always grab the inode locks first and the rgrp lock
later.

In order to ensure no races in looking up the unlinked, but still
allocated inodes, we need to hold the rgrp lock when we do the lookup,
which means that we can't take the inode glock.

The solution is to borrow the technique already used by NFS to solve
what is essentially the same problem (given an inode number, look up
the inode carefully, checking that it really is in the expected
state).

We cannot do that directly from the allocation code (lock ordering
again) so we give the job to the pre-existing delete workqueue and
carry on with the allocation as normal.

If we find there is no space, we do a journal flush (required anyway
if space from a deallocation is to be released) which should block
against the pending deallocations, so we should always get the space
back.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>


diff --git a/fs/gfs2/export.c b/fs/gfs2/export.c
index 06d5827..5ab3839 100644
--- a/fs/gfs2/export.c
+++ b/fs/gfs2/export.c
@@ -138,10 +138,8 @@ static struct dentry *gfs2_get_dentry(struct super_block *sb,
 				      struct gfs2_inum_host *inum)
 {
 	struct gfs2_sbd *sdp = sb->s_fs_info;
-	struct gfs2_holder i_gh;
 	struct inode *inode;
 	struct dentry *dentry;
-	int error;
 
 	inode = gfs2_ilookup(sb, inum->no_addr);
 	if (inode) {
@@ -152,52 +150,16 @@ static struct dentry *gfs2_get_dentry(struct super_block *sb,
 		goto out_inode;
 	}
 
-	error = gfs2_glock_nq_num(sdp, inum->no_addr, &gfs2_inode_glops,
-				  LM_ST_SHARED, LM_FLAG_ANY, &i_gh);
-	if (error)
-		return ERR_PTR(error);
-
-	error = gfs2_check_blk_type(sdp, inum->no_addr, GFS2_BLKST_DINODE);
-	if (error)
-		goto fail;
-
-	inode = gfs2_inode_lookup(sb, DT_UNKNOWN, inum->no_addr, 0);
-	if (IS_ERR(inode)) {
-		error = PTR_ERR(inode);
-		goto fail;
-	}
-
-	error = gfs2_inode_refresh(GFS2_I(inode));
-	if (error) {
-		iput(inode);
-		goto fail;
-	}
-
-	/* Pick up the works we bypass in gfs2_inode_lookup */
-	if (inode->i_state & I_NEW) 
-		gfs2_set_iop(inode);
-
-	if (GFS2_I(inode)->i_no_formal_ino != inum->no_formal_ino) {
-		iput(inode);
-		goto fail;
-	}
-
-	error = -EIO;
-	if (GFS2_I(inode)->i_diskflags & GFS2_DIF_SYSTEM) {
-		iput(inode);
-		goto fail;
-	}
-
-	gfs2_glock_dq_uninit(&i_gh);
+	inode = gfs2_lookup_by_inum(sdp, inum->no_addr, &inum->no_formal_ino,
+				    GFS2_BLKST_DINODE);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
 
 out_inode:
 	dentry = d_obtain_alias(inode);
 	if (!IS_ERR(dentry))
 		dentry->d_op = &gfs2_dops;
 	return dentry;
-fail:
-	gfs2_glock_dq_uninit(&i_gh);
-	return ERR_PTR(error);
 }
 
 static struct dentry *gfs2_fh_to_dentry(struct super_block *sb, struct fid *fid,
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 8777885..f92c177 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -686,21 +686,20 @@ static void delete_work_func(struct work_struct *work)
 {
 	struct gfs2_glock *gl = container_of(work, struct gfs2_glock, gl_delete);
 	struct gfs2_sbd *sdp = gl->gl_sbd;
-	struct gfs2_inode *ip = NULL;
+	struct gfs2_inode *ip;
 	struct inode *inode;
-	u64 no_addr = 0;
+	u64 no_addr = gl->gl_name.ln_number;
+
+	ip = gl->gl_object;
+	/* Note: Unsafe to dereference ip as we don't hold right refs/locks */
 
-	spin_lock(&gl->gl_spin);
-	ip = (struct gfs2_inode *)gl->gl_object;
 	if (ip)
-		no_addr = ip->i_no_addr;
-	spin_unlock(&gl->gl_spin);
-	if (ip) {
 		inode = gfs2_ilookup(sdp->sd_vfs, no_addr);
-		if (inode) {
-			d_prune_aliases(inode);
-			iput(inode);
-		}
+	else
+		inode = gfs2_lookup_by_inum(sdp, no_addr, NULL, GFS2_BLKST_UNLINKED);
+	if (inode && !IS_ERR(inode)) {
+		d_prune_aliases(inode);
+		iput(inode);
 	}
 	gfs2_glock_put(gl);
 }
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 06370f8..e1213f7 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -73,49 +73,6 @@ static struct inode *gfs2_iget(struct super_block *sb, u64 no_addr)
 	return iget5_locked(sb, hash, iget_test, iget_set, &no_addr);
 }
 
-struct gfs2_skip_data {
-	u64	no_addr;
-	int	skipped;
-};
-
-static int iget_skip_test(struct inode *inode, void *opaque)
-{
-	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_skip_data *data = opaque;
-
-	if (ip->i_no_addr == data->no_addr) {
-		if (inode->i_state & (I_FREEING|I_WILL_FREE)){
-			data->skipped = 1;
-			return 0;
-		}
-		return 1;
-	}
-	return 0;
-}
-
-static int iget_skip_set(struct inode *inode, void *opaque)
-{
-	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_skip_data *data = opaque;
-
-	if (data->skipped)
-		return 1;
-	inode->i_ino = (unsigned long)(data->no_addr);
-	ip->i_no_addr = data->no_addr;
-	return 0;
-}
-
-static struct inode *gfs2_iget_skip(struct super_block *sb,
-				    u64 no_addr)
-{
-	struct gfs2_skip_data data;
-	unsigned long hash = (unsigned long)no_addr;
-
-	data.no_addr = no_addr;
-	data.skipped = 0;
-	return iget5_locked(sb, hash, iget_skip_test, iget_skip_set, &data);
-}
-
 /**
  * GFS2 lookup code fills in vfs inode contents based on info obtained
  * from directory entry inside gfs2_inode_lookup(). This has caused issues
@@ -243,93 +200,54 @@ fail:
 	return ERR_PTR(error);
 }
 
-/**
- * gfs2_process_unlinked_inode - Lookup an unlinked inode for reclamation
- *                               and try to reclaim it by doing iput.
- *
- * This function assumes no rgrp locks are currently held.
- *
- * @sb: The super block
- * no_addr: The inode number
- *
- */
-
-void gfs2_process_unlinked_inode(struct super_block *sb, u64 no_addr)
+struct inode *gfs2_lookup_by_inum(struct gfs2_sbd *sdp, u64 no_addr,
+				  u64 *no_formal_ino, unsigned int blktype)
 {
-	struct gfs2_sbd *sdp;
-	struct gfs2_inode *ip;
-	struct gfs2_glock *io_gl = NULL;
-	int error;
-	struct gfs2_holder gh;
+	struct super_block *sb = sdp->sd_vfs;
+	struct gfs2_holder i_gh;
 	struct inode *inode;
+	int error;
 
-	inode = gfs2_iget_skip(sb, no_addr);
-
-	if (!inode)
-		return;
-
-	/* If it's not a new inode, someone's using it, so leave it alone. */
-	if (!(inode->i_state & I_NEW)) {
-		iput(inode);
-		return;
-	}
-
-	ip = GFS2_I(inode);
-	sdp = GFS2_SB(inode);
-	ip->i_no_formal_ino = -1;
+	error = gfs2_glock_nq_num(sdp, no_addr, &gfs2_inode_glops,
+				  LM_ST_SHARED, LM_FLAG_ANY, &i_gh);
+	if (error)
+		return ERR_PTR(error);
 
-	error = gfs2_glock_get(sdp, no_addr, &gfs2_inode_glops, CREATE, &ip->i_gl);
-	if (unlikely(error))
+	error = gfs2_check_blk_type(sdp, no_addr, blktype);
+	if (error)
 		goto fail;
-	ip->i_gl->gl_object = ip;
 
-	error = gfs2_glock_get(sdp, no_addr, &gfs2_iopen_glops, CREATE, &io_gl);
-	if (unlikely(error))
-		goto fail_put;
-
-	set_bit(GIF_INVALID, &ip->i_flags);
-	error = gfs2_glock_nq_init(io_gl, LM_ST_SHARED, LM_FLAG_TRY | GL_EXACT,
-				   &ip->i_iopen_gh);
-	if (unlikely(error))
-		goto fail_iopen;
+	inode = gfs2_inode_lookup(sb, DT_UNKNOWN, no_addr, 0);
+	if (IS_ERR(inode))
+		goto fail;
 
-	ip->i_iopen_gh.gh_gl->gl_object = ip;
-	gfs2_glock_put(io_gl);
-	io_gl = NULL;
+	error = gfs2_inode_refresh(GFS2_I(inode));
+	if (error)
+		goto fail_iput;
 
-	inode->i_mode = DT2IF(DT_UNKNOWN);
+	/* Pick up the works we bypass in gfs2_inode_lookup */
+	if (inode->i_state & I_NEW) 
+		gfs2_set_iop(inode);
 
-	/*
-	 * We must read the inode in order to work out its type in
-	 * this case. Note that this doesn't happen often as we normally
-	 * know the type beforehand. This code path only occurs during
-	 * unlinked inode recovery (where it is safe to do this glock,
-	 * which is not true in the general case).
-	 */
-	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, LM_FLAG_TRY,
-				   &gh);
-	if (unlikely(error))
-		goto fail_glock;
+	/* Two extra checks for NFS only */
+	if (no_formal_ino) {
+		error = -ESTALE;
+		if (GFS2_I(inode)->i_no_formal_ino != *no_formal_ino)
+			goto fail_iput;
 
-	/* Inode is now uptodate */
-	gfs2_glock_dq_uninit(&gh);
-	gfs2_set_iop(inode);
+		error = -EIO;
+		if (GFS2_I(inode)->i_diskflags & GFS2_DIF_SYSTEM)
+			goto fail_iput;
 
-	/* The iput will cause it to be deleted. */
-	iput(inode);
-	return;
+		error = 0;
+	}
 
-fail_glock:
-	gfs2_glock_dq(&ip->i_iopen_gh);
-fail_iopen:
-	if (io_gl)
-		gfs2_glock_put(io_gl);
-fail_put:
-	ip->i_gl->gl_object = NULL;
-	gfs2_glock_put(ip->i_gl);
 fail:
-	iget_failed(inode);
-	return;
+	gfs2_glock_dq_uninit(&i_gh);
+	return error ? ERR_PTR(error) : inode;
+fail_iput:
+	iput(inode);
+	goto fail;
 }
 
 static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index 6720d7d..d8499fa 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -99,7 +99,9 @@ err:
 extern void gfs2_set_iop(struct inode *inode);
 extern struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned type, 
 				       u64 no_addr, u64 no_formal_ino);
-extern void gfs2_process_unlinked_inode(struct super_block *sb, u64 no_addr);
+extern struct inode *gfs2_lookup_by_inum(struct gfs2_sbd *sdp, u64 no_addr,
+					 u64 *no_formal_ino,
+					 unsigned int blktype);
 extern struct inode *gfs2_ilookup(struct super_block *sb, u64 no_addr);
 
 extern int gfs2_inode_refresh(struct gfs2_inode *ip);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index bef3ab6..33c8407 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -963,17 +963,18 @@ static int try_rgrp_fit(struct gfs2_rgrpd *rgd, struct gfs2_alloc *al)
  *          The inode, if one has been found, in inode.
  */
 
-static u64 try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked,
-			   u64 skip)
+static void try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked, u64 skip)
 {
 	u32 goal = 0, block;
 	u64 no_addr;
 	struct gfs2_sbd *sdp = rgd->rd_sbd;
 	unsigned int n;
+	struct gfs2_glock *gl;
+	struct gfs2_inode *ip;
+	int error;
+	int found = 0;
 
-	for(;;) {
-		if (goal >= rgd->rd_data)
-			break;
+	while (goal < rgd->rd_data) {
 		down_write(&sdp->sd_log_flush_lock);
 		n = 1;
 		block = rgblk_search(rgd, goal, GFS2_BLKST_UNLINKED,
@@ -990,11 +991,32 @@ static u64 try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked,
 		if (no_addr == skip)
 			continue;
 		*last_unlinked = no_addr;
-		return no_addr;
+
+		error = gfs2_glock_get(sdp, no_addr, &gfs2_inode_glops, CREATE, &gl);
+		if (error)
+			continue;
+
+		/* If the inode is already in cache, we can ignore it here
+		 * because the existing inode disposal code will deal with
+		 * it when all refs have gone away. Accessing gl_object like
+		 * this is not safe in general. Here it is ok because we do
+		 * not dereference the pointer, and we only need an approx
+		 * answer to whether it is NULL or not.
+		 */
+		ip = gl->gl_object;
+
+		if (ip || queue_work(gfs2_delete_workqueue, &gl->gl_delete) == 0)
+			gfs2_glock_put(gl);
+		else
+			found++;
+
+		/* Limit reclaim to sensible number of tasks */
+		if (found > 2*NR_CPUS)
+			return;
 	}
 
 	rgd->rd_flags &= ~GFS2_RDF_CHECK;
-	return 0;
+	return;
 }
 
 /**
@@ -1075,11 +1097,9 @@ static void forward_rgrp_set(struct gfs2_sbd *sdp, struct gfs2_rgrpd *rgd)
  * Try to acquire rgrp in way which avoids contending with others.
  *
  * Returns: errno
- *          unlinked: the block address of an unlinked block to be reclaimed
  */
 
-static int get_local_rgrp(struct gfs2_inode *ip, u64 *unlinked,
-			  u64 *last_unlinked)
+static int get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_rgrpd *rgd, *begin = NULL;
@@ -1089,7 +1109,6 @@ static int get_local_rgrp(struct gfs2_inode *ip, u64 *unlinked,
 	int loops = 0;
 	int error, rg_locked;
 
-	*unlinked = 0;
 	rgd = gfs2_blk2rgrpd(sdp, ip->i_goal);
 
 	while (rgd) {
@@ -1106,17 +1125,10 @@ static int get_local_rgrp(struct gfs2_inode *ip, u64 *unlinked,
 		case 0:
 			if (try_rgrp_fit(rgd, al))
 				goto out;
-			/* If the rg came in already locked, there's no
-			   way we can recover from a failed try_rgrp_unlink
-			   because that would require an iput which can only
-			   happen after the rgrp is unlocked. */
-			if (!rg_locked && rgd->rd_flags & GFS2_RDF_CHECK)
-				*unlinked = try_rgrp_unlink(rgd, last_unlinked,
-							   ip->i_no_addr);
+			if (rgd->rd_flags & GFS2_RDF_CHECK)
+				try_rgrp_unlink(rgd, last_unlinked, ip->i_no_addr);
 			if (!rg_locked)
 				gfs2_glock_dq_uninit(&al->al_rgd_gh);
-			if (*unlinked)
-				return -EAGAIN;
 			/* fall through */
 		case GLR_TRYFAILED:
 			rgd = recent_rgrp_next(rgd);
@@ -1145,13 +1157,10 @@ static int get_local_rgrp(struct gfs2_inode *ip, u64 *unlinked,
 		case 0:
 			if (try_rgrp_fit(rgd, al))
 				goto out;
-			if (!rg_locked && rgd->rd_flags & GFS2_RDF_CHECK)
-				*unlinked = try_rgrp_unlink(rgd, last_unlinked,
-							    ip->i_no_addr);
+			if (rgd->rd_flags & GFS2_RDF_CHECK)
+				try_rgrp_unlink(rgd, last_unlinked, ip->i_no_addr);
 			if (!rg_locked)
 				gfs2_glock_dq_uninit(&al->al_rgd_gh);
-			if (*unlinked)
-				return -EAGAIN;
 			break;
 
 		case GLR_TRYFAILED:
@@ -1204,12 +1213,12 @@ int gfs2_inplace_reserve_i(struct gfs2_inode *ip, int hold_rindex,
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_alloc *al = ip->i_alloc;
 	int error = 0;
-	u64 last_unlinked = NO_BLOCK, unlinked;
+	u64 last_unlinked = NO_BLOCK;
+	int tries = 0;
 
 	if (gfs2_assert_warn(sdp, al->al_requested))
 		return -EINVAL;
 
-try_again:
 	if (hold_rindex) {
 		/* We need to hold the rindex unless the inode we're using is
 		   the rindex itself, in which case it's already held. */
@@ -1218,31 +1227,23 @@ try_again:
 		else if (!sdp->sd_rgrps) /* We may not have the rindex read
 					    in, so: */
 			error = gfs2_ri_update_special(ip);
+		if (error)
+			return error;
 	}
 
-	if (error)
-		return error;
+	do {
+		error = get_local_rgrp(ip, &last_unlinked);
+		/* If there is no space, flushing the log may release some */
+		if (error)
+			gfs2_log_flush(sdp, NULL);
+	} while (error && tries++ < 3);
 
-	/* Find an rgrp suitable for allocation.  If it encounters any unlinked
-	   dinodes along the way, error will equal -EAGAIN and unlinked will
-	   contains it block address. We then need to look up that inode and
-	   try to free it, and try the allocation again. */
-	error = get_local_rgrp(ip, &unlinked, &last_unlinked);
 	if (error) {
 		if (hold_rindex && ip != GFS2_I(sdp->sd_rindex))
 			gfs2_glock_dq_uninit(&al->al_ri_gh);
-		if (error != -EAGAIN)
-			return error;
-
-		gfs2_process_unlinked_inode(ip->i_inode.i_sb, unlinked);
-		/* regardless of whether or not gfs2_process_unlinked_inode
-		   was successful, we don't want to repeat it again. */
-		last_unlinked = unlinked;
-		gfs2_log_flush(sdp, NULL);
-		error = 0;
-
-		goto try_again;
+		return error;
 	}
+
 	/* no error, so we have the rgrp set in the inode's allocation. */
 	al->al_file = file;
 	al->al_line = line;


