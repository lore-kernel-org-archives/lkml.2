Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab2GMHE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 03:04:58 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:34090 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab2GMHE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 03:04:56 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-ee-4fffc897c713
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: l.majewski@samsung.com, a.kesavan@samsung.com, prashanth.g@samsung.com,
        kmpark@infradead.org, joshi@samsung.com, jy0922.shim@samsung.com,
        sshtylyov@mvista.com, olofj@google.com,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1342072512-29945-1-git-send-email-gautam.vivek@samsung.com>
 <1342072512-29945-2-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1342072512-29945-2-git-send-email-gautam.vivek@samsung.com>
Subject: Re: [PATCH 1/3 v2] USB: ohci-exynos: Add support for device tree
Date: Fri, 13 Jul 2012 16:04:55 +0900
Message-id: <001a01cd60c5$ceb848e0$6c28daa0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1f8PMpgXg3ISqcRgiQUKtSpqlzswA1LInw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t9jAd3pJ/77G7zYYWlxedccNotFy1qZ
	HZg8Pm+SC2CM4rJJSc3JLEst0rdL4Mo4t30NS8FJ4Yrbn06wNjC+5u9i5OSQEDCReHCjkxXC
	FpO4cG89WxcjF4eQwCJGiUmHjzFCOL8YJf5dWscGUsUmoCbx5cthdpCEiMAqRoklPx+zgjjM
	AncYJdZvuscCUiUk0M4ocfd3BIjNKeApcX3RG7BuYSD74rV/7CA2i4CqxPf9J8HqeQVsJXbu
	XsgIYQtK/JgMMYdZQEti/c7jTBC2vMTmNW+Zuxg5gG5Vl3j0VxckLCJgJLFn/gyoEhGJfS/e
	MU5gFJqFZNIsJJNmIZk0C0nLAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBYf1Magfj
	ygaLQ4wCHIxKPLw7dv/3F2JNLCuuzD3EKMHBrCTCqzANKMSbklhZlVqUH19UmpNafIhRmoNF
	SZzX2Purv5BAemJJanZqakFqEUyWiYNTqoExayWviMg764+/lylf0Pw+t+dVyGOtxbs6LRIP
	X7VePev8K6GKwkC195O5Z7S6NPmeiPe+wa1lcONH+tZJpzXu2Rr39h+amKB3aH7pjsZyK4G4
	BL9/kVKsma6LRGQdp7791jcrIDea+X535N9gN7uJrwRPRq44V8Szc3rJgW7jmBW6Zy8ofe5V
	YinOSDTUYi4qTgQAY0uMomcCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 12, 2012 2:55 PM, Vivek Gautam wrote:
> 
> This patch adds support to parse probe data for
> ohci driver for exynos using device tree.
> 
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> 
> diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
> index 2909621..c4ad60f 100644
> --- a/drivers/usb/host/ohci-exynos.c
> +++ b/drivers/usb/host/ohci-exynos.c
> @@ -12,6 +12,7 @@
>   */
> 
>  #include <linux/clk.h>
> +#include <linux/of.h>
>  #include <linux/platform_device.h>
>  #include <mach/ohci.h>
>  #include <plat/usb-phy.h>
> @@ -71,6 +72,8 @@ static const struct hc_driver exynos_ohci_hc_driver = {
>  	.start_port_reset	= ohci_start_port_reset,
>  };
> 
> +static u64 ohci_exynos_dma_mask = DMA_BIT_MASK(32);
> +
>  static int __devinit exynos_ohci_probe(struct platform_device *pdev)
>  {
>  	struct exynos4_ohci_platdata *pdata;
> @@ -87,6 +90,16 @@ static int __devinit exynos_ohci_probe(struct platform_device *pdev)
>  		return -EINVAL;
>  	}
> 
> +	/*
> +	 * Right now device-tree probed devices don't get dma_mask set.
> +	 * Since shared usb code relies on it, set it here for now.
> +	 * Once we move to full device tree support this will vanish off.
> +	 */
> +	if (!pdev->dev.dma_mask)
> +		pdev->dev.dma_mask = &ohci_exynos_dma_mask;
> +	if (!pdev->dev.coherent_dma_mask)
> +		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
> +
>  	exynos_ohci = kzalloc(sizeof(struct exynos_ohci_hcd), GFP_KERNEL);

This makes conflict on 'usb-next' branch.
Please re-base the patch on 'usb-next' branch.

>  	if (!exynos_ohci)
>  		return -ENOMEM;
> @@ -258,6 +271,14 @@ static const struct dev_pm_ops exynos_ohci_pm_ops = {
>  	.resume		= exynos_ohci_resume,
>  };
> 
> +#ifdef CONFIG_OF
> +static const struct of_device_id exynos_ohci_match[] = {
> +	{ .compatible = "samsung,exynos-ohci" },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, exynos_ohci_match);
> +#endif
> +
>  static struct platform_driver exynos_ohci_driver = {
>  	.probe		= exynos_ohci_probe,
>  	.remove		= __devexit_p(exynos_ohci_remove),
> @@ -266,6 +287,7 @@ static struct platform_driver exynos_ohci_driver = {
>  		.name	= "exynos-ohci",
>  		.owner	= THIS_MODULE,
>  		.pm	= &exynos_ohci_pm_ops,
> +		.of_match_table	= of_match_ptr(exynos_ohci_match),
>  	}
>  };
> 
> --
> 1.7.0.4

