Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab0LVQcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 11:32:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:58951 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab0LVQcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 11:32:54 -0500
Message-ID: <4D12282B.7090103@infradead.org>
Date: Wed, 22 Dec 2010 14:32:43 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: iceberg <strakh@ispras.ru>
CC: linux-kernel@vger.kernel.org, kangyong@telegent.com, xbzhang@telegent.com,
        zyziii@telegent.com, shijie8@gmail.com, linux-media@vger.kernel.org
Subject: Re: BUG: double mutex_unlock in drivers/media/video/tlg2300/pd-video.c
References: <201012131859.15152.strakh@ispras.ru>
In-Reply-To: <201012131859.15152.strakh@ispras.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 13-12-2010 13:59, iceberg escreveu:
> KERNEL_VERSION: 2.6.36
>         SUBJECT: double mutex_lock in drivers/media/video/tlg2300/pd-video.c 
> in function vidioc_s_fmt
>         SUBSCRIBE:
> 	First mutex_unlock in function pd_vidioc_s_fmt in line 767:
> 
>  764        ret |= send_set_req(pd, VIDEO_ROSOLU_SEL,
>  765                                vid_resol, &cmd_status);
>  766        if (ret || cmd_status) {
>  767                mutex_unlock(&pd->lock);
>  768                return -EBUSY;
>  769        }
> 
> 	Second mutex_unlock in function vidioc_s_fmt in line 806:
> 
>  805        pd_vidioc_s_fmt(pd, &f->fmt.pix);
>  806        mutex_unlock(&pd->lock);
> 
> Found by Linux Device Drivers Verification Project
> 
> ?hecks the return code of pd_vidioc_s_fm before mutex_unlocking.
> 
> Signed-off-by: Alexander Strakh <strakh@ispras.ru>
> 
> ---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> diff --git a/drivers/media/video/tlg2300/pd-video.c 
> b/drivers/media/video/tlg2300/pd-video.c
> index a1ffe18..fe6bd2b 100644
> --- a/drivers/media/video/tlg2300/pd-video.c
> +++ b/drivers/media/video/tlg2300/pd-video.c
> @@ -802,8 +802,8 @@ static int vidioc_s_fmt(struct file *file, void *fh, 
> struct v4l2_format *f)
>  		return -EINVAL;
>  	}
>  
> -	pd_vidioc_s_fmt(pd, &f->fmt.pix);
> -	mutex_unlock(&pd->lock);
> +	if (!pd_vidioc_s_fmt(pd, &f->fmt.pix)) 
> +		mutex_unlock(&pd->lock);
>  	return 0;
>  }
> 

Thanks for the patch, but the better is to keep the calls to mutex_lock/mutex_unlock
at the same function. So, instead of adding an "if" at vidioc_s_fmt, please remove
the mutex_unlock() from pd_vidioc_s_fmt().

Cheers,
Mauro
