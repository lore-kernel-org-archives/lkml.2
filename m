Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab3AFQXf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 11:23:35 -0500
Received: from [216.228.121.140] ([216.228.121.140]:2833 "EHLO
	hqemgate03.nvidia.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab3AFQXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 11:23:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 06 Jan 2013 08:22:22 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <vinod.koul@intel.com>
CC: <djbw@fb.com>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/2] dma: tegra: add support for channel wise pause
Date: Sun, 6 Jan 2013 21:52:02 +0530
Message-ID: <1357489323-21359-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1357489323-21359-1-git-send-email-ldewangan@nvidia.com>
References: <1357489323-21359-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NVIDIA's some SoCs like Tegra114 support the channel wise pause control
inplace of global pause which pauses all DMA channels. When SoCs support
the channel wise pause control then it uses the global pause for clock
gating for register access as well as all DMA channel pause. Hence DMA
registers are not accessible if DMAs are globally paused on these new SoCs.

Add support for channel wise pause feature if SoCs support it.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/dma/tegra20-apb-dma.c |   43 ++++++++++++++++++++++++++++++++++++----
 1 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index c39e61b..1f3ea0f 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -62,6 +62,9 @@
 #define TEGRA_APBDMA_STATUS_COUNT_SHIFT		2
 #define TEGRA_APBDMA_STATUS_COUNT_MASK		0xFFFC
 
+#define TEGRA_APBDMA_CHAN_CSRE			0x00C
+#define TEGRA_APBDMA_CHAN_CSRE_PAUSE		(1 << 31)
+
 /* AHB memory address */
 #define TEGRA_APBDMA_CHAN_AHBPTR		0x010
 
@@ -112,10 +115,12 @@ struct tegra_dma;
  * tegra_dma_chip_data Tegra chip specific DMA data
  * @nr_channels: Number of channels available in the controller.
  * @max_dma_count: Maximum DMA transfer count supported by DMA controller.
+ * @support_channel_pause: Support channel wise pause of dma.
  */
 struct tegra_dma_chip_data {
 	int nr_channels;
 	int max_dma_count;
+	bool support_channel_pause;
 };
 
 /* DMA channel registers */
@@ -353,6 +358,32 @@ static void tegra_dma_global_resume(struct tegra_dma_channel *tdc)
 	spin_unlock(&tdma->global_lock);
 }
 
+static void tegra_dma_pause(struct tegra_dma_channel *tdc,
+	bool wait_for_burst_complete)
+{
+	struct tegra_dma *tdma = tdc->tdma;
+
+	if (tdma->chip_data->support_channel_pause) {
+		tdc_write(tdc, TEGRA_APBDMA_CHAN_CSRE,
+				TEGRA_APBDMA_CHAN_CSRE_PAUSE);
+		if (wait_for_burst_complete)
+			udelay(TEGRA_APBDMA_BURST_COMPLETE_TIME);
+	} else {
+		tegra_dma_global_pause(tdc, wait_for_burst_complete);
+	}
+}
+
+static void tegra_dma_resume(struct tegra_dma_channel *tdc)
+{
+	struct tegra_dma *tdma = tdc->tdma;
+
+	if (tdma->chip_data->support_channel_pause) {
+		tdc_write(tdc, TEGRA_APBDMA_CHAN_CSRE, 0);
+	} else {
+		tegra_dma_global_resume(tdc);
+	}
+}
+
 static void tegra_dma_stop(struct tegra_dma_channel *tdc)
 {
 	u32 csr;
@@ -408,7 +439,7 @@ static void tegra_dma_configure_for_next(struct tegra_dma_channel *tdc,
 	 * If there is already IEC status then interrupt handler need to
 	 * load new configuration.
 	 */
-	tegra_dma_global_pause(tdc, false);
+	tegra_dma_pause(tdc, false);
 	status  = tdc_read(tdc, TEGRA_APBDMA_CHAN_STATUS);
 
 	/*
@@ -418,7 +449,7 @@ static void tegra_dma_configure_for_next(struct tegra_dma_channel *tdc,
 	if (status & TEGRA_APBDMA_STATUS_ISE_EOC) {
 		dev_err(tdc2dev(tdc),
 			"Skipping new configuration as interrupt is pending\n");
-		tegra_dma_global_resume(tdc);
+		tegra_dma_resume(tdc);
 		return;
 	}
 
@@ -429,7 +460,7 @@ static void tegra_dma_configure_for_next(struct tegra_dma_channel *tdc,
 				nsg_req->ch_regs.csr | TEGRA_APBDMA_CSR_ENB);
 	nsg_req->configured = true;
 
-	tegra_dma_global_resume(tdc);
+	tegra_dma_resume(tdc);
 }
 
 static void tdc_start_head_req(struct tegra_dma_channel *tdc)
@@ -690,7 +721,7 @@ static void tegra_dma_terminate_all(struct dma_chan *dc)
 		goto skip_dma_stop;
 
 	/* Pause DMA before checking the queue status */
-	tegra_dma_global_pause(tdc, true);
+	tegra_dma_pause(tdc, true);
 
 	status = tdc_read(tdc, TEGRA_APBDMA_CHAN_STATUS);
 	if (status & TEGRA_APBDMA_STATUS_ISE_EOC) {
@@ -708,7 +739,7 @@ static void tegra_dma_terminate_all(struct dma_chan *dc)
 		sgreq->dma_desc->bytes_transferred +=
 				get_current_xferred_count(tdc, sgreq, status);
 	}
-	tegra_dma_global_resume(tdc);
+	tegra_dma_resume(tdc);
 
 skip_dma_stop:
 	tegra_dma_abort_all(tdc);
@@ -1175,6 +1206,7 @@ static void tegra_dma_free_chan_resources(struct dma_chan *dc)
 static const struct tegra_dma_chip_data tegra20_dma_chip_data = {
 	.nr_channels		= 16,
 	.max_dma_count		= 1024UL * 64,
+	.support_channel_pause	= false,
 };
 
 #if defined(CONFIG_OF)
@@ -1182,6 +1214,7 @@ static const struct tegra_dma_chip_data tegra20_dma_chip_data = {
 static const struct tegra_dma_chip_data tegra30_dma_chip_data = {
 	.nr_channels		= 32,
 	.max_dma_count		= 1024UL * 64,
+	.support_channel_pause	= false,
 };
 
 static const struct of_device_id tegra_dma_of_match[] = {
-- 
1.7.1.1

