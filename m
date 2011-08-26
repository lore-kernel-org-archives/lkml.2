Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab1HZL1C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 07:27:02 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42602 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab1HZL04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 07:26:56 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] mrst: Battery fixes
To: cbou@mail.ru, linux-kernel@vger.kernel.org
Date: Fri, 26 Aug 2011 12:22:00 +0100
Message-ID: <20110826112145.27280.69626.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Major Lee <major_lee@wistrom.com>

[Resend with correct email address]

When DCDC input line over current detecting, PMIC will change charging
current automatically.  Logging event is enough.

Signed-off-by: Major Lee <major_lee@wistron.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/power/intel_mid_battery.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/power/intel_mid_battery.c b/drivers/power/intel_mid_battery.c
index cffcb7c..c82088d 100644
--- a/drivers/power/intel_mid_battery.c
+++ b/drivers/power/intel_mid_battery.c
@@ -61,7 +61,8 @@ MODULE_PARM_DESC(debug, "Flag to enable PMIC Battery debug messages.");
 #define PMIC_BATT_CHR_SBATDET_MASK	(1 << 5)
 #define PMIC_BATT_CHR_SDCLMT_MASK	(1 << 6)
 #define PMIC_BATT_CHR_SUSBOVP_MASK	(1 << 7)
-#define PMIC_BATT_CHR_EXCPT_MASK	0xC6
+#define PMIC_BATT_CHR_EXCPT_MASK	0x86
+
 #define PMIC_BATT_ADC_ACCCHRG_MASK	(1 << 31)
 #define PMIC_BATT_ADC_ACCCHRGVAL_MASK	0x7FFFFFFF
 
@@ -304,11 +305,6 @@ static void pmic_battery_read_status(struct pmic_power_module_info *pbi)
 			pbi->batt_status = POWER_SUPPLY_STATUS_NOT_CHARGING;
 			pmic_battery_log_event(BATT_EVENT_BATOVP_EXCPT);
 			batt_exception = 1;
-		} else if (r8 & PMIC_BATT_CHR_SDCLMT_MASK) {
-			pbi->batt_health = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
-			pbi->batt_status = POWER_SUPPLY_STATUS_NOT_CHARGING;
-			pmic_battery_log_event(BATT_EVENT_DCLMT_EXCPT);
-			batt_exception = 1;
 		} else if (r8 & PMIC_BATT_CHR_STEMP_MASK) {
 			pbi->batt_health = POWER_SUPPLY_HEALTH_OVERHEAT;
 			pbi->batt_status = POWER_SUPPLY_STATUS_NOT_CHARGING;
@@ -316,6 +312,10 @@ static void pmic_battery_read_status(struct pmic_power_module_info *pbi)
 			batt_exception = 1;
 		} else {
 			pbi->batt_health = POWER_SUPPLY_HEALTH_GOOD;
+			if (r8 & PMIC_BATT_CHR_SDCLMT_MASK) {
+				/* PMIC will change charging current automatically */
+				pmic_battery_log_event(pbi, BATT_EVENT_DCLMT_EXCPT);
+			}
 		}
 	}
 

