Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab2FKKA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 06:00:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626Ab2FKKA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 06:00:56 -0400
Date: Mon, 11 Jun 2012 12:00:50 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-1-248.brq.redhat.com
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Luk?? Czerner <lczerner@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, mbroz@redhat.com
Subject: Re: [PATCH 1/2] vfs: Do not allow mnt_longterm to go negative
In-Reply-To: <20120609045404.GV30000@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1206111153140.5403@dhcp-1-248.brq.redhat.com>
References: <1337959776-16564-1-git-send-email-lczerner@redhat.com> <alpine.LFD.2.00.1205290807350.2144@dhcp-1-248.brq.redhat.com> <20120530020134.GA20448@ZenIV.linux.org.uk> <20120609045404.GV30000@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2012, Al Viro wrote:

> Date: Sat, 9 Jun 2012 05:54:04 +0100
> From: Al Viro <viro@ZenIV.linux.org.uk>
> To: Luk?? Czerner <lczerner@redhat.com>
> Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
>     mbroz@redhat.com
> Subject: Re: [PATCH 1/2] vfs: Do not allow mnt_longterm to go negative
> 
> On Wed, May 30, 2012 at 03:01:34AM +0100, Al Viro wrote:
> > instead and that's all it takes.  Alternatively, we can just turn the
> > code in mntput_no_expire() into
> > 	if (likely(mnt->mnt_ns || atomic_read(...))
> > and get rid of longterm/shortterm logics around ->mnt_ns completely.
> > Short-term, pardon the bad pun, I'm going with the first variant; it's
> > less intrusive.  Longer term I think we want to get rid of playing with
> > mnt_longterm in there and just check ->mnt_ns as well when deciding to
> > go for the fast path in mntput_no_expire().
> 
> Probably not, actually - mnt_make_shortterm() is called often enough (any
> chdir moving you to another fs) and practically always it's done with
> longterm reference from being mounted remaining there.  We want that to
> be fast path.  And that's exactly what we have with the current logics;
> we don't grab vfsmount_lock unless ->mnt_longterm was about to reach 0.
> We need to make sure that transition to "no longterm references left"
> would happen only under vfsmount_lock.  As it is (with the fix in 3.5-rc
> and -stable) we have this:
> 	mnt->mnt_longterm == number of references to mnt in some
> fs_struct->{root,pwd}.mnt + (is it a kernel-internal vfsmount ? 1 : 0) +
> (mnt->mnt_ns != NULL ? 1 : 0)
> and getting rid of the third part would make life consider more painful
> for chdir et.al. - we can use atomic_add_unless() for lockless path
> when dropping a pwd/root reference with the current scheme and get away
> with that in almost all cases.  Doing an equivalent with separate checks
> for mnt->mnt_ns != NULL or atomic_read(&mnt->mnt_longterm) > 0 would be
> hard and it wouldn't have won us anything.
> 
> IOW, I'm an idiot.  Especially since there is a much simpler solution:
> 	* lose ->mnt_longterm manipulations for root/pwd
> 	* lose ->mnt_longterm manipulations for places where we assign
> ->mnt_ns now
> 	* turn that check on the fast path of mntput_no_expire() into
> 	if (likely(mnt->mnt_ns))
> 	* turn manipulations with ->mnt_longterm in kern_mount_data/kern_umount
> into setting ->mnt_ns to something distinct (ERR_PTR(-EINVAL)) and clearing it.
> 	* lose ->mnt_longterm completely, along with the helpers for
> modifying it.
> 	* new helper - is_mounted(mnt); checks if ->mnt_ns points to some
> mnt_namespace (i.e. what used to be ->mnt_ns != NULL; now !IS_ERR_OR_NULL())
> 	* switch prepend_path() to use of that helper instead of direct
> check of ->mnt_ns != NULl.
> 
> Somebody with pwd on lazy-umounted vfsmount will have costlier mntput() of
> that pwd.  Everything else loses a bunch of atomic operations on fairly
> hot paths, not to mention the loss of extra atomic_t in struct vfsmount
> on SMP kernels.  BTW, looking at that thing... I really wonder if int is
> enough for mnt_count.  On boxen with a lot of RAM it might be possible to
> overflow; you are probably fucked anyway if that happens (things that
> hold struct vfsmount * are not particulary small), but still...  I suspect
> that it, and probably mnt_writers as well, should be long.  Anyway, that's
> a separate story; how about the following for ->mnt_longterm?

It looks like a good idea to me and the code seems fine. Although I
have one concern.

Currently mnt_ns could contain only valid pointer or NULL, however
with this patch it can also contain ERR_PTR(-EINVAL) which might be
a problem if we hit 'if (ns)' condition followed by dereferencing the
pointer. Especially touch_mnt_namespace() and __touch_mnt_namespace()
looks rather suspicious. I am not sure it we can get into this codepath
with this mnt_ns, but I do not immediately see why not.

It seems that we should rather change those condition to use
IS_ERR_OR_NULL(). What do you think ?

Thanks!
-Lukas

> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 4046904..44acb5b 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -2622,7 +2622,7 @@ global_root:
>  	if (!slash)
>  		error = prepend(buffer, buflen, "/", 1);
>  	if (!error)
> -		error = real_mount(vfsmnt)->mnt_ns ? 1 : 2;
> +		error = is_mounted(vfsmnt) ? 1 : 2;
>  	goto out;
>  }
>  
> diff --git a/fs/fs_struct.c b/fs/fs_struct.c
> index e159e68..5df4775 100644
> --- a/fs/fs_struct.c
> +++ b/fs/fs_struct.c
> @@ -6,18 +6,6 @@
>  #include <linux/fs_struct.h>
>  #include "internal.h"
>  
> -static inline void path_get_longterm(struct path *path)
> -{
> -	path_get(path);
> -	mnt_make_longterm(path->mnt);
> -}
> -
> -static inline void path_put_longterm(struct path *path)
> -{
> -	mnt_make_shortterm(path->mnt);
> -	path_put(path);
> -}
> -
>  /*
>   * Replace the fs->{rootmnt,root} with {mnt,dentry}. Put the old values.
>   * It can block.
> @@ -26,7 +14,7 @@ void set_fs_root(struct fs_struct *fs, struct path *path)
>  {
>  	struct path old_root;
>  
> -	path_get_longterm(path);
> +	path_get(path);
>  	spin_lock(&fs->lock);
>  	write_seqcount_begin(&fs->seq);
>  	old_root = fs->root;
> @@ -34,7 +22,7 @@ void set_fs_root(struct fs_struct *fs, struct path *path)
>  	write_seqcount_end(&fs->seq);
>  	spin_unlock(&fs->lock);
>  	if (old_root.dentry)
> -		path_put_longterm(&old_root);
> +		path_put(&old_root);
>  }
>  
>  /*
> @@ -45,7 +33,7 @@ void set_fs_pwd(struct fs_struct *fs, struct path *path)
>  {
>  	struct path old_pwd;
>  
> -	path_get_longterm(path);
> +	path_get(path);
>  	spin_lock(&fs->lock);
>  	write_seqcount_begin(&fs->seq);
>  	old_pwd = fs->pwd;
> @@ -54,7 +42,7 @@ void set_fs_pwd(struct fs_struct *fs, struct path *path)
>  	spin_unlock(&fs->lock);
>  
>  	if (old_pwd.dentry)
> -		path_put_longterm(&old_pwd);
> +		path_put(&old_pwd);
>  }
>  
>  static inline int replace_path(struct path *p, const struct path *old, const struct path *new)
> @@ -84,7 +72,7 @@ void chroot_fs_refs(struct path *old_root, struct path *new_root)
>  			write_seqcount_end(&fs->seq);
>  			while (hits--) {
>  				count++;
> -				path_get_longterm(new_root);
> +				path_get(new_root);
>  			}
>  			spin_unlock(&fs->lock);
>  		}
> @@ -92,13 +80,13 @@ void chroot_fs_refs(struct path *old_root, struct path *new_root)
>  	} while_each_thread(g, p);
>  	read_unlock(&tasklist_lock);
>  	while (count--)
> -		path_put_longterm(old_root);
> +		path_put(old_root);
>  }
>  
>  void free_fs_struct(struct fs_struct *fs)
>  {
> -	path_put_longterm(&fs->root);
> -	path_put_longterm(&fs->pwd);
> +	path_put(&fs->root);
> +	path_put(&fs->pwd);
>  	kmem_cache_free(fs_cachep, fs);
>  }
>  
> @@ -132,9 +120,9 @@ struct fs_struct *copy_fs_struct(struct fs_struct *old)
>  
>  		spin_lock(&old->lock);
>  		fs->root = old->root;
> -		path_get_longterm(&fs->root);
> +		path_get(&fs->root);
>  		fs->pwd = old->pwd;
> -		path_get_longterm(&fs->pwd);
> +		path_get(&fs->pwd);
>  		spin_unlock(&old->lock);
>  	}
>  	return fs;
> diff --git a/fs/internal.h b/fs/internal.h
> index 18bc216..d2a23ff6 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -50,8 +50,6 @@ extern int copy_mount_string(const void __user *, char **);
>  extern struct vfsmount *lookup_mnt(struct path *);
>  extern int finish_automount(struct vfsmount *, struct path *);
>  
> -extern void mnt_make_longterm(struct vfsmount *);
> -extern void mnt_make_shortterm(struct vfsmount *);
>  extern int sb_prepare_remount_readonly(struct super_block *);
>  
>  extern void __init mnt_init(void);
> diff --git a/fs/mount.h b/fs/mount.h
> index 4ef36d9..05a2a11 100644
> --- a/fs/mount.h
> +++ b/fs/mount.h
> @@ -22,7 +22,6 @@ struct mount {
>  	struct vfsmount mnt;
>  #ifdef CONFIG_SMP
>  	struct mnt_pcp __percpu *mnt_pcp;
> -	atomic_t mnt_longterm;		/* how many of the refs are longterm */
>  #else
>  	int mnt_count;
>  	int mnt_writers;
> @@ -49,6 +48,8 @@ struct mount {
>  	int mnt_ghosts;
>  };
>  
> +#define MNT_NS_INTERNAL ERR_PTR(-EINVAL) /* distinct from any mnt_namespace */
> +
>  static inline struct mount *real_mount(struct vfsmount *mnt)
>  {
>  	return container_of(mnt, struct mount, mnt);
> @@ -59,6 +60,12 @@ static inline int mnt_has_parent(struct mount *mnt)
>  	return mnt != mnt->mnt_parent;
>  }
>  
> +static inline int is_mounted(struct vfsmount *mnt)
> +{
> +	/* neither detached nor internal? */
> +	return !IS_ERR_OR_NULL(real_mount(mnt));
> +}
> +
>  extern struct mount *__lookup_mnt(struct vfsmount *, struct dentry *, int);
>  
>  static inline void get_mnt_ns(struct mnt_namespace *ns)
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 1e4a5fe..a524ea4 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -621,21 +621,6 @@ static void attach_mnt(struct mount *mnt, struct path *path)
>  	list_add_tail(&mnt->mnt_child, &real_mount(path->mnt)->mnt_mounts);
>  }
>  
> -static inline void __mnt_make_longterm(struct mount *mnt)
> -{
> -#ifdef CONFIG_SMP
> -	atomic_inc(&mnt->mnt_longterm);
> -#endif
> -}
> -
> -/* needs vfsmount lock for write */
> -static inline void __mnt_make_shortterm(struct mount *mnt)
> -{
> -#ifdef CONFIG_SMP
> -	atomic_dec(&mnt->mnt_longterm);
> -#endif
> -}
> -
>  /*
>   * vfsmount lock must be held for write
>   */
> @@ -649,10 +634,8 @@ static void commit_tree(struct mount *mnt)
>  	BUG_ON(parent == mnt);
>  
>  	list_add_tail(&head, &mnt->mnt_list);
> -	list_for_each_entry(m, &head, mnt_list) {
> +	list_for_each_entry(m, &head, mnt_list)
>  		m->mnt_ns = n;
> -		__mnt_make_longterm(m);
> -	}
>  
>  	list_splice(&head, n->list.prev);
>  
> @@ -804,7 +787,8 @@ static void mntput_no_expire(struct mount *mnt)
>  put_again:
>  #ifdef CONFIG_SMP
>  	br_read_lock(&vfsmount_lock);
> -	if (likely(atomic_read(&mnt->mnt_longterm))) {
> +	if (likely(mnt->mnt_ns)) {
> +		/* shouldn't be the last one */
>  		mnt_add_count(mnt, -1);
>  		br_read_unlock(&vfsmount_lock);
>  		return;
> @@ -1074,8 +1058,6 @@ void umount_tree(struct mount *mnt, int propagate, struct list_head *kill)
>  		list_del_init(&p->mnt_expire);
>  		list_del_init(&p->mnt_list);
>  		__touch_mnt_namespace(p->mnt_ns);
> -		if (p->mnt_ns)
> -			__mnt_make_shortterm(p);
>  		p->mnt_ns = NULL;
>  		list_del_init(&p->mnt_child);
>  		if (mnt_has_parent(p)) {
> @@ -2209,23 +2191,6 @@ static struct mnt_namespace *alloc_mnt_ns(void)
>  	return new_ns;
>  }
>  
> -void mnt_make_longterm(struct vfsmount *mnt)
> -{
> -	__mnt_make_longterm(real_mount(mnt));
> -}
> -
> -void mnt_make_shortterm(struct vfsmount *m)
> -{
> -#ifdef CONFIG_SMP
> -	struct mount *mnt = real_mount(m);
> -	if (atomic_add_unless(&mnt->mnt_longterm, -1, 1))
> -		return;
> -	br_write_lock(&vfsmount_lock);
> -	atomic_dec(&mnt->mnt_longterm);
> -	br_write_unlock(&vfsmount_lock);
> -#endif
> -}
> -
>  /*
>   * Allocate a new namespace structure and populate it with contents
>   * copied from the namespace of the passed in task structure.
> @@ -2265,18 +2230,13 @@ static struct mnt_namespace *dup_mnt_ns(struct mnt_namespace *mnt_ns,
>  	q = new;
>  	while (p) {
>  		q->mnt_ns = new_ns;
> -		__mnt_make_longterm(q);
>  		if (fs) {
>  			if (&p->mnt == fs->root.mnt) {
>  				fs->root.mnt = mntget(&q->mnt);
> -				__mnt_make_longterm(q);
> -				mnt_make_shortterm(&p->mnt);
>  				rootmnt = &p->mnt;
>  			}
>  			if (&p->mnt == fs->pwd.mnt) {
>  				fs->pwd.mnt = mntget(&q->mnt);
> -				__mnt_make_longterm(q);
> -				mnt_make_shortterm(&p->mnt);
>  				pwdmnt = &p->mnt;
>  			}
>  		}
> @@ -2320,7 +2280,6 @@ static struct mnt_namespace *create_mnt_ns(struct vfsmount *m)
>  	if (!IS_ERR(new_ns)) {
>  		struct mount *mnt = real_mount(m);
>  		mnt->mnt_ns = new_ns;
> -		__mnt_make_longterm(mnt);
>  		new_ns->root = mnt;
>  		list_add(&new_ns->list, &mnt->mnt_list);
>  	} else {
> @@ -2615,7 +2574,7 @@ struct vfsmount *kern_mount_data(struct file_system_type *type, void *data)
>  		 * it is a longterm mount, don't release mnt until
>  		 * we unmount before file sys is unregistered
>  		*/
> -		mnt_make_longterm(mnt);
> +		real_mount(mnt)->mnt_ns = MNT_NS_INTERNAL;
>  	}
>  	return mnt;
>  }
> @@ -2625,7 +2584,9 @@ void kern_unmount(struct vfsmount *mnt)
>  {
>  	/* release long term mount so mount point can be released */
>  	if (!IS_ERR_OR_NULL(mnt)) {
> -		mnt_make_shortterm(mnt);
> +		br_write_lock(&vfsmount_lock);
> +		real_mount(mnt)->mnt_ns = NULL;
> +		br_write_unlock(&vfsmount_lock);
>  		mntput(mnt);
>  	}
>  }
> 
