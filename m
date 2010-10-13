Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab0JMLeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 07:34:05 -0400
Received: from canuck.infradead.org ([134.117.69.58]:47365 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab0JMLeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 07:34:02 -0400
Date: Wed, 13 Oct 2010 07:34:02 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/18] exofs: use iput() for inode reference count
 decrements
Message-ID: <20101013113402.GC19456@infradead.org>
References: <1286928961-15157-1-git-send-email-david@fromorbit.com>
 <1286928961-15157-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286928961-15157-7-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, this looks like a nasty enough bug that it might be worth queing
up for 2.6.36.

On Wed, Oct 13, 2010 at 11:15:49AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Direct modification of the inode reference count is a no-no. Convert
> the exofs decrements to call iput() instead of acting directly on
> i_count.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/exofs/inode.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
> index b631ff3..0fb4d4c 100644
> --- a/fs/exofs/inode.c
> +++ b/fs/exofs/inode.c
> @@ -1101,7 +1101,7 @@ static void create_done(struct exofs_io_state *ios, void *p)
>  
>  	set_obj_created(oi);
>  
> -	atomic_dec(&inode->i_count);
> +	iput(inode);
>  	wake_up(&oi->i_wq);
>  }
>  
> @@ -1161,7 +1161,7 @@ struct inode *exofs_new_inode(struct inode *dir, int mode)
>  	ios->cred = oi->i_cred;
>  	ret = exofs_sbi_create(ios);
>  	if (ret) {
> -		atomic_dec(&inode->i_count);
> +		iput(inode);
>  		exofs_put_io_state(ios);
>  		return ERR_PTR(ret);
>  	}
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
