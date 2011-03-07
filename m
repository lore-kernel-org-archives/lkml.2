Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab1CGRv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 12:51:27 -0500
Received: from cobra.newdream.net ([66.33.216.30]:39023 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950Ab1CGRvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 12:51:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:in-reply-to:message-id:references:mime-version:
	content-type; q=dns; s=newdream.net; b=AbjGbfcbs8/nEaG32uBtXuWrs
	eMeIc1y/tEMOMJDCOY2zfl7sQnamhwo+rP/N3arzCJpksHubZVqv2YcTOye2Q+oz
	tvsOdbTdzav/F+SH94Q10lNtPdbkdurEXl/cHXJCCB7jlXz3gUvoWxEEGsvPkyTC
	IcQuB/qvf9vjMd7hPY=
Date: Mon, 7 Mar 2011 09:53:05 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
cc: mszeredi@suse.cz
Subject: Re: [RFC] d_prune
In-Reply-To: <Pine.LNX.4.64.1103041443290.29012@cobra.newdream.net>
Message-ID: <Pine.LNX.4.64.1103070947370.11152@cobra.newdream.net>
References: <Pine.LNX.4.64.1103041443290.29012@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Mar 2011, Sage Weil wrote:
> The rcu path walk changes for 2.6.38 shone light in some dark corners 
> where Ceph was using the dcache in racy ways.  The main problem is this:
> 
>  * The Ceph MDS server gives us lease information such that we know the
>    contents for a directory won't change.
>  * We want to do lookup on non-existant items without interacting with the
>    server.  (We also want to do readdir, but that's a more complicated
>    case.)
>  * The existing hooks (d_release is what we were using) do not give us
>    the opportunity to clear our "this directory is completely cached" flag
>    prior to the dentry being unhashed.
>  * d_lookup can't look at the "complete" flag and conclude a dentry 
>    doesn't exist without worrying about a race with the pruner.
> 
> There are two cases where this matters:
> 
>  * The VFS does a lookup prior to any create, which means we do two server 
>    requests instead of one.  Some VFS refactoring could probably fix that 
>    (and Al has some ideas there).
>  * A user looks up a non-existent file.  This should not require a server
>    request at all.
> 
> The race we care about is with the pruner (shrink_dentry_list and 
> shrink_dcache_for_umount_subtree).  Dropping dentries due to actual 
> changes (rename, unlink, rmdir) all go through the usual d_ops where we 
> have ample opportunity to the right thing (with the exception of one 
> dentry_unhash in vfs_rename_dir() :/).

Unless there are other (non-pruner) cases where the VFS randomly unhashes 
things, I think vfs_rename_dir() is the main problem with the d_prune 
method approach.  Specifically, vfs_rename_dir() does

                if (target)
                        dentry_unhash(new_dentry);

prior to calling ->rename().  It's not clear to me why vfs_rename_dir() 
does this but vfs_rename_other() does not.  Could it be pushed down into 
the ->rename() method?

Also, the 

                if (d_unhashed(new_dentry))
                        d_rehash(new_dentry);

after ->rename() has always looked fishy/buggy to me.  See

        http://lkml.org/lkml/2008/7/30/165

Thanks-
sage



> Is something like the patch below sane?  It notifies the fs prior to 
> unhashing the dentry, giving Ceph the chance to clear its "complete" bit.  
> Are there other reasons the VFS would drop dentries that I'm missing?
> 
> Some alternatives we've considered:
> 
>  * Double-caching.  We could keep a copy of directory contents in the fs
>    layer and use that to do the lookup.  Yuck.
>  * Put the "complete" bit in the dcache.  The problem is it's a flag on 
>    the parent, d_flags is protected by d_lock, and we can't take the parent's
>    d_lock while holding the child's d_lock (which we do while pruning).  
>    Extra work that most fs's don't need.
>  * Serializing lookups against the pruner in some other way.
> 
> Any thoughts or suggestions?
> 
> Thanks! 
> sage
> 
> 
> diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
> index 4471a41..180e14b 100644
> --- a/Documentation/filesystems/Locking
> +++ b/Documentation/filesystems/Locking
> @@ -28,6 +28,7 @@ d_revalidate: no              no              yes (ref-walk)  maybe
>  d_hash         no              no              no              maybe
>  d_compare:     yes             no              no              maybe
>  d_delete:      no              yes             no              no
> +d_prune:        no              yes             no              no
>  d_release:     no              no              yes             no
>  d_iput:                no              no              yes             no
>  d_dname:       no              no              no              no
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 2a6bd9a..cdb5d81 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -690,6 +690,8 @@ static void try_prune_one_dentry(struct dentry *dentry)
>                         spin_unlock(&dentry->d_lock);
>                         return;
>                 }
> +               if (dentry->d_op->d_flags & DCACHE_OP_PRUNE)
> +                       dentry->d_op->d_prune(dentry);
>                 dentry = dentry_kill(dentry, 1);
>         }
>  }
> @@ -896,6 +898,8 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
>  
>         /* detach this root from the system */
>         spin_lock(&dentry->d_lock);
> +       if (dentry->d_op->d_flags & DCACHE_OP_PRUNE)
> +               dentry->d_op->d_prune(dentry);
>         dentry_lru_del(dentry);
>         __d_drop(dentry);
>         spin_unlock(&dentry->d_lock);
> @@ -912,6 +916,8 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
>                                             d_u.d_child) {
>                                 spin_lock_nested(&loop->d_lock,
>                                                 DENTRY_D_LOCK_NESTED);
> +                               if (dentry->d_op->d_flags & DCACHE_OP_PRUNE)
> +                                       dentry->d_op->d_prune(dentry);
>                                 dentry_lru_del(loop);
>                                 __d_drop(loop);
>                                 spin_unlock(&loop->d_lock);
> @@ -1375,6 +1381,8 @@ void d_set_d_op(struct dentry *dentry, const struct dentry_operations *op)
>                 dentry->d_flags |= DCACHE_OP_REVALIDATE;
>         if (op->d_delete)
>                 dentry->d_flags |= DCACHE_OP_DELETE;
> +       if (op->d_prune)
> +               dentry->d_flags |= DCACHE_OP_PRUNE;
>  
>  }
>  EXPORT_SYMBOL(d_set_d_op);
> diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> index f958c19..1e83bd8 100644
> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -165,6 +165,7 @@ struct dentry_operations {
>                         unsigned int, const char *, const struct qstr *);
>         int (*d_delete)(const struct dentry *);
>         void (*d_release)(struct dentry *);
> +       void (*d_prune)(struct dentry *);
>         void (*d_iput)(struct dentry *, struct inode *);
>         char *(*d_dname)(struct dentry *, char *, int);
>         struct vfsmount *(*d_automount)(struct path *);
> @@ -219,6 +220,8 @@ struct dentry_operations {
>  #define DCACHE_MANAGED_DENTRY \
>         (DCACHE_MOUNTED|DCACHE_NEED_AUTOMOUNT|DCACHE_MANAGE_TRANSIT)
>  
> +#define DCACHE_OP_PRUNE         0x80000
> +
>  extern seqlock_t rename_lock;
>  
>  static inline int dname_external(struct dentry *dentry)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
