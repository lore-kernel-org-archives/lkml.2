Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454Ab2B1H3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 02:29:11 -0500
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:43632 "HELO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756504Ab2B1H3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 02:29:01 -0500
From: zhaoy <zhaoy@marvell.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nicolas.pitre@linaro.org, linux@arm.linux.org.uk, hzhuang1@marvell.com,
        cxie4@marvell.com, leoy@marvell.com
Cc: zhaoy <zhaoy@marvell.com>
Subject: [PATCH 12/13] mdma:dmaengine:update mdma for tdma
Date: Tue, 28 Feb 2012 15:27:44 +0800
Message-Id: <1330414065-2949-13-git-send-email-zhaoy@marvell.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <Y>
References: <Y>
X-OriginalArrivalTime: 28 Feb 2012 07:28:39.0860 (UTC) FILETIME=[976DA740:01CCF5EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	1, do some update to add mdma to the
	dma engine as adma

Change-Id: I514b247e0c2301fc48b1f1980562f3c50d6a6455
Signed-off-by: zhaoy <zhaoy@marvell.com>
---
 drivers/char/mmp2_mdma.c |  273 ++++++++++++++--------------------------------
 1 files changed, 84 insertions(+), 189 deletions(-)

diff --git a/drivers/char/mmp2_mdma.c b/drivers/char/mmp2_mdma.c
index c16b94a..72fee88 100644
--- a/drivers/char/mmp2_mdma.c
+++ b/drivers/char/mmp2_mdma.c
@@ -37,8 +37,8 @@ static void *dma_desc_array_ch1 = NULL;
 static void *dma_desc_array_ch2 = NULL;
 static dma_addr_t dma_desc_array_phys_ch1;
 static dma_addr_t dma_desc_array_phys_ch2;
-static struct completion complete_ch1;
-static struct completion complete_ch2;
+static struct completion complete_memcpy;
+static struct completion complete_memset;
 
 static unsigned long uva_to_pa(struct mm_struct *mm, unsigned long addr)
 {
@@ -68,43 +68,41 @@ static unsigned long uva_to_pa(struct mm_struct *mm, unsigned long addr)
 	return ret;
 }
 
-static void mdma_irq(int channel, void *data)
+static void mdma_irq(void *data)
 {
-	unsigned int base_register = mmp_get_dma_reg_base(channel);
-
-	if(base_register){
-		if (TDISR(base_register) & 0x1) {
-			if(channel == MDMA1_CH0)
-				complete(&complete_ch1);
-			else
-				complete(&complete_ch2);
-			if(TDISR(base_register) & 0xc)
-				printk(KERN_ERR "MDMA error 0x%x on channel %d \n",
-					TDISR(base_register), channel);
-		} else {
-			printk(KERN_ERR "MDMA error on channel %d \n", channel);
-		}
-		TDISR(base_register) = 0;
-	}
+	struct completion *mdma_complete = data;
+
+	complete(mdma_complete);
 
 	return;
 }
 
+static bool filter(struct dma_chan *chan, void *param)
+{
+	struct mmp_tdma_data *tdma_data = param;
+
+	if (!mmp_mdma_is_this_type(chan))
+		return false;
+
+	chan->private = tdma_data;
+
+	return true;
+}
 /*
  * len requires at least 8bytes alignment. 128bytes alignment will get better performance.
  * Alignment: 8, 16, 32, 64, 128. The bigger, the better.
  * source and destination address aslo need alignment with burst size.
  */
+struct mmp_tdma_data tdma_data_pmemcpy;
 unsigned long mdma_pmemcpy(unsigned long pdst, unsigned long psrc, unsigned int len)
 {
-	int ret, dma_ch;
-	unsigned int base_register;
-	unsigned int dcmd, mdma_dcr;
+	int ret;
 	unsigned long len_tmp, len_total;
-	struct pxa910_squ_desc *dma_desc_tmp;
-	dma_addr_t dma_desc_p_tmp;
 	unsigned long srcphyaddr = psrc;
 	unsigned long dstphyaddr = pdst;
+	struct dma_chan *dma_chan;
+	dma_cap_mask_t mask;
+	struct dma_async_tx_descriptor *desc;
 
 	if (srcphyaddr == 0 || dstphyaddr == 0)
 		return -1;
@@ -124,95 +122,44 @@ unsigned long mdma_pmemcpy(unsigned long pdst, unsigned long psrc, unsigned int
 		return -1;
 	}
 
-	ret = mmp_request_dma("mdma_memcpy", MDMA1_CH0,
-					mdma_irq, NULL);
-	if (ret < 0){
-		ret = mmp_request_dma("mdma_memcpy", MDMA1_CH1,
-						mdma_irq, NULL);
-		if (ret < 0){
-			printk(KERN_ERR	"Can't request MDMA for memcpy\n");
-			return -ENODEV;
-		}else{
-			dma_ch = MDMA1_CH1;
-		}
-	}else{
-		dma_ch = MDMA1_CH0;
-	}
-
-	if(dma_ch == MDMA1_CH0){
-		dma_desc_tmp = dma_desc_array_ch1;
-		dma_desc_p_tmp = dma_desc_array_phys_ch1;
-	}else{
-		dma_desc_tmp = dma_desc_array_ch2;
-		dma_desc_p_tmp = dma_desc_array_phys_ch2;
-	}
-
-	len_total = len;
-	while(len_total) {
-		len_tmp = len_total>SINGLE_DESC_TRANS_MAX ?
-				SINGLE_DESC_TRANS_MAX : len_total;
-		dma_desc_tmp->nxt_desc = dma_desc_p_tmp + sizeof(struct pxa910_squ_desc);
-		dma_desc_tmp->src_addr = srcphyaddr;
-		dma_desc_tmp->dst_addr = dstphyaddr;
-		dma_desc_tmp->byte_cnt = len_tmp;
-		if (len_total <= SINGLE_DESC_TRANS_MAX) {
-			dma_desc_tmp->nxt_desc = 0;
-			break;
-		}
-		len_total -= len_tmp;
-		dma_desc_tmp ++;
-		dma_desc_p_tmp += sizeof(struct pxa910_squ_desc);
-		srcphyaddr += len_tmp;
-		dstphyaddr += len_tmp;
-	}
-
 	if (!((len & 0x7f) || (srcphyaddr & 0x7f) || (dstphyaddr & 0x7f)))
-		dcmd = MDCR_DST_ADDR_INC | MDCR_SRC_ADDR_INC | MDCR_TRANSMOD |
-			MDCR_DMA_BURST_128B | SDCR_FETCHND;
+		tdma_data_pmemcpy.bus_size = MDCR_DMA_BURST_128B;
 	else if (!((len & 0x3f) || (srcphyaddr & 0x3f) || (dstphyaddr & 0x3f)))
-		dcmd = MDCR_DST_ADDR_INC | MDCR_SRC_ADDR_INC | MDCR_TRANSMOD |
-			MDCR_DMA_BURST_64B | SDCR_FETCHND;
+		tdma_data_pmemcpy.bus_size = MDCR_DMA_BURST_64B;
 	else if (!((len & 0x1f) || (srcphyaddr & 0x1f) || (dstphyaddr & 0x1f)))
-		dcmd = MDCR_DST_ADDR_INC | MDCR_SRC_ADDR_INC | MDCR_TRANSMOD |
-			MDCR_DMA_BURST_32B | SDCR_FETCHND;
+		tdma_data_pmemcpy.bus_size = MDCR_DMA_BURST_32B;
 	else if (!((len & 0xf) || (srcphyaddr & 0xf) || (dstphyaddr & 0xf)))
-		dcmd = MDCR_DST_ADDR_INC | MDCR_SRC_ADDR_INC | MDCR_TRANSMOD |
-			MDCR_DMA_BURST_16B | SDCR_FETCHND;
-	else
-		dcmd = MDCR_DST_ADDR_INC | MDCR_SRC_ADDR_INC | MDCR_TRANSMOD |
-			MDCR_DMA_BURST_8B | SDCR_FETCHND;
-
-	base_register = mmp_get_dma_reg_base(dma_ch);
-	TDCR(base_register)= (dcmd) & (~MDCR_CHANEN);
-	TDIMR(base_register) = MDIMR_COMP;
-	if(dma_ch == MDMA1_CH0)
-		TDNDPR(base_register) = dma_desc_array_phys_ch1;
+		tdma_data_pmemcpy.bus_size = MDCR_DMA_BURST_16B;
 	else
-		TDNDPR(base_register) = dma_desc_array_phys_ch2;
-	if(dma_ch == MDMA1_CH0){
-		init_completion(&complete_ch1);
-	}else{
-		init_completion(&complete_ch2);
-	}
+		tdma_data_pmemcpy.bus_size = MDCR_DMA_BURST_8B;
 
+	/* Try to grab a DMA channel */
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_MEMCPY, mask);
+	dma_chan = dma_request_channel(mask, filter, &tdma_data_pmemcpy);
 
-	TDCR(base_register)= dcmd | MDCR_CHANEN;
+	len_total = len;
+	len_tmp = len_total > SINGLE_DESC_TRANS_MAX ?
+				SINGLE_DESC_TRANS_MAX : len_total;
 
-	if(dma_ch == MDMA1_CH0){
-		ret = wait_for_completion_timeout(&complete_ch1, 10*HZ);
-	}else{
-		ret = wait_for_completion_timeout(&complete_ch2, 10*HZ);
-	}
+	desc = dma_chan->device->device_prep_dma_memcpy(
+			dma_chan, dstphyaddr, srcphyaddr, len_total,
+			DMA_BIDIRECTIONAL);
 
-	TDIMR(base_register) = 0;
-	mdma_dcr = TDCR(base_register);
-	if (mdma_dcr & TDCR_CHANACT) {
-		TDCR(base_register) = mdma_dcr | TDCR_ABR;
-	}
-	while (mdma_dcr & TDCR_CHANACT) {
-		mdma_dcr = TDCR(base_register);
-	}
-	mmp_free_dma(dma_ch);
+	/* this completion will be finished after mdma irq */
+	init_completion(&complete_memcpy);
+
+	desc->callback = mdma_irq;
+	desc->callback_param = &complete_memcpy;
+
+	/* start dma transfer */
+	dmaengine_submit(desc);
+
+	ret = wait_for_completion_timeout(&complete_memcpy, 10*HZ);
+
+	/* release dma channel */
+	dma_release_channel(dma_chan);
+	dma_chan = NULL;
 
 	if (ret)
 		return len;
@@ -227,15 +174,15 @@ EXPORT_SYMBOL(mdma_pmemcpy);
  * destination address aslo need alignment with burst size.
  * data requires 32bits.
  */
+struct mmp_tdma_data tdma_data_pmemset;
 unsigned long mdma_pmemset(unsigned long paddr, unsigned long c, unsigned int len)
 {
-	int ret, dma_ch;
-	unsigned int base_register;
-	unsigned int dcmd, mdma_dcr;
+	int ret;
 	unsigned long len_tmp, len_total;
-	struct pxa910_squ_desc *dma_desc_tmp;
-	dma_addr_t dma_desc_p_tmp;
 	unsigned long dstphyaddr = paddr;
+	struct dma_chan *dma_chan;
+	dma_cap_mask_t mask;
+	struct dma_async_tx_descriptor *desc;
 
 	if (dstphyaddr == 0)
 		return -1;
@@ -250,95 +197,43 @@ unsigned long mdma_pmemset(unsigned long paddr, unsigned long c, unsigned int le
 		return -1;
 	}
 
-	ret = mmp_request_dma("mdma_memcpy", MDMA1_CH0,
-					mdma_irq, NULL);
-	if (ret < 0){
-		ret = mmp_request_dma("mdma_memcpy", MDMA1_CH1,
-						mdma_irq, NULL);
-		if (ret < 0){
-			printk(KERN_ERR	"Can't request MDMA for memcpy\n");
-			return -ENODEV;
-		}else{
-			dma_ch = MDMA1_CH1;
-		}
-	}else{
-		dma_ch = MDMA1_CH0;
-	}
-
-	if(dma_ch == MDMA1_CH0){
-		dma_desc_tmp = dma_desc_array_ch1;
-		dma_desc_p_tmp = dma_desc_array_phys_ch1;
-	}else{
-		dma_desc_tmp = dma_desc_array_ch2;
-		dma_desc_p_tmp = dma_desc_array_phys_ch2;
-	}
-
-	len_total = len;
-	while(len_total) {
-		len_tmp = len_total>SINGLE_DESC_TRANS_MAX ?
-				SINGLE_DESC_TRANS_MAX : len_total;
-		dma_desc_tmp->nxt_desc = dma_desc_p_tmp + sizeof(struct pxa910_squ_desc);
-		dma_desc_tmp->src_addr = 0;
-		dma_desc_tmp->dst_addr = dstphyaddr;
-		dma_desc_tmp->byte_cnt = len_tmp;
-		if (len_total <= SINGLE_DESC_TRANS_MAX) {
-			dma_desc_tmp->nxt_desc = 0;
-			break;
-		}
-		len_total -= len_tmp;
-		dma_desc_tmp ++;
-		dma_desc_p_tmp += sizeof(struct pxa910_squ_desc);
-		dstphyaddr += len_tmp;
-	}
-
 	if (!((len & 0x7f) || (dstphyaddr & 0x7f)))
-		dcmd = MDCR_DST_ADDR_INC | MDCR_SRC_ADDR_HOLD | MDCR_TRANSMOD |
-			MDCR_FILLMOD | MDCR_DMA_BURST_128B | SDCR_FETCHND;
+		tdma_data_pmemset.bus_size = MDCR_FILLMOD | MDCR_DMA_BURST_128B;
 	else if (!((len & 0x3f) || (dstphyaddr & 0x3f)))
-		dcmd = MDCR_DST_ADDR_INC | MDCR_SRC_ADDR_HOLD | MDCR_TRANSMOD |
-			MDCR_FILLMOD | MDCR_DMA_BURST_64B | SDCR_FETCHND;
+		tdma_data_pmemset.bus_size = MDCR_FILLMOD | MDCR_DMA_BURST_64B;
 	else if (!((len & 0x1f) || (dstphyaddr & 0x1f)))
-		dcmd = MDCR_DST_ADDR_INC | MDCR_SRC_ADDR_HOLD | MDCR_TRANSMOD |
-			MDCR_FILLMOD | MDCR_DMA_BURST_32B | SDCR_FETCHND;
+		tdma_data_pmemset.bus_size = MDCR_FILLMOD | MDCR_DMA_BURST_32B;
 	else if (!((len & 0xf) || (dstphyaddr & 0xf)))
-		dcmd = MDCR_DST_ADDR_INC | MDCR_SRC_ADDR_HOLD | MDCR_TRANSMOD |
-			MDCR_FILLMOD | MDCR_DMA_BURST_16B | SDCR_FETCHND;
-	else
-		dcmd = MDCR_DST_ADDR_INC | MDCR_SRC_ADDR_HOLD | MDCR_TRANSMOD |
-			MDCR_FILLMOD | MDCR_DMA_BURST_8B | SDCR_FETCHND;
-
-	base_register = mmp_get_dma_reg_base(dma_ch);
-	TDCR(base_register)= (dcmd) & (~MDCR_CHANEN);
-	TDIMR(base_register) = MDIMR_COMP;
-	if(dma_ch == MDMA1_CH0)
-		TDNDPR(base_register) = dma_desc_array_phys_ch1;
+		tdma_data_pmemset.bus_size = MDCR_FILLMOD | MDCR_DMA_BURST_16B;
 	else
-		TDNDPR(base_register) = dma_desc_array_phys_ch2;
-	MMP2_FILL_DATA(base_register) = c;
+		tdma_data_pmemset.bus_size = MDCR_FILLMOD | MDCR_DMA_BURST_8B;
 
-	if(dma_ch == MDMA1_CH0){
-		init_completion(&complete_ch1);
-	}else{
-		init_completion(&complete_ch2);
-	}
+	/* Try to grab a DMA channel */
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_MEMSET, mask);
+	dma_chan = dma_request_channel(mask, filter, &tdma_data_pmemset);
 
-	TDCR(base_register)= dcmd | MDCR_CHANEN;
+	len_total = len;
+	len_tmp = len_total > SINGLE_DESC_TRANS_MAX ?
+				SINGLE_DESC_TRANS_MAX : len_total;
+	desc = dma_chan->device->device_prep_dma_memset(
+			dma_chan, dstphyaddr, c, len_total,
+			DMA_BIDIRECTIONAL);
 
-	if(dma_ch == MDMA1_CH0){
-		ret = wait_for_completion_timeout(&complete_ch1, 10*HZ);
-	}else{
-		ret = wait_for_completion_timeout(&complete_ch2, 10*HZ);
-	}
+	/* this completion will be finished after mdma irq */
+	init_completion(&complete_memset);
 
-	TDIMR(base_register) = 0;
-	mdma_dcr = TDCR(base_register);
-	if (mdma_dcr & TDCR_CHANACT) {
-		TDCR(base_register) = mdma_dcr | TDCR_ABR;
-	}
-	while (mdma_dcr & TDCR_CHANACT) {
-		mdma_dcr = TDCR(base_register);
-	}
-	mmp_free_dma(dma_ch);
+	desc->callback = mdma_irq;
+	desc->callback_param = &complete_memset;
+
+	/* start dma transfer */
+	dmaengine_submit(desc);
+
+	ret = wait_for_completion_timeout(&complete_memset, 10*HZ);
+
+	/* release dma channel */
+	dma_release_channel(dma_chan);
+	dma_chan = NULL;
 
 	if (ret)
 		return len;
-- 
1.7.0.4

