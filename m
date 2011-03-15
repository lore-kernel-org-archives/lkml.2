Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab1COFBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 01:01:45 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63697 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab1COFBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 01:01:24 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6285"; a="79964168"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jeff Ohlstein <johlstei@codeaurora.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 07/11] msm: dma: Support multiple adms
Date: Mon, 14 Mar 2011 22:01:10 -0700
Message-Id: <1300165274-8544-8-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300165274-8544-1-git-send-email-johlstei@codeaurora.org>
References: <1300165274-8544-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for targets which have more than one ADM present. In the
interest of maintaining the same api as before, map each ADM's channels
sequentially, so adm0 would have channels 0-15, adm1 would have channels
16-31, etc.

Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
---
 arch/arm/mach-msm/dma.c |  314 +++++++++++++++++++++++++++++------------------
 1 files changed, 194 insertions(+), 120 deletions(-)

diff --git a/arch/arm/mach-msm/dma.c b/arch/arm/mach-msm/dma.c
index 3bafee9..ef543e1 100644
--- a/arch/arm/mach-msm/dma.c
+++ b/arch/arm/mach-msm/dma.c
@@ -21,9 +21,11 @@
 #include <linux/completion.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <mach/dma.h>
 
 #define MSM_DMOV_CHANNEL_COUNT 16
+#define MSM_DMOV_MAX_ADMS 2
 
 #define MODULE_NAME "msm_dmov"
 
@@ -33,20 +35,26 @@ enum {
 	MSM_DMOV_PRINT_FLOW = 4
 };
 
-static DEFINE_SPINLOCK(msm_dmov_lock);
-static struct clk *msm_dmov_clk;
-static struct clk *msm_dmov_pclk;
-static unsigned int channel_active;
-static struct list_head ready_commands[MSM_DMOV_CHANNEL_COUNT];
-static struct list_head active_commands[MSM_DMOV_CHANNEL_COUNT];
 unsigned int msm_dmov_print_mask = MSM_DMOV_PRINT_ERRORS;
-static void __iomem *msm_dmov_base;
-static unsigned msm_dmov_irq;
 
-#define DMOV_SD0(off, ch) (msm_dmov_base + 0x0000 + (off) + ((ch) << 2))
-#define DMOV_SD1(off, ch) (msm_dmov_base + 0x0400 + (off) + ((ch) << 2))
-#define DMOV_SD2(off, ch) (msm_dmov_base + 0x0800 + (off) + ((ch) << 2))
-#define DMOV_SD3(off, ch) (msm_dmov_base + 0x0C00 + (off) + ((ch) << 2))
+struct msm_dmov_conf {
+	void __iomem *base;
+	int channel_active;
+	struct list_head ready_commands[MSM_DMOV_CHANNEL_COUNT];
+	struct list_head active_commands[MSM_DMOV_CHANNEL_COUNT];
+	spinlock_t lock;
+	unsigned irq;
+	struct clk *clk;
+	struct clk *pclk;
+};
+
+static struct msm_dmov_conf dmov_conf[MSM_DMOV_MAX_ADMS];
+static int nr_adms;
+
+#define DMOV_SD0(off, ch) (0x0000 + (off) + ((ch) << 2))
+#define DMOV_SD1(off, ch) (0x0400 + (off) + ((ch) << 2))
+#define DMOV_SD2(off, ch) (0x0800 + (off) + ((ch) << 2))
+#define DMOV_SD3(off, ch) (0x0C00 + (off) + ((ch) << 2))
 
 #if defined(CONFIG_ARCH_MSM7X30)
 #define DMOV_SD_AARM DMOV_SD2
@@ -78,86 +86,104 @@ static unsigned msm_dmov_irq;
 #define PRINT_FLOW(format, args...) \
 	MSM_DMOV_DPRINTF(MSM_DMOV_PRINT_FLOW, format, args);
 
+static inline unsigned dmov_readl(unsigned addr, int adm)
+{
+	return readl(dmov_conf[adm].base + addr);
+}
+
+static inline void dmov_writel(unsigned val, unsigned addr, int adm)
+{
+	writel(val, dmov_conf[adm].base + addr);
+}
+
+#define DMOV_ID_TO_ADM(id)   ((id) / MSM_DMOV_CHANNEL_COUNT)
+#define DMOV_ID_TO_CHAN(id)   ((id) % MSM_DMOV_CHANNEL_COUNT)
+#define DMOV_CHAN_ADM_TO_ID(ch, adm) ((ch) + (adm) * MSM_DMOV_CHANNEL_COUNT)
+
 void msm_dmov_stop_cmd(unsigned id, struct msm_dmov_cmd *cmd, int graceful)
 {
-	writel((graceful << 31), DMOV_FLUSH0(id));
+	int adm = DMOV_ID_TO_ADM(id);
+	int ch = DMOV_ID_TO_CHAN(id);
+
+	dmov_writel((graceful << 31), DMOV_FLUSH0(ch), adm);
 }
 EXPORT_SYMBOL(msm_dmov_stop_cmd);
 
-static int msm_dmov_clocks_on(void)
+static int msm_dmov_clocks_on(int adm)
 {
 	int ret = 0;
 
-	if (!IS_ERR(msm_dmov_clk)) {
-		ret = clk_enable(msm_dmov_clk);
+	if (!IS_ERR(dmov_conf[adm].clk)) {
+		ret = clk_enable(dmov_conf[adm].clk);
 		if (ret)
 			return ret;
-		if (!IS_ERR(msm_dmov_pclk)) {
-			ret = clk_enable(msm_dmov_pclk);
+		if (!IS_ERR(dmov_conf[adm].pclk)) {
+			ret = clk_enable(dmov_conf[adm].pclk);
 			if (ret)
-				clk_disable(msm_dmov_clk);
+				clk_disable(dmov_conf[adm].clk);
 		}
 	}
 	return ret;
 }
 
-static void msm_dmov_clocks_off(void)
+static void msm_dmov_clocks_off(int adm)
 {
-	if (!IS_ERR(msm_dmov_clk))
-		clk_disable(msm_dmov_clk);
-	if (!IS_ERR(msm_dmov_pclk))
-		clk_disable(msm_dmov_pclk);
+	if (!IS_ERR(dmov_conf[adm].clk))
+		clk_disable(dmov_conf[adm].clk);
+	if (!IS_ERR(dmov_conf[adm].pclk))
+		clk_disable(dmov_conf[adm].pclk);
 }
 
 void msm_dmov_enqueue_cmd(unsigned id, struct msm_dmov_cmd *cmd)
 {
 	unsigned long irq_flags;
 	unsigned int status;
+	int adm = DMOV_ID_TO_ADM(id);
+	int ch = DMOV_ID_TO_CHAN(id);
 
-	spin_lock_irqsave(&msm_dmov_lock, irq_flags);
-	if (!channel_active)
-		msm_dmov_clocks_on();
+	spin_lock_irqsave(&dmov_conf[adm].lock, irq_flags);
+	if (!dmov_conf[adm].channel_active)
+		msm_dmov_clocks_on(adm);
 	dsb();
-	status = readl(DMOV_STATUS(id));
-	if (list_empty(&ready_commands[id]) &&
+	status = dmov_readl(DMOV_STATUS(ch), adm);
+	if (list_empty(&dmov_conf[adm].ready_commands[ch]) &&
 		(status & DMOV_STATUS_CMD_PTR_RDY)) {
-#if 0
-		if (list_empty(&active_commands[id])) {
-			PRINT_FLOW("msm_dmov_enqueue_cmd(%d), enable interrupt\n", id);
-			writel(DMOV_CONFIG_IRQ_EN, DMOV_CONFIG(id));
-		}
-#endif
 		if (cmd->execute_func)
 			cmd->execute_func(cmd);
-		PRINT_IO("msm_dmov_enqueue_cmd(%d), start command, status %x\n", id, status);
-		list_add_tail(&cmd->list, &active_commands[id]);
-		if (!channel_active)
-			enable_irq(msm_dmov_irq);
-		channel_active |= 1U << id;
-		writel(cmd->cmdptr, DMOV_CMD_PTR(id));
+		PRINT_IO("msm_dmov_enqueue_cmd(%d), start command, status %x\n",
+			 id, status);
+		list_add_tail(&cmd->list, &dmov_conf[adm].active_commands[ch]);
+		if (!dmov_conf[adm].channel_active)
+			enable_irq(dmov_conf[adm].irq);
+		dmov_conf[adm].channel_active |= 1U << ch;
+		dmov_writel(cmd->cmdptr, DMOV_CMD_PTR(ch), adm);
 	} else {
-		if (!channel_active)
-			msm_dmov_clocks_off();
-		if (list_empty(&active_commands[id]))
-			PRINT_ERROR("msm_dmov_enqueue_cmd(%d), error datamover stalled, status %x\n", id, status);
-
-		PRINT_IO("msm_dmov_enqueue_cmd(%d), enqueue command, status %x\n", id, status);
-		list_add_tail(&cmd->list, &ready_commands[id]);
+		if (!dmov_conf[adm].channel_active)
+			msm_dmov_clocks_off(adm);
+		if (list_empty(&dmov_conf[adm].active_commands[ch]))
+			PRINT_ERROR("msm_dmov_enqueue_cmd(%d), error datamover "
+				    "stalled, status %x\n", id, status);
+		PRINT_IO("msm_dmov_enqueue_cmd(%d), enqueue command, status "
+			 "%x\n", id, status);
+		list_add_tail(&cmd->list, &dmov_conf[adm].ready_commands[ch]);
 	}
-	spin_unlock_irqrestore(&msm_dmov_lock, irq_flags);
+	spin_unlock_irqrestore(&dmov_conf[adm].lock, irq_flags);
 }
 EXPORT_SYMBOL(msm_dmov_enqueue_cmd);
 
 void msm_dmov_flush(unsigned int id)
 {
 	unsigned long flags;
-	spin_lock_irqsave(&msm_dmov_lock, flags);
+	int ch = DMOV_ID_TO_CHAN(id);
+	int adm = DMOV_ID_TO_ADM(id);
+
+	spin_lock_irqsave(&dmov_conf[adm].lock, flags);
 	/* XXX not checking if flush cmd sent already */
-	if (!list_empty(&active_commands[id])) {
+	if (!list_empty(&dmov_conf[adm].active_commands[ch])) {
 		PRINT_IO("msm_dmov_flush(%d), send flush cmd\n", id);
-		writel(DMOV_FLUSH_GRACEFUL, DMOV_FLUSH0(id));
+		dmov_writel(DMOV_FLUSH_GRACEFUL, DMOV_FLUSH0(ch), adm);
 	}
-	spin_unlock_irqrestore(&msm_dmov_lock, flags);
+	spin_unlock_irqrestore(&dmov_conf[adm].lock, flags);
 }
 EXPORT_SYMBOL(msm_dmov_flush);
 
@@ -208,39 +234,66 @@ int msm_dmov_exec_cmd(unsigned id, unsigned int cmdptr)
 }
 EXPORT_SYMBOL(msm_dmov_exec_cmd);
 
+static void msm_dmov_fill_errdata(struct msm_dmov_errdata *errdata, int ch,
+				  int adm)
+{
+	errdata->flush[0] = dmov_readl(DMOV_FLUSH0(ch), adm);
+	errdata->flush[1] = dmov_readl(DMOV_FLUSH1(ch), adm);
+	errdata->flush[2] = dmov_readl(DMOV_FLUSH2(ch), adm);
+	errdata->flush[3] = dmov_readl(DMOV_FLUSH3(ch), adm);
+	errdata->flush[4] = dmov_readl(DMOV_FLUSH4(ch), adm);
+	errdata->flush[5] = dmov_readl(DMOV_FLUSH5(ch), adm);
+}
+
+static int msm_dmov_irq_to_adm(unsigned irq)
+{
+	int i;
+	for (i = 0; i < nr_adms; i++)
+		if (dmov_conf[i].irq == irq)
+			return i;
+	PRINT_ERROR("msm_dmov_irq_to_adm: can't match ADM to IRQ %d\n", irq);
+	return -EINVAL;
+}
+
 static irqreturn_t msm_datamover_irq_handler(int irq, void *dev_id)
 {
 	unsigned int int_status, mask, id;
 	unsigned long irq_flags;
+	unsigned int ch;
 	unsigned int ch_status;
 	unsigned int ch_result;
 	struct msm_dmov_cmd *cmd;
+	int adm = msm_dmov_irq_to_adm(irq);
 
-	spin_lock_irqsave(&msm_dmov_lock, irq_flags);
+	spin_lock_irqsave(&dmov_conf[adm].lock, irq_flags);
 
-	int_status = readl(DMOV_ISR); /* read and clear interrupt */
+	int_status = dmov_readl(DMOV_ISR, adm); /* read and clear interrupt */
 	PRINT_FLOW("msm_datamover_irq_handler: DMOV_ISR %x\n", int_status);
 
 	while (int_status) {
 		mask = int_status & -int_status;
-		id = fls(mask) - 1;
+		ch = fls(mask) - 1;
+		id = DMOV_CHAN_ADM_TO_ID(ch, adm);
 		PRINT_FLOW("msm_datamover_irq_handler %08x %08x id %d\n", int_status, mask, id);
 		int_status &= ~mask;
-		ch_status = readl(DMOV_STATUS(id));
+		ch_status = dmov_readl(DMOV_STATUS(ch), adm);
 		if (!(ch_status & DMOV_STATUS_RSLT_VALID)) {
 			PRINT_FLOW("msm_datamover_irq_handler id %d, result not valid %x\n", id, ch_status);
 			continue;
 		}
 		do {
-			ch_result = readl(DMOV_RSLT(id));
-			if (list_empty(&active_commands[id])) {
+			ch_result = dmov_readl(DMOV_RSLT(ch), adm);
+			if (list_empty(&dmov_conf[adm].active_commands[ch])) {
 				PRINT_ERROR("msm_datamover_irq_handler id %d, got result "
 					"with no active command, status %x, result %x\n",
 					id, ch_status, ch_result);
 				cmd = NULL;
 			} else
-				cmd = list_entry(active_commands[id].next, typeof(*cmd), list);
-			PRINT_FLOW("msm_datamover_irq_handler id %d, status %x, result %x\n", id, ch_status, ch_result);
+				cmd = list_entry(dmov_conf[adm].
+					active_commands[ch].next, typeof(*cmd),
+					list);
+			PRINT_FLOW("msm_datamover_irq_handler id %d, status %x,"
+				   " result %x\n", id, ch_status, ch_result);
 			if (ch_result & DMOV_RSLT_DONE) {
 				PRINT_FLOW("msm_datamover_irq_handler id %d, status %x\n",
 					id, ch_status);
@@ -255,12 +308,7 @@ static irqreturn_t msm_datamover_irq_handler(int irq, void *dev_id)
 			if (ch_result & DMOV_RSLT_FLUSH) {
 				struct msm_dmov_errdata errdata;
 
-				errdata.flush[0] = readl(DMOV_FLUSH0(id));
-				errdata.flush[1] = readl(DMOV_FLUSH1(id));
-				errdata.flush[2] = readl(DMOV_FLUSH2(id));
-				errdata.flush[3] = readl(DMOV_FLUSH3(id));
-				errdata.flush[4] = readl(DMOV_FLUSH4(id));
-				errdata.flush[5] = readl(DMOV_FLUSH5(id));
+				msm_dmov_fill_errdata(&errdata, ch, adm);
 				PRINT_FLOW("msm_datamover_irq_handler id %d, status %x\n", id, ch_status);
 				PRINT_FLOW("msm_datamover_irq_handler id %d, flush, result %x, flush0 %x\n", id, ch_result, errdata.flush[0]);
 				if (cmd) {
@@ -272,13 +320,7 @@ static irqreturn_t msm_datamover_irq_handler(int irq, void *dev_id)
 			if (ch_result & DMOV_RSLT_ERROR) {
 				struct msm_dmov_errdata errdata;
 
-				errdata.flush[0] = readl(DMOV_FLUSH0(id));
-				errdata.flush[1] = readl(DMOV_FLUSH1(id));
-				errdata.flush[2] = readl(DMOV_FLUSH2(id));
-				errdata.flush[3] = readl(DMOV_FLUSH3(id));
-				errdata.flush[4] = readl(DMOV_FLUSH4(id));
-				errdata.flush[5] = readl(DMOV_FLUSH5(id));
-
+				msm_dmov_fill_errdata(&errdata, ch, adm);
 				PRINT_ERROR("msm_datamover_irq_handler id %d, status %x\n", id, ch_status);
 				PRINT_ERROR("msm_datamover_irq_handler id %d, error, result %x, flush0 %x\n", id, ch_result, errdata.flush[0]);
 				if (cmd) {
@@ -288,101 +330,133 @@ static irqreturn_t msm_datamover_irq_handler(int irq, void *dev_id)
 				}
 				/* this does not seem to work, once we get an error */
 				/* the datamover will no longer accept commands */
-				writel(0, DMOV_FLUSH0(id));
+				dmov_writel(0, DMOV_FLUSH0(ch), adm);
 			}
-			ch_status = readl(DMOV_STATUS(id));
+			ch_status = dmov_readl(DMOV_STATUS(ch), adm);
 			PRINT_FLOW("msm_datamover_irq_handler id %d, status %x\n", id, ch_status);
-			if ((ch_status & DMOV_STATUS_CMD_PTR_RDY) && !list_empty(&ready_commands[id])) {
-				cmd = list_entry(ready_commands[id].next, typeof(*cmd), list);
+			if ((ch_status & DMOV_STATUS_CMD_PTR_RDY) &&
+			    !list_empty(&dmov_conf[adm].ready_commands[ch])) {
+				cmd = list_entry(dmov_conf[adm].
+					ready_commands[ch].next, typeof(*cmd),
+					list);
 				list_del(&cmd->list);
-				list_add_tail(&cmd->list, &active_commands[id]);
+				list_add_tail(&cmd->list, &dmov_conf[adm].
+					      active_commands[ch]);
 				if (cmd->execute_func)
 					cmd->execute_func(cmd);
 				PRINT_FLOW("msm_datamover_irq_handler id %d, start command\n", id);
-				writel(cmd->cmdptr, DMOV_CMD_PTR(id));
+				dmov_writel(cmd->cmdptr, DMOV_CMD_PTR(ch), adm);
 			}
 		} while (ch_status & DMOV_STATUS_RSLT_VALID);
-		if (list_empty(&active_commands[id]) && list_empty(&ready_commands[id]))
-			channel_active &= ~(1U << id);
+		if (list_empty(&dmov_conf[adm].active_commands[ch]) &&
+				list_empty(&dmov_conf[adm].ready_commands[ch]))
+			dmov_conf[adm].channel_active &= ~(1U << ch);
 		PRINT_FLOW("msm_datamover_irq_handler id %d, status %x\n", id, ch_status);
 	}
 
-	if (!channel_active) {
-		disable_irq_nosync(msm_dmov_irq);
-		msm_dmov_clocks_off();
+	if (!dmov_conf[adm].channel_active) {
+		disable_irq_nosync(dmov_conf[adm].irq);
+		msm_dmov_clocks_off(adm);
 	}
 
-	spin_unlock_irqrestore(&msm_dmov_lock, irq_flags);
+	spin_unlock_irqrestore(&dmov_conf[adm].lock, irq_flags);
 	return IRQ_HANDLED;
 }
 
-static void __init msm_dmov_deinit_clocks(void)
+static void __init msm_dmov_deinit_clocks(int adm)
 {
-	if (!IS_ERR(msm_dmov_clk))
-		clk_put(msm_dmov_clk);
-	if (!IS_ERR(msm_dmov_pclk))
-		clk_put(msm_dmov_pclk);
+	if (!IS_ERR(dmov_conf[adm].clk))
+		clk_put(dmov_conf[adm].clk);
+	if (!IS_ERR(dmov_conf[adm].pclk))
+		clk_put(dmov_conf[adm].pclk);
 }
 
+#define PDEV_TO_ADM(pdev) \
+({ \
+	typeof(pdev) _pdev = pdev; \
+	(_pdev->id == -1) ? 0 : _pdev->id; \
+})
+
 static int __devinit msm_dmov_init_clocks(struct platform_device *pdev)
 {
 	int ret = 0;
+	int adm = PDEV_TO_ADM(pdev);
 
-	msm_dmov_clk = clk_get(&pdev->dev, "adm_clk");
-	if (IS_ERR(msm_dmov_clk)) {
+	dmov_conf[adm].clk = clk_get(&pdev->dev, "adm_clk");
+	if (IS_ERR(dmov_conf[adm].clk)) {
 		PRINT_ERROR("%s: Error getting adm_clk\n", __func__);
-		ret = PTR_ERR(msm_dmov_clk);
+		ret = PTR_ERR(dmov_conf[adm].clk);
 	}
 
-	msm_dmov_pclk = clk_get(&pdev->dev, "adm_pclk");
+	dmov_conf[adm].pclk = clk_get(&pdev->dev, "adm_pclk");
 	/* pclk not present on all SoCs, don't return error on failure */
 
 	return ret;
 }
 
-static int __devinit msm_dmov_probe(struct platform_device *pdev)
+static int __devinit msm_dmov_conf_init(struct platform_device *pdev)
 {
 	int i;
-	int ret;
-	struct resource *res;
+	int adm = PDEV_TO_ADM(pdev);
+	struct resource *irqres =
+		platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	struct resource *memres =
+		platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	if (!irqres || !memres || !irqres->start)
+		return -EINVAL;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENXIO;
+	dmov_conf[adm].irq = irqres->start;
 
-	msm_dmov_base = ioremap_nocache(res->start, resource_size(res));
-	if (!msm_dmov_base)
+	dmov_conf[adm].base =
+		ioremap_nocache(memres->start, resource_size(memres));
+	if (!dmov_conf[adm].base)
 		return -ENOMEM;
 
+	dmov_conf[adm].lock = __SPIN_LOCK_UNLOCKED(dmov_lock);
 	for (i = 0; i < MSM_DMOV_CHANNEL_COUNT; i++) {
-		INIT_LIST_HEAD(&ready_commands[i]);
-		INIT_LIST_HEAD(&active_commands[i]);
-		writel(DMOV_CONFIG_IRQ_EN | DMOV_CONFIG_FORCE_TOP_PTR_RSLT |
-		       DMOV_CONFIG_FORCE_FLUSH_RSLT, DMOV_CONFIG(i));
+		INIT_LIST_HEAD(&dmov_conf[adm].ready_commands[i]);
+		INIT_LIST_HEAD(&dmov_conf[adm].active_commands[i]);
 	}
+	return 0;
+}
 
-	ret = msm_dmov_init_clocks(pdev);
+static inline void __devinit msm_dmov_conf_free(int adm)
+{
+	iounmap(dmov_conf[adm].base);
+}
+
+static int __devinit msm_dmov_probe(struct platform_device *pdev)
+{
+	int i;
+	int ret;
+	int adm = PDEV_TO_ADM(pdev);
+
+	ret = msm_dmov_conf_init(pdev);
 	if (ret)
-		goto out_map;
+		return ret;
 
-	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (!res) {
-		ret = -EINVAL;
-		goto out_clock;
-	}
+	for (i = 0; i < MSM_DMOV_CHANNEL_COUNT; i++)
+		dmov_writel(DMOV_CONFIG_IRQ_EN | DMOV_CONFIG_FORCE_TOP_PTR_RSLT
+			  | DMOV_CONFIG_FORCE_FLUSH_RSLT, DMOV_CONFIG(i), adm);
 
-	msm_dmov_irq = res->start;
-	ret = request_irq(msm_dmov_irq, msm_datamover_irq_handler, 0,
+	ret = msm_dmov_init_clocks(pdev);
+	if (ret)
+		goto out_conf;
+
+	ret = request_irq(dmov_conf[adm].irq, msm_datamover_irq_handler, 0,
 			  "msmdatamover", NULL);
 	if (ret)
 		goto out_clock;
-	disable_irq(msm_dmov_irq);
+	disable_irq(dmov_conf[adm].irq);
+	nr_adms++;
 
 	return 0;
+
 out_clock:
-	msm_dmov_deinit_clocks();
-out_map:
-	iounmap(msm_dmov_base);
+	msm_dmov_deinit_clocks(adm);
+out_conf:
+	msm_dmov_conf_free(adm);
 	return ret;
 }
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

