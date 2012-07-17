Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab2GQSi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 14:38:59 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:62295 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab2GQSi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 14:38:56 -0400
Date: Tue, 17 Jul 2012 11:38:51 -0700
From: Tejun Heo <tj@kernel.org>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Hugh Dickins <hughd@google.com>, Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v3 2/3] cgroup: revise how we re-populate root directory
Message-ID: <20120717183851.GA24336@google.com>
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
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Sorry about the delay.

On Tue, Jul 10, 2012 at 03:27:22PM -0400, Aristeu Rozanski wrote:
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

I couldn't find how this is used.  How is it used?

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

Maybe @subsys_mask is better?  Also, why is @remove_all a separate
argument?  Can't we define, say, CGRP_ALL_SUBSYS and pass it in as
@subsys_mask?

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

Ah, I see.  We don't have a bit for the base files.  I think it's a
bit confusing that there are two params controlling subsys file
removal.  Maybe reserve a bit for NULL subsys or use
@remove_base_files argument instead?

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

I think it would be best to keep the clear and populate interface more
or less symmetrical so that both have @subsys_mask (and maybe
@base_files).

Thanks.

-- 
tejun
