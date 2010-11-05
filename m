Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab0KEUky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 16:40:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752375Ab0KEUku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 16:40:50 -0400
Date: Fri, 5 Nov 2010 13:40:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Carpenter <error27@gmail.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [RFC] [patch] fbcmap: integer overflow bug
Message-Id: <20101105134018.2c11f283.akpm@linux-foundation.org>
In-Reply-To: <20101027093716.GD6062@bicker>
References: <20101027093716.GD6062@bicker>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Oct 2010 11:37:16 +0200
Dan Carpenter <error27@gmail.com> wrote:

> There is an integer overflow bug in the FBIOPUTCMAP ioctl if
> cmap->len * 2 overflows.
> 
> It's harmless, except that it messes up the cmap until someone types
> `reset`.  It could have been caught by checking the return from
> fb_copy_cmap().
> 
> Or it could have been caught by limiting the size of the cmaps to one
> page.  The cmaps are allocated with GFP_ATOMIC and it makes sense to
> limit them.
> 
> Different drivers use different sizes of cmaps.  There are about 150
> drivers.  I've checked a bunch (50) of them and the larges cmap.len I've
> found is gxt4500 which maxes out at 1024 so PAGE_SIZE is about twice that
> length.  For some of the 50 I wasn't sure on the limit.
> 
> Is PAGE_SIZE a reasonable limit?  Does anyone know or do I have to audit
> all 150 drivers?

No signed-off-by:.

> diff --git a/drivers/video/fbcmap.c b/drivers/video/fbcmap.c
> index f53b9f1..6dc5817 100644
> --- a/drivers/video/fbcmap.c
> +++ b/drivers/video/fbcmap.c
> @@ -110,7 +110,9 @@ int fb_alloc_cmap(struct fb_cmap *cmap, int len, int transp)
>      }
>      cmap->start = 0;
>      cmap->len = len;
> -    fb_copy_cmap(fb_default_cmap(len), cmap);
> +    if (fb_copy_cmap(fb_default_cmap(len), cmap))
> +	goto fail;
> +
>      return 0;
>  
>  fail:
> @@ -250,6 +252,9 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info)
>  	int rc, size = cmap->len * sizeof(u16);
>  	struct fb_cmap umap;
>  
> +	if (cmap->len > PAGE_SIZE || cmap->len * sizeof(u16) > PAGE_SIZE)
> +		return -EINVAL;
> +
>  	memset(&umap, 0, sizeof(struct fb_cmap));
>  	rc = fb_alloc_cmap(&umap, cmap->len, cmap->transp != NULL);
>  	if (rc)

A suitable way to fix this would be to detect the overflow only, and
then just throw the passed-in length at kmalloc(), and let kmalloc()
decide whether it is sane or not.

To do that, one would need to implement a new
fb_alloc_cmap_not_stupid() which takes a gfp_t, and pass in GFP_KERNEL.

Feel free to sanitise the fb_alloc_cmap() indenting in [patch 1/2] as well ;)
