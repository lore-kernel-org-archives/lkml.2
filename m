Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab0J3Kkw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 06:40:52 -0400
Received: from dyn60-31.dsl.spy.dnainternet.fi ([83.102.60.31]:43760 "EHLO
	shogun.pilppa.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752839Ab0J3Kkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 06:40:47 -0400
X-Greylist: delayed 625 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Oct 2010 06:40:46 EDT
Date: Sat, 30 Oct 2010 13:30:19 +0300 (EEST)
From: Mika Laitio <lamikr@pilppa.org>
To: linux-kernel@vger.kernel.org
cc: johnpol@2ka.mipt.ru
Subject: [PATCH] DS2423 w1 counter driver and documentation
Message-ID: <Pine.LNX.4.64.1010300247360.10143@shogun.pilppa.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Attached is 1-wire/w1 DS2423 slave driver for reading the values from all 
4 counters available DS2423 devices by using standard w1_slave file. 
In ds2423 the counters are tied to ram pages 12-15 in 
and each of those ram-pages. Each of these counter values (and 
asoociated ram page values) are represented as a own 
line in w1_slave file. Driver has been tested on mips and x86.

usage example:
cat /sys/bus/w1/devices/1d-00000009b964/w1_slave

00 02 00 00 00 00 00 00 00 6d 38 00 ff ff 00 00 fe ff 00 00 ff ff 00 00 ff 
ff 00 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff crc=YES c=2
00 02 00 00 00 00 00 00 00 e0 1f 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff 
ff 00 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff crc=YES c=2
00 5a 0e 5f 18 00 00 00 00 0b 28 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff 
ff 00 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff crc=YES c=408882778
00 05 00 00 00 00 00 00 00 8d 39 ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff crc=YES c=5

Patch includes also the documentation.

terveisin

      Mika


Signed-off-by: Mika Laitio <lamikr@pilppa.org>
---
  Documentation/w1/slaves/00-INDEX  |    2 +
  Documentation/w1/slaves/w1_ds2423 |   47 +++++++++++
  drivers/w1/slaves/Kconfig         |   10 ++
  drivers/w1/slaves/Makefile        |    1 +
  drivers/w1/slaves/w1_ds2423.c     |  166 +++++++++++++++++++++++++++++++++++++
  drivers/w1/w1_family.h            |    1 +
  6 files changed, 227 insertions(+), 0 deletions(-)
  create mode 100644 Documentation/w1/slaves/w1_ds2423
  create mode 100644 drivers/w1/slaves/w1_ds2423.c

diff --git a/Documentation/w1/slaves/00-INDEX b/Documentation/w1/slaves/00-INDEX
index f8101d6..75613c9 100644
--- a/Documentation/w1/slaves/00-INDEX
+++ b/Documentation/w1/slaves/00-INDEX
@@ -2,3 +2,5 @@
  	- This file
  w1_therm
  	- The Maxim/Dallas Semiconductor ds18*20 temperature sensor.
+w1_ds2423
+	- The Maxim/Dallas Semiconductor ds2423 counter device.
diff --git a/Documentation/w1/slaves/w1_ds2423 b/Documentation/w1/slaves/w1_ds2423
new file mode 100644
index 0000000..90a65d2
--- /dev/null
+++ b/Documentation/w1/slaves/w1_ds2423
@@ -0,0 +1,47 @@
+Kernel driver w1_ds2423
+=======================
+
+Supported chips:
+  * Maxim DS2423 based counter devices.
+
+supported family codes:
+	W1_THERM_DS2423	0x1D
+
+Author: Mika Laitio <lamikr@pilppa.org>
+
+Description
+-----------
+
+Support is provided through the sysfs w1_slave file. Each opening and
+read sequence of w1_slave file initiates the read of counters and ram
+available in DS2423 pages 12 - 15.
+
+Result of each page is provided as an ASCII output where each counter
+value and associated ram buffer is outpputed to own line.
+
+Each lines will contain the values of 42 bytes read from the counter and
+memory page along the crc=YES or NO for indicating whether the read operation
+was successfull and CRC matched.
+If the operation was successfull, there is also in the end of each line
+a counter value expressed as an integer after c=
+
+Meaning of 42 bytes represented is following:
+ - 1 byte from ram page
+ - 4 bytes for the counter value
+ - 4 zero bytes
+ - 2 bytes for crc16 which was calculated from the data read since the previous crc bytes
+ - 31 remaining bytes from the ram page
+ - crc=YES/NO indicating whether read was ok and crc matched
+ - c=<int> current counter value
+
+example from the successfull read:
+00 02 00 00 00 00 00 00 00 6d 38 00 ff ff 00 00 fe ff 00 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff crc=YES c=2
+00 02 00 00 00 00 00 00 00 e0 1f 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff crc=YES c=2
+00 29 c6 5d 18 00 00 00 00 04 37 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff crc=YES c=408798761
+00 05 00 00 00 00 00 00 00 8d 39 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff crc=YES c=5
+
+example from the read with crc errors:
+00 02 00 00 00 00 00 00 00 6d 38 00 ff ff 00 00 fe ff 00 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff crc=YES c=2
+00 02 00 00 22 00 00 00 00 e0 1f 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff crc=NO
+00 e1 61 5d 19 00 00 00 00 df 0b 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff 00 00 ff ff crc=NO
+00 05 00 00 20 00 00 00 00 8d 39 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff crc=NO
diff --git a/drivers/w1/slaves/Kconfig b/drivers/w1/slaves/Kconfig
index 1f51366..27f44c2 100644
--- a/drivers/w1/slaves/Kconfig
+++ b/drivers/w1/slaves/Kconfig
@@ -16,6 +16,16 @@ config W1_SLAVE_SMEM
  	  Say Y here if you want to connect 1-wire
  	  simple 64bit memory rom(ds2401/ds2411/ds1990*) to your wire.

+config W1_SLAVE_DS2423
+	tristate "Counter 1-wire device (DS2423)"
+	help
+	  If you enable this you can read the counter values available
+	  in the DS2423 chipset from the w1_slave file under the
+	  sys file system.
+
+	  Say Y here if you want to use a 1-wire
+	  counter family device (DS2423).
+
  config W1_SLAVE_DS2431
  	tristate "1kb EEPROM family support (DS2431)"
  	help
diff --git a/drivers/w1/slaves/Makefile b/drivers/w1/slaves/Makefile
index f1f51f1..3c76350 100644
--- a/drivers/w1/slaves/Makefile
+++ b/drivers/w1/slaves/Makefile
@@ -4,6 +4,7 @@

  obj-$(CONFIG_W1_SLAVE_THERM)	+= w1_therm.o
  obj-$(CONFIG_W1_SLAVE_SMEM)	+= w1_smem.o
+obj-$(CONFIG_W1_SLAVE_DS2423)	+= w1_ds2423.o
  obj-$(CONFIG_W1_SLAVE_DS2431)	+= w1_ds2431.o
  obj-$(CONFIG_W1_SLAVE_DS2433)	+= w1_ds2433.o
  obj-$(CONFIG_W1_SLAVE_DS2760)	+= w1_ds2760.o
diff --git a/drivers/w1/slaves/w1_ds2423.c b/drivers/w1/slaves/w1_ds2423.c
new file mode 100644
index 0000000..7a7dbe5
--- /dev/null
+++ b/drivers/w1/slaves/w1_ds2423.c
@@ -0,0 +1,166 @@
+/*
+ *	w1_ds2423.c
+ *
+ * Copyright (c) 2010 Mika Laitio <lamikr@pilppa.org>
+ *
+ * This driver will read and write the value of 4 counters to w1_slave file in
+ * sys filesystem.
+ * Inspired by the w1_therm and w1_ds2431 drivers.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the therms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/device.h>
+#include <linux/types.h>
+#include <linux/delay.h>
+#include <linux/crc16.h>
+
+#include "../w1.h"
+#include "../w1_int.h"
+#include "../w1_family.h"
+
+#define CRC16_VALID	0xb001
+#define CRC16_INIT	0
+
+#define COUNTER_COUNT 4
+#define READ_BYTE_COUNT 42
+
+static ssize_t w1_counter_read(struct device *device,
+	struct device_attribute *attr, char *buf);
+
+static struct device_attribute w1_counter_attr =
+	__ATTR(w1_slave, S_IRUGO, w1_counter_read, NULL);
+
+static ssize_t w1_counter_read(struct device *device,
+	struct device_attribute *attr, char *out_buf)
+{
+	struct w1_slave *sl = dev_to_w1_slave(device);
+	struct w1_master *dev = sl->master;
+	u8 rbuf[COUNTER_COUNT * READ_BYTE_COUNT];
+	u8 wrbuf[3];
+	int rom_addr;
+	int read_byte_count;
+	int result;
+	ssize_t c;
+	int ii;
+	int p;
+	int crc;
+
+	c		= PAGE_SIZE;
+	rom_addr	= (12 << 5) + 31;
+	wrbuf[0]	= 0xA5;
+	wrbuf[1]	= rom_addr & 0xFF;
+	wrbuf[2]	= rom_addr >> 8;
+	mutex_lock(&dev->mutex);
+	if (!w1_reset_select_slave(sl)) {
+		w1_write_block(dev, wrbuf, 3);
+		read_byte_count = 0;
+		for (p = 0; p < 4; p++) {
+			/*
+			 * 1 byte for first bytes in ram page read
+			 * 4 bytes for counter
+			 * 4 bytes for zero bits
+			 * 2 bytes for crc
+			 * 31 remaining bytes from the ram page
+			 */
+			read_byte_count += w1_read_block(dev,
+				rbuf + (p * READ_BYTE_COUNT), READ_BYTE_COUNT);
+			for (ii = 0; ii < READ_BYTE_COUNT; ++ii)
+				c -= snprintf(out_buf + PAGE_SIZE - c,
+					c, "%02x ",
+					rbuf[(p * READ_BYTE_COUNT) + ii]);
+			if (read_byte_count != (p + 1) * READ_BYTE_COUNT) {
+				dev_warn(device,
+					"w1_counter_read() returned %u bytes "
+					"instead of %d bytes wanted.\n",
+					read_byte_count,
+					READ_BYTE_COUNT);
+				c -= snprintf(out_buf + PAGE_SIZE - c,
+					c, "crc=NO\n");
+			} else {
+				if (p == 0) {
+					crc = crc16(CRC16_INIT, wrbuf, 3);
+					crc = crc16(crc, rbuf, 11);
+				} else {
+					/*
+					 * DS2423 calculates crc from all bytes
+					 * read after the previous crc bytes.
+					 */
+					crc = crc16(CRC16_INIT,
+						(rbuf + 11) +
+						((p - 1) * READ_BYTE_COUNT),
+						READ_BYTE_COUNT);
+				}
+				if (crc == CRC16_VALID) {
+					result = 0;
+					for (ii = 4; ii > 0; ii--) {
+						result <<= 8;
+						result |= rbuf[(p *
+							READ_BYTE_COUNT) + ii];
+					}
+					c -= snprintf(out_buf + PAGE_SIZE - c,
+						c, "crc=YES c=%d\n", result);
+				} else {
+					c -= snprintf(out_buf + PAGE_SIZE - c,
+						c, "crc=NO\n");
+				}
+			}
+		}
+	} else {
+		c -= snprintf(out_buf + PAGE_SIZE - c, c, "Connection error");
+	}
+	mutex_unlock(&dev->mutex);
+	return PAGE_SIZE - c;
+}
+
+static int w1_f1d_add_slave(struct w1_slave *sl)
+{
+	return device_create_file(&sl->dev, &w1_counter_attr);
+}
+
+static void w1_f1d_remove_slave(struct w1_slave *sl)
+{
+	device_remove_file(&sl->dev, &w1_counter_attr);
+}
+
+static struct w1_family_ops w1_f1d_fops = {
+	.add_slave      = w1_f1d_add_slave,
+	.remove_slave   = w1_f1d_remove_slave,
+};
+
+static struct w1_family w1_family_1d = {
+	.fid = W1_COUNTER_DS2423,
+	.fops = &w1_f1d_fops,
+};
+
+static int __init w1_f1d_init(void)
+{
+	return w1_register_family(&w1_family_1d);
+}
+
+static void __exit w1_f1d_exit(void)
+{
+	w1_unregister_family(&w1_family_1d);
+}
+
+module_init(w1_f1d_init);
+module_exit(w1_f1d_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mika Laitio <lamikr@pilppa.org>");
+MODULE_DESCRIPTION("w1 family 1d driver for DS2423, 4 counters and 4kb ram");
diff --git a/drivers/w1/w1_family.h b/drivers/w1/w1_family.h
index 3ca1b92..f3b636d 100644
--- a/drivers/w1/w1_family.h
+++ b/drivers/w1/w1_family.h
@@ -30,6 +30,7 @@
  #define W1_FAMILY_SMEM_01	0x01
  #define W1_FAMILY_SMEM_81	0x81
  #define W1_THERM_DS18S20 	0x10
+#define W1_COUNTER_DS2423	0x1D
  #define W1_THERM_DS1822  	0x22
  #define W1_EEPROM_DS2433  	0x23
  #define W1_THERM_DS18B20 	0x28
-- 
1.7.1



