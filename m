Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab0CTON1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:13:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59001 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab0CTONU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:13:20 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: kernel-janitors@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 20 Mar 2010 15:12:41 +0100
Message-Id: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.0
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: i2c-drivers: Remove dangling pointers
X-SA-Exim-Version: 4.2.1 (built Sat, 01 Aug 2009 12:09:26 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is a patch series fixing I2C drivers which free their private data
structure and leave the clientdata pointer dangling or do the cleanup in the
wrong order. All occurences were found using coccinelle [1] and the semantic
patch below. The matches have been reviewed, and sometimes adapted.

The complete series goes to linux-i2c and kernel-janitors. The rest of the CCs
is handled per patch using get_maintainers.pl (which always adds LKML, so you
have the complete series there, too).

Please review, comment, apply!

Kind regards,

   Wolfram

[1] http://coccinelle.lip6.fr/

===

@@
type T;
identifier client, data;
@@

// Check if function uses clientdata
(
	i2c_set_clientdata(client, data);
|
	data = i2c_get_clientdata(client);
|
	T data = i2c_get_clientdata(client);
)
// Anything inbetween
	...
// Check if clientdata gets NULLed before data is freed
(
	i2c_set_clientdata(client, NULL);
	...
 	kfree(data);
|
+	i2c_set_clientdata(client, NULL);
 	kfree(data);
	...
-	i2c_set_clientdata(client, NULL);
|
+	i2c_set_clientdata(client, NULL);
? 	kfree(data);
)

===

 drivers/gpio/adp5588-gpio.c                   |    1 +
 drivers/gpio/max732x.c                        |    1 +
 drivers/gpio/pca953x.c                        |    1 +
 drivers/gpio/pcf857x.c                        |    7 ++++---
 drivers/hwmon/ad7414.c                        |    2 ++
 drivers/hwmon/ad7418.c                        |    2 ++
 drivers/hwmon/adm1021.c                       |    2 ++
 drivers/hwmon/adm1025.c                       |    2 ++
 drivers/hwmon/adm1026.c                       |    2 ++
 drivers/hwmon/adm1029.c                       |    2 ++
 drivers/hwmon/adm1031.c                       |    2 ++
 drivers/hwmon/adm9240.c                       |    2 ++
 drivers/hwmon/ads7828.c                       |    5 ++++-
 drivers/hwmon/adt7462.c                       |    2 ++
 drivers/hwmon/adt7470.c                       |    2 ++
 drivers/hwmon/adt7475.c                       |    2 ++
 drivers/hwmon/amc6821.c                       |    2 ++
 drivers/hwmon/asb100.c                        |    2 ++
 drivers/hwmon/atxp1.c                         |    2 ++
 drivers/hwmon/dme1737.c                       |    2 ++
 drivers/hwmon/ds1621.c                        |    2 ++
 drivers/hwmon/f75375s.c                       |    4 ++--
 drivers/hwmon/g760a.c                         |    4 ++--
 drivers/hwmon/gl518sm.c                       |    2 ++
 drivers/hwmon/gl520sm.c                       |    2 ++
 drivers/hwmon/lm63.c                          |    2 ++
 drivers/hwmon/lm77.c                          |    2 ++
 drivers/hwmon/lm78.c                          |    2 ++
 drivers/hwmon/lm80.c                          |    2 ++
 drivers/hwmon/lm83.c                          |    2 ++
 drivers/hwmon/lm85.c                          |    2 ++
 drivers/hwmon/lm87.c                          |    2 ++
 drivers/hwmon/lm90.c                          |    2 ++
 drivers/hwmon/lm92.c                          |    2 ++
 drivers/hwmon/lm93.c                          |    2 ++
 drivers/hwmon/lm95241.c                       |    1 +
 drivers/hwmon/ltc4215.c                       |    2 ++
 drivers/hwmon/ltc4245.c                       |    2 ++
 drivers/hwmon/max1619.c                       |    2 ++
 drivers/hwmon/max6650.c                       |    2 ++
 drivers/hwmon/pcf8591.c                       |    6 +++++-
 drivers/hwmon/smsc47m192.c                    |    2 ++
 drivers/hwmon/thmc50.c                        |    2 ++
 drivers/hwmon/tmp401.c                        |    1 +
 drivers/hwmon/w83791d.c                       |    2 ++
 drivers/hwmon/w83792d.c                       |    2 ++
 drivers/hwmon/w83793.c                        |    1 +
 drivers/hwmon/w83l785ts.c                     |    2 ++
 drivers/hwmon/w83l786ng.c                     |    2 ++
 drivers/input/keyboard/lm8323.c               |    2 ++
 drivers/input/keyboard/qt2160.c               |    2 +-
 drivers/input/touchscreen/mcs5000_ts.c        |    2 +-
 drivers/input/touchscreen/tsc2007.c           |    1 +
 drivers/leds/leds-lp3944.c                    |    2 +-
 drivers/leds/leds-pca9532.c                   |    4 ++--
 drivers/leds/leds-pca955x.c                   |    4 ++--
 drivers/macintosh/therm_adt746x.c             |    2 ++
 drivers/media/radio/radio-tea5764.c           |    2 ++
 drivers/media/radio/si470x/radio-si470x-i2c.c |    2 +-
 drivers/media/video/cs5345.c                  |    1 +
 drivers/media/video/cs53l32a.c                |    1 +
 drivers/media/video/ir-kbd-i2c.c              |    2 ++
 drivers/media/video/tda9840.c                 |    1 +
 drivers/media/video/tea6415c.c                |    1 +
 drivers/media/video/tea6420.c                 |    1 +
 drivers/media/video/ths7303.c                 |    1 +
 drivers/mfd/88pm860x-i2c.c                    |    1 +
 drivers/mfd/ab3100-core.c                     |    2 ++
 drivers/mfd/da903x.c                          |    1 +
 drivers/mfd/menelaus.c                        |    3 ++-
 drivers/mfd/pcf50633-core.c                   |    1 +
 drivers/mfd/tps65010.c                        |    2 +-
 drivers/mfd/wm8350-i2c.c                      |    2 ++
 drivers/misc/ad525x_dpot.c                    |    2 +-
 drivers/misc/eeprom/at24.c                    |    2 +-
 drivers/misc/eeprom/eeprom.c                  |    6 +++++-
 drivers/misc/eeprom/max6875.c                 |    2 ++
 drivers/misc/ics932s401.c                     |    2 ++
 drivers/misc/isl29003.c                       |    6 +++++-
 drivers/misc/tsl2550.c                        |    6 +++++-
 drivers/mtd/maps/pismo.c                      |    8 +++++++-
 drivers/power/bq27x00_battery.c               |    2 ++
 drivers/power/ds2782_battery.c                |    4 ++--
 drivers/regulator/max1586.c                   |    2 +-
 drivers/regulator/max8649.c                   |    3 ++-
 drivers/regulator/max8660.c                   |    2 +-
 drivers/rtc/rtc-ds1307.c                      |    2 ++
 drivers/rtc/rtc-fm3130.c                      |    2 ++
 drivers/rtc/rtc-m41t80.c                      |    2 ++
 drivers/rtc/rtc-pcf8563.c                     |    2 ++
 drivers/rtc/rtc-pcf8583.c                     |    2 ++
 drivers/rtc/rtc-rs5c372.c                     |    2 ++
 drivers/rtc/rtc-s35390a.c                     |    4 ++--
 drivers/staging/dream/synaptics_i2c_rmi.c     |    2 ++
 drivers/staging/go7007/wis-saa7113.c          |    1 +
 drivers/staging/go7007/wis-saa7115.c          |    1 +
 drivers/staging/go7007/wis-tw9903.c           |    1 +
 drivers/staging/iio/adc/max1363_core.c        |    2 ++
 drivers/staging/iio/light/tsl2563.c           |    2 ++
 drivers/usb/otg/isp1301_omap.c                |    5 ++++-
 drivers/video/matrox/matroxfb_maven.c         |    1 +
 drivers/w1/masters/ds2482.c                   |    2 ++
 102 files changed, 198 insertions(+), 33 deletions(-)

