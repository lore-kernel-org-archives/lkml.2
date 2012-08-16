Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab2HPMQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 08:16:21 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:38332 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab2HPMQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 08:16:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hideki EIRAKU <hdk@igel.co.jp>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Katsuya MATSUBARA <matsu@igel.co.jp>,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: Re: [PATCH v4] fbdev: sh_mobile_lcdc: use dma_mmap_coherent
Date: Thu, 16 Aug 2012 14:16:32 +0200
Message-ID: <14014166.3JMiBq7jRA@avalon>
User-Agent: KMail/4.8.3 (Linux/3.3.8-gentoo; KDE/4.8.3; x86_64; ; )
In-Reply-To: <1345112000-22738-1-git-send-email-hdk@igel.co.jp>
References: <1345112000-22738-1-git-send-email-hdk@igel.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eiraku-san,

On Thursday 16 August 2012 19:13:20 Hideki EIRAKU wrote:
> fb_mmap() implemented in fbmem.c uses smem_start as the physical
> address of the frame buffer.  In the sh_mobile_lcdc driver, the
> smem_start is a dma_addr_t that is not a physical address when IOMMU is
> enabled.  dma_mmap_coherent() maps the address correctly.
> 
> Signed-off-by: Hideki EIRAKU <hdk@igel.co.jp>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I will push the patch to v3.7 through my tree.

> ---
>  drivers/video/sh_mobile_lcdcfb.c |   20 ++++++++++++++++++++
>  1 files changed, 20 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/sh_mobile_lcdcfb.c
> b/drivers/video/sh_mobile_lcdcfb.c index 699487c..bccfd7e 100644
> --- a/drivers/video/sh_mobile_lcdcfb.c
> +++ b/drivers/video/sh_mobile_lcdcfb.c
> @@ -1614,6 +1614,15 @@ static int sh_mobile_lcdc_overlay_blank(int blank,
> struct fb_info *info) return 1;
>  }
> 
> +static int
> +sh_mobile_lcdc_overlay_mmap(struct fb_info *info, struct vm_area_struct
> *vma) +{
> +	struct sh_mobile_lcdc_overlay *ovl = info->par;
> +
> +	return dma_mmap_coherent(ovl->channel->lcdc->dev, vma, ovl->fb_mem,
> +				 ovl->dma_handle, ovl->fb_size);
> +}
> +
>  static struct fb_ops sh_mobile_lcdc_overlay_ops = {
>  	.owner          = THIS_MODULE,
>  	.fb_read        = fb_sys_read,
> @@ -1626,6 +1635,7 @@ static struct fb_ops sh_mobile_lcdc_overlay_ops = {
>  	.fb_ioctl       = sh_mobile_lcdc_overlay_ioctl,
>  	.fb_check_var	= sh_mobile_lcdc_overlay_check_var,
>  	.fb_set_par	= sh_mobile_lcdc_overlay_set_par,
> +	.fb_mmap	= sh_mobile_lcdc_overlay_mmap,
>  };
> 
>  static void
> @@ -2093,6 +2103,15 @@ static int sh_mobile_lcdc_blank(int blank, struct
> fb_info *info) return 0;
>  }
> 
> +static int
> +sh_mobile_lcdc_mmap(struct fb_info *info, struct vm_area_struct *vma)
> +{
> +	struct sh_mobile_lcdc_chan *ch = info->par;
> +
> +	return dma_mmap_coherent(ch->lcdc->dev, vma, ch->fb_mem,
> +				 ch->dma_handle, ch->fb_size);
> +}
> +
>  static struct fb_ops sh_mobile_lcdc_ops = {
>  	.owner          = THIS_MODULE,
>  	.fb_setcolreg	= sh_mobile_lcdc_setcolreg,
> @@ -2108,6 +2127,7 @@ static struct fb_ops sh_mobile_lcdc_ops = {
>  	.fb_release	= sh_mobile_lcdc_release,
>  	.fb_check_var	= sh_mobile_lcdc_check_var,
>  	.fb_set_par	= sh_mobile_lcdc_set_par,
> +	.fb_mmap	= sh_mobile_lcdc_mmap,
>  };
> 
>  static void

-- 
Regards,

Laurent Pinchart

