Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab1HXW1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:27:25 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:38186 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750827Ab1HXW1Y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:27:24 -0400
From: Philip Rakity <prakity@marvell.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Haojian Zhuang <hzhuang1@marvell.com>
Date: Wed, 24 Aug 2011 15:27:33 -0700
Subject: [PATCH] power: max8925_power.  Do not detect ac insert if handled
 by other code 
Thread-Topic: [PATCH] power: max8925_power.  Do not detect ac insert if
 handled by other code 
Thread-Index: AcxirP59AOC1LnWlTPiZlRDb9t19Rw==
Message-ID: <7F69A365-0154-4B4A-9ED9-D60AE4BEB23C@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On brownstone rev 4 ac-insert detect is handled by vbus.

allow the platform code to configure the disabling of insert
by setting no_insert_detect.

Signed-off-by: Philip Rakity <prakity@marvell.com>
---
 drivers/power/max8925_power.c |    8 ++++++--
 include/linux/mfd/max8925.h   |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
index dba07f3..fd32c08 100644
--- a/drivers/power/max8925_power.c
+++ b/drivers/power/max8925_power.c
@@ -79,6 +79,7 @@ struct max8925_power_info {
 	unsigned		topoff_threshold:2;
 	unsigned		fast_charge:3;
 	unsigned		no_temp_support:1;
+	unsigned		no_insert_detect:1;
 
 	int (*set_charger) (int);
 };
@@ -366,8 +367,10 @@ static __devinit int max8925_init_charger(struct max8925_chip *chip,
 	int ret;
 
 	REQUEST_IRQ(MAX8925_IRQ_VCHG_DC_OVP, "ac-ovp");
-	REQUEST_IRQ(MAX8925_IRQ_VCHG_DC_F, "ac-remove");
-	REQUEST_IRQ(MAX8925_IRQ_VCHG_DC_R, "ac-insert");
+	if (!info->no_insert_detect) {
+		REQUEST_IRQ(MAX8925_IRQ_VCHG_DC_F, "ac-remove");
+		REQUEST_IRQ(MAX8925_IRQ_VCHG_DC_R, "ac-insert");
+	}
 	REQUEST_IRQ(MAX8925_IRQ_VCHG_USB_OVP, "usb-ovp");
 	REQUEST_IRQ(MAX8925_IRQ_VCHG_USB_F, "usb-remove");
 	REQUEST_IRQ(MAX8925_IRQ_VCHG_USB_R, "usb-insert");
@@ -482,6 +485,7 @@ static __devinit int max8925_power_probe(struct platform_device *pdev)
 	info->fast_charge = pdata->fast_charge;
 	info->set_charger = pdata->set_charger;
 	info->no_temp_support = pdata->no_temp_support;
+	info->no_insert_detect = pdata->no_insert_detect;
 
 	max8925_init_charger(chip, info);
 	return 0;
diff --git a/include/linux/mfd/max8925.h b/include/linux/mfd/max8925.h
index 69ec8f0..e742e04 100644
--- a/include/linux/mfd/max8925.h
+++ b/include/linux/mfd/max8925.h
@@ -224,6 +224,7 @@ struct max8925_power_pdata {
 	unsigned	topoff_threshold:2;
 	unsigned	fast_charge:3;	/* charge current */
 	unsigned	no_temp_support:1; /* set if no temperature detect */
+	unsigned	no_insert_detect:1; /* set if no ac insert detect */
 };
 
 /*
-- 
1.7.6

