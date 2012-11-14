Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab2KNTP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 14:15:57 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43235 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab2KNTP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 14:15:56 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v5 4/4] misc: sram: add support for configurable allocation order
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        kernel@pengutronix.de, devicetree-discuss@lists.ozlabs.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>
In-Reply-To: <1350570453-24546-5-git-send-email-p.zabel@pengutronix.de>
References: <1350570453-24546-1-git-send-email-p.zabel@pengutronix.de> <1350570453-24546-5-git-send-email-p.zabel@pengutronix.de>
Date: Wed, 14 Nov 2012 19:15:51 +0000
Message-Id: <20121114191551.5E8673E0B7C@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2012 16:27:33 +0200, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> From: Matt Porter <mporter@ti.com>
> 
> Adds support for setting the genalloc pool's minimum allocation
> order via DT or platform data. The allocation order is optional
> for both the DT property and platform data case. If it is not
> present then the order defaults to PAGE_SHIFT to preserve the
> current behavior.
> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  Documentation/devicetree/bindings/misc/sram.txt |   12 ++++++++++-
>  drivers/misc/sram.c                             |   14 ++++++++++++-
>  include/linux/platform_data/sram.h              |   25 +++++++++++++++++++++++
>  3 files changed, 49 insertions(+), 2 deletions(-)
>  create mode 100644 include/linux/platform_data/sram.h
> 
> diff --git a/Documentation/devicetree/bindings/misc/sram.txt b/Documentation/devicetree/bindings/misc/sram.txt
> index b64136c..b1705ec 100644
> --- a/Documentation/devicetree/bindings/misc/sram.txt
> +++ b/Documentation/devicetree/bindings/misc/sram.txt
> @@ -8,10 +8,20 @@ Required properties:
>  
>  - reg : SRAM iomem address range
>  
> -Example:
> +Optional properties:
> +
> +- alloc-order : Minimum allocation order for the SRAM pool

Looks okay, but I think the property name is confusing. I for one had
no idea what 'order' would be and why it was important. I had to read
the code to figure it out.

It does raise the question though of what is this binding actually
for? Does it reflect a limitation of the SRAM? or of the hardware using
the SRAM? Or is it an optimization? How do you expect to use it?

Assuming it is appropriate to put into the device tree, I'd suggest a
different name. Instead of 'order', how about 'sram-alloc-align' (in
address bits) or 'sram-alloc-min-size' (in bytes).

> @@ -60,7 +62,17 @@ static int __devinit sram_probe(struct platform_device *pdev)
>  	if (!IS_ERR(sram->clk))
>  		clk_prepare_enable(sram->clk);
>  
> -	sram->pool = gen_pool_create(PAGE_SHIFT, -1);
> +	if (pdev->dev.of_node)
> +		of_property_read_u32(pdev->dev.of_node,
> +				     "alloc-order", &alloc_order);
> +	else
> +		if (pdev->dev.platform_data) {
> +			struct sram_pdata *pdata = pdev->dev.platform_data;
> +			if (pdata->alloc_order)
> +				alloc_order = pdata->alloc_order;
> +		}
> +
> +	sram->pool = gen_pool_create(alloc_order, -1);

Do you already have a user for the platform_data use case? If not then
I'd drop it entirely and skip adding the new header file.

g.

