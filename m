Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964Ab1CRWMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 18:12:34 -0400
Received: from mail.atheros.com ([12.19.149.2]:44376 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932908Ab1CRWMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 18:12:25 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <cjb@laptop.org>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <vmehta@atheros.com>, <naveen.singh@atheros.com>, <kvalo@adurom.com>,
        <j@w1.fi>, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Naveen Singh <nsingh@atheros.com>,
        Vipin Mehta <Vipin.Mehta@atheros.com>
Subject: [RFC 4/4] sdhci: add quick for controllers with for CIRQ issues
Date: Fri, 18 Mar 2011 15:12:00 -0700
Message-ID: <1300486320-23607-5-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.7.4.15.g7811d
In-Reply-To: <1300486320-23607-1-git-send-email-lrodriguez@atheros.com>
References: <1300486320-23607-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds an SDHCI quick for controller which cannot
cannot detect CIRQ reliably when in 4-bit mode. What
we do is while bus is idle we leave it in 1-bit mode at
the controller level.

This allows the PCI SDCHI ENE 712 controller to work
correctly.

Cc: Chris Ball <cjb@laptop.org>
Cc: Kalle Valo <kvalo@adurom.com>
Cc: Naveen Singh <nsingh@atheros.com>
Cc: Vipin Mehta <Vipin.Mehta@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/mmc/host/sdhci-pci.c |    3 ++-
 drivers/mmc/host/sdhci.c     |   25 +++++++++++++++++++++++++
 include/linux/mmc/sdhci.h    |    2 ++
 3 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 2f8d468..8b13f61 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -130,7 +130,8 @@ static const struct sdhci_pci_fixes sdhci_ricoh_mmc = {
 
 static const struct sdhci_pci_fixes sdhci_ene_712 = {
 	.quirks		= SDHCI_QUIRK_SINGLE_POWER_WRITE |
-			  SDHCI_QUIRK_BROKEN_DMA,
+			  SDHCI_QUIRK_BROKEN_DMA |
+			  SDHCI_QUIRK_1BIT_INTERRUPT,
 };
 
 static const struct sdhci_pci_fixes sdhci_ene_714 = {
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index a4cf0c0..fac075e 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -245,6 +245,27 @@ static void sdhci_led_control(struct led_classdev *led,
 }
 #endif
 
+/* handle bus case where controller cannot detect CIRQ reliably when in 4-bit mode */
+static void sdhci_idle_bus_adjust(struct sdhci_host *host, u8 idle)
+{
+	u8 ctrl;
+
+	if (!(host->flags & SDHCI_IN_4BIT_MODE))
+		return;
+
+	if (!(host->quirks & SDHCI_QUIRK_1BIT_INTERRUPT))
+		return;
+
+	/* while bus is idle, leave it in 1-bit mode at the controller level */
+	ctrl = readb(host->ioaddr + SDHCI_HOST_CONTROL);
+	ctrl &= ~SDHCI_CTRL_4BITBUS;
+
+	if (!idle)
+		ctrl |= SDHCI_CTRL_4BITBUS;
+
+	writeb(ctrl, host->ioaddr + SDHCI_HOST_CONTROL);
+}
+
 /*****************************************************************************\
  *                                                                           *
  * Core functions                                                            *
@@ -919,6 +940,8 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 
 	mod_timer(&host->timer, jiffies + 10 * HZ);
 
+	sdhci_idle_bus_adjust(host, 0);
+
 	host->cmd = cmd;
 
 	sdhci_prepare_data(host, cmd->data);
@@ -1374,6 +1397,8 @@ static void sdhci_tasklet_finish(unsigned long param)
 	host->cmd = NULL;
 	host->data = NULL;
 
+	sdhci_idle_bus_adjust(host, 1);
+
 #ifndef SDHCI_USE_LEDS_CLASS
 	sdhci_deactivate_led(host);
 #endif
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index 266f796..4f1b26263 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -85,6 +85,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_NO_HISPD_BIT			(1<<29)
 /* Controller treats ADMA descriptors with length 0000h incorrectly */
 #define SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC		(1<<30)
+/* Controller cannot detect CIRQ reliably when in 4-bit mode */
+#define SDHCI_QUIRK_1BIT_INTERRUPT			(1<<31)
 
 	int irq;		/* Device IRQ */
 	void __iomem *ioaddr;	/* Mapped address */
-- 
1.7.4.15.g7811d

