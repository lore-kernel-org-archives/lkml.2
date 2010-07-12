Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0GLIXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 04:23:50 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:37441 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab0GLIXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 04:23:48 -0400
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@suse.de, hooanon05@yahoo.co.jp,
        bfields@fieldses.org, linux-fsdevel@vger.kernel.org,
        sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com
In-reply-to: <1278916545-19751-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V16 04/12] vfs: Allow handle based open on symlinks
References: <1278916545-19751-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1278916545-19751-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Message-Id: <E1OYEIL-0005si-EO@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 12 Jul 2010 10:23:21 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010, Aneesh Kumar K.V wrote:
> The patch update may_open to allow handle based open on symlinks.
> The file handle based API use file descritor returned from open_by_handle_at
> to do different file system operations. To find the link target name we
> need to get a file descriptor on symlinks.
> 
> We should be able to read the link target using file handle. The exact
> usecase is with respect to implementing READLINK operation on a
> userspace NFS server. The request contain the file handle and the
> response include target name.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/namei.c         |   10 +++++++++-
>  fs/open.c          |    9 ++++++++-
>  include/linux/fs.h |    1 +
>  3 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 4d590a3..a6a8093 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -1456,7 +1456,15 @@ int may_open(struct path *path, int acc_mode, int flag)
>  
>  	switch (inode->i_mode & S_IFMT) {
>  	case S_IFLNK:
> -		return -ELOOP;
> +		/*
> +		 * Allow only if acc_mode contain
> +		 * open link request and read request.
> +		 */
> +		if (acc_mode != (MAY_OPEN_LINK | MAY_READ))

Why require MAY_READ?

Actually, open_by_handle() should be a good place to start supporting
O_NOACCESS from the start.  I.e. neigher read, nor write access is
permitted on the file.


> +			return -ELOOP;
> +		if (flag != O_RDONLY)
> +			return -ELOOP;
> +		break;
>  	case S_IFDIR:
>  		if (acc_mode & MAY_WRITE)
>  			return -EISDIR;
> diff --git a/fs/open.c b/fs/open.c
> index df5d21e..afb089e 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -1268,8 +1268,15 @@ static long do_sys_open_by_handle(int mountdirfd,
>  	 */
>  	if (open_flag & __O_SYNC)
>  		open_flag |= O_DSYNC;
> +	/*
> +	 * Handle based API allow open on a symlink
> +	 */
> +	if (S_ISLNK(path->dentry->d_inode->i_mode))
> +		acc_mode = MAY_OPEN_LINK;
> +	else
> +		acc_mode = MAY_OPEN;
>  
> -	acc_mode = MAY_OPEN | ACC_MODE(open_flag);
> +	acc_mode |= ACC_MODE(open_flag);
>  
>  	/* O_TRUNC implies we need access checks for write permissions */
>  	if (open_flag & O_TRUNC)
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index a458b4e..08afa72 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -53,6 +53,7 @@ struct inodes_stat_t {
>  #define MAY_APPEND 8
>  #define MAY_ACCESS 16
>  #define MAY_OPEN 32
> +#define MAY_OPEN_LINK 64
>  
>  /*
>   * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must correspond
> -- 
> 1.7.2.rc1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
