Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab2H0Iad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 04:30:33 -0400
Received: from bosmailout18.eigbox.net ([66.96.186.18]:33769 "EHLO
	bosmailout18.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab2H0Iab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 04:30:31 -0400
X-Greylist: delayed 2403 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Aug 2012 04:30:31 EDT
X-Authority-Analysis: v=2.0 cv=aPZHX8Bm c=1 sm=1
 a=OWwsRfqG41DA94+gJvZMBg==:17 a=bc2JKO6qiGsA:10 a=kfTud4QeKxsA:10
 a=jtEPNERedswA:10 a=8nJEP1OIZ-IA:10 a=fXvAegrqyC0A:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=D19gQVrFAAAA:8 a=LyVXdZXIuMePhhwbg04A:9
 a=wPNLvfGTeEIA:10 a=vn8ca0hwg8UMvoMy:21 a=eVlIrLoMWPY7KIwk:21
 a=6uKCkKhFq2wXOH2GoQX8aA==:117
X-EN-OrigOutIP: 10.20.18.3
X-EN-IMPSID: rjqR1j00503yW7601jqRyn
Message-ID: <503B2656.3050506@yahoo.es>
Date: Mon, 27 Aug 2012 15:48:38 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: spear-devel <spear-devel@list.st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, egtvedt@samfundet.no,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>, vinod.koul@intel.com,
        dan.j.williams@intel.com
Subject: Re: [PATCH 2/2] dw_dmac: max_mem_width limits value for SRC/DST_TR_WID
 register
References: <503A89E0.40602@yahoo.es> <CAKohpontcFpMiju1LwO3fL43Oud0jAixYf8ZNN+6-hTj35ownA@mail.gmail.com>
In-Reply-To: <CAKohpontcFpMiju1LwO3fL43Oud0jAixYf8ZNN+6-hTj35ownA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.63.241
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/27/2012 11:47 AM, Viresh Kumar wrote:
> On 27 August 2012 02:11, Hein Tibosch <hein_tibosch@yahoo.es <mailto:hein_tibosch@yahoo.es>> wrote:
>
>     The dw_dmac driver was earlier adapted to do 64-bit transfers
>     on the memory side (https://lkml.org/lkml/2012/1/18/52)
>     This works on ARM platforms but for AVR32 (AP700x) the maximum
>     allowed transfer size is 32-bits.
>     This patch allows the arch to set a new slave property
>     max_mem_width to limit the size.
>     Allowable values for dw_dma_slave::max_mem_width are:
>
>     0 : leave it up to dw_dmac (64 bits)
>     1 : 16-bits
>     2 : 32-bits
>
>
> Either this should be in increasing order or decreasing. That will make it
> more sensible, isn't it?
>
> So it should be:
> 0-64bit
> 1-32bit
> 2-16bit
>
> Also, i am not sure if we should actually support 16 bit here at all. Maybe nobody
> will have 16 bit requirement. So can remove it for now. If in future it is required
> then can accept that.
>  
Viresh,

If you're OK with the version below, I'll send both dw_dmac patches
again as v2

Now cc Vinod Koul and Dan Williams

The dw_dmac driver was earlier adapted to do 64-bit transfers
on the memory side (https://lkml.org/lkml/2012/1/18/52)
This works on ARM platforms but for AVR32 (AP700x) the maximum
allowed transfer size is 32-bits.

A new 'automatic' config item 'DW_DMAC_MEM_64_BIT' determines if 64-bit
memory transfers are allowed. This boolean will be defined on non-AVR32
platforms

No arch code will have to be changed to make this patch work.

Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>
---
 drivers/dma/Kconfig   |    8 ++++++++
 drivers/dma/dw_dmac.c |   15 ++++++++++++---
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 3635daf..82e958f 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -97,6 +97,14 @@ config DW_DMAC_BE
 	  Say yes if access to the Synopsys DesignWare AHB DMA controller
 	  should be big endian, such as for Atmel AT32ap7000
 
+config DW_DMAC_MEM_64_BIT
+	bool "Allow Synopsys DesignWare AHB DMA to do 64-bit mem transfers"
+	default y if !AVR32
+	depends on DW_DMAC
+	help
+	  Say yes if the Synopsys DesignWare AHB DMA controller may do
+	  64-bit memory transfers
+
 config AT_HDMAC
 	tristate "Atmel AHB DMA support"
 	depends on ARCH_AT91
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 7212961..2be010c 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -639,9 +639,12 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 	 * We can be a lot more clever here, but this should take care
 	 * of the most common optimization.
 	 */
+#ifdef	DW_DMAC_MEM_64_BIT
 	if (!((src | dest  | len) & 7))
 		src_width = dst_width = 3;
-	else if (!((src | dest  | len) & 3))
+	else
+#endif
+	if (!((src | dest  | len) & 3))
 		src_width = dst_width = 2;
 	else if (!((src | dest | len) & 1))
 		src_width = dst_width = 1;
@@ -746,9 +749,12 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 			mem = sg_dma_address(sg);
 			len = sg_dma_len(sg);
 
+#ifdef	DW_DMAC_MEM_64_BIT
 			if (!((mem | len) & 7))
 				mem_width = 3;
-			else if (!((mem | len) & 3))
+			else
+#endif
+			if (!((mem | len) & 3))
 				mem_width = 2;
 			else if (!((mem | len) & 1))
 				mem_width = 1;
@@ -813,9 +819,12 @@ slave_sg_todev_fill_desc:
 			mem = sg_dma_address(sg);
 			len = sg_dma_len(sg);
 
+#ifdef	DW_DMAC_MEM_64_BIT
 			if (!((mem | len) & 7))
 				mem_width = 3;
-			else if (!((mem | len) & 3))
+			else
+#endif
+			if (!((mem | len) & 3))
 				mem_width = 2;
 			else if (!((mem | len) & 1))
 				mem_width = 1;
-- 
1.7.8.0

