Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab0K3GLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 01:11:50 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:39663 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab0K3GLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 01:11:49 -0500
Date: Tue, 30 Nov 2010 15:10:51 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Thomas Schlichter <thomas.schlichter@web.de>
Cc: Michal Januszewski <spock@gentoo.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uvesafb,vesafb: create write-combining or write-back PAT entries
Message-ID: <20101130061051.GD17114@linux-sh.org>
References: <201011271437.38126.thomas.schlichter@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011271437.38126.thomas.schlichter@web.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 27, 2010 at 02:37:37PM +0100, Thomas Schlichter wrote:
> diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
> index 52ec095..5a34bc8 100644
> --- a/drivers/video/uvesafb.c
> +++ b/drivers/video/uvesafb.c
...

> -	info->screen_base = ioremap(info->fix.smem_start, info->fix.smem_len);
> +	uvesafb_init_mtrr(info);
> +
> +	switch (mtrr) {
> +	case 1: /* uncachable */
> +		info->screen_base = ioremap_nocache(info->fix.smem_start, info->fix.smem_len);
> +		break;
> +	case 2: /* write-back */
> +		info->screen_base = ioremap_cache(info->fix.smem_start, info->fix.smem_len);
> +		break;
> +	case 3: /* write-combining */
> +		info->screen_base = ioremap_wc(info->fix.smem_start, info->fix.smem_len);
> +		break;
> +	case 4: /* write-through */
> +	default:
> +		info->screen_base = ioremap(info->fix.smem_start, info->fix.smem_len);
> +		break;
> +	}
>  
>  	if (!info->screen_base) {
>  		printk(KERN_ERR

uvesafb presently has no special architecture dependencies, but
ioremap_wc() is not as of yet a wholly generic interface. Some
architectures that don't set ARCH_HAS_IOREMAP_WC get it by virtue of the
asm-generic/iomap.h include, and most of the nommu architectures will
stub it in via asm-generic/io.h, but this still leaves quite a long list
of platforms that don't handle it at all.

Your options at this point are either to establish ioremap_wc() as a
generic API, and layer this patch on top of that, or rework
uvesafb_init_mtrr() to do the actual broken-out remapping and rework it
in to something like a uvesafb_remap(), where you bury the MTRR details
under CONFIG_MTRR.

While there's probably value in exposing ioremap_wc() as a generic
interface, you're never going to hit any of the non-default ioremap()
calls on platforms lacking MTRRs anyways, so special-casing it is ok.
