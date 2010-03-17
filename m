Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab0CQGOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 02:14:10 -0400
Received: from smtprelay-h12.telenor.se ([62.127.194.5]:36383 "EHLO
	smtprelay-h12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab0CQGOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 02:14:08 -0400
X-Greylist: delayed 671 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Mar 2010 02:14:08 EDT
X-SENDER-IP: [85.228.115.218]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtE/ANYPoEtV5HPaPGdsb2JhbACDC4RVkyIMAQEBATctpwCQIoEsgmBqBA
X-IronPort-AV: E=Sophos;i="4.49,655,1262559600"; 
   d="scan'208";a="51626504"
Message-ID: <4BA0732B.7040007@pelagicore.com>
Date: Wed, 17 Mar 2010 07:14:03 +0100
From: =?UTF-8?B?UmljaGFyZCBSw7ZqZm9ycw==?= 
	<richard.rojfors@pelagicore.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1.8) Gecko/20100227 Lightning/1.0b1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Anton Vorontsov <avorontsov@ru.mvista.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       David Vrabel <david.vrabel@csr.com>, Pierre Ossman <pierre@ossman.eu>,
       Ben Dooks <ben@simtec.co.uk>, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] sdhci-pltfm: Implement platform data passing
References: <20100316183400.GA24191@oksana.dev.rtsoft.ru> <20100316183429.GB25670@oksana.dev.rtsoft.ru>
In-Reply-To: <20100316183429.GB25670@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/16/10 7:34 PM, Anton Vorontsov wrote:
> This includes platform ops, quirks and (de)initialization callbacks.

Good idea, just a doc comment below.

> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
>  drivers/mmc/host/sdhci-pltfm.c |   24 ++++++++++++++++++++----
>  include/linux/sdhci-pltfm.h    |   27 +++++++++++++++++++++++++++
>  2 files changed, 47 insertions(+), 4 deletions(-)
>  create mode 100644 include/linux/sdhci-pltfm.h
> 
> diff --git a/drivers/mmc/host/sdhci-pltfm.c b/drivers/mmc/host/sdhci-pltfm.c
> index 297f40a..217b911 100644
> --- a/drivers/mmc/host/sdhci-pltfm.c
> +++ b/drivers/mmc/host/sdhci-pltfm.c
> @@ -29,6 +29,7 @@
>  #include <linux/mmc/host.h>
>  
>  #include <linux/io.h>
> +#include <linux/sdhci-pltfm.h>
>  
>  #include "sdhci.h"
>  
> @@ -49,12 +50,11 @@ static struct sdhci_ops sdhci_pltfm_ops = {
>  
>  static int __devinit sdhci_pltfm_probe(struct platform_device *pdev)
>  {
> +	struct sdhci_pltfm_data *pdata = pdev->dev.platform_data;
>  	struct sdhci_host *host;
>  	struct resource *iomem;
>  	int ret;
>  
> -	BUG_ON(pdev == NULL);
> -
>  	iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!iomem) {
>  		ret = -ENOMEM;
> @@ -76,7 +76,12 @@ static int __devinit sdhci_pltfm_probe(struct platform_device *pdev)
>  	}
>  
>  	host->hw_name = "platform";
> -	host->ops = &sdhci_pltfm_ops;
> +	if (pdata && pdata->ops)
> +		host->ops = pdata->ops;
> +	else
> +		host->ops = &sdhci_pltfm_ops;
> +	if (pdata)
> +		host->quirks = pdata->quirks;
>  	host->irq = platform_get_irq(pdev, 0);
>  
>  	if (!request_mem_region(iomem->start, resource_size(iomem),
> @@ -93,6 +98,12 @@ static int __devinit sdhci_pltfm_probe(struct platform_device *pdev)
>  		goto err_remap;
>  	}
>  
> +	if (pdata && pdata->init) {
> +		ret = pdata->init(host);
> +		if (ret)
> +			goto err_plat_init;
> +	}
> +
>  	ret = sdhci_add_host(host);
>  	if (ret)
>  		goto err_add_host;
> @@ -102,6 +113,9 @@ static int __devinit sdhci_pltfm_probe(struct platform_device *pdev)
>  	return 0;
>  
>  err_add_host:
> +	if (pdata && pdata->exit)
> +		pdata->exit(host);
> +err_plat_init:
>  	iounmap(host->ioaddr);
>  err_remap:
>  	release_mem_region(iomem->start, resource_size(iomem));
> @@ -114,6 +128,7 @@ err:
>  
>  static int __devexit sdhci_pltfm_remove(struct platform_device *pdev)
>  {
> +	struct sdhci_pltfm_data *pdata = pdev->dev.platform_data;
>  	struct sdhci_host *host = platform_get_drvdata(pdev);
>  	struct resource *iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	int dead;
> @@ -125,6 +140,8 @@ static int __devexit sdhci_pltfm_remove(struct platform_device *pdev)
>  		dead = 1;
>  
>  	sdhci_remove_host(host, dead);
> +	if (pdata && pdata->exit)
> +		pdata->exit(host);
>  	iounmap(host->ioaddr);
>  	release_mem_region(iomem->start, resource_size(iomem));
>  	sdhci_free_host(host);
> @@ -165,4 +182,3 @@ MODULE_DESCRIPTION("Secure Digital Host Controller Interface platform driver");
>  MODULE_AUTHOR("Mocean Laboratories <info@mocean-labs.com>");
>  MODULE_LICENSE("GPL v2");
>  MODULE_ALIAS("platform:sdhci");
> -
> diff --git a/include/linux/sdhci-pltfm.h b/include/linux/sdhci-pltfm.h
> new file mode 100644
> index 0000000..0aaa334
> --- /dev/null
> +++ b/include/linux/sdhci-pltfm.h
> @@ -0,0 +1,27 @@
> +/*
> + * Platform data declarations for the sdhci-pltfm driver.
> + *
> + * Copyright (c) 2010 MontaVista Software, LLC.
> + *
> + * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or (at
> + * your option) any later version.
> + */
> +
> +#ifndef _SDHCI_PLTFM_H
> +#define _SDHCI_PLTFM_H
> +
> +struct sdhci_ops;
> +struct sdhci_host;
> +
> +struct sdhci_pltfm_data {
> +	struct sdhci_ops *ops;
> +	unsigned int quirks;
> +	int (*init)(struct sdhci_host *host);
> +	void (*exit)(struct sdhci_host *host);
> +};

I would like to see this struct kernel-doc:ed.

> +
> +#endif /* _SDHCI_PLTFM_H */

