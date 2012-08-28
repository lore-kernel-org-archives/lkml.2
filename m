Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab2H1Hif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 03:38:35 -0400
Received: from bosmailout18.eigbox.net ([66.96.184.18]:41874 "EHLO
	bosmailout18.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab2H1Hic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 03:38:32 -0400
X-Greylist: delayed 2411 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Aug 2012 03:38:32 EDT
X-Authority-Analysis: v=2.0 cv=aPZHX8Bm c=1 sm=1
 a=NP72zy0OYyB7xhnhJV20Mg==:17 a=bc2JKO6qiGsA:10 a=kfTud4QeKxsA:10
 a=6_yu9_eKWJgA:10 a=8nJEP1OIZ-IA:10 a=gHsnk5GASbAA:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=elBXUQro9WRqngJtSfgA:9 a=wPNLvfGTeEIA:10
 a=mr6_uXNXRh26YLVQ:21 a=1eo5-E3mByFaXeb8:21 a=+tcVrJynzLVJ9yqDAOBWjQ==:117
X-EN-OrigOutIP: 10.20.18.9
X-EN-IMPSID: s6yJ1j0010BkY8i016yJ1m
Message-ID: <503C6B67.2010903@yahoo.es>
Date: Tue, 28 Aug 2012 14:55:35 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        spear-devel <spear-devel@list.st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH 1/2] dw_dmac: make driver endianness configurable
References: <503A8CAE.6050606@yahoo.es> <20120827070323.GC28721@samfundet.no> <503B342C.9060300@yahoo.es> <20120827111431.GA27868@samfundet.no> <503B8B26.3050205@yahoo.es> <CAKohpo=ALUNOnQdQjNd1Y2jtocxjixKCiBrRZp8qGErqg1LSKw@mail.gmail.com>
In-Reply-To: <CAKohpo=ALUNOnQdQjNd1Y2jtocxjixKCiBrRZp8qGErqg1LSKw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.57.43
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/2012 11:23 AM, Viresh Kumar wrote:
> On 27 August 2012 20:28, Hein Tibosch <hein_tibosch@yahoo.es> wrote:
>>>> +config DW_DMAC_MEM_64_BIT
>>>> +    bool "Allow 64-bit memory transfers"
>>>> +    default y if !AVR32
>>>> +    depends on DW_DMAC
>>>> +    help
>>>> +      Say yes if the DMA controller may do 64-bit memory transfers
>>>> +      For AVR32, say no because only up to 32-bit transfers are
>>>> +      defined
>>> Is this sane to add? Could some non-AVR32 platforms use 64-bit and 32-bit
>>> depending on runtime configuration? E.g. if you build a kernel with support
>>> for multiple boards/processors, and there is a mix of 32-bit and 64-bit wide
>>> DMA support.
>>>
>>> I think it is better to select 32/64-bit at runtime.
>> I did that in the first patch, adding a new property to the dw_dma_slave
>> structure. It had the small disadvantage that some arch code had to be
>> adapted (at32ap700x.c).
>>
>> Viresh, what do you think? Add a property called "mem_64_bit_access" or so?
>>
>> Or should it be passed as a member of 'dw_dma_platform_data', because it
>> is a property of the (entire) DMA controller?
> I think second option is better. But can there be some supportive scenarios of
> first option?
>
> We have a system, with two different memory controllers, one supporting 32 bit
> and other 64 bit?
>
> Or what we can do now is: go with option 2, i.e. update dw_dma_platform_data
> and if some platform like what i mentioned above comes, then we can move it
> to slave data.
What about this:

In case of AVR32, the arch code will indicate:

static struct dw_dma_platform_data dw_dmac0_data = {
	.nr_channels    = 3,
	/* DMAC supports up to 32-bit memory access */
	.mem_access_32_bit_only = true,
};

ARM users won't have to change anything because mem_access_32_bit_only
will be false and therefor 'dw->mem_64_bit' will become true

Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>

---
 drivers/dma/dw_dmac.c      |   11 ++++++++---
 drivers/dma/dw_dmac_regs.h |    2 ++
 include/linux/dw_dmac.h    |    2 ++
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 7212961..a37053c 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -618,6 +618,7 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 		size_t len, unsigned long flags)
 {
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
+	struct dw_dma		*dw = to_dw_dma(dwc->chan.device);
 	struct dw_desc		*desc;
 	struct dw_desc		*first;
 	struct dw_desc		*prev;
@@ -639,7 +640,7 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 	 * We can be a lot more clever here, but this should take care
 	 * of the most common optimization.
 	 */
-	if (!((src | dest  | len) & 7))
+	if (dw->mem_64_bit && !((src | dest  | len) & 7))
 		src_width = dst_width = 3;
 	else if (!((src | dest  | len) & 3))
 		src_width = dst_width = 2;
@@ -710,6 +711,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
 	struct dw_dma_slave	*dws = chan->private;
 	struct dma_slave_config	*sconfig = &dwc->dma_sconfig;
+	struct dw_dma		*dw = to_dw_dma(dwc->chan.device);
 	struct dw_desc		*prev;
 	struct dw_desc		*first;
 	u32			ctllo;
@@ -746,7 +748,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 			mem = sg_dma_address(sg);
 			len = sg_dma_len(sg);
 
-			if (!((mem | len) & 7))
+			if (dw->mem_64_bit && !((mem | len) & 7))
 				mem_width = 3;
 			else if (!((mem | len) & 3))
 				mem_width = 2;
@@ -813,7 +815,7 @@ slave_sg_todev_fill_desc:
 			mem = sg_dma_address(sg);
 			len = sg_dma_len(sg);
 
-			if (!((mem | len) & 7))
+			if (dw->mem_64_bit && !((mem | len) & 7))
 				mem_width = 3;
 			else if (!((mem | len) & 3))
 				mem_width = 2;
@@ -1419,6 +1421,9 @@ static int __init dw_probe(struct platform_device *pdev)
 		goto err_kfree;
 	}
 
+	/* Remember if 64-bit access to memory is allowed */
+	dw->mem_64_bit = !pdata->mem_access_32_bit_only;
+
 	dw->regs = ioremap(io->start, DW_REGLEN);
 	if (!dw->regs) {
 		err = -ENOMEM;
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index 9758651..e24562e 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -199,6 +199,8 @@ struct dw_dma {
 	struct clk		*clk;
 
 	u8			all_chan_mask;
+	/* 64-bit access to memory is allowed */
+	bool			mem_64_bit;
 
 	struct dw_dma_chan	chan[0];
 };
diff --git a/include/linux/dw_dmac.h b/include/linux/dw_dmac.h
index 2412e02..d01d63f 100644
--- a/include/linux/dw_dmac.h
+++ b/include/linux/dw_dmac.h
@@ -29,6 +29,8 @@ struct dw_dma_platform_data {
 #define CHAN_PRIORITY_ASCENDING		0	/* chan0 highest */
 #define CHAN_PRIORITY_DESCENDING	1	/* chan7 highest */
 	unsigned char	chan_priority;
+	/* Make true if 64-bit access to memory is not implemented */
+	bool		mem_access_32_bit_only;
 };
 
 /* bursts size */
-- 
1.7.8.0

