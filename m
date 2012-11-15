Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767741Ab2KONLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 08:11:40 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44345 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767709Ab2KONLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 08:11:38 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC PATCH 3.7.0-rc2] dt/platform: insert resources correctly into resource tree
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>, rob.herring@calxeda.com
Cc: srinivas.kandagatla@st.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
In-Reply-To: <1351853179-27741-1-git-send-email-srinivas.kandagatla@st.com>
References: <1351853179-27741-1-git-send-email-srinivas.kandagatla@st.com>
Date: Thu, 15 Nov 2012 13:11:33 +0000
Message-Id: <20121115131134.03E5F3E0B12@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  2 Nov 2012 10:46:19 +0000, Srinivas KANDAGATLA <srinivas.kandagatla@st.com> wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> 
> This patch add new code to correctly add resources into platform device.
> Issue with the existing code was the resources are added as flat entry
> without creating any tree, this is very much different to what non-dt
> platform code does.
> 
> With this patch the resources appear correctly as tree in /proc/iomem,
> without this patch the resources in /proc/iomem appear as single entry.
> 
> i2c example in /proc/iomem:
> 
> With-patch:
> 
> fed41000-fed4110f : /soc/i2c-stm@fed41000
>   fed41000-fed4110f : i2c
> 
> Without patch:
> fed41000-fed4110f : i2c
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>

Yes, that is a problem that should be fixed.
Although it seems to me that some powerpc platforms will break due to
nodes with overlapping ranges. That will need to be tested.

I also don't like the duplication of code from platform_device_add().
Does something like this work for you instead? I might need to add an
exception to fallback onto of_device_add if the resource regions
overlay. Or modify platform_device_add() to complain about overlaps, but
not fail when on PowerPC.

g.

---

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 72c776f..2edf831 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -283,7 +283,7 @@ int platform_device_add(struct platform_device *pdev)
 	if (!pdev)
 		return -EINVAL;
 
-	if (!pdev->dev.parent)
+	if (!pdev->dev.parent && !pdev->dev.of_node)
 		pdev->dev.parent = &platform_bus;
 
 	pdev->dev.bus = &platform_bus_type;
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index b80891b..fb9cbad 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -214,16 +214,22 @@ struct platform_device *of_platform_device_create_pdata(
 #if defined(CONFIG_MICROBLAZE)
 	dev->archdata.dma_mask = 0xffffffffUL;
 #endif
+	dev->name = dev_name(&dev->dev);
 	dev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
-	dev->dev.bus = &platform_bus_type;
 	dev->dev.platform_data = platform_data;
+	dev->dev.id = PLATFORM_DEVID_NONE;
+	/* device_add will assume that this device is on the same node as
+	 * the parent. If there is no parent defined, set the node
+	 * explicitly */
+	if (!parent)
+		set_dev_node(&dev->dev, of_node_to_nid(np));
 
 	/* We do not fill the DMA ops for platform devices by default.
 	 * This is currently the responsibility of the platform code
 	 * to do such, possibly using a device notifier
 	 */
 
-	if (of_device_add(dev) != 0) {
+	if (platform_device_add(dev)) {
 		platform_device_put(dev);
 		return NULL;
 	}


> ---
> Hi All, 
> Recently I noticed that appearance of /proc/iomem ouput changed 
> when I started using device trees and the reason for this was 
> the of-plaform code was not adding resources in same way as 
> non-dt platform code does.
> 
> Do you have any reason for not doing it the same way as non-dt platform code?
> 
> This patch is a fixup to that issue.
> 
> Comment?
> thanks,
> srini
> 
>  drivers/of/platform.c |   23 +++++++++++++++++++++++
>  1 files changed, 23 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index b80891b..f43922c 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -203,6 +203,7 @@ struct platform_device *of_platform_device_create_pdata(
>  					struct device *parent)
>  {
>  	struct platform_device *dev;
> +	int i;
>  
>  	if (!of_device_is_available(np))
>  		return NULL;
> @@ -218,6 +219,28 @@ struct platform_device *of_platform_device_create_pdata(
>  	dev->dev.bus = &platform_bus_type;
>  	dev->dev.platform_data = platform_data;
>  
> +	for (i = 0; i < dev->num_resources; i++) {
> +		struct resource *p, *r = &dev->resource[i];
> +
> +		if (r->name == NULL)
> +			r->name = dev_name(&dev->dev);
> +
> +		p = r->parent;
> +		if (!p) {
> +			if (resource_type(r) == IORESOURCE_MEM)
> +				p = &iomem_resource;
> +			else if (resource_type(r) == IORESOURCE_IO)
> +				p = &ioport_resource;
> +		}
> +
> +		if (p && insert_resource(p, r)) {
> +			pr_err("%s: failed to claim resource %d\n",
> +			       dev_name(&dev->dev), i);
> +			platform_device_put(dev);
> +			return NULL;
> +		}
> +	}
> +
>  	/* We do not fill the DMA ops for platform devices by default.
>  	 * This is currently the responsibility of the platform code
>  	 * to do such, possibly using a device notifier
> -- 
> 1.7.0.4
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
