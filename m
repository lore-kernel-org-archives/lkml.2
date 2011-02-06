Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab1BFTjo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 14:39:44 -0500
Received: from smtp-out-015.synserver.de ([212.40.185.15]:1251 "HELO
	smtp-out-014.synserver.de" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753667Ab1BFTje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 14:39:34 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 24265
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Rodolfo Giometti <giometti@linux.it>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 04/14] POWER: bq27x00: Return -ENODEV for properties if the battery is not present
Date: Sun,  6 Feb 2011 01:48:01 +0100
Message-Id: <1296953291-10373-5-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1296953291-10373-1-git-send-email-lars@metafoo.de>
References: <1296953291-10373-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes get_property callback of the bq27x00 battery to return
-ENODEV for properties other then the PROP_PRESENT if the battery is not
present.
The power subsystem core expects a driver to behave that way.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/power/bq27x00_battery.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 1b06134..9f16666 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -252,16 +252,21 @@ static int bq27x00_battery_get_property(struct power_supply *psy,
 {
 	int ret = 0;
 	struct bq27x00_device_info *di = to_bq27x00_device_info(psy);
+	int voltage = bq27x00_battery_voltage(di);
+
+	if (psp != POWER_SUPPLY_PROP_PRESENT && voltage <= 0)
+		return -ENODEV;
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_STATUS:
 		ret = bq27x00_battery_status(di, val);
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		val->intval = voltage;
+		break;
 	case POWER_SUPPLY_PROP_PRESENT:
-		val->intval = bq27x00_battery_voltage(di);
 		if (psp == POWER_SUPPLY_PROP_PRESENT)
-			val->intval = val->intval <= 0 ? 0 : 1;
+			val->intval = voltage <= 0 ? 0 : 1;
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
 		val->intval = bq27x00_battery_current(di);
-- 
1.7.2.3

