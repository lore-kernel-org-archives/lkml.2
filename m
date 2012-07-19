Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab2GSLa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 07:30:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36740 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab2GSLaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 07:30:55 -0400
Date: Thu, 19 Jul 2012 13:30:59 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Rob Clark <rob.clark@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: Re: [Linaro-mm-sig] [PATCH] device: add dma_params->max_segment_count
Message-ID: <20120719113059.GB5262@phenom.ffwll.local>
Mail-Followup-To: Rob Clark <rob.clark@linaro.org>,
	linux-kernel@vger.kernel.org, linaro-mm-sig@lists.linaro.org
References: <1342115056-27419-1-git-send-email-rob.clark@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342115056-27419-1-git-send-email-rob.clark@linaro.org>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 12:44:16PM -0500, Rob Clark wrote:
> From: Rob Clark <rob@ti.com>
> 
> For devices which have constraints about maximum number of segments
> in an sglist.  For example, a device which could only deal with
> contiguous buffers would set max_segment_count to 1.
> 
> The initial motivation is for devices sharing buffers via dma-buf,
> to allow the buffer exporter to know the constraints of other
> devices which have attached to the buffer.  The dma_mask and fields
> in 'struct device_dma_parameters' tell the exporter everything else
> that is needed, except whether the importer has constraints about
> maximum number of segments.
> 
> Signed-off-by: Rob Clark <rob@ti.com>

I like this and I guess it's an easy way to solve most of our sharing
issues with funnier hw. Exporters can then fall back to large allocations,
CMA, special-purpose remappes (like the omap tiler) or platform-specific
carveout areas (stolen mem for drm/i915). One little thing though:

Could you add a little helper (maybe in a second patch) to dma_buf that
walks all currently attached buffers and ORs together all masks and takes
the minimum of all other limits for all attached buffers?

Yours, Daniel

> ---
>  include/linux/device.h      |    1 +
>  include/linux/dma-mapping.h |   16 ++++++++++++++++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 161d962..3813735 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -568,6 +568,7 @@ struct device_dma_parameters {
>  	 * sg limitations.
>  	 */
>  	unsigned int max_segment_size;
> +	unsigned int max_segment_count;    /* zero for unlimited */
>  	unsigned long segment_boundary_mask;
>  };
>  
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index dfc099e..f380f79 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -111,6 +111,22 @@ static inline unsigned int dma_set_max_seg_size(struct device *dev,
>  		return -EIO;
>  }
>  
> +static inline unsigned int dma_get_max_seg_count(struct device *dev)
> +{
> +	return dev->dma_parms ? dev->dma_parms->max_segment_count : 0;
> +}
> +
> +static inline int dma_set_max_seg_count(struct device *dev,
> +						unsigned int count)
> +{
> +	if (dev->dma_parms) {
> +		dev->dma_parms->max_segment_count = count;
> +		return 0;
> +	} else
> +		return -EIO;
> +}
> +
> +
>  static inline unsigned long dma_get_seg_boundary(struct device *dev)
>  {
>  	return dev->dma_parms ?
> -- 
> 1.7.9.5
> 
> 
> _______________________________________________
> Linaro-mm-sig mailing list
> Linaro-mm-sig@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-mm-sig

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
