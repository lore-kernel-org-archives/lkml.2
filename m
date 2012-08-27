Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab2H0REP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:04:15 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:49109 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753652Ab2H0REN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:04:13 -0400
X-IronPort-AV: E=Sophos;i="4.80,321,1344204000"; 
   d="scan'208";a="170967314"
Date: Mon, 27 Aug 2012 19:04:10 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Sergei Shtylyov <sshtylyov@mvista.com>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        kernel-janitors@vger.kernel.org,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>
Subject: Re: [PATCH 6/6] i2c: davinci: use devm_ functions
In-Reply-To: <503BA696.6080701@mvista.com>
Message-ID: <alpine.DEB.2.02.1208271900520.2079@hadrien>
References: <1345916499-6657-6-git-send-email-Julia.Lawall@lip6.fr> <503BA696.6080701@mvista.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > -	ioarea = request_mem_region(mem->start, resource_size(mem),
> > -				    pdev->name);
> > -	if (!ioarea) {
> > -		dev_err(&pdev->dev, "I2C region already claimed\n");
> > -		return -EBUSY;
> > -	}
>
>    Shouldn't you have dropped the 'ioarea' variable? It should be unused now...

Indeed, this is probably the case.  I will check.

> > @@ -699,14 +685,15 @@ static int davinci_i2c_probe(struct platform_device *pdev)
> [...]
> > -	dev->base = ioremap(mem->start, resource_size(mem));
> > +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>
>    Why you dropped check form 'mem' being NULL?

devm_request_and_ioremap does the check.  There have been some discussions
about this before.  Since the code is overall complicated and error-prone,
it seems better to minimize it when possible.

> > +	dev->base = devm_request_and_ioremap(&pdev->dev, mem);
> >  	if (!dev->base) {
> >  		r = -EBUSY;
> >  		goto err_mem_ioremap;
> > @@ -714,16 +701,17 @@ static int davinci_i2c_probe(struct platform_device *pdev)
> >
> >  	i2c_davinci_init(dev);
> >
> > -	r = request_irq(dev->irq, i2c_davinci_isr, 0, pdev->name, dev);
> > +	r = devm_request_irq(&pdev->dev, dev->irq, i2c_davinci_isr, 0,
> > +			     pdev->name, dev);
> >  	if (r) {
> >  		dev_err(&pdev->dev, "failure requesting irq %i\n", dev->irq);
> > -		goto err_unuse_clocks;
> > +		goto err_mem_ioremap;
>
>    The label no longer corresponds the failure happening. Perhaps it's better to
> leave 'err_unuse_clocks'...

OK.  It seemed nicer not to have a stack of empty labels...

I'll send another patch shortly.

julia

> >  	}
> >
> >  	r = i2c_davinci_cpufreq_register(dev);
> >  	if (r) {
> >  		dev_err(&pdev->dev, "failed to register cpufreq\n");
> > -		goto err_free_irq;
> > +		goto err_mem_ioremap;
>
>    Ditto...
>
> > @@ -740,26 +728,18 @@ static int davinci_i2c_probe(struct platform_device *pdev)
> >  	r = i2c_add_numbered_adapter(adap);
> >  	if (r) {
> >  		dev_err(&pdev->dev, "failure adding adapter\n");
> > -		goto err_free_irq;
> > +		goto err_mem_ioremap;
>
>    Ditto...
>
> WBR, Sergei
>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
