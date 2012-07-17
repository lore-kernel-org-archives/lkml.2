Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab2GQN5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 09:57:17 -0400
Received: from lobo.ruivo.org ([173.14.175.98]:58985 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755129Ab2GQN5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 09:57:14 -0400
Date: Tue, 17 Jul 2012 09:56:45 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: Tejun Heo <tj@kernel.org>
Cc: Aristeu Rozanski <aris@redhat.com>, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Hugh Dickins <hughd@google.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v3 2/3] cgroup: revise how we re-populate root directory
Message-ID: <20120717135645.GA5134@cathedrallabs.org>
References: <20120702142925.795007114@napanee.usersys.redhat.com>
 <20120702142926.405632285@napanee.usersys.redhat.com>
 <20120709171748.GD1341@google.com>
 <20120709172220.GE1341@google.com>
 <20120709172831.GF1341@google.com>
 <20120710192721.GB19791@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120710192721.GB19791@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,
On Tue, Jul 10, 2012 at 03:27:22PM -0400, Aristeu Rozanski wrote:
> Hi Tejun,
> On Mon, Jul 09, 2012 at 10:28:31AM -0700, Tejun Heo wrote:
> > On Mon, Jul 09, 2012 at 10:22:20AM -0700, Tejun Heo wrote:
> > > > Changing subsys_bits via remount is being deprecated.  No need to
> > > > worry about this.
> > > 
> > > Also, why does this matter?  The xattrs are kept in cgrp anyway.  Why
> > > does keeping dentry/inode around make difference?
> > 
> > Ah, okay, the file xattrs are kept in cfe which goes away on file
> > deletion.  :)
> > 
> > While changing subsys via remount is going away, I think removing
> > files selectively is still nice to have (even for single hierarchy).
> > I wish it were implemented differently tho.  As cgroup_rm_file()
> > already has @cft argument, wouldn't it be better to e.g. add @subsys
> > arg to cgroup_clear_directory() and let that walk subsys->cftsets
> > instead?
> 
> something like this? (will resubmit if you're ok with this version)

had some time to look on this?

> Index: xattr/include/linux/cgroup.h
> ===================================================================
> --- xattr.orig/include/linux/cgroup.h	2012-07-03 15:43:43.404334484 -0400
> +++ xattr/include/linux/cgroup.h	2012-07-10 13:17:32.285119770 -0400
> @@ -306,6 +306,9 @@
>  	 */
>  	size_t max_write_len;
>  
> +	/* The subsystem this cgroup file belongs to */
> +	struct cgroup_subsys *subsys;
> +
>  	/* CFTYPE_* flags */
>  	unsigned int flags;
>  
> Index: xattr/kernel/cgroup.c
> ===================================================================
> --- xattr.orig/kernel/cgroup.c	2012-07-03 15:43:43.404334484 -0400
> +++ xattr/kernel/cgroup.c	2012-07-10 13:28:18.424657727 -0400
> @@ -825,6 +825,7 @@
>  static struct dentry *cgroup_lookup(struct inode *, struct dentry *, struct nameidata *);
>  static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry);
>  static int cgroup_populate_dir(struct cgroup *cgrp);
> +static int cgroup_repopulate_dir(struct cgroup *cgrp, unsigned long added_bits);
>  static const struct inode_operations cgroup_dir_inode_operations;
>  static const struct file_operations proc_cgroupstats_operations;
>  
> @@ -973,12 +974,23 @@
>  	return -ENOENT;
>  }
>  
> -static void cgroup_clear_directory(struct dentry *dir)
> +static void cgroup_clear_directory(struct dentry *dir, bool remove_all,
> +				   unsigned long removed_bits)
>  {
>  	struct cgroup *cgrp = __d_cgrp(dir);
> +	struct cgroup_subsys *ss;
>  
> -	while (!list_empty(&cgrp->files))
> -		cgroup_rm_file(cgrp, NULL);
> +	for_each_subsys(cgrp->root, ss) {
> +		struct cftype_set *set;
> +		if (!remove_all && !test_bit(ss->subsys_id, &removed_bits))
> +			continue;
> +		list_for_each_entry(set, &ss->cftsets, node)
> +			cgroup_rm_file(cgrp, set->cfts);
> +	}
> +	if (remove_all) {
> +		while (!list_empty(&cgrp->files))
> +			cgroup_rm_file(cgrp, NULL);
> +	}
>  }
>  
>  /*
> @@ -988,7 +1000,7 @@
>  {
>  	struct dentry *parent;
>  
> -	cgroup_clear_directory(dentry);
> +	cgroup_clear_directory(dentry, true, 0);
>  
>  	parent = dentry->d_parent;
>  	spin_lock(&parent->d_lock);
> @@ -1353,6 +1365,7 @@
>  	struct cgroupfs_root *root = sb->s_fs_info;
>  	struct cgroup *cgrp = &root->top_cgroup;
>  	struct cgroup_sb_opts opts;
> +	unsigned long added_bits, removed_bits;
>  
>  	mutex_lock(&cgrp->dentry->d_inode->i_mutex);
>  	mutex_lock(&cgroup_mutex);
> @@ -1368,6 +1381,9 @@
>  		pr_warning("cgroup: option changes via remount are deprecated (pid=%d comm=%s)\n",
>  			   task_tgid_nr(current), current->comm);
>  
> +	added_bits = opts.subsys_bits & ~root->subsys_bits;
> +	removed_bits = root->subsys_bits & ~opts.subsys_bits;
> +
>  	/* Don't allow flags or name to change at remount */
>  	if (opts.flags != root->flags ||
>  	    (opts.name && strcmp(opts.name, root->name))) {
> @@ -1383,8 +1399,9 @@
>  	}
>  
>  	/* clear out any existing files and repopulate subsystem files */
> -	cgroup_clear_directory(cgrp->dentry);
> -	cgroup_populate_dir(cgrp);
> +	cgroup_clear_directory(cgrp->dentry, false, removed_bits);
> +	/* re-populate subsystem files */
> +	cgroup_repopulate_dir(cgrp, added_bits);
>  
>  	if (opts.release_agent)
>  		strcpy(root->release_agent_path, opts.release_agent);
> @@ -2696,6 +2713,8 @@
>  	umode_t mode;
>  	char name[MAX_CGROUP_TYPE_NAMELEN + MAX_CFTYPE_NAME + 2] = { 0 };
>  
> +	cft->subsys = subsys;
> +
>  	/* does @cft->flags tell us to skip creation on @cgrp? */
>  	if ((cft->flags & CFTYPE_NOT_ON_ROOT) && !cgrp->parent)
>  		return 0;
> @@ -3858,18 +3877,16 @@
>  	{ }	/* terminate */
>  };
>  
> -static int cgroup_populate_dir(struct cgroup *cgrp)
> +static int __cgroup_populate_dir(struct cgroup *cgrp, unsigned long added_bits)
>  {
>  	int err;
>  	struct cgroup_subsys *ss;
>  
> -	err = cgroup_addrm_files(cgrp, NULL, files, true);
> -	if (err < 0)
> -		return err;
> -
>  	/* process cftsets of each subsystem */
>  	for_each_subsys(cgrp->root, ss) {
>  		struct cftype_set *set;
> +		if (!test_bit(ss->subsys_id, &added_bits))
> +			continue;
>  
>  		list_for_each_entry(set, &ss->cftsets, node)
>  			cgroup_addrm_files(cgrp, ss, set->cfts, true);
> @@ -3890,6 +3907,22 @@
>  	return 0;
>  }
>  
> +static int cgroup_populate_dir(struct cgroup *cgrp)
> +{
> +	int err;
> +
> +	err = cgroup_addrm_files(cgrp, NULL, files, true);
> +	if (err < 0)
> +		return err;
> +
> +	return __cgroup_populate_dir(cgrp, cgrp->root->subsys_bits);
> +}
> +
> +static int cgroup_repopulate_dir(struct cgroup *cgrp, unsigned long added_bits)
> +{
> +	return __cgroup_populate_dir(cgrp, added_bits);
> +}
> +
>  static void css_dput_fn(struct work_struct *work)
>  {
>  	struct cgroup_subsys_state *css =
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
