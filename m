Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933378Ab2BBVfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:35:14 -0500
Received: from mxout1.idt.com ([157.165.5.25]:57416 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932766Ab2BBVeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:34:17 -0500
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Marek Vasut <marek.vasut@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Huang Shijie <b32955@freescale.com>,
        Artem Bityutskiy <artem.bityutskiy@intel.com>
Subject: [PATCH 06/11] nand/gpmi: add context parameter to prep_slave_sg calls
Date: Thu,  2 Feb 2012 16:32:16 -0500
Message-Id: <1328218341-31436-7-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com>
References: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixups for calls affected by adding the new context parameter to DMA_SLAVE
and DMA_CYCLIC interfaces.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Marek Vasut <marek.vasut@gmail.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Huang Shijie <b32955@freescale.com>
Cc: Artem Bityutskiy <artem.bityutskiy@intel.com>
---
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c |   25 +++++++++++++++----------
 1 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
index 7f68042..c52964e 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
@@ -827,7 +827,8 @@ int gpmi_send_command(struct gpmi_nand_data *this)
 	pio[1] = pio[2] = 0;
 	desc = channel->device->device_prep_slave_sg(channel,
 					(struct scatterlist *)pio,
-					ARRAY_SIZE(pio), DMA_TRANS_NONE, 0);
+					ARRAY_SIZE(pio), DMA_TRANS_NONE,
+					0, NULL);
 	if (!desc) {
 		pr_err("step 1 error\n");
 		return -1;
@@ -839,7 +840,7 @@ int gpmi_send_command(struct gpmi_nand_data *this)
 	sg_init_one(sgl, this->cmd_buffer, this->command_length);
 	dma_map_sg(this->dev, sgl, 1, DMA_TO_DEVICE);
 	desc = channel->device->device_prep_slave_sg(channel,
-					sgl, 1, DMA_MEM_TO_DEV, 1);
+					sgl, 1, DMA_MEM_TO_DEV, 1, NULL);
 	if (!desc) {
 		pr_err("step 2 error\n");
 		return -1;
@@ -872,7 +873,8 @@ int gpmi_send_data(struct gpmi_nand_data *this)
 	pio[1] = 0;
 	desc = channel->device->device_prep_slave_sg(channel,
 					(struct scatterlist *)pio,
-					ARRAY_SIZE(pio), DMA_TRANS_NONE, 0);
+					ARRAY_SIZE(pio), DMA_TRANS_NONE,
+					0, NULL);
 	if (!desc) {
 		pr_err("step 1 error\n");
 		return -1;
@@ -881,7 +883,7 @@ int gpmi_send_data(struct gpmi_nand_data *this)
 	/* [2] send DMA request */
 	prepare_data_dma(this, DMA_TO_DEVICE);
 	desc = channel->device->device_prep_slave_sg(channel, &this->data_sgl,
-						1, DMA_MEM_TO_DEV, 1);
+						1, DMA_MEM_TO_DEV, 1, NULL);
 	if (!desc) {
 		pr_err("step 2 error\n");
 		return -1;
@@ -908,7 +910,8 @@ int gpmi_read_data(struct gpmi_nand_data *this)
 	pio[1] = 0;
 	desc = channel->device->device_prep_slave_sg(channel,
 					(struct scatterlist *)pio,
-					ARRAY_SIZE(pio), DMA_TRANS_NONE, 0);
+					ARRAY_SIZE(pio), DMA_TRANS_NONE,
+					0, NULL);
 	if (!desc) {
 		pr_err("step 1 error\n");
 		return -1;
@@ -917,7 +920,7 @@ int gpmi_read_data(struct gpmi_nand_data *this)
 	/* [2] : send DMA request */
 	prepare_data_dma(this, DMA_FROM_DEVICE);
 	desc = channel->device->device_prep_slave_sg(channel, &this->data_sgl,
-						1, DMA_DEV_TO_MEM, 1);
+						1, DMA_DEV_TO_MEM, 1, NULL);
 	if (!desc) {
 		pr_err("step 2 error\n");
 		return -1;
@@ -964,7 +967,8 @@ int gpmi_send_page(struct gpmi_nand_data *this,
 
 	desc = channel->device->device_prep_slave_sg(channel,
 					(struct scatterlist *)pio,
-					ARRAY_SIZE(pio), DMA_TRANS_NONE, 0);
+					ARRAY_SIZE(pio), DMA_TRANS_NONE,
+					0, NULL);
 	if (!desc) {
 		pr_err("step 2 error\n");
 		return -1;
@@ -999,7 +1003,7 @@ int gpmi_read_page(struct gpmi_nand_data *this,
 	pio[1] = 0;
 	desc = channel->device->device_prep_slave_sg(channel,
 				(struct scatterlist *)pio, 2,
-				DMA_TRANS_NONE, 0);
+				DMA_TRANS_NONE, 0, NULL);
 	if (!desc) {
 		pr_err("step 1 error\n");
 		return -1;
@@ -1028,7 +1032,8 @@ int gpmi_read_page(struct gpmi_nand_data *this,
 	pio[5] = auxiliary;
 	desc = channel->device->device_prep_slave_sg(channel,
 					(struct scatterlist *)pio,
-					ARRAY_SIZE(pio), DMA_TRANS_NONE, 1);
+					ARRAY_SIZE(pio), DMA_TRANS_NONE,
+					1, NULL);
 	if (!desc) {
 		pr_err("step 2 error\n");
 		return -1;
@@ -1047,7 +1052,7 @@ int gpmi_read_page(struct gpmi_nand_data *this,
 	pio[1] = 0;
 	desc = channel->device->device_prep_slave_sg(channel,
 				(struct scatterlist *)pio, 2,
-				DMA_TRANS_NONE, 1);
+				DMA_TRANS_NONE, 1, NULL);
 	if (!desc) {
 		pr_err("step 3 error\n");
 		return -1;
-- 
1.7.8.4

