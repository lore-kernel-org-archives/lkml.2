Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab0CVI0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 04:26:21 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:37945 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab0CVI0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 04:26:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=LoRux0jY+xYqrJdxnvinCTKU9HVk+6YkvJhOvKwNfXhOo7uwY6+hPwPCWjgJOXtUzv
         FzoRetWt8tJase/sEMutgCe7AWewkMo4kR79nbs/+7+vIcHYZdUi6egY8arNjHgWt0GR
         tLjOH5wLkhtljJXLA/p0YmPJqLuG9ZQC4UHO0=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1003212147360.12371@ask.diku.dk>
References: <Pine.LNX.4.64.1003212147360.12371@ask.diku.dk>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 22 Mar 2010 16:19:04 +0800
Message-ID: <f17812d71003220119i68ecc705ud1422161b77ab2ef@mail.gmail.com>
Subject: Re: [PATCH] arch/arm/mach-pxa: avoid NULL dereference in error 
	handling code
To: Julia Lawall <julia@diku.dk>
Cc: Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 4:48 AM, Julia Lawall <julia@diku.dk> wrote:
> From: Julia Lawall <julia@diku.dk>
>
> The assignments of res to the results of the two calls to
> platform_get_resource make it impossible to use res in the error handling
> code in the arguments to release_mem_region.
>

Nice catch, I've yet made a small change to move the block of getting
dma resource earlier so to avoid introducing another variable pres.

> At the same time, code of the form res->end - res->start + 1 is converted
> to use resource_size.
>

OK, I've separated this into an individual patch with the above one,
rebased against my 'ssp_cleanup' branch as follows (note: the ssp.c
has been moved to plat-pxa for code sharing):

=====================================================
commit 97be6e52dc0aabaea07222bd0486e3b2df3e1baa
Author: Julia Lawall <julia@diku.dk>
Date:   Mon Mar 22 16:11:55 2010 +0800

    [ARM] pxa: avoid NULL dereferencing in error handling of ssp.c

    The assignments of res to the results of the two calls to
    platform_get_resource make it impossible to use res in the error handling
    code in the arguments to release_mem_region.

    The semantic match that finds the former problem is as follows:
    (http://coccinelle.lip6.fr/)

    // <smpl>
    @r exists@
    expression E, E1;
    identifier f;
    statement S1,S3;
    iterator iter;
    @@

    if ((E == NULL && ...) || ...)
    {
     ... when != false ((E == NULL && ...) || ...)
         when != true  ((E != NULL && ...) || ...)
         when != iter(E,...) S1
         when != E = E1
    (
     sizeof(E->f)
    |
    * E->f
    )
     ... when any
     return ...;
    }
    else S3
    // </smpl>

    Signed-off-by: Julia Lawall <julia@diku.dk>
    Signed-off-by: Eric Miao <eric.y.miao@gmail.com>

diff --git a/arch/arm/plat-pxa/ssp.c b/arch/arm/plat-pxa/ssp.c
index cfebcd8..3bf704d 100644
--- a/arch/arm/plat-pxa/ssp.c
+++ b/arch/arm/plat-pxa/ssp.c
@@ -92,6 +92,22 @@ static int __devinit ssp_probe(struct platform_device *pdev)
 		goto err_free;
 	}

+	res = platform_get_resource(pdev, IORESOURCE_DMA, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "no SSP RX DRCMR defined\n");
+		ret = -ENODEV;
+		goto err_free_clk;
+	}
+	ssp->drcmr_rx = res->start;
+
+	res = platform_get_resource(pdev, IORESOURCE_DMA, 1);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "no SSP TX DRCMR defined\n");
+		ret = -ENODEV;
+		goto err_free_clk;
+	}
+	ssp->drcmr_tx = res->start;
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
 		dev_err(&pdev->dev, "no memory resource defined\n");
@@ -123,22 +139,6 @@ static int __devinit ssp_probe(struct
platform_device *pdev)
 		goto err_free_io;
 	}

-	res = platform_get_resource(pdev, IORESOURCE_DMA, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "no SSP RX DRCMR defined\n");
-		ret = -ENODEV;
-		goto err_free_io;
-	}
-	ssp->drcmr_rx = res->start;
-
-	res = platform_get_resource(pdev, IORESOURCE_DMA, 1);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "no SSP TX DRCMR defined\n");
-		ret = -ENODEV;
-		goto err_free_io;
-	}
-	ssp->drcmr_tx = res->start;
-
 	/* PXA2xx/3xx SSP ports starts from 1 and the internal pdev->id
 	 * starts from 0, do a translation here
 	 */

===============================================================================

commit 00921f0d5f21f213b8407d348b53fdce4ad383bd
Author: Julia Lawall <julia@diku.dk>
Date:   Mon Mar 22 16:16:24 2010 +0800

    [ARM] pxa: use resource_size() in ssp.c

    Signed-off-by: Julia Lawall <julia@diku.dk>
    Signed-off-by: Eric Miao <eric.y.miao@gmail.com>

diff --git a/arch/arm/plat-pxa/ssp.c b/arch/arm/plat-pxa/ssp.c
index 3bf704d..52c07cc 100644
--- a/arch/arm/plat-pxa/ssp.c
+++ b/arch/arm/plat-pxa/ssp.c
@@ -115,7 +115,7 @@ static int __devinit ssp_probe(struct platform_device *pdev)
 		goto err_free_clk;
 	}

-	res = request_mem_region(res->start, res->end - res->start + 1,
+	res = request_mem_region(res->start, resource_size(res),
 			pdev->name);
 	if (res == NULL) {
 		dev_err(&pdev->dev, "failed to request memory resource\n");
@@ -125,7 +125,7 @@ static int __devinit ssp_probe(struct platform_device *pdev)

 	ssp->phys_base = res->start;

-	ssp->mmio_base = ioremap(res->start, res->end - res->start + 1);
+	ssp->mmio_base = ioremap(res->start, resource_size(res));
 	if (ssp->mmio_base == NULL) {
 		dev_err(&pdev->dev, "failed to ioremap() registers\n");
 		ret = -ENODEV;
@@ -156,7 +156,7 @@ static int __devinit ssp_probe(struct platform_device *pdev)
 err_free_io:
 	iounmap(ssp->mmio_base);
 err_free_mem:
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 err_free_clk:
 	clk_put(ssp->clk);
 err_free:
@@ -176,7 +176,7 @@ static int __devexit ssp_remove(struct
platform_device *pdev)
 	iounmap(ssp->mmio_base);

 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));

 	clk_put(ssp->clk);
