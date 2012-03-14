Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760644Ab2CNBFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 21:05:24 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43959 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760528Ab2CNBFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 21:05:18 -0400
Date: Wed, 14 Mar 2012 05:05:15 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Arun Murthy <arun.murthy@stericsson.com>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        karl.komierowski@stericsson.com, johan.palsson@stericsson.com,
        linus.walleij@linaro.org
Subject: [PATCH 4/6] ab8500_fg: Get rid of 'struct battery_type'
Message-ID: <20120314010515.GD10798@oksana.dev.rtsoft.ru>
References: <20120314005901.GB1778@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120314005901.GB1778@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The struct is duplicated, plus causes the following flood:

  CC      drivers/power/ab8500_fg.o
ab8500_fg.c: In function ‘ab8500_fg_get_ext_psy_data’:
b8500_fg.c:2081:8: warning: assignment from incompatible pointer type [enabled by default]

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/power/ab8500_fg.c            |    3 +-
 include/linux/mfd/abx500/ab8500-bm.h |   59 ----------------------------------
 2 files changed, 2 insertions(+), 60 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 180c21a..b7e12c8 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -2077,7 +2077,8 @@ static int ab8500_fg_get_ext_psy_data(struct device *dev, void *data)
 			switch (ext->type) {
 			case POWER_SUPPLY_TYPE_BATTERY:
 				if (!di->flags.batt_id_received) {
-					const struct battery_type *b;
+					const struct abx500_battery_type *b;
+
 					b = &(di->bat->bat_type[di->bat->batt_id]);
 
 					di->flags.batt_id_received = true;
diff --git a/include/linux/mfd/abx500/ab8500-bm.h b/include/linux/mfd/abx500/ab8500-bm.h
index 44d8620..44310c9 100644
--- a/include/linux/mfd/abx500/ab8500-bm.h
+++ b/include/linux/mfd/abx500/ab8500-bm.h
@@ -313,64 +313,6 @@ struct ab8500_maxim_parameters {
 };
 
 /**
- * struct battery_type - different batteries supported
- * @name:			battery technology
- * @resis_high:			battery upper resistance limit
- * @resis_low:			battery lower resistance limit
- * @charge_full_design:		Maximum battery capacity in mAh
- * @nominal_voltage:		Nominal voltage of the battery in mV
- * @termination_vol:		max voltage upto which battery can be charged
- * @termination_curr		battery charging termination current in mA
- * @recharge_vol		battery voltage limit that will trigger a new
- *				full charging cycle in the case where maintenan-
- *				-ce charging has been disabled
- * @normal_cur_lvl:		charger current in normal state in mA
- * @normal_vol_lvl:		charger voltage in normal state in mV
- * @maint_a_cur_lvl:		charger current in maintenance A state in mA
- * @maint_a_vol_lvl:		charger voltage in maintenance A state in mV
- * @maint_a_chg_timer_h:	charge time in maintenance A state
- * @maint_b_cur_lvl:		charger current in maintenance B state in mA
- * @maint_b_vol_lvl:		charger voltage in maintenance B state in mV
- * @maint_b_chg_timer_h:	charge time in maintenance B state
- * @low_high_cur_lvl:		charger current in temp low/high state in mA
- * @low_high_vol_lvl:		charger voltage in temp low/high state in mV'
- * @battery_resistance:		battery inner resistance in mOhm.
- * @n_r_t_tbl_elements:		number of elements in r_to_t_tbl
- * @r_to_t_tbl:			table containing resistance to temp points
- * @n_v_cap_tbl_elements:	number of elements in v_to_cap_tbl
- * @v_to_cap_tbl:		Voltage to capacity (in %) table
- * @n_batres_tbl_elements	number of elements in the batres_tbl
- * @batres_tbl			battery internal resistance vs temperature table
- */
-struct battery_type {
-	int name;
-	int resis_high;
-	int resis_low;
-	int charge_full_design;
-	int nominal_voltage;
-	int termination_vol;
-	int termination_curr;
-	int recharge_vol;
-	int normal_cur_lvl;
-	int normal_vol_lvl;
-	int maint_a_cur_lvl;
-	int maint_a_vol_lvl;
-	int maint_a_chg_timer_h;
-	int maint_b_cur_lvl;
-	int maint_b_vol_lvl;
-	int maint_b_chg_timer_h;
-	int low_high_cur_lvl;
-	int low_high_vol_lvl;
-	int battery_resistance;
-	int n_temp_tbl_elements;
-	struct res_to_temp *r_to_t_tbl;
-	int n_v_cap_tbl_elements;
-	struct v_to_cap *v_to_cap_tbl;
-	int n_batres_tbl_elements;
-	struct batres_vs_temp *batres_tbl;
-};
-
-/**
  * struct ab8500_bm_capacity_levels - ab8500 capacity level data
  * @critical:		critical capacity level in percent
  * @low:		low capacity level in percent
@@ -453,7 +395,6 @@ struct ab8500_bm_data {
 	int gnd_lift_resistance;
 	const struct ab8500_maxim_parameters *maxi;
 	const struct ab8500_bm_capacity_levels *cap_levels;
-	const struct battery_type *bat_type;
 	const struct ab8500_bm_charger_parameters *chg_params;
 	const struct ab8500_fg_parameters *fg_params;
 };
-- 
1.7.9

