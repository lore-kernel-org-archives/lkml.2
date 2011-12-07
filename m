Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab1LGDLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 22:11:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45568 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab1LGDLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 22:11:51 -0500
Message-ID: <4EDED96E.7000106@canonical.com>
Date: Tue, 06 Dec 2011 19:11:42 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] apparmor fix for __d_path() misuse
References: <20111206205346.GK2203@ZenIV.linux.org.uk> <CA+55aFwbWUBs3Fy1hyP3CQ15rF2opvjxLR8gnSF5gERDGCGhOw@mail.gmail.com> <4EDE94DC.8010106@canonical.com> <20111206224100.GM2203@ZenIV.linux.org.uk> <4EDEA152.90804@canonical.com> <CA+55aFwn=n5H_PuaRhnVPpMtfeig8nSi+Wj4Yzv6VBdjkUBEjw@mail.gmail.com> <20111207001643.GN2203@ZenIV.linux.org.uk> <20111207003922.GO2203@ZenIV.linux.org.uk> <CA+55aFyaz7K4V5xLmaQ9GK=5LA1mbRdVGCFspET=y6ode_i=jg@mail.gmail.com> <20111207011047.GQ2203@ZenIV.linux.org.uk> <20111207013720.GS2203@ZenIV.linux.org.uk>
In-Reply-To: <20111207013720.GS2203@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 05:37 PM, Al Viro wrote:
> On Wed, Dec 07, 2011 at 01:10:47AM +0000, Al Viro wrote:
> 
>> So let's add d_absolute_path(path, buf, buflen).  Having it check that
>> we'd walked to something mounted.  And returning NULL otherwise.  _Never_
> 
> Turns out that returning ERR_PTR(-EINVAL) is more convenient.
> All right, here's a variant that does *NOT* return any vfsmount/dentry
> pointers at all.  And it does best-sane-effort wrt returning the pathname;
> i.e. if it *is* something outside of chroot, that absolute pathname is
> what we'll get.
> 
I haven't had a chance to build and test yet but this looks good to me.  I do
think splitting the two uses cases makes sense.  I am building a kernel now
and will update when I am done with it.



> diff --git a/fs/dcache.c b/fs/dcache.c
> index 10ba92d..89509b5 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -2439,16 +2439,14 @@ static int prepend_name(char **buffer, int *buflen, struct qstr *name)
>  /**
>   * prepend_path - Prepend path string to a buffer
>   * @path: the dentry/vfsmount to report
> - * @root: root vfsmnt/dentry (may be modified by this function)
> + * @root: root vfsmnt/dentry
>   * @buffer: pointer to the end of the buffer
>   * @buflen: pointer to buffer length
>   *
>   * Caller holds the rename_lock.
> - *
> - * If path is not reachable from the supplied root, then the value of
> - * root is changed (without modifying refcounts).
>   */
> -static int prepend_path(const struct path *path, struct path *root,
> +static int prepend_path(const struct path *path,
> +			const struct path *root,
>  			char **buffer, int *buflen)
>  {
>  	struct dentry *dentry = path->dentry;
> @@ -2483,10 +2481,10 @@ static int prepend_path(const struct path *path, struct path *root,
>  		dentry = parent;
>  	}
>  
> -out:
>  	if (!error && !slash)
>  		error = prepend(buffer, buflen, "/", 1);
>  
> +out:
>  	br_read_unlock(vfsmount_lock);
>  	return error;
>  
> @@ -2500,15 +2498,17 @@ global_root:
>  		WARN(1, "Root dentry has weird name <%.*s>\n",
>  		     (int) dentry->d_name.len, dentry->d_name.name);
>  	}
> -	root->mnt = vfsmnt;
> -	root->dentry = dentry;
> +	if (!slash)
> +		error = prepend(buffer, buflen, "/", 1);
> +	if (!error)
> +		error = vfsmnt->mnt_ns ? 1 : 2;
>  	goto out;
>  }
>  
>  /**
>   * __d_path - return the path of a dentry
>   * @path: the dentry/vfsmount to report
> - * @root: root vfsmnt/dentry (may be modified by this function)
> + * @root: root vfsmnt/dentry
>   * @buf: buffer to return value in
>   * @buflen: buffer length
>   *
> @@ -2519,10 +2519,10 @@ global_root:
>   *
>   * "buflen" should be positive.
>   *
> - * If path is not reachable from the supplied root, then the value of
> - * root is changed (without modifying refcounts).
> + * If the path is not reachable from the supplied root, return %NULL.
>   */
> -char *__d_path(const struct path *path, struct path *root,
> +char *__d_path(const struct path *path,
> +	       const struct path *root,
>  	       char *buf, int buflen)
>  {
>  	char *res = buf + buflen;
> @@ -2533,7 +2533,28 @@ char *__d_path(const struct path *path, struct path *root,
>  	error = prepend_path(path, root, &res, &buflen);
>  	write_sequnlock(&rename_lock);
>  
> -	if (error)
> +	if (error < 0)
> +		return ERR_PTR(error);
> +	if (error > 0)
> +		return NULL;
> +	return res;
> +}
> +
> +char *d_absolute_path(const struct path *path,
> +	       char *buf, int buflen)
> +{
> +	struct path root = {};
> +	char *res = buf + buflen;
> +	int error;
> +
> +	prepend(&res, &buflen, "\0", 1);
> +	write_seqlock(&rename_lock);
> +	error = prepend_path(path, &root, &res, &buflen);
> +	write_sequnlock(&rename_lock);
> +
> +	if (error > 1)
> +		error = -EINVAL;
> +	if (error < 0)
>  		return ERR_PTR(error);
>  	return res;
>  }
> @@ -2541,8 +2562,9 @@ char *__d_path(const struct path *path, struct path *root,
>  /*
>   * same as __d_path but appends "(deleted)" for unlinked files.
>   */
> -static int path_with_deleted(const struct path *path, struct path *root,
> -				 char **buf, int *buflen)
> +static int path_with_deleted(const struct path *path,
> +			     const struct path *root,
> +			     char **buf, int *buflen)
>  {
>  	prepend(buf, buflen, "\0", 1);
>  	if (d_unlinked(path->dentry)) {
> @@ -2579,7 +2601,6 @@ char *d_path(const struct path *path, char *buf, int buflen)
>  {
>  	char *res = buf + buflen;
>  	struct path root;
> -	struct path tmp;
>  	int error;
>  
>  	/*
> @@ -2594,9 +2615,8 @@ char *d_path(const struct path *path, char *buf, int buflen)
>  
>  	get_fs_root(current->fs, &root);
>  	write_seqlock(&rename_lock);
> -	tmp = root;
> -	error = path_with_deleted(path, &tmp, &res, &buflen);
> -	if (error)
> +	error = path_with_deleted(path, &root, &res, &buflen);
> +	if (error < 0)
>  		res = ERR_PTR(error);
>  	write_sequnlock(&rename_lock);
>  	path_put(&root);
> @@ -2617,7 +2637,6 @@ char *d_path_with_unreachable(const struct path *path, char *buf, int buflen)
>  {
>  	char *res = buf + buflen;
>  	struct path root;
> -	struct path tmp;
>  	int error;
>  
>  	if (path->dentry->d_op && path->dentry->d_op->d_dname)
> @@ -2625,9 +2644,8 @@ char *d_path_with_unreachable(const struct path *path, char *buf, int buflen)
>  
>  	get_fs_root(current->fs, &root);
>  	write_seqlock(&rename_lock);
> -	tmp = root;
> -	error = path_with_deleted(path, &tmp, &res, &buflen);
> -	if (!error && !path_equal(&tmp, &root))
> +	error = path_with_deleted(path, &root, &res, &buflen);
> +	if (error > 0)
>  		error = prepend_unreachable(&res, &buflen);
>  	write_sequnlock(&rename_lock);
>  	path_put(&root);
> @@ -2758,19 +2776,18 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
>  	write_seqlock(&rename_lock);
>  	if (!d_unlinked(pwd.dentry)) {
>  		unsigned long len;
> -		struct path tmp = root;
>  		char *cwd = page + PAGE_SIZE;
>  		int buflen = PAGE_SIZE;
>  
>  		prepend(&cwd, &buflen, "\0", 1);
> -		error = prepend_path(&pwd, &tmp, &cwd, &buflen);
> +		error = prepend_path(&pwd, &root, &cwd, &buflen);
>  		write_sequnlock(&rename_lock);
>  
> -		if (error)
> +		if (error < 0)
>  			goto out;
>  
>  		/* Unreachable from current root */
> -		if (!path_equal(&tmp, &root)) {
> +		if (error > 0) {
>  			error = prepend_unreachable(&cwd, &buflen);
>  			if (error)
>  				goto out;
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 6d3a196..cfc6d44 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1048,15 +1048,12 @@ static int show_mountinfo(struct seq_file *m, void *v)
>  	if (err)
>  		goto out;
>  	seq_putc(m, ' ');
> -	seq_path_root(m, &mnt_path, &root, " \t\n\\");
> -	if (root.mnt != p->root.mnt || root.dentry != p->root.dentry) {
> -		/*
> -		 * Mountpoint is outside root, discard that one.  Ugly,
> -		 * but less so than trying to do that in iterator in a
> -		 * race-free way (due to renames).
> -		 */
> -		return SEQ_SKIP;
> -	}
> +
> +	/* mountpoints outside of chroot jail will give SEQ_SKIP on this */
> +	err = seq_path_root(m, &mnt_path, &root, " \t\n\\");
> +	if (err)
> +		goto out;
> +
>  	seq_puts(m, mnt->mnt_flags & MNT_READONLY ? " ro" : " rw");
>  	show_mnt_opts(m, mnt);
>  
> @@ -2776,3 +2773,8 @@ void kern_unmount(struct vfsmount *mnt)
>  	}
>  }
>  EXPORT_SYMBOL(kern_unmount);
> +
> +bool our_mnt(struct vfsmount *mnt)
> +{
> +	return check_mnt(mnt);
> +}
> diff --git a/fs/seq_file.c b/fs/seq_file.c
> index 05d6b0e..dba43c3 100644
> --- a/fs/seq_file.c
> +++ b/fs/seq_file.c
> @@ -449,8 +449,6 @@ EXPORT_SYMBOL(seq_path);
>  
>  /*
>   * Same as seq_path, but relative to supplied root.
> - *
> - * root may be changed, see __d_path().
>   */
>  int seq_path_root(struct seq_file *m, struct path *path, struct path *root,
>  		  char *esc)
> @@ -463,6 +461,8 @@ int seq_path_root(struct seq_file *m, struct path *path, struct path *root,
>  		char *p;
>  
>  		p = __d_path(path, root, buf, size);
> +		if (!p)
> +			return SEQ_SKIP;
>  		res = PTR_ERR(p);
>  		if (!IS_ERR(p)) {
>  			char *end = mangle_path(buf, p, esc);
> @@ -474,7 +474,7 @@ int seq_path_root(struct seq_file *m, struct path *path, struct path *root,
>  	}
>  	seq_commit(m, res);
>  
> -	return res < 0 ? res : 0;
> +	return res < 0 && res != -ENAMETOOLONG ? res : 0;
>  }
>  
>  /*
> diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> index 4df9261..ed9f74f 100644
> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -339,7 +339,8 @@ extern int d_validate(struct dentry *, struct dentry *);
>   */
>  extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
>  
> -extern char *__d_path(const struct path *path, struct path *root, char *, int);
> +extern char *__d_path(const struct path *, const struct path *, char *, int);
> +extern char *d_absolute_path(const struct path *, char *, int);
>  extern char *d_path(const struct path *, char *, int);
>  extern char *d_path_with_unreachable(const struct path *, char *, int);
>  extern char *dentry_path_raw(struct dentry *, char *, int);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index e313022..019dc55 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1942,6 +1942,7 @@ extern int fd_statfs(int, struct kstatfs *);
>  extern int statfs_by_dentry(struct dentry *, struct kstatfs *);
>  extern int freeze_super(struct super_block *super);
>  extern int thaw_super(struct super_block *super);
> +extern bool our_mnt(struct vfsmount *mnt);
>  
>  extern int current_umask(void);
>  
> diff --git a/security/apparmor/path.c b/security/apparmor/path.c
> index 36cc0cc..b566eba 100644
> --- a/security/apparmor/path.c
> +++ b/security/apparmor/path.c
> @@ -57,23 +57,44 @@ static int prepend(char **buffer, int buflen, const char *str, int namelen)
>  static int d_namespace_path(struct path *path, char *buf, int buflen,
>  			    char **name, int flags)
>  {
> -	struct path root, tmp;
>  	char *res;
> -	int connected, error = 0;
> +	int error = 0;
> +	int connected = 1;
> +
> +	if (path->mnt->mnt_flags & MNT_INTERNAL) {
> +		/* it's not mounted anywhere */
> +		res = dentry_path(path->dentry, buf, buflen);
> +		*name = res;
> +		if (IS_ERR(res)) {
> +			*name = buf;
> +			return PTR_ERR(res);
> +		}
> +		if (path->dentry->d_sb->s_magic == PROC_SUPER_MAGIC &&
> +		    strncmp(*name, "/sys/", 5) == 0) {
> +			/* TODO: convert over to using a per namespace
> +			 * control instead of hard coded /proc
> +			 */
> +			return prepend(name, *name - buf, "/proc", 5);
> +		}
> +		return 0;
> +	}
>  
> -	/* Get the root we want to resolve too, released below */
> +	/* resolve paths relative to chroot?*/
>  	if (flags & PATH_CHROOT_REL) {
> -		/* resolve paths relative to chroot */
> +		struct path root;
>  		get_fs_root(current->fs, &root);
> -	} else {
> -		/* resolve paths relative to namespace */
> -		root.mnt = current->nsproxy->mnt_ns->root;
> -		root.dentry = root.mnt->mnt_root;
> -		path_get(&root);
> +		res = __d_path(path, &root, buf, buflen);
> +		if (res && !IS_ERR(res)) {
> +			/* everything's fine */
> +			*name = res;
> +			path_put(&root);
> +			goto ok;
> +		}
> +		path_put(&root);
> +		connected = 0;
>  	}
>  
> -	tmp = root;
> -	res = __d_path(path, &tmp, buf, buflen);
> +	res = d_absolute_path(path, buf, buflen);
>  
>  	*name = res;
>  	/* handle error conditions - and still allow a partial path to
> @@ -84,7 +105,10 @@ static int d_namespace_path(struct path *path, char *buf, int buflen,
>  		*name = buf;
>  		goto out;
>  	}
> +	if (!our_mnt(path->mnt))
> +		connected = 0;
>  
> +ok:
>  	/* Handle two cases:
>  	 * 1. A deleted dentry && profile is not allowing mediation of deleted
>  	 * 2. On some filesystems, newly allocated dentries appear to the
> @@ -97,10 +121,7 @@ static int d_namespace_path(struct path *path, char *buf, int buflen,
>  			goto out;
>  	}
>  
> -	/* Determine if the path is connected to the expected root */
> -	connected = tmp.dentry == root.dentry && tmp.mnt == root.mnt;
> -
> -	/* If the path is not connected,
> +	/* If the path is not connected to the expected root,
>  	 * check if it is a sysctl and handle specially else remove any
>  	 * leading / that __d_path may have returned.
>  	 * Unless
> @@ -112,17 +133,9 @@ static int d_namespace_path(struct path *path, char *buf, int buflen,
>  	 *     namespace root.
>  	 */
>  	if (!connected) {
> -		/* is the disconnect path a sysctl? */
> -		if (tmp.dentry->d_sb->s_magic == PROC_SUPER_MAGIC &&
> -		    strncmp(*name, "/sys/", 5) == 0) {
> -			/* TODO: convert over to using a per namespace
> -			 * control instead of hard coded /proc
> -			 */
> -			error = prepend(name, *name - buf, "/proc", 5);
> -		} else if (!(flags & PATH_CONNECT_PATH) &&
> +		if (!(flags & PATH_CONNECT_PATH) &&
>  			   !(((flags & CHROOT_NSCONNECT) == CHROOT_NSCONNECT) &&
> -			     (tmp.mnt == current->nsproxy->mnt_ns->root &&
> -			      tmp.dentry == tmp.mnt->mnt_root))) {
> +			     our_mnt(path->mnt))) {
>  			/* disconnected path, don't return pathname starting
>  			 * with '/'
>  			 */
> @@ -133,8 +146,6 @@ static int d_namespace_path(struct path *path, char *buf, int buflen,
>  	}
>  
>  out:
> -	path_put(&root);
> -
>  	return error;
>  }
>  
> diff --git a/security/tomoyo/realpath.c b/security/tomoyo/realpath.c
> index 738bbdf..36fa7c9 100644
> --- a/security/tomoyo/realpath.c
> +++ b/security/tomoyo/realpath.c
> @@ -101,9 +101,8 @@ static char *tomoyo_get_absolute_path(struct path *path, char * const buffer,
>  {
>  	char *pos = ERR_PTR(-ENOMEM);
>  	if (buflen >= 256) {
> -		struct path ns_root = { };
>  		/* go to whatever namespace root we are under */
> -		pos = __d_path(path, &ns_root, buffer, buflen - 1);
> +		pos = d_absolute_path(path, buffer, buflen - 1);
>  		if (!IS_ERR(pos) && *pos == '/' && pos[1]) {
>  			struct inode *inode = path->dentry->d_inode;
>  			if (inode && S_ISDIR(inode->i_mode)) {

