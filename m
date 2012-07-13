Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab2GMHDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 03:03:50 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33508 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab2GMHDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 03:03:48 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-49-4fffc84678fc
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: l.majewski@samsung.com, a.kesavan@samsung.com, prashanth.g@samsung.com,
        kmpark@infradead.org, joshi@samsung.com, jy0922.shim@samsung.com,
        sshtylyov@mvista.com, olofj@google.com,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1342072512-29945-1-git-send-email-gautam.vivek@samsung.com>
 <1342072512-29945-3-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1342072512-29945-3-git-send-email-gautam.vivek@samsung.com>
Subject: Re: [PATCH 2/3 v2] USB: ehci-s5p: Add support for device tree
Date: Fri, 13 Jul 2012 16:03:33 +0900
Message-id: <001901cd60c5$9ddb9650$d992c2f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1f8PRa9O9tBCerQBSj1QJdk0pfpgA09HaQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t9jQV23E//9DaY+47G4vGsOm8WiZa3M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGXcvzWVuaBNtOLxyfdMDYy/BboYOTkkBEwkftz6wg5h
	i0lcuLeerYuRi0NIYDqjxJxtj9ghnF+MEtfPrmAGqWITUJP48uUwWEJEYBWjxJKfj1lBHGaB
	O4wS6zfdY4FoaWeU6D13hamLkYODU8BTovuEHUi3sICbxIpf8xhBbBYBVYnOtwuZQGxeAVuJ
	A1sPskPYghI/JoPM4QQaqiWxfudxJghbXmLzmrfMICMlBNQlHv3VBQmLCBhJnOh9yQhRIiKx
	78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4rJ9J
	72Bc1WBxiFGAg1GJh/fZsf/+QqyJZcWVuYcYJTiYlUR4FaYBhXhTEiurUovy44tKc1KLDzFK
	c7AoifOaeH/1FxJITyxJzU5NLUgtgskycXBKNTDK6p2r2rgkTnbOTMZHDzjYHt4OmzfrrNN6
	vYsZYddVJi968ZPdIMB+ZR2rRPS2Az+bLz0pXvfh2g2fOY7235Q5FgY9cPD9G7v8jJubnEnc
	8hV2KlfvsT0J9OGqfn3W8PVZzbumnhkWGzK007Q5110q/PXt/nrpHzpS5yevvfbE4lNFEk+q
	9apmJZbijERDLeai4kQATTz2KGcCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 12, 2012 2:55 PM, Vivek Gautam wrote:
> 
> This patch adds support to parse probe data for
> ehci driver for exynos using device tree
> 
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> 
> diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
> index c474cec..52d0049 100644
> --- a/drivers/usb/host/ehci-s5p.c
> +++ b/drivers/usb/host/ehci-s5p.c
> @@ -13,6 +13,7 @@
>   */
> 
>  #include <linux/clk.h>
> +#include <linux/of.h>
>  #include <linux/platform_device.h>
>  #include <plat/ehci.h>
>  #include <plat/usb-phy.h>
> @@ -63,6 +64,8 @@ static const struct hc_driver s5p_ehci_hc_driver = {
>  	.clear_tt_buffer_complete	= ehci_clear_tt_buffer_complete,
>  };
> 
> +static u64 ehci_s5p_dma_mask = DMA_BIT_MASK(32);
> +
>  static int __devinit s5p_ehci_probe(struct platform_device *pdev)
>  {
>  	struct s5p_ehci_platdata *pdata;
> @@ -79,6 +82,16 @@ static int __devinit s5p_ehci_probe(struct platform_device *pdev)
>  		return -EINVAL;
>  	}
> 
> +	/*
> +	 * Right now device-tree probed devices don't get dma_mask set.
> +	 * Since shared usb code relies on it, set it here for now.
> +	 * Once we move to full device tree support this will vanish off.
> +	 */
> +	if (!pdev->dev.dma_mask)
> +		pdev->dev.dma_mask = &ehci_s5p_dma_mask;
> +	if (!pdev->dev.coherent_dma_mask)
> +		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
> +
>  	s5p_ehci = kzalloc(sizeof(struct s5p_ehci_hcd), GFP_KERNEL);

This makes conflict on 'usb-next' branch.
Please re-base the patch on 'usb-next' branch.


>  	if (!s5p_ehci)
>  		return -ENOMEM;
> @@ -298,6 +311,14 @@ static int s5p_ehci_resume(struct device *dev)
>  #define s5p_ehci_resume		NULL
>  #endif
> 
> +#ifdef CONFIG_OF
> +static const struct of_device_id exynos_ehci_match[] = {
> +	{ .compatible = "samsung,exynos-ehci" },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, exynos_ehci_match);
> +#endif
> +

Please move " struct of_device_id exynos_ehci_match[]"
to the next of "struct dev_pm_ops s5p_ehci_pm_ops",
as you did at 1st patch '[PATCH 1/3 v2] USB: ohci-exynos: Add support for device tree'.

Please keep the code sync as possible.

>  static const struct dev_pm_ops s5p_ehci_pm_ops = {
>  	.suspend	= s5p_ehci_suspend,
>  	.resume		= s5p_ehci_resume,
> @@ -311,6 +332,7 @@ static struct platform_driver s5p_ehci_driver = {
>  		.name	= "s5p-ehci",
>  		.owner	= THIS_MODULE,
>  		.pm	= &s5p_ehci_pm_ops,
> +		.of_match_table = of_match_ptr(exynos_ehci_match),
>  	}
>  };
> 
> --
> 1.7.0.4

