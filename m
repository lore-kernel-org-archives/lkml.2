Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767804Ab2KONPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 08:15:50 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54514 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767792Ab2KONPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 08:15:47 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [linux-keystone] [RESEND PATCH] mtd: davinci: add support for parition binding nodes
To: Murali Karicheri <m-karicheri2@ti.com>, rob.herring@calxeda.com,
        rob@landley.net, dwmw2@infradead.org, artem.bityutskiy@linux.intel.com,
        hs@denx.de, nsekhar@ti.com, mikedunn@newsguy.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-keystone@list.ti.com
Cc: Murali Karicheri <m-karicheri2@ti.com>
In-Reply-To: <1351866161-15516-1-git-send-email-m-karicheri2@ti.com>
References: <1351866161-15516-1-git-send-email-m-karicheri2@ti.com>
Date: Thu, 15 Nov 2012 13:15:42 +0000
Message-Id: <20121115131542.D7F023E0B12@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Nov 2012 10:22:41 -0400, Murali Karicheri <m-karicheri2@ti.com> wrote:
> Enhance the driver to support partition subnodes inside the nand
> device bindings to describe partions on the nand device.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

Looks fine to me.

Reviewed-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  .../devicetree/bindings/arm/davinci/nand.txt       |    8 ++++++++
>  drivers/mtd/nand/davinci_nand.c                    |   13 ++++++++++---
>  2 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/davinci/nand.txt b/Documentation/devicetree/bindings/arm/davinci/nand.txt
> index e37241f..4746452 100644
> --- a/Documentation/devicetree/bindings/arm/davinci/nand.txt
> +++ b/Documentation/devicetree/bindings/arm/davinci/nand.txt
> @@ -23,6 +23,9 @@ Recommended properties :
>  - ti,davinci-nand-buswidth: buswidth 8 or 16
>  - ti,davinci-nand-use-bbt: use flash based bad block table support.
>  
> +nand device bindings may contain additional sub-nodes describing
> +partitions of the address space. See partition.txt for more detail.
> +
>  Example (enbw_cmc board):
>  aemif@60000000 {
>  	compatible = "ti,davinci-aemif";
> @@ -47,5 +50,10 @@ aemif@60000000 {
>  		ti,davinci-ecc-mode = "hw";
>  		ti,davinci-ecc-bits = <4>;
>  		ti,davinci-nand-use-bbt;
> +
> +		partition@180000 {
> +			label = "ubifs";
> +			reg = <0x180000 0x7e80000>;
> +		};
>  	};
>  };
> diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
> index df1ab7d..321b053 100644
> --- a/drivers/mtd/nand/davinci_nand.c
> +++ b/drivers/mtd/nand/davinci_nand.c
> @@ -821,9 +821,16 @@ syndrome_done:
>  	if (ret < 0)
>  		goto err_scan;
>  
> -	ret = mtd_device_parse_register(&info->mtd, NULL, NULL, pdata->parts,
> -					pdata->nr_parts);
> -
> +	if (pdata->parts)
> +		ret = mtd_device_parse_register(&info->mtd, NULL, NULL,
> +					pdata->parts, pdata->nr_parts);
> +	else {
> +		struct mtd_part_parser_data	ppdata;
> +
> +		ppdata.of_node = pdev->dev.of_node;
> +		ret = mtd_device_parse_register(&info->mtd, NULL, &ppdata,
> +						NULL, 0);
> +	}
>  	if (ret < 0)
>  		goto err_scan;
>  
> -- 
> 1.7.9.5
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
