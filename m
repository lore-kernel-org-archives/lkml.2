Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab1ASKtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 05:49:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827Ab1ASKtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 05:49:03 -0500
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Wed, 19 Jan 2011 10:50:18 +0000
Message-ID: <1295434218.2578.66.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following GFS2 bug fixes,

Steve.

------------------------------------------------------------------------------

The following changes since commit e6f597a1425b5af64917be3448b29e2d5a585ac8:

  staging: fix build failure in bcm driver (2011-01-17 17:39:39 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git master

Benjamin Marzinski (1):
      GFS2: remove iopen glocks from cache on failed deletes

Steven Whitehouse (1):
      GFS2: Fix error path in gfs2_lookup_by_inum()

 fs/gfs2/inode.c |   72 ++++++++++++++++--------------------------------------
 fs/gfs2/inode.h |    1 -
 fs/gfs2/super.c |    1 +
 3 files changed, 23 insertions(+), 51 deletions(-)

-----------------------------------------------------------------------------
>From 23c3010808de86f21436eb822aacfa551bfc17e4 Mon Sep 17 00:00:00 2001
From: Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 14 Jan 2011 22:39:16 -0600
Subject: [PATCH 1/2] GFS2: remove iopen glocks from cache on failed deletes

When a file gets deleted on GFS2, if a node can't get an exclusive lock on the
file's iopen glock, it punts on actually freeing up the space, because another
node is using the file.  When it does this, it needs to drop the iopen glock
from its cache so that the other node can get an exclusive lock on it. Now,
gfs2_delete_inode() sets GL_NOCACHE before dropping the shared lock on the
iopen glock in preparation for grabbing it in the exclusive state.  Since the
node needs the glock in the exclusive state, dropping the shared lock from the
cache doesn't slow down the case where no other nodes are using the file.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 16c2eca..ec73ed7 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1336,6 +1336,7 @@ static void gfs2_evict_inode(struct inode *inode)
 	if (error)
 		goto out_truncate;
 
+	ip->i_iopen_gh.gh_flags |= GL_NOCACHE;
 	gfs2_glock_dq_wait(&ip->i_iopen_gh);
 	gfs2_holder_reinit(LM_ST_EXCLUSIVE, LM_FLAG_TRY_1CB | GL_NOCACHE, &ip->i_iopen_gh);
 	error = gfs2_glock_nq(&ip->i_iopen_gh);
-- 
1.7.3.3

------------------------------------------------------------------------------
>From 24d9765fc18c7838ccdbb0d71fb706321d9b824c Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Tue, 18 Jan 2011 14:49:08 +0000
Subject: [PATCH 2/2] GFS2: Fix error path in gfs2_lookup_by_inum()

In the (impossible, except if there is fs corruption) error path
in gfs2_lookup_by_inum() if the call to gfs2_inode_refresh()
fails, it was leaving the function by calling iput() rather
than iget_failed(). This would cause future lookups of the same
inode to block forever.

This patch fixes the problem by moving the call to gfs2_inode_refresh()
into gfs2_inode_lookup() where iget_failed() is part of the error path
already. Also this cleans up some unreachable code and makes
gfs2_set_iop() static.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 2232b3c..7aa7d4f 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -74,16 +74,14 @@ static struct inode *gfs2_iget(struct super_block *sb, u64 no_addr)
 }
 
 /**
- * GFS2 lookup code fills in vfs inode contents based on info obtained
- * from directory entry inside gfs2_inode_lookup(). This has caused issues
- * with NFS code path since its get_dentry routine doesn't have the relevant
- * directory entry when gfs2_inode_lookup() is invoked. Part of the code
- * segment inside gfs2_inode_lookup code needs to get moved around.
+ * gfs2_set_iop - Sets inode operations
+ * @inode: The inode with correct i_mode filled in
  *
- * Clears I_NEW as well.
- **/
+ * GFS2 lookup code fills in vfs inode contents based on info obtained
+ * from directory entry inside gfs2_inode_lookup().
+ */
 
-void gfs2_set_iop(struct inode *inode)
+static void gfs2_set_iop(struct inode *inode)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	umode_t mode = inode->i_mode;
@@ -106,8 +104,6 @@ void gfs2_set_iop(struct inode *inode)
 		inode->i_op = &gfs2_file_iops;
 		init_special_inode(inode, inode->i_mode, inode->i_rdev);
 	}
-
-	unlock_new_inode(inode);
 }
 
 /**
@@ -119,10 +115,8 @@ void gfs2_set_iop(struct inode *inode)
  * Returns: A VFS inode, or an error
  */
 
-struct inode *gfs2_inode_lookup(struct super_block *sb,
-				unsigned int type,
-				u64 no_addr,
-				u64 no_formal_ino)
+struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned int type,
+				u64 no_addr, u64 no_formal_ino)
 {
 	struct inode *inode;
 	struct gfs2_inode *ip;
@@ -152,51 +146,37 @@ struct inode *gfs2_inode_lookup(struct super_block *sb,
 		error = gfs2_glock_nq_init(io_gl, LM_ST_SHARED, GL_EXACT, &ip->i_iopen_gh);
 		if (unlikely(error))
 			goto fail_iopen;
-		ip->i_iopen_gh.gh_gl->gl_object = ip;
 
+		ip->i_iopen_gh.gh_gl->gl_object = ip;
 		gfs2_glock_put(io_gl);
 		io_gl = NULL;
 
-		if ((type == DT_UNKNOWN) && (no_formal_ino == 0))
-			goto gfs2_nfsbypass;
-
-		inode->i_mode = DT2IF(type);
-
-		/*
-		 * We must read the inode in order to work out its type in
-		 * this case. Note that this doesn't happen often as we normally
-		 * know the type beforehand. This code path only occurs during
-		 * unlinked inode recovery (where it is safe to do this glock,
-		 * which is not true in the general case).
-		 */
 		if (type == DT_UNKNOWN) {
-			struct gfs2_holder gh;
-			error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
-			if (unlikely(error))
-				goto fail_glock;
-			/* Inode is now uptodate */
-			gfs2_glock_dq_uninit(&gh);
+			/* Inode glock must be locked already */
+			error = gfs2_inode_refresh(GFS2_I(inode));
+			if (error)
+				goto fail_refresh;
+		} else {
+			inode->i_mode = DT2IF(type);
 		}
 
 		gfs2_set_iop(inode);
+		unlock_new_inode(inode);
 	}
 
-gfs2_nfsbypass:
 	return inode;
-fail_glock:
-	gfs2_glock_dq(&ip->i_iopen_gh);
+
+fail_refresh:
+	ip->i_iopen_gh.gh_gl->gl_object = NULL;
+	gfs2_glock_dq_uninit(&ip->i_iopen_gh);
 fail_iopen:
 	if (io_gl)
 		gfs2_glock_put(io_gl);
 fail_put:
-	if (inode->i_state & I_NEW)
-		ip->i_gl->gl_object = NULL;
+	ip->i_gl->gl_object = NULL;
 	gfs2_glock_put(ip->i_gl);
 fail:
-	if (inode->i_state & I_NEW)
-		iget_failed(inode);
-	else
-		iput(inode);
+	iget_failed(inode);
 	return ERR_PTR(error);
 }
 
@@ -221,14 +201,6 @@ struct inode *gfs2_lookup_by_inum(struct gfs2_sbd *sdp, u64 no_addr,
 	if (IS_ERR(inode))
 		goto fail;
 
-	error = gfs2_inode_refresh(GFS2_I(inode));
-	if (error)
-		goto fail_iput;
-
-	/* Pick up the works we bypass in gfs2_inode_lookup */
-	if (inode->i_state & I_NEW) 
-		gfs2_set_iop(inode);
-
 	/* Two extra checks for NFS only */
 	if (no_formal_ino) {
 		error = -ESTALE;
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index 732a183..3e00a66 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -96,7 +96,6 @@ err:
 	return -EIO;
 }
 
-extern void gfs2_set_iop(struct inode *inode);
 extern struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned type, 
 				       u64 no_addr, u64 no_formal_ino);
 extern struct inode *gfs2_lookup_by_inum(struct gfs2_sbd *sdp, u64 no_addr,
-- 
1.7.3.3



