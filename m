Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab1KUTrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 14:47:01 -0500
Received: from 184-106-247-128.static.cloud-ips.com ([184.106.247.128]:50856
	"EHLO cloud01.chad-versace.us" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754219Ab1KUTrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 14:47:00 -0500
X-Spam-Flag: NO
X-Spam-Score: -1
Date: Mon, 21 Nov 2011 11:46:49 -0800
From: Ben Widawsky <ben@bwidawsk.net>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 06/13] drm: add helper to clflush a virtual
 address range
Message-ID: <20111121194649.GC18843@bolo_yeung.jf.intel.com>
References: <1320606840-21132-1-git-send-email-daniel.vetter@ffwll.ch>
 <1320606840-21132-7-git-send-email-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320606840-21132-7-git-send-email-daniel.vetter@ffwll.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 06, 2011 at 08:13:53PM +0100, Daniel Vetter wrote:
> Useful when the page is already mapped to copy date in/out.
> 
> Cc: dri-devel@lists.freedesktop.org
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---
>  drivers/gpu/drm/drm_cache.c |   23 +++++++++++++++++++++++
>  include/drm/drmP.h          |    1 +
>  2 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_cache.c b/drivers/gpu/drm/drm_cache.c
> index 0e3bd5b..502771a 100644
> --- a/drivers/gpu/drm/drm_cache.c
> +++ b/drivers/gpu/drm/drm_cache.c
> @@ -97,3 +97,26 @@ drm_clflush_pages(struct page *pages[], unsigned long num_pages)
>  #endif
>  }
>  EXPORT_SYMBOL(drm_clflush_pages);
> +
> +void
> +drm_clflush_virt_range(char *addr, unsigned long length)
> +{
> +#if defined(CONFIG_X86)
> +	if (cpu_has_clflush) {
> +		char *end = addr + length;
> +		mb();
> +		for (; addr < end; addr += boot_cpu_data.x86_clflush_size)
> +			clflush(addr);
> +		clflush(end - 1);
> +		mb();
> +		return;
> +	}
> +
> +	if (on_each_cpu(drm_clflush_ipi_handler, NULL, 1) != 0)
> +		printk(KERN_ERR "Timed out waiting for cache flush.\n");
> +#else
> +	printk(KERN_ERR "Architecture has no drm_cache.c support\n");
> +	WARN_ON_ONCE(1);
> +#endif
> +}
> +EXPORT_SYMBOL(drm_clflush_virt_range);

I'd feel more comfortable with a BUG_ON(irqs_disabled()); before the
IPI... though I don't even know how many platforms that actually
pertains to (if any).
