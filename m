Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab0FVTlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 15:41:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750977Ab0FVTla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 15:41:30 -0400
Date: Tue, 22 Jun 2010 12:41:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dave.bueso@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH fs/ramfs] inode.c: Fix incorrect variable freeing.
Message-Id: <20100622124101.0dbb2b3c.akpm@linux-foundation.org>
In-Reply-To: <1277062057.14428.0.camel@cowboy>
References: <1277062057.14428.0.camel@cowboy>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jun 2010 15:27:37 -0400
Davidlohr Bueso <dave.bueso@gmail.com> wrote:

> Hi,
> 
> In ramfs_fill_super(), if fsi's memory allocation fails, it will go to 'fail', 
> which immediately tries to free the variable, potentially producing an Oops. 
> This patch addresses this issue.
> 
> Thanks.
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
>  fs/ramfs/inode.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
> index a5ebae7..40af7a2 100644
> --- a/fs/ramfs/inode.c
> +++ b/fs/ramfs/inode.c
> @@ -219,7 +219,7 @@ int ramfs_fill_super(struct super_block *sb, void *data, int silent)
>  	sb->s_fs_info = fsi;
>  	if (!fsi) {
>  		err = -ENOMEM;
> -		goto fail;
> +		goto fail2;
>  	}
>  
>  	err = ramfs_parse_options(data, &fsi->mount_opts);
> @@ -247,11 +247,13 @@ int ramfs_fill_super(struct super_block *sb, void *data, int silent)
>  	}
>  
>  	return 0;
> -fail:
> -	kfree(fsi);
> +fail2:
>  	sb->s_fs_info = NULL;
>  	iput(inode);
>  	return err;
> +fail:
> +	kfree(fsi);
> +	goto fail2;
>  }
>  
>  int ramfs_get_sb(struct file_system_type *fs_type,

notabug.  kfree(NULL) is an OK thing to do.  The kernel does this
pretty regularly in recovery paths - it usually results in slightly
simpler and slightly smaller code.
