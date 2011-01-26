Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab1AZS5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:57:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab1AZS5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:57:32 -0500
Date: Wed, 26 Jan 2011 13:57:29 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Cc: Moyer Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] blkio-throttle: Avoid calling blkiocg_lookup_group() for
 root group
Message-ID: <20110126185729.GD6713@redhat.com>
References: <20110117215606.GI5624@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110117215606.GI5624@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 17, 2011 at 04:56:06PM -0500, Vivek Goyal wrote:
> o Jeff Moyer was doing some testing on a RAM backed disk and
>   blkiocg_lookup_group() showed up high overhead after memcpy(). Similarly
>   somebody else reported that blkiocg_lookup_group() is eating 6% extra
>   cpu. Though looking at the code I can't think why the overhead of
>   this function is so high. One thing is that it is called with very high
>   frequency (once for every IO).
> 
> o For lot of folks blkio controller will be compiled in but they might
>   not have actually created cgroups. Hence optimize the case of root
>   cgroup where we can avoid calling blkiocg_lookup_group() if IO is happening
>   in root group (common case).
> 
> Reported-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Hi Jens,

Do you have any concerns regarding this patch?

Thanks
Vivek

> ---
>  block/blk-throttle.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/block/blk-throttle.c
> ===================================================================
> --- linux-2.6.orig/block/blk-throttle.c	2011-01-17 16:23:37.041280712 -0500
> +++ linux-2.6/block/blk-throttle.c	2011-01-17 16:36:09.362940975 -0500
> @@ -168,7 +168,15 @@ static struct throtl_grp * throtl_find_a
>  	 * tree of blkg (instead of traversing through hash list all
>  	 * the time.
>  	 */
> -	tg = tg_of_blkg(blkiocg_lookup_group(blkcg, key));
> +
> +	/*
> +	 * This is the common case when there are no blkio cgroups.
> + 	 * Avoid lookup in this case
> + 	 */
> +	if (blkcg == &blkio_root_cgroup)
> +		tg = &td->root_tg;
> +	else
> +		tg = tg_of_blkg(blkiocg_lookup_group(blkcg, key));
>  
>  	/* Fill in device details for root group */
>  	if (tg && !tg->blkg.dev && bdi->dev && dev_name(bdi->dev)) {
> 
