Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab0FCVOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 17:14:17 -0400
Received: from smtp.nokia.com ([192.100.122.230]:52743 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab0FCVON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 17:14:13 -0400
Message-ID: <4C081AFF.1050306@nokia.com>
Date: Fri, 04 Jun 2010 00:13:35 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Madhusudhan Chikkature <madhu.cr@ti.com>, Tony Lindgren <tony@atomide.com>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] omap_hsmmc: Add erase capability
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jun 2010 21:13:36.0262 (UTC) FILETIME=[A145FA60:01CB0361]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8aa6d3d17e2a0d768163072e3f919e03162a2df9 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Tue, 18 May 2010 17:33:13 +0300
Subject: [PATCH 4/4] omap_hsmmc: Add erase capability

Disable the data (busy) timeout for erases and set the
MMC_CAP_ERASE capability.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/host/omap_hsmmc.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index b032828..5cbbe09 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -28,6 +28,7 @@
 #include <linux/clk.h>
 #include <linux/mmc/host.h>
 #include <linux/mmc/core.h>
+#include <linux/mmc/mmc.h>
 #include <linux/io.h>
 #include <linux/semaphore.h>
 #include <linux/gpio.h>
@@ -78,6 +79,7 @@
 #define INT_EN_MASK		0x307F0033
 #define BWR_ENABLE		(1 << 4)
 #define BRR_ENABLE		(1 << 5)
+#define DTO_ENABLE		(1 << 20)
 #define INIT_STREAM		(1 << 1)
 #define DP_SELECT		(1 << 21)
 #define DDIR			(1 << 4)
@@ -523,7 +525,8 @@ static void omap_hsmmc_stop_clock(struct omap_hsmmc_host *host)
 		dev_dbg(mmc_dev(host->mmc), "MMC Clock is not stoped\n");
 }
 
-static void omap_hsmmc_enable_irq(struct omap_hsmmc_host *host)
+static void omap_hsmmc_enable_irq(struct omap_hsmmc_host *host,
+				  struct mmc_command *cmd)
 {
 	unsigned int irq_mask;
 
@@ -532,6 +535,10 @@ static void omap_hsmmc_enable_irq(struct omap_hsmmc_host *host)
 	else
 		irq_mask = INT_EN_MASK;
 
+	/* Disable timeout for erases */
+	if (cmd->opcode == MMC_ERASE)
+		irq_mask &= ~DTO_ENABLE;
+
 	OMAP_HSMMC_WRITE(host->base, STAT, STAT_CLEAR);
 	OMAP_HSMMC_WRITE(host->base, ISE, irq_mask);
 	OMAP_HSMMC_WRITE(host->base, IE, irq_mask);
@@ -782,7 +789,7 @@ omap_hsmmc_start_command(struct omap_hsmmc_host *host, struct mmc_command *cmd,
 		mmc_hostname(host->mmc), cmd->opcode, cmd->arg);
 	host->cmd = cmd;
 
-	omap_hsmmc_enable_irq(host);
+	omap_hsmmc_enable_irq(host, cmd);
 
 	host->response_busy = 0;
 	if (cmd->flags & MMC_RSP_PRESENT) {
@@ -2094,7 +2101,7 @@ static int __init omap_hsmmc_probe(struct platform_device *pdev)
 	mmc->max_seg_size = mmc->max_req_size;
 
 	mmc->caps |= MMC_CAP_MMC_HIGHSPEED | MMC_CAP_SD_HIGHSPEED |
-		     MMC_CAP_WAIT_WHILE_BUSY;
+		     MMC_CAP_WAIT_WHILE_BUSY | MMC_CAP_ERASE;
 
 	if (mmc_slot(host).wires >= 8)
 		mmc->caps |= MMC_CAP_8_BIT_DATA;
-- 
1.6.3.3
