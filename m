Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab1HAXij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:38:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38155 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280Ab1HAXY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:24:26 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:51 2011
Message-Id: <20110801232051.899071904@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [13/70] hwmon: (pmbus) Use long variables for register to data conversions
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Guenter Roeck <guenter.roeck@ericsson.com>

commit f450c1504d3ff6aace3927c805bdea0ac0669efd upstream.

Using integer variable types for register to data conversions can cause
overflows especially for power calculations, which are in microwatt.
Use long variables instead.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/pmbus_core.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/hwmon/pmbus_core.c
+++ b/drivers/hwmon/pmbus_core.c
@@ -355,8 +355,8 @@ static struct pmbus_data *pmbus_update_d
  * Convert linear sensor values to milli- or micro-units
  * depending on sensor type.
  */
-static int pmbus_reg2data_linear(struct pmbus_data *data,
-				 struct pmbus_sensor *sensor)
+static long pmbus_reg2data_linear(struct pmbus_data *data,
+				  struct pmbus_sensor *sensor)
 {
 	s16 exponent;
 	s32 mantissa;
@@ -390,15 +390,15 @@ static int pmbus_reg2data_linear(struct
 	else
 		val >>= -exponent;
 
-	return (int)val;
+	return val;
 }
 
 /*
  * Convert direct sensor values to milli- or micro-units
  * depending on sensor type.
  */
-static int pmbus_reg2data_direct(struct pmbus_data *data,
-				 struct pmbus_sensor *sensor)
+static long pmbus_reg2data_direct(struct pmbus_data *data,
+				  struct pmbus_sensor *sensor)
 {
 	long val = (s16) sensor->data;
 	long m, b, R;
@@ -433,12 +433,12 @@ static int pmbus_reg2data_direct(struct
 		R++;
 	}
 
-	return (int)((val - b) / m);
+	return (val - b) / m;
 }
 
-static int pmbus_reg2data(struct pmbus_data *data, struct pmbus_sensor *sensor)
+static long pmbus_reg2data(struct pmbus_data *data, struct pmbus_sensor *sensor)
 {
-	int val;
+	long val;
 
 	if (data->info->direct[sensor->class])
 		val = pmbus_reg2data_direct(data, sensor);
@@ -612,7 +612,7 @@ static int pmbus_get_boolean(struct pmbu
 	if (!s1 && !s2)
 		*val = !!regval;
 	else {
-		int v1, v2;
+		long v1, v2;
 		struct pmbus_sensor *sensor1, *sensor2;
 
 		sensor1 = &data->sensors[s1];
@@ -654,7 +654,7 @@ static ssize_t pmbus_show_sensor(struct
 	if (sensor->data < 0)
 		return sensor->data;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", pmbus_reg2data(data, sensor));
+	return snprintf(buf, PAGE_SIZE, "%ld\n", pmbus_reg2data(data, sensor));
 }
 
 static ssize_t pmbus_set_sensor(struct device *dev,


