Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab1B1KMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 05:12:15 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:45302 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296Ab1B1KML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 05:12:11 -0500
Date: Mon, 28 Feb 2011 11:12:05 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Ben Dooks'" <ben-linux@fluff.org>, kernel-janitors@vger.kernel.org,
        "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: RE: [PATCH 1/2] drivers/watchdog/s3c2410_wdt.c: Convert release_resource
 to release_region/release_mem_region
In-Reply-To: <002e01cbd72f$448ac150$cda043f0$%kim@samsung.com>
Message-ID: <Pine.LNX.4.64.1102281110090.14560@pc-004.diku.dk>
References: <1298738079-28893-1-git-send-email-julia@diku.dk>
 <002e01cbd72f$448ac150$cda043f0$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Feb 2011, Kukjin Kim wrote:

> Julia Lawall wrote:
> > 
> > Request_mem_region should be used with release_mem_region, not
> > release_resource.
> > 
> > The semantic match that finds this problem is as follows:
> > (http://coccinelle.lip6.fr/)
> > 
> > // <smpl>
> > @@
> > expression x,E;
> > @@
> > *x = request_mem_region(...)
> > ... when != release_mem_region(x)
> >     when != x = E
> > * release_resource(x);
> > // </smpl>
> > 
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> > 
> > ---
> >  drivers/watchdog/s3c2410_wdt.c |   19 ++++++++-----------
> >  1 file changed, 8 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/watchdog/s3c2410_wdt.c
> b/drivers/watchdog/s3c2410_wdt.c
> > index 25b39bf..95ae53d 100644
> > --- a/drivers/watchdog/s3c2410_wdt.c
> > +++ b/drivers/watchdog/s3c2410_wdt.c
> > @@ -402,7 +402,6 @@ static inline void s3c2410wdt_cpufreq_deregister(void)
> > 
> >  static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
> >  {
> > -	struct resource *res;
> >  	struct device *dev;
> >  	unsigned int wtcon;
> >  	int started = 0;
> > @@ -416,20 +415,19 @@ static int __devinit s3c2410wdt_probe(struct
> > platform_device *pdev)
> > 
> >  	/* get the memory region for the watchdog timer */
> > 
> > -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > -	if (res == NULL) {
> > +	wdt_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	if (wdt_mem == NULL) {
> 
> Hmm...I think, 'res' is better for platform_get_resource().
> Do we _really_ need to change the name?...

wdt_mem is a global variable.  Is res a good name for a global variable?  
One could say wdt_mem = res, if that seems better.

julia

> >  		dev_err(dev, "no memory resource specified\n");
> >  		return -ENOENT;
> >  	}
> > 
> > -	size = resource_size(res);
> > -	wdt_mem = request_mem_region(res->start, size, pdev->name);
> > -	if (wdt_mem == NULL) {
> > +	size = resource_size(wdt_mem);
> > +	if (!request_mem_region(wdt_mem->start, size, pdev->name)) {
> 
> If we keep the name 'res', don't need to change above.
> 
> >  		dev_err(dev, "failed to get memory region\n");
> >  		return -EBUSY;
> >  	}
> > 
> > -	wdt_base = ioremap(res->start, size);
> > +	wdt_base = ioremap(wdt_mem->start, size);
> 
> Same as above.
> 
> >  	if (wdt_base == NULL) {
> >  		dev_err(dev, "failed to ioremap() region\n");
> >  		ret = -EINVAL;
> > @@ -524,8 +522,8 @@ static int __devinit s3c2410wdt_probe(struct
> > platform_device *pdev)
> >  	iounmap(wdt_base);
> > 
> >   err_req:
> > -	release_resource(wdt_mem);
> > -	kfree(wdt_mem);
> > +	release_mem_region(wdt_mem->start, size);
> 
> release_mem_region(res->start, size); ?
> 
> > +	wdt_mem = NULL;
> > 
> >  	return ret;
> >  }
> > @@ -545,8 +543,7 @@ static int __devexit s3c2410wdt_remove(struct
> > platform_device *dev)
> > 
> >  	iounmap(wdt_base);
> > 
> > -	release_resource(wdt_mem);
> > -	kfree(wdt_mem);
> > +	release_mem_region(wdt_mem->start, resource_size(wdt_mem));
> 
> release_mem_region(res->start, resource_size(res)); ?
>
> >  	wdt_mem = NULL;
> >  	return 0;
> >  }
> 
> 
> Thanks.
> 
> Best regards,
> Kgene.
> --
> Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
> SW Solution Development Team, Samsung Electronics Co., Ltd.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
