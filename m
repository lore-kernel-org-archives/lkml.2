Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850Ab2ANBkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 20:40:00 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48074 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab2ANBj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 20:39:57 -0500
MIME-Version: 1.0
Date: Fri, 13 Jan 2012 19:39:56 -0600
Message-ID: <CAPbJ=B=_Xubsni7R00kSotDQ9AE9jmhmyRV0gPkXGqAPGrNaXg@mail.gmail.com>
Subject: [RFC][PATCH 2/2] hwmon: (w83627ehf) Add GPIO port 3 functionality
From: Alex Rio <scasbyte@gmail.com>
To: khali@linux-fr.org, guenter.roeck@ericsson.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The w83627ehf chip has 5 GPIO ports, currently none of them is supported.
This patch adds the GPIO port 3 driver with the following functions:
set/get pin values, direction_in/out, set_debounce.
The values are also available to the userspace (if requiered)
in the path /sys/class/gpio by using the export/unexport functions.
Please look at the REVISIT comment, this is the main reason of the RFC,
suggestions will be highly appreciated.

Signed-off-by: Alex Rio <scasbyte@gmail.com>
---
 drivers/hwmon/w83627ehf.c |  188 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 188 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index 0e0af04..3c6ea1a 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -60,6 +60,7 @@
 #include <linux/mutex.h>
 #include <linux/acpi.h>
 #include <linux/io.h>
+#include <linux/gpio.h>
 #include "lm75.h"

 enum kinds {
@@ -88,6 +89,10 @@ module_param(fan_debounce, ushort, 0);
 MODULE_PARM_DESC(fan_debounce, "Enable debouncing for fan RPM signal");

 #define DRVNAME "w83627ehf"
+#define GPIO_NAME "w83627ehf-gpio"
+#define GPIO_IOSIZE		4
+
+static DEFINE_SPINLOCK(sio_lock);

 /*
  * Super-I/O constants and functions
@@ -115,6 +120,7 @@ MODULE_PARM_DESC(fan_debounce, "Enable debouncing
for fan RPM signal");
 #define SIO_NCT6776_ID		0xc330
 #define SIO_ID_MASK		0xFFF0

+
 static inline void
 superio_outb(int ioreg, int reg, int val)
 {
@@ -202,6 +208,31 @@ static const u16 W83627EHF_REG_TEMP_CONFIG[] = {
0, 0x152, 0x252, 0 };
 #define W83627EHF_REG_ALARM2		0x45A
 #define W83627EHF_REG_ALARM3		0x45B

+/* Register to configure both SPI and GPIO functionality */
+#define W83627EHF_SPI_GPIO_CONF		0x2A
+/* Multifunction configure register (some GPIO, VID, UART) */
+#define W83627EHF_MULTIFUNCT_1		0x2C
+
+/* GPIO logical devices and other stuff */
+#define W83627EHF_GPIO_2TO5		0x09 /* LD for GPIO2~5 */
+#define W83627EHF_GPIO6			0x07 /* LD for GPIO6 */
+#define W83627EHF_GPIO_DEFAULT_DATA	0xFF /* All 1s initially */
+#define W83627EHF_GPIO_DEFAULT_DIR	0xFF /* Initially all inputs */
+#define W83627EHF_GPIO_DEFAULT_TYPE	0xFF /* Initially debouncer enabled */
+
+/* Logical device 9 registers */
+#define W83627EHF_LD9_GPIO_2TO5_ENA	0x30 /* GPIO2~5 enable register */
+#define W83627EHF_LD9_GPIO3_DATA	0xF1
+#define W83627EHF_LD9_GPIO3_DIR		0xF0
+#define W83627EHF_LD9_GPIO3_TYPE	0xFE
+
+/* GPIO enable bits */
+#define W83627EHF_ENABLE_GPIO2		0x00 /* Not used */
+#define W83627EHF_ENABLE_GPIO3		0x02 /* Only GPIO 3 is implemented */
+#define W83627EHF_ENABLE_GPIO4		0x04 /* Not used */
+#define W83627EHF_ENABLE_GPIO5		0x08 /* Not used */
+#define W83627EHF_ENABLE_GPIO6		0x08 /* Not used */
+
 #define W83627EHF_REG_CASEOPEN_DET	0x42 /* SMI STATUS #2 */
 #define W83627EHF_REG_CASEOPEN_CLR	0x46 /* SMI MASK #3 */

@@ -501,6 +532,13 @@ struct w83627ehf_sio_data {
 	enum kinds kind;
 };

+/* REVISIT!: This is a global variable for sioreg.
+ * How could a function like gpio_get be able to access
+ * sioreg from w83627ehf_sio_data?
+ * Maybe we can make the sioreg global?
+ */
+int global_sioaddr;
+
 /*
  * On older chips, only registers 0x50-0x5f are banked.
  * On more recent chips, all registers are banked.
@@ -2505,6 +2543,108 @@ static struct platform_driver w83627ehf_driver = {
 	.remove		= __devexit_p(w83627ehf_remove),
 };

+static int w83627e_gpio_get(struct gpio_chip *gc, unsigned gpio_num)
+{
+	u8 reg_val, result;
+
+	spin_lock(&sio_lock);
+	superio_enter(global_sioaddr);
+	superio_select(global_sioaddr, W83627EHF_GPIO_2TO5);
+	/* get pin value */
+	reg_val = superio_inb(global_sioaddr, W83627EHF_LD9_GPIO3_DATA);
+	result = (reg_val >> gpio_num) & 0x1;
+	superio_exit(global_sioaddr);
+	spin_unlock(&sio_lock);
+
+	return result;
+}
+
+static int w83627e_gpio_direction_in(struct gpio_chip *gc, unsigned gpio_num)
+{
+	u8 reg_val;
+
+	spin_lock(&sio_lock);
+	superio_enter(global_sioaddr);
+	superio_select(global_sioaddr, W83627EHF_GPIO_2TO5);
+	/* set direction in */
+	reg_val = superio_inb(global_sioaddr, W83627EHF_LD9_GPIO3_DIR);
+	superio_outb(global_sioaddr, W83627EHF_LD9_GPIO3_DIR,
+		     (1 << gpio_num) | reg_val);
+	superio_exit(global_sioaddr);
+	spin_unlock(&sio_lock);
+
+	return 0;
+}
+
+static void w83627e_gpio_set(struct gpio_chip *gc,
+				unsigned gpio_num, int val)
+{
+	u8 reg_val;
+
+	spin_lock(&sio_lock);
+	superio_enter(global_sioaddr);
+	superio_select(global_sioaddr, W83627EHF_GPIO_2TO5);
+	/* gpio set */
+	reg_val = superio_inb(global_sioaddr, W83627EHF_LD9_GPIO3_DATA);
+	superio_outb(global_sioaddr, W83627EHF_LD9_GPIO3_DATA, val ?
+				(1 << gpio_num) | reg_val :
+				~(1 << gpio_num) & reg_val);
+	superio_exit(global_sioaddr);
+	spin_unlock(&sio_lock);
+}
+
+static int w83627e_gpio_direction_out(struct gpio_chip *gc,
+					unsigned gpio_num, int val)
+{
+	u8 reg_val;
+
+	spin_lock(&sio_lock);
+	superio_enter(global_sioaddr);
+	superio_select(global_sioaddr, W83627EHF_GPIO_2TO5);
+	/* set direction out */
+	reg_val = superio_inb(global_sioaddr,
+			      W83627EHF_LD9_GPIO3_DIR);
+	superio_outb(global_sioaddr, W83627EHF_LD9_GPIO3_DIR,
+		     ~(1 << gpio_num) & reg_val);
+	reg_val = superio_inb(global_sioaddr, W83627EHF_LD9_GPIO3_DIR);
+	superio_exit(global_sioaddr);
+	spin_unlock(&sio_lock);
+
+	return 0;
+}
+
+/* Debounce only available for GP30, 31 and 35 */
+static int w83627e_gpio_set_debounce(struct gpio_chip *gc,
+				unsigned gpio_num, unsigned deb_val)
+{
+	u8 reg_val;
+
+	spin_lock(&sio_lock);
+	superio_enter(global_sioaddr);
+	superio_select(global_sioaddr, W83627EHF_GPIO_2TO5);
+	/* set debounce */
+	reg_val = superio_inb(global_sioaddr, W83627EHF_LD9_GPIO3_TYPE);
+	if (gpio_num == 0 || gpio_num == 1 || gpio_num == 5) {
+		superio_outb(global_sioaddr, W83627EHF_LD9_GPIO3_TYPE,
+				deb_val ? ~(1 << gpio_num) & reg_val :
+				(1 << gpio_num) | reg_val);
+	}
+	superio_exit(global_sioaddr);
+	spin_unlock(&sio_lock);
+
+	return 0;
+}
+
+static struct gpio_chip w83627e_gpio_chip = {
+	.label			= GPIO_NAME,
+	.owner			= THIS_MODULE,
+	.get			= w83627e_gpio_get,
+	.direction_input	= w83627e_gpio_direction_in,
+	.set			= w83627e_gpio_set,
+	.direction_output	= w83627e_gpio_direction_out,
+	.set_debounce		= w83627e_gpio_set_debounce,
+};
+
 /* w83627ehf_find() looks for a '627 in the Super-I/O config space */
 static int __init w83627ehf_find(int sioaddr, unsigned short *addr,
 				 struct w83627ehf_sio_data *sio_data)
@@ -2521,6 +2661,8 @@ static int __init w83627ehf_find(int sioaddr,
unsigned short *addr,

 	u16 val;
 	const char *sio_name;
+	u8 reg_temp;
+	int err;

 	superio_enter(sioaddr);

@@ -2592,11 +2734,51 @@ static int __init w83627ehf_find(int sioaddr,
unsigned short *addr,
 		superio_outb(sioaddr, SIO_REG_ENABLE, val | 0x01);
 	}

+	/* Enable GPIO port 3 and write default values */
+	pr_info("Enabling GPIO3");
+
+	/* Enable share port 3 pins */
+	reg_temp = superio_inb(sioaddr,
+			W83627EHF_SPI_GPIO_CONF);
+	reg_temp = reg_temp & 0xFD;
+	superio_outb(sioaddr, W83627EHF_SPI_GPIO_CONF,
+			reg_temp);
+	reg_temp = superio_inb(sioaddr,
+			W83627EHF_MULTIFUNCT_1);
+	reg_temp = reg_temp & 0x1F;
+	superio_outb(sioaddr, W83627EHF_MULTIFUNCT_1,
+			reg_temp);
+
+	/* Select logical device 9 */
+	superio_select(sioaddr, W83627EHF_GPIO_2TO5);
+	/* All low */
+	superio_outb(sioaddr, W83627EHF_LD9_GPIO3_DATA,
+			W83627EHF_GPIO_DEFAULT_DATA);
+	/* All outputs intially */
+	superio_outb(sioaddr, W83627EHF_LD9_GPIO3_DIR,
+			W83627EHF_GPIO_DEFAULT_DIR);
+
+	superio_outb(sioaddr, W83627EHF_LD9_GPIO_2TO5_ENA,
+			0x03);
+
+	w83627e_gpio_chip.base = -1;
+	w83627e_gpio_chip.ngpio = 8;
+
+	err = gpiochip_add(&w83627e_gpio_chip);
+	if (err < 0)
+		goto gpiochip_add_err;
+
+	pr_info("GPIO chip added");
 	superio_exit(sioaddr);
 	pr_info("Found %s chip at %#x\n", sio_name, *addr);
 	sio_data->sioreg = sioaddr;
+	global_sioaddr = sioaddr;

 	return 0;
+
+gpiochip_add_err:
+	pr_info("Error adding GPIO chip");
+	return err;
 }

 /* when Super-I/O functions move to a separate file, the Super-I/O
@@ -2674,6 +2856,12 @@ exit:

 static void __exit sensors_w83627ehf_exit(void)
 {
+	int ret;
+
+	ret = gpiochip_remove(&w83627e_gpio_chip);
+	WARN(ret, "%s(): sensors_w83627ehf_exit() failed, ret=%d\n",
+		__func__, ret);
+
 	platform_device_unregister(pdev);
 	platform_driver_unregister(&w83627ehf_driver);
