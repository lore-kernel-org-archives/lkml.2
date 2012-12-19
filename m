Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab2LSAlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 19:41:18 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:61014 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab2LSAlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 19:41:17 -0500
X-Greylist: delayed 1214 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2012 19:41:17 EST
Date: Tue, 18 Dec 2012 16:09:30 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Subject: [GIT PULL] (part2) battery-2.6.git
Message-ID: <20121219000928.GA3327@lizard.mcd00620.sjc.wayport.net>
Reply-To: cbouatmailru@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Here is the second part of the battery tree patches. These are left overs
that I didn't have time to review/apply before the merge window opened. I
didn't want to "spoil" the first pull request with these late patches, so
they were not included.

But the stuff is simple enough, so I thought it is worth asking to pull.
In 'part2':

- A small patch for the RX51 OMAP board (Nokia N900 phone), the patch
  creates a battery monitor device instance, so that it can be probed. It
  was acked by the OMAP maintainer;

- A couple of late bug fixes for the charger-manager: corrects corner
  cases for the battery full handling.

Please pull.

Thanks, and merry holidays to you!


The following changes since commit 76d8a23b127020472207b281427d3e9f4f1227e4:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux (2012-12-11 22:15:57 -0800)

are available in the git repository at:


  git://git.infradead.org/battery-2.6.git tags/for-v3.8-part2

for you to fetch changes up to f36b9ddbab408f5f5ed9105d857189b84337af48:

  charger-manager: Fix bug when check dropped voltage after fullbatt event (2012-12-16 22:45:58 -0800)

----------------------------------------------------------------
In part2:

- A small patch for the RX51 OMAP board (Nokia N900 phone), the patch
  creates a battery monitor device instance, so that it can be probed. It
  was acked by the OMAP maintainer;

- A couple of late bug fixes for the charger-manager: corrects corner
  cases for the battery full handling.

----------------------------------------------------------------
Chanwoo Choi (2):
      charger-manager: Fix bug related to checking fully charged state of battery
      charger-manager: Fix bug when check dropped voltage after fullbatt event

Pali Rohár (1):
      ARM: OMAP: rx51: Register platform device for rx51_battery

 arch/arm/mach-omap2/board-rx51-peripherals.c |  6 ++++++
 drivers/power/charger-manager.c              | 38 ++++++++++++++++----------------------
 2 files changed, 22 insertions(+), 22 deletions(-)


--

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index 020e03c..1fb96e6 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -255,6 +255,11 @@ static struct spi_board_info rx51_peripherals_spi_board_info[] __initdata = {
 	},
 };
 
+static struct platform_device rx51_battery_device = {
+	.name	= "rx51-battery",
+	.id	= -1,
+};
+
 static void rx51_charger_set_power(bool on)
 {
 	gpio_set_value(RX51_USB_TRANSCEIVER_RST_GPIO, on);
@@ -276,6 +281,7 @@ static void __init rx51_charger_init(void)
 	WARN_ON(gpio_request_one(RX51_USB_TRANSCEIVER_RST_GPIO,
 		GPIOF_OUT_INIT_HIGH, "isp1704_reset"));
 
+	platform_device_register(&rx51_battery_device);
 	platform_device_register(&rx51_charger_device);
 }
 
diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index adb3a4b..6ba047f 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -239,44 +239,37 @@ static bool is_full_charged(struct charger_manager *cm)
 	int uV;
 
 	/* If there is no battery, it cannot be charged */
-	if (!is_batt_present(cm)) {
-		val.intval = 0;
-		goto out;
-	}
+	if (!is_batt_present(cm))
+		return false;
 
 	if (cm->fuel_gauge && desc->fullbatt_full_capacity > 0) {
+		val.intval = 0;
+
 		/* Not full if capacity of fuel gauge isn't full */
 		ret = cm->fuel_gauge->get_property(cm->fuel_gauge,
 				POWER_SUPPLY_PROP_CHARGE_FULL, &val);
-		if (!ret && val.intval > desc->fullbatt_full_capacity) {
-			val.intval = 1;
-			goto out;
-		}
+		if (!ret && val.intval > desc->fullbatt_full_capacity)
+			return true;
 	}
 
 	/* Full, if it's over the fullbatt voltage */
 	if (desc->fullbatt_uV > 0) {
 		ret = get_batt_uV(cm, &uV);
-		if (!ret && uV >= desc->fullbatt_uV) {
-			val.intval = 1;
-			goto out;
-		}
+		if (!ret && uV >= desc->fullbatt_uV)
+			return true;
 	}
 
 	/* Full, if the capacity is more than fullbatt_soc */
 	if (cm->fuel_gauge && desc->fullbatt_soc > 0) {
+		val.intval = 0;
+
 		ret = cm->fuel_gauge->get_property(cm->fuel_gauge,
 				POWER_SUPPLY_PROP_CAPACITY, &val);
-		if (!ret && val.intval >= desc->fullbatt_soc) {
-			val.intval = 1;
-			goto out;
-		}
+		if (!ret && val.intval >= desc->fullbatt_soc)
+			return true;
 	}
 
-	val.intval = 0;
-
-out:
-	return val.intval ? true : false;
+	return false;
 }
 
 /**
@@ -489,8 +482,9 @@ static void fullbatt_vchk(struct work_struct *work)
 		return;
 	}
 
-	diff = desc->fullbatt_uV;
-	diff -= batt_uV;
+	diff = desc->fullbatt_uV - batt_uV;
+	if (diff < 0)
+		return;
 
 	dev_info(cm->dev, "VBATT dropped %duV after full-batt.\n", diff);
 
