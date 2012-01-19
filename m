Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab2ASGPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 01:15:50 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:1932
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752882Ab2ASGPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 01:15:44 -0500
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275bhz2dhc1bhc31hc1ah2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Huang Shijie <b32955@freescale.com>
To: <vinod.koul@intel.com>
CC: <shawn.guo@linaro.org>, <artem.bityutskiy@intel.com>, <shijie8@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <w.sang@pengutronix.de>,
        <LW@KARO-electronics.de>, <alsa-devel@alsa-project.org>,
        <b29396@freescale.com>, Huang Shijie <b32955@freescale.com>
Subject: [PATCH 10/10] MTD/GPMI : change the code for new DMA interface
Date: Thu, 19 Jan 2012 14:16:07 +0800
Message-ID: <1326953767-24155-11-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1326953767-24155-1-git-send-email-b32955@freescale.com>
References: <1326953767-24155-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please read more comment in the mxs-dma.h.

In the new GPMI version(0x05010000 used by MX6Q/MX50), we should
set the WAIT4END bit in the middle one of this chain,
which enables the BCH module and reads out the NAND page.
If we do not do this, a DMA timeout occurs. This bug has been
catched in the MX6Q board.

We have changed the DMA interface to fix the bug, now use the new
interface.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
index 5b73ae5..84abd49 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
@@ -842,7 +842,7 @@ int gpmi_send_command(struct gpmi_nand_data *this)
 	sg_init_one(sgl, this->cmd_buffer, this->command_length);
 	dma_map_sg(this->dev, sgl, 1, DMA_TO_DEVICE);
 	desc = channel->device->device_prep_slave_sg(channel,
-					sgl, 1, DMA_MEM_TO_DEV, 1);
+				sgl, 1, DMA_MEM_TO_DEV, MXS_DMA_F_LASTONE);
 	if (!desc) {
 		pr_err("step 2 error\n");
 		return -1;
@@ -884,7 +884,7 @@ int gpmi_send_data(struct gpmi_nand_data *this)
 	/* [2] send DMA request */
 	prepare_data_dma(this, DMA_TO_DEVICE);
 	desc = channel->device->device_prep_slave_sg(channel, &this->data_sgl,
-						1, DMA_MEM_TO_DEV, 1);
+					1, DMA_MEM_TO_DEV, MXS_DMA_F_LASTONE);
 	if (!desc) {
 		pr_err("step 2 error\n");
 		return -1;
@@ -920,7 +920,7 @@ int gpmi_read_data(struct gpmi_nand_data *this)
 	/* [2] : send DMA request */
 	prepare_data_dma(this, DMA_FROM_DEVICE);
 	desc = channel->device->device_prep_slave_sg(channel, &this->data_sgl,
-						1, DMA_DEV_TO_MEM, 1);
+					1, DMA_DEV_TO_MEM, MXS_DMA_F_LASTONE);
 	if (!desc) {
 		pr_err("step 2 error\n");
 		return -1;
@@ -967,7 +967,8 @@ int gpmi_send_page(struct gpmi_nand_data *this,
 
 	desc = channel->device->device_prep_slave_sg(channel,
 					(struct scatterlist *)pio,
-					ARRAY_SIZE(pio), DMA_TRANS_NONE, 0);
+					ARRAY_SIZE(pio), DMA_TRANS_NONE,
+					MXS_DMA_F_WAIT4END);
 	if (!desc) {
 		pr_err("step 2 error\n");
 		return -1;
@@ -987,6 +988,7 @@ int gpmi_read_page(struct gpmi_nand_data *this,
 	struct dma_async_tx_descriptor *desc;
 	struct dma_chan *channel = get_dma_chan(this);
 	int chip = this->current_chip;
+	unsigned long flags;
 	u32 pio[6];
 
 	/* [1] Wait for the chip to report ready. */
@@ -1029,9 +1031,14 @@ int gpmi_read_page(struct gpmi_nand_data *this,
 	pio[3] = geo->page_size;
 	pio[4] = payload;
 	pio[5] = auxiliary;
+
+	/* If the GPMI is new version, set MXS_DMA_F_WAIT4END here. */
+	flags = MXS_DMA_F_APPEND;
+	if (this->gpmi_version == GPMI_VERSION_0501)
+		flags |= MXS_DMA_F_WAIT4END;
 	desc = channel->device->device_prep_slave_sg(channel,
 					(struct scatterlist *)pio,
-					ARRAY_SIZE(pio), DMA_TRANS_NONE, 1);
+					ARRAY_SIZE(pio), DMA_TRANS_NONE, flags);
 	if (!desc) {
 		pr_err("step 2 error\n");
 		return -1;
@@ -1048,9 +1055,10 @@ int gpmi_read_page(struct gpmi_nand_data *this,
 		| BF_GPMI_CTRL0_ADDRESS(address)
 		| BF_GPMI_CTRL0_XFER_COUNT(geo->page_size);
 	pio[1] = 0;
+	pio[2] = 0;
 	desc = channel->device->device_prep_slave_sg(channel,
 				(struct scatterlist *)pio, 2,
-				DMA_TRANS_NONE, 1);
+				DMA_TRANS_NONE, MXS_DMA_F_LASTONE);
 	if (!desc) {
 		pr_err("step 3 error\n");
 		return -1;
-- 
1.7.0.4


