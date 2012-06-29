Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab2F2LdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 07:33:16 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5821 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab2F2LdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 07:33:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 29 Jun 2012 04:33:10 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <ccross@android.com>, <olof@lixom.net>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] ARM: tegra: apbio: use dmaengine based dma driver
Date: Fri, 29 Jun 2012 17:00:07 +0530
Message-ID: <1340969407-7662-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the dmaengine based Tegra APB DMA driver for
apbio access in place of legacy Tegra APB DMA.

The new driver is selected if legacy driver is not
selected and new DMA driver is enabled through config
file.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/mach-tegra/apbio.c |  135 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 131 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-tegra/apbio.c b/arch/arm/mach-tegra/apbio.c
index 74ac0db..00405be 100644
--- a/arch/arm/mach-tegra/apbio.c
+++ b/arch/arm/mach-tegra/apbio.c
@@ -17,8 +17,7 @@
 #include <linux/io.h>
 #include <mach/iomap.h>
 #include <linux/of.h>
-
-#ifdef CONFIG_TEGRA_SYSTEM_DMA
+#include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
@@ -29,9 +28,8 @@
 
 #include "apbio.h"
 
+#if defined(CONFIG_TEGRA_SYSTEM_DMA) || defined(CONFIG_TEGRA20_APB_DMA)
 static DEFINE_MUTEX(tegra_apb_dma_lock);
-
-static struct tegra_dma_channel *tegra_apb_dma;
 static u32 *tegra_apb_bb;
 static dma_addr_t tegra_apb_bb_phys;
 static DECLARE_COMPLETION(tegra_apb_wait);
@@ -39,6 +37,9 @@ static DECLARE_COMPLETION(tegra_apb_wait);
 static u32 tegra_apb_readl_direct(unsigned long offset);
 static void tegra_apb_writel_direct(u32 value, unsigned long offset);
 
+#if defined(CONFIG_TEGRA_SYSTEM_DMA)
+static struct tegra_dma_channel *tegra_apb_dma;
+
 bool tegra_apb_init(void)
 {
 	struct tegra_dma_channel *ch;
@@ -149,6 +150,132 @@ static void tegra_apb_writel_using_dma(u32 value, unsigned long offset)
 
 	mutex_unlock(&tegra_apb_dma_lock);
 }
+
+#else
+static struct dma_chan *tegra_apb_dma_chan;
+static struct dma_slave_config dma_sconfig;
+
+bool tegra_apb_dma_init(void)
+{
+	dma_cap_mask_t mask;
+
+	mutex_lock(&tegra_apb_dma_lock);
+
+	/* Check to see if we raced to setup */
+	if (tegra_apb_dma_chan)
+		goto skip_init;
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+	tegra_apb_dma_chan = dma_request_channel(mask, NULL, NULL);
+	if (!tegra_apb_dma_chan) {
+		pr_err("%s: can not allocate dma channel\n", __func__);
+		goto err_dma_alloc;
+	}
+
+	tegra_apb_bb = dma_alloc_coherent(NULL, sizeof(u32),
+		&tegra_apb_bb_phys, GFP_KERNEL);
+	if (!tegra_apb_bb) {
+		pr_err("%s: can not allocate bounce buffer\n", __func__);
+		goto err_buff_alloc;
+	}
+
+	dma_sconfig.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	dma_sconfig.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	dma_sconfig.slave_id = TEGRA_DMA_REQ_SEL_CNTR;
+	dma_sconfig.src_maxburst = 1;
+	dma_sconfig.dst_maxburst = 1;
+
+skip_init:
+	mutex_unlock(&tegra_apb_dma_lock);
+	return true;
+
+err_buff_alloc:
+	dma_release_channel(tegra_apb_dma_chan);
+	tegra_apb_dma_chan = NULL;
+
+err_dma_alloc:
+	mutex_unlock(&tegra_apb_dma_lock);
+	return false;
+}
+
+static void apb_dma_complete(void *args)
+{
+	complete(&tegra_apb_wait);
+}
+
+static int do_dma_transfer(unsigned long apb_add,
+		enum dma_transfer_direction dir)
+{
+	struct dma_async_tx_descriptor *dma_desc;
+	int ret;
+
+	if (dir == DMA_DEV_TO_MEM)
+		dma_sconfig.src_addr = apb_add;
+	else
+		dma_sconfig.dst_addr = apb_add;
+
+	ret = dmaengine_slave_config(tegra_apb_dma_chan, &dma_sconfig);
+	if (ret)
+		return ret;
+
+	dma_desc = dmaengine_prep_slave_single(tegra_apb_dma_chan,
+			tegra_apb_bb_phys, sizeof(u32), dir,
+			DMA_PREP_INTERRUPT |  DMA_CTRL_ACK);
+	if (!dma_desc)
+		return -EINVAL;
+
+	dma_desc->callback = apb_dma_complete;
+	dma_desc->callback_param = NULL;
+
+	INIT_COMPLETION(tegra_apb_wait);
+
+	dmaengine_submit(dma_desc);
+	dma_async_issue_pending(tegra_apb_dma_chan);
+	ret = wait_for_completion_timeout(&tegra_apb_wait,
+		msecs_to_jiffies(50));
+
+	if (WARN(ret == 0, "apb read dma timed out")) {
+		dmaengine_terminate_all(tegra_apb_dma_chan);
+		return -EFAULT;
+	}
+	return 0;
+}
+
+static u32 tegra_apb_readl_using_dma(unsigned long offset)
+{
+	int ret;
+
+	if (!tegra_apb_dma_chan && !tegra_apb_dma_init())
+		return tegra_apb_readl_direct(offset);
+
+	mutex_lock(&tegra_apb_dma_lock);
+	ret = do_dma_transfer(offset, DMA_DEV_TO_MEM);
+	if (ret < 0) {
+		pr_err("error in reading offset 0x%08lx using dma\n", offset);
+		*(u32 *)tegra_apb_bb = 0;
+	}
+	mutex_unlock(&tegra_apb_dma_lock);
+	return *((u32 *)tegra_apb_bb);
+}
+
+static void tegra_apb_writel_using_dma(u32 value, unsigned long offset)
+{
+	int ret;
+
+	if (!tegra_apb_dma_chan && !tegra_apb_dma_init()) {
+		tegra_apb_writel_direct(value, offset);
+		return;
+	}
+
+	mutex_lock(&tegra_apb_dma_lock);
+	*((u32 *)tegra_apb_bb) = value;
+	ret = do_dma_transfer(offset, DMA_MEM_TO_DEV);
+	if (ret < 0)
+		pr_err("error in writing offset 0x%08lx using dma\n", offset);
+	mutex_unlock(&tegra_apb_dma_lock);
+}
+#endif
 #else
 #define tegra_apb_readl_using_dma tegra_apb_readl_direct
 #define tegra_apb_writel_using_dma tegra_apb_writel_direct
-- 
1.7.1.1

