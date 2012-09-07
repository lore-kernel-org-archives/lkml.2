Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab2IGSEE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 14:04:04 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59462 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448Ab2IGSEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 14:04:02 -0400
Message-ID: <504A36FF.3020303@ti.com>
Date: Fri, 7 Sep 2012 20:03:43 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Vaibhav Hiremath <hvaibhav@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@ti.com>
Subject: Re: [RFC PATCH] ARM: OMAP2+: omap-device: Do not overwrite resources
 allocated by OF layer
References: <1346233691-10294-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <1346233691-10294-1-git-send-email-hvaibhav@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vaibhav,

The following patch is having some checkpatch issues.
CHECK: Alignment should match open parenthesis
#169: FILE: arch/arm/plat-omap/omap_device.c:591:
+			dev_dbg(&pdev->dev, "%s(): resources already allocated %d\n",
+					__func__, res_count);

CHECK: Alignment should match open parenthesis
#171: FILE: arch/arm/plat-omap/omap_device.c:593:
+			memcpy(res, pdev->resource,
+				sizeof(struct resource) * pdev->num_resources);

CHECK: Alignment should match open parenthesis
#173: FILE: arch/arm/plat-omap/omap_device.c:595:
+			omap_device_fill_dma_resources(od,
+					&res[pdev->num_resources]);

CHECK: Alignment should match open parenthesis
#176: FILE: arch/arm/plat-omap/omap_device.c:598:
+			dev_dbg(&pdev->dev, "%s(): using resources from hwmod %d\n",
+					__func__, res_count);

total: 0 errors, 0 warnings, 4 checks, 130 lines checked


Since I was in a nice mood, because the week-end is almost there, I
fixed them myself.

Please note that I had to rename the API becasue it was way too long to
do a proper alignement.

 omap_device_fill_dma_resources -> _od_fill_dma_resources

In fact I realized that some private APIs should probably be renamed as
well like that for
consistency.

Just let me know if you have any issue with that version.

Regards,
Benoit

---
>From b82b04e8eb27abe0cfe9cd7bf4fee8bb1bb9b013 Mon Sep 17 00:00:00 2001
From: Vaibhav Hiremath <hvaibhav@ti.com>
Date: Wed, 29 Aug 2012 15:18:11 +0530
Subject: [PATCH] ARM: OMAP: omap_device: Do not overwrite resources
allocated by OF layer

With the new devices (like, AM33XX and OMAP5) we now only support
DT boot mode of operation and now it is the time to start killing
slowly the dependency on hwmod, so with this patch, we are starting
with device resources.
The idea here is implemented considering to both boot modes -
  - DT boot mode
    OF framework will construct the resource structure (currently
    does for MEM & IRQ resource) and we should respect/use these
    resources, killing hwmod dependency.
    If pdev->num_resources > 0, we assume that MEM & IRQ resources
    have been allocated by OF layer already (through DTB).

    Once DMA resource is available from OF layer, we should
    kill filling any resources from hwmod.

  - Non-DT boot mode
    Here, pdev->num_resources = 0, and we should get all the
    resources from hwmod (following existing steps)

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Kevin Hilman <khilman@ti.com>
[b-cousson@ti.com: Fix some checkpatch CHECK issues]
Signed-off-by: Benoit Cousson <b-cousson@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod.c             |   27 ++++++++++
 arch/arm/plat-omap/include/plat/omap_hwmod.h |    1 +
 arch/arm/plat-omap/omap_device.c             |   71
+++++++++++++++++++++----
 3 files changed, 87 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod.c
b/arch/arm/mach-omap2/omap_hwmod.c
index 6ca8e51..7768804 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -3158,6 +3158,33 @@ int omap_hwmod_fill_resources(struct omap_hwmod
*oh, struct resource *res)
 }
  /**
+ * omap_hwmod_fill_dma_resources - fill struct resource array with dma data
+ * @oh: struct omap_hwmod *
+ * @res: pointer to the array of struct resource to fill
+ *
+ * Fill the struct resource array @res with dma resource data from the
+ * omap_hwmod @oh.  Intended to be called by code that registers
+ * omap_devices.  See also omap_hwmod_count_resources().  Returns the
+ * number of array elements filled.
+ */
+int omap_hwmod_fill_dma_resources(struct omap_hwmod *oh, struct
resource *res)
+{
+	int i, sdma_reqs_cnt;
+	int r = 0;
+
+	sdma_reqs_cnt = _count_sdma_reqs(oh);
+	for (i = 0; i < sdma_reqs_cnt; i++) {
+		(res + r)->name = (oh->sdma_reqs + i)->name;
+		(res + r)->start = (oh->sdma_reqs + i)->dma_req;
+		(res + r)->end = (oh->sdma_reqs + i)->dma_req;
+		(res + r)->flags = IORESOURCE_DMA;
+		r++;
+	}
+
+	return r;
+}
+
+/**
  * omap_hwmod_get_resource_byname - fetch IP block integration data by name
  * @oh: struct omap_hwmod * to operate on
  * @type: one of the IORESOURCE_* constants from include/linux/ioport.h
diff --git a/arch/arm/plat-omap/include/plat/omap_hwmod.h
b/arch/arm/plat-omap/include/plat/omap_hwmod.h
index 6132972..5857b9c 100644
--- a/arch/arm/plat-omap/include/plat/omap_hwmod.h
+++ b/arch/arm/plat-omap/include/plat/omap_hwmod.h
@@ -615,6 +615,7 @@ int omap_hwmod_softreset(struct omap_hwmod *oh);
  int omap_hwmod_count_resources(struct omap_hwmod *oh);
 int omap_hwmod_fill_resources(struct omap_hwmod *oh, struct resource *res);
+int omap_hwmod_fill_dma_resources(struct omap_hwmod *oh, struct
resource *res);
 int omap_hwmod_get_resource_byname(struct omap_hwmod *oh, unsigned int
type,
 				   const char *name, struct resource *res);
 diff --git a/arch/arm/plat-omap/omap_device.c
b/arch/arm/plat-omap/omap_device.c
index ff57b5a..6f5c580 100644
--- a/arch/arm/plat-omap/omap_device.c
+++ b/arch/arm/plat-omap/omap_device.c
@@ -494,6 +494,33 @@ static int omap_device_fill_resources(struct
omap_device *od,
 }
  /**
+ * _od_fill_dma_resources - fill in array of struct resource with dma
resources
+ * @od: struct omap_device *
+ * @res: pointer to an array of struct resource to be filled in
+ *
+ * Populate one or more empty struct resource pointed to by @res with
+ * the dma resource data for this omap_device @od.  Used by
+ * omap_device_alloc() after calling omap_device_count_resources().
+ *
+ * Ideally this function would not be needed at all.  If we have
+ * mechanism to get dma resources from DT.
+ *
+ * Returns 0.
+ */
+static int _od_fill_dma_resources(struct omap_device *od,
+				      struct resource *res)
+{
+	int i, r;
+
+	for (i = 0; i < od->hwmods_cnt; i++) {
+		r = omap_hwmod_fill_dma_resources(od->hwmods[i], res);
+		res += r;
+	}
+
+	return 0;
+}
+
+/**
  * omap_device_alloc - allocate an omap_device
  * @pdev: platform_device that will be included in this omap_device
  * @oh: ptr to the single omap_hwmod that backs this omap_device
@@ -532,24 +559,44 @@ struct omap_device *omap_device_alloc(struct
platform_device *pdev,
 	od->hwmods = hwmods;
 	od->pdev = pdev;
 +	res_count = omap_device_count_resources(od);
 	/*
-	 * HACK: Ideally the resources from DT should match, and hwmod
-	 * should just add the missing ones. Since the name is not
-	 * properly populated by DT, stick to hwmod resources only.
+	 * DT Boot:
+	 *   OF framework will construct the resource structure (currently
+	 *   does for MEM & IRQ resource) and we should respect/use these
+	 *   resources, killing hwmod dependency.
+	 *   If pdev->num_resources > 0, we assume that MEM & IRQ resources
+	 *   have been allocated by OF layer already (through DTB).
+	 *
+	 * Non-DT Boot:
+	 *   Here, pdev->num_resources = 0, and we should get all the
+	 *   resources from hwmod.
+	 *
+	 * TODO: Once DMA resource is available from OF layer, we should
+	 *   kill filling any resources from hwmod.
 	 */
-	if (pdev->num_resources && pdev->resource)
-		dev_warn(&pdev->dev, "%s(): resources already allocated %d\n",
-			__func__, pdev->num_resources);
-
-	res_count = omap_device_count_resources(od);
-	if (res_count > 0) {
-		dev_dbg(&pdev->dev, "%s(): resources allocated from hwmod %d\n",
-			__func__, res_count);
+	if (res_count > pdev->num_resources) {
+		/* Allocate resources memory to account for new resources */
 		res = kzalloc(sizeof(struct resource) * res_count, GFP_KERNEL);
 		if (!res)
 			goto oda_exit3;
 -		omap_device_fill_resources(od, res);
+		/*
+		 * If pdev->num_resources > 0, then assume that,
+		 * MEM and IRQ resources will only come from DT and only
+		 * fill DMA resource from hwmod layer.
+		 */
+		if (pdev->num_resources && pdev->resource) {
+			dev_dbg(&pdev->dev, "%s(): resources already allocated %d\n",
+				__func__, res_count);
+			memcpy(res, pdev->resource,
+			       sizeof(struct resource) * pdev->num_resources);
+			_od_fill_dma_resources(od, &res[pdev->num_resources]);
+		} else {
+			dev_dbg(&pdev->dev, "%s(): using resources from hwmod %d\n",
+				__func__, res_count);
+			omap_device_fill_resources(od, res);
+		}
  		ret = platform_device_add_resources(pdev, res, res_count);
 		kfree(res);
-- 
1.7.0.4



On 08/29/2012 11:48 AM, Vaibhav Hiremath wrote:
> With the new devices (like, AM33XX and OMAP5) we now only support
> DT boot mode of operation and now it is the time to start killing
> slowly the dependency on hwmod, so with this patch, we are starting
> with device resources.
> The idea here is implemented considering to both boot modes -
>   - DT boot mode
>     OF framework will construct the resource structure (currently
>     does for MEM & IRQ resource) and we should respect/use these
>     resources, killing hwmod dependency.
>     If pdev->num_resources > 0, we assume that MEM & IRQ resources
>     have been allocated by OF layer already (through DTB).
> 
>     Once DMA resource is available from OF layer, we should
>     kill filling any resources from hwmod.
> 
>   - Non-DT boot mode
>     Here, pdev->num_resources = 0, and we should get all the
>     resources from hwmod (following existing steps)
> 
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> Cc: Benoit Cousson <b-cousson@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Paul Walmsley <paul@pwsan.com>
> Cc: Kevin Hilman <khilman@ti.com>
> ---
> This patch is tested on BeagleBone and AM37xEVM.
> 
> Why RFC?
> Still we have function duplication omap_device_fill_resources() and
> omap_device_fill_dma_resources(), we can actually split the function
> into 3 resources and avoid duplication -
>   - omap_device_fill_dma_resources()
>   - omap_device_fill_mem_resources()
>   - omap_device_fill_irq_resources()
> 
> Actually I wanted to clean it further but thought of getting
> feedback first and then proceed further.
> 
>  arch/arm/mach-omap2/omap_hwmod.c             |   27 ++++++++++
>  arch/arm/plat-omap/include/plat/omap_hwmod.h |    1 +
>  arch/arm/plat-omap/omap_device.c             |   72 +++++++++++++++++++++----
>  3 files changed, 88 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
> index 31ec283..edabfb3 100644
> --- a/arch/arm/mach-omap2/omap_hwmod.c
> +++ b/arch/arm/mach-omap2/omap_hwmod.c
> @@ -3330,6 +3330,33 @@ int omap_hwmod_fill_resources(struct omap_hwmod *oh, struct resource *res)
>  }
> 
>  /**
> + * omap_hwmod_fill_dma_resources - fill struct resource array with dma data
> + * @oh: struct omap_hwmod *
> + * @res: pointer to the array of struct resource to fill
> + *
> + * Fill the struct resource array @res with dma resource data from the
> + * omap_hwmod @oh.  Intended to be called by code that registers
> + * omap_devices.  See also omap_hwmod_count_resources().  Returns the
> + * number of array elements filled.
> + */
> +int omap_hwmod_fill_dma_resources(struct omap_hwmod *oh, struct resource *res)
> +{
> +	int i, sdma_reqs_cnt;
> +	int r = 0;
> +
> +	sdma_reqs_cnt = _count_sdma_reqs(oh);
> +	for (i = 0; i < sdma_reqs_cnt; i++) {
> +		(res + r)->name = (oh->sdma_reqs + i)->name;
> +		(res + r)->start = (oh->sdma_reqs + i)->dma_req;
> +		(res + r)->end = (oh->sdma_reqs + i)->dma_req;
> +		(res + r)->flags = IORESOURCE_DMA;
> +		r++;
> +	}
> +
> +	return r;
> +}
> +
> +/**
>   * omap_hwmod_get_resource_byname - fetch IP block integration data by name
>   * @oh: struct omap_hwmod * to operate on
>   * @type: one of the IORESOURCE_* constants from include/linux/ioport.h
> diff --git a/arch/arm/plat-omap/include/plat/omap_hwmod.h b/arch/arm/plat-omap/include/plat/omap_hwmod.h
> index 9b9646c..0533073 100644
> --- a/arch/arm/plat-omap/include/plat/omap_hwmod.h
> +++ b/arch/arm/plat-omap/include/plat/omap_hwmod.h
> @@ -615,6 +615,7 @@ int omap_hwmod_softreset(struct omap_hwmod *oh);
> 
>  int omap_hwmod_count_resources(struct omap_hwmod *oh);
>  int omap_hwmod_fill_resources(struct omap_hwmod *oh, struct resource *res);
> +int omap_hwmod_fill_dma_resources(struct omap_hwmod *oh, struct resource *res);
>  int omap_hwmod_get_resource_byname(struct omap_hwmod *oh, unsigned int type,
>  				   const char *name, struct resource *res);
> 
> diff --git a/arch/arm/plat-omap/omap_device.c b/arch/arm/plat-omap/omap_device.c
> index c490240..fd15a3a 100644
> --- a/arch/arm/plat-omap/omap_device.c
> +++ b/arch/arm/plat-omap/omap_device.c
> @@ -486,6 +486,33 @@ static int omap_device_fill_resources(struct omap_device *od,
>  }
> 
>  /**
> + * omap_device_fill_dma_resources - fill in array of struct resource with dma resources
> + * @od: struct omap_device *
> + * @res: pointer to an array of struct resource to be filled in
> + *
> + * Populate one or more empty struct resource pointed to by @res with
> + * the dma resource data for this omap_device @od.  Used by
> + * omap_device_alloc() after calling omap_device_count_resources().
> + *
> + * Ideally this function would not be needed at all.  If we have
> + * mechanism to get dma resources from DT.
> + *
> + * Returns 0.
> + */
> +static int omap_device_fill_dma_resources(struct omap_device *od,
> +				      struct resource *res)
> +{
> +	int i, r;
> +
> +	for (i = 0; i < od->hwmods_cnt; i++) {
> +		r = omap_hwmod_fill_dma_resources(od->hwmods[i], res);
> +		res += r;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
>   * omap_device_alloc - allocate an omap_device
>   * @pdev: platform_device that will be included in this omap_device
>   * @oh: ptr to the single omap_hwmod that backs this omap_device
> @@ -524,24 +551,45 @@ struct omap_device *omap_device_alloc(struct platform_device *pdev,
>  	od->hwmods = hwmods;
>  	od->pdev = pdev;
> 
> +	res_count = omap_device_count_resources(od);
>  	/*
> -	 * HACK: Ideally the resources from DT should match, and hwmod
> -	 * should just add the missing ones. Since the name is not
> -	 * properly populated by DT, stick to hwmod resources only.
> +	 * DT Boot:
> +	 *   OF framework will construct the resource structure (currently
> +	 *   does for MEM & IRQ resource) and we should respect/use these
> +	 *   resources, killing hwmod dependency.
> +	 *   If pdev->num_resources > 0, we assume that MEM & IRQ resources
> +	 *   have been allocated by OF layer already (through DTB).
> +	 *
> +	 * Non-DT Boot:
> +	 *   Here, pdev->num_resources = 0, and we should get all the
> +	 *   resources from hwmod.
> +	 *
> +	 * TODO: Once DMA resource is available from OF layer, we should
> +	 *   kill filling any resources from hwmod.
>  	 */
> -	if (pdev->num_resources && pdev->resource)
> -		dev_warn(&pdev->dev, "%s(): resources already allocated %d\n",
> -			__func__, pdev->num_resources);
> -
> -	res_count = omap_device_count_resources(od);
> -	if (res_count > 0) {
> -		dev_dbg(&pdev->dev, "%s(): resources allocated from hwmod %d\n",
> -			__func__, res_count);
> +	if (res_count > pdev->num_resources) {
> +		/* Allocate resources memory to account for new resources */
>  		res = kzalloc(sizeof(struct resource) * res_count, GFP_KERNEL);
>  		if (!res)
>  			goto oda_exit3;
> 
> -		omap_device_fill_resources(od, res);
> +		/*
> +		 * If pdev->num_resources > 0, then assume that,
> +		 * MEM and IRQ resources will only come from DT and only
> +		 * fill DMA resource from hwmod layer.
> +		 */
> +		if (pdev->num_resources && pdev->resource) {
> +			dev_dbg(&pdev->dev, "%s(): resources already allocated %d\n",
> +					__func__, res_count);
> +			memcpy(res, pdev->resource,
> +				sizeof(struct resource) * pdev->num_resources);
> +			omap_device_fill_dma_resources(od,
> +					&res[pdev->num_resources]);
> +		} else {
> +			dev_dbg(&pdev->dev, "%s(): using resources from hwmod %d\n",
> +					__func__, res_count);
> +			omap_device_fill_resources(od, res);
> +		}
> 
>  		ret = platform_device_add_resources(pdev, res, res_count);
>  		kfree(res);
> --
> 1.7.0.4
> 

