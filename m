Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760303Ab0FKTIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 15:08:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44958 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760253Ab0FKTIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 15:08:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Y1MMW/fF5Z6UYjiwzxyoVvFKvLEprqUzT4sOs2tZj7PkNaMdp4hWrLWeiE/noXHI3x
         C5al6FH3IQdVswGp+xUmmblf9kp1RpzrhfhQ7lx4Vxr55i76ZPfdVk/vRUPryEcGHNBQ
         oYNHPq0pIV+j/mzm0xQTCdacrNcWnqbfdDxbY=
Subject: [PATCH v3] mmc: make sdhci work with ricoh mmc controller
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Philip Langdale <philipl@overt.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew de Quincey <adq_dvb@lidskialf.net>
In-Reply-To: <20100606184139.5505d2a5@fido5>
References: <1275859475.3151.4.camel@maxim-laptop>
	 <1275859731-2898-1-git-send-email-maximlevitsky@gmail.com>
	 <b99ba230e4a7f8b2174d7f52f1e7324c@localhost>
	 <1275871052.24091.7.camel@maxim-laptop>  <20100606184139.5505d2a5@fido5>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Jun 2010 22:08:06 +0300
Message-ID: <1276283286.8557.28.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, now I tested it well, and sdhci + mmc controller finally work well.

I found out that small delay is all needed to make the mmc work fine
after resume with or without card.

Its not that pretty solution as it might increase the resume time (I use
a delay of 1/2sec, while around 300 ms is enough)
With parallel resume it probably be unnoticeable.

It might be not enough for other mmc cards (slower?) but then the
problem isn't that big deal, you just reinsert the card after resume or
don't suspend with it if first place.

I will at future do some reverse engineering.
Maybe I find a bit to that will tell that controller is currently busy
checking if card is mmc or not.

I did quite a lot of testing, and it works. 
commit bd9596e86d2321f3f97a90ec157371c366925357
Author: Maxim Levitsky <maximlevitsky@gmail.com>
Date:   Mon Jun 7 02:04:40 2010 +0300

---

    mmc: make sdhci work with ricoh mmc controller
    
    The current way of disabling it is not well tested by vendor
    and has all kinds of bugs that show up on resume from ram/disk.
    
    Old way of disabling is still supported by
    continuing to use CONFIG_MMC_RICOH_MMC.
    
    Based on 'http://list.drzeus.cx/pipermail/sdhci-devel/2007-December/002085.html'
    Most of the credit for this goes to Andrew de Quincey
    
    
    Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
    CC: Andrew de Quincey <adq_dvb@lidskialf.net>
    CC: linux-mmc@vger.kernel.org <linux-mmc@vger.kernel.org>

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 569e94d..85d15de 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1259,8 +1259,6 @@ int mmc_suspend_host(struct mmc_host *host)
 
 	if (host->caps & MMC_CAP_DISABLE)
 		cancel_delayed_work(&host->disable);
-	cancel_delayed_work(&host->detect);
-	mmc_flush_scheduled_work();
 
 	mmc_bus_get(host);
 	if (host->bus_ops && !host->bus_dead) {
diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 65483fd..e021431 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -17,6 +17,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
+#include <linux/device.h>
 
 #include <linux/mmc/host.h>
 
@@ -84,7 +85,30 @@ static int ricoh_probe(struct sdhci_pci_chip *chip)
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
+
+		((0x21 << SDHCI_CLOCK_BASE_SHIFT)
+			& SDHCI_CLOCK_BASE_MASK) |
 
+		SDHCI_TIMEOUT_CLK_UNIT |
+		SDHCI_CAN_VDD_330 |
+		SDHCI_CAN_DO_SDMA;
+	return 0;
+}
+
+static int ricoh_mmc_resume(struct sdhci_pci_chip *chip)
+{
+	/* Apply a delay to allow controller to settle */
+	/* Otherwise it becomes confused if card state changed
+		during suspend */
+	msleep(500);
 	return 0;
 }
 
@@ -95,6 +119,15 @@ static const struct sdhci_pci_fixes sdhci_ricoh = {
 			  SDHCI_QUIRK_CLOCK_BEFORE_RESET,
 };
 
+static const struct sdhci_pci_fixes sdhci_ricoh_mmc = {
+	.probe_slot	= ricoh_mmc_probe_slot,
+	.resume		= ricoh_mmc_resume,
+	.quirks		= SDHCI_QUIRK_32BIT_DMA_ADDR |
+			  SDHCI_QUIRK_CLOCK_BEFORE_RESET |
+			  SDHCI_QUIRK_NO_CARD_NO_RESET |
+			  SDHCI_QUIRK_MISSING_CAPS
+};
+
 static const struct sdhci_pci_fixes sdhci_ene_712 = {
 	.quirks		= SDHCI_QUIRK_SINGLE_POWER_WRITE |
 			  SDHCI_QUIRK_BROKEN_DMA,
@@ -374,6 +407,14 @@ static const struct pci_device_id pci_ids[] __devinitdata = {
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
 


