Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945Ab0LNBet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 20:34:49 -0500
Received: from mail-bw0-f66.google.com ([209.85.214.66]:41231 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758865Ab0LNBer convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 20:34:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qZj60WZSQsBVdCNxK+2XtG3xkpXMu6GPXcfjFJtnMtx+h8cGxVsTLRWm8CD4gXRB8J
         WCSFi0lgEp3QJ8VglH7XmGMP+k7Cju/ZCY7C9Je5jWRFJuQk/4tyiKhY7D0j7pLwbuFt
         107mi0BILsNXE8pmRiz5Gbwd6VJLJWv8+922Q=
MIME-Version: 1.0
In-Reply-To: <201012131859.15152.strakh@ispras.ru>
References: <201012131859.15152.strakh@ispras.ru>
Date: Tue, 14 Dec 2010 09:34:46 +0800
Message-ID: <AANLkTi=4CZ2LD8cj_cjnb5yyyML+M6T=57EjT_hD4TBn@mail.gmail.com>
Subject: Re: BUG: double mutex_unlock in drivers/media/video/tlg2300/pd-video.c
From: Huang Shijie <shijie8@gmail.com>
To: Alexander Strakh <strakh@ispras.ru>
Cc: linux-kernel@vger.kernel.org, kangyong@telegent.com, xbzhang@telegent.com,
        zyziii@telegent.com, Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Strakh:

Thanks for your patch.

But I prefer to remove the mutex_unlock() in the pd_vidioc_s_fmt(),
since the pd_vidioc_s_fmt() is also called in restore_v4l2_context().

would you please change the patch?
I will ack it.

Best Regards
Huang Shijie


2010/12/13 Alexander Strakh <strakh@ispras.ru>:
>        KERNEL_VERSION: 2.6.36
>        SUBJECT: double mutex_lock in drivers/media/video/tlg2300/pd-video.c
> in function vidioc_s_fmt
>        SUBSCRIBE:
>        First mutex_unlock in function pd_vidioc_s_fmt in line 767:
>
>  764        ret |= send_set_req(pd, VIDEO_ROSOLU_SEL,
>  765                                vid_resol, &cmd_status);
>  766        if (ret || cmd_status) {
>  767                mutex_unlock(&pd->lock);
>  768                return -EBUSY;
>  769        }
>
>        Second mutex_unlock in function vidioc_s_fmt in line 806:
>
>  805        pd_vidioc_s_fmt(pd, &f->fmt.pix);
>  806        mutex_unlock(&pd->lock);
>
> Found by Linux Device Drivers Verification Project
>
> Сhecks the return code of pd_vidioc_s_fm before mutex_unlocking.
>
> Signed-off-by: Alexander Strakh <strakh@ispras.ru>
>
> ---
> diff --git a/drivers/media/video/tlg2300/pd-video.c
> b/drivers/media/video/tlg2300/pd-video.c
> index a1ffe18..fe6bd2b 100644
> --- a/drivers/media/video/tlg2300/pd-video.c
> +++ b/drivers/media/video/tlg2300/pd-video.c
> @@ -802,8 +802,8 @@ static int vidioc_s_fmt(struct file *file, void *fh,
> struct v4l2_format *f)
>                return -EINVAL;
>        }
>
> -       pd_vidioc_s_fmt(pd, &f->fmt.pix);
> -       mutex_unlock(&pd->lock);
> +       if(!pd_vidioc_s_fmt(pd, &f->fmt.pix))
> +               mutex_unlock(&pd->lock);
>        return 0;
>  }
>
>
>
