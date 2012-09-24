Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab2IXKAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 06:00:42 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:38297 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab2IXKAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 06:00:40 -0400
Message-id: <50602F45.1020205@samsung.com>
Date: Mon, 24 Sep 2012 12:00:37 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
MIME-version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Peter Senna Tschudin <peter.senna@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: Fwd: [PATCH v2] drivers/media/platform/s5p-tv/sdo_drv.c: fix error
 return code
References: <1346920709-8711-1-git-send-email-peter.senna@gmail.com>
 <505F6362.5090602@redhat.com>
In-reply-to: <505F6362.5090602@redhat.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2012 09:30 PM, Mauro Carvalho Chehab wrote:
> Sylwester,
> 
> Please review.
> 
> Regards,
> Mauro
> 
> -------- Mensagem original --------
> Assunto: [PATCH v2] drivers/media/platform/s5p-tv/sdo_drv.c: fix error return code
> Data: Thu,  6 Sep 2012 10:38:29 +0200
> De: Peter Senna Tschudin <peter.senna@gmail.com>
> Para: peter.senna@gmail.com, Mauro Carvalho Chehab <mchehab@infradead.org>
> CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
> 
> From: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> Convert a nonnegative error return code to a negative one, as returned
> elsewhere in the function.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> (
> if@p1 (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret@p1 = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
> 
> // </smpl>
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> ---
>  drivers/media/platform/s5p-tv/sdo_drv.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
> index ad68bbe..58cf56d 100644
> --- a/drivers/media/platform/s5p-tv/sdo_drv.c
> +++ b/drivers/media/platform/s5p-tv/sdo_drv.c
> @@ -369,6 +369,7 @@ static int __devinit sdo_probe(struct platform_device *pdev)
>  	sdev->fout_vpll = clk_get(dev, "fout_vpll");
>  	if (IS_ERR_OR_NULL(sdev->fout_vpll)) {
>  		dev_err(dev, "failed to get clock 'fout_vpll'\n");
> +		ret = -ENXIO;

This patch improves the situation but it doesn't look like a proper fix
to me. First of all clk_get() return code should be checked only with
IS_ERR() and the error code should be propagated up to the caller, rather
than overwriting it with -ENXIO. It's important especially in cases where,
e.g we are getting EPROBE_DEFER instead of a valid resource.

>  		goto fail_dacphy;
>  	}
>  	dev_info(dev, "fout_vpll.rate = %lu\n", clk_get_rate(sclk_vpll));
> @@ -377,11 +378,13 @@ static int __devinit sdo_probe(struct platform_device *pdev)
>  	sdev->vdac = devm_regulator_get(dev, "vdd33a_dac");
>  	if (IS_ERR_OR_NULL(sdev->vdac)) {
>  		dev_err(dev, "failed to get regulator 'vdac'\n");
> +		ret = -ENXIO;

Same situation here..

>  		goto fail_fout_vpll;
>  	}
>  	sdev->vdet = devm_regulator_get(dev, "vdet");
>  	if (IS_ERR_OR_NULL(sdev->vdet)) {
>  		dev_err(dev, "failed to get regulator 'vdet'\n");
> +		ret = -ENXIO;
>  		goto fail_fout_vpll;
>  	}

end here.

I think something more like this is needed (I'm going to queue this
patch for 3.7):

8<------------------------------------------------------------------
>From 8d3ce303461a2c09991efc5b86a0f56789045fa9 Mon Sep 17 00:00:00 2001
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Date: Mon, 24 Sep 2012 10:37:51 +0200
Subject: [PATCH] s5p-tv: Fix return value in sdo_probe() on error paths

Use proper return value test for clk_get() and devm_regulator_get()
functions and propagate any errors from the clock and the regulator
subsystem to the driver core. In two cases a proper error code is
now returned rather than 0.

Reported-by: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-tv/sdo_drv.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c
b/drivers/media/platform/s5p-tv/sdo_drv.c
index ad68bbe..2d1a654 100644
--- a/drivers/media/platform/s5p-tv/sdo_drv.c
+++ b/drivers/media/platform/s5p-tv/sdo_drv.c
@@ -341,47 +341,50 @@ static int __devinit sdo_probe(struct platform_device *pdev)

 	/* acquire clocks */
 	sdev->sclk_dac = clk_get(dev, "sclk_dac");
-	if (IS_ERR_OR_NULL(sdev->sclk_dac)) {
+	if (IS_ERR(sdev->sclk_dac)) {
 		dev_err(dev, "failed to get clock 'sclk_dac'\n");
-		ret = -ENXIO;
+		ret = PTR_ERR(sdev->sclk_dac);
 		goto fail;
 	}
 	sdev->dac = clk_get(dev, "dac");
-	if (IS_ERR_OR_NULL(sdev->dac)) {
+	if (IS_ERR(sdev->dac)) {
 		dev_err(dev, "failed to get clock 'dac'\n");
-		ret = -ENXIO;
+		ret = PTR_ERR(sdev->dac);
 		goto fail_sclk_dac;
 	}
 	sdev->dacphy = clk_get(dev, "dacphy");
-	if (IS_ERR_OR_NULL(sdev->dacphy)) {
+	if (IS_ERR(sdev->dacphy)) {
 		dev_err(dev, "failed to get clock 'dacphy'\n");
-		ret = -ENXIO;
+		ret = PTR_ERR(sdev->dacphy);
 		goto fail_dac;
 	}
 	sclk_vpll = clk_get(dev, "sclk_vpll");
-	if (IS_ERR_OR_NULL(sclk_vpll)) {
+	if (IS_ERR(sclk_vpll)) {
 		dev_err(dev, "failed to get clock 'sclk_vpll'\n");
-		ret = -ENXIO;
+		ret = PTR_ERR(sclk_vpll);
 		goto fail_dacphy;
 	}
 	clk_set_parent(sdev->sclk_dac, sclk_vpll);
 	clk_put(sclk_vpll);
 	sdev->fout_vpll = clk_get(dev, "fout_vpll");
-	if (IS_ERR_OR_NULL(sdev->fout_vpll)) {
+	if (IS_ERR(sdev->fout_vpll)) {
 		dev_err(dev, "failed to get clock 'fout_vpll'\n");
+		ret = PTR_ERR(sdev->fout_vpll);
 		goto fail_dacphy;
 	}
 	dev_info(dev, "fout_vpll.rate = %lu\n", clk_get_rate(sclk_vpll));

 	/* acquire regulator */
 	sdev->vdac = devm_regulator_get(dev, "vdd33a_dac");
-	if (IS_ERR_OR_NULL(sdev->vdac)) {
+	if (IS_ERR(sdev->vdac)) {
 		dev_err(dev, "failed to get regulator 'vdac'\n");
+		ret = PTR_ERR(sdev->vdac);
 		goto fail_fout_vpll;
 	}
 	sdev->vdet = devm_regulator_get(dev, "vdet");
-	if (IS_ERR_OR_NULL(sdev->vdet)) {
+	if (IS_ERR(sdev->vdet)) {
 		dev_err(dev, "failed to get regulator 'vdet'\n");
+		ret = PTR_ERR(sdev->vdet);
 		goto fail_fout_vpll;
 	}

-- 
1.7.11.3
8<------------------------------------------------------------------


Regards,
Sylwester
