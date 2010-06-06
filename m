Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab0FFV3K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 17:29:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:49507 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab0FFV3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 17:29:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fGgpiSH/GFwoD5aB3MGj+9ZpCWHUs6ucke61ohKl8zMAt16Ttu7E/f6XjIKusR2qaE
         TqhJTVu4Rk/lu9Lgwi85s80x37sUUL0dH24ts3vnYn/kZ//lBrHfMk340Nac86DkHK/a
         kuTlJDAW16ltc0K1ewuIup0cy4aiTv19caA9s=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: " linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Cc: Philip Langdale <philipl@overt.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 2/2] mmc: fix mmc card disappearence on resume on ricoh mmc controllers
Date: Mon,  7 Jun 2010 00:28:51 +0300
Message-Id: <1275859731-2898-2-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275859475.3151.4.camel@maxim-laptop>
References: <1275859475.3151.4.camel@maxim-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reason was that it takes time for controller to detect the card.
So wait a bit for the card to appear.
In worst case scenario, when you suspend the system with mmc card,
and actually remove it, the resume will be delayed maximum by 2 seconds

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mmc/host/sdhci-pci.c |    3 ++-
 drivers/mmc/host/sdhci.c     |   18 ++++++++++++++++++
 drivers/mmc/host/sdhci.h     |    2 ++
 3 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index c4bcaeb..49d863c 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -115,7 +115,8 @@ static const struct sdhci_pci_fixes sdhci_ricoh_mmc = {
 	.quirks		= SDHCI_QUIRK_32BIT_DMA_ADDR |
 			  SDHCI_QUIRK_CLOCK_BEFORE_RESET |
 			  SDHCI_QUIRK_NO_CARD_NO_RESET |
-			  SDHCI_QUIRK_MISSING_CAPS
+			  SDHCI_QUIRK_MISSING_CAPS |
+			  SDHCI_QUIRK_WAIT_CARD_ON_RESUME
 };
 
 static const struct sdhci_pci_fixes sdhci_ene_712 = {
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 483b78e..6cda505 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1612,6 +1612,24 @@ int sdhci_resume_host(struct sdhci_host *host)
 {
 	int ret;
 
+	/* Some controllers (especialy the ricoh mmc controller) delay
+		card detection on resume (probably since the controller
+		has to poke the card to determine if its MMC or not */
+
+	if (host->mmc->bus_ops && (host->quirks &
+			SDHCI_QUIRK_WAIT_CARD_ON_RESUME)) {
+
+		unsigned long timeout = jiffies + msecs_to_jiffies(2000);
+
+		while (!time_after(jiffies, timeout))
+			if (sdhci_readl(host, SDHCI_PRESENT_STATE)
+							& SDHCI_CARD_PRESENT) {
+				break;
+			}
+			cpu_relax();
+	}
+
+
 	if (host->flags & (SDHCI_USE_SDMA | SDHCI_USE_ADMA)) {
 		if (host->ops->enable_dma)
 			host->ops->enable_dma(host);
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index b1839a3..c9d099c 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -242,6 +242,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC		(1<<26)
 /* Controller is missing device caps. Use caps provided by host */
 #define SDHCI_QUIRK_MISSING_CAPS			(1<<27)
+/* Card doesn't appear immediatly on resume from low power state */
+#define SDHCI_QUIRK_WAIT_CARD_ON_RESUME			(1<<28)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
-- 
1.7.0.4

