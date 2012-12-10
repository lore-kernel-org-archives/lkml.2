Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab2LJJIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 04:08:25 -0500
Received: from mga14.intel.com ([143.182.124.37]:35781 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab2LJJHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 04:07:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,250,1355126400"; 
   d="scan'208";a="229269925"
From: Adrian Hunter <adrian.hunter@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] mmc: sdhci-acpi: enable runtime-pm for device HID INT33C6
Date: Mon, 10 Dec 2012 11:10:44 +0200
Message-Id: <1355130644-26065-2-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355130644-26065-1-git-send-email-adrian.hunter@intel.com>
References: <1355130644-26065-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sdhci-acpi supports ACPI devices which have compatibility ID
PNP0D40, however it is not possible to know if those devices
will all work correctly with runtime-pm, so that must be configured
per hardware ID.

For INT33C6, several related quirks, capabilities and flags are set:

	MMC_CAP_NONREMOVABLE
		The SDIO card will never be removable

	SDHCI_ACPI_RUNTIME_PM
		Enable runtime-pm of the host controller

	MMC_CAP_POWER_OFF_CARD
		Enable runtime-pm of the SDIO card

	MMC_PM_KEEP_POWER
		SDIO card has the capability to remain powered up
		during system suspend

	SDHCI_QUIRK2_HOST_OFF_CARD_ON
		Always do a full reset during system resume
		because the card may be already initialized having
		not been powered off.

Wake-ups from the INT33C6 host controller are not supported, so the
following capability must *not* be set:

	MMC_PM_WAKE_SDIO_IRQ
		Enable wake on card interrupt

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/mmc/host/sdhci-acpi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/mmc/host/sdhci-acpi.c b/drivers/mmc/host/sdhci-acpi.c
index 6ac3617..12b0a78 100644
--- a/drivers/mmc/host/sdhci-acpi.c
+++ b/drivers/mmc/host/sdhci-acpi.c
@@ -87,7 +87,15 @@ static const struct sdhci_ops sdhci_acpi_ops_dflt = {
 	.enable_dma = sdhci_acpi_enable_dma,
 };
 
+static const struct sdhci_acpi_slot sdhci_acpi_slot_int_sdio = {
+	.quirks2 = SDHCI_QUIRK2_HOST_OFF_CARD_ON,
+	.caps    = MMC_CAP_NONREMOVABLE | MMC_CAP_POWER_OFF_CARD,
+	.flags   = SDHCI_ACPI_RUNTIME_PM,
+	.pm_caps = MMC_PM_KEEP_POWER,
+};
+
 static const struct acpi_device_id sdhci_acpi_ids[] = {
+	{ "INT33C6", (kernel_ulong_t)&sdhci_acpi_slot_int_sdio },
 	{ "PNP0D40" },
 	{ },
 };
-- 
1.7.11.7

