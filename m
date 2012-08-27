Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab2H0Q5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 12:57:48 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64915 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab2H0Q5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 12:57:45 -0400
Message-ID: <503BA696.6080701@mvista.com>
Date: Mon, 27 Aug 2012 20:55:50 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        kernel-janitors@vger.kernel.org,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>
Subject: Re: [PATCH 6/6] i2c: davinci: use devm_ functions
References: <1345916499-6657-6-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1345916499-6657-6-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/25/2012 09:41 PM, Julia Lawall wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>

> The various devm_ functions allocate memory that is released when a driver
> detaches.  This patch uses these functions for data that is allocated in
> the probe function of a platform device and is only freed in the remove
> function.

> The call to platform_get_resource is moved down to the call to
> devm_request_and_ioremap that uses it.

> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

> ---
> Not compiled.

   I see. :-)

> I was not sure what to do with the comment on the first line, so I just
> left it where it is.
> I was also concerned about the calls to get_device and put_device, and
> whether they would cause &pdev->dev to be freed before the devm-allocated
> objects were freed.  Most other platform drivers don't seem to have these
> calls.

>  drivers/i2c/busses/i2c-davinci.c |   51 +++++++++------------------------------
>  1 file changed, 12 insertions(+), 39 deletions(-)

> diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
> index b6185dc..c8e9c87 100644
> --- a/drivers/i2c/busses/i2c-davinci.c
> +++ b/drivers/i2c/busses/i2c-davinci.c
> @@ -647,30 +647,16 @@ static int davinci_i2c_probe(struct platform_device *pdev)
>  	int r;
>  
>  	/* NOTE: driver uses the static register mapping */
> -	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!mem) {
> -		dev_err(&pdev->dev, "no mem resource?\n");
> -		return -ENODEV;
> -	}
> -
>  	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>  	if (!irq) {
>  		dev_err(&pdev->dev, "no irq resource?\n");
>  		return -ENODEV;
>  	}
>  
> -	ioarea = request_mem_region(mem->start, resource_size(mem),
> -				    pdev->name);
> -	if (!ioarea) {
> -		dev_err(&pdev->dev, "I2C region already claimed\n");
> -		return -EBUSY;
> -	}

   Shouldn't you have dropped the 'ioarea' variable? It should be unused now...

> @@ -699,14 +685,15 @@ static int davinci_i2c_probe(struct platform_device *pdev)
[...]
> -	dev->base = ioremap(mem->start, resource_size(mem));
> +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);

   Why you dropped check form 'mem' being NULL?

> +	dev->base = devm_request_and_ioremap(&pdev->dev, mem);
>  	if (!dev->base) {
>  		r = -EBUSY;
>  		goto err_mem_ioremap;
> @@ -714,16 +701,17 @@ static int davinci_i2c_probe(struct platform_device *pdev)
>  
>  	i2c_davinci_init(dev);
>  
> -	r = request_irq(dev->irq, i2c_davinci_isr, 0, pdev->name, dev);
> +	r = devm_request_irq(&pdev->dev, dev->irq, i2c_davinci_isr, 0,
> +			     pdev->name, dev);
>  	if (r) {
>  		dev_err(&pdev->dev, "failure requesting irq %i\n", dev->irq);
> -		goto err_unuse_clocks;
> +		goto err_mem_ioremap;

   The label no longer corresponds the failure happening. Perhaps it's better to
leave 'err_unuse_clocks'...

>  	}
>  
>  	r = i2c_davinci_cpufreq_register(dev);
>  	if (r) {
>  		dev_err(&pdev->dev, "failed to register cpufreq\n");
> -		goto err_free_irq;
> +		goto err_mem_ioremap;

   Ditto...

> @@ -740,26 +728,18 @@ static int davinci_i2c_probe(struct platform_device *pdev)
>  	r = i2c_add_numbered_adapter(adap);
>  	if (r) {
>  		dev_err(&pdev->dev, "failure adding adapter\n");
> -		goto err_free_irq;
> +		goto err_mem_ioremap;

   Ditto...

WBR, Sergei

