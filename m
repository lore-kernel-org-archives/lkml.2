Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab2GQV3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 17:29:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756781Ab2GQV3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 17:29:33 -0400
Date: Tue, 17 Jul 2012 17:29:27 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Hugh Dickins <hughd@google.com>, Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v3 2/3] cgroup: revise how we re-populate root directory
Message-ID: <20120717212926.GB26916@redhat.com>
References: <20120702142925.795007114@napanee.usersys.redhat.com>
 <20120702142926.405632285@napanee.usersys.redhat.com>
 <20120709171748.GD1341@google.com>
 <20120709172220.GE1341@google.com>
 <20120709172831.GF1341@google.com>
 <20120710192721.GB19791@redhat.com>
 <20120717183851.GA24336@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120717183851.GA24336@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 11:38:51AM -0700, Tejun Heo wrote:
> Hello,
> 
> Sorry about the delay.

no worries, thanks for doing this

> On Tue, Jul 10, 2012 at 03:27:22PM -0400, Aristeu Rozanski wrote:
> > Index: xattr/include/linux/cgroup.h
> > ===================================================================
> > --- xattr.orig/include/linux/cgroup.h	2012-07-03 15:43:43.404334484 -0400
> > +++ xattr/include/linux/cgroup.h	2012-07-10 13:17:32.285119770 -0400
> > @@ -306,6 +306,9 @@
> >  	 */
> >  	size_t max_write_len;
> >  
> > +	/* The subsystem this cgroup file belongs to */
> > +	struct cgroup_subsys *subsys;
> 
> I couldn't find how this is used.  How is it used?

ignore this, I forgot it there from a previous version of the patch

> Maybe @subsys_mask is better?  Also, why is @remove_all a separate
> argument?  Can't we define, say, CGRP_ALL_SUBSYS and pass it in as
> @subsys_mask?

(...)

> Ah, I see.  We don't have a bit for the base files.  I think it's a
> bit confusing that there are two params controlling subsys file
> removal.  Maybe reserve a bit for NULL subsys or use
> @remove_base_files argument instead?

if we'd create one subsys id for base, a lot of code would have to be
changed in order to accomodate this. I think
remove_base_files/base_files will look better.

> 
> > +static int cgroup_populate_dir(struct cgroup *cgrp)
> > +{
> > +	int err;
> > +
> > +	err = cgroup_addrm_files(cgrp, NULL, files, true);
> > +	if (err < 0)
> > +		return err;
> > +
> > +	return __cgroup_populate_dir(cgrp, cgrp->root->subsys_bits);
> > +}
> 
> I think it would be best to keep the clear and populate interface more
> or less symmetrical so that both have @subsys_mask (and maybe
> @base_files).

what about this version:

--- xattr.orig/kernel/cgroup.c	2012-07-03 15:43:43.404334484 -0400
+++ xattr/kernel/cgroup.c	2012-07-17 15:49:10.536825559 -0400
@@ -824,7 +824,8 @@
 static int cgroup_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode);
 static struct dentry *cgroup_lookup(struct inode *, struct dentry *, struct nameidata *);
 static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry);
-static int cgroup_populate_dir(struct cgroup *cgrp);
+static int cgroup_populate_dir(struct cgroup *cgrp, bool base_files,
+			       unsigned long added_bits);
 static const struct inode_operations cgroup_dir_inode_operations;
 static const struct file_operations proc_cgroupstats_operations;
 
@@ -973,12 +974,23 @@
 	return -ENOENT;
 }
 
-static void cgroup_clear_directory(struct dentry *dir)
+static void cgroup_clear_directory(struct dentry *dir, bool base_files,
+				   unsigned long removed_bits)
 {
 	struct cgroup *cgrp = __d_cgrp(dir);
+	struct cgroup_subsys *ss;
 
-	while (!list_empty(&cgrp->files))
-		cgroup_rm_file(cgrp, NULL);
+	for_each_subsys(cgrp->root, ss) {
+		struct cftype_set *set;
+		if (!test_bit(ss->subsys_id, &removed_bits))
+			continue;
+		list_for_each_entry(set, &ss->cftsets, node)
+			cgroup_rm_file(cgrp, set->cfts);
+	}
+	if (base_files) {
+		while (!list_empty(&cgrp->files))
+			cgroup_rm_file(cgrp, NULL);
+	}
 }
 
 /*
@@ -987,8 +999,9 @@
 static void cgroup_d_remove_dir(struct dentry *dentry)
 {
 	struct dentry *parent;
+	struct cgroupfs_root *root = dentry->d_sb->s_fs_info;
 
-	cgroup_clear_directory(dentry);
+	cgroup_clear_directory(dentry, true, root->subsys_bits);
 
 	parent = dentry->d_parent;
 	spin_lock(&parent->d_lock);
@@ -1353,6 +1366,7 @@
 	struct cgroupfs_root *root = sb->s_fs_info;
 	struct cgroup *cgrp = &root->top_cgroup;
 	struct cgroup_sb_opts opts;
+	unsigned long added_bits, removed_bits;
 
 	mutex_lock(&cgrp->dentry->d_inode->i_mutex);
 	mutex_lock(&cgroup_mutex);
@@ -1368,6 +1382,9 @@
 		pr_warning("cgroup: option changes via remount are deprecated (pid=%d comm=%s)\n",
 			   task_tgid_nr(current), current->comm);
 
+	added_bits = opts.subsys_bits & ~root->subsys_bits;
+	removed_bits = root->subsys_bits & ~opts.subsys_bits;
+
 	/* Don't allow flags or name to change at remount */
 	if (opts.flags != root->flags ||
 	    (opts.name && strcmp(opts.name, root->name))) {
@@ -1383,8 +1400,9 @@
 	}
 
 	/* clear out any existing files and repopulate subsystem files */
-	cgroup_clear_directory(cgrp->dentry);
-	cgroup_populate_dir(cgrp);
+	cgroup_clear_directory(cgrp->dentry, false, removed_bits);
+	/* re-populate subsystem files */
+	cgroup_populate_dir(cgrp, false, added_bits);
 
 	if (opts.release_agent)
 		strcpy(root->release_agent_path, opts.release_agent);
@@ -1684,7 +1702,7 @@
 		BUG_ON(root->number_of_cgroups != 1);
 
 		cred = override_creds(&init_cred);
-		cgroup_populate_dir(root_cgrp);
+		cgroup_populate_dir(root_cgrp, true, root->subsys_bits);
 		revert_creds(cred);
 		mutex_unlock(&cgroup_root_mutex);
 		mutex_unlock(&cgroup_mutex);
@@ -3858,18 +3876,23 @@
 	{ }	/* terminate */
 };
 
-static int cgroup_populate_dir(struct cgroup *cgrp)
+static int cgroup_populate_dir(struct cgroup *cgrp, bool base_files,
+			       unsigned long added_bits)
 {
 	int err;
 	struct cgroup_subsys *ss;
 
-	err = cgroup_addrm_files(cgrp, NULL, files, true);
-	if (err < 0)
-		return err;
+        if (base_files) {
+		err = cgroup_addrm_files(cgrp, NULL, files, true);
+		if (err < 0)
+			return err;
+	}
 
 	/* process cftsets of each subsystem */
 	for_each_subsys(cgrp->root, ss) {
 		struct cftype_set *set;
+		if (!test_bit(ss->subsys_id, &added_bits))
+			continue;
 
 		list_for_each_entry(set, &ss->cftsets, node)
 			cgroup_addrm_files(cgrp, ss, set->cfts, true);
@@ -4032,7 +4055,7 @@
 
 	list_add_tail(&cgrp->allcg_node, &root->allcg_list);
 
-	err = cgroup_populate_dir(cgrp);
+	err = cgroup_populate_dir(cgrp, true, root->subsys_bits);
 	/* If err < 0, we have a half-filled directory - oh well ;) */
 
 	mutex_unlock(&cgroup_mutex);

