Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327Ab2BBVe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:34:26 -0500
Received: from mxout1.idt.com ([157.165.5.25]:57427 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932585Ab2BBVeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:34:24 -0500
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, Chris Ball <cjb@laptop.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ian Molton <ian@mnementh.co.uk>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Per Forlin <per.forlin@stericsson.com>,
        Ulf Hansson <ulf.hansson@stericsson.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH 05/11] mmc/host: add context parameter for DMA_SLAVE and DMA_CYCLIC
Date: Thu,  2 Feb 2012 16:32:15 -0500
Message-Id: <1328218341-31436-6-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com>
References: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixups for calls affected by adding the new context parameter to DMA_SLAVE
and DMA_CYCLIC interfaces.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Chris Ball <cjb@laptop.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Per Forlin <per.forlin@stericsson.com>
Cc: Ulf Hansson <ulf.hansson@stericsson.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/mmc/host/atmel-mci.c    |    2 +-
 drivers/mmc/host/mmci.c         |    2 +-
 drivers/mmc/host/mxcmmc.c       |    2 +-
 drivers/mmc/host/mxs-mmc.c      |    2 +-
 drivers/mmc/host/sh_mmcif.c     |    6 ++++--
 drivers/mmc/host/tmio_mmc_dma.c |    4 ++--
 6 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index fcfe1eb..8e2d1f9 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -874,7 +874,7 @@ atmci_prepare_data_dma(struct atmel_mci *host, struct mmc_data *data)
 
 	desc = chan->device->device_prep_slave_sg(chan,
 			data->sg, sglen, slave_dirn,
-			DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+			DMA_PREP_INTERRUPT | DMA_CTRL_ACK, NULL);
 	if (!desc)
 		goto unmap_exit;
 
diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 0d955ff..39b574d 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -412,7 +412,7 @@ static int mmci_dma_prep_data(struct mmci_host *host, struct mmc_data *data,
 
 	dmaengine_slave_config(chan, &conf);
 	desc = device->device_prep_slave_sg(chan, data->sg, nr_sg,
-					    conf.direction, DMA_CTRL_ACK);
+					    conf.direction, DMA_CTRL_ACK, NULL);
 	if (!desc)
 		goto unmap_exit;
 
diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
index 4184b79..870f94f 100644
--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -256,7 +256,7 @@ static int mxcmci_setup_data(struct mxcmci_host *host, struct mmc_data *data)
 
 	host->desc = host->dma->device->device_prep_slave_sg(host->dma,
 		data->sg, data->sg_len, slave_dirn,
-		DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+		DMA_PREP_INTERRUPT | DMA_CTRL_ACK, NULL);
 
 	if (!host->desc) {
 		dma_unmap_sg(host->dma->device->dev, data->sg, data->sg_len,
diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index 382c835..2bd7066 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -325,7 +325,7 @@ static struct dma_async_tx_descriptor *mxs_mmc_prep_dma(
 	}
 
 	desc = host->dmach->device->device_prep_slave_sg(host->dmach,
-				sgl, sg_len, host->slave_dirn, append);
+				sgl, sg_len, host->slave_dirn, append, NULL);
 	if (desc) {
 		desc->callback = mxs_mmc_dma_irq_callback;
 		desc->callback_param = host;
diff --git a/drivers/mmc/host/sh_mmcif.c b/drivers/mmc/host/sh_mmcif.c
index f5d8b53..deff2fa 100644
--- a/drivers/mmc/host/sh_mmcif.c
+++ b/drivers/mmc/host/sh_mmcif.c
@@ -286,7 +286,8 @@ static void sh_mmcif_start_dma_rx(struct sh_mmcif_host *host)
 	if (ret > 0) {
 		host->dma_active = true;
 		desc = chan->device->device_prep_slave_sg(chan, sg, ret,
-			DMA_DEV_TO_MEM, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+			DMA_DEV_TO_MEM, DMA_PREP_INTERRUPT | DMA_CTRL_ACK,
+			NULL);
 	}
 
 	if (desc) {
@@ -335,7 +336,8 @@ static void sh_mmcif_start_dma_tx(struct sh_mmcif_host *host)
 	if (ret > 0) {
 		host->dma_active = true;
 		desc = chan->device->device_prep_slave_sg(chan, sg, ret,
-			DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+			DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK,
+			NULL);
 	}
 
 	if (desc) {
diff --git a/drivers/mmc/host/tmio_mmc_dma.c b/drivers/mmc/host/tmio_mmc_dma.c
index 7a6e6cc..3fb4286 100644
--- a/drivers/mmc/host/tmio_mmc_dma.c
+++ b/drivers/mmc/host/tmio_mmc_dma.c
@@ -77,7 +77,7 @@ static void tmio_mmc_start_dma_rx(struct tmio_mmc_host *host)
 	ret = dma_map_sg(chan->device->dev, sg, host->sg_len, DMA_FROM_DEVICE);
 	if (ret > 0)
 		desc = chan->device->device_prep_slave_sg(chan, sg, ret,
-			DMA_DEV_TO_MEM, DMA_CTRL_ACK);
+			DMA_DEV_TO_MEM, DMA_CTRL_ACK, NULL);
 
 	if (desc) {
 		cookie = dmaengine_submit(desc);
@@ -158,7 +158,7 @@ static void tmio_mmc_start_dma_tx(struct tmio_mmc_host *host)
 	ret = dma_map_sg(chan->device->dev, sg, host->sg_len, DMA_TO_DEVICE);
 	if (ret > 0)
 		desc = chan->device->device_prep_slave_sg(chan, sg, ret,
-			DMA_MEM_TO_DEV, DMA_CTRL_ACK);
+			DMA_MEM_TO_DEV, DMA_CTRL_ACK, NULL);
 
 	if (desc) {
 		cookie = dmaengine_submit(desc);
-- 
1.7.8.4

