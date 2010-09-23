Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab0IWUT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 16:19:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756550Ab0IWUT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 16:19:58 -0400
Date: Thu, 23 Sep 2010 16:19:19 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de,
        viro@zeniv.linux.org.uk, stable@kernel.org
Subject: Re: [PATCH 5/7 v3] vfs: fix possible use after free in finish_open()
Message-ID: <20100923201919.GC3536@shell>
References: <20100920180404.939991832@szeredi.hu> <20100920180446.104998543@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100920180446.104998543@szeredi.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 08:04:09PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> If open(O_TRUNC) is called and the actual open fails, then nd->path
> will be released by nameidata_to_filp().  If this races with an
> unmount then mnt_drop_write() can Oops.
> 
> Fix by acquiring a ref to nd->path and releasing after
> mnt_drop_write().
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> CC: stable@kernel.org
> ---
>  fs/namei.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/fs/namei.c
> ===================================================================
> --- linux-2.6.orig/fs/namei.c	2010-09-20 13:32:35.000000000 +0200
> +++ linux-2.6/fs/namei.c	2010-09-20 13:33:14.000000000 +0200
> @@ -1559,6 +1559,11 @@ static struct file *finish_open(struct n
>  			mnt_drop_write(nd->path.mnt);
>  		goto exit;
>  	}
> +	if (will_truncate) {
> +		/* nameidata_to_filp() puts nd->path! */
> +		path_get(&nd->path);
> +	}
> +
>  	filp = nameidata_to_filp(nd);
>  	if (!IS_ERR(filp)) {
>  		error = ima_file_check(filp, acc_mode);
> @@ -1581,8 +1586,10 @@ static struct file *finish_open(struct n
>  	 * because the filp has had a write taken
>  	 * on its behalf.
>  	 */
> -	if (will_truncate)
> +	if (will_truncate) {
>  		mnt_drop_write(nd->path.mnt);
> +		path_put(&nd->path);
> +	}
>  	return filp;
>  
>  exit:
> 

Nice catch!

Reviewed-by: Valerie Aurora <vaurora@redhat.com>

-VAL
