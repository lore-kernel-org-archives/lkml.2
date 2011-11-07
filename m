Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab1KGDFA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 22:05:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60316 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab1KGDE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 22:04:58 -0500
Message-ID: <4EB74A96.2080209@cn.fujitsu.com>
Date: Mon, 07 Nov 2011 11:03:50 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: FNST
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110322 Red Hat/3.1.9-3.el6_0 Thunderbird/3.1.9
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Andy Whitcroft <apw@canonical.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] readlinkat: ensure we return ENOENT for the empty
 pathname for normal lookups
References: <1312455634-16253-1-git-send-email-apw@canonical.com> <1312455634-16253-2-git-send-email-apw@canonical.com>
In-Reply-To: <1312455634-16253-2-git-send-email-apw@canonical.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-07 11:04:52,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-07 11:04:53,
	Serialize complete at 2011-11-07 11:04:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg:

I see that this patch was queued to stable 3.0 and 3.1, and I wanna know
will it be merged to v3.0.9, v3.1.1?

The return value of readlink/readlinkat for the empty pathname had switched
from ENOENT to EINVAL since V2.6.39, and now switched back again....

It is important for LTP to check the return value for this, so can you tell
me, thanks a lot Greg.

Thanks
-Wanlong Gao

> Since the commit below which added O_PATH support to the *at() calls,
> the error return for readlink/readlinkat for the empty pathname has
> switched from ENOENT to EINVAL:
> 
>   commit 65cfc6722361570bfe255698d9cd4dccaf47570d
>   Author: Al Viro <viro@zeniv.linux.org.uk>
>   Date:   Sun Mar 13 15:56:26 2011 -0400
> 
>     readlinkat(), fchownat() and fstatat() with empty relative pathnames
> 
> This is both unexpected for userspace and makes readlink/readlinkat
> inconsistant with all other interfaces; and inconsistant with our stated
> return for these pathnames.
> 
> As the readlinkat call does not have a flags parameter we cannot use
> the AT_EMPTY_PATH approach used in the other calls.  Therefore expose
> whether the original path is infact entry via a new user_path_at_empty()
> path lookup function.  Use this to determine whether to default to EINVAL
> or ENOENT for failures.
> 
> BugLink: http://bugs.launchpad.net/bugs/817187
> Signed-off-by: Andy Whitcroft <apw@canonical.com>
> ---
>  fs/namei.c            |   24 +++++++++++++++++++-----
>  fs/stat.c             |    5 +++--
>  include/linux/namei.h |    1 +
>  3 files changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 445fd5d..9e013b8 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -137,7 +137,8 @@ static int do_getname(const char __user *filename, char *page)
>  	return retval;
>  }
>  
> -static char *getname_flags(const char __user * filename, int flags)
> +static char *getname_flags_empty(const char __user * filename,
> +							int flags, int *empty)
>  {
>  	char *tmp, *result;
>  
> @@ -148,6 +149,8 @@ static char *getname_flags(const char __user * filename, int flags)
>  
>  		result = tmp;
>  		if (retval < 0) {
> +			if (retval == -ENOENT && empty)
> +				*empty = 1;
>  			if (retval != -ENOENT || !(flags & LOOKUP_EMPTY)) {
>  				__putname(tmp);
>  				result = ERR_PTR(retval);
> @@ -158,9 +161,14 @@ static char *getname_flags(const char __user * filename, int flags)
>  	return result;
>  }
>  
> +static char *getname_flags(const char __user * filename, int flags)
> +{
> +	return getname_flags_empty(filename, flags, 0);
> +}
> +
>  char *getname(const char __user * filename)
>  {
> -	return getname_flags(filename, 0);
> +	return getname_flags_empty(filename, 0, 0);
>  }
>  
>  #ifdef CONFIG_AUDITSYSCALL
> @@ -1756,11 +1764,11 @@ struct dentry *lookup_one_len(const char *name, struct dentry *base, int len)
>  	return __lookup_hash(&this, base, NULL);
>  }
>  
> -int user_path_at(int dfd, const char __user *name, unsigned flags,
> -		 struct path *path)
> +int user_path_at_empty(int dfd, const char __user *name, unsigned flags,
> +		 struct path *path, int *empty)
>  {
>  	struct nameidata nd;
> -	char *tmp = getname_flags(name, flags);
> +	char *tmp = getname_flags_empty(name, flags, empty);
>  	int err = PTR_ERR(tmp);
>  	if (!IS_ERR(tmp)) {
>  
> @@ -1774,6 +1782,12 @@ int user_path_at(int dfd, const char __user *name, unsigned flags,
>  	return err;
>  }
>  
> +int user_path_at(int dfd, const char __user *name, unsigned flags,
> +		 struct path *path)
> +{
> +	return user_path_at_empty(dfd, name, flags, path, 0);
> +}
> +
>  static int user_path_parent(int dfd, const char __user *path,
>  			struct nameidata *nd, char **name)
>  {
> diff --git a/fs/stat.c b/fs/stat.c
> index 9610391..4c814bb 100644
> --- a/fs/stat.c
> +++ b/fs/stat.c
> @@ -296,15 +296,16 @@ SYSCALL_DEFINE4(readlinkat, int, dfd, const char __user *, pathname,
>  {
>  	struct path path;
>  	int error;
> +	int empty = 0;
>  
>  	if (bufsiz <= 0)
>  		return -EINVAL;
>  
> -	error = user_path_at(dfd, pathname, LOOKUP_EMPTY, &path);
> +	error = user_path_at_empty(dfd, pathname, LOOKUP_EMPTY, &path, &empty);
>  	if (!error) {
>  		struct inode *inode = path.dentry->d_inode;
>  
> -		error = -EINVAL;
> +		error = (empty) ? -ENOENT : -EINVAL;
>  		if (inode->i_op->readlink) {
>  			error = security_inode_readlink(path.dentry);
>  			if (!error) {
> diff --git a/include/linux/namei.h b/include/linux/namei.h
> index 76fe2c6..c300127 100644
> --- a/include/linux/namei.h
> +++ b/include/linux/namei.h
> @@ -66,6 +66,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
>  #define LOOKUP_EMPTY		0x4000
>  
>  extern int user_path_at(int, const char __user *, unsigned, struct path *);
> +extern int user_path_at_empty(int, const char __user *, unsigned, struct path *, int *empty);
>  
>  #define user_path(name, path) user_path_at(AT_FDCWD, name, LOOKUP_FOLLOW, path)
>  #define user_lpath(name, path) user_path_at(AT_FDCWD, name, 0, path)


