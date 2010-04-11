Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab0DKXzo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 19:55:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129Ab0DKXzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 19:55:42 -0400
Subject: Re: [PATCH 1/3] fbmem: fix aperture overlapping check
From: Dave Airlie <airlied@redhat.com>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>,
       nouveau@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
       Peter Jones <pjones@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1270929334-3742-1-git-send-email-marcin.slusarz@gmail.com>
References: <1270929334-3742-1-git-send-email-marcin.slusarz@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Apr 2010 09:54:28 +1000
Message-ID: <1271030068.3554.1.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-04-10 at 21:55 +0200, marcin.slusarz@gmail.com wrote:
> fb_do_apertures_overlap is returning wrong value when one aperture
> is completely whithin the other. Add generic ranges_overlap macro
> (probably kernel.h candidate) and use it here.
> 

That doesn't seem right.

The rules are:

the generic aperture has to be equal or smaller than the hw aperture,
otherwise the generic driver will be trashing random hw pieces on the
machine.

So with that in mind, the check makes sure the generic aperture starts
somewhere inside the hw aperture, which the test clearly gets right.

Have you got a pointer to a machine where it fails?

Dave.


> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: Peter Jones <pjones@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  drivers/video/fbmem.c |   24 +++++++++++++++++-------
>  1 files changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
> index a15b44e..41f2e5e 100644
> --- a/drivers/video/fbmem.c
> +++ b/drivers/video/fbmem.c
> @@ -1468,15 +1468,25 @@ static int fb_check_foreignness(struct fb_info *fi)
>  	return 0;
>  }
>  
> +/**
> + * ranges_overlap - check whether two ranges overlap (their intersection is not empty)
> + * @start1: start of the first range
> + * @size1:  length of the first range
> + * @start2: start of the second range
> + * @size2:  length of the second range
> + */
> +#define ranges_overlap(start1, size1, start2, size2) ({	\
> +	typeof(start1) __start1 = (start1);		\
> +	typeof(size1)  __size1  = (size1);		\
> +	typeof(start2) __start2 = (start2);		\
> +	typeof(size2)  __size2  = (size2);		\
> +	__start1 < __start2 + __size2 && __start1 + __size1 > __start2; \
> +})
> +
>  static bool fb_do_apertures_overlap(struct fb_info *gen, struct fb_info *hw)
>  {
> -	/* is the generic aperture base the same as the HW one */
> -	if (gen->aperture_base == hw->aperture_base)
> -		return true;
> -	/* is the generic aperture base inside the hw base->hw base+size */
> -	if (gen->aperture_base > hw->aperture_base && gen->aperture_base <= hw->aperture_base + hw->aperture_size)
> -		return true;
> -	return false;
> +	return ranges_overlap(gen->aperture_base, gen->aperture_size,
> +				hw->aperture_base, hw->aperture_size);
>  }
>  /**
>   *	register_framebuffer - registers a frame buffer device


