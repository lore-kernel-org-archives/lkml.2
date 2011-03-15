Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab1COFBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 01:01:39 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31206 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab1COFBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 01:01:23 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6285"; a="79772014"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jeff Ohlstein <johlstei@codeaurora.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 04/11] msm: dma: Toggle adm_pclk along with adm_clk
Date: Mon, 14 Mar 2011 22:01:07 -0700
Message-Id: <1300165274-8544-5-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300165274-8544-1-git-send-email-johlstei@codeaurora.org>
References: <1300165274-8544-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously we just left the pclk in whatever state it was in at boot.
Instead, turn it off and on at the same time that we turn the regular
clock on and off.

Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
---
 arch/arm/mach-msm/dma.c |   71 +++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 62 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-msm/dma.c b/arch/arm/mach-msm/dma.c
index 1f487b8..2dc408d 100644
--- a/arch/arm/mach-msm/dma.c
+++ b/arch/arm/mach-msm/dma.c
@@ -32,6 +32,7 @@ enum {
 
 static DEFINE_SPINLOCK(msm_dmov_lock);
 static struct clk *msm_dmov_clk;
+static struct clk *msm_dmov_pclk;
 static unsigned int channel_active;
 static struct list_head ready_commands[MSM_DMOV_CHANNEL_COUNT];
 static struct list_head active_commands[MSM_DMOV_CHANNEL_COUNT];
@@ -55,6 +56,31 @@ void msm_dmov_stop_cmd(unsigned id, struct msm_dmov_cmd *cmd, int graceful)
 }
 EXPORT_SYMBOL(msm_dmov_stop_cmd);
 
+static int msm_dmov_clocks_on(void)
+{
+	int ret = 0;
+
+	if (!IS_ERR(msm_dmov_clk)) {
+		ret = clk_enable(msm_dmov_clk);
+		if (ret)
+			return ret;
+		if (!IS_ERR(msm_dmov_pclk)) {
+			ret = clk_enable(msm_dmov_pclk);
+			if (ret)
+				clk_disable(msm_dmov_clk);
+		}
+	}
+	return ret;
+}
+
+static void msm_dmov_clocks_off(void)
+{
+	if (!IS_ERR(msm_dmov_clk))
+		clk_disable(msm_dmov_clk);
+	if (!IS_ERR(msm_dmov_pclk))
+		clk_disable(msm_dmov_pclk);
+}
+
 void msm_dmov_enqueue_cmd(unsigned id, struct msm_dmov_cmd *cmd)
 {
 	unsigned long irq_flags;
@@ -62,7 +88,7 @@ void msm_dmov_enqueue_cmd(unsigned id, struct msm_dmov_cmd *cmd)
 
 	spin_lock_irqsave(&msm_dmov_lock, irq_flags);
 	if (!channel_active)
-		clk_enable(msm_dmov_clk);
+		msm_dmov_clocks_on();
 	dsb();
 	status = readl(DMOV_STATUS(id));
 	if (list_empty(&ready_commands[id]) &&
@@ -83,7 +109,7 @@ void msm_dmov_enqueue_cmd(unsigned id, struct msm_dmov_cmd *cmd)
 		writel(cmd->cmdptr, DMOV_CMD_PTR(id));
 	} else {
 		if (!channel_active)
-			clk_disable(msm_dmov_clk);
+			msm_dmov_clocks_off();
 		if (list_empty(&active_commands[id]))
 			PRINT_ERROR("msm_dmov_enqueue_cmd(%d), error datamover stalled, status %x\n", id, status);
 
@@ -255,31 +281,58 @@ static irqreturn_t msm_datamover_irq_handler(int irq, void *dev_id)
 
 	if (!channel_active) {
 		disable_irq_nosync(INT_ADM_AARM);
-		clk_disable(msm_dmov_clk);
+		msm_dmov_clocks_off();
 	}
 
 	spin_unlock_irqrestore(&msm_dmov_lock, irq_flags);
 	return IRQ_HANDLED;
 }
 
+static void __init msm_dmov_deinit_clocks(void)
+{
+	if (!IS_ERR(msm_dmov_clk))
+		clk_put(msm_dmov_clk);
+	if (!IS_ERR(msm_dmov_pclk))
+		clk_put(msm_dmov_pclk);
+}
+
+static int __init msm_dmov_init_clocks(void)
+{
+	int ret = 0;
+
+	msm_dmov_clk = clk_get(NULL, "adm_clk");
+	if (IS_ERR(msm_dmov_clk)) {
+		PRINT_ERROR("%s: Error getting adm_clk\n", __func__);
+		ret = PTR_ERR(msm_dmov_clk);
+	}
+
+	msm_dmov_pclk = clk_get(NULL, "adm_pclk");
+	/* pclk not present on all SoCs, don't return error on failure */
+
+	return ret;
+}
+
 static int __init msm_init_datamover(void)
 {
 	int i;
 	int ret;
-	struct clk *clk;
 
 	for (i = 0; i < MSM_DMOV_CHANNEL_COUNT; i++) {
 		INIT_LIST_HEAD(&ready_commands[i]);
 		INIT_LIST_HEAD(&active_commands[i]);
 		writel(DMOV_CONFIG_IRQ_EN | DMOV_CONFIG_FORCE_TOP_PTR_RSLT | DMOV_CONFIG_FORCE_FLUSH_RSLT, DMOV_CONFIG(i));
 	}
-	clk = clk_get(NULL, "adm_clk");
-	if (IS_ERR(clk))
-		return PTR_ERR(clk);
-	msm_dmov_clk = clk;
-	ret = request_irq(INT_ADM_AARM, msm_datamover_irq_handler, 0, "msmdatamover", NULL);
+
+	ret = msm_dmov_init_clocks();
 	if (ret)
 		return ret;
+
+	ret = request_irq(INT_ADM_AARM, msm_datamover_irq_handler, 0,
+			  "msmdatamover", NULL);
+	if (ret) {
+		msm_dmov_deinit_clocks();
+		return ret;
+	}
 	disable_irq(INT_ADM_AARM);
 	return 0;
 }
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

