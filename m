Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab3AHJ6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 04:58:31 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:45673 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab3AHJ63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 04:58:29 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r089vU26032613
From: <wei_wang@realsil.com.cn>
To: <cjb@laptop.org>, <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <arnd@arndb.de>, <oakad@yahoo.com>, <bp@alien8.de>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH v4 5/8] MMC:rtsx: Using callback function to switch output voltage
Date: Tue, 8 Jan 2013 17:57:26 +0800
Message-ID: <b70e8ec1eeab87ca5dbc3d6bc12fd86efd9c4032.1357638064.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1357638064.git.wei_wang@realsil.com.cn>
References: <cover.1357638064.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

Different card reader has different method to switch output voltage, so
we have to use the callback function provided by MFD driver to switch
output pad voltage.

Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c |   30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index 571915d..f74b5ad 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -1060,26 +1060,6 @@ static int sd_wait_voltage_stable_2(struct realtek_pci_sdmmc *host)
 	return 0;
 }
 
-static int sd_change_bank_voltage(struct realtek_pci_sdmmc *host, u8 voltage)
-{
-	struct rtsx_pcr *pcr = host->pcr;
-	int err;
-
-	if (voltage == SD_IO_3V3) {
-		err = rtsx_pci_write_phy_register(pcr, 0x08, 0x4FC0 | 0x24);
-		if (err < 0)
-			return err;
-	} else if (voltage == SD_IO_1V8) {
-		err = rtsx_pci_write_phy_register(pcr, 0x08, 0x4C40 | 0x24);
-		if (err < 0)
-			return err;
-	} else {
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 static int sdmmc_switch_voltage(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	struct realtek_pci_sdmmc *host = mmc_priv(mmc);
@@ -1098,11 +1078,11 @@ static int sdmmc_switch_voltage(struct mmc_host *mmc, struct mmc_ios *ios)
 	rtsx_pci_start_run(pcr);
 
 	if (ios->signal_voltage == MMC_SIGNAL_VOLTAGE_330)
-		voltage = SD_IO_3V3;
+		voltage = OUTPUT_3V3;
 	else
-		voltage = SD_IO_1V8;
+		voltage = OUTPUT_1V8;
 
-	if (voltage == SD_IO_1V8) {
+	if (voltage == OUTPUT_1V8) {
 		err = rtsx_pci_write_register(pcr,
 				SD30_DRIVE_SEL, 0x07, DRIVER_TYPE_B);
 		if (err < 0)
@@ -1113,11 +1093,11 @@ static int sdmmc_switch_voltage(struct mmc_host *mmc, struct mmc_ios *ios)
 			goto out;
 	}
 
-	err = sd_change_bank_voltage(host, voltage);
+	err = rtsx_pci_switch_output_voltage(pcr, voltage);
 	if (err < 0)
 		goto out;
 
-	if (voltage == SD_IO_1V8) {
+	if (voltage == OUTPUT_1V8) {
 		err = sd_wait_voltage_stable_2(host);
 		if (err < 0)
 			goto out;
-- 
1.7.9.5

