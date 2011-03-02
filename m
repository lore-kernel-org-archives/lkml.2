Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab1CBFcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 00:32:33 -0500
Received: from imr3.ericy.com ([198.24.6.13]:40343 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384Ab1CBFcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 00:32:31 -0500
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>, Greg Schnorr <gschnorr@cisco.com>,
        <lm-sensors@lm-sensors.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH] hwmon: (pmbus) More stringent checking of VOUT_MODE register
Date: Tue, 1 Mar 2011 21:32:20 -0800
Message-ID: <1299043940-22798-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some PMBus chips do not support the VOUT_MODE register. To make matters worse,
such chips may not return an error when reading the register either, but instead
return 0xff.

Check if the register exists using pmbus_check_byte_register() before reading
its value. In addition, validate the returned value and ignore it if it is 0xff
(which is invalid).

Reported-by: Greg Schnorr <gschnorr@cisco.com>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 drivers/hwmon/pmbus_core.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/pmbus_core.c b/drivers/hwmon/pmbus_core.c
index 0edab1c..b7c64ba 100644
--- a/drivers/hwmon/pmbus_core.c
+++ b/drivers/hwmon/pmbus_core.c
@@ -1426,10 +1426,11 @@ static void pmbus_find_attributes(struct i2c_client *client,
 static int pmbus_identify_common(struct i2c_client *client,
 				 struct pmbus_data *data)
 {
-	int vout_mode, exponent;
+	int vout_mode = -1, exponent;
 
-	vout_mode = pmbus_read_byte_data(client, 0, PMBUS_VOUT_MODE);
-	if (vout_mode >= 0) {
+	if (pmbus_check_byte_register(client, 0, PMBUS_VOUT_MODE))
+		vout_mode = pmbus_read_byte_data(client, 0, PMBUS_VOUT_MODE);
+	if (vout_mode >= 0 && vout_mode != 0xff) {
 		/*
 		 * Not all chips support the VOUT_MODE command,
 		 * so a failure to read it is not an error.
-- 
1.7.3.1

