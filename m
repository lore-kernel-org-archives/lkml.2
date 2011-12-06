Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869Ab1LFCex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 21:34:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49791 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850Ab1LFCev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 21:34:51 -0500
Message-ID: <4EDD7F46.1050907@canonical.com>
Date: Mon, 05 Dec 2011 18:34:46 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] __d_path() API change (was Re: [PATCH] Remove use of mnt_ns->root
 and fix a couple of bugs in d_namespace_path)
References: <1323034020-28780-1-git-send-email-john.johansen@canonical.com> <20111204221020.GB2203@ZenIV.linux.org.uk> <20111205032711.GC2203@ZenIV.linux.org.uk>
In-Reply-To: <20111205032711.GC2203@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2011 07:27 PM, Al Viro wrote:
> 	I think I have a saner solution; the root of the problem is that
> __d_path() API is asking for trouble.  What I'm proposing is:
> 
> 	* Give prepend_path() an extra argument for reporting which
> fatherless thing has it reached if it has missed the root - struct
> path *bastard.  struct path *root becomes const on that *and* what
> we put into *bastard is properly grabbed.  We do that only if that
> pointer is not NULL, of course.  In any case we return 1 if we go
> out through global_root:
> 
> 	* modify the callers accordingly; everything except __d_path()
> will simply pass NULL as that extra argument and instead of checking
> if root has been changed, just check if return value was positive.
> 
> 	* __d_path() gets the similar extra argument itself; if it's non-NULL
> and we miss the root, the caller can expect to get (referenced) point where
> the walk has stopped stored there.  _Maybe_ it ought to fill it with
> NULL/NULL otherwise; I've just done that in the only such caller before
> calling __d_path().  If it is NULL *and* root has not been NULL/NULL (i.e.
> we asked for subtree explicitly and have nowhere to put the stopping point),
> we return NULL instead of pointer to relative pathname.
> 
> 	* seq_path_root() does _NOT_ return -ENAMETOOLONG (it's stupid anyway -
> the normal seq_file logics will take care of growing the buffer and redoing
> the call of ->show() just fine).  However, if it gets path not reachable
> from root, it returns SEQ_SKIP.  The only caller adjusted (i.e. stopped
> ignoring the return value as it used to do).
> 
> 	* unlike seq_path_root(), the caller in tomoyo passes NULL/NULL in
> *root (it wants absolute path).  It still calls with bastard == NULL, so
> no references are grabbed.
> 
> 	* apparmor d_namespace_path() calls __d_path() passing it a pointer
> to local struct path to fill.  It's been earlier initialized to NULL/NULL
> (see above in part about __d_path()), so the check for "has it been outside
> of chroot jail" is simply bastard.mnt != NULL after the call.  Moreover,
> in this case it's safe to access vfsmount and dentry; we can do the checks
> just fine, they won't be freed under us.  One more thing - I've exported
> uninlined variant of check_mnt() (called our_mnt(), for obvious reasons)
> and used it here.
> 
> Completely untested patch follows:
> 
Thanks Al, this looks good, and I have been running this one a test box doing
regression testing successfully for hours with one small change in the apparmor
portion of the code which I have included below.

With the apparmor change you can add

Reviewed-by: John Johansen <john.johansen@canonical.com>

> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---

<< snip >>

> --- a/security/apparmor/path.c
> +++ b/security/apparmor/path.c
> @@ -57,23 +57,16 @@ static int prepend(char **buffer, int buflen, const char *str, int namelen)
>  static int d_namespace_path(struct path *path, char *buf, int buflen,
>  			    char **name, int flags)
>  {
> -	struct path root, tmp;
> +	struct path root = {};
> +	struct path bastard = {};
>  	char *res;
> -	int connected, error = 0;
> +	int error = 0;
>  
> -	/* Get the root we want to resolve too, released below */
> -	if (flags & PATH_CHROOT_REL) {
> -		/* resolve paths relative to chroot */
> +	/* resolve paths relative to chroot?*/
> +	if (flags & PATH_CHROOT_REL)
>  		get_fs_root(current->fs, &root);
> -	} else {
> -		/* resolve paths relative to namespace */
> -		root.mnt = current->nsproxy->mnt_ns->root;
> -		root.dentry = root.mnt->mnt_root;
> -		path_get(&root);
> -	}
>  
> -	tmp = root;
> -	res = __d_path(path, &tmp, buf, buflen);
> +	res = __d_path(path, &root, &bastard, buf, buflen);
>  
>  	*name = res;
>  	/* handle error conditions - and still allow a partial path to
> @@ -97,10 +90,7 @@ static int d_namespace_path(struct path *path, char *buf, int buflen,
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
> @@ -111,9 +101,9 @@ static int d_namespace_path(struct path *path, char *buf, int buflen,
>  	 *     of chroot) and specifically directed to connect paths to
>  	 *     namespace root.
>  	 */
> -	if (!connected) {
> +	if (bastard.mnt) {
This doesn't quite match the original !connected check.  It is the same for the case of
flags & PATH_CHROOT_REL (ie. root = current->fs), but for the case where we pass root = { }
bastard.mnt is always true, while in the old !connected case, it would only be true if
!our_mnt(bastard).

This isn't entirely covered by the subsequent check
			   !(((flags & CHROOT_NSCONNECT) == CHROOT_NSCONNECT) &&
			     our_mnt(bastard.mnt))) {

which means apparmor ends up treating the path as disconnected when it shouldn't.
This can be fixed by changing the check to

-	if (!connected) {
+	if (bastard.mnt && (root.mnt || !our_mnt(bastard.mnt)) {

I will send a separate patch to kill
			   !(((flags & CHROOT_NSCONNECT) == CHROOT_NSCONNECT) &&
			     our_mnt(bastard.mnt))

as its an unused vestige which isn't even possible, and was missed being removed during
code cleanup.

>  		/* is the disconnect path a sysctl? */
> -		if (tmp.dentry->d_sb->s_magic == PROC_SUPER_MAGIC &&
> +		if (bastard.dentry->d_sb->s_magic == PROC_SUPER_MAGIC &&
>  		    strncmp(*name, "/sys/", 5) == 0) {
>  			/* TODO: convert over to using a per namespace
>  			 * control instead of hard coded /proc
> @@ -121,8 +111,7 @@ static int d_namespace_path(struct path *path, char *buf, int buflen,
>  			error = prepend(name, *name - buf, "/proc", 5);
>  		} else if (!(flags & PATH_CONNECT_PATH) &&
>  			   !(((flags & CHROOT_NSCONNECT) == CHROOT_NSCONNECT) &&
> -			     (tmp.mnt == current->nsproxy->mnt_ns->root &&
> -			      tmp.dentry == tmp.mnt->mnt_root))) {
> +			     our_mnt(bastard.mnt))) {
>  			/* disconnected path, don't return pathname starting
>  			 * with '/'
>  			 */
> @@ -133,7 +122,10 @@ static int d_namespace_path(struct path *path, char *buf, int buflen,
>  	}
>  
>  out:
> -	path_put(&root);
> +	if (bastard.mnt)
> +		path_put(&bastard);
> +	if (flags & PATH_CHROOT_REL)
> +		path_put(&root);
>  
>  	return error;
>  }
