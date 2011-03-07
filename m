Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab1CGQhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 11:37:04 -0500
Received: from imr4.ericy.com ([198.24.6.8]:45169 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab1CGQg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 11:36:58 -0500
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Greg Schnorr <gschnorr@cisco.com>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH 1/2] hwmon: (pmbus) Improve support for paged temperature sensors
Date: Mon, 7 Mar 2011 08:38:56 -0800
Message-ID: <1299515937-9138-2-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1299515937-9138-1-git-send-email-guenter.roeck@ericsson.com>
References: <1299515937-9138-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assumption so far was that PMBus devices would support TEMP2 and TEMP3 registers
only on page 0, and that only the TEMP1 register would be used/supported
on other pages.

Turns out that is not correct. UCD92xx devices support TEMP1 and TEMP2 on
page 0, and TEMP2 on other pages. So it is necessary to change the core code
such that it does not make a page based assumptions about temperature register
support.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 drivers/hwmon/pmbus_core.c |   46 ++++++++++++++++++++++++++-----------------
 1 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/hwmon/pmbus_core.c b/drivers/hwmon/pmbus_core.c
index d025a11..e9dda58 100644
--- a/drivers/hwmon/pmbus_core.c
+++ b/drivers/hwmon/pmbus_core.c
@@ -797,6 +797,12 @@ static const int pmbus_temp_registers[] = {
 	PMBUS_READ_TEMPERATURE_3
 };
 
+static const int pmbus_temp_flags[] = {
+	PMBUS_HAVE_TEMP,
+	PMBUS_HAVE_TEMP2,
+	PMBUS_HAVE_TEMP3
+};
+
 static const int pmbus_fan_registers[] = {
 	PMBUS_READ_FAN_SPEED_1,
 	PMBUS_READ_FAN_SPEED_2,
@@ -871,17 +877,16 @@ static void pmbus_find_max_attr(struct i2c_client *client,
 			max_booleans += 2 * PMBUS_MAX_BOOLEANS_PER_FAN;
 		}
 		if (info->func[page] & PMBUS_HAVE_TEMP) {
-			if (page == 0) {
-				max_sensors +=
-				    ARRAY_SIZE(pmbus_temp_registers) *
-				    PMBUS_MAX_SENSORS_PER_TEMP;
-				max_booleans +=
-				    ARRAY_SIZE(pmbus_temp_registers) *
-				    PMBUS_MAX_BOOLEANS_PER_TEMP;
-			} else {
-				max_sensors += PMBUS_MAX_SENSORS_PER_TEMP;
-				max_booleans += PMBUS_MAX_BOOLEANS_PER_TEMP;
-			}
+			max_sensors += PMBUS_MAX_SENSORS_PER_TEMP;
+			max_booleans += PMBUS_MAX_BOOLEANS_PER_TEMP;
+		}
+		if (info->func[page] & PMBUS_HAVE_TEMP2) {
+			max_sensors += PMBUS_MAX_SENSORS_PER_TEMP;
+			max_booleans += PMBUS_MAX_BOOLEANS_PER_TEMP;
+		}
+		if (info->func[page] & PMBUS_HAVE_TEMP3) {
+			max_sensors += PMBUS_MAX_SENSORS_PER_TEMP;
+			max_booleans += PMBUS_MAX_BOOLEANS_PER_TEMP;
 		}
 	}
 	data->max_sensors = max_sensors;
@@ -1273,18 +1278,23 @@ static void pmbus_find_attributes(struct i2c_client *client,
 	 */
 	in_index = 1;
 	for (page = 0; page < info->pages; page++) {
-		int t, temps;
-
-		if (!(info->func[page] & PMBUS_HAVE_TEMP))
-			continue;
+		int t;
 
-		temps = page ? 1 : ARRAY_SIZE(pmbus_temp_registers);
-		for (t = 0; t < temps; t++) {
+		for (t = 0; t < ARRAY_SIZE(pmbus_temp_registers); t++) {
 			bool have_alarm = false;
 
+			/*
+			 * A PMBus chip may support any combination of
+			 * temperature registers on any page. So we can not
+			 * abort after a failure to detect a register, but have
+			 * to continue checking for all registers on all pages.
+			 */
+			if (!(info->func[page] & pmbus_temp_flags[t]))
+				continue;
+
 			if (!pmbus_check_word_register
 			    (client, page, pmbus_temp_registers[t]))
-				break;
+				continue;
 
 			i0 = data->num_sensors;
 			pmbus_add_sensor(data, "temp", "input", in_index, page,
-- 
1.7.3.1

