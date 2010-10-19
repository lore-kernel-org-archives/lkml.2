Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab0JSKQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 06:16:55 -0400
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:48137 "HELO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750871Ab0JSKQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:16:54 -0400
Message-ID: <4CBD7013.1030709@panasas.com>
Date: Tue, 19 Oct 2010 12:16:51 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: npiggin@kernel.dk
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 08/35] fs: icache lock i_count
References: <20101019034216.319085068@kernel.dk> <20101019034656.303425354@kernel.dk>
In-Reply-To: <20101019034656.303425354@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Oct 2010 10:16:53.0005 (UTC) FILETIME=[C01B9BD0:01CB6F76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2010 05:42 AM, npiggin@kernel.dk wrote:
> Protect inode->i_count with i_lock, rather than having it atomic.
> 
> Signed-off-by: Nick Piggin <npiggin@kernel.dk>
> 
> ---
<>
>  fs/exofs/inode.c                         |   12 +++++++---
>  fs/exofs/namei.c                         |    4 ++-
<>
> Index: linux-2.6/fs/exofs/inode.c
> ===================================================================
> --- linux-2.6.orig/fs/exofs/inode.c	2010-10-19 14:17:26.000000000 +1100
> +++ linux-2.6/fs/exofs/inode.c	2010-10-19 14:19:18.000000000 +1100
> @@ -1107,7 +1107,9 @@
>  

Hi Nick, Please use -p option in your diff(s) it is a bit hard to follow
and review without the proper function context. These patches are on a git
tree. Why don't you use git to produce and send these patches?

>  	set_obj_created(oi);
>  
> -	atomic_dec(&inode->i_count);
> +	spin_lock(&inode->i_lock);
> +	inode->i_count--;
> +	spin_unlock(&inode->i_lock);

I've queued up a patch in Linux-next that will conflict with this.
The patch uses iput() instead.

>  	wake_up(&oi->i_wq);
>  }
>  
> @@ -1160,14 +1162,18 @@
>  	/* increment the refcount so that the inode will still be around when we
>  	 * reach the callback
>  	 */
> -	atomic_inc(&inode->i_count);
> +	spin_lock(&inode->i_lock);
> +	inode->i_count++;
> +	spin_unlock(&inode->i_lock);
>  
>  	ios->done = create_done;
>  	ios->private = inode;
>  	ios->cred = oi->i_cred;
>  	ret = exofs_sbi_create(ios);
>  	if (ret) {
> -		atomic_dec(&inode->i_count);
> +		spin_lock(&inode->i_lock);
> +		inode->i_count--;
> +		spin_unlock(&inode->i_lock);

Here too. (iput)

>  		exofs_put_io_state(ios);
>  		return ERR_PTR(ret);
>  	}
> Index: linux-2.6/fs/exofs/namei.c
> ===================================================================
> --- linux-2.6.orig/fs/exofs/namei.c	2010-10-19 14:17:26.000000000 +1100
> +++ linux-2.6/fs/exofs/namei.c	2010-10-19 14:19:18.000000000 +1100
> @@ -153,7 +153,9 @@
>  
>  	inode->i_ctime = CURRENT_TIME;
>  	inode_inc_link_count(inode);
> -	atomic_inc(&inode->i_count);
> +	spin_lock(&inode->i_lock);
> +	inode->i_count++;

All these will change to inode_get(), right?

> +	spin_unlock(&inode->i_lock);
>  
>  	return exofs_add_nondir(dentry, inode);
>  }

Thanks
Boaz
