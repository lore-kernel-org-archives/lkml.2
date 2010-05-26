Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814Ab0EZKaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 06:30:05 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:37307 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242Ab0EZKaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 06:30:03 -0400
To: Changli Gao <xiaosuo@gmail.com>
CC: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, xiaosuo@gmail.com
In-reply-to: <1274867768-3011-1-git-send-email-xiaosuo@gmail.com> (message
	from Changli Gao on Wed, 26 May 2010 17:56:08 +0800)
Subject: Re: [PATCH 2/3] splice: allow non-block splice only when in file is seekable
References: <1274867768-3011-1-git-send-email-xiaosuo@gmail.com>
Message-Id: <E1OHDru-0000Ge-Lr@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 26 May 2010 12:29:46 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010, Changli Gao wrote:
> allow non-block splice only when in file is seekable.
> 
> do_splice_to() is split to two parts: read data from in file to spd, and move
> data from spd to pipe. If there isn't much space in pipe for the data in spd,
> and the splice is called with non-block flag, the data dropped due to non
> enough space in pipe will be lost forever when in file isn't seekable.

This is a gratuitous ABI change.  I don't think we should hold the
hand of application writers, maybe they _know_ the splice will not
block.

NACK from me.

Miklos

> 
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
> ----
>  fs/splice.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> diff --git a/fs/splice.c b/fs/splice.c
> index 9e52de5..8137e23 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -1346,8 +1346,12 @@ static long do_splice(struct file *in, loff_t __user *off_in,
>  			if (copy_from_user(&offset, off_in, sizeof(loff_t)))
>  				return -EFAULT;
>  			off = &offset;
> -		} else
> +		} else {
> +			if ((flags & SPLICE_F_NONBLOCK) &&
> +			    !(in->f_mode & FMODE_PREAD))
> +				return -EINVAL;
>  			off = &in->f_pos;
> +		}
>  
>  		ret = do_splice_to(in, off, opipe, len, flags);
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
