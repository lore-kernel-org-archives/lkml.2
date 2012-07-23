Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab2GWRCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 13:02:44 -0400
Received: from mail-bk0-f74.google.com ([209.85.214.74]:56543 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab2GWRCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 13:02:43 -0400
From: Doug Anderson <dianders@chromium.org>
To: linux-mmc@vger.kernel.org
Cc: Chris Ball <cjb@laptop.org>, Will Newton <will.newton@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, linux-kernel@vger.kernel.org,
        Grant Grundler <grundler@chromium.org>,
        Olof Johansson <olofj@chromium.org>, shashidharh@vayavyalabs.com,
        ki0351.kim@samsung.com, Doug Anderson <dianders@chromium.org>
Subject: [PATCH v2] mmc: dw_mmc: Disable low power mode if SDIO interrupts are used
Date: Mon, 23 Jul 2012 10:02:35 -0700
Message-Id: <1343062955-24516-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <CAD=FV=XuXUe1Jyd_urCzmS5+1vv7iuNTXYr23XYZp+MnTq1HGg@mail.gmail.com>
References: <CAD=FV=XuXUe1Jyd_urCzmS5+1vv7iuNTXYr23XYZp+MnTq1HGg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation for the dw_mmc part says that the low power
mode should normally only be set for MMC and SD memory and should
be turned off for SDIO cards that need interrupts detected.

The best place I could find to do this is when the SDIO interrupt
was first enabled.  I rely on the fact that dw_mci_setup_bus()
will be called when it's time to reenable.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v2:
- Commenting fixes requested by Grant Grundler.
- Be extra certain that we don't re-turn on the low power mode in
  CLKENA in dw_mci_setup_bus() if SDIO interrupts are enabled.
  There are no known instances of this happening but it's good to be safe.

 drivers/mmc/host/dw_mmc.c |   43 ++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 72dc3cd..0ab1771 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -627,6 +627,7 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot)
 {
 	struct dw_mci *host = slot->host;
 	u32 div;
+	u32 clk_en_a;
 
 	if (slot->clock != host->current_speed) {
 		div = host->bus_hz / slot->clock;
@@ -659,9 +660,11 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot)
 		mci_send_cmd(slot,
 			     SDMMC_CMD_UPD_CLK | SDMMC_CMD_PRV_DAT_WAIT, 0);
 
-		/* enable clock */
-		mci_writel(host, CLKENA, ((SDMMC_CLKEN_ENABLE |
-			   SDMMC_CLKEN_LOW_PWR) << slot->id));
+		/* enable clock; only low power if no SDIO */
+		clk_en_a = SDMMC_CLKEN_ENABLE << slot->id;
+		if (!(mci_readl(host, INTMASK) & SDMMC_INT_SDIO(slot->id)))
+			clk_en_a |= SDMMC_CLKEN_LOW_PWR << slot->id;
+		mci_writel(host, CLKENA, clk_en_a);
 
 		/* inform CIU */
 		mci_send_cmd(slot,
@@ -862,6 +865,32 @@ static int dw_mci_get_cd(struct mmc_host *mmc)
 	return present;
 }
 
+/*
+ * Disable lower power mode.
+ *
+ * Low power mode will stop the card clock when idle.  According to
+ * documentation (Exynos 5250 User's Manual 0.04, description of
+ * CLKENA register) we should disable low power mode for SDIO cards
+ * if we need interrupts to work.
+ *
+ * This function is fast if the power mode is already disabled.
+ */
+static void dw_mci_disable_low_power(struct mmc_host *mmc)
+{
+	struct dw_mci_slot *slot = mmc_priv(mmc);
+	struct dw_mci *host = slot->host;
+	u32 clk_en_a;
+	const u32 clken_low_pwr = SDMMC_CLKEN_LOW_PWR << slot->id;
+
+	clk_en_a = mci_readl(host, CLKENA);
+
+	if (clk_en_a & clken_low_pwr) {
+		mci_writel(host, CLKENA, clk_en_a & ~clken_low_pwr);
+		mci_send_cmd(slot, SDMMC_CMD_UPD_CLK |
+			     SDMMC_CMD_PRV_DAT_WAIT, 0);
+	}
+}
+
 static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
 {
 	struct dw_mci_slot *slot = mmc_priv(mmc);
@@ -871,6 +900,14 @@ static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
 	/* Enable/disable Slot Specific SDIO interrupt */
 	int_mask = mci_readl(host, INTMASK);
 	if (enb) {
+		/*
+		 * Turn off low power mode if it was enabled.  This is a bit of
+		 * a heavy operation and we disable / enable IRQs a lot, so
+		 * we'll leave low power mode disabled and it will get
+		 * re-enabled again in dw_mci_setup_bus().
+		 */
+		dw_mci_disable_low_power(mmc);
+
 		mci_writel(host, INTMASK,
 			   (int_mask | SDMMC_INT_SDIO(slot->id)));
 	} else {
-- 
1.7.7.3

