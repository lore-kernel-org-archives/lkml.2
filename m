Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab2HBSfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 14:35:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab2HBSfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 14:35:04 -0400
Message-ID: <1343932497.2605.1.camel@localhost>
Subject: Re: Oops in audit_copy_inode
From: Eric Paris <eparis@redhat.com>
To: Miklos Szeredi <mszeredi@suse.cz>
Cc: Peter Moody <pmoody@google.com>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@google.com>, viro@zeniv.linux.org.uk,
        miklos@szeredi.hu, jlayton@redhat.com, linux-fsdevel@vger.kernel.org
Date: Thu, 02 Aug 2012 14:34:57 -0400
In-Reply-To: <1343837499.18359.7.camel@tucsk.pomaz.szeredi.hu>
References: <CALnj_=4r0qdrNUbXmS=q=sk11PZ-Q0z=wPO5wR_DzR4HjnMdqw@mail.gmail.com>
	 <CALnj_=5qfAxtKN_T+eoAPCswZPrWmKmOK5HSTwCNZV0s08f_qw@mail.gmail.com>
	 <1343837499.18359.7.camel@tucsk.pomaz.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe this was already found and fixed:

https://lkml.org/lkml/2012/7/25/259

Which was pulled by Linus in:

3134f37e931d75931bdf6d4eacd82a3fd26eca7c

-Eric

On Wed, 2012-08-01 at 18:11 +0200, Miklos Szeredi wrote:
> Hi Peter,
> 
> Thanks for the report.
> 
> Here's a patch.  I haven't tested it but I'm pretty confident that it
> fixes the bug.
> 
> Thanks,
> Miklos
> 
> 
> Subject: vfs: fix audit_inode on negative dentry
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Peter Moody reported an oops in audit_copy_inode() and bisected it to commit
> 7157486541 (vfs: do_last(): common slow lookup).
> 
> The problem is that audit_inode() in do_last() is called with a negative dentry.
> 
> Previously the non-O_CREAT case didn't call audit_inode() here, but now both
> O_CREAT and non-O_CREAT opens are handled by the same code.
> 
> I really have no idea why this audit_inode() is needed here at all but am afaid
> to remove this for fear of breaking audit somehow.  So just fix this case by
> checking for a negative dentry.
> 
> Reported-by: Peter Moody <pmoody@google.com>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> CC: stable@vger.kernel.org
> ---
>  fs/namei.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/fs/namei.c
> ===================================================================
> --- linux-2.6.orig/fs/namei.c	2012-08-01 17:47:28.000000000 +0200
> +++ linux-2.6/fs/namei.c	2012-08-01 17:49:26.000000000 +0200
> @@ -2607,10 +2607,12 @@ static int do_last(struct nameidata *nd,
>  		goto finish_open_created;
>  	}
>  
> -	/*
> -	 * It already exists.
> -	 */
> -	audit_inode(pathname, path->dentry);
> +	if (path->dentry->d_inode) {
> +		/*
> +		 * It already exists.
> +		 */
> +		audit_inode(pathname, path->dentry);
> +	}
>  
>  	/*
>  	 * If atomic_open() acquired write access it is dropped now due to
> 
> 


