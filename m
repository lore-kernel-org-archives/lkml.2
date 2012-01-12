Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab2ALVB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 16:01:29 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43767 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670Ab2ALVB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 16:01:27 -0500
Date: Thu, 12 Jan 2012 16:05:26 -0500
From: Jerome Glisse <j.glisse@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: airlied@redhat.com, airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ttm/dma: Remove the WARN() which is not useful.
Message-ID: <20120112210526.GD4669@homer.localdomain>
References: <1326387026-25142-1-git-send-email-konrad.wilk@oracle.com>
 <1326387026-25142-2-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326387026-25142-2-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 11:50:26AM -0500, Konrad Rzeszutek Wilk wrote:
> . It was useful during development, but now on a production system
> we can get this (if the user forgot to upload the firmware):
> 
> [drm] radeon: irq initialized.
> [drm] GART: num cpu pages 131072, num gpu pages 131072
> [drm] radeon: ib pool ready.
> [drm] Loading SUMO Microcode
> r600_cp: Failed to load firmware "radeon/SUMO_pfp.bin"
> atl1c 0000:03:00.0: version 1.0.1.0-NAPI.213057] [drm:evergreen_startup] *ERROR* Failed to load firmware!
> radeon 0000:00:01.0: disabling GPU acceleration
> 88] radeon 0000:00:01.0: ffff8801bb782400 unpin not necessary
> ------------[ cut here ]------------
> WARNING: at /home/konrad/linux-linus/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c:956 ttm_dma_unpopulate+0x79/0x300 [ttm]()
> Hardware name: System Product Name
> Modules linked in: e1000e atl1c radeon(+) ahci libahci libata scsi_mod fbcon tileblit font ttm bitblit softcursor drm_kms_helper wmi xen_blkfront xen_netfront fb_sys_fops sysimgblt sysfillrect syscopyarea xenfs xen_privcmd
> Pid: 1600, comm: modprobe Not tainted 3.2.0-06100-ge343a89 #1
> Call Trace:
>  [<ffffffff8108973a>] warn_slowpath_common+0x7a/0xb0
>  [<ffffffff81089785>] warn_slowpath_null+0x15/0x20
>  [<ffffffffa0060309>] ttm_dma_unpopulate+0x79/0x300 [ttm]
>  [<ffffffffa01341c0>] radeon_ttm_tt_unpopulate+0x120/0x130 [radeon]
>  [<ffffffffa0056e0c>] ttm_tt_destroy+0x2c/0x70 [ttm]
>  [<ffffffffa0057a4e>] ttm_bo_cleanup_memtype_use+0x3e/0x80 [ttm]
>  [<ffffffffa00595a1>] ttm_bo_release+0x251/0x280 [ttm]
>  [<ffffffffa0059610>] ttm_bo_unref+0x40/0x60 [ttm]
>  [<ffffffffa0134d02>] radeon_bo_unref+0x42/0x80 [radeon]
>  [<ffffffffa0186dfb>] radeon_sa_bo_manager_fini+0x6b/0x80 [radeon]
>  [<ffffffffa0146b8f>] radeon_ib_pool_fini+0x6f/0x90 [radeon]
>  [<ffffffffa014be49>] r100_ib_fini+0x19/0x20 [radeon]
>  [<ffffffffa017b47e>] evergreen_init+0x1ee/0x2d0 [radeon]
> 
> The big WARN() has nothing to do with the culprit - which is that
> the firmware was not loaded. So lets remove the WARN() from the TTM DMA code.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: Jerome Glisse <jglisse@redhat.com>
> ---
>  drivers/gpu/drm/ttm/ttm_page_alloc_dma.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
> index 37ead69..0c46d8c 100644
> --- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
> +++ b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
> @@ -952,10 +952,9 @@ void ttm_dma_unpopulate(struct ttm_dma_tt *ttm_dma, struct device *dev)
>  
>  	type = ttm_to_type(ttm->page_flags, ttm->caching_state);
>  	pool = ttm_dma_find_pool(dev, type);
> -	if (!pool) {
> -		WARN_ON(!pool);
> +	if (!pool)
>  		return;
> -	}
> +
>  	is_cached = (ttm_dma_find_pool(pool->dev,
>  		     ttm_to_type(ttm->page_flags, tt_cached)) == pool);
>  
> -- 
> 1.7.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
