Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab0LGH5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 02:57:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49561 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455Ab0LGH5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 02:57:03 -0500
From: Takashi Iwai <tiwai@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Dubov <oakad@yahoo.com>,
        Aries Lee <arieslee@jmicron.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 1/3] memstick: Fix setup for JMicron 38x controllers
Date: Tue,  7 Dec 2010 08:56:37 +0100
Message-Id: <1291708599-28026-2-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1291708599-28026-1-git-send-email-tiwai@suse.de>
References: <1291708599-28026-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch corrects the definition of clock values for JMicron 38x
controllers and sets the value properly per interface type.
Also, it adds a check for TPC errors in the interrupt handler.

Signed-off-by: Aries Lee <arieslee@jmicron.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/memstick/host/jmb38x_ms.c |   66 ++++++++++++++++++++-----------------
 1 files changed, 36 insertions(+), 30 deletions(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index f2b894c..c90ba50 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -61,6 +61,7 @@ struct jmb38x_ms_host {
 	struct memstick_request *req;
 	unsigned char           cmd_flags;
 	unsigned char           io_pos;
+	unsigned char           ifmode;
 	unsigned int            io_word[2];
 };
 
@@ -136,15 +137,14 @@ struct jmb38x_ms {
 #define PAD_PU_PD_ON_MS_SOCK0 0x5f8f0000
 #define PAD_PU_PD_ON_MS_SOCK1 0x0f0f0000
 
+#define CLOCK_CONTROL_BY_MMIO 0x00000008
 #define CLOCK_CONTROL_40MHZ   0x00000001
-#define CLOCK_CONTROL_50MHZ   0x0000000a
-#define CLOCK_CONTROL_60MHZ   0x00000008
-#define CLOCK_CONTROL_62_5MHZ 0x0000000c
+#define CLOCK_CONTROL_50MHZ   0x00000002
+#define CLOCK_CONTROL_60MHZ   0x00000010
+#define CLOCK_CONTROL_62_5MHZ 0x00000004
 #define CLOCK_CONTROL_OFF     0x00000000
 
 #define PCI_CTL_CLOCK_DLY_ADDR   0x000000b0
-#define PCI_CTL_CLOCK_DLY_MASK_A 0x00000f00
-#define PCI_CTL_CLOCK_DLY_MASK_B 0x0000f000
 
 enum {
 	CMD_READY    = 0x01,
@@ -390,8 +390,13 @@ static int jmb38x_ms_issue_cmd(struct memstick_host *msh)
 
 	if (host->req->data_dir == READ)
 		cmd |= TPC_DIR;
-	if (host->req->need_card_int)
-		cmd |= TPC_WAIT_INT;
+
+	if (host->req->need_card_int) {
+		if (host->ifmode == MEMSTICK_SERIAL)
+			cmd |= TPC_GET_INT;
+		else
+			cmd |= TPC_WAIT_INT;
+	}
 
 	data = host->req->data;
 
@@ -529,7 +534,10 @@ static irqreturn_t jmb38x_ms_isr(int irq, void *dev_id)
 		if (irq_status & INT_STATUS_ANY_ERR) {
 			if (irq_status & INT_STATUS_CRC_ERR)
 				host->req->error = -EILSEQ;
-			else
+			else if (irq_status & INT_STATUS_TPC_ERR) {
+				dev_dbg(&host->chip->pdev->dev, "TPC_ERR\n");
+				jmb38x_ms_complete_cmd(msh, 0);
+			} else
 				host->req->error = -ETIME;
 		} else {
 			if (host->cmd_flags & DMA_DATA) {
@@ -644,7 +652,6 @@ static int jmb38x_ms_reset(struct jmb38x_ms_host *host)
 		ndelay(20);
 	}
 	dev_dbg(&host->chip->pdev->dev, "reset_req timeout\n");
-	/* return -EIO; */
 
 reset_next:
 	writel(HOST_CONTROL_RESET | HOST_CONTROL_CLOCK_EN
@@ -675,7 +682,7 @@ static int jmb38x_ms_set_param(struct memstick_host *msh,
 {
 	struct jmb38x_ms_host *host = memstick_priv(msh);
 	unsigned int host_ctl = readl(host->addr + HOST_CONTROL);
-	unsigned int clock_ctl = CLOCK_CONTROL_40MHZ, clock_delay = 0;
+	unsigned int clock_ctl = CLOCK_CONTROL_BY_MMIO, clock_delay = 0;
 	int rc = 0;
 
 	switch (param) {
@@ -687,9 +694,7 @@ static int jmb38x_ms_set_param(struct memstick_host *msh,
 
 			host_ctl = 7;
 			host_ctl |= HOST_CONTROL_POWER_EN
-				    | HOST_CONTROL_CLOCK_EN
-				    | HOST_CONTROL_HW_OC_P
-				    | HOST_CONTROL_TDELAY_EN;
+				 | HOST_CONTROL_CLOCK_EN;
 			writel(host_ctl, host->addr + HOST_CONTROL);
 
 			writel(host->id ? PAD_PU_PD_ON_MS_SOCK1
@@ -712,41 +717,42 @@ static int jmb38x_ms_set_param(struct memstick_host *msh,
 			return -EINVAL;
 		break;
 	case MEMSTICK_INTERFACE:
+		dev_dbg(&host->chip->pdev->dev,
+			"Set Host Interface Mode to %d\n", value);
+		host_ctl &= ~(HOST_CONTROL_FAST_CLK | HOST_CONTROL_REI |
+			      HOST_CONTROL_REO);
+		host_ctl |= HOST_CONTROL_TDELAY_EN | HOST_CONTROL_HW_OC_P;
 		host_ctl &= ~(3 << HOST_CONTROL_IF_SHIFT);
-		pci_read_config_dword(host->chip->pdev,
-				      PCI_CTL_CLOCK_DLY_ADDR,
-				      &clock_delay);
-		clock_delay &= host->id ? ~PCI_CTL_CLOCK_DLY_MASK_B
-					: ~PCI_CTL_CLOCK_DLY_MASK_A;
 
 		if (value == MEMSTICK_SERIAL) {
-			host_ctl &= ~HOST_CONTROL_FAST_CLK;
-			host_ctl &= ~HOST_CONTROL_REO;
 			host_ctl |= HOST_CONTROL_IF_SERIAL
 				    << HOST_CONTROL_IF_SHIFT;
 			host_ctl |= HOST_CONTROL_REI;
-			clock_ctl = CLOCK_CONTROL_40MHZ;
+			clock_ctl |= CLOCK_CONTROL_40MHZ;
+			clock_delay = 0;
 		} else if (value == MEMSTICK_PAR4) {
-			host_ctl |= HOST_CONTROL_FAST_CLK | HOST_CONTROL_REO;
+			host_ctl |= HOST_CONTROL_FAST_CLK;
 			host_ctl |= HOST_CONTROL_IF_PAR4
 				    << HOST_CONTROL_IF_SHIFT;
-			host_ctl &= ~HOST_CONTROL_REI;
-			clock_ctl = CLOCK_CONTROL_40MHZ;
-			clock_delay |= host->id ? (4 << 12) : (4 << 8);
+			host_ctl |= HOST_CONTROL_REO;
+			clock_ctl |= CLOCK_CONTROL_40MHZ;
+			clock_delay = 4;
 		} else if (value == MEMSTICK_PAR8) {
 			host_ctl |= HOST_CONTROL_FAST_CLK;
 			host_ctl |= HOST_CONTROL_IF_PAR8
 				    << HOST_CONTROL_IF_SHIFT;
-			host_ctl &= ~(HOST_CONTROL_REI | HOST_CONTROL_REO);
-			clock_ctl = CLOCK_CONTROL_50MHZ;
+			clock_ctl |= CLOCK_CONTROL_50MHZ;
+			clock_delay = 0;
 		} else
 			return -EINVAL;
 
 		writel(host_ctl, host->addr + HOST_CONTROL);
+		writel(CLOCK_CONTROL_OFF, host->addr + CLOCK_CONTROL);
 		writel(clock_ctl, host->addr + CLOCK_CONTROL);
-		pci_write_config_dword(host->chip->pdev,
-				       PCI_CTL_CLOCK_DLY_ADDR,
-				       clock_delay);
+		pci_write_config_byte(host->chip->pdev,
+				      PCI_CTL_CLOCK_DLY_ADDR + 1,
+				      clock_delay);
+		host->ifmode = value;
 		break;
 	};
 	return 0;
-- 
1.7.3.1

