Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab0GGQtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 12:49:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58779 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755711Ab0GGQtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 12:49:07 -0400
Date: Thu, 8 Jul 2010 02:48:59 +1000
From: Nick Piggin <npiggin@suse.de>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de, hooanon05@yahoo.co.jp,
       bfields@fieldses.org, linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V14 04/11] vfs: Allow handle based open on symlinks
Message-ID: <20100707164859.GB9263@laptop>
References: <1276621981-2774-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1276621981-2774-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276621981-2774-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 10:42:54PM +0530, Aneesh Kumar K.V wrote:
> The patch update may_open to allow handle based open on symlinks.
> The file handle based API use file descritor returned from open_by_handle_at
> to do different file system operations. To find the link target name we
> need to get a file descriptor on symlinks.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/namei.c |   17 ++++++++++++++---
>  1 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index c2d19c7..417bf53 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -1422,7 +1422,7 @@ int vfs_create(struct inode *dir, struct dentry *dentry, int mode,
>  	return error;
>  }
>  
> -int may_open(struct path *path, int acc_mode, int flag)
> +static int __may_open(struct path *path, int acc_mode, int flag, int handle)
>  {
>  	struct dentry *dentry = path->dentry;
>  	struct inode *inode = dentry->d_inode;
> @@ -1433,7 +1433,13 @@ int may_open(struct path *path, int acc_mode, int flag)
>  
>  	switch (inode->i_mode & S_IFMT) {
>  	case S_IFLNK:
> -		return -ELOOP;
> +		/*
> +		 * For file handle based open we should allow
> +		 * open of symlink.
> +		 */
> +		if (!handle)
> +			return -ELOOP;
> +		break;
>  	case S_IFDIR:
>  		if (acc_mode & MAY_WRITE)
>  			return -EISDIR;
> @@ -1473,6 +1479,11 @@ int may_open(struct path *path, int acc_mode, int flag)
>  	return break_lease(inode, flag);
>  }
>  
> +int may_open(struct path *path, int acc_mode, int flag)
> +{
> +	return __may_open(path, acc_mode, flag, 0);
> +}

Why don't you just add MAY_OPEN_LNK instead of this ugliness?

