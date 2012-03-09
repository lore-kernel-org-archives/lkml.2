Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305Ab2CIUOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:14:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48917 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031140Ab2CITt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:49:56 -0500
Message-Id: <20120309190208.679598175@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:21 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <khali@linux-fr.org>
Subject: [ 79/95] hwmon: (zl6100) Maintain delay parameter in driver instance data
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 7ad6307ad6968ce25cecf209d4822d4c722be030 upstream.

A global delay parameter has the side effect of being overwritten with 0 if a
single ZL2004 or ZL6105 is instantiated. If other chips supported by the same
driver are in the system, this will result in access errors for those chips.

To solve the problem, keep a per-instance copy of the delay parameter, and do
not change the original parameter.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/pmbus/zl6100.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/hwmon/pmbus/zl6100.c
+++ b/drivers/hwmon/pmbus/zl6100.c
@@ -33,6 +33,7 @@ enum chips { zl2004, zl2006, zl2008, zl2
 struct zl6100_data {
 	int id;
 	ktime_t access;		/* chip access time */
+	int delay;		/* Delay between chip accesses in uS */
 	struct pmbus_driver_info info;
 };
 
@@ -49,10 +50,10 @@ MODULE_PARM_DESC(delay, "Delay between c
 /* Some chips need a delay between accesses */
 static inline void zl6100_wait(const struct zl6100_data *data)
 {
-	if (delay) {
+	if (data->delay) {
 		s64 delta = ktime_us_delta(ktime_get(), data->access);
-		if (delta < delay)
-			udelay(delay - delta);
+		if (delta < data->delay)
+			udelay(data->delay - delta);
 	}
 }
 
@@ -184,8 +185,9 @@ static int zl6100_probe(struct i2c_clien
 	 * can be cleared later for additional chips if tests show that it
 	 * is not needed (in other words, better be safe than sorry).
 	 */
+	data->delay = delay;
 	if (data->id == zl2004 || data->id == zl6105)
-		delay = 0;
+		data->delay = 0;
 
 	/*
 	 * Since there was a direct I2C device access above, wait before


