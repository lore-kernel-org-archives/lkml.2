Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab1AUQ1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 11:27:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab1AUQ1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 11:27:13 -0500
Date: Fri, 21 Jan 2011 17:26:50 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH] drm/i915,agp/intel: Do not clear stolen entries
Message-ID: <20110121162650.GB28563@jolsa.brq.redhat.com>
References: <20110120232410.GA19405@nowhere>
 <1295607537-877-1-git-send-email-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295607537-877-1-git-send-email-chris@chris-wilson.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch fixed the issue for me

Tested-by: Jiri Olsa <jolsa@redhat.com>
if needed :)

thanks,
jirka


On Fri, Jan 21, 2011 at 10:58:57AM +0000, Chris Wilson wrote:
> We can only utilize the stolen portion of the GTT if we are in sole
> charge of the hardware. This is only true if using GEM and KMS,
> otherwise VESA continues to access stolen memory.
> 
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> ---
>  drivers/char/agp/intel-gtt.c    |   18 ++++++++----------
>  drivers/gpu/drm/i915/i915_gem.c |    6 ++++--
>  2 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
> index 826ab09..cbbcaba 100644
> --- a/drivers/char/agp/intel-gtt.c
> +++ b/drivers/char/agp/intel-gtt.c
> @@ -68,6 +68,7 @@ static struct _intel_private {
>  	phys_addr_t gma_bus_addr;
>  	u32 PGETBL_save;
>  	u32 __iomem *gtt;		/* I915G */
> +	bool clear_fake_agp; /* on first access via agp, fill with scratch */
>  	int num_dcache_entries;
>  	union {
>  		void __iomem *i9xx_flush_page;
> @@ -869,21 +870,12 @@ static int intel_fake_agp_free_gatt_table(struct agp_bridge_data *bridge)
>  
>  static int intel_fake_agp_configure(void)
>  {
> -	int i;
> -
>  	if (!intel_enable_gtt())
>  	    return -EIO;
>  
> +	intel_private.clear_fake_agp = true;
>  	agp_bridge->gart_bus_addr = intel_private.gma_bus_addr;
>  
> -	for (i = 0; i < intel_private.base.gtt_total_entries; i++) {
> -		intel_private.driver->write_entry(intel_private.scratch_page_dma,
> -						  i, 0);
> -	}
> -	readl(intel_private.gtt+i-1);	/* PCI Posting. */
> -
> -	global_cache_flush();
> -
>  	return 0;
>  }
>  
> @@ -945,6 +937,12 @@ static int intel_fake_agp_insert_entries(struct agp_memory *mem,
>  {
>  	int ret = -EINVAL;
>  
> +	if (intel_private.clear_fake_agp) {
> +		intel_gtt_clear_range(intel_private.base.stolen_size / PAGE_SIZE,
> +				      intel_private.base.gtt_total_entries);
> +		intel_private.clear_fake_agp = false;
> +	}
> +
>  	if (INTEL_GTT_GEN == 1 && type == AGP_DCACHE_MEMORY)
>  		return i810_insert_dcache_entries(mem, pg_start, type);
>  
> diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> index 812b97b..6542e7d 100644
> --- a/drivers/gpu/drm/i915/i915_gem.c
> +++ b/drivers/gpu/drm/i915/i915_gem.c
> @@ -140,12 +140,14 @@ void i915_gem_do_init(struct drm_device *dev,
>  {
>  	drm_i915_private_t *dev_priv = dev->dev_private;
>  
> -	drm_mm_init(&dev_priv->mm.gtt_space, start,
> -		    end - start);
> +	drm_mm_init(&dev_priv->mm.gtt_space, start, end - start);
>  
>  	dev_priv->mm.gtt_total = end - start;
>  	dev_priv->mm.mappable_gtt_total = min(end, mappable_end) - start;
>  	dev_priv->mm.gtt_mappable_end = mappable_end;
> +
> +	/* Take over this portion of the GTT */
> +	intel_gtt_clear_range(start / PAGE_SIZE, end / PAGE_SIZE);
>  }
>  
>  int
> -- 
> 1.7.2.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
