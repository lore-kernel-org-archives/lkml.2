Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab0FFV3H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 17:29:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63597 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab0FFV3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 17:29:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GS77aJhXuzt4GyOebYHAjg1nnLcW7rZbq4OiW8b6kFxPP2w1qNC+tJFTA2Em6uaSOO
         t0QP/2HJvrJ1ISinDhBhgc2M51zZklKt5tgVHMQuh7mXXS1UvtXTu/MCpGqit7Sithdo
         xkd5JKqDMj+9XkHu63UQqya86fNgRIDISpEyI=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: " linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Cc: Philip Langdale <philipl@overt.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Andrew de Quincey <adq_dvb@lidskialf.net>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Subject: [PATCH 1/2] mmc: make sdhci work with ricoh mmc controller
Date: Mon,  7 Jun 2010 00:28:50 +0300
Message-Id: <1275859731-2898-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275859475.3151.4.camel@maxim-laptop>
References: <1275859475.3151.4.camel@maxim-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current way of disabling it is not well tested by vendor
and has all kinds of bugs that show up on resume from ram/disk.

Old way of disabling is still supported by
continuing to use CONFIG_MMC_RICOH_MMC.

Based on 'http://list.drzeus.cx/pipermail/sdhci-devel/2007-December/002085.html'
Most of the credit for this goes to Andrew de Quincey


Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Andrew de Quincey <adq_dvb@lidskialf.net>
CC: linux-mmc@vger.kernel.org <linux-mmc@vger.kernel.org>
---
 drivers/mmc/host/sdhci-pci.c |   31 +++++++++++++++++++++++++++++++
 drivers/mmc/host/sdhci.c     |    3 ++-
 drivers/mmc/host/sdhci.h     |    4 ++++
 3 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 65483fd..c4bcaeb 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -17,6 +17,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
+#include <linux/device.h>
 
 #include <linux/mmc/host.h>
 
@@ -84,7 +85,21 @@ static int ricoh_probe(struct sdhci_pci_chip *chip)
 	if (chip->pdev->subsystem_vendor == PCI_VENDOR_ID_SAMSUNG ||
 	    chip->pdev->subsystem_vendor == PCI_VENDOR_ID_SONY)
 		chip->quirks |= SDHCI_QUIRK_NO_CARD_NO_RESET;
+	return 0;
+}
+
+static int ricoh_mmc_probe_slot(struct sdhci_pci_slot *slot)
+{
+	slot->host->caps =
+		((0x21 << SDHCI_TIMEOUT_CLK_SHIFT)
+			& SDHCI_TIMEOUT_CLK_MASK) |
 
+		((0x21 << SDHCI_CLOCK_BASE_SHIFT)
+			& SDHCI_CLOCK_BASE_MASK) |
+
+		SDHCI_TIMEOUT_CLK_UNIT |
+		SDHCI_CAN_VDD_330 |
+		SDHCI_CAN_DO_SDMA;
 	return 0;
 }
 
@@ -95,6 +110,14 @@ static const struct sdhci_pci_fixes sdhci_ricoh = {
 			  SDHCI_QUIRK_CLOCK_BEFORE_RESET,
 };
 
+static const struct sdhci_pci_fixes sdhci_ricoh_mmc = {
+	.probe_slot	= ricoh_mmc_probe_slot,
+	.quirks		= SDHCI_QUIRK_32BIT_DMA_ADDR |
+			  SDHCI_QUIRK_CLOCK_BEFORE_RESET |
+			  SDHCI_QUIRK_NO_CARD_NO_RESET |
+			  SDHCI_QUIRK_MISSING_CAPS
+};
+
 static const struct sdhci_pci_fixes sdhci_ene_712 = {
 	.quirks		= SDHCI_QUIRK_SINGLE_POWER_WRITE |
 			  SDHCI_QUIRK_BROKEN_DMA,
@@ -374,6 +397,14 @@ static const struct pci_device_id pci_ids[] __devinitdata = {
 	},
 
 	{
+		.vendor         = PCI_VENDOR_ID_RICOH,
+		.device         = 0x843,
+		.subvendor      = PCI_ANY_ID,
+		.subdevice      = PCI_ANY_ID,
+		.driver_data    = (kernel_ulong_t)&sdhci_ricoh_mmc,
+	},
+
+	{
 		.vendor		= PCI_VENDOR_ID_ENE,
 		.device		= PCI_DEVICE_ID_ENE_CB712_SD,
 		.subvendor	= PCI_ANY_ID,
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index c6d1bd8..483b78e 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1687,7 +1687,8 @@ int sdhci_add_host(struct sdhci_host *host)
 			host->version);
 	}
 
-	caps = sdhci_readl(host, SDHCI_CAPABILITIES);
+	caps = (host->quirks & SDHCI_QUIRK_MISSING_CAPS) ? host->caps :
+		sdhci_readl(host, SDHCI_CAPABILITIES);
 
 	if (host->quirks & SDHCI_QUIRK_FORCE_DMA)
 		host->flags |= SDHCI_USE_SDMA;
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index c846813..b1839a3 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -240,6 +240,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN		(1<<25)
 /* Controller cannot support End Attribute in NOP ADMA descriptor */
 #define SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC		(1<<26)
+/* Controller is missing device caps. Use caps provided by host */
+#define SDHCI_QUIRK_MISSING_CAPS			(1<<27)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
@@ -292,6 +294,8 @@ struct sdhci_host {
 
 	struct timer_list	timer;		/* Timer for timeouts */
 
+	unsigned int		caps;		/* Alternative capabilities */
+
 	unsigned long		private[0] ____cacheline_aligned;
 };
 
-- 
1.7.0.4

