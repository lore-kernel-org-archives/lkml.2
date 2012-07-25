Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab2GYLKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:10:42 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:41499 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726Ab2GYLKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:10:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hideki EIRAKU <hdk@igel.co.jp>
Cc: Russell King <linux@arm.linux.org.uk>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Katsuya MATSUBARA <matsu@igel.co.jp>
Subject: Re: [PATCH 3/3] fbdev: sh_mobile_lcdc: use dma_mmap_coherent if available
Date: Wed, 25 Jul 2012 13:10:46 +0200
Message-ID: <9666926.0rOsjgUcAB@avalon>
User-Agent: KMail/4.8.3 (Linux/3.3.8-gentoo; KDE/4.8.3; x86_64; ; )
In-Reply-To: <1343197764-13659-4-git-send-email-hdk@igel.co.jp>
References: <1343197764-13659-1-git-send-email-hdk@igel.co.jp> <1343197764-13659-4-git-send-email-hdk@igel.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eiraku-san,

Thank you for the patch.

On Wednesday 25 July 2012 15:29:24 Hideki EIRAKU wrote:
> fb_mmap() implemented in fbmem.c uses smem_start as the physical
> address of the frame buffer.  In the sh_mobile_lcdc driver, the
> smem_start is a dma_addr_t that is not a physical address when IOMMU is
> enabled.  dma_mmap_coherent() maps the address correctly.  It is
> available on ARM platforms.

This looks good to me, but will need to be rebased on top of the 
sh_mobile_lcdc patches currently queued for v3.6. You can find them in the 
fbdev-next branch of git://github.com/schandinat/linux-2.6.git.

In particular, these patches add support for overlays exported through 
additional fbdev devices. You will need to initialize .fb_mmap in both 
sh_mobile_lcdc_overlay_ops and sh_mobile_lcdc_ops.

> Signed-off-by: Hideki EIRAKU <hdk@igel.co.jp>
> ---
>  drivers/video/sh_mobile_lcdcfb.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/sh_mobile_lcdcfb.c
> b/drivers/video/sh_mobile_lcdcfb.c index e672698..65732c4 100644
> --- a/drivers/video/sh_mobile_lcdcfb.c
> +++ b/drivers/video/sh_mobile_lcdcfb.c
> @@ -1393,6 +1393,17 @@ static int sh_mobile_lcdc_blank(int blank, struct
> fb_info *info) return 0;
>  }
> 
> +#ifdef ARCH_HAS_DMA_MMAP_COHERENT
> +static int
> +sh_mobile_fb_mmap(struct fb_info *info, struct vm_area_struct *vma)
> +{
> +	struct sh_mobile_lcdc_chan *ch = info->par;
> +
> +	return dma_mmap_coherent(ch->lcdc->dev, vma, ch->fb_mem,
> +				 ch->dma_handle, ch->fb_size);
> +}
> +#endif
> +
>  static struct fb_ops sh_mobile_lcdc_ops = {
>  	.owner          = THIS_MODULE,
>  	.fb_setcolreg	= sh_mobile_lcdc_setcolreg,
> @@ -1408,6 +1419,9 @@ static struct fb_ops sh_mobile_lcdc_ops = {
>  	.fb_release	= sh_mobile_release,
>  	.fb_check_var	= sh_mobile_check_var,
>  	.fb_set_par	= sh_mobile_set_par,
> +#ifdef ARCH_HAS_DMA_MMAP_COHERENT
> +	.fb_mmap	= sh_mobile_fb_mmap,
> +#endif
>  };
> 
>  static void
-- 
Regards,

Laurent Pinchart

