Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933654Ab2JLOG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 10:06:57 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:51545 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932611Ab2JLOG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 10:06:56 -0400
MIME-Version: 1.0
In-Reply-To: <1350048519.10584.158.camel@smile>
References: <142ef9170a2c69657d8a05ac127a9970d7b04965.1350020375.git.viresh.kumar@linaro.org>
	<91e41b4cc972d298f714cbd6f400569a9710304c.1350020375.git.viresh.kumar@linaro.org>
	<1350048519.10584.158.camel@smile>
Date: Fri, 12 Oct 2012 19:36:55 +0530
Message-ID: <CAKohpok=nv2XnFdPkD_yJgUsDqx2gEh=mG_Xhbe-BvT7swVsyg@mail.gmail.com>
Subject: Re: [PATCH 2/3] dmaengine: dw_dmac: Enhance device tree support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
Cc: "Koul, Vinod" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spear-devel@list.st.com" <spear-devel@list.st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 October 2012 18:58, Shevchenko, Andriy
<andriy.shevchenko@intel.com> wrote:
> On Fri, 2012-10-12 at 11:14 +0530, Viresh Kumar wrote:

>> +     if (!of_property_read_u32(np, "chan_allocation_order",
>> +                             &val))
> Fits one line?

yes.

>> +             pdata->chan_allocation_order = (unsigned char)val;
> do we really need explicit casting here?

Obviously not, bigger to smaller is automatically casted. My coding standard is
going down :(

Same for all casting comments.

>> +     if (!of_property_read_u32(np, "nr_masters", &val)) {
>> +             if (val > 4)
> I thought once that we might introduce constant like #define
> DW_MAX_AHB_MASTERS 4. It seems a bit useless because hw is designed for
> that number anyway, but maybe you have another opinion.

Not everyone have four masters in there SoC configurations. So its better
to export correct values.

>> +     if (!of_property_read_u32_array(np, "data_width", arr,
>> +                             pdata->nr_masters))
>> +             for (count = 0; count < pdata->nr_masters; count++)
>> +                     pdata->data_width[count] = arr[count];
> Ah, it would be nice to have of_property_read_u8_array and so on...

:)
Maybe yes. I don't want to do it with this patchset, as that will take more
time to go through maintainers.

>> +     /* calculate number of slaves */
>> +     for_each_child_of_node(sn, cn)
>> +             count++;
>
> of.h: static inline int of_get_child_count(const struct device_node *np)

Hehe.. Will use that.
This proves there is no efficient way of finding child nodes, than this.

>> +     for_each_child_of_node(sn, cn) {
>> +             of_property_read_string(cn, "bus_id", &sd[count].bus_id);
>> +             of_property_read_u32(cn, "cfg_hi", &sd[count].cfg_hi);
>> +             of_property_read_u32(cn, "cfg_lo", &sd[count].cfg_lo);
>> +             if (!of_property_read_u32(cn, "src_master", &val))
>> +                     sd[count].src_master = (u8)val;
>> +
>> +             if (!of_property_read_u32(cn, "dst_master", &val))
>> +                     sd[count].dst_master = (u8)val;
>> +
>> +             sd[count].dma_dev = &pdev->dev;
>> +             count++;
>> +     }
>
> what about to define sd as sd[0]; in the platform_data structure and
> then use smth like following
>
> struct ... *sd = pdata->sd;
> for_each... {
> sd->... = ;
> sd++;
> }
>
> it will probably require to split this part in a separate function and
> calculate count of slave_info children before pdata memory allocation.

Liked the idea partially. Check my new implementation in fixup for all
these comments:

---------------------------8<---------------------------

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Fri, 12 Oct 2012 19:35:44 +0530
Subject: [PATCH] fixup! dmaengine: dw_dmac: Enhance device tree support

---
 drivers/dma/dw_dmac.c   | 50 ++++++++++++++++++++++---------------------------
 include/linux/dw_dmac.h |  2 +-
 2 files changed, 23 insertions(+), 29 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index c24859e..d72c26f 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1179,7 +1179,7 @@ static void dwc_free_chan_resources(struct dma_chan *chan)
 	dev_vdbg(chan2dev(chan), "%s: done\n", __func__);
 }

-bool dw_generic_filter(struct dma_chan *chan, void *param)
+bool dw_dma_generic_filter(struct dma_chan *chan, void *param)
 {
 	struct dw_dma *dw = to_dw_dma(chan->device);
 	static struct dw_dma *last_dw;
@@ -1224,7 +1224,7 @@ bool dw_generic_filter(struct dma_chan *chan, void *param)
 	last_bus_id = param;
 	return false;
 }
-EXPORT_SYMBOL(dw_generic_filter);
+EXPORT_SYMBOL(dw_dma_generic_filter);

 /* --------------------- Cyclic DMA API extensions -------------------- */

@@ -1516,7 +1516,7 @@ __devinit dw_dma_parse_dt(struct platform_device *pdev)
 	struct device_node *sn, *cn, *np = pdev->dev.of_node;
 	struct dw_dma_platform_data *pdata;
 	struct dw_dma_slave *sd;
-	u32 count, val, arr[4];
+	u32 val, arr[4];

 	if (!np) {
 		dev_err(&pdev->dev, "Missing DT data\n");
@@ -1533,63 +1533,57 @@ __devinit dw_dma_parse_dt(struct platform_device *pdev)
 	if (of_property_read_bool(np, "is_private"))
 		pdata->is_private = true;

-	if (!of_property_read_u32(np, "chan_allocation_order",
-				&val))
+	if (!of_property_read_u32(np, "chan_allocation_order", &val))
 		pdata->chan_allocation_order = (unsigned char)val;

 	if (!of_property_read_u32(np, "chan_priority", &val))
-		pdata->chan_priority = (unsigned char)val;
+		pdata->chan_priority = val;

 	if (!of_property_read_u32(np, "block_size", &val))
-		pdata->block_size = (unsigned short)val;
+		pdata->block_size = val;

 	if (!of_property_read_u32(np, "nr_masters", &val)) {
 		if (val > 4)
 			return NULL;

-		pdata->nr_masters = (unsigned char)val;
+		pdata->nr_masters = val;
 	}

 	if (!of_property_read_u32_array(np, "data_width", arr,
 				pdata->nr_masters))
-		for (count = 0; count < pdata->nr_masters; count++)
-			pdata->data_width[count] = arr[count];
+		for (val = 0; val < pdata->nr_masters; val++)
+			pdata->data_width[val] = arr[val];

 	/* parse slave data */
 	sn = of_find_node_by_name(np, "slave_info");
 	if (!sn)
 		return pdata;

-	count = 0;
 	/* calculate number of slaves */
-	for_each_child_of_node(sn, cn)
-		count++;
-
-	if (!count)
+	val = of_get_child_count(sn);
+	if (!val)
 		return NULL;

-	sd = devm_kzalloc(&pdev->dev, sizeof(*sd) * count, GFP_KERNEL);
+	sd = devm_kzalloc(&pdev->dev, sizeof(*sd) * val, GFP_KERNEL);
 	if (!sd)
 		return NULL;

-	count = 0;
+	pdata->sd = sd;
+	pdata->sd_count = val;
+
 	for_each_child_of_node(sn, cn) {
-		of_property_read_string(cn, "bus_id", &sd[count].bus_id);
-		of_property_read_u32(cn, "cfg_hi", &sd[count].cfg_hi);
-		of_property_read_u32(cn, "cfg_lo", &sd[count].cfg_lo);
+		sd->dma_dev = &pdev->dev;
+		of_property_read_string(cn, "bus_id", &sd->bus_id);
+		of_property_read_u32(cn, "cfg_hi", &sd->cfg_hi);
+		of_property_read_u32(cn, "cfg_lo", &sd->cfg_lo);
 		if (!of_property_read_u32(cn, "src_master", &val))
-			sd[count].src_master = (u8)val;
+			sd->src_master = val;

 		if (!of_property_read_u32(cn, "dst_master", &val))
-			sd[count].dst_master = (u8)val;
-
-		sd[count].dma_dev = &pdev->dev;
-		count++;
+			sd->dst_master = val;
+		sd++;
 	}

-	pdata->sd = sd;
-	pdata->sd_count = count;
-
 	return pdata;
 }
 #else
diff --git a/include/linux/dw_dmac.h b/include/linux/dw_dmac.h
index 4d1c8c3..41766de 100644
--- a/include/linux/dw_dmac.h
+++ b/include/linux/dw_dmac.h
@@ -114,6 +114,6 @@ void dw_dma_cyclic_stop(struct dma_chan *chan);
 dma_addr_t dw_dma_get_src_addr(struct dma_chan *chan);

 dma_addr_t dw_dma_get_dst_addr(struct dma_chan *chan);
-bool dw_generic_filter(struct dma_chan *chan, void *param);
+bool dw_dma_generic_filter(struct dma_chan *chan, void *param);

 #endif /* DW_DMAC_H */
