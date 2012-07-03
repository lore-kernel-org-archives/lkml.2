Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147Ab2GCWw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 18:52:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53007 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab2GCWwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 18:52:23 -0400
Date: Tue, 3 Jul 2012 15:52:18 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: shyju pv <shyju.pv@huawei.com>, Sanil kumar <sanil.kumar@huawei.com>,
        Masanari Iida <standby24x7@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        viro@zeniv.linux.org.uk, levinsasha928@gmail.com
Subject: Re: [PATCH] cgroup: fix dentry still in use bug when dropping css
 refs after umount
Message-ID: <20120703225218.GF555@google.com>
References: <4FEEA5CB.8070809@huawei.com>
 <20120703170317.GB555@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120703170317.GB555@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Shyju, can you please test the following patch?

Sasha, can you please re-test your test case with this patch?  I don't
think fa980ca87d "cgroup: superblock can't be released with active
dentries" did anything useful.  cgroup always calls d_iput() and
d_release() in succession from the same context.  It may just have
stretched the timing a bit to hide the race.

Li, this patch reverts fa980ca87d and wraps dput() in css_dput_fn()
with s_active refs.  Positive dentry ref means that we have active ref
on sb, so wrapping the final dput() with extra s_active ref should
avoid premature super destruction.  I think we're horridly broken for
root cgroup tho - and it has been broken for very long time.  I think
it's mostly hidden because most (all?) controllers short-circuit root
cgroup.  Eh, well....

Thanks.

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b214fc2..15462a0 100644
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
