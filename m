Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab2GPGks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 02:40:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37917 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab2GPGkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 02:40:45 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-f2-5003b753483c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: l.majewski@samsung.com, a.kesavan@samsung.com, prashanth.g@samsung.com,
        kmpark@infradead.org, joshi@samsung.com, olofj@google.com,
        jy0922.shim@samsung.com, thomas.abraham@linaro.org,
        sshtylyov@mvista.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1342418138-6192-1-git-send-email-gautam.vivek@samsung.com>
 <1342418138-6192-4-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1342418138-6192-4-git-send-email-gautam.vivek@samsung.com>
Subject: Re: [PATCH 3/3 v3] USB: ehci-s5p: Add vbus setup function to the s5p
 ehci glue layer
Date: Mon, 16 Jul 2012 15:40:18 +0900
Message-id: <002901cd631d$ddbcc5f0$993651d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1jFaD8CQBakXZiSOWr+Cb8HCsaiQACCYlA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jQd3g7cwBBp3PeC0u75rDZrFoWSuz
	A5PH501yAYxRXDYpqTmZZalF+nYJXBlPd05hK/jKV/H83TmmBsZJPF2MnBwSAiYS929NYIGw
	xSQu3FvP1sXIxSEkMJ1R4uqBRYwgCSGBX4wS79/ag9hsAmoSX74cZgcpEhFYxSix5OdjVhCH
	WeAno8TDvhUsEO2tjBIbf30Haufg4BTwkDj71QPEFBaIl7i+mB1kEIuAqsScR01MIDavgK3E
	z6XPGCFsQYkfk++BXcQsoCWxfudxJghbXmLzmrfMIGMkBNQlHv3VBQmLCBhJXP6ymg2iRERi
	34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwSD+T
	3sG4qsHiEKMAB6MSD6/FBuYAIdbEsuLK3EOMEhzMSiK8nZ1AId6UxMqq1KL8+KLSnNTiQ4zS
	HCxK4rwm3l/9hQTSE0tSs1NTC1KLYLJMHJxSDYxZz99zLLxXPft62+uThXqK//6K8B2vnODN
	x/75TSX7Pfkvh6SSzZ/viJ576Edg3u8J4hXlK18mmx9uf63gcYvhyO9nXMcbhAMT2GIFhben
	Hv77k8dE+s1M9Q8ysrM+JwXNb6jqke7u8zvir1YmqLjtAffse98WXmjiKJM5p3JN/Ovf7OK7
	qcxKLMUZiYZazEXFiQAaOrVsZQIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 16, 2012 2:56 PM, Vivek Gautam wrote:
> 
> This patch retrieves and configures the vbus control gpio via
> the device tree. The suspend/resume callbacks will be later
> modified for vbus control.
> 
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

> 
> diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
> index 37d84cf..4037878 100644
> --- a/drivers/usb/host/ehci-s5p.c
> +++ b/drivers/usb/host/ehci-s5p.c
> @@ -15,6 +15,7 @@
>  #include <linux/clk.h>
>  #include <linux/of.h>
>  #include <linux/platform_device.h>
> +#include <linux/of_gpio.h>
>  #include <plat/ehci.h>
>  #include <plat/usb-phy.h>
> 
> @@ -64,6 +65,28 @@ static const struct hc_driver s5p_ehci_hc_driver = {
>  	.clear_tt_buffer_complete	= ehci_clear_tt_buffer_complete,
>  };
> 
> +static int s5p_ehci_setup_gpio(struct platform_device *pdev)
> +{
> +	int err;
> +	int gpio;
> +
> +	if (!pdev->dev.of_node)
> +		return 0;
> +
> +	gpio = of_get_named_gpio(pdev->dev.of_node,
> +			"samsung,vbus-gpio", 0);
> +	if (!gpio_is_valid(gpio))
> +		return 0;
> +
> +	err = gpio_request_one(gpio, GPIOF_OUT_INIT_HIGH, "ehci_vbus_gpio");
> +	if (err) {
> +		dev_err(&pdev->dev, "can't request ehci vbus gpio %d", gpio);
> +		return err;
> +	}
> +
> +	return err;
> +}
> +
>  static u64 ehci_s5p_dma_mask = DMA_BIT_MASK(32);
> 
>  static int __devinit s5p_ehci_probe(struct platform_device *pdev)
> @@ -92,6 +115,8 @@ static int __devinit s5p_ehci_probe(struct platform_device *pdev)
>  	if (!pdev->dev.coherent_dma_mask)
>  		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
> 
> +	s5p_ehci_setup_gpio(pdev);
> +
>  	s5p_ehci = devm_kzalloc(&pdev->dev, sizeof(struct s5p_ehci_hcd),
>  				GFP_KERNEL);
>  	if (!s5p_ehci)
> --
> 1.7.0.4

