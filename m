Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab2DWLNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 07:13:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab2DWLNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 07:13:21 -0400
Subject: Re: [PATCH] GFS2: Fix mem leak in gfs2_get_acl()
From: Steven Whitehouse <swhiteho@redhat.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
In-Reply-To: <alpine.LNX.2.00.1204212258130.25551@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204212258130.25551@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 23 Apr 2012 12:12:55 +0100
Message-ID: <1335179575.2708.28.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 2012-04-21 at 23:00 +0200, Jesper Juhl wrote:
> If gfs2_xattr_acl_get() returns 0 - which, as far as I can tell, it
> may do independently of having allocated memory for its third argument
> ('data' in this case) - then we may leak the memory allocated to data.
> 
I'm not so sure... in gfs2_xattr_acl_get() we have:

        error = gfs2_ea_find(ip, GFS2_EATYPE_SYS, name, &el);
        if (error)
                return error;
        if (!el.el_ea)
                goto out;
        if (!GFS2_EA_DATA_LEN(el.el_ea))   <---- zero length means return without allocating
                goto out;

        len = GFS2_EA_DATA_LEN(el.el_ea);
        data = kmalloc(len, GFP_NOFS);
etc.

So it looks to me as if we will never have allocated any
data unless the length is greater than zero, unless I've
missed something?

Steve.

> This patch initializes 'data' to NULL so that it will be safe to call
> kfree() on it even if we do not allocate anything and also makes sure
> that we kfree(data) in the 'len == 0' case.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  fs/gfs2/acl.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
>  Note: I have tested that this change compiles. It has seen no other 
>        testing than that.
> 
> diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
> index 230eb0f..d254d98 100644
> --- a/fs/gfs2/acl.c
> +++ b/fs/gfs2/acl.c
> @@ -43,7 +43,7 @@ struct posix_acl *gfs2_get_acl(struct inode *inode, int type)
>  	struct gfs2_inode *ip = GFS2_I(inode);
>  	struct posix_acl *acl;
>  	const char *name;
> -	char *data;
> +	char *data = NULL;
>  	int len;
>  
>  	if (!ip->i_eattr)
> @@ -60,8 +60,10 @@ struct posix_acl *gfs2_get_acl(struct inode *inode, int type)
>  	len = gfs2_xattr_acl_get(ip, name, &data);
>  	if (len < 0)
>  		return ERR_PTR(len);
> -	if (len == 0)
> +	if (len == 0) {
> +		kfree(data);
>  		return NULL;
> +	}
>  
>  	acl = posix_acl_from_xattr(data, len);
>  	kfree(data);
> -- 
> 1.7.10
> 
> 


