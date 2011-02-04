Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab1BDSL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 13:11:28 -0500
Received: from fieldses.org ([174.143.236.118]:39365 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207Ab1BDSL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 13:11:27 -0500
Date: Fri, 4 Feb 2011 13:11:16 -0500
To: Andrey Vagin <avagin@openvz.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: Correctly check d_find_alias() return code in
 devpts_pty_kill
Message-ID: <20110204181116.GA12304@fieldses.org>
References: <1296833307-22549-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296833307-22549-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 04, 2011 at 06:28:26PM +0300, Andrey Vagin wrote:
> d_find_alias() return NULL in case error, but we expected errno in
> devpts_pty_kill.

Possibly dumb question: can d_find_alias() actually fail here?

--b.

> 
> Signed-off-by: Andrey Vagin <avagin@openvz.org>
> ---
>  fs/devpts/inode.c |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
> index 8392c8c..530b1f1 100644
> --- a/fs/devpts/inode.c
> +++ b/fs/devpts/inode.c
> @@ -544,14 +544,12 @@ void devpts_pty_kill(struct tty_struct *tty)
>  	mutex_lock(&root->d_inode->i_mutex);
>  
>  	dentry = d_find_alias(inode);
> -	if (IS_ERR(dentry))
> +	if (!dentry)
>  		goto out;
>  
> -	if (dentry) {
> -		inode->i_nlink--;
> -		d_delete(dentry);
> -		dput(dentry);	/* d_alloc_name() in devpts_pty_new() */
> -	}
> +	inode->i_nlink--;
> +	d_delete(dentry);
> +	dput(dentry);	/* d_alloc_name() in devpts_pty_new() */
>  
>  	dput(dentry);		/* d_find_alias above */
>  out:
> -- 
> 1.7.2.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
