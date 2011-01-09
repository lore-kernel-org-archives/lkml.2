Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab1AIQa3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 11:30:29 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54866 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab1AIQa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 11:30:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=K9AGwERMTqBEG6WtTQzgeAErp5IhMwGk7kE00tISv5Ie2YqHYObF/C6SwWZaVEolee
         uKlkETFXyiQEvyv0uU92nBLAXMX8wu1Ido0Wyg1F6tl/NzjfIIK9zyavMHVg6UXKttSM
         FiED0R4WnYeRIZLPreC75atnE2zKQJQdY6Nys=
From: Pierre Tardy <tardyp@gmail.com>
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Pierre Tardy <tardyp@gmail.com>
Subject: [PATCH 2/3] mmc: add MMC_QUIRK_BROKEN_CLK_GATING
Date: Sun,  9 Jan 2011 17:26:19 +0100
Message-Id: <4663ceeebbd267abb11515570ac17702a6a482f4.1294588491.git.tardyp@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1294588491.git.tardyp@gmail.com>
References: <cover.1294588491.git.tardyp@gmail.com>
In-Reply-To: <cover.1294588491.git.tardyp@gmail.com>
References: <cover.1294588491.git.tardyp@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some sdio card are not following sdio standard, and does not work
when the sdio bus's clock is gated

To keep functionnality for all legacy driver, we turn this quirk on
for every sdio card.
Drivers needs to disable the quirk manually when someone verified that their
supported card works with clock gating.

Signed-off-by: Pierre Tardy <tardyp@gmail.com>
---
 drivers/mmc/core/host.c   |    5 +----
 drivers/mmc/core/quirks.c |   11 +++++++++++
 include/linux/mmc/card.h  |    1 +
 3 files changed, 13 insertions(+), 4 deletions(-)

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
index d8a5fec..fe467c8 100644
--- a/drivers/mmc/core/quirks.c
+++ b/drivers/mmc/core/quirks.c
@@ -32,7 +32,18 @@ static void add_quirk(struct mmc_card *card, int data)
 	card->quirks |= data;
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
+	{ SDIO_ANY_ID, SDIO_ANY_ID,
+		add_quirk_for_sdio_devices, MMC_QUIRK_BROKEN_CLK_GATING }
 	{ 0 }
 };
 
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index a498d53..3fe9db0 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -121,6 +121,7 @@ struct mmc_card {
 						/* for byte mode */
 #define MMC_QUIRK_NONSTD_SDIO	(1<<2)		/* non-standard SDIO card attached */
 						/* (missing CIA registers) */
+#define MMC_QUIRK_BROKEN_CLK_GATING (1<<3)	/* clock gating the sdio bus will make card fail */
 
 	unsigned int		erase_size;	/* erase size in sectors */
  	unsigned int		erase_shift;	/* if erase unit is power 2 */
-- 
1.7.1

