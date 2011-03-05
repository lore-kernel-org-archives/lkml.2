Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab1CEQGw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 11:06:52 -0500
Received: from imr3.ericy.com ([198.24.6.13]:45522 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076Ab1CEQGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 11:06:51 -0500
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>, Greg Schnorr <gschnorr@cisco.com>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH] hwmon: (pmbus) Improve support for paged fans
Date: Sat, 5 Mar 2011 08:08:23 -0800
Message-ID: <1299341303-32570-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So far, it seemed like fans would either all be in page 0, or that
there would be one page per fan.

Turns out this was a wrong assumption. There is at least one PMBus
fan controller which supports three pages with four fans each.
Update code to handle this situation.

Reported-by: Greg Schnorr <gschnorr@cisco.com>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 drivers/hwmon/pmbus_core.c |   70 +++++++++++++++++++++++++-------------------
 1 files changed, 40 insertions(+), 30 deletions(-)

diff --git a/drivers/hwmon/pmbus_core.c b/drivers/hwmon/pmbus_core.c
index b7c64ba..d025a11 100644
--- a/drivers/hwmon/pmbus_core.c
+++ b/drivers/hwmon/pmbus_core.c
@@ -58,12 +58,10 @@
 #define PMBUS_MAX_INPUT_LABELS		4	/* vin, vcap, iin, pin */
 
 /*
- * status, status_vout, status_iout, status_fans, and status_temp
- * are paged. status_input and status_fan34 are unpaged.
- * status_fan34 is a special case to handle a second set of fans
- * on page 0.
+ * status, status_vout, status_iout, status_fans, status_fan34, and status_temp
+ * are paged. status_input is unpaged.
  */
-#define PB_NUM_STATUS_REG	(PMBUS_PAGES * 5 + 2)
+#define PB_NUM_STATUS_REG	(PMBUS_PAGES * 6 + 1)
 
 /*
  * Index into status register array, per status register group
@@ -73,7 +71,7 @@
 #define PB_STATUS_IOUT_BASE	(PB_STATUS_VOUT_BASE + PMBUS_PAGES)
 #define PB_STATUS_FAN_BASE	(PB_STATUS_IOUT_BASE + PMBUS_PAGES)
 #define PB_STATUS_FAN34_BASE	(PB_STATUS_FAN_BASE + PMBUS_PAGES)
-#define PB_STATUS_INPUT_BASE	(PB_STATUS_FAN34_BASE + 1)
+#define PB_STATUS_INPUT_BASE	(PB_STATUS_FAN34_BASE + PMBUS_PAGES)
 #define PB_STATUS_TEMP_BASE	(PB_STATUS_INPUT_BASE + 1)
 
 struct pmbus_sensor {
@@ -327,14 +325,17 @@ static struct pmbus_data *pmbus_update_device(struct device *dev)
 			  = pmbus_get_status(client, i, PMBUS_STATUS_FAN_12);
 		}
 
+		for (i = 0; i < info->pages; i++) {
+			if (!(info->func[i] & PMBUS_HAVE_STATUS_FAN34))
+				continue;
+			data->status[PB_STATUS_FAN34_BASE + i]
+			  = pmbus_get_status(client, i, PMBUS_STATUS_FAN_34);
+		}
+
 		if (info->func[0] & PMBUS_HAVE_STATUS_INPUT)
 			data->status[PB_STATUS_INPUT_BASE]
 			  = pmbus_get_status(client, 0, PMBUS_STATUS_INPUT);
 
-		if (info->func[0] & PMBUS_HAVE_STATUS_FAN34)
-			data->status[PB_STATUS_FAN34_BASE]
-			  = pmbus_get_status(client, 0, PMBUS_STATUS_FAN_34);
-
 		for (i = 0; i < data->num_sensors; i++) {
 			struct pmbus_sensor *sensor = &data->sensors[i];
 
@@ -817,6 +818,20 @@ static const int pmbus_fan_status_registers[] = {
 	PMBUS_STATUS_FAN_34
 };
 
+static const u32 pmbus_fan_flags[] = {
+	PMBUS_HAVE_FAN12,
+	PMBUS_HAVE_FAN12,
+	PMBUS_HAVE_FAN34,
+	PMBUS_HAVE_FAN34
+};
+
+static const u32 pmbus_fan_status_flags[] = {
+	PMBUS_HAVE_STATUS_FAN12,
+	PMBUS_HAVE_STATUS_FAN12,
+	PMBUS_HAVE_STATUS_FAN34,
+	PMBUS_HAVE_STATUS_FAN34
+};
+
 /*
  * Determine maximum number of sensors, booleans, and labels.
  * To keep things simple, only make a rough high estimate.
@@ -848,17 +863,12 @@ static void pmbus_find_max_attr(struct i2c_client *client,
 			max_labels++;
 		}
 		if (info->func[page] & PMBUS_HAVE_FAN12) {
-			if (page == 0) {
-				max_sensors +=
-				    ARRAY_SIZE(pmbus_fan_registers) *
-				    PMBUS_MAX_SENSORS_PER_FAN;
-				max_booleans +=
-				    ARRAY_SIZE(pmbus_fan_registers) *
-				    PMBUS_MAX_BOOLEANS_PER_FAN;
-			} else {
-				max_sensors += PMBUS_MAX_SENSORS_PER_FAN;
-				max_booleans += PMBUS_MAX_BOOLEANS_PER_FAN;
-			}
+			max_sensors += 2 * PMBUS_MAX_SENSORS_PER_FAN;
+			max_booleans += 2 * PMBUS_MAX_BOOLEANS_PER_FAN;
+		}
+		if (info->func[page] & PMBUS_HAVE_FAN34) {
+			max_sensors += 2 * PMBUS_MAX_SENSORS_PER_FAN;
+			max_booleans += 2 * PMBUS_MAX_BOOLEANS_PER_FAN;
 		}
 		if (info->func[page] & PMBUS_HAVE_TEMP) {
 			if (page == 0) {
@@ -1365,15 +1375,14 @@ static void pmbus_find_attributes(struct i2c_client *client,
 	 */
 	in_index = 1;
 	for (page = 0; page < info->pages; page++) {
-		int fans, f;
+		int f;
 
-		if (!(info->func[page] & PMBUS_HAVE_FAN12))
-			continue;
-
-		fans = page ? 1 : ARRAY_SIZE(pmbus_fan_registers);
-		for (f = 0; f < fans; f++) {
+		for (f = 0; f < ARRAY_SIZE(pmbus_fan_registers); f++) {
 			int regval;
 
+			if (!(info->func[page] & pmbus_fan_flags[f]))
+				break;
+
 			if (!pmbus_check_word_register(client, page,
 						       pmbus_fan_registers[f])
 			    || !pmbus_check_byte_register(client, page,
@@ -1399,12 +1408,13 @@ static void pmbus_find_attributes(struct i2c_client *client,
 			 * Each fan status register covers multiple fans,
 			 * so we have to do some magic.
 			 */
-			if (pmbus_check_byte_register
-			    (client, page, pmbus_fan_status_registers[f])) {
+			if ((info->func[page] & pmbus_fan_status_flags[f]) &&
+			    pmbus_check_byte_register(client,
+					page, pmbus_fan_status_registers[f])) {
 				int base;
 
 				if (f > 1)	/* fan 3, 4 */
-					base = PB_STATUS_FAN34_BASE;
+					base = PB_STATUS_FAN34_BASE + page;
 				else
 					base = PB_STATUS_FAN_BASE + page;
 				pmbus_add_boolean_reg(data, "fan", "alarm",
-- 
1.7.3.1

