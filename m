Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab1COFDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 01:03:33 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56080 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab1COFBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 01:01:24 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6285"; a="79772020"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jeff Ohlstein <johlstei@codeaurora.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>, San Mehat <san@google.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 08/11] msm: dma: Handle probe failure in dma function
Date: Mon, 14 Mar 2011 22:01:11 -0700
Message-Id: <1300165274-8544-9-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300165274-8544-1-git-send-email-johlstei@codeaurora.org>
References: <1300165274-8544-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not safe to call the existing functions if dma fails to probe. So,
check for probe failure at the start of each externally facing function.

Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
---
 arch/arm/mach-msm/dma.c              |   26 +++++++++++++++++++++++---
 arch/arm/mach-msm/include/mach/dma.h |   15 +++++++++------
 2 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-msm/dma.c b/arch/arm/mach-msm/dma.c
index ef543e1..5510c61 100644
--- a/arch/arm/mach-msm/dma.c
+++ b/arch/arm/mach-msm/dma.c
@@ -100,12 +100,17 @@ static inline void dmov_writel(unsigned val, unsigned addr, int adm)
 #define DMOV_ID_TO_CHAN(id)   ((id) % MSM_DMOV_CHANNEL_COUNT)
 #define DMOV_CHAN_ADM_TO_ID(ch, adm) ((ch) + (adm) * MSM_DMOV_CHANNEL_COUNT)
 
-void msm_dmov_stop_cmd(unsigned id, struct msm_dmov_cmd *cmd, int graceful)
+int msm_dmov_stop_cmd(unsigned id, struct msm_dmov_cmd *cmd, int graceful)
 {
 	int adm = DMOV_ID_TO_ADM(id);
 	int ch = DMOV_ID_TO_CHAN(id);
 
+	if (!dmov_conf[adm].base)
+		return -ENODEV;
+
 	dmov_writel((graceful << 31), DMOV_FLUSH0(ch), adm);
+
+	return 0;
 }
 EXPORT_SYMBOL(msm_dmov_stop_cmd);
 
@@ -134,13 +139,16 @@ static void msm_dmov_clocks_off(int adm)
 		clk_disable(dmov_conf[adm].pclk);
 }
 
-void msm_dmov_enqueue_cmd(unsigned id, struct msm_dmov_cmd *cmd)
+int msm_dmov_enqueue_cmd(unsigned id, struct msm_dmov_cmd *cmd)
 {
 	unsigned long irq_flags;
 	unsigned int status;
 	int adm = DMOV_ID_TO_ADM(id);
 	int ch = DMOV_ID_TO_CHAN(id);
 
+	if (!dmov_conf[adm].base)
+		return -ENODEV;
+
 	spin_lock_irqsave(&dmov_conf[adm].lock, irq_flags);
 	if (!dmov_conf[adm].channel_active)
 		msm_dmov_clocks_on(adm);
@@ -168,15 +176,20 @@ void msm_dmov_enqueue_cmd(unsigned id, struct msm_dmov_cmd *cmd)
 		list_add_tail(&cmd->list, &dmov_conf[adm].ready_commands[ch]);
 	}
 	spin_unlock_irqrestore(&dmov_conf[adm].lock, irq_flags);
+
+	return 0;
 }
 EXPORT_SYMBOL(msm_dmov_enqueue_cmd);
 
-void msm_dmov_flush(unsigned int id)
+int msm_dmov_flush(unsigned int id)
 {
 	unsigned long flags;
 	int ch = DMOV_ID_TO_CHAN(id);
 	int adm = DMOV_ID_TO_ADM(id);
 
+	if (!dmov_conf[adm].base)
+		return -ENODEV;
+
 	spin_lock_irqsave(&dmov_conf[adm].lock, flags);
 	/* XXX not checking if flush cmd sent already */
 	if (!list_empty(&dmov_conf[adm].active_commands[ch])) {
@@ -184,6 +197,8 @@ void msm_dmov_flush(unsigned int id)
 		dmov_writel(DMOV_FLUSH_GRACEFUL, DMOV_FLUSH0(ch), adm);
 	}
 	spin_unlock_irqrestore(&dmov_conf[adm].lock, flags);
+
+	return 0;
 }
 EXPORT_SYMBOL(msm_dmov_flush);
 
@@ -211,6 +226,10 @@ dmov_exec_cmdptr_complete_func(struct msm_dmov_cmd *_cmd,
 int msm_dmov_exec_cmd(unsigned id, unsigned int cmdptr)
 {
 	struct msm_dmov_exec_cmdptr_cmd cmd;
+	int adm = DMOV_ID_TO_ADM(id);
+
+	if (!dmov_conf[adm].base)
+		return -ENODEV;
 
 	PRINT_FLOW("dmov_exec_cmdptr(%d, %x)\n", id, cmdptr);
 
@@ -424,6 +443,7 @@ static int __devinit msm_dmov_conf_init(struct platform_device *pdev)
 static inline void __devinit msm_dmov_conf_free(int adm)
 {
 	iounmap(dmov_conf[adm].base);
+	dmov_conf[adm].base = NULL;
 }
 
 static int __devinit msm_dmov_probe(struct platform_device *pdev)
diff --git a/arch/arm/mach-msm/include/mach/dma.h b/arch/arm/mach-msm/include/mach/dma.h
index ae031d2..23041c7 100644
--- a/arch/arm/mach-msm/include/mach/dma.h
+++ b/arch/arm/mach-msm/include/mach/dma.h
@@ -35,19 +35,22 @@ struct msm_dmov_cmd {
 };
 
 #ifndef CONFIG_ARCH_MSM8X60
-void msm_dmov_enqueue_cmd(unsigned id, struct msm_dmov_cmd *cmd);
-void msm_dmov_stop_cmd(unsigned id, struct msm_dmov_cmd *cmd, int graceful);
+int msm_dmov_enqueue_cmd(unsigned id, struct msm_dmov_cmd *cmd);
+int msm_dmov_stop_cmd(unsigned id, struct msm_dmov_cmd *cmd, int graceful);
 int msm_dmov_exec_cmd(unsigned id, unsigned int cmdptr);
-void msm_dmov_flush(unsigned int id);
+int msm_dmov_flush(unsigned int id);
 #else
 static inline
-void msm_dmov_enqueue_cmd(unsigned id, struct msm_dmov_cmd *cmd) { }
+int msm_dmov_enqueue_cmd(unsigned id, struct msm_dmov_cmd *cmd) { return -EIO; }
 static inline
-void msm_dmov_stop_cmd(unsigned id, struct msm_dmov_cmd *cmd, int graceful) { }
+int msm_dmov_stop_cmd(unsigned id, struct msm_dmov_cmd *cmd, int graceful)
+{
+	return -EIO;
+}
 static inline
 int msm_dmov_exec_cmd(unsigned id, unsigned int cmdptr) { return -EIO; }
 static inline
-void msm_dmov_flush(unsigned int id) { }
+int msm_dmov_flush(unsigned int id) { return -EIO; }
 #endif
 
 #define DMOV_CMD_LIST         (0 << 29) /* does not work */
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

