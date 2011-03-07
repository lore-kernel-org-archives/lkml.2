Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab1CGQhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 11:37:16 -0500
Received: from imr4.ericy.com ([198.24.6.8]:45166 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590Ab1CGQg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 11:36:56 -0500
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Greg Schnorr <gschnorr@cisco.com>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH 2/2] hwmon: (pmbus) Continuously update temperature limit registers
Date: Mon, 7 Mar 2011 08:38:57 -0800
Message-ID: <1299515937-9138-3-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1299515937-9138-1-git-send-email-guenter.roeck@ericsson.com>
References: <1299515937-9138-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PMBus only has one set of limit registers for up to three temperature sensors.
Thus, changing a limit for one of the temperature sensors affects limits for
other temperature sensors in the same page (and potentially multiple pages
depending on the chip implementation). To handle this situation, re-read all
temperature limit registers when updating sensor data. This way, all affected
temperature limits are updated whenever the limit for a single sensor is
changed.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 drivers/hwmon/pmbus_core.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/pmbus_core.c b/drivers/hwmon/pmbus_core.c
index e9dda58..92540c9 100644
--- a/drivers/hwmon/pmbus_core.c
+++ b/drivers/hwmon/pmbus_core.c
@@ -1308,13 +1308,19 @@ static void pmbus_find_attributes(struct i2c_client *client,
 			 * Always compare current temperature against the limit
 			 * registers to determine alarm conditions for a
 			 * specific sensor.
+			 *
+			 * Since there is only one set of limit registers for
+			 * up to three temperature sensors, we need to update
+			 * all limit registers after the limit was changed for
+			 * one of the sensors. This ensures that correct limits
+			 * are reported for all temperature sensors.
 			 */
 			if (pmbus_check_word_register
 			    (client, page, PMBUS_UT_WARN_LIMIT)) {
 				i1 = data->num_sensors;
 				pmbus_add_sensor(data, "temp", "min", in_index,
 						 page, PMBUS_UT_WARN_LIMIT,
-						 PSC_TEMPERATURE, false);
+						 PSC_TEMPERATURE, true);
 				if (info->func[page] & PMBUS_HAVE_STATUS_TEMP) {
 					pmbus_add_boolean_cmp(data, "temp",
 						"min_alarm", in_index, i1, i0,
@@ -1329,7 +1335,7 @@ static void pmbus_find_attributes(struct i2c_client *client,
 				pmbus_add_sensor(data, "temp", "lcrit",
 						 in_index, page,
 						 PMBUS_UT_FAULT_LIMIT,
-						 PSC_TEMPERATURE, false);
+						 PSC_TEMPERATURE, true);
 				if (info->func[page] & PMBUS_HAVE_STATUS_TEMP) {
 					pmbus_add_boolean_cmp(data, "temp",
 						"lcrit_alarm", in_index, i1, i0,
@@ -1343,7 +1349,7 @@ static void pmbus_find_attributes(struct i2c_client *client,
 				i1 = data->num_sensors;
 				pmbus_add_sensor(data, "temp", "max", in_index,
 						 page, PMBUS_OT_WARN_LIMIT,
-						 PSC_TEMPERATURE, false);
+						 PSC_TEMPERATURE, true);
 				if (info->func[page] & PMBUS_HAVE_STATUS_TEMP) {
 					pmbus_add_boolean_cmp(data, "temp",
 						"max_alarm", in_index, i0, i1,
@@ -1357,7 +1363,7 @@ static void pmbus_find_attributes(struct i2c_client *client,
 				i1 = data->num_sensors;
 				pmbus_add_sensor(data, "temp", "crit", in_index,
 						 page, PMBUS_OT_FAULT_LIMIT,
-						 PSC_TEMPERATURE, false);
+						 PSC_TEMPERATURE, true);
 				if (info->func[page] & PMBUS_HAVE_STATUS_TEMP) {
 					pmbus_add_boolean_cmp(data, "temp",
 						"crit_alarm", in_index, i0, i1,
-- 
1.7.3.1

