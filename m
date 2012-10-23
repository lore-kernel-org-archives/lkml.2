Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934089Ab2JWUUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:20:52 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63825 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964936Ab2JWUNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:13:15 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Andreas Larsson <andreas@gaisler.com>
Cc: linux-i2c@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, software@gaisler.com
Subject: Re: [PATCH 1/2] i2c: i2c-ocores: Add irq support for sparc
References: <1351004637-11049-1-git-send-email-andreas@gaisler.com>
	<1351004637-11049-2-git-send-email-andreas@gaisler.com>
Date: Tue, 23 Oct 2012 22:13:08 +0200
In-Reply-To: <1351004637-11049-2-git-send-email-andreas@gaisler.com> (Andreas
	Larsson's message of "Tue, 23 Oct 2012 17:03:56 +0200")
Message-ID: <87wqyhlzfv.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Andreas" == Andreas Larsson <andreas@gaisler.com> writes:

 Andreas> There are no platform resources of type IORESOURCE_IRQ on
 Andreas> sparc, so the irq number is acquired in a different manner for
 Andreas> sparc. The general case uses platform_get_irq, that internally
 Andreas> still uses platform_get_resource.

I have no idea why sparc is being odd in this regard, but assuming this
is how it's done, I'm fine with this change.

A quick grep doesn't find any other drivers doing this though:

git grep -l archdata.irqs drivers | xargs grep platform_get_irq

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>


 Andreas> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
 Andreas> ---
 Andreas>  drivers/i2c/busses/i2c-ocores.c |   13 +++++++++----
 Andreas>  1 files changed, 9 insertions(+), 4 deletions(-)

 Andreas> diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
 Andreas> index bffd550..1eb8a65 100644
 Andreas> --- a/drivers/i2c/busses/i2c-ocores.c
 Andreas> +++ b/drivers/i2c/busses/i2c-ocores.c
 Andreas> @@ -267,16 +267,21 @@ static int __devinit ocores_i2c_probe(struct platform_device *pdev)
 Andreas>  {
 Andreas>  	struct ocores_i2c *i2c;
 Andreas>  	struct ocores_i2c_platform_data *pdata;
 Andreas> -	struct resource *res, *res2;
 Andreas> +	struct resource *res;
 Andreas>  	int ret;
 Andreas>  	int i;
 Andreas> +	int irq;
 
 Andreas>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 Andreas>  	if (!res)
 Andreas>  		return -ENODEV;
 
 Andreas> -	res2 = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 Andreas> -	if (!res2)
 Andreas> +#ifdef CONFIG_SPARC
 Andreas> +	irq = pdev->archdata.irqs[0];
 Andreas> +#else
 Andreas> +	irq = platform_get_irq(pdev, 0);
 Andreas> +#endif
 Andreas> +	if (irq < 0)
 Andreas>  		return -ENODEV;
 
 Andreas>  	i2c = devm_kzalloc(&pdev->dev, sizeof(*i2c), GFP_KERNEL);
 Andreas> @@ -313,7 +318,7 @@ static int __devinit ocores_i2c_probe(struct platform_device *pdev)
 Andreas>  	ocores_init(i2c);
 
 Andreas>  	init_waitqueue_head(&i2c->wait);
 Andreas> -	ret = devm_request_irq(&pdev->dev, res2->start, ocores_isr, 0,
 Andreas> +	ret = devm_request_irq(&pdev->dev, irq, ocores_isr, 0,
 pdev-> name, i2c);
 Andreas>  	if (ret) {
 Andreas>  		dev_err(&pdev->dev, "Cannot claim IRQ\n");
 Andreas> -- 
 Andreas> 1.7.0.4

 Andreas> --
 Andreas> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
 Andreas> the body of a message to majordomo@vger.kernel.org
 Andreas> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Bye, Peter Korsgaard
