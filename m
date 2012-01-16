Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab2APLdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 06:33:22 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53056 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754297Ab2APLdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 06:33:17 -0500
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-mmc@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Shubhrajyoti D <shubhrajyoti@ti.com>,
        Denis Karpov <ext-denis.2.karpov@nokia.com>
Subject: [PATCH RFC] mmc : omap_hsmmc : Save and restore the sysc across reset
Date: Mon, 16 Jan 2012 17:03:07 +0530
Message-ID: <1326713587-26463-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 11dd62:[omap_hsmmc: context save/restore support]

does a reset and restores AUTOIDLE settings.
This patch saves the register does a reset and restores
the same configuration.

Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
Untested
 drivers/mmc/host/omap_hsmmc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index fd0c661..175029d 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -680,7 +680,7 @@ static int omap_hsmmc_context_restore(struct omap_hsmmc_host *host)
 	struct mmc_ios *ios = &host->mmc->ios;
 	struct omap_mmc_platform_data *pdata = host->pdata;
 	int context_loss = 0;
-	u32 hctl, capa;
+	u32 hctl, capa, sysc;
 	unsigned long timeout;
 
 	if (pdata->get_context_loss_count) {
@@ -700,6 +700,7 @@ static int omap_hsmmc_context_restore(struct omap_hsmmc_host *host)
 		&& time_before(jiffies, timeout))
 		;
 
+	sysc = OMAP_HSMMC_READ(host->base, SYSCONFIG);
 	/* Do software reset */
 	OMAP_HSMMC_WRITE(host->base, SYSCONFIG, SOFTRESET);
 	timeout = jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
@@ -707,8 +708,7 @@ static int omap_hsmmc_context_restore(struct omap_hsmmc_host *host)
 		&& time_before(jiffies, timeout))
 		;
 
-	OMAP_HSMMC_WRITE(host->base, SYSCONFIG,
-			OMAP_HSMMC_READ(host->base, SYSCONFIG) | AUTOIDLE);
+	OMAP_HSMMC_WRITE(host->base, SYSCONFIG, sysc);
 
 	if (host->id == OMAP_MMC1_DEVID) {
 		if (host->power_mode != MMC_POWER_OFF &&
-- 
1.7.1

