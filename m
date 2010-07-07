Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab0GGLSu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 07:18:50 -0400
Received: from smtp.nokia.com ([192.100.105.134]:40691 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab0GGLSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 07:18:37 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Hunter <adrian.hunter@nokia.com>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kyungmin Park <kmpark@infradead.org>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       linux-mmc Mailing List <linux-mmc@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Date: Wed, 07 Jul 2010 14:17:41 +0300
Message-Id: <20100707111741.24979.38696.sendpatchset@ahunter-work.research.nokia.com>
In-Reply-To: <20100707111716.24979.68940.sendpatchset@ahunter-work.research.nokia.com>
References: <20100707111716.24979.68940.sendpatchset@ahunter-work.research.nokia.com>
Subject: [PATCH V4 3/5] omap_hsmmc: Add erase capability
X-OriginalArrivalTime: 07 Jul 2010 11:17:47.0408 (UTC) FILETIME=[07574100:01CB1DC6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From db31a11109e7f0c89a7a9ca70ad03beff354aa8e Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Tue, 18 May 2010 17:33:13 +0300
Subject: [PATCH 3/5] omap_hsmmc: Add erase capability

Disable the data (busy) timeout for erases and set the
MMC_CAP_ERASE capability.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/host/omap_hsmmc.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index a0c8515..868498d 100644
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
 
 	switch (mmc_slot(host).wires) {
 	case 8:
-- 
1.6.3.3

