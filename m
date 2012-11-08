Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab2KHNIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:08:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:7521 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755621Ab2KHND5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:03:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,737,1344236400"; 
   d="scan'208";a="244102230"
From: dragos.tatulea@intel.com
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, cjb@laptop.org
Cc: kirill.shutemov@linux.intel.com, irina.tirdea@intel.com,
        octavian.purdila@intel.com, tony.luck@intel.com, keescook@chromium.org,
        dragos.tatulea@gmail.com, Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v2 10/26] mmc: panic write: do not msleep
Date: Thu,  8 Nov 2012 15:06:08 +0200
Message-Id: <1352379984-18381-11-git-send-email-dragos.tatulea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352379984-18381-1-git-send-email-dragos.tatulea@intel.com>
References: <1352379984-18381-1-git-send-email-dragos.tatulea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 drivers/mmc/core/core.c     |    6 +++---
 drivers/mmc/core/core.h     |    6 ++++--
 drivers/mmc/core/mmc_ops.c  |   10 +++++-----
 drivers/mmc/core/sd_ops.c   |    2 +-
 drivers/mmc/core/sdio_ops.c |    2 +-
 5 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 0b904bc..204a9bd 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1331,7 +1331,7 @@ static void mmc_power_up(struct mmc_host *host)
 	 * This delay should be sufficient to allow the power supply
 	 * to reach the minimum voltage.
 	 */
-	mmc_delay(10);
+	mmc_delay(host, 10);
 
 	host->ios.clock = host->f_init;
 
@@ -1342,7 +1342,7 @@ static void mmc_power_up(struct mmc_host *host)
 	 * This delay must be at least 74 clock sizes, or 1 ms, or the
 	 * time required to reach a stable voltage.
 	 */
-	mmc_delay(10);
+	mmc_delay(host, 10);
 
 	mmc_host_clk_release(host);
 }
@@ -1378,7 +1378,7 @@ void mmc_power_off(struct mmc_host *host)
 	 * XO-1.5, require a short delay after poweroff before the card
 	 * can be successfully turned on again.
 	 */
-	mmc_delay(1);
+	mmc_delay(host, 1);
 
 	mmc_host_clk_release(host);
 }
diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
index 3bdafbc..4cba1f1 100644
--- a/drivers/mmc/core/core.h
+++ b/drivers/mmc/core/core.h
@@ -46,9 +46,11 @@ void mmc_set_timing(struct mmc_host *host, unsigned int timing);
 void mmc_set_driver_type(struct mmc_host *host, unsigned int drv_type);
 void mmc_power_off(struct mmc_host *host);
 
-static inline void mmc_delay(unsigned int ms)
+static inline void mmc_delay(struct mmc_host *host, unsigned int ms)
 {
-	if (ms < 1000 / HZ) {
+	if (mmc_am_panic_task(host)) {
+		mdelay(ms);
+	} else if (ms < 1000 / HZ) {
 		cond_resched();
 		mdelay(ms);
 	} else {
diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index a0e1720..23eaeab 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -83,7 +83,7 @@ int mmc_card_sleepawake(struct mmc_host *host, int sleep)
 	 * others) is invalid while the card sleeps.
 	 */
 	if (!(host->caps & MMC_CAP_WAIT_WHILE_BUSY))
-		mmc_delay(DIV_ROUND_UP(card->ext_csd.sa_timeout, 10000));
+		mmc_delay(host, DIV_ROUND_UP(card->ext_csd.sa_timeout, 10000));
 
 	if (!sleep)
 		err = mmc_select_card(card);
@@ -107,7 +107,7 @@ int mmc_go_idle(struct mmc_host *host)
 	 */
 	if (!mmc_host_is_spi(host)) {
 		mmc_set_chip_select(host, MMC_CS_HIGH);
-		mmc_delay(1);
+		mmc_delay(host, 1);
 	}
 
 	cmd.opcode = MMC_GO_IDLE_STATE;
@@ -116,11 +116,11 @@ int mmc_go_idle(struct mmc_host *host)
 
 	err = mmc_wait_for_cmd(host, &cmd, 0);
 
-	mmc_delay(1);
+	mmc_delay(host, 1);
 
 	if (!mmc_host_is_spi(host)) {
 		mmc_set_chip_select(host, MMC_CS_DONTCARE);
-		mmc_delay(1);
+		mmc_delay(host, 1);
 	}
 
 	host->use_spi_crc = 0;
@@ -159,7 +159,7 @@ int mmc_send_op_cond(struct mmc_host *host, u32 ocr, u32 *rocr)
 
 		err = -ETIMEDOUT;
 
-		mmc_delay(10);
+		mmc_delay(host, 10);
 	}
 
 	if (rocr && !mmc_host_is_spi(host))
diff --git a/drivers/mmc/core/sd_ops.c b/drivers/mmc/core/sd_ops.c
index 274ef00..d4573fb 100644
--- a/drivers/mmc/core/sd_ops.c
+++ b/drivers/mmc/core/sd_ops.c
@@ -181,7 +181,7 @@ int mmc_send_app_op_cond(struct mmc_host *host, u32 ocr, u32 *rocr)
 
 		err = -ETIMEDOUT;
 
-		mmc_delay(10);
+		mmc_delay(host, 10);
 	}
 
 	if (rocr && !mmc_host_is_spi(host))
diff --git a/drivers/mmc/core/sdio_ops.c b/drivers/mmc/core/sdio_ops.c
index d29e206..099908c 100644
--- a/drivers/mmc/core/sdio_ops.c
+++ b/drivers/mmc/core/sdio_ops.c
@@ -56,7 +56,7 @@ int mmc_send_io_op_cond(struct mmc_host *host, u32 ocr, u32 *rocr)
 
 		err = -ETIMEDOUT;
 
-		mmc_delay(10);
+		mmc_delay(host, 10);
 	}
 
 	if (rocr)
-- 
1.7.9.5

