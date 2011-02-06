Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab1BFSEP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 13:04:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:55174 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524Ab1BFSEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 13:04:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,434,1291622400"; 
   d="scan'208";a="654942324"
From: Pierre Tardy <pierre.tardy@intel.com>
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Pierre Tardy <tardyp@gmail.com>
Subject: [PATCH v2 2/3] mmc: add MMC_QUIRK_BROKEN_CLK_GATING
Date: Sun,  6 Feb 2011 19:03:47 +0100
Message-Id: <b4058c575abc1831c8cf3e899a7b70267be9e6fe.1297014807.git.pierre.tardy@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1297014807.git.pierre.tardy@intel.com>
References: <cover.1297014807.git.pierre.tardy@intel.com>
In-Reply-To: <cover.1297014807.git.pierre.tardy@intel.com>
References: <cover.1297014807.git.pierre.tardy@intel.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pierre Tardy <tardyp@gmail.com>

Some sdio card are not following sdio standard, and does not work
when the sdio bus's clock is gated

To keep functionnality for all legacy driver, we turn this quirk on
for every sdio card.
Drivers needs to disable the quirk manually when someone verified that their
supported card works with clock gating.

Signed-off-by: Pierre Tardy <tardyp@gmail.com>
---
 drivers/mmc/core/host.c   |    5 +----
 drivers/mmc/core/quirks.c |   13 +++++++++++++
 include/linux/mmc/card.h  |    1 +
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index b3ac6c5..461e6a1 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -160,10 +160,7 @@ static bool mmc_host_may_gate_card(struct mmc_card *card)
 	 * gate the clock, because there is somebody out there that may still
 	 * be using it.
 	 */
-	if (mmc_card_sdio(card))
-		return false;
-
-	return true;
+	return !(card->quirks & MMC_QUIRK_BROKEN_CLK_GATING);
 }
 
 /**
diff --git a/drivers/mmc/core/quirks.c b/drivers/mmc/core/quirks.c
index aa811fc..d004106 100644
--- a/drivers/mmc/core/quirks.c
+++ b/drivers/mmc/core/quirks.c
@@ -40,7 +40,20 @@ static void __maybe_unused remove_quirk(struct mmc_card *card, int data)
 	card->quirks &= ~data;
 }
 
+/*
+ * This hook just adds a quirk for all sdio devices
+ */
+static void add_quirk_for_sdio_devices(struct mmc_card *card, int data)
+{
+	if (mmc_card_sdio(card))
+		card->quirks |= data;
+}
+
 static const struct mmc_fixup mmc_fixup_methods[] = {
+	/* by default sdio devices are considered CLK_GATING broken */
+	/* good cards will be whitelisted as they are tested */
+	{ SDIO_ANY_ID, SDIO_ANY_ID,
+		add_quirk_for_sdio_devices, MMC_QUIRK_BROKEN_CLK_GATING }
 	{ 0 }
 };
 
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index ad74138..adb4888 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -124,6 +124,7 @@ struct mmc_card {
 						/* for byte mode */
 #define MMC_QUIRK_NONSTD_SDIO	(1<<2)		/* non-standard SDIO card attached */
 						/* (missing CIA registers) */
+#define MMC_QUIRK_BROKEN_CLK_GATING (1<<3)	/* clock gating the sdio bus will make card fail */
 
 	unsigned int		erase_size;	/* erase size in sectors */
  	unsigned int		erase_shift;	/* if erase unit is power 2 */
-- 
1.7.2.3

---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

