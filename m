Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab1B1KHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 05:07:15 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:46296 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab1B1KHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 05:07:14 -0500
Date: Mon, 28 Feb 2011 19:07:07 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH 1/2] drivers/watchdog/s3c2410_wdt.c: Convert
 release_resource to release_region/release_mem_region
In-reply-to: <1298738079-28893-1-git-send-email-julia@diku.dk>
To: "'Julia Lawall'" <julia@diku.dk>, "'Ben Dooks'" <ben-linux@fluff.org>
Cc: kernel-janitors@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-id: <002e01cbd72f$448ac150$cda043f0$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcvV0xbypL/oSPNeTu+Ya7vzSCiJFQBWkz8Q
References: <1298738079-28893-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> 
> Request_mem_region should be used with release_mem_region, not
> release_resource.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression x,E;
> @@
> *x = request_mem_region(...)
> ... when != release_mem_region(x)
>     when != x = E
> * release_resource(x);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/watchdog/s3c2410_wdt.c |   19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/watchdog/s3c2410_wdt.c
b/drivers/watchdog/s3c2410_wdt.c
> index 25b39bf..95ae53d 100644
> --- a/drivers/watchdog/s3c2410_wdt.c
> +++ b/drivers/watchdog/s3c2410_wdt.c
> @@ -402,7 +402,6 @@ static inline void s3c2410wdt_cpufreq_deregister(void)
> 
>  static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
>  {
> -	struct resource *res;
>  	struct device *dev;
>  	unsigned int wtcon;
>  	int started = 0;
> @@ -416,20 +415,19 @@ static int __devinit s3c2410wdt_probe(struct
> platform_device *pdev)
> 
>  	/* get the memory region for the watchdog timer */
> 
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (res == NULL) {
> +	wdt_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (wdt_mem == NULL) {

Hmm...I think, 'res' is better for platform_get_resource().
Do we _really_ need to change the name?...

>  		dev_err(dev, "no memory resource specified\n");
>  		return -ENOENT;
>  	}
> 
> -	size = resource_size(res);
> -	wdt_mem = request_mem_region(res->start, size, pdev->name);
> -	if (wdt_mem == NULL) {
> +	size = resource_size(wdt_mem);
> +	if (!request_mem_region(wdt_mem->start, size, pdev->name)) {

If we keep the name 'res', don't need to change above.

>  		dev_err(dev, "failed to get memory region\n");
>  		return -EBUSY;
>  	}
> 
> -	wdt_base = ioremap(res->start, size);
> +	wdt_base = ioremap(wdt_mem->start, size);

Same as above.

>  	if (wdt_base == NULL) {
>  		dev_err(dev, "failed to ioremap() region\n");
>  		ret = -EINVAL;
> @@ -524,8 +522,8 @@ static int __devinit s3c2410wdt_probe(struct
> platform_device *pdev)
>  	iounmap(wdt_base);
> 
>   err_req:
> -	release_resource(wdt_mem);
> -	kfree(wdt_mem);
> +	release_mem_region(wdt_mem->start, size);

release_mem_region(res->start, size); ?

> +	wdt_mem = NULL;
> 
>  	return ret;
>  }
> @@ -545,8 +543,7 @@ static int __devexit s3c2410wdt_remove(struct
> platform_device *dev)
> 
>  	iounmap(wdt_base);
> 
> -	release_resource(wdt_mem);
> -	kfree(wdt_mem);
> +	release_mem_region(wdt_mem->start, resource_size(wdt_mem));

release_mem_region(res->start, resource_size(res)); ?

>  	wdt_mem = NULL;
>  	return 0;
>  }


Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

