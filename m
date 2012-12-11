Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab2LKVbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 16:31:38 -0500
Received: from host-176-100-244-43.masterbit.su ([176.100.244.43]:59741 "EHLO
	tservice.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442Ab2LKVbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 16:31:37 -0500
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Dec 2012 16:31:36 EST
Date: Wed, 12 Dec 2012 01:25:56 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers/w1/masters/mxc_w1.c: use devm_ functions
Message-ID: <20121211212555.GA15333@ioremap.net>
References: <1354835724-26945-2-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354835724-26945-2-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Dec 07, 2012 at 12:15:24AM +0100, Julia Lawall (Julia.Lawall@lip6.fr) wrote:
> +	mdev = devm_kzalloc(&pdev->dev, sizeof(struct mxc_w1_device),
> +			    GFP_KERNEL);
>  	if (!mdev)
>  		return -ENOMEM;
>  
> -	mdev->clk = clk_get(&pdev->dev, NULL);
> -	if (IS_ERR(mdev->clk)) {
> -		err = PTR_ERR(mdev->clk);
> -		goto failed_clk;
> -	}
> +	mdev->clk = devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(mdev->clk))
> +		return PTR_ERR(mdev->clk);
>  
>  	mdev->clkdiv = (clk_get_rate(mdev->clk) / 1000000) - 1;
>  
> -	res = request_mem_region(res->start, resource_size(res),
> -				"mxc_w1");
> -	if (!res) {
> -		err = -EBUSY;
> -		goto failed_req;
> -	}
> -
> -	mdev->regs = ioremap(res->start, resource_size(res));
> -	if (!mdev->regs) {
> -		dev_err(&pdev->dev, "Cannot map mxc_w1 registers\n");
> -		goto failed_ioremap;
> -	}
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	mdev->regs = devm_request_and_ioremap(&pdev->dev, res);
> +	if (!mdev->regs)
> +		return -EBUSY;

I suppose mdev will be automatically freed, but who will release
mdev->clk and other private members of mdev structure?

-- 
	Evgeniy Polyakov
