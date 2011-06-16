Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab1FPJyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 05:54:09 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64978 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab1FPJyD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 05:54:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QfAo2yUjslxZ/PNTAns5eyao+6KQRyX6MxttLakGdAhIyWax2i0QnWDHG8EYMq/yj0
         /6eD8pGPL4eqGXzEsUVLfzThFShtOIw2LUGdPXaYs9r2/9uWjiAx0tpNvn82kRgQlWWV
         5+0jckmx3y2mA5QpFgnVYJaZnjH0kHeM7/D6k=
MIME-Version: 1.0
In-Reply-To: <1308139721-4008-1-git-send-email-shawn.guo@linaro.org>
References: <BANLkTi=-t9HVc6U6QY07su+c3WztsGoq3Q@mail.gmail.com>
	<1308139721-4008-1-git-send-email-shawn.guo@linaro.org>
Date: Thu, 16 Jun 2011 11:54:01 +0200
X-Google-Sender-Auth: HK5hAS_XczSPoDj_a8poASJUPZg
Message-ID: <BANLkTikSj+9-p3uvDTbSYF1nX3sxvbDwUQ@mail.gmail.com>
Subject: Re: [PATCH v3] dmaengine: add new dma API for max_segment_number
From: Per Forlin <per.forlin@linaro.org>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, patches@linaro.org,
        vinod.koul@intel.com, gregkh@suse.de, linux-mmc@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Dan Williams <dan.j.williams@intel.com>, cjb@laptop.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 2:08 PM, Shawn Guo <shawn.guo@linaro.org> wrote:
> [PATCH v3] dmaengine: add new dma API for max_segment_number
The subject "dmaengine:" in this case is a bit misleading since the
patches doesn't touch any code inside drivers/dmaengine.
For this patch I would prefer subject "dma-mapping:"

There is a need for the DMA clients to be able to extract the max seg
number from the DMA provider/device. I think this patch is a sane way
of making this information available.

Regards,
Per

> Like dma_set(get)_max_seg_size for max_segment_size, the patch adds
> max_segment_number into device_dma_parameters and creates the
> corresponding dmaengine API dma_set(get)_max_seg_number for it.
>
> Here is the user story that tells the need of the new api.  The
> mxs-mmc is the mmc host controller for Freescale MXS architecture.
> There are a pair of  mmc host specific parameters max_seg_size and
> max_segs that mxs-mmc host driver needs to tell mmc core, so that
> mmc core can know how big each data segment could be and how many
> segments could be handled one time in a scatter list by host driver.
>
> The mxs-mmc driver is one user of dmaengine mxs-dma, and it will call
> mxs-dma to transfer data in scatter list.  That is to say mxs-mmc has
> no idea of what max_seg_size and max_segs should be, because they are
> all mxs-dma capability parameters, and mxs-mmc needs to query them
> from mxs-dma.
>
> Right now, there is well defined dma api (dma_get_max_seg_size) for
> mmc to query max_seg_size from dma driver, but the one for max_segs
> is missing.  That's why mxs-mmc driver has to hard-code it.
>
> The mxs-mmc is just one example to demonstrate the need of the new
> api, and there are other mmc host drivers (mxcmmc on imx-dma is
> another example) and possibly even other dmaengine users need this
> new api to know the maximum segments that dma driver can handle per
> dma call.
>
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> ---
>  include/linux/device.h      |   16 ++++++++++++----
>  include/linux/dma-mapping.h |   15 +++++++++++++++
>  2 files changed, 27 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/device.h b/include/linux/device.h
> index c66111a..f1152c5 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -481,12 +481,20 @@ extern int devres_release_group(struct device *dev, void *id);
>  extern void *devm_kzalloc(struct device *dev, size_t size, gfp_t gfp);
>  extern void devm_kfree(struct device *dev, void *p);
>
> +/*
> + * device_dma_parameters is a property of DMA provider, and it belongs to the
> + * 'struct device' that actually provides DMA service, typically the drivers
> + * under drivers/dma, although in some cases the DMA provider and block device
> + * uses DMA service happen to be the same 'struct device'.
> + *
> + * It's not necessary for every single DMA providers to have this structure,
> + * because some DMA providers simply do not have these parameters/limitations.
> + * For those do have, the DMA providers should be responsible for setting the
> + * parameters up.
> + */
>  struct device_dma_parameters {
> -       /*
> -        * a low level driver may set these to teach IOMMU code about
> -        * sg limitations.
> -        */
>        unsigned int max_segment_size;
> +       unsigned int max_segment_number;
>        unsigned long segment_boundary_mask;
>  };
>
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index ba8319a..fd314f4 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -131,6 +131,21 @@ static inline unsigned int dma_set_max_seg_size(struct device *dev,
>                return -EIO;
>  }
>
> +static inline unsigned int dma_get_max_seg_number(struct device *dev)
> +{
> +       return dev->dma_parms ? dev->dma_parms->max_segment_number : 1;
> +}
> +
> +static inline unsigned int dma_set_max_seg_number(struct device *dev,
> +                                                 unsigned int number)
> +{
> +       if (dev->dma_parms) {
> +               dev->dma_parms->max_segment_number = number;
> +               return 0;
> +       } else
> +               return -EIO;
> +}
> +
>  static inline unsigned long dma_get_seg_boundary(struct device *dev)
>  {
>        return dev->dma_parms ?
> --
> 1.7.4.1
>
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
