Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab0ICNm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 09:42:27 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:51252 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab0ICNmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 09:42:09 -0400
Message-ID: <4C80FB05.1040706@atmel.com>
Date: Fri, 03 Sep 2010 15:41:25 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.8) Gecko/20100802 Lightning/1.0b2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Paul Chavent <paul.chavent@fnac.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, jkosina@suse.cz, richard.cochran@omicron.at,
        jpirko@redhat.com, davem@davemloft.net
Subject: Re: [PATCH] arm driver net macb
References: <4C800BAF.2090003@fnac.net>
In-Reply-To: <4C800BAF.2090003@fnac.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 02/09/2010 22:40, Paul Chavent :
> When listing processes on a system with SOFT/HARD_IRQ enabled, the name
> of the ethernet device is [irq/eth%d] (instead of [irq/eth0] for example).
> 
> This patch call the request_irq function after having initialized the
> name of the device.
> 
> Signed-off-by: Paul Chavent <paul.chavent@fnac.net>

[..]

> @@ -1214,13 +1281,23 @@
>  	err = register_netdev(dev);
>  	if (err) {
>  		dev_err(&pdev->dev, "Cannot register net device, aborting.\n");
> -		goto err_out_free_irq;
> +		goto err_out_iounmap;
>  	}
>  
>  	if (macb_mii_init(bp) != 0) {
>  		goto err_out_unregister_netdev;
>  	}
>  
> +	dev->irq = platform_get_irq(pdev, 0);
> +	err = request_irq(dev->irq, macb_interrupt, IRQF_SAMPLE_RANDOM,
> +			  dev->name, dev);
> +	if (err) {
> +		printk(KERN_ERR
> +		       "%s: Unable to request IRQ %d (error %d)\n",
> +		       dev->name, dev->irq, err);
> +		goto err_out_unregister_netdev;
> +	}
> +

The string is modified in register_netdev() so why don't you deal 
with IRQ just after it? I would have placed the code snippet 
before macb_mii_init(): what do you think about this?

Best regards,
-- 
Nicolas Ferre

