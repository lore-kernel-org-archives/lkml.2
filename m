Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036Ab1AMV41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 16:56:27 -0500
Received: from tundra.namei.org ([65.99.196.166]:38567 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932498Ab1AMV4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 16:56:21 -0500
Date: Fri, 14 Jan 2011 08:55:36 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: viro@zeniv.linux.org.uk, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        tomoyo-users-en@lists.sourceforge.jp,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] CacheFiles: Add calls to path-based security hooks [ver
 #2]
In-Reply-To: <20101224144834.22524.86008.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.00.1101140847200.27060@tundra.namei.org>
References: <20101224144834.22524.86008.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Dec 2010, David Howells wrote:

> Add calls to path-based security hooks into CacheFiles as, unlike inode-based
> security, these aren't implicit in the vfs_mkdir() and similar calls.

Adding fsdevel for further review - cachefiles is essentially part of the 
vfs, right ?


> 
> Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  fs/cachefiles/namei.c |   52 +++++++++++++++++++++++++++++++++++++++++--------
>  security/security.c   |    3 +++
>  2 files changed, 47 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
> index 42c7faf..a0358c2 100644
> --- a/fs/cachefiles/namei.c
> +++ b/fs/cachefiles/namei.c
> @@ -275,6 +275,7 @@ static int cachefiles_bury_object(struct cachefiles_cache *cache,
>  				  bool preemptive)
>  {
>  	struct dentry *grave, *trap;
> +	struct path path, path_to_graveyard;
>  	char nbuffer[8 + 8 + 1];
>  	int ret;
>  
> @@ -287,10 +288,18 @@ static int cachefiles_bury_object(struct cachefiles_cache *cache,
>  	/* non-directories can just be unlinked */
>  	if (!S_ISDIR(rep->d_inode->i_mode)) {
>  		_debug("unlink stale object");
> -		ret = vfs_unlink(dir->d_inode, rep);
>  
> -		if (preemptive)
> -			cachefiles_mark_object_buried(cache, rep);
> +		path.mnt = cache->mnt;
> +		path.dentry = dir;
> +		ret = security_path_unlink(&path, rep);
> +		if (ret < 0) {
> +			cachefiles_io_error(cache, "Unlink security error");
> +		} else {
> +			ret = vfs_unlink(dir->d_inode, rep);
> +
> +			if (preemptive)
> +				cachefiles_mark_object_buried(cache, rep);
> +		}
>  
>  		mutex_unlock(&dir->d_inode->i_mutex);
>  
> @@ -379,12 +388,23 @@ try_again:
>  	}
>  
>  	/* attempt the rename */
> -	ret = vfs_rename(dir->d_inode, rep, cache->graveyard->d_inode, grave);
> -	if (ret != 0 && ret != -ENOMEM)
> -		cachefiles_io_error(cache, "Rename failed with error %d", ret);
> +	path.mnt = cache->mnt;
> +	path.dentry = dir;
> +	path_to_graveyard.mnt = cache->mnt;
> +	path_to_graveyard.dentry = cache->graveyard;
> +	ret = security_path_rename(&path, rep, &path_to_graveyard, grave);
> +	if (ret < 0) {
> +		cachefiles_io_error(cache, "Rename security error %d", ret);
> +	} else {
> +		ret = vfs_rename(dir->d_inode, rep,
> +				 cache->graveyard->d_inode, grave);
> +		if (ret != 0 && ret != -ENOMEM)
> +			cachefiles_io_error(cache,
> +					    "Rename failed with error %d", ret);
>  
> -	if (preemptive)
> -		cachefiles_mark_object_buried(cache, rep);
> +		if (preemptive)
> +			cachefiles_mark_object_buried(cache, rep);
> +	}
>  
>  	unlock_rename(cache->graveyard, dir);
>  	dput(grave);
> @@ -448,6 +468,7 @@ int cachefiles_walk_to_object(struct cachefiles_object *parent,
>  {
>  	struct cachefiles_cache *cache;
>  	struct dentry *dir, *next = NULL;
> +	struct path path;
>  	unsigned long start;
>  	const char *name;
>  	int ret, nlen;
> @@ -458,6 +479,7 @@ int cachefiles_walk_to_object(struct cachefiles_object *parent,
>  
>  	cache = container_of(parent->fscache.cache,
>  			     struct cachefiles_cache, cache);
> +	path.mnt = cache->mnt;
>  
>  	ASSERT(parent->dentry);
>  	ASSERT(parent->dentry->d_inode);
> @@ -511,6 +533,10 @@ lookup_again:
>  			if (ret < 0)
>  				goto create_error;
>  
> +			path.dentry = dir;
> +			ret = security_path_mkdir(&path, next, 0);
> +			if (ret < 0)
> +				goto create_error;
>  			start = jiffies;
>  			ret = vfs_mkdir(dir->d_inode, next, 0);
>  			cachefiles_hist(cachefiles_mkdir_histogram, start);
> @@ -536,6 +562,10 @@ lookup_again:
>  			if (ret < 0)
>  				goto create_error;
>  
> +			path.dentry = dir;
> +			ret = security_path_mknod(&path, next, S_IFREG, 0);
> +			if (ret < 0)
> +				goto create_error;
>  			start = jiffies;
>  			ret = vfs_create(dir->d_inode, next, S_IFREG, NULL);
>  			cachefiles_hist(cachefiles_create_histogram, start);
> @@ -692,6 +722,7 @@ struct dentry *cachefiles_get_directory(struct cachefiles_cache *cache,
>  {
>  	struct dentry *subdir;
>  	unsigned long start;
> +	struct path path;
>  	int ret;
>  
>  	_enter(",,%s", dirname);
> @@ -719,6 +750,11 @@ struct dentry *cachefiles_get_directory(struct cachefiles_cache *cache,
>  
>  		_debug("attempt mkdir");
>  
> +		path.mnt = cache->mnt;
> +		path.dentry = dir;
> +		ret = security_path_mkdir(&path, subdir, 0700);
> +		if (ret < 0)
> +			goto mkdir_error;
>  		ret = vfs_mkdir(dir->d_inode, subdir, 0700);
>  		if (ret < 0)
>  			goto mkdir_error;
> diff --git a/security/security.c b/security/security.c
> index 1b798d3..568b98d 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -360,6 +360,7 @@ int security_path_mkdir(struct path *dir, struct dentry *dentry, int mode)
>  		return 0;
>  	return security_ops->path_mkdir(dir, dentry, mode);
>  }
> +EXPORT_SYMBOL(security_path_mkdir);
>  
>  int security_path_rmdir(struct path *dir, struct dentry *dentry)
>  {
> @@ -374,6 +375,7 @@ int security_path_unlink(struct path *dir, struct dentry *dentry)
>  		return 0;
>  	return security_ops->path_unlink(dir, dentry);
>  }
> +EXPORT_SYMBOL(security_path_unlink);
>  
>  int security_path_symlink(struct path *dir, struct dentry *dentry,
>  			  const char *old_name)
> @@ -400,6 +402,7 @@ int security_path_rename(struct path *old_dir, struct dentry *old_dentry,
>  	return security_ops->path_rename(old_dir, old_dentry, new_dir,
>  					 new_dentry);
>  }
> +EXPORT_SYMBOL(security_path_rename);
>  
>  int security_path_truncate(struct path *path)
>  {
> 

-- 
James Morris
<jmorris@namei.org>
