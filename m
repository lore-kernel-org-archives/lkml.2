Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab1ABVMJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 16:12:09 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33985 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab1ABVMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 16:12:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iqvFzgba2bUh9dSJ0BV/cykJQm3+Hl5/lB2u6RAYCDwkCLaIPYisOCrL9eRK9Kxyz9
         TWskVyddCcYqaEAsLcitK0xUGFuYntu6MRyKUQYs791KwFXxGIqA4WmVcyR1Ok5FTjKv
         q0DPPQCDFy5QlKZBdhcMVTXwhKm/Fm1Fs3XHI=
From: Pierre Tardy <tardyp@gmail.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>,
        "Gao, Yunpeng" <yunpeng.gao@intel.com>,
        Pierre Tardy <tardyp@gmail.com>, "Yuan, Hang" <hang.yuan@intel.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Takashi Iwai <tiwai@suse.de>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Cc: Pierre Tardy <tardyp@gmail.com>
Subject: [PATCH] mmc: add MMC_QUIRK_BROKEN_CLK_GATING
Date: Sun,  2 Jan 2011 22:08:30 +0100
Message-Id: <1294002510-2324-1-git-send-email-tardyp@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <AANLkTin7OYXzCYty8pDxyzE_Bg83=+L8jmcaoEMSf4QM@mail.gmail.com>
References: <AANLkTin7OYXzCYty8pDxyzE_Bg83=+L8jmcaoEMSf4QM@mail.gmail.com>
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
 drivers/mmc/core/host.c  |    5 +----
 drivers/mmc/core/sdio.c  |    6 ++++++
 include/linux/mmc/card.h |    1 +
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 92e3370..54cc461 100644
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
diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 82f4b90..6df1ead 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -785,6 +785,12 @@ int mmc_attach_sdio(struct mmc_host *host, u32 ocr)
 
 	mmc_release_host(host);
 
+        /*
+         * see comments in mmc_host_may_gate_card()
+         * this can be overidden by function drivers if they know that
+         * their sdio card works with clock gating
+         */
+        card->quirks |= MMC_QUIRK_BROKEN_CLK_GATING;
 	/*
 	 * First add the card to the driver model...
 	 */
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 8ce0827..5071eb1 100644
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

