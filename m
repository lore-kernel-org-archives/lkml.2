Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab1FGWfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 18:35:54 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:44185 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756995Ab1FGWfx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 18:35:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=w7m2zpQEGXGRmf+Bv6puTrtHiq0uNJtJ+zKn/YAVufownxedG9UfwZxVbXmXl4Ql6v
         UZDbCe+B2VLwyXu1GxPi5yoWIcAE8EdakAgQ/82zYoMHVgLkHbAhrUuhCqmihnE+4Hk5
         TYkVoKjHagJzvMA2S3G8S83sMtJA0Fg6jqA7g=
MIME-Version: 1.0
In-Reply-To: <1307345414-26872-1-git-send-email-shawn.guo@linaro.org>
References: <1307345414-26872-1-git-send-email-shawn.guo@linaro.org>
Date: Tue, 7 Jun 2011 15:35:51 -0700
X-Google-Sender-Auth: G8jWrZnmU6shkiGEIWNA8UO1quU
Message-ID: <BANLkTi=-t9HVc6U6QY07su+c3WztsGoq3Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] dmaengine: add new dma API for max_segment_number
From: Dan Williams <dan.j.williams@intel.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, vinod.koul@intel.com,
        linux-mmc@vger.kernel.org, cjb@laptop.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 12:30 AM, Shawn Guo <shawn.guo@linaro.org> wrote:
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
> Changes since v1:
>  * Update commit message to explain why the new api is needed
>
>  include/linux/device.h      |    1 +
>  include/linux/dma-mapping.h |   15 +++++++++++++++
>  2 files changed, 16 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/device.h b/include/linux/device.h
> index c66111a..44cb2528 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -487,6 +487,7 @@ struct device_dma_parameters {
>         * sg limitations.
>         */

Given the discussion seems like this patch is missing an update to the
documentation of the struct to clarify the definition of dma provider.
 I.e. that this info belongs to the device doing the dma, and that is
is not necessarily the same as the device that is requesting dma
service.

Other than that seems like a natural extension of the existing usage
of device_dma_parameters in drivers/dma/.
