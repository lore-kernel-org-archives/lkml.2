Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946505Ab2CPXls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:41:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39045 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946492Ab2CPXll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:41:41 -0400
Message-Id: <20120316233814.308629950@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:38:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Vivek Gani <vgani@intersil.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [ 41/41] hwmon: (zl6100) Enable interval between chip accesses for all chips
In-Reply-To: <20120316233829.GA14022@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <guenter.roeck@ericsson.com>

commit fecfb64422d91a9621a3f96ab75c3a5f13e80b58 upstream.

Intersil reports that all chips supported by the zl6100 driver require
an interval between chip accesses, even ZL2004 and ZL6105 which were thought
to be safe.

Reported-by: Vivek Gani <vgani@intersil.com>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/hwmon/zl6100   |   14 ++++++--------
 drivers/hwmon/pmbus/zl6100.c |   11 +++--------
 2 files changed, 9 insertions(+), 16 deletions(-)

--- a/Documentation/hwmon/zl6100
+++ b/Documentation/hwmon/zl6100
@@ -73,14 +73,12 @@ Module parameters
 delay
 -----
 
-Some Intersil/Zilker Labs DC-DC controllers require a minimum interval between
-I2C bus accesses. According to Intersil, the minimum interval is 2 ms, though
-1 ms appears to be sufficient and has not caused any problems in testing.
-The problem is known to affect ZL6100, ZL2105, and ZL2008. It is known not to
-affect ZL2004 and ZL6105. The driver automatically sets the interval to 1 ms
-except for ZL2004 and ZL6105. To enable manual override, the driver provides a
-writeable module parameter, 'delay', which can be used to set the interval to
-a value between 0 and 65,535 microseconds.
+Intersil/Zilker Labs DC-DC controllers require a minimum interval between I2C
+bus accesses. According to Intersil, the minimum interval is 2 ms, though 1 ms
+appears to be sufficient and has not caused any problems in testing. The problem
+is known to affect all currently supported chips. For manual override, the
+driver provides a writeable module parameter, 'delay', which can be used to set
+the interval to a value between 0 and 65,535 microseconds.
 
 
 Sysfs entries
--- a/drivers/hwmon/pmbus/zl6100.c
+++ b/drivers/hwmon/pmbus/zl6100.c
@@ -178,16 +178,11 @@ static int zl6100_probe(struct i2c_clien
 	data->id = mid->driver_data;
 
 	/*
-	 * ZL2008, ZL2105, and ZL6100 are known to require a wait time
-	 * between I2C accesses. ZL2004 and ZL6105 are known to be safe.
-	 *
-	 * Only clear the wait time for chips known to be safe. The wait time
-	 * can be cleared later for additional chips if tests show that it
-	 * is not needed (in other words, better be safe than sorry).
+	 * According to information from the chip vendor, all currently
+	 * supported chips are known to require a wait time between I2C
+	 * accesses.
 	 */
 	data->delay = delay;
-	if (data->id == zl2004 || data->id == zl6105)
-		data->delay = 0;
 
 	/*
 	 * Since there was a direct I2C device access above, wait before


