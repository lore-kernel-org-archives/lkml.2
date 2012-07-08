Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344Ab2GHGdq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 02:33:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42826 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab2GHGdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 02:33:45 -0400
Date: Sat, 7 Jul 2012 23:33:40 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, shyju pv <shyju.pv@huawei.com>,
        Sasha Levin <levinsasha928@gmail.com>, Li Zefan <lizefan@huawei.com>
Subject: [GIT PULL] cgroup fixes for 3.5-rc5
Message-ID: <20120708063340.GA19021@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

The previous cgroup pull request contained a patch to fix a race
condition during cgroup hierarchy umount.  Unfortunately, while the
patch reduced the race window such that the test case I and Sasha were
using didn't trigger it anymore, it wasn't complete - Shyju and Li
could reliably trigger the race condition using a different test case.

The problem wasn't the gap between dentry deletion and release which
the previous patch tried to fix.  The window was between the last
dput() of a root's child and the resulting dput() of the root.  For
cgroup dentries, the deletion and release always happen synchronously.
As this releases the s_active ref, the refcnt of the root dentry,
which doesn't hold s_active, stays above zero without the
corresponding s_active.  If umount was in progress, the last
deactivate_super() proceeds to destory the superblock and triggers
BUG() on the non-zero root dentry refcnt after shrinking.

This issue surfaced because cgroup dentries are now allowed to linger
after rmdir(2) since 3.5-rc1.  Before, rmdir synchronously drained the
dentry refcnt and the s_active acquired by rmdir from vfs layer
protected the whole thing.  After 3.5-rc1, cgroup may internally hold
and put dentry refs after rmdir finishes and the delayed dput()
doesn't have surrounding s_active ref exposing this issue.

This pull request contains two patches - one reverting the previous
incorrect fix and the other adding the surrounding s_active ref around
the delayed dput().

This is quite late in the release cycle but the change is on the safer
side and fixes the test cases reliably, so I don't think it's too
crazy.  Thanks.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.5-fixes

Tejun Heo (2):
      Revert "cgroup: superblock can't be released with active dentries"
      cgroup: fix cgroup hierarchy umount race

 kernel/cgroup.c |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)
---
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2097684..b303dfc 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -901,13 +901,10 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 		mutex_unlock(&cgroup_mutex);
 
 		/*
-		 * We want to drop the active superblock reference from the
-		 * cgroup creation after all the dentry refs are gone -
-		 * kill_sb gets mighty unhappy otherwise.  Mark
-		 * dentry->d_fsdata with cgroup_diput() to tell
-		 * cgroup_d_release() to call deactivate_super().
+		 * Drop the active superblock reference that we took when we
+		 * created the cgroup
 		 */
-		dentry->d_fsdata = cgroup_diput;
+		deactivate_super(cgrp->root->sb);
 
 		/*
 		 * if we're getting rid of the cgroup, refcount should ensure
@@ -933,13 +930,6 @@ static int cgroup_delete(const struct dentry *d)
 	return 1;
 }
 
-static void cgroup_d_release(struct dentry *dentry)
-{
-	/* did cgroup_diput() tell me to deactivate super? */
-	if (dentry->d_fsdata == cgroup_diput)
-		deactivate_super(dentry->d_sb);
-}
-
 static void remove_dir(struct dentry *d)
 {
 	struct dentry *parent = dget(d->d_parent);
@@ -1547,7 +1537,6 @@ static int cgroup_get_rootdir(struct super_block *sb)
 	static const struct dentry_operations cgroup_dops = {
 		.d_iput = cgroup_diput,
 		.d_delete = cgroup_delete,
-		.d_release = cgroup_d_release,
 	};
 
 	struct inode *inode =
@@ -3894,8 +3883,12 @@ static void css_dput_fn(struct work_struct *work)
 {
 	struct cgroup_subsys_state *css =
 		container_of(work, struct cgroup_subsys_state, dput_work);
+	struct dentry *dentry = css->cgroup->dentry;
+	struct super_block *sb = dentry->d_sb;
 
-	dput(css->cgroup->dentry);
+	atomic_inc(&sb->s_active);
+	dput(dentry);
+	deactivate_super(sb);
 }
 
 static void init_cgroup_css(struct cgroup_subsys_state *css,
