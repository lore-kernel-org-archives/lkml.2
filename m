Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933609Ab2FASGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 14:06:25 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:40582 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932480Ab2FASGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 14:06:18 -0400
From: Mathias Leblanc <matthias.leblanc@gmail.com>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        Grant Likely <grant.likely@secretlab.ca>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <tpmdd-devel@lists.sourceforge.net>
Cc: Mathias Leblanc <mathias.leblanc@st.com>
Subject: [PATCH 1/1] TPM: STMicroelectronics ST33 I2C/SPI & ST19 I2C
Date: Fri,  1 Jun 2012 20:06:00 +0200
Message-Id: <1338573960-12425-1-git-send-email-mathias.leblanc@st.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 * STMicroelectronics version 1.2.0, Copyright (C) 2010
 * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
 * This is free software, and you are welcome to redistribute it
 * under certain conditions.

This is the driver for TPM chip from ST Microelectronics.

If you have a TPM security chip from STMicroelectronics working with
an I2C/SPI, in menuconfig or .config choose the tpm driver on
device --> tpm and activate the protocol of your choice before compiling
the kernel.
The driver will be accessible from within Linux.

Tested on linux x86/x64 and beagleboard REV B & XM REV C

Signed-off-by: Mathias Leblanc <mathias.leblanc@st.com>
---
 arch/arm/mach-omap2/board-omap3beagle.c |   58 ++
 drivers/char/tpm/Kconfig                |   32 +-
 drivers/char/tpm/Makefile               |    2 +
 drivers/char/tpm/tpm_stm_st19_i2c.c     |  560 ++++++++++++++
 drivers/char/tpm/tpm_stm_st19_i2c.h     |   52 ++
 drivers/char/tpm/tpm_stm_st33_i2c.c     | 1200 +++++++++++++++++++++++++++++
 drivers/char/tpm/tpm_stm_st33_i2c.h     |   76 ++
 drivers/char/tpm/tpm_stm_st33_spi.c     | 1285 +++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm_stm_st33_spi.h     |   80 ++
 include/linux/i2c/tpm_stm_st19_i2c.h    |   42 +
 include/linux/i2c/tpm_stm_st33_i2c.h    |   48 ++
 include/linux/spi/tpm_stm_st33_spi.h    |   46 ++
 12 files changed, 3473 insertions(+), 8 deletions(-)
 create mode 100644 drivers/char/tpm/tpm_stm_st19_i2c.c
 create mode 100644 drivers/char/tpm/tpm_stm_st19_i2c.h
 create mode 100644 drivers/char/tpm/tpm_stm_st33_i2c.c
 create mode 100644 drivers/char/tpm/tpm_stm_st33_i2c.h
 create mode 100644 drivers/char/tpm/tpm_stm_st33_spi.c
 create mode 100644 drivers/char/tpm/tpm_stm_st33_spi.h
 create mode 100644 include/linux/i2c/tpm_stm_st19_i2c.h
 create mode 100644 include/linux/i2c/tpm_stm_st33_i2c.h
 create mode 100644 include/linux/spi/tpm_stm_st33_spi.h

diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index 7be8d65..80b2280 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -48,6 +48,15 @@
 #include <plat/usb.h>
 #include <plat/omap_device.h>
 
+#ifdef CONFIG_TCG_ST33_I2C
+#include <linux/i2c/tpm_stm_st33_i2c.h>
+#endif /* CONFIG_TCG_ST33_I2C */
+
+#ifdef CONFIG_TCG_ST33_SPI
+#include <linux/spi/tpm_stm_st33_spi.h>
+#include <linux/spi/spi.h>
+#endif /* CONFIG_TCG_ST33_SPI */
+
 #include "mux.h"
 #include "hsmmc.h"
 #include "pm.h"
@@ -374,6 +383,35 @@ static struct i2c_board_info __initdata beagle_i2c_eeprom[] = {
        },
 };
 
+#if defined CONFIG_TCG_ST33_I2C || defined CONFIG_TCG_ST33_SPI
+static struct st33zp24_platform_data tpm_data = {
+        .io_serirq = 137,
+        .io_lpcpd  = 143,
+};
+#endif
+
+#ifdef CONFIG_TCG_ST33_I2C
+static struct i2c_board_info __initdata tpm_st33_i2c_board_info[] = {
+        {
+                I2C_BOARD_INFO(TPM_ST33_I2C, TPM_I2C_ST33_ADDR_WR_LOC0),
+                .platform_data = &tpm_data,
+        },
+};
+#endif
+
+#ifdef CONFIG_TCG_ST33_SPI
+static struct  spi_board_info tpm_st33_spi_board_info[] = {
+        {
+                .modalias = TPM_ST33_SPI,
+                .max_speed_hz = 10000000,
+                .bus_num = 4,
+                .chip_select = 0,
+                .mode = SPI_MODE_0,
+                .platform_data = &tpm_data,
+        },
+};
+#endif
+
 static int __init omap3_beagle_i2c_init(void)
 {
 	omap3_pmic_get_config(&beagle_twldata,
@@ -553,6 +591,26 @@ static void __init omap3_beagle_init(void)
 	omap_mux_init_signal("sdrc_cke1", OMAP_PIN_OUTPUT);
 
 	beagle_display_init();
+	#if defined CONFIG_TCG_ST33_I2C || defined CONFIG_TCG_ST33_SPI
+		omap_mux_init_gpio(tpm_data.io_serirq, OMAP_PIN_INPUT);
+		omap_mux_init_gpio(tpm_data.io_lpcpd, OMAP_PIN_OUTPUT);
+	#endif
+
+	#ifdef CONFIG_TCG_ST33_I2C
+		omap_mux_init_signal("i2c2_scl", OMAP_PIN_INPUT);
+		omap_mux_init_signal("i2c2_sda", OMAP_PIN_INPUT);
+		omap_register_i2c_bus(2, 400, tpm_st33_i2c_board_info, ARRAY_SIZE(tpm_st33_i2c_board_info));
+	#endif
+
+	#ifdef CONFIG_TCG_ST33_SPI
+		omap_mux_init_signal("mcspi4_clk", OMAP_PIN_INPUT);
+		omap_mux_init_signal("mcspi4_cs0", OMAP_PIN_OUTPUT);
+		omap_mux_init_signal("mcspi4_simo", OMAP_PIN_OUTPUT);
+		omap_mux_init_signal("mcspi4_somi", OMAP_PIN_INPUT);
+
+		spi_register_board_info(tpm_st33_spi_board_info, ARRAY_SIZE(tpm_st33_spi_board_info));
+	#endif
+
 	beagle_opp_init();
 }
 
diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index a048199..7384c93 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -5,6 +5,7 @@
 menuconfig TCG_TPM
 	tristate "TPM Hardware Support"
 	depends on HAS_IOMEM
+	depends on EXPERIMENTAL
 	select SECURITYFS
 	---help---
 	  If you have a TPM security chip in your system, which
@@ -16,17 +17,14 @@ menuconfig TCG_TPM
 	  obtained at: <http://sourceforge.net/projects/trousers>.  To 
 	  compile this driver as a module, choose M here; the module 
 	  will be called tpm. If unsure, say N.
-	  Notes:
-	  1) For more TPM drivers enable CONFIG_PNP, CONFIG_ACPI
+	  Note: For more TPM drivers enable CONFIG_PNP, CONFIG_ACPI
 	  and CONFIG_PNPACPI.
-	  2) Without ACPI enabled, the BIOS event log won't be accessible,
-	  which is required to validate the PCR 0-7 values.
 
 if TCG_TPM
 
 config TCG_TIS
 	tristate "TPM Interface Specification 1.2 Interface"
-	depends on X86
+	depends on PNP
 	---help---
 	  If you have a TPM security chip that is compliant with the
 	  TCG TIS 1.2 TPM specification say Yes and it will be accessible
@@ -35,7 +33,6 @@ config TCG_TIS
 
 config TCG_NSC
 	tristate "National Semiconductor TPM Interface"
-	depends on X86
 	---help---
 	  If you have a TPM security chip from National Semiconductor 
 	  say Yes and it will be accessible from within Linux.  To 
@@ -44,7 +41,6 @@ config TCG_NSC
 
 config TCG_ATMEL
 	tristate "Atmel TPM Interface"
-	depends on PPC64 || HAS_IOPORT
 	---help---
 	  If you have a TPM security chip from Atmel say Yes and it 
 	  will be accessible from within Linux.  To compile this driver 
@@ -60,6 +56,26 @@ config TCG_INFINEON
 	  To compile this driver as a module, choose M here; the module
 	  will be called tpm_infineon.
 	  Further information on this driver and the supported hardware
-	  can be found at http://www.trust.rub.de/projects/linux-device-driver-infineon-tpm/ 
+	  can be found at http://www.prosec.rub.de/tpm
+
+config TCG_ST33_I2C
+        tristate "STMicroelectronics ST33 I2C TPM with locality 0 & 4"
+        depends on I2C
+        depends on GPIOLIB
+        ---help---
+        If you have a TPM security chip from STMicroelectronics working with
+        an I2C bus say Yes and it will be accessible from within Linux.
+        To compile this driver as a module, choose M here; the module will be
+        called tpm_stm_st33_i2c.
+
+config TCG_ST33_SPI
+	tristate "STMicroelectronics ST33 SPI"
+	depends on SPI
+	depends on GPIOLIB
+	---help---
+	If you have a TPM security chip from STMicroelectronics working with
+	an SPI bus say Yes and it will be accessible from within Linux.
+	To compile this driver as a module, choose M here; the module will be
+	called tpm_stm_st33_spi.
 
 endif # TCG_TPM
diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index ea3a1e0..8d3449f 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -9,3 +9,5 @@ obj-$(CONFIG_TCG_TIS) += tpm_tis.o
 obj-$(CONFIG_TCG_NSC) += tpm_nsc.o
 obj-$(CONFIG_TCG_ATMEL) += tpm_atmel.o
 obj-$(CONFIG_TCG_INFINEON) += tpm_infineon.o
+obj-$(CONFIG_TCG_ST33_I2C) += tpm_stm_st33_i2c.o
+obj-$(CONFIG_TCG_ST33_SPI) += tpm_stm_st33_spi.o 
diff --git a/drivers/char/tpm/tpm_stm_st19_i2c.c b/drivers/char/tpm/tpm_stm_st19_i2c.c
new file mode 100644
index 0000000..c8f9ed7
--- /dev/null
+++ b/drivers/char/tpm/tpm_stm_st19_i2c.c
@@ -0,0 +1,560 @@
+/*
+ * STMicroelectronics TPM I2C Linux driver for TPM ST19NP18
+ * Copyright (C) 2009, 2010  STMicroelectronics
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * STMicroelectronics version 1.2.0, Copyright (C) 2010
+ * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
+ * This is free software, and you are welcome to redistribute it
+ * under certain conditions.
+ *
+ * @Author: Christophe RICARD tpmsupport@st.com
+ *
+ * @File: tpm_stm_st19_i2c.c
+ *
+ * @Synopsis:
+ * ----------------------------------------------------------------------
+ *	02/12/2008
+ *	- Stand alone implementation (without any TPM api)
+ * ----------------------------------------------------------------------
+ *	03/02/2010
+ *	- Power management (suspend and resume functions)
+ *	implementation
+ * ----------------------------------------------------------------------
+ *	03/19/2010
+ *	- Use of the linux kernel TPM api --> driver/char/tpm
+ * ----------------------------------------------------------------------
+ *	05/26/2010
+ *	- Update code for code submission and bug fixes:
+ *	- Comments spelling fixes
+ *	- Lindent script execution
+ *	- checkpatch.pl script execution
+ *	- fix syslog error when loaded as a module:
+ *	 "release() function missing and must be fixed"
+ *	- name files change from
+ *	  stm_st19_tpm_i2c to tpm_stm_st19_i2c
+ * ----------------------------------------------------------------------
+ *	06/15/2010
+ *	- Update for new tpm core device.
+ *	num_opens --> is_open
+ * ----------------------------------------------------------------------
+ *	07/08/2010
+ *	- Update probe, resume suspend functions
+ *	- Fix issue suspend buffer and work around related to the
+ *	chip->data_buffer not allocated.
+ * ----------------------------------------------------------------------
+ *	09/03/2010
+ *	- Review under LKLM
+ *	- Patches from Joe Perches after review which fix some break and
+ *	some neatings.
+ * ----------------------------------------------------------------------
+ *	09/16/2010
+ *	- Remove unaccurate comment.
+ * ----------------------------------------------------------------------
+ *	01/12/2011
+ *	- update ioctl function to unlocked_ioctl for kernel >= 2.6.36
+ *	- Some cleaning
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/wait.h>
+#include <linux/string.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/sysfs.h>
+#include <linux/gpio.h>
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/version.h>
+
+#include <linux/i2c/tpm_stm_st19_i2c.h>
+
+#include "tpm.h"
+
+#include "tpm_stm_st19_i2c.h"
+
+#ifdef DEBUG
+#define FUNC_ENTER() pr_info("%s\n", __func__)
+#else
+#define FUNC_ENTER() do {} while (0)
+#endif
+
+static struct st19np18_platform_data *pin_infos;
+
+#define TPM_STS_DATA_AVAIL 0x10
+#define TPM_STS_ACCEPT_COMMAND 0x01
+#define TPM_STS_CANCEL (TPM_STS_DATA_AVAIL | TPM_STS_ACCEPT_COMMAND)
+
+/*
+ * gpio_readpin is a wrapper to read a gpio value.
+ * Use generic gpio APIs
+ * @param: pin_id, the pin identifier where the value will be read.
+ * @return: the gpio value (should be 0 or 1) or negative errno
+ */
+static int gpio_readpin(int pin_id)
+{
+	int ret;
+	ret = gpio_direction_input(pin_id);
+	if (ret == 0)
+		return gpio_get_value(pin_id);
+	return ret;
+}
+
+/*
+ * tpm_stm_i2c_status return the TPM state
+ */
+static u8 tpm_stm_i2c_status(struct tpm_chip *chip)
+{
+	u8 state_data, state_command;
+
+	state_data = gpio_readpin(pin_infos->data_avail_pin);
+	state_command = gpio_readpin(pin_infos->accept_pin);
+
+	return (state_data << 4) | state_command;
+}
+
+/*
+ * tpm_stm_i2c_send send TPM commands through the I2C bus.
+ * Before sending any TPM commands, tpm_stm_i2c_send poll data_available and
+ * accept_command TPM GPIOs.
+ *
+ * In case the data_available is high (logical value 1), tpm_stm_i2c_send will
+ * empty the TPM FIFO by reading all the datas stored inside the TPM.
+ *
+ * Then, if the accept_command TPM GPIO is high(logical value 1)
+ * tpm_stm_i2c_send will first send the 10 bytes header of the TCG commands and
+ * then send the others bytes by 40 bytes blocks.
+ *
+ * data_available and accept_command TPM GPIOs will goes low when the TPM
+ * compute the command.
+ *
+ * @param: chip, the tpm_chip description as specified in driver/char/tpm/tpm.h.
+ * @param: buf,	the buffer to send.
+ * @param: count, the number of bytes to send.
+ * @return: In case of success the number of bytes sent.
+ *			In other case, a < 0 value describing the issue.
+ */
+static int tpm_stm_i2c_send(struct tpm_chip *chip, unsigned char *buf,
+			    size_t count)
+{
+	u32 ret = 0, i, size, ordinal;
+	struct i2c_client *client;
+
+	FUNC_ENTER();
+
+	if (chip == NULL)
+		return -EBUSY;
+
+	if (count < TPM_HEADER_SIZE)
+		return -EBUSY;
+
+	client = (struct i2c_client *)pin_infos->client;
+
+	ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
+
+	size = TPM_HEADER_SIZE;
+	i = 0;
+	while (i < size && wait_for_tpm_stat(chip, TPM_STS_ACCEPT_COMMAND,
+					     TPM_I2C_SHORT,
+					     &chip->vendor.int_queue) == 0) {
+		int bytes;
+
+		if (i == 0)
+			bytes = TPM_HEADER_SIZE;
+		else
+			bytes = min_t(int, count - i, TPM_I2C_BLOCK_SIZE);
+
+		if (i == 0) {
+			size = be32_to_cpu(*(__be32 *) (buf + 2));
+			size = size < count ? size : count;
+		}
+		if (count < TPM_HEADER_SIZE)
+			bytes = count;
+		ret = i2c_master_send(client, buf + i, bytes);
+		if (ret < 0) {
+			pr_info("Failed to send data\n");
+			goto end;
+		}
+
+		if (i == 0)
+			i += TPM_HEADER_SIZE;
+		else
+			i += TPM_I2C_BLOCK_SIZE;
+	}
+
+	if (i == 0) {
+		pr_info("Failed to read gpio pin (AcceptCmd)\n");
+		ret = -EIO;
+	}
+end:
+	return ret ? ret : count;
+}
+
+/*
+ * tpm_stm_i2c_recv received TPM response through the I2C bus.
+ * Before receiving any TPM response, tpm_stm_i2c_recv poll data_available and
+ * accept_command TPM GPIOs.
+ *
+ * In case the accept_command is high (logical value 1), tpm_stm_i2c_recv will
+ * do nothing.
+ *
+ * Then, if the data_available TPM GPIO is high(logical value 1)
+ * tpm_stm_i2c_recv will first receive the 10 bytes header of the TCG TPM
+ * response and then receive the others bytes by 40 bytes blocks.
+ *
+ * accept_command TPM GPIOs will goes high when the TPM Fifo is empty.
+ *
+ * @param: chip, the tpm_chip description as specified in driver/char/tpm/tpm.h.
+ * @param: buf,	the buffer to store datas.
+ * @param: count, the number of bytes to send.
+ * @return: In case of success the number of bytes received.
+ *			In other case, a < 0 value describing the issue.
+ */
+static int tpm_stm_i2c_recv(struct tpm_chip *chip, unsigned char *buf,
+			    size_t count)
+{
+	int ret = 0;
+	int i, size;
+	struct i2c_client *client;
+
+	FUNC_ENTER();
+
+	if (chip == NULL)
+		return -EBUSY;
+	if (count < TPM_HEADER_SIZE)
+		return -EBUSY;
+
+	client = (struct i2c_client *)pin_infos->client;
+
+	size = TPM_HEADER_SIZE;
+	i = 0;
+	while (i < size && wait_for_tpm_stat(chip, TPM_STS_DATA_AVAIL,
+					     TPM_I2C_SHORT,
+					     &chip->vendor.read_queue) == 0) {
+		int bytes;
+
+		if (count < TPM_HEADER_SIZE)
+			bytes = count;
+		else if (i == 0)
+			bytes = TPM_HEADER_SIZE;
+		else
+			bytes = min_t(int, size - i, TPM_I2C_BLOCK_SIZE);
+
+		ret = i2c_master_recv(client, buf + i, bytes);
+		if (ret < 0) {
+			pr_info(" Failed to read gpio pin (DataAvailable)\n");
+			goto end;
+		}
+
+		if (!buf) {
+			pr_info("read buffer is NULL\n");
+			goto end;
+		}
+
+		if (i == 0) {
+			size = be32_to_cpu(*(__be32 *) (buf + 2));
+			if (size > count)
+				size = count;
+			i += TPM_HEADER_SIZE;
+		} else
+			i += TPM_I2C_BLOCK_SIZE;
+	}
+
+	if (i == 0) {
+		pr_info("Failed to read gpio pin (DataAvailable)\n");
+		ret = -EIO;
+		goto end;
+	}
+	return size;
+end:
+	return ret;
+}
+
+/*
+ * tpm_stm_i2c_cancel, cancel is not implemented.
+ * @param: chip, the tpm_chip description as specified in driver/char/tpm/tpm.h.
+ */
+static void tpm_stm_i2c_cancel(struct tpm_chip *chip)
+{
+}
+
+/*
+ * tpm_st19_i2c_ioctl provides 2 handles:
+ * - TPMIOC_CANCEL: allow to CANCEL a TPM commands execution.
+ *   See tpm_stm_i2c_cancel description above
+ * - TPMIOC_TRANSMIT: allow to transmit a TPM commands.
+ *
+ * @return: In case of success, return TPM response size.
+ * In other case return < 0 value describing the issue.
+ */
+static long tpm_stm_i2c_ioctl(struct file *file,
+			      unsigned int cmd, unsigned long arg)
+{
+	int in_size = 0, out_size = 0, ret = -ENOTTY;
+	struct tpm_chip *chip = file->private_data;
+
+	switch (cmd) {
+	case TPMIOC_CANCEL:
+		tpm_stm_i2c_cancel(chip);
+		ret = -ENOSYS;
+		break;
+	case TPMIOC_TRANSMIT:
+		if (copy_from_user(chip->data_buffer,
+				   (const char *)arg, TPM_HEADER_SIZE)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		in_size = be32_to_cpu(*(__be32 *) (chip->data_buffer + 2));
+		if (copy_from_user(chip->data_buffer,
+				   (const char *)arg, in_size)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		tpm_stm_i2c_send(chip, chip->data_buffer, in_size);
+
+		out_size = tpm_stm_i2c_recv(chip, chip->data_buffer,
+					    TPM_BUFSIZE);
+		if (copy_to_user((char *)arg, chip->data_buffer, out_size)) {
+			ret = -EFAULT;
+			break;
+		}
+		ret = out_size;
+		break;
+	}
+	return ret;
+}
+
+static const struct file_operations tpm_st19_i2c_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.read = tpm_read,
+	.unlocked_ioctl = tpm_stm_i2c_ioctl,
+	.write = tpm_write,
+	.open = tpm_open,
+	.release = tpm_release,
+};
+
+static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
+static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
+static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
+static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
+static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
+static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated, NULL);
+static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps_1_2, NULL);
+static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
+
+static struct attribute *stm_tpm_attrs[] = {
+	&dev_attr_pubek.attr,
+	&dev_attr_pcrs.attr,
+	&dev_attr_enabled.attr,
+	&dev_attr_active.attr,
+	&dev_attr_owned.attr,
+	&dev_attr_temp_deactivated.attr,
+	&dev_attr_caps.attr,
+	&dev_attr_cancel.attr, NULL,
+};
+
+static struct attribute_group stm_tpm_attr_grp = {
+	.attrs = stm_tpm_attrs
+};
+
+static struct tpm_vendor_specific st_i2c_tpm = {
+	.send = tpm_stm_i2c_send,
+	.recv = tpm_stm_i2c_recv,
+	.cancel = tpm_stm_i2c_cancel,
+	.status = tpm_stm_i2c_status,
+	.req_complete_mask = TPM_STS_DATA_AVAIL,
+	.req_complete_val = TPM_STS_DATA_AVAIL,
+	.req_canceled = TPM_STS_CANCEL,
+	.attr_group = &stm_tpm_attr_grp,
+	.miscdev = {.fops = &tpm_st19_i2c_fops,},
+};
+
+/*
+ * tpm_st19_i2c_probe initialize the TPM device
+ * @param: client, the i2c_client drescription (TPM I2C description).
+ * @param: id, the i2c_device_id struct.
+ * @return: 0 in case of success.
+ *			-1 in other case.
+ */
+static int
+tpm_st19_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
+{
+	int err;
+	struct tpm_chip *chip;
+	struct st19np18_platform_data *platform_data;
+
+	FUNC_ENTER();
+
+	err = 0;
+
+	/* Check I2C platform functionnalities */
+	if (client == NULL) {
+		pr_info("client is NULL. exiting.\n");
+		err = -ENODEV;
+		goto end;
+	}
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		pr_info("client not i2c capable\n");
+		err = -ENODEV;
+		goto end;
+	}
+
+	chip = tpm_register_hardware(&client->dev, &st_i2c_tpm);
+	if (!chip) {
+		err = -ENODEV;
+		goto end;
+	}
+
+	platform_data = client->dev.platform_data;
+	pin_infos = platform_data;
+	platform_data->client = client;
+
+	chip->vendor.timeout_a = msecs_to_jiffies(TPM_I2C_SHORT);
+	chip->vendor.timeout_b = msecs_to_jiffies(TPM_I2C_SHORT);
+	chip->vendor.timeout_c = msecs_to_jiffies(TPM_I2C_SHORT);
+	chip->vendor.timeout_d = msecs_to_jiffies(TPM_I2C_SHORT);
+
+	/* Register GPIO pin through generic Linux GPIO API */
+	err = gpio_request(platform_data->accept_pin, "accept command");
+	if (err)
+		goto _gpio_init;
+
+	err = gpio_request(platform_data->data_avail_pin, "data available");
+	if (err)
+		goto _gpio_init;
+
+	tpm_get_timeouts(chip);
+	tpm_continue_selftest(chip);
+
+	/* attach chip datas to client */
+	i2c_set_clientdata(client, chip);
+
+	pr_info("TPM I2C Initialized\n");
+	return 0;
+_gpio_init:
+	if (platform_data) {
+		gpio_free(platform_data->accept_pin);
+		gpio_free(platform_data->data_avail_pin);
+	}
+	tpm_remove_hardware(chip->dev);
+end:
+	i2c_set_clientdata(client, NULL);
+	pr_info("TPM I2C initialisation fail\n");
+	return err;
+}
+
+/*
+ * tpm_st19_i2c_remove remove the TPM device
+ * @param: client, the i2c_client drescription (TPM I2C description).
+		clear_bit(0, &chip->is_open);
+ * @return: 0 in case of success.
+ */
+static __devexit int tpm_st19_i2c_remove(struct i2c_client *client)
+{
+	struct tpm_chip *chip = (struct tpm_chip *)i2c_get_clientdata(client);
+	FUNC_ENTER();
+
+	if (pin_infos != NULL) {
+		gpio_free(pin_infos->accept_pin);
+		gpio_free(pin_infos->data_avail_pin);
+	}
+
+	/* Check if chip has been previously clean */
+	if (chip != NULL)
+		tpm_remove_hardware(chip->dev);
+
+	return 0;
+}
+
+/*
+ * tpm_st19_i2c_pm_suspend suspend the TPM device
+ * @param: client, the i2c_client drescription (TPM I2C description).
+ * @param: mesg, the power management message.
+ * @return: 0 in case of success.
+ */
+static int tpm_st19_i2c_pm_suspend(struct i2c_client *client, pm_message_t mesg)
+{
+	return tpm_pm_suspend(&client->dev, mesg);
+}
+
+/*
+ * tpm_st19_i2c_pm_resume resume the TPM device
+ * @param: client, the i2c_client drescription (TPM I2C description).
+ * @return: 0 in case of success.
+ */
+static int tpm_st19_i2c_pm_resume(struct i2c_client *client)
+{
+	return tpm_pm_resume(&client->dev);
+}				/* tpm_st19_i2c_pm_resume() */
+
+static const struct i2c_device_id tpm_st19_i2c_id[] = {
+	{TPM_DRIVER_NAME, 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, tpm_st19_i2c_id);
+
+static struct i2c_driver tpm_st19_i2c_driver = {
+	.driver = {
+		   .owner = THIS_MODULE,
+		   .name = TPM_DRIVER_NAME,
+		   },
+	.probe = tpm_st19_i2c_probe,
+	.remove = tpm_st19_i2c_remove,
+	.resume = tpm_st19_i2c_pm_resume,
+	.suspend = tpm_st19_i2c_pm_suspend,
+	.id_table = tpm_st19_i2c_id
+};
+
+/*
+ * tpm_st19_i2c_init initialize driver
+ * @return: 0 if successful, else non zero value.
+ */
+static int __init tpm_st19_i2c_init(void)
+{
+	FUNC_ENTER();
+	return i2c_add_driver(&tpm_st19_i2c_driver);
+}
+
+/*
+ * tpm_st19_i2c_exit The kernel calls this function during unloading the
+ * module or during shut down process
+ */
+static void __exit tpm_st19_i2c_exit(void)
+{
+	FUNC_ENTER();
+	i2c_del_driver(&tpm_st19_i2c_driver);
+}
+
+module_init(tpm_st19_i2c_init);
+module_exit(tpm_st19_i2c_exit);
+
+MODULE_AUTHOR("Christophe Ricard (tpmsupport@st.com)");
+MODULE_DESCRIPTION("STM TPM I2C ST19 Driver");
+MODULE_VERSION("1.2.0");
+MODULE_LICENSE("GPL");
diff --git a/drivers/char/tpm/tpm_stm_st19_i2c.h b/drivers/char/tpm/tpm_stm_st19_i2c.h
new file mode 100644
index 0000000..d79fa0d
--- /dev/null
+++ b/drivers/char/tpm/tpm_stm_st19_i2c.h
@@ -0,0 +1,52 @@
+/*
+ * STMicroelectronics TPM I2C Linux driver for TPM ST19NP18
+ * Copyright (C) 2009, 2010  STMicroelectronics
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * STMicroelectronics version 1.2.0, Copyright (C) 2010
+ * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
+ * This is free software, and you are welcome to redistribute it
+ * under certain conditions.
+ *
+ * @Author: Christophe RICARD tpmsupport@st.com
+ *
+ * @File: stm_st19_tpm_i2c.h
+ *
+ * @Date: 02/12/2008
+ */
+#ifndef __STM_ST19_TPM_I2C_MAIN_H__
+#define __STM_ST19_TPM_I2C_MAIN_H__
+
+#include <linux/pci.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/i2c.h>
+/*#include <linux/i2c-id.h>*/
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+
+#define TPM_BUFSIZE		2048
+#define TPM_HEADER_SIZE		10
+#define TPM_I2C_BLOCK_SIZE	0x28
+
+#define TPM_I2C_SHORT		2000	/* 2s */
+#define STARTUP_WAIT_INTERVAL	8	/* 8ms */
+
+/* ioctl commands */
+#define TPMIOC_CANCEL		_IO('T', 0x00)	/* Not supported */
+#define TPMIOC_TRANSMIT		_IO('T', 0x01)
+
+#endif /* __STM_ST19_TPM_I2C_MAIN_H__ */
diff --git a/drivers/char/tpm/tpm_stm_st33_i2c.c b/drivers/char/tpm/tpm_stm_st33_i2c.c
new file mode 100644
index 0000000..b4cbbc5
--- /dev/null
+++ b/drivers/char/tpm/tpm_stm_st33_i2c.c
@@ -0,0 +1,1200 @@
+/*
+ * STMicroelectronics TPM I2C Linux driver for TPM ST33ZP24
+ * Copyright (C) 2009, 2010  STMicroelectronics
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * STMicroelectronics version 1.2.0, Copyright (C) 2010
+ * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
+ * This is free software, and you are welcome to redistribute it
+ * under certain conditions.
+ *
+ * @Author: Christophe RICARD tpmsupport@st.com
+ *
+ * @File: tpm_stm_st33_i2c.c
+ *
+ * @Synopsis:
+ * 	09/15/2010:	First shot driver tpm_tis driver for lpc is used as model.
+ */
+
+#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+//#include <linux/i2c-id.h>
+#include <linux/wait.h>
+#include <linux/string.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/sysfs.h>
+#include <linux/gpio.h>
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+
+#include <linux/i2c/tpm_stm_st33_i2c.h>
+
+#include "tpm.h"
+
+#include "tpm_stm_st33_i2c.h"
+
+#ifdef DEBUG
+#define FUNC_ENTER()	pr_info("%s\n", __func__)
+#else
+#define	FUNC_ENTER()	do{}	while(0)
+#endif
+
+enum stm33zp24_access {
+        TPM_ACCESS_VALID = 0x80,
+        TPM_ACCESS_ACTIVE_LOCALITY = 0x20,
+        TPM_ACCESS_REQUEST_PENDING = 0x04,
+        TPM_ACCESS_REQUEST_USE = 0x02,
+};
+
+enum stm33zp24_status {
+        TPM_STS_VALID = 0x80,
+        TPM_STS_COMMAND_READY = 0x40,
+        TPM_STS_GO = 0x20,
+        TPM_STS_DATA_AVAIL = 0x10,
+        TPM_STS_DATA_EXPECT = 0x08,
+};
+
+enum stm33zp24_int_flags {
+	TPM_GLOBAL_INT_ENABLE = 0x80,
+        TPM_INTF_CMD_READY_INT = 0x080,	
+	TPM_INTF_FIFO_AVALAIBLE_INT = 0x040,
+	TPM_INTF_WAKE_UP_READY_INT = 0x020, 
+	TPM_INTF_LOC4SOFTRELEASE_INT = 0x008,	
+	TPM_INTF_LOCALITY_CHANGE_INT = 0x004,
+        TPM_INTF_STS_VALID_INT = 0x002,
+        TPM_INTF_DATA_AVAIL_INT = 0x001,
+};
+
+enum tis_defaults {
+        TIS_SHORT_TIMEOUT = 750,        /* ms */
+        TIS_LONG_TIMEOUT = 2000,        /* 2 sec */
+};
+
+//static DEFINE_SPINLOCK(tpm_stm_st33_lock);
+
+/*
+ * write8_reg
+ * Send byte to the TIS register according to the ST33ZP24 I2C protocol.
+ * @param: tpm_register, the tpm tis register where the data should be written
+ * @param: tpm_data, the tpm_data to write inside the tpm_register
+ * @param: tpm_size, The length of the data
+ * @return: number of byte written successfully: should be one if success.
+ */
+static int write8_reg(struct i2c_client* client, u8 tpm_register, 
+		      u8* tpm_data, u16 tpm_size)
+{
+	u8 data; 
+	int value = 0;
+	struct st33zp24_platform_data* pin_infos;
+
+	FUNC_ENTER();
+	pin_infos = client->dev.platform_data;
+
+	data = tpm_register;
+	memcpy(pin_infos->tpm_i2c_buffer[0], &data, sizeof(data));
+	memcpy(pin_infos->tpm_i2c_buffer[0] + 1, tpm_data, tpm_size);
+	value = i2c_master_send(client, pin_infos->tpm_i2c_buffer[0], tpm_size + 1);
+	return value;
+}/* write8_reg() */
+
+/*
+ * read8_reg
+ * Recv byte from the TIS register according to the ST33ZP24 I2C protocol.
+ * @param: tpm_register, the tpm tis register where the data should be read
+ * @param: tpm_data, the TPM response
+ * @param: tpm_size, tpm TPM response size to read.
+ * @return: number of byte read successfully: should be one if success.
+ */
+static int read8_reg(struct i2c_client* client, u8 tpm_register, 
+		    u8* tpm_data, int tpm_size )
+{
+	u8 status = 0;
+	u8 data;
+	struct st33zp24_platform_data* pin_infos;
+
+	FUNC_ENTER();
+	pin_infos = client->dev.platform_data;
+
+	data = TPM_DUMMY_BYTE;
+	status = write8_reg(client, tpm_register, &data, 1);
+	if (status == 2 )
+		status = i2c_master_recv(client, tpm_data, tpm_size);
+	return status;
+}/* read8_reg() */
+
+/*
+ * I2C_WRITE_DATA
+ * Send byte to the TIS register according to the ST33ZP24 I2C protocol.
+ * @param: tpm, the chip description
+ * @param: tpm_register, the tpm tis register where the data should be written
+ * @param: tpm_data, the tpm_data to write inside the tpm_register
+ * @param: tpm_size, The length of the data
+ * @return: number of byte written successfully: should be one if success.
+ */
+static int I2C_WRITE_DATA(struct i2c_client* client, u8 tpm_register, 
+			 u8* tpm_data, u16 tpm_size)
+{
+	u8 value = 0;
+	//unsigned long flags;	
+
+	FUNC_ENTER();	
+
+        //spin_lock_irqsave(&tpm_stm_st33_lock, flags);	
+	value = write8_reg(client, tpm_register | TPM_WRITE_DIRECTION, tpm_data, tpm_size);
+	//spin_unlock_irqrestore(&tpm_stm_st33_lock, flags);
+	return value;
+}/* I2C_WRITE_DATA() */
+
+/*
+ * I2C_READ_DATA
+ * Recv byte from the TIS register according to the ST33ZP24 I2C protocol.
+ * @param: tpm, the chip description
+ * @param: tpm_register, the tpm tis register where the data should be read
+ * @param: tpm_data, the TPM response
+ * @param: tpm_size, tpm TPM response size to read.
+ * @return: number of byte read successfully: should be one if success.
+ */
+static int I2C_READ_DATA(struct i2c_client* client, u8 tpm_register,
+			 u8* tpm_data, u16 tpm_size)
+{
+	u8 value = 0;
+	//unsigned long flags;	
+
+	FUNC_ENTER();	
+
+        //spin_lock_irqsave(&tpm_stm_st33_lock, flags);	
+	value = read8_reg(client, tpm_register, tpm_data, tpm_size); 
+	//spin_unlock_irqrestore(&tpm_stm_st33_lock, flags); 
+	return value;
+}/* I2C_READ_DATA () */
+
+/*
+ * clear_interruption
+ * clear the TPM interrupt register.
+ * @param: tpm, the chip description
+ */
+static void clear_interruption(struct i2c_client* client)
+{
+        u8 interrupt;
+        I2C_READ_DATA(client, TPM_INT_STATUS, &interrupt, 1);
+        /* Clear interrupts handled with TPM_EOI */
+        I2C_WRITE_DATA(client, TPM_INT_STATUS, &interrupt, 1);
+        I2C_READ_DATA(client, TPM_INT_STATUS, &interrupt, 1);
+}/* clear_interruption() */
+
+/*
+ * _wait_for_interrupt_serirq_timeout
+ * @param: tpm, the chip description
+ * @param: timeout, the timeout of the interrupt
+ * @return: the status of the interruption.
+ */
+static int _wait_for_interrupt_serirq_timeout(struct tpm_chip* chip, unsigned long timeout)
+{
+        unsigned long status;
+        struct i2c_client *client;
+        struct st33zp24_platform_data* pin_infos;
+
+        FUNC_ENTER();
+
+        client = (struct i2c_client *) chip->vendor.iobase;
+        pin_infos = client->dev.platform_data;
+
+        status = wait_for_completion_interruptible_timeout(&pin_infos->irq_detection, timeout);
+        if ( status > 0 )
+                enable_irq(gpio_to_irq(pin_infos->io_serirq));
+        gpio_direction_input(pin_infos->io_serirq);
+
+        return status;
+}/* wait_for_interrupt_serirq_timeout() */
+
+#define wait_for_serirq_timeout(chip, condition, timeout) \
+({ \
+        unsigned long status = 2; \
+        struct i2c_client *client; \
+        struct st33zp24_platform_data* pin_infos; \
+\
+        client = (struct i2c_client *) chip->vendor.iobase; \
+        pin_infos = client->dev.platform_data;  \
+\
+        status = _wait_for_interrupt_serirq_timeout(chip, timeout); \
+        if (!status) \
+        { \
+                status = -EBUSY; \
+                goto wait_end; \
+        } \
+        clear_interruption(client);     \
+        if (condition) \
+                status = 1; \
+\
+wait_end: \
+        status;\
+}) 
+
+/*
+ * tpm_stm_i2c_cancel, cancel is not implemented.
+ * @param: chip, the tpm_chip description as specified in driver/char/tpm/tpm.h.
+ */
+static void tpm_stm_i2c_cancel(struct tpm_chip *chip)
+{
+	struct i2c_client* client;
+	u8 data;	
+
+	client = (struct i2c_client *) chip->vendor.iobase;
+
+	FUNC_ENTER();	
+
+	/* this causes the current command to be aborted */
+	data = TPM_STS_COMMAND_READY;
+        I2C_WRITE_DATA(client, TPM_STS, &data, 1);
+        if ( chip->vendor.irq )
+                wait_for_serirq_timeout(chip, 1, chip->vendor.timeout_a);
+}	/* tpm_stm_i2c_cancel() */
+
+/*
+ * tpm_stm_spi_status return the TPM_STS register 
+ * @param: chip, the tpm chip description
+ * @return: the TPM_STS register value.
+ */
+static u8 tpm_stm_i2c_status(struct tpm_chip *chip)
+{
+	struct i2c_client* client;
+	u8 data;	
+	client = (struct i2c_client *) chip->vendor.iobase;
+
+	FUNC_ENTER();	
+
+	I2C_READ_DATA(client, TPM_STS, &data, 1);	
+	return data;
+}				/* tpm_stm_i2c_status() */
+
+/*
+ * responseSize return the command size
+ * @param: buffer, command buffer.
+ * @param: size, the buffer size.
+ * @return: the command size.
+ */
+static int responseSize(const char *buffer, size_t size)
+{
+	size_t val = 0;
+
+	FUNC_ENTER();	
+
+	if (size >= TPM_HEADER_SIZE) {
+		val = (size_t) (((unsigned)buffer[2]) << 24
+				| ((unsigned)buffer[3]) << 16
+				| ((unsigned)buffer[4]) << 8 | (unsigned)
+				buffer[5]);
+	}
+
+	if (val < TPM_BUFSIZE)
+		return val;
+	else
+		return TPM_BUFSIZE;
+}
+
+/*
+ * check_locality if the locality is active 
+ * @param: chip, the tpm chip description
+ * @return: the active locality or -EACCESS.
+ */
+static int check_locality(struct tpm_chip* chip)
+{
+	struct i2c_client* client;
+	u8 data;
+	u8 status;
+
+	FUNC_ENTER();	
+
+	client = (struct i2c_client *) chip->vendor.iobase;
+
+	status = I2C_READ_DATA(client, TPM_ACCESS, &data, 1);
+	if ( status && (data &  
+		(TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==  
+		(TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID) )
+		return chip->vendor.locality;
+
+	return -EACCES;
+	
+}/* check_locality() */
+
+/*
+ * request_locality request the TPM locality
+ * @param: chip, the chip description
+ * @return: the active locality or EACCESS.
+ */
+static int request_locality(struct tpm_chip* chip)
+{
+	unsigned long stop;
+	long rc;
+	struct i2c_client* client; 
+	u8 data;
+
+	FUNC_ENTER();
+
+	client = (struct i2c_client *) chip->vendor.iobase;
+	
+	/* Check locality */
+	if ( check_locality(chip) == chip->vendor.locality )
+		return chip->vendor.locality;	
+	
+	/* Request locality */
+	data = TPM_ACCESS_REQUEST_USE;
+	rc = I2C_WRITE_DATA(client, TPM_ACCESS, &data, 1);
+	if ( rc < 0)
+		goto end;
+
+	/* If request locality succeed return l else -EACCES */ 
+	/* wait for burstcount */
+	if (chip->vendor.irq) {
+                rc = wait_for_serirq_timeout(chip, (check_locality
+                                                       (chip) >= 0),
+                                                      chip->vendor.timeout_a);
+                if (rc > 0)
+                        return chip->vendor.locality;
+        } else {
+	        stop = jiffies + chip->vendor.timeout_a;
+        	do {
+        		if (check_locality(chip) >= 0)
+                		return chip->vendor.locality;
+	                msleep(TPM_TIMEOUT);
+        	}
+	        while (time_before(jiffies, stop));
+	}
+	rc = -EACCES;
+end:
+	return rc;
+}/* request_locality() */
+
+/*
+ * release_locality release the active locality
+ * @param: chip, the tpm chip description.
+ */
+static void release_locality(struct tpm_chip *chip)
+{
+	struct i2c_client* client; 
+	u8 data;
+
+	FUNC_ENTER();
+
+	client = (struct i2c_client *) chip->vendor.iobase; 
+	data = TPM_ACCESS_ACTIVE_LOCALITY;
+
+        I2C_WRITE_DATA(client, TPM_ACCESS, &data, 1);
+}
+
+/*
+ * get_burstcount return the burstcount address 0x19 0x1A
+ * @param: chip, the chip description
+ * return: the burstcount.
+ */
+static int get_burstcount(struct tpm_chip *chip)
+{
+        unsigned long stop;
+        int burstcnt, status;
+	u8 tpm_reg, temp;
+
+	struct i2c_client* client = (struct i2c_client* ) chip->vendor.iobase;
+
+	FUNC_ENTER();
+
+        /* wait for burstcount */
+        /* which timeout value, spec has 2 answers (c & d) */
+        stop = jiffies + chip->vendor.timeout_d;
+        do {
+		tpm_reg = TPM_STS + 1;
+                status = I2C_READ_DATA(client, tpm_reg, &temp, 1 );
+                if (status < 0)
+                        goto end;
+
+                tpm_reg = tpm_reg + 1;
+                burstcnt = temp;
+                status = I2C_READ_DATA(client, tpm_reg, &temp, 1);
+                if (status < 0)
+                        goto end;
+
+                burstcnt |= temp << 8;
+                if (burstcnt)
+                        return burstcnt;
+                msleep(TPM_TIMEOUT);
+        } while (time_before(jiffies, stop));
+
+end:
+        return -EBUSY;
+}/* get_burstcount() */
+
+/*
+ * wait_for_stat wait for a TPM_STS value
+ * @param: chip, the tpm chip description
+ * @param: mask, the value mask to wait
+ * @param: timeout, the timeout
+ * @param: queue, the wait queue.
+ * @return: the tpm status, 0 if success, -ETIME if timeout is reached.
+ */
+static int wait_for_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
+                         wait_queue_head_t *queue)
+{
+        unsigned long stop;
+	long rc;
+        u8 status;
+
+	FUNC_ENTER();
+
+        /* check current status */
+        /*status = tpm_stm_i2c_status(chip);
+        if ((status & mask) == mask)
+                return 0;*/
+
+	 if (chip->vendor.irq) {
+                rc = wait_for_serirq_timeout(chip, ((tpm_stm_i2c_status
+                                                        (chip) & mask) ==
+                                                       mask), timeout);
+                if (rc > 0)
+                        return 0;
+        } else {
+	        stop = jiffies + timeout;
+	        do {
+        		msleep(TPM_TIMEOUT);
+                	status = tpm_stm_i2c_status(chip);
+	                if ((status & mask) == mask)
+        	        	return 0;
+	        } while (time_before(jiffies, stop));
+	}
+        return -ETIME;
+} /* wait_for_stat() */
+
+/*
+ * recv_data receive data
+ * @param: chip, the tpm chip description
+ * @param: buf, the buffer where the data are received
+ * @param: count, the number of data to receive
+ * @return: the tpm status, 0 if success, -ETIME if timeout is reached.
+ */
+static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
+{
+        int size = 0, burstcnt, len;
+	struct i2c_client* client;
+
+	FUNC_ENTER();
+
+	client = (struct i2c_client *) chip->vendor.iobase;
+
+        while (size < count &&
+               wait_for_stat(chip,
+                             TPM_STS_DATA_AVAIL | TPM_STS_VALID,
+                             chip->vendor.timeout_c,
+                             &chip->vendor.read_queue)
+               == 0) {
+                burstcnt = get_burstcount(chip);
+		len = min_t(int, burstcnt, count - size);
+		I2C_READ_DATA(client, TPM_DATA_FIFO, buf + size, len);
+		size += len;
+        }
+        return size;
+} 
+
+/*
+ * tpm_ioserirq_handler the serirq irq handler
+ * @param: irq, the tpm chip description
+ * @param: dev_id, the description of the chip
+ * @return: the status of the handler.
+ */
+static irqreturn_t tpm_ioserirq_handler(int irq, void *dev_id)
+{
+        struct tpm_chip *chip = dev_id;
+        struct i2c_client *client;
+        struct st33zp24_platform_data* pin_infos;
+
+        disable_irq_nosync(irq);
+        FUNC_ENTER();
+
+        client = (struct i2c_client *) chip->vendor.iobase;
+        pin_infos = client->dev.platform_data;
+
+        complete(&pin_infos->irq_detection);
+        return IRQ_HANDLED;
+}/* tpm_ioserirq_handler() */
+
+
+/*
+ * tpm_stm_i2c_send send TPM commands through the I2C bus.
+ *
+ * @param: chip, the tpm_chip description as specified in driver/char/tpm/tpm.h.
+ * @param: buf,	the buffer to send.
+ * @param: count, the number of bytes to send.
+ * @return: In case of success the number of bytes sent.
+ *			In other case, a < 0 value describing the issue.
+ */
+static int tpm_stm_i2c_send(struct tpm_chip *chip, unsigned char *buf,
+			    size_t len)
+{
+	u32 ret = 0, ordinal, 
+	    status,
+	    burstcnt = 0, i, size;
+	u8 data;
+	struct i2c_client* client;
+	struct st33zp24_platform_data* pin_infos;
+
+
+	FUNC_ENTER();
+	if (chip == NULL)
+		return -EBUSY;
+	if (len < TPM_HEADER_SIZE)
+		return -EBUSY;
+	
+	client = (struct i2c_client *)chip->vendor.iobase;
+	pin_infos = client->dev.platform_data;
+	
+	ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
+
+	/* i2c_client initialization */
+	client->flags = 0;
+
+	ret = request_locality(chip);
+	if (ret < 0)
+		return ret;
+
+	status = tpm_stm_i2c_status(chip);
+        if ((status & TPM_STS_COMMAND_READY) == 0) {
+                tpm_stm_i2c_cancel(chip);
+                if (wait_for_stat
+                    (chip, TPM_STS_COMMAND_READY, chip->vendor.timeout_b,
+                     &chip->vendor.int_queue) < 0) {
+                        ret = -ETIME;
+                        goto out_err;
+                }
+        }
+
+
+	for ( i = 0 ; i < len - 1 ; )
+        {
+                burstcnt = get_burstcount(chip);
+                size = min_t(int, len - i - 1, burstcnt);
+                ret = I2C_WRITE_DATA(client, TPM_DATA_FIFO, buf, size);
+		if ( ret < 0 )
+			goto out_err;	
+
+                i += size;
+        }
+
+        status = tpm_stm_i2c_status(chip);
+        if ((status & TPM_STS_DATA_EXPECT) == 0) {
+        	ret = -EIO;
+                goto out_err;
+        }
+
+        /* write last byte */
+        ret = I2C_WRITE_DATA(client, TPM_DATA_FIFO, buf + len - 1, 1);
+	if (ret < 0)
+		goto out_err;
+                
+        status = tpm_stm_i2c_status(chip);
+        if ((status & TPM_STS_DATA_EXPECT) != 0) {
+                ret = -EIO;
+                goto out_err;
+        }
+
+	/* go and do it */
+	data = TPM_STS_GO;
+        I2C_WRITE_DATA(client, TPM_STS, &data, 1); 
+
+        return len;
+out_err:
+        tpm_stm_i2c_cancel(chip);
+        release_locality(chip);
+	return ret;
+}
+
+/*
+ * tpm_stm_i2c_recv received TPM response through the I2C bus.
+ * @param: chip, the tpm_chip description as specified in driver/char/tpm/tpm.h.
+ * @param: buf,	the buffer to store datas.
+ * @param: count, the number of bytes to send.
+ * @return: In case of success the number of bytes received.
+ *      	In other case, a < 0 value describing the issue.
+ */
+static int tpm_stm_i2c_recv(struct tpm_chip *chip, unsigned char *buf,
+			    size_t count)
+{
+	int size = 0;
+	int expected;	
+
+	struct i2c_client* client;
+	struct st33zp24_platform_data* pin_infos;
+
+
+	FUNC_ENTER();
+
+	client = (struct i2c_client *)chip->vendor.iobase;
+	pin_infos = client->dev.platform_data;
+
+
+	if (chip == NULL)
+		return -EBUSY;
+
+	if (count < TPM_HEADER_SIZE) {
+                size = -EIO;
+                goto out;
+        }	
+
+        /* read first 10 bytes, including tag, paramsize, and result */
+        if ((size =
+             recv_data(chip, buf, TPM_HEADER_SIZE)) < TPM_HEADER_SIZE) {
+                dev_err(chip->dev, "Unable to read header\n");
+                goto out;
+        }
+
+        expected = be32_to_cpu(*(__be32 *) (buf + 2));
+        if (expected > count) {
+                size = -EIO;
+                goto out;
+        }
+
+        if ((size +=
+             recv_data(chip, &buf[TPM_HEADER_SIZE],
+                       expected - TPM_HEADER_SIZE)) < expected) {
+                dev_err(chip->dev, "Unable to read remainder of result\n");
+                size = -ETIME;
+                goto out;
+        }
+
+out:
+	chip->vendor.cancel(chip);
+        release_locality(chip); 
+	return size;
+}
+
+/*
+ * tpm_stm_i2c_send_hash send TPM locality 4 hash datas through the I2C bus.
+ * @param: chip, the tpm_chip description as specified in driver/char/tpm/tpm.h.
+ * @param: buf,	the data buffer to send.
+ * @param: len, the number of bytes to send.
+ * @return: In case of success the number of bytes sent.
+ *			In other case, a < 0 value describing the issue.
+ */
+static int tpm_stm_i2c_send_hash(struct tpm_chip *chip, unsigned char *buf,
+			    size_t len)
+{
+	u32 ret = 0, i, size, burstcnt;
+	u8 data;
+	
+	struct i2c_client* client;
+	struct st33zp24_platform_data* pin_infos;	
+
+	FUNC_ENTER();
+
+	if (chip == NULL)
+		return -EBUSY;
+
+	client = (struct i2c_client *)chip->vendor.iobase;
+	pin_infos = client->dev.platform_data;
+
+	/* i2c_client initialization */
+	client->flags = 0;
+
+	ret = request_locality(chip);
+        if (ret < 0)
+                goto end;
+
+        burstcnt = get_burstcount(chip);		
+	if (burstcnt < 0)
+		goto end;
+
+	/* HASH_START */
+	data = TPM_DUMMY_BYTE;
+	ret = I2C_WRITE_DATA(client, TPM_HASH_START, &data, 1);
+	if (ret < 0)
+		goto end;
+
+	/* Send data  */	
+        for ( i = 0 ; i < len ; )
+        {
+                size = min_t(int, len - i, burstcnt);
+                ret = I2C_WRITE_DATA(client, TPM_DATA_FIFO, buf + i, size);
+                if (ret < 0)
+                        goto end;
+                i += size;
+        }	
+
+end:
+	/* In case of any error we try to end the hash mecanism to recover the tpm */
+	/* HASH_END  */
+	I2C_WRITE_DATA(client, TPM_HASH_END, &data, 1);	
+	return ret;
+}
+
+
+/*
+ * tpm_st33_i2c_ioctl provides 2 handles:
+ * - TPMIOC_CANCEL: allow to CANCEL a TPM commands execution.
+ *   See tpm_stm_i2c_cancel description above
+ * - TPMIOC_TRANSMIT: allow to transmit a TPM commands.
+ * - TPMIOC_HASH: allow to compute a locality 4 hash
+ * - TPMIOC_CHANGELOCALITY: allow to change the current locality
+ *
+ * @return: In case of success, return TPM response size.
+ * In other case return < 0 value describing the issue.
+ */
+static ssize_t tpm_st33_i2c_ioctl(struct inode *inode, struct file *file,
+				  unsigned int cmd, unsigned long arg)
+{
+	int in_size = 0, out_size = 0, rc, status;
+	unsigned long stop;
+	struct tpm_chip *chip = file->private_data;
+	st_tpm_hash_t hash_data;		
+	struct i2c_client* client;
+	client = (struct i2c_client *) chip->vendor.iobase;
+
+	FUNC_ENTER();	
+
+	switch (cmd) {
+	case TPMIOC_CANCEL:
+		tpm_stm_i2c_cancel(chip);
+		return 0;
+	case TPMIOC_TRANSMIT:
+		if (copy_from_user(chip->data_buffer,
+		    (const char *)arg, TPM_HEADER_SIZE))
+			return -EFAULT;
+
+		in_size = responseSize(chip->data_buffer,
+				      TPM_HEADER_SIZE);
+		if (copy_from_user(chip->data_buffer,
+				   (const char *)arg, in_size))
+			return -EFAULT;
+		tpm_stm_i2c_send(chip, chip->data_buffer, in_size);
+
+		out_size = tpm_stm_i2c_recv(chip, chip->data_buffer,
+					    TPM_BUFSIZE);
+		if (copy_to_user((char *)arg, chip->data_buffer,
+				 out_size))
+			return -EFAULT;
+		return out_size;
+	case TPMIOC_HASH:
+		if (chip->vendor.locality == LOCALITY4 )
+		{
+			if (copy_from_user(&hash_data,
+		   			 (st_tpm_hash_t __user *)arg, sizeof(st_tpm_hash_t)))
+				return -EFAULT;
+			tpm_stm_i2c_send_hash(chip, hash_data.data, hash_data.size);
+
+			if (chip->vendor.irq)
+                        {
+                                rc = wait_event_interruptible_timeout(chip->vendor.read_queue,
+                                                 (check_locality(chip) != chip->vendor.locality),
+                                                 chip->vendor.timeout_a);
+                                if (rc < 0)
+                                        return -ETIME;
+                                return hash_data.size; 
+                        }
+
+			stop = jiffies + chip->vendor.timeout_a;
+                        do {
+                                msleep(TPM_TIMEOUT);
+                                status = check_locality(chip);
+                                if (status != chip->vendor.locality)
+                                        return hash_data.size;
+                        } while (time_before(jiffies, stop));
+			return hash_data.size;
+		}
+		return -ENOSYS;
+		break;
+	case TPMIOC_CHANGELOCALITY:
+		if ( arg == LOCALITY0 )
+		{
+			client->addr = TPM_I2C_ST33_ADDR_WR_LOC0;
+			chip->vendor.locality = LOCALITY0;
+			return 0;
+		}
+		else if ( arg == LOCALITY4 )
+		{
+			client->addr = TPM_I2C_ST33_ADDR_WR_LOC4;
+			chip->vendor.locality = LOCALITY4;
+			return 0;
+		}
+		else
+			return -ENOSYS;
+		break;
+	default:
+		return -ENOTTY;
+	}
+	return -ENOTTY;
+}
+
+static const struct file_operations tpm_st33_i2c_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.read = tpm_read,
+	.compat_ioctl = tpm_st33_i2c_ioctl,
+	.write = tpm_write,
+	.open = tpm_open,
+	.release = tpm_release,
+};
+
+static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
+static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
+static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
+static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
+static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
+static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated, NULL);
+static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps_1_2, NULL);
+static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
+
+static struct attribute *stm_tpm_attrs[] = {
+	&dev_attr_pubek.attr,
+	&dev_attr_pcrs.attr,
+	&dev_attr_enabled.attr,
+	&dev_attr_active.attr,
+	&dev_attr_owned.attr,
+	&dev_attr_temp_deactivated.attr,
+	&dev_attr_caps.attr,
+	&dev_attr_cancel.attr, NULL,
+};
+
+static struct attribute_group stm_tpm_attr_grp = {
+	.attrs = stm_tpm_attrs
+};
+
+static struct tpm_vendor_specific st_i2c_tpm = {
+	.send = tpm_stm_i2c_send,
+	.recv = tpm_stm_i2c_recv,
+	.cancel = tpm_stm_i2c_cancel,
+	.status = tpm_stm_i2c_status,
+	.req_complete_mask = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
+	.req_complete_val = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
+	.req_canceled = TPM_STS_COMMAND_READY,
+	.attr_group = &stm_tpm_attr_grp,
+	.miscdev = {.fops = &tpm_st33_i2c_fops,},
+};
+
+static int interrupts = 0;
+module_param(interrupts, bool, 0444);
+MODULE_PARM_DESC(interrupts, "Enable interrupts");
+
+static int power_mgt = 1;
+module_param(power_mgt, bool, 0444);
+MODULE_PARM_DESC(power_mgt, "Power Management");
+
+/*
+ * tpm_st33_i2c_probe initialize the TPM device
+ * @param: client, the i2c_client drescription (TPM I2C description).
+ * @param: id, the i2c_device_id struct.
+ * @return: 0 in case of success.
+ *         -1 in other case.
+ */
+static int
+tpm_st33_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
+{
+	u32 err;
+	u8 intmask;
+	struct tpm_chip *chip;
+	struct st33zp24_platform_data *platform_data;
+
+	FUNC_ENTER();
+
+	err = 0;
+
+	/* Check I2C platform functionnalities */
+	if (client == NULL) {
+		pr_info("client is NULL. exiting.\n");
+		err = -ENODEV;
+		goto end;
+	}
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		pr_info("client not i2c capable\n");
+		err = -ENODEV;
+		goto end;
+	}
+
+	chip = tpm_register_hardware(&client->dev, &st_i2c_tpm);
+	if (!chip) {
+		pr_info("fail chip\n");
+		err = -ENODEV;
+		goto end;
+	}
+
+	platform_data = client->dev.platform_data;
+	platform_data->tpm_i2c_buffer[0] =
+	    kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
+	if (platform_data->tpm_i2c_buffer[0] == NULL) {
+		err = -ENOMEM;
+		goto _tpm_clean_answer;
+	}
+	platform_data->tpm_i2c_buffer[1] =
+	    kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
+	if (platform_data->tpm_i2c_buffer[1] == NULL) {
+		err = -ENOMEM;
+		goto _tpm_clean_response;
+	}
+
+	chip->vendor.iobase = client;
+
+	/* Default timeouts */	
+        chip->vendor.timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+        chip->vendor.timeout_b = msecs_to_jiffies(TIS_LONG_TIMEOUT);
+        chip->vendor.timeout_c = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+        chip->vendor.timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+
+	chip->vendor.locality = LOCALITY0;
+	
+	if ( power_mgt )
+	{
+		err = gpio_request(platform_data->io_lpcpd, "TPM IO_LPCPD");
+		if (err)
+			goto _gpio_init1; 
+		gpio_set_value(platform_data->io_lpcpd, 1);
+	}
+
+	/* Enable interrupt */
+	/* Register GPIO pin through generic Linux GPIO API */
+	if (interrupts) {
+		init_completion(&platform_data->irq_detection);	
+		if (request_locality(chip) != LOCALITY0) {
+                	err = -ENODEV;
+	                goto _tpm_clean_response;
+        	}	
+		err = gpio_request(platform_data->io_serirq, "TPM IO_SERIRQ");
+		if (err)
+			goto _gpio_init2; 
+
+		/* Clear all existing */
+		clear_interruption(client);
+		err = request_irq(gpio_to_irq(platform_data->io_serirq), &tpm_ioserirq_handler,
+        		        IRQF_TRIGGER_HIGH,
+		                "TPM SERIRQ management", chip);
+		if (err < 0) {
+
+                	pr_info("TPM SERIRQ signals %d not available\n",
+                       	gpio_to_irq(platform_data->io_serirq));
+			goto _irq_set;
+		}
+
+		err = I2C_READ_DATA(client, TPM_INT_ENABLE, &intmask, 1);
+		if (err < 0)
+			goto _irq_set;
+
+        	intmask |= TPM_INTF_CMD_READY_INT
+			|  TPM_INTF_FIFO_AVALAIBLE_INT 
+			|  TPM_INTF_WAKE_UP_READY_INT 
+		        |  TPM_INTF_LOC4SOFTRELEASE_INT
+			|  TPM_INTF_LOCALITY_CHANGE_INT
+			|  TPM_INTF_STS_VALID_INT
+			|  TPM_INTF_DATA_AVAIL_INT;
+
+       		err = I2C_WRITE_DATA(client, TPM_INT_ENABLE, &intmask, 1);	
+		if (err < 0)	
+			goto _irq_set;
+
+		intmask = TPM_GLOBAL_INT_ENABLE;
+		err = I2C_WRITE_DATA(client, TPM_INT_ENABLE + 3, &intmask, 1);		
+		if (err < 0)
+			goto _irq_set;
+
+		err = I2C_READ_DATA(client, TPM_INT_STATUS, &intmask, 1);
+		if (err < 0)
+			goto _irq_set;
+
+		chip->vendor.irq = interrupts;
+
+                tpm_gen_interrupt(chip);
+        } 	
+	
+	tpm_get_timeouts(chip);
+
+	/* attach chip datas to client */
+	i2c_set_clientdata(client, chip);
+	platform_data->bChipF = false;
+	
+	pr_info("TPM I2C Initialized\n");
+	return 0;
+_irq_set:
+        free_irq(gpio_to_irq(platform_data->io_serirq), (void *) chip);
+_gpio_init2:
+        if (platform_data && interrupts) {
+                gpio_free(platform_data->io_serirq);
+        }
+_gpio_init1:
+        if ( platform_data && power_mgt ) {
+                gpio_free(platform_data->io_lpcpd);
+        }
+_tpm_clean_response:
+	tpm_remove_hardware(chip->dev);
+	if (platform_data->tpm_i2c_buffer[1] != NULL) {
+		kfree(platform_data->tpm_i2c_buffer[1]);
+		platform_data->tpm_i2c_buffer[1] = NULL;
+	}
+_tpm_clean_answer:
+	if (platform_data->tpm_i2c_buffer[0] != NULL) {
+		kfree(platform_data->tpm_i2c_buffer[0]);
+		platform_data->tpm_i2c_buffer[0] = NULL;
+	}
+	
+	platform_data->bChipF = true;
+end:
+	pr_info("TPM I2C initialisation fail\n");
+	return err;
+}
+
+/*
+ * tpm_st33_i2c_remove remove the TPM device
+ * @param: client, the i2c_client drescription (TPM I2C description).
+		clear_bit(0, &chip->is_open);
+ * @return: 0 in case of success.
+ */
+static __devexit int tpm_st33_i2c_remove(struct i2c_client *client)
+{
+	struct tpm_chip *chip = (struct tpm_chip *)i2c_get_clientdata(client);
+	struct st33zp24_platform_data* pin_infos = 
+		((struct i2c_client* ) chip->vendor.iobase)->dev.platform_data;
+
+	FUNC_ENTER();
+
+	if (pin_infos != NULL) {
+		free_irq(pin_infos->io_serirq, chip);
+
+		gpio_free(pin_infos->io_serirq);
+		gpio_free(pin_infos->io_lpcpd);
+
+		/* Check if chip has been previously clean */
+		if (pin_infos->bChipF != true)
+			tpm_remove_hardware(chip->dev);
+		if (pin_infos->tpm_i2c_buffer[1] != NULL) {
+			kfree(pin_infos->tpm_i2c_buffer[1]);
+			pin_infos->tpm_i2c_buffer[1] = NULL;
+		}
+		if (pin_infos->tpm_i2c_buffer[0] != NULL) {
+			kfree(pin_infos->tpm_i2c_buffer[0]);
+			pin_infos->tpm_i2c_buffer[0] = NULL;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * tpm_st33_i2c_pm_suspend suspend the TPM device
+ * Added: Work around when suspend and no tpm application is running, suspend
+ * may fail because chip->data_buffer is not set (only set in tpm_open in Linux
+ * TPM core)
+ * @param: client, the i2c_client drescription (TPM I2C description).
+ * @param: mesg, the power management message.
+ * @return: 0 in case of success.
+ */
+static int tpm_st33_i2c_pm_suspend(struct i2c_client *client, pm_message_t mesg)
+{
+	struct tpm_chip *chip =
+            (struct tpm_chip *)i2c_get_clientdata(client);
+        struct st33zp24_platform_data* pin_infos =
+                ((struct i2c_client *)chip->vendor.iobase)->dev.platform_data;
+        int ret = 0;
+
+        if ( power_mgt )
+                gpio_set_value(pin_infos->io_lpcpd, 0);
+        else
+        {
+                if (chip->data_buffer == NULL)
+                        chip->data_buffer = pin_infos->tpm_i2c_buffer[0];
+                ret = tpm_pm_suspend(&client->dev, mesg);
+        }
+        return ret;
+}				/* tpm_st33_i2c_suspend() */
+
+/*
+ * tpm_st33_i2c_pm_resume resume the TPM device
+ * @param: client, the i2c_client drescription (TPM I2C description).
+ * @return: 0 in case of success.
+ */
+static int tpm_st33_i2c_pm_resume(struct i2c_client *client)
+{
+	struct tpm_chip *chip =
+            (struct tpm_chip *)i2c_get_clientdata(client);
+        struct st33zp24_platform_data* pin_infos =
+                ((struct i2c_client *)chip->vendor.iobase)->dev.platform_data;
+
+        int ret = 0;
+
+        if ( power_mgt )
+        {
+                gpio_set_value(pin_infos->io_lpcpd, 1);
+                ret = wait_for_serirq_timeout(chip, (chip->vendor.status(chip) &&
+                                                  TPM_STS_VALID) == TPM_STS_VALID,
+                                                  chip->vendor.timeout_b);
+        }
+        else
+        {
+                if (chip->data_buffer == NULL)
+                        chip->data_buffer = pin_infos->tpm_i2c_buffer[0];
+                ret = tpm_pm_resume(&client->dev);
+                if (!ret)
+                        tpm_continue_selftest(chip);
+        }
+        return ret;
+}				/* tpm_st33_i2c_pm_resume() */
+
+static const struct i2c_device_id tpm_st33_i2c_id[] = {
+	{TPM_ST33_I2C, 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, tpm_st33_i2c_id);
+
+static struct i2c_driver tpm_st33_i2c_driver = {
+	.driver = {
+		   .owner = THIS_MODULE,
+		   .name = TPM_ST33_I2C,
+		   },
+	.probe = tpm_st33_i2c_probe,
+	.remove = tpm_st33_i2c_remove,
+	.resume = tpm_st33_i2c_pm_resume,
+	.suspend = tpm_st33_i2c_pm_suspend,
+	.id_table = tpm_st33_i2c_id
+};
+
+/*
+ * tpm_st33_i2c_init initialize driver
+ * @return: 0 if successful, else non zero value.
+ */
+static int __init tpm_st33_i2c_init(void)
+{
+	FUNC_ENTER();
+	return i2c_add_driver(&tpm_st33_i2c_driver);
+}
+
+/*
+ * tpm_st33_i2c_exit The kernel calls this function during unloading the
+ * module or during shut down process
+ */
+static void __exit tpm_st33_i2c_exit(void)
+{
+	FUNC_ENTER();
+	i2c_del_driver(&tpm_st33_i2c_driver);
+}
+
+module_init(tpm_st33_i2c_init);
+module_exit(tpm_st33_i2c_exit);
+
+MODULE_AUTHOR("Christophe Ricard (tpmsupport@st.com)");
+MODULE_DESCRIPTION("STM TPM I2C ST33 Driver");
+MODULE_VERSION("1.2.0");
+MODULE_LICENSE("GPL");
diff --git a/drivers/char/tpm/tpm_stm_st33_i2c.h b/drivers/char/tpm/tpm_stm_st33_i2c.h
new file mode 100644
index 0000000..0f63bf4
--- /dev/null
+++ b/drivers/char/tpm/tpm_stm_st33_i2c.h
@@ -0,0 +1,76 @@
+/*
+ * STMicroelectronics TPM I2C Linux driver for TPM ST33ZP24
+ * Copyright (C) 2009, 2010  STMicroelectronics
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * STMicroelectronics version 1.2.0, Copyright (C) 2010
+ * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
+ * This is free software, and you are welcome to redistribute it
+ * under certain conditions.
+ *
+ * @Author: Christophe RICARD tpmsupport@st.com
+ *
+ * @File: stm_st33_tpm_i2c.h
+ *
+ * @Date: 09/15/2010
+ */
+#ifndef __STM_ST33_TPM_I2C_MAIN_H__
+#define __STM_ST33_TPM_I2C_MAIN_H__
+
+#include <linux/pci.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/i2c.h>
+//#include <linux/i2c-id.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+
+#define MINOR_NUM_I2C		224
+
+/*#define TPM_DRIVER_NAME		"st33np18_i2c"*/
+
+#define TPM_ACCESS			(0x0)		
+#define TPM_STS				(0x18)
+#define TPM_HASH_END			(0x20)
+#define TPM_DATA_FIFO			(0x24)
+#define TPM_HASH_DATA			(0x24)
+#define TPM_HASH_START			(0x28)
+#define TPM_INTF_CAPABILITY		(0x14)
+#define TPM_INT_STATUS			(0x10)
+#define TPM_INT_ENABLE			(0x08)
+
+
+#define TPM_DUMMY_BYTE			0xAA
+#define TPM_WRITE_DIRECTION		0x80
+#define TPM_HEADER_SIZE 		10
+#define TPM_BUFSIZE			2048
+
+/* ioctl commands */
+#define TPMIOC_CANCEL		_IO('T', 0x00)
+#define TPMIOC_TRANSMIT		_IO('T', 0x01)
+#define TPMIOC_HASH		_IO('T', 0x02)
+#define TPMIOC_CHANGELOCALITY	_IO('T', 0x03)
+
+#define LOCALITY0		0
+#define LOCALITY4		4
+
+typedef struct st_tpm_hash
+{
+        int size;
+        u8* data;
+}st_tpm_hash_t;
+
+#endif /* __STM_ST33_TPM_I2C_MAIN_H__ */
diff --git a/drivers/char/tpm/tpm_stm_st33_spi.c b/drivers/char/tpm/tpm_stm_st33_spi.c
new file mode 100644
index 0000000..551a356
--- /dev/null
+++ b/drivers/char/tpm/tpm_stm_st33_spi.c
@@ -0,0 +1,1285 @@
+/*
+ * STMicroelectronics TPM SPI Linux driver for TPM ST33ZP24
+ * Copyright (C) 2009, 2010  STMicroelectronics
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * STMicroelectronics version 1.2.0, Copyright (C) 2010
+ * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
+ * This is free software, and you are welcome to redistribute it
+ * under certain conditions.
+ *
+ * @Author: Christophe RICARD tpmsupport@st.com
+ *
+ * @File: tpm_stm_st33_spi.c
+ *
+ * @Synopsis:
+ * 	09/15/2010:	First shot driver tpm_tis driver for lpc is used as model.
+ */
+
+#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/spi/spi.h>
+#include <linux/wait.h>
+#include <linux/string.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/sysfs.h>
+#include <linux/gpio.h>
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+
+#include <linux/spi/tpm_stm_st33_spi.h>
+
+#include "tpm.h"
+
+#include "tpm_stm_st33_spi.h"
+
+#ifdef DEBUG
+#define FUNC_ENTER()	pr_info("%s\n", __func__)
+#else
+#define	FUNC_ENTER()	do{}	while(0)
+#endif
+
+enum stm33zp24_access {
+        TPM_ACCESS_VALID = 0x80,
+        TPM_ACCESS_ACTIVE_LOCALITY = 0x20,
+        TPM_ACCESS_REQUEST_PENDING = 0x04,
+        TPM_ACCESS_REQUEST_USE = 0x02,
+};
+
+enum stm33zp24_status {
+        TPM_STS_VALID = 0x80,
+        TPM_STS_COMMAND_READY = 0x40,
+        TPM_STS_GO = 0x20,
+        TPM_STS_DATA_AVAIL = 0x10,
+        TPM_STS_DATA_EXPECT = 0x08,
+};
+
+enum stm33zp24_int_flags {
+	TPM_GLOBAL_INT_ENABLE = 0x80,
+        TPM_INTF_CMD_READY_INT = 0x080,	
+	TPM_INTF_FIFO_AVALAIBLE_INT = 0x040,
+	TPM_INTF_WAKE_UP_READY_INT = 0x020, 
+	TPM_INTF_LOC4SOFTRELEASE_INT = 0x008,	
+	TPM_INTF_LOCALITY_CHANGE_INT = 0x004,
+        TPM_INTF_STS_VALID_INT = 0x002,
+        TPM_INTF_DATA_AVAIL_INT = 0x001,
+};
+
+enum tis_defaults {
+        TIS_SHORT_TIMEOUT = 750,        /* ms */
+        TIS_LONG_TIMEOUT = 2000,        /* 2 sec */
+};
+
+/*
+ * write8_reg
+ * Send byte to the TIS register according to the ST33ZP24 SPI protocol.
+ * @param: tpm, the chip description
+ * @param: tpm_register, the tpm tis register where the data should be written
+ * @param: tpm_data, the tpm_data to write inside the tpm_register
+ * @param: tpm_size, The length of the data
+ * @return: number of byte written successfully: should be one if success.
+ */
+static int write8_reg(struct tpm_chip* tpm, u8 tpm_register, 
+		      u8* tpm_data, u16 tpm_size)
+{
+	/* u8 LOC+DIR u8 ADD u16 LENGHT u8* data */
+	/* u8 LATENCY u8 LATENCY */
+
+	u8 data;
+	int i = 0, j;
+	int value = 0;
+	//u8 status;
+	struct spi_device* dev = (struct spi_device*) tpm->vendor.iobase;
+	struct st33zp24_platform_data *platform_data = dev->dev.platform_data;
+	u8* data_buffer = platform_data->tpm_spi_buffer[0];
+	struct spi_transfer xfer = {
+                .tx_buf         = data_buffer,
+                .rx_buf         = platform_data->tpm_spi_buffer[1],
+        };
+        struct spi_message msg;
+	u8 latency = platform_data->latency + tpm_size + 1;
+
+
+	FUNC_ENTER();
+	/* Pre-Header */
+
+	data = TPM_WRITE_DIRECTION | tpm->vendor.locality;
+	memcpy(data_buffer + i, &data, sizeof(data));
+	i++;
+	data = tpm_register;
+	memcpy(data_buffer + i, &data, sizeof(data));
+	i++;
+
+	if ( tpm_size > 0 && 
+	     (tpm_register == TPM_DATA_FIFO ||
+	      tpm_register == TPM_HASH_DATA) )
+	{
+		data = tpm_size >> 8 & 0x00ff;
+		memcpy(data_buffer + i, &data, sizeof(data));
+		i++; 
+		data = tpm_size & 0x00ff; 
+		memcpy(data_buffer + i, &data, sizeof(data));
+		i++;
+		latency -= 2;
+	}
+
+	memcpy(data_buffer + i, tpm_data, tpm_size);
+	i += tpm_size;
+
+	for ( j = 0 ; j < platform_data->latency + 1; j++ )
+	{
+		data = TPM_DUMMY_BYTE; 
+		memcpy(data_buffer + i, &data, sizeof(data));
+		i++; 
+	}
+	xfer.len = i;
+	spi_message_init(&msg);
+        spi_message_add_tail(&xfer, &msg);
+	value = spi_sync(dev, &msg); 
+
+	if (value == 0 )
+	{
+		j = i - 1 - j;
+		for ( ; j < i && ((u8 *) xfer.rx_buf)[j] == 0; j++);
+
+		if ( ((u8 *) xfer.rx_buf)[j] != 0 )
+			value = ((u8 *) xfer.rx_buf)[j];
+	}
+
+	return value;
+}/* write8_reg() */
+
+/*
+ * read8_reg
+ * Recv byte from the TIS register according to the ST33ZP24 SPI protocol.
+ * @param: tpm, the chip description
+ * @param: tpm_register, the tpm tis register where the data should be read
+ * @param: tpm_data, the TPM response
+ * @param: tpm_size, tpm TPM response size to read.
+ * @return: number of byte read successfully: should be one if success.
+ */
+static u8 read8_reg(struct tpm_chip* tpm, u8 tpm_register, 
+		    u8* tpm_data, u16 tpm_size)
+{
+	u8 data;
+	int i = 0, j;
+	int value = 0;
+	struct spi_device* dev = (struct spi_device*) tpm->vendor.iobase;
+	struct st33zp24_platform_data *platform_data = dev->dev.platform_data;
+	u8* data_buffer = platform_data->tpm_spi_buffer[0];
+	struct spi_transfer xfer = {
+                .tx_buf         = data_buffer,
+                .rx_buf         = platform_data->tpm_spi_buffer[1],
+        };
+        struct spi_message msg;
+	
+	u8 latency = platform_data->latency + tpm_size + 1;
+
+	FUNC_ENTER();
+	/* Pre-Header */
+
+	data = tpm->vendor.locality;
+	memcpy(data_buffer + i, &data, sizeof(data));
+	i++;
+	data = tpm_register;
+	memcpy(data_buffer + i, &data, sizeof(data));
+	i++;
+	
+	for ( j = 0 ; j < latency; j++ )
+        {
+                data = TPM_DUMMY_BYTE;
+                memcpy(data_buffer + i, &data, sizeof(data));
+                i++;
+        }
+        xfer.len = i;
+
+	/* header + status byte + size of the data + status byte */	
+	spi_message_init(&msg);
+        spi_message_add_tail(&xfer, &msg);
+	value = spi_sync(dev, &msg);
+	if (tpm_size > 0 && value == 0 )
+	{
+		j = 2; 
+		for ( ; j < i && ((u8 *) xfer.rx_buf)[j] == 0; j++);
+
+		if ( j + 1 < i )
+		{
+			value = ((u8 *) xfer.rx_buf)[j];
+
+			if ( tpm_size > 0 )
+				memcpy(tpm_data, xfer.rx_buf + j + 1, tpm_size);
+		}
+	}
+        return value;
+}/* read8_reg() */
+
+/*
+ * SPI_WRITE_DATA
+ * Send byte to the TIS register according to the ST33ZP24 SPI protocol.
+ * @param: tpm, the chip description
+ * @param: tpm_register, the tpm tis register where the data should be written
+ * @param: tpm_data, the tpm_data to write inside the tpm_register
+ * @param: tpm_size, The length of the data
+ * @return: number of byte written successfully: should be one if success.
+ */
+static u32 SPI_WRITE_DATA(struct tpm_chip* tpm, u8 tpm_register, 
+	 		  u8* tpm_data, u16 tpm_size)
+{
+	u8 value = 0;
+
+	FUNC_ENTER();	
+
+	value = write8_reg(tpm, tpm_register, tpm_data, tpm_size);
+	
+	switch(value)
+	{
+		case TPM_ST_SPI_OK:
+			return TPM_ST_SPI_OK;
+		case 0:
+			return 0;
+		default:
+			return -EBUSY;
+	}
+}/* SPI_WRITE_DATA() */
+
+/*
+ * SPI_READ_DATA
+ * Recv byte from the TIS register according to the ST33ZP24 SPI protocol.
+ * @param: tpm, the chip description
+ * @param: tpm_register, the tpm tis register where the data should be read
+ * @param: tpm_data, the TPM response
+ * @param: tpm_size, tpm TPM response size to read.
+ * @return: number of byte read successfully: should be one if success.
+ */ 
+static u32 SPI_READ_DATA(struct tpm_chip* tpm, u8 tpm_register, 
+			u8* tpm_data, u16 tpm_size)
+{
+	u8 value = 0;
+
+	FUNC_ENTER();	
+
+	value = read8_reg(tpm, tpm_register, tpm_data, tpm_size); 
+
+	switch(value)
+	{
+		case TPM_ST_SPI_OK:
+			return TPM_ST_SPI_OK;
+		case 0:
+			return 0;
+		default:
+			return -EBUSY;
+	}
+}/* SPI_READ_DATA () */
+
+/*
+ * clear_interruption
+ * clear the TPM interrupt register.
+ * @param: tpm, the chip description
+ */
+static void clear_interruption(struct tpm_chip* tpm)
+{
+        u8 interrupt;
+        SPI_READ_DATA(tpm, TPM_INT_STATUS, &interrupt, 1);
+        /* Clear interrupts handled with TPM_EOI */
+        SPI_WRITE_DATA(tpm, TPM_INT_STATUS, &interrupt, 1);
+        SPI_READ_DATA(tpm, TPM_INT_STATUS, &interrupt, 1);
+}/* clear_interruption() */
+
+/*
+ * _wait_for_interrupt_serirq_timeout
+ * @param: tpm, the chip description
+ * @param: timeout, the timeout of the interrupt
+ * @return: the status of the interruption.
+ */
+static int _wait_for_interrupt_serirq_timeout(struct tpm_chip* chip, unsigned long timeout)
+{
+        unsigned long status;
+        struct spi_device *client;
+        struct st33zp24_platform_data* pin_infos;
+
+        FUNC_ENTER();
+
+        client = (struct spi_device *) chip->vendor.iobase;
+        pin_infos = client->dev.platform_data;
+
+        status = wait_for_completion_interruptible_timeout(&pin_infos->irq_detection, timeout);
+        if ( status > 0 )
+                enable_irq(gpio_to_irq(pin_infos->io_serirq));
+        gpio_direction_input(pin_infos->io_serirq);
+
+        return status;
+}/* wait_for_interrupt_serirq_timeout() */
+
+#define wait_for_serirq_timeout(chip, condition, timeout) \
+({ \
+        unsigned long status = 0; \
+        struct spi_device *client; \
+        struct st33zp24_platform_data* pin_infos; \
+\
+        client = (struct spi_device *) chip->vendor.iobase; \
+        pin_infos = client->dev.platform_data;  \
+\
+        status = _wait_for_interrupt_serirq_timeout(chip, timeout); \
+        if (!status) \
+        { \
+                status = -EBUSY; \
+                goto wait_end; \
+        } \
+        clear_interruption(chip);     \
+        if (condition) \
+                status = 1; \
+\
+wait_end: \
+        status;\
+}) 
+
+
+/*
+ * tpm_stm_spi_cancel, cancel is not implemented.
+ * @param: chip, the tpm chip description as specified in driver/char/tpm/tpm.h.
+ */
+static void tpm_stm_spi_cancel(struct tpm_chip *chip)
+{
+	struct spi_device* client;
+	u8 data = TPM_STS_COMMAND_READY;
+	client = (struct spi_device *) chip->vendor.iobase;
+
+	FUNC_ENTER();	
+
+	/* this causes the current command to be aborted */
+        SPI_WRITE_DATA(chip, TPM_STS, &data, 1);
+}	/* tpm_stm_spi_cancel() */
+
+/*
+ * tpm_stm_spi_status return the TPM_STS register 
+ * @param: chip, the tpm chip description
+ * @return: the TPM_STS register value.
+ */
+static u8 tpm_stm_spi_status(struct tpm_chip *chip)
+{
+	struct spi_device* client;
+	u8 data;
+	client = (struct spi_device *) chip->vendor.iobase;
+
+	FUNC_ENTER();	
+
+	SPI_READ_DATA(chip, TPM_STS, &data, 1);	
+	return data;
+}				/* tpm_stm_spi_status() */
+
+/*
+ * responseSize return the command size
+ * @param: buffer, command buffer.
+ * @param: size, the buffer size.
+ * @return: the command size.
+ */
+static int responseSize(const char *buffer, size_t size)
+{
+	size_t val = 0;
+
+	FUNC_ENTER();	
+
+	if (size >= TPM_HEADER_SIZE) {
+		val = (size_t) (((unsigned)buffer[2]) << 24
+				| ((unsigned)buffer[3]) << 16
+				| ((unsigned)buffer[4]) << 8 | (unsigned)
+				buffer[5]);
+	}
+
+	if (val < TPM_BUFSIZE)
+		return val;
+	else
+		return TPM_BUFSIZE;
+}
+
+/*
+ * check_locality if the locality is active 
+ * @param: chip, the tpm chip description
+ * @return: the active locality or -EACCESS.
+ */
+static int check_locality(struct tpm_chip* chip)
+{
+	struct spi_device* client;
+	u8 data;
+	u8 status;
+
+	FUNC_ENTER();	
+
+	client = (struct spi_device *) chip->vendor.iobase;
+
+	status = SPI_READ_DATA(chip, TPM_ACCESS, &data, 1);
+	if (status && (data &
+		(TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==  
+		(TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID) )
+		return chip->vendor.locality;
+
+	return -EACCES; 
+}/* check_locality() */
+
+/*
+ * request_locality request the TPM locality
+ * @param: chip, the chip description
+ * @return: the active locality or EACCESS.
+ */
+static int request_locality(struct tpm_chip* chip)
+{
+	unsigned long stop;
+	long rc;
+	u8 data;
+	struct spi_device* client; 
+
+	FUNC_ENTER();
+
+	client = (struct spi_device *) chip->vendor.iobase;
+	/* Check locality */
+	if ( check_locality(chip) == chip->vendor.locality )
+		return chip->vendor.locality;	
+	
+	/* Request locality */
+	data = TPM_ACCESS_REQUEST_USE;
+	rc = SPI_WRITE_DATA(chip, TPM_ACCESS, &data, 1);
+	if (rc < 0)
+		goto end;
+
+	/* wait for burstcount */
+	if (chip->vendor.irq) {
+                rc = wait_for_serirq_timeout(chip, (check_locality
+                                                       (chip) >= 0),
+                                                      chip->vendor.timeout_a);
+                if (rc > 0)
+                        return chip->vendor.locality;
+        } else {
+	        stop = jiffies + chip->vendor.timeout_a;
+	        do {
+        		if (check_locality(chip) >= 0)
+                		return chip->vendor.locality;
+	                msleep(TPM_TIMEOUT);
+        	} while (time_before(jiffies, stop));
+	}
+end:
+	return -EACCES;
+}/* request_locality() */
+
+/*
+ * release_locality release the active locality
+ * @param: chip, the tpm chip description.
+ */
+static void release_locality(struct tpm_chip *chip)
+{
+	struct spi_device* client; 
+	u8 data;
+
+	FUNC_ENTER();
+
+	client = (struct spi_device *) chip->vendor.iobase; 
+	data = TPM_ACCESS_ACTIVE_LOCALITY; 
+        SPI_WRITE_DATA(chip, TPM_ACCESS, &data, 1);
+}/* release_locality()*/
+
+/*
+ * get_burstcount return the burstcount address 0x19 0x1A
+ * @param: chip, the chip description
+ * return: the burstcount.
+ */ 
+static int get_burstcount(struct tpm_chip *chip)
+{
+        unsigned long stop;
+        u32 burstcnt, status;
+	u8 tpm_reg, temp;
+
+	FUNC_ENTER();
+
+        /* wait for burstcount */
+        /* which timeout value, spec has 2 answers (c & d) */
+        stop = jiffies + chip->vendor.timeout_d;
+        do {
+		tpm_reg = TPM_STS + 1;
+                status = SPI_READ_DATA(chip, tpm_reg, &temp, 1 );
+		if (status < 0)
+			goto end;
+
+		tpm_reg = tpm_reg + 1;
+		burstcnt = temp;
+                status = SPI_READ_DATA(chip, tpm_reg, &temp, 1);
+		if (status < 0)
+			goto end;
+
+		burstcnt |= temp << 8;
+                if (burstcnt)
+                        return burstcnt;
+                msleep(TPM_TIMEOUT);
+        } while (time_before(jiffies, stop));
+
+end:
+        return -EBUSY;
+}/* get_burstcount() */
+
+/*
+ * wait_for_stat wait for a TPM_STS value
+ * @param: chip, the tpm chip description
+ * @param: mask, the value mask to wait
+ * @param: timeout, the timeout
+ * @param: queue, the wait queue.
+ * @return: the tpm status, 0 if success, -ETIME if timeout is reached.
+ */ 
+static int wait_for_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
+                         wait_queue_head_t *queue)
+{
+        unsigned long stop;
+	long rc;
+        u8 status;
+
+	FUNC_ENTER();
+
+        /* check current status */
+        status = tpm_stm_spi_status(chip);
+        if (!chip->vendor.irq && (status & mask) == mask)
+                return 0;
+
+	if (chip->vendor.irq) {
+        	rc = wait_for_serirq_timeout(chip, ((tpm_stm_spi_status
+                                                    (chip) & mask) ==
+                                                     mask), timeout);
+                if (rc > 0)
+                	return 0;
+        } else {
+	       	stop = jiffies + timeout;
+       		do {
+       			msleep(TPM_TIMEOUT);
+	       		status = tpm_stm_spi_status(chip);
+        		if ((status & mask) == mask)
+                		return 0;
+		} while (time_before(jiffies, stop));
+	}
+        return -ETIME;
+} /* wait_for_stat() */
+
+/*
+ * recv_data receive data
+ * @param: chip, the tpm chip description
+ * @param: buf, the buffer where the data are received
+ * @param: count, the number of data to receive
+ * @return: the tpm status, 0 if success, -ETIME if timeout is reached.
+ */ 
+static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
+{
+        u32 size = 0, burstcnt, status, len;
+	struct spi_device* client;
+
+	FUNC_ENTER();
+
+	client = (struct spi_device *) chip->vendor.iobase;
+
+        while (size < count &&
+               wait_for_stat(chip,
+                             TPM_STS_DATA_AVAIL | TPM_STS_VALID,
+                             chip->vendor.timeout_c,
+                             &chip->vendor.read_queue)
+               == 0) {
+                burstcnt = get_burstcount(chip);
+		len = min_t(int, burstcnt, count - size);
+                status = SPI_READ_DATA(chip, TPM_DATA_FIFO, buf + size, len);
+		if (status < 0)
+			return status;
+		
+
+		size += len;
+        }
+        return size;
+} 
+
+/*
+ * tpm_ioserirq_handler the serirq irq handler
+ * @param: irq, the tpm chip description
+ * @param: dev_id, the description of the chip
+ * @return: the status of the handler.
+ */ 
+static irqreturn_t tpm_ioserirq_handler(int irq, void *dev_id)
+{
+        struct tpm_chip *chip = dev_id;
+        struct spi_device *client;
+        struct st33zp24_platform_data* pin_infos;
+
+        disable_irq_nosync(irq);
+        FUNC_ENTER();
+
+        client = (struct spi_device *) chip->vendor.iobase;
+        pin_infos = client->dev.platform_data;
+
+        complete(&pin_infos->irq_detection);
+        return IRQ_HANDLED;
+}/* tpm_ioserirq_handler() */
+
+/*
+ * tpm_stm_spi_send send TPM commands through the SPI bus.
+ * @param: chip, the tpm chip description
+ * @param: buf, the tpm command buffer 
+ * @param: len, the tpm command size
+ * @return: In case of success the number of bytes sent.
+ *			In other case, a < 0 value describing the issue.
+ */
+static int tpm_stm_spi_send(struct tpm_chip *chip, unsigned char *buf,
+			    size_t len)
+{
+	u32 ret = 0, ordinal, 
+	    status, burstcnt = 0, i, size = 0;
+	u8 data;
+	
+	struct spi_device* client;
+	struct st33zp24_platform_data* pin_infos; 
+
+	FUNC_ENTER();
+
+	if (chip == NULL)
+		return -EBUSY;
+	if (len < TPM_HEADER_SIZE)
+		return -EBUSY;
+	
+	client = (struct spi_device *)chip->vendor.iobase;
+	pin_infos = client->dev.platform_data;
+	
+	ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
+
+	ret = request_locality(chip);
+	if (ret < 0)
+		return ret;
+
+	status = tpm_stm_spi_status(chip);
+        if ((status & TPM_STS_COMMAND_READY) == 0) {
+                tpm_stm_spi_cancel(chip);
+                if (wait_for_stat
+                    (chip, TPM_STS_COMMAND_READY, chip->vendor.timeout_b,
+                     &chip->vendor.int_queue) < 0) {
+                        ret = -ETIME;
+                        goto out_err;
+                }
+        }
+
+	for ( i = 0 ; i < len - 1 ; )
+	{
+	        burstcnt = get_burstcount(chip);		
+		size = min_t(int, len - i - 1, burstcnt);
+	        ret = SPI_WRITE_DATA(chip, TPM_DATA_FIFO, buf, size);		
+		if (ret < 0)
+			goto out_err;
+		i += size;
+	}
+
+        status = tpm_stm_spi_status(chip);
+        if ((status & TPM_STS_DATA_EXPECT) == 0) {
+        	ret = -EIO;
+                goto out_err;
+        }
+
+        /* write last byte */
+        SPI_WRITE_DATA(chip, TPM_DATA_FIFO, buf + len - 1, 1);
+                
+        status = tpm_stm_spi_status(chip);
+        if ((status & TPM_STS_DATA_EXPECT) != 0) {
+                ret = -EIO;
+                goto out_err;
+        }
+
+	/* go and do it */
+	data = TPM_STS_GO;
+        ret = SPI_WRITE_DATA(chip, TPM_STS, &data, 1); 
+	if (ret < 0)
+		goto out_err;
+
+        return len;
+out_err:
+        tpm_stm_spi_cancel(chip);
+        release_locality(chip);
+	return ret;
+}
+
+/*
+ * tpm_stm_spi_recv received TPM response through the SPI bus.
+ * @param: chip, the tpm chip description
+ * @param: buf, the tpm command buffer 
+ * @param: len, the tpm command size
+* @return: In case of success the number of bytes received.
+ *			In other case, a < 0 value describing the issue.
+ */
+static int tpm_stm_spi_recv(struct tpm_chip *chip, unsigned char *buf,
+			    size_t count)
+{
+	int size = 0;
+	int expected;	
+
+	struct spi_device* client;
+	struct st33zp24_platform_data* pin_infos;
+
+
+	FUNC_ENTER();
+
+	client = (struct spi_device *)chip->vendor.iobase;
+	pin_infos = client->dev.platform_data;
+
+
+	if (chip == NULL)
+		return -EBUSY;
+	if (count < TPM_HEADER_SIZE) {
+                size = -EIO;
+                goto out;
+        }	
+
+        /* read first 10 bytes, including tag, paramsize, and result */
+        if ((size =
+             recv_data(chip, buf, TPM_HEADER_SIZE)) < TPM_HEADER_SIZE) {
+                dev_err(chip->dev, "Unable to read header\n");
+                goto out;
+        }
+
+        expected = be32_to_cpu(*(__be32 *) (buf + 2));
+        if (expected > count) {
+                size = -EIO;
+                goto out;
+        }
+
+        if ((size +=
+             recv_data(chip, &buf[TPM_HEADER_SIZE],
+                       expected - TPM_HEADER_SIZE)) < expected) {
+                dev_err(chip->dev, "Unable to read remainder of result\n");
+                size = -ETIME;
+                goto out;
+        }
+
+out:
+	chip->vendor.cancel(chip);
+        release_locality(chip); 
+	return size;
+}
+
+/*
+ * tpm_stm_spi_send send TPM locality 4 hash through the SPI bus.
+ * @param: chip, the tpm chip description
+ * @param: buf, the tpm data buffer 
+ * @param: len, the tpm data size 
+ * @return: In case of success the number of bytes sent.
+ *			In other case, a < 0 value describing the issue.
+ */
+static int tpm_stm_spi_send_hash(struct tpm_chip *chip, unsigned char *buf,
+			    size_t len)
+{
+	u32 ret = 0, burstcnt, i, size;
+	u8 data;
+	
+	struct spi_device* client;
+	struct st33zp24_platform_data* pin_infos;	
+
+	FUNC_ENTER();
+
+	if (chip == NULL)
+		return -EBUSY;
+
+	client = (struct spi_device *)chip->vendor.iobase;
+	pin_infos = client->dev.platform_data;
+
+	ret = request_locality(chip);
+        if (ret < 0)
+                goto end;
+
+	data = TPM_DUMMY_BYTE;
+	/* HASH_START */
+	ret = SPI_WRITE_DATA(chip, TPM_HASH_START, &data, 1);
+	if (ret < 0)
+		goto end;
+
+	/* Send data  */
+	for ( i = 0 ; i < len ; )
+	{
+		burstcnt = get_burstcount(chip);		
+		if (burstcnt < 0)
+			goto end;	
+		size = min_t(int, len - i, burstcnt);
+	        ret = SPI_WRITE_DATA(chip, TPM_DATA_FIFO, buf + i, size);		
+		if (ret < 0)
+			goto end;
+		i += size;
+	}
+	
+end: 
+	/* HASH_END   */
+	ret = SPI_WRITE_DATA(chip, TPM_HASH_END, &data, 1);	
+	return ret;
+}
+
+
+/*
+ * tpm_st33_spi_ioctl provides 2 handles:
+ * - TPMIOC_CANCEL: allow to CANCEL a TPM commands execution.
+ *   See tpm_stm_spi_cancel description above
+ * - TPMIOC_TRANSMIT: allow to transmit a TPM commands.
+ * - TPMIOC_HASH: allow to compute a locality 4 hash
+ * - TPMIOC_CHANGELOCALITY: allow to change the current locality
+ *
+ * @return: In case of success, return TPM response size.
+ * In other case return < 0 value describing the issue.
+ */
+static ssize_t tpm_st33_spi_ioctl(struct inode *inode, struct file *file,
+				  unsigned int cmd, unsigned long arg)
+{
+	int in_size = 0, out_size = 0, rc;
+	int status;
+	unsigned long stop = 0;
+	struct tpm_chip *chip = file->private_data;
+	st_tpm_hash_t hash_data;
+
+	FUNC_ENTER();	
+
+	switch (cmd) {
+	case TPMIOC_CANCEL:
+		tpm_stm_spi_cancel(chip);
+		return 0;
+	case TPMIOC_TRANSMIT:
+		if (copy_from_user(chip->data_buffer,
+		    (const char *)arg, TPM_HEADER_SIZE))
+			return -EFAULT;
+		in_size = responseSize(chip->data_buffer,
+				      TPM_HEADER_SIZE);
+		if (copy_from_user(chip->data_buffer,
+				   (const char *)arg, in_size))
+			return -EFAULT;
+		tpm_stm_spi_send(chip, chip->data_buffer, in_size);
+
+		out_size = tpm_stm_spi_recv(chip, chip->data_buffer,
+					    TPM_BUFSIZE);
+
+		if (copy_to_user((char *)arg, chip->data_buffer,
+				 out_size))
+			return -EFAULT;
+		
+		return out_size;
+	case TPMIOC_HASH:
+		if (chip->vendor.locality == LOCALITY4 )
+		{
+			if (copy_from_user(&hash_data,
+		   			 (st_tpm_hash_t __user *)arg, sizeof(st_tpm_hash_t)))
+				return -EFAULT;
+			tpm_stm_spi_send_hash(chip, hash_data.data, hash_data.size);
+
+			if (chip->vendor.irq)
+			{
+				rc = wait_event_interruptible_timeout(chip->vendor.read_queue,
+        		                         (check_locality(chip) != chip->vendor.locality),
+                                                 chip->vendor.timeout_a);
+				if (rc < 0)
+					return -ETIME;
+				return hash_data.size; 
+			}
+
+	       		stop = jiffies + chip->vendor.timeout_a;
+	       		do {
+       				msleep(TPM_TIMEOUT);
+	       			status = check_locality(chip); 
+        			if (status != chip->vendor.locality)
+                			return hash_data.size;
+			} while (time_before(jiffies, stop));
+			
+			return -ETIME;
+		} 
+                return -ENOSYS;
+                break;
+        case TPMIOC_CHANGELOCALITY:
+		if ( arg >= LOCALITY0 && arg <= LOCALITY4 )
+		{
+			chip->vendor.locality = arg;
+			return 0;
+		}
+		return -ENOSYS;
+                break; 
+	default:
+		return -ENOTTY;
+	}
+	return -ENOTTY;
+}
+
+static const struct file_operations tpm_st33_spi_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.read = tpm_read,
+	.compat_ioctl = tpm_st33_spi_ioctl,
+	.write = tpm_write,
+	.open = tpm_open,
+	.release = tpm_release,
+};
+
+static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
+static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
+static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
+static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
+static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
+static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated, NULL);
+static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps_1_2, NULL);
+static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
+
+static struct attribute *stm_tpm_attrs[] = {
+	&dev_attr_pubek.attr,
+	&dev_attr_pcrs.attr,
+	&dev_attr_enabled.attr,
+	&dev_attr_active.attr,
+	&dev_attr_owned.attr,
+	&dev_attr_temp_deactivated.attr,
+	&dev_attr_caps.attr,
+	&dev_attr_cancel.attr, NULL,
+};
+
+static struct attribute_group stm_tpm_attr_grp = {
+	.attrs = stm_tpm_attrs
+};
+
+static struct tpm_vendor_specific st_spi_tpm = {
+	.send = tpm_stm_spi_send,
+	.recv = tpm_stm_spi_recv,
+	.cancel = tpm_stm_spi_cancel,
+	.status = tpm_stm_spi_status,
+	.attr_group = &stm_tpm_attr_grp,
+	.miscdev = {.fops = &tpm_st33_spi_fops,},
+};
+
+static int evaluate_latency(struct tpm_chip* chip)
+{
+	int latency = 0;
+        struct spi_device* dev = (struct spi_device*) chip->vendor.iobase;
+	struct st33zp24_platform_data *platform_data = dev->dev.platform_data;
+	int status = 0;
+	u8 data;
+	
+	for ( ; status == 0x00 && latency < MAX_SPI_LATENCY ; latency++ )
+	{
+		platform_data->latency = latency;
+		status = SPI_READ_DATA(chip, TPM_INTF_CAPABILITY, &data, 1);		
+	}
+	return latency - 1;
+}/* evaluate_latency() */
+
+static int interrupts = 0;
+module_param(interrupts, bool, 0444);
+MODULE_PARM_DESC(interrupts, "Enable interrupts");
+
+static int power_mgt = 1;
+module_param(power_mgt, bool, 0444);
+MODULE_PARM_DESC(power_mgt, "Power Management");
+
+/*
+ * tpm_st33_spi_probe initialize the TPM device
+ * @param: client, the spi_device drescription (TPM SPI description).
+ * @param: id, the spi_device_id struct.
+ * @return: 0 in case of success.
+ *         -1 in other case.
+ */
+static int
+tpm_st33_spi_probe(struct spi_device *dev)
+{
+	u32 err;
+	u8 intmask;
+	struct tpm_chip *chip;
+	struct st33zp24_platform_data *platform_data;
+
+	FUNC_ENTER();
+
+	err = 0;
+
+	/* Check SPI platform functionnalities */
+	if (dev == NULL) {
+		pr_info("dev is NULL. exiting.\n");
+		err = -ENODEV;
+		goto end;
+	}
+
+	chip = tpm_register_hardware(&dev->dev, &st_spi_tpm);
+	if (!chip) {
+		err = -ENODEV;
+		goto end;
+	}
+
+	/* Allocation of SPI buffers MISO and MOSI 	      */
+	/* Size is as follow: 			   	      */
+	/* Request burstcount value  = 0x800 = 2048	      */
+	/* +						      */
+	/* Response burstcount value = 0x400 = 1024	      */			
+	/* +						      */
+        /* At least:					      */
+	/* 1 byte for direction/locality	      	      */
+	/* 1 byte tpm tis register			      */
+	/* 2 bytes spi data length (for request only)	      */	
+	/* 2 latency bytes				      */
+	/* 1 status byte				      */  
+	/* = 2048 + 1024 + 7				      */
+	/* We reserved 2048 + 1024 + 20 in case latency byte  */
+	/* change 					      */
+	platform_data = dev->dev.platform_data;
+	platform_data->tpm_spi_buffer[0] =
+	    kmalloc((TPM_BUFSIZE + (TPM_BUFSIZE / 2) + TPM_DIGEST_SIZE) * sizeof(u8), GFP_KERNEL);
+	if (platform_data->tpm_spi_buffer[0] == NULL) {
+		err = -ENOMEM;
+		goto _tpm_clean_answer;
+	}
+	platform_data->tpm_spi_buffer[1] =
+	    kmalloc((TPM_BUFSIZE + (TPM_BUFSIZE / 2) + TPM_DIGEST_SIZE) * sizeof(u8) , GFP_KERNEL);
+	if (platform_data->tpm_spi_buffer[1] == NULL) {
+		err = -ENOMEM;
+		goto _tpm_clean_response;
+	}
+
+	chip->vendor.iobase = dev;
+
+	/* Default timeouts */
+        chip->vendor.timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+        chip->vendor.timeout_b = msecs_to_jiffies(TIS_LONG_TIMEOUT);
+        chip->vendor.timeout_c = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+        chip->vendor.timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+	chip->vendor.locality = LOCALITY0;
+
+	if ( power_mgt )
+	{
+		err = gpio_request(platform_data->io_lpcpd, "TPM IO_LPCPD");
+		if (err)
+			goto _gpio_init1; 
+		gpio_set_value(platform_data->io_lpcpd, 1);
+	}
+
+	platform_data->latency = evaluate_latency(chip);
+	if (platform_data->latency <= 0x00) {
+		err = -ENODEV;
+		goto _gpio_init1;
+	}
+
+	/* Enable interrupt */
+	/* Register GPIO pin through generic Linux GPIO API */
+	if (interrupts) {
+		init_completion(&platform_data->irq_detection);	
+		if (request_locality(chip) != LOCALITY0) {
+                	err = -ENODEV;
+	                goto _tpm_clean_response;
+        	}	
+		err = gpio_request(platform_data->io_serirq, "TPM IO_SERIRQ");
+		if (err)
+			goto _gpio_init2; 
+
+		/* Clear all existing */
+		clear_interruption(chip);
+		err = request_irq(gpio_to_irq(platform_data->io_serirq), &tpm_ioserirq_handler,
+        		        IRQF_TRIGGER_HIGH | IRQF_SHARED,
+		                "TPM SERIRQ management", chip);
+		if (err < 0) {
+
+                	pr_info("TPM SERIRQ signals %d not available\n",
+                       	gpio_to_irq(platform_data->io_serirq));
+			goto _irq_set;
+		}
+		err = SPI_READ_DATA(chip, TPM_INT_ENABLE, &intmask, 1);
+		if (err < 0)
+			goto _irq_set; 
+
+        	intmask |= TPM_INTF_CMD_READY_INT
+			|  TPM_INTF_FIFO_AVALAIBLE_INT 
+			|  TPM_INTF_WAKE_UP_READY_INT 
+		        |  TPM_INTF_LOC4SOFTRELEASE_INT
+			|  TPM_INTF_LOCALITY_CHANGE_INT
+			|  TPM_INTF_STS_VALID_INT
+			|  TPM_INTF_DATA_AVAIL_INT;
+
+       		err = SPI_WRITE_DATA(chip, TPM_INT_ENABLE, &intmask, 1);	
+		if (err < 0)
+			goto _irq_set;
+
+		intmask = TPM_GLOBAL_INT_ENABLE;
+		err = SPI_WRITE_DATA(chip, TPM_INT_ENABLE + 3, &intmask, 1);
+		if (err < 0)
+			goto _irq_set;
+
+		err = SPI_READ_DATA(chip, TPM_INT_STATUS, &intmask, 1);
+		if (err < 0)
+			goto _irq_set;
+
+		chip->vendor.irq = interrupts;
+
+                tpm_gen_interrupt(chip);
+        } 	
+
+	tpm_get_timeouts(chip);
+
+	/* attach chip datas to client */
+	spi_set_drvdata(dev, chip);
+	platform_data->bChipF = false;
+	
+	pr_info("TPM SPI Initialized\n");
+	return 0;
+_irq_set:
+        free_irq(gpio_to_irq(platform_data->io_serirq), chip);
+_gpio_init2:
+        if (platform_data && interrupts) {
+                gpio_free(platform_data->io_serirq);
+        }
+_gpio_init1:
+	if ( platform_data && power_mgt ) {
+		gpio_free(platform_data->io_lpcpd);
+	}
+_tpm_clean_response:
+	tpm_remove_hardware(chip->dev);
+	if (platform_data->tpm_spi_buffer[1] != NULL) {
+		kfree(platform_data->tpm_spi_buffer[1]);
+		platform_data->tpm_spi_buffer[1] = NULL;
+	}
+_tpm_clean_answer:
+	if (platform_data->tpm_spi_buffer[0] != NULL) {
+		kfree(platform_data->tpm_spi_buffer[0]);
+		platform_data->tpm_spi_buffer[0] = NULL;
+	}
+	
+	platform_data->bChipF = true;
+end:
+	pr_info("TPM SPI initialisation fail\n");
+	return err;
+}
+
+/*
+ * tpm_st33_spi_remove remove the TPM device
+ * @param: client, the spi_device drescription (TPM SPI description).
+		clear_bit(0, &chip->is_open);
+ * @return: 0 in case of success.
+ */
+static __devexit int tpm_st33_spi_remove(struct spi_device *client)
+{
+	struct tpm_chip *chip = (struct tpm_chip *)spi_get_drvdata(client);
+	struct st33zp24_platform_data* pin_infos = 
+		((struct spi_device* ) chip->vendor.iobase)->dev.platform_data;
+
+	FUNC_ENTER();
+
+	if (pin_infos != NULL) {
+		gpio_free(pin_infos->io_lpcpd);
+
+		/* Check if chip has been previously clean */
+		if (pin_infos->bChipF != true)
+			tpm_remove_hardware(chip->dev);
+		if (pin_infos->tpm_spi_buffer[1] != NULL) {
+			kfree(pin_infos->tpm_spi_buffer[1]);
+			pin_infos->tpm_spi_buffer[1] = NULL;
+		}
+		if (pin_infos->tpm_spi_buffer[0] != NULL) {
+			kfree(pin_infos->tpm_spi_buffer[0]);
+			pin_infos->tpm_spi_buffer[0] = NULL;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * tpm_st33_spi_pm_suspend suspend the TPM device
+ * Added: Work around when suspend and no tpm application is running, suspend
+ * may fail because chip->data_buffer is not set (only set in tpm_open in Linux
+ * TPM core)
+ * @param: client, the spi_device drescription (TPM SPI description).
+ * @param: mesg, the power management message.
+ * @return: 0 in case of success.
+ */
+static int tpm_st33_spi_pm_suspend(struct spi_device *client, pm_message_t mesg)
+{
+	struct tpm_chip *chip =
+	    (struct tpm_chip *)spi_get_drvdata(client);
+	struct st33zp24_platform_data* pin_infos = 
+		((struct spi_device *)chip->vendor.iobase)->dev.platform_data;
+	int ret = 0;	
+
+	if ( power_mgt )
+		gpio_set_value(pin_infos->io_lpcpd, 0);
+	else
+	{
+		if (chip->data_buffer == NULL)
+			chip->data_buffer = pin_infos->tpm_spi_buffer[0];
+		ret = tpm_pm_suspend(&client->dev, mesg);
+	}
+	return ret;
+}				/* tpm_st33_spi_suspend() */
+
+/*
+ * tpm_st33_spi_pm_resume resume the TPM device
+ * @param: spi, the spi_device drescription (TPM SPI description).
+ * @return: 0 in case of success.
+ */
+static int tpm_st33_spi_pm_resume(struct spi_device *spi)
+{
+	struct tpm_chip *chip =
+	    (struct tpm_chip *)spi_get_drvdata(spi);
+	struct st33zp24_platform_data* pin_infos = 
+		((struct spi_device *)chip->vendor.iobase)->dev.platform_data;
+	
+	int ret = 0;
+	if ( power_mgt ) {
+                gpio_set_value(pin_infos->io_lpcpd, 1);
+                ret = wait_for_serirq_timeout(chip, (chip->vendor.status(chip) &&
+                                                  TPM_STS_VALID) == TPM_STS_VALID,
+                                                  chip->vendor.timeout_b);
+        } else {
+		if (chip->data_buffer == NULL)
+			chip->data_buffer = pin_infos->tpm_spi_buffer[0];
+		ret = tpm_pm_resume(&spi->dev);
+		if (!ret)
+			tpm_continue_selftest(chip); 
+	}
+	return ret;
+}				/* tpm_st33_spi_pm_resume() */
+
+static struct spi_driver tpm_st33_spi_driver = {
+	.driver = {
+		   .owner = THIS_MODULE,
+		   .name = TPM_ST33_SPI,
+		   },
+	.probe = tpm_st33_spi_probe,
+	.remove = tpm_st33_spi_remove,
+	.resume = tpm_st33_spi_pm_resume,
+	.suspend = tpm_st33_spi_pm_suspend,
+};
+
+/*
+ * tpm_st33_spi_init initialize driver
+ * @return: 0 if successful, else non zero value.
+ */
+static int __init tpm_st33_spi_init(void)
+{
+	FUNC_ENTER();
+	return spi_register_driver(&tpm_st33_spi_driver);
+}
+
+/*
+ * tpm_st33_spi_exit The kernel calls this function during unloading the
+ * module or during shut down process
+ */
+static void __exit tpm_st33_spi_exit(void)
+{
+	FUNC_ENTER();
+	spi_unregister_driver(&tpm_st33_spi_driver);
+}
+
+module_init(tpm_st33_spi_init);
+module_exit(tpm_st33_spi_exit);
+
+MODULE_AUTHOR("Christophe Ricard (tpmsupport@st.com)");
+MODULE_DESCRIPTION("STM TPM SPI ST33 Driver");
+MODULE_VERSION("1.2.0");
+MODULE_LICENSE("GPL");
diff --git a/drivers/char/tpm/tpm_stm_st33_spi.h b/drivers/char/tpm/tpm_stm_st33_spi.h
new file mode 100644
index 0000000..dfcc7fd
--- /dev/null
+++ b/drivers/char/tpm/tpm_stm_st33_spi.h
@@ -0,0 +1,80 @@
+/*
+ * STMicroelectronics TPM I2C Linux driver for TPM ST33NP18
+ * Copyright (C) 2009, 2010  STMicroelectronics
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * STMicroelectronics version 1.2.0, Copyright (C) 2010
+ * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
+ * This is free software, and you are welcome to redistribute it
+ * under certain conditions.
+ *
+ * @Author: Christophe RICARD tpmsupport@st.com
+ *
+ * @File: stm_st33_tpm_i2c.h
+ *
+ * @Date: 09/15/2010
+ */
+#ifndef __STM_ST33_TPM_I2C_MAIN_H__
+#define __STM_ST33_TPM_I2C_MAIN_H__
+
+#include <linux/pci.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/i2c.h>
+//#include <linux/i2c-id.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+
+#define MINOR_NUM_I2C		224
+
+/*#define TPM_DRIVER_NAME		"st33np18_i2c"*/
+
+#define TPM_ACCESS			(0x0)		
+#define TPM_STS				(0x18)
+#define TPM_HASH_END			(0x20)
+#define TPM_DATA_FIFO			(0x24)
+#define TPM_HASH_DATA			(0x24)
+#define TPM_HASH_START			(0x28)
+#define TPM_INTF_CAPABILITY		(0x14)
+#define TPM_INT_STATUS			(0x10)
+#define TPM_INT_ENABLE			(0x08)
+
+#define TPM_DUMMY_BYTE			0x00
+#define TPM_WRITE_DIRECTION		0x80
+#define TPM_HEADER_SIZE 		10
+#define TPM_BUFSIZE			2048
+
+/* ioctl commands */
+#define TPMIOC_CANCEL		_IO('T', 0x00)	
+#define TPMIOC_TRANSMIT		_IO('T', 0x01)
+#define TPMIOC_HASH		_IO('T', 0x02)
+#define TPMIOC_CHANGELOCALITY	_IO('T', 0x03)
+
+#define LOCALITY0		0
+#define LOCALITY4		4
+
+#define TPM_ST_SPI_OK 		0x5A
+
+
+#define MAX_SPI_LATENCY		15
+
+typedef struct st_tpm_hash
+{
+        int size;
+        u8* data;
+}st_tpm_hash_t;
+
+#endif /* __STM_ST33_TPM_I2C_MAIN_H__ */
diff --git a/include/linux/i2c/tpm_stm_st19_i2c.h b/include/linux/i2c/tpm_stm_st19_i2c.h
new file mode 100644
index 0000000..d97f50f
--- /dev/null
+++ b/include/linux/i2c/tpm_stm_st19_i2c.h
@@ -0,0 +1,42 @@
+/*
+ * STMicroelectronics TPM I2C Linux driver for TPM ST19NP18
+ * Copyright (C) 2009, 2010 STMicroelectronics
+ * Christophe RICARD tpmsupport@st.com
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * STMicroelectronics version 1.2.0, Copyright (C) 2010
+ * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
+ * This is free software, and you are welcome to redistribute it
+ * under certain conditions.
+ *
+ * @File: stm_st19_tpm_i2c.h
+ *
+ * @Date: 06/15/2008
+ */
+#ifndef __STM_ST19_TPM_I2C_H__
+#define __STM_ST19_TPM_I2C_H__
+
+#include <linux/i2c.h>
+
+#define TPM_DRIVER_NAME         "st19np18"
+#define TPM_I2C_ST19_ADDR_WR	(0x26 >> 1)	/*0x13 7 bits address */
+
+struct st19np18_platform_data {
+	int accept_pin;		/* accept command pin */
+	int data_avail_pin;	/* data available pin */
+	struct i2c_client *client;
+};
+
+#endif /* __STM_ST19_TPM_I2C_H__ */
diff --git a/include/linux/i2c/tpm_stm_st33_i2c.h b/include/linux/i2c/tpm_stm_st33_i2c.h
new file mode 100644
index 0000000..2d0991e
--- /dev/null
+++ b/include/linux/i2c/tpm_stm_st33_i2c.h
@@ -0,0 +1,48 @@
+/*
+* STMicroelectronics TPM I2C Linux driver for TPM ST33ZP24
+* Copyright (C) 2009, 2010 STMicroelectronics
+* Christophe RICARD tpmsupport@st.com
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License as published by
+* the Free Software Foundation; either version 2 of the License, or
+* (at your option) any later version.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License along
+* with this program; if not, write to the Free Software Foundation, Inc.,
+* 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+*
+* STMicroelectronics version 1.2.0, Copyright (C) 2010
+* STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
+* This is free software, and you are welcome to redistribute it
+* under certain conditions.
+*
+* @File: stm_st33_tpm_i2c.h
+*
+* @Date: 06/15/2008
+*/
+#ifndef __STM_ST33_TPM_I2C_H__
+#define __STM_ST33_TPM_I2C_H__
+
+#include <linux/i2c.h>
+
+#define TPM_ST33_I2C		    	"st33zp24_i2c"
+#define TPM_I2C_ST33_ADDR_WR_LOC0	(0x26 >> 1)
+#define TPM_I2C_ST33_ADDR_WR_LOC4	(0x36 >> 1)
+
+
+struct st33zp24_platform_data {
+	int io_serirq;	
+	int io_lpcpd;
+	struct i2c_client *client;
+	bool bChipF;
+	u8 *tpm_i2c_buffer[2]; /* 0 Request 1 Response */
+	struct completion irq_detection;
+	struct mutex lock;
+};
+
+#endif /* __STM_ST33_TPM_I2C_H__ */
diff --git a/include/linux/spi/tpm_stm_st33_spi.h b/include/linux/spi/tpm_stm_st33_spi.h
new file mode 100644
index 0000000..4bf31c4
--- /dev/null
+++ b/include/linux/spi/tpm_stm_st33_spi.h
@@ -0,0 +1,46 @@
+/*
+* STMicroelectronics TPM SPI Linux driver for TPM ST33NP18
+* Copyright (C) 2009, 2010 STMicroelectronics
+* Christophe RICARD tpmsupport@st.com
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License as published by
+* the Free Software Foundation; either version 2 of the License, or
+* (at your option) any later version.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License along
+* with this program; if not, write to the Free Software Foundation, Inc.,
+* 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+*
+* STMicroelectronics version 1.2.0, Copyright (C) 2010
+* STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
+* This is free software, and you are welcome to redistribute it
+* under certain conditions.
+*
+* @File: stm_st33_tpm_spi.h
+*
+* @Date: 06/15/2008
+*/
+#ifndef __STM_ST33_TPM_SPI_H__
+#define __STM_ST33_TPM_SPI_H__
+
+#include <linux/spi/spi.h>
+
+#define TPM_ST33_SPI		"st33zp24_spi"
+
+#ifndef __STM_ST33_TPM_I2C_H__
+struct st33zp24_platform_data {
+	int io_serirq;
+	int io_lpcpd;
+	int latency;
+	bool bChipF;
+	u8 *tpm_spi_buffer[2]; /* 0 Request 1 Response */
+	struct completion irq_detection;
+};
+#endif
+
+#endif /* __STM_ST33_TPM_SPI_H__ */
-- 
1.7.1

