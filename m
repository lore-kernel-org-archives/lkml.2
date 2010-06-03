Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473Ab0FCBQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 21:16:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:20529 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758189Ab0FCBQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 21:16:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ziu0bI3ecoL/NkOaATxZIDO/aTbkSCm8h9Lh5x1VR+waqBJYiKhxU4SznSFKracEz3
         Wdh54opbcjiB4iulLILJhMguPzpsy3DnVELDYci9oOAs6UpdLsN7HDemzky6XOQmY7EZ
         Qn5/vF3Gv9c+zQlUkFlMHOyui/h2Byk1A/lPs=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Philip Langdale <philipl@overt.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, adq_dvb@lidskialf.net,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Subject: [PATCH] mmc: make sdhci work with ricoh mmc controller
Date: Thu,  3 Jun 2010 04:16:27 +0300
Message-Id: <1275527787-3783-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275516180.30272.4.camel@maxim-laptop>
References: <1275516180.30272.4.camel@maxim-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current way of disabling it is not well tested by vendor
and has all kinds of bugs that show up on resume from ram/disk.

Old way of disabling is still supported by
continuing to use CONFIG_MMC_RICOH_MMC.

Based on 'http://list.drzeus.cx/pipermail/sdhci-devel/2007-December/002085.html'

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
CC: adq_dvb@lidskialf.net
CC: linux-mmc@vger.kernel.org <linux-mmc@vger.kernel.org>
---
 drivers/mmc/host/sdhci-pci.c |   34 ++++++++++++++++++++++++++++++++++
 drivers/mmc/host/sdhci.c     |    5 ++++-
 drivers/mmc/host/sdhci.h     |    2 ++
 3 files changed, 40 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 65483fd..3843780 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -17,6 +17,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
+#include <linux/device.h>
 
 #include <linux/mmc/host.h>
 
@@ -85,6 +86,26 @@ static int ricoh_probe(struct sdhci_pci_chip *chip)
 	    chip->pdev->subsystem_vendor == PCI_VENDOR_ID_SONY)
 		chip->quirks |= SDHCI_QUIRK_NO_CARD_NO_RESET;
 
+	/* To disable hardware races against MMC part */
+	device_disable_async_suspend(&chip->pci_dev->dev);
+	return 0;
+}
+
+static int ricoh_mmc_probe_slot(struct sdhci_pci_slot *slot)
+{
+	slot->host->caps =
+		((0x21 << SDHCI_TIMEOUT_CLK_SHIFT)
+			& SDHCI_TIMEOUT_CLK_MASK) |
+
+		((0x21 << SDHCI_CLOCK_BASE_SHIFT)
+			& SDHCI_CLOCK_BASE_MASK) |
+
+		SDHCI_TIMEOUT_CLK_UNIT |
+		SDHCI_CAN_VDD_330 |
+		SDHCI_CAN_DO_SDMA ;
+
+	/* To disable hardware races against SDHC part */
+	device_disable_async_suspend(&slot->chip->pci_dev->dev);
 	return 0;
 }
 
@@ -95,6 +116,11 @@ static const struct sdhci_pci_fixes sdhci_ricoh = {
 			  SDHCI_QUIRK_CLOCK_BEFORE_RESET,
 };
 
+static const struct sdhci_pci_fixes sdhci_ricoh_mmc = {
+	.probe_slot	= ricoh_mmc_probe_slot,
+	.quirks		= SDHCI_QUIRK_NO_CARD_NO_RESET,
+};
+
 static const struct sdhci_pci_fixes sdhci_ene_712 = {
 	.quirks		= SDHCI_QUIRK_SINGLE_POWER_WRITE |
 			  SDHCI_QUIRK_BROKEN_DMA,
@@ -374,6 +400,14 @@ static const struct pci_device_id pci_ids[] __devinitdata = {
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
index c6d1bd8..dbd9367 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1687,7 +1687,10 @@ int sdhci_add_host(struct sdhci_host *host)
 			host->version);
 	}
 
-	caps = sdhci_readl(host, SDHCI_CAPABILITIES);
+	if (host->caps)
+		caps = host->caps;
+	else
+		caps = sdhci_readl(host, SDHCI_CAPABILITIES);
 
 	if (host->quirks & SDHCI_QUIRK_FORCE_DMA)
 		host->flags |= SDHCI_USE_SDMA;
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index c846813..b41581a 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -292,6 +292,8 @@ struct sdhci_host {
 
 	struct timer_list	timer;		/* Timer for timeouts */
 
+	unsigned int		caps;		/* Alternative capabilities */
+
 	unsigned long		private[0] ____cacheline_aligned;
 };
 
-- 
1.7.0.4

