Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab2KPE5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 23:57:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:24140 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab2KPE5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 23:57:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,261,1352102400"; 
   d="scan'208";a="243039610"
Subject: [PATCH] serial: ifx6x60: Add module parameters to manage the modem
 status through sysfs
From: Jun Chen <jun.d.chen@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: serial <linux-serial@vger.kernel.org>, "russ.gorby" <russ.gorby@intel.com>,
        liu chuansheng <chuansheng.liu@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jun Chen <jun.d.chen@intel.com>, Bi Chao <chao.bi@intel.com>,
        Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Nov 2012 07:59:49 -0500
Message-ID: <1353070789.24092.6.camel@chenjun-workstation>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The Medfield Platform implements a recovery procedure consisting in an escalation
from simple and light recovery procedures to stronger ones with increased visibility
and impact to end-user.After platform find some problem from Modem,such as no response,
platform will try do modem warm reset.If several tries failed, platform will try to
do modem cold boot procedure.For Modem Cold Boot, AP is responsible to generate
blob (binary object containing PIN code and other necessary information).
Blob is stored in AP volatile memory. AP decides to read PIN code from cache instead of
prompting end-user, and sends it to modem as if end-user had entered it.

This patch add module parameters to manage the modem status through sysfs.
Reset_modem can be read and write by user space.When read the reset_modem,user space will
get the mdm_reset_state which used to avoid to run twice at once.When set the reset_modem to
IFX_COLD_RESET_REQ,modem will do cold reset, other val value will trigger modem reset.

Hangup_reasons used to give one interface to user space to know and clear the modem reset reasons.
Now there are four reasons:SPI timeout, modem initiative reset,modem coredump,spi tranfer error.

Cc: Bi Chao <chao.bi@intel.com>
Cc: Liu chuansheng <chuansheng.liu@intel.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Chen Jun <jun.d.chen@intel.com>
---
 drivers/tty/serial/Kconfig   |    2 +-
 drivers/tty/serial/ifx6x60.c |  193 ++++++++++++++++++++++++++++++++++++++++++
 drivers/tty/serial/ifx6x60.h |    8 ++
 3 files changed, 202 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 2a53be5..640b36a 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1323,7 +1323,7 @@ config SERIAL_ALTERA_UART_CONSOLE
 
 config SERIAL_IFX6X60
         tristate "SPI protocol driver for Infineon 6x60 modem (EXPERIMENTAL)"
-	depends on GPIOLIB && SPI
+	depends on GPIOLIB && SPI && X86_INTEL_MID && INTEL_SCU_IPC
 	help
 	  Support for the IFX6x60 modem devices on Intel MID platforms.
 
diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index 5b9bc19..c17efc6 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -60,6 +60,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/spi/ifx_modem.h>
 #include <linux/delay.h>
+#include <asm/intel_scu_ipc.h>
 
 #include "ifx6x60.h"
 
@@ -72,6 +73,27 @@
 #define IFX_SPI_HEADER_0		(-1)
 #define IFX_SPI_HEADER_F		(-2)
 
+
+/* Delays for powering up/resetting the modem, ms */
+#define PO_INTERLINE_DELAY	1
+#define PO_POST_DELAY		200
+
+#define IFX_COLD_RESET_REQ	1
+
+#define IFX_MDM_PWR_ON	3
+#define IFX_MDM_RST_PMU	4
+
+/* For modem cold boot */
+#define V1P35CNT_W		0x0E0	/* PMIC register used to power off */
+/* the modem */
+#define V1P35_OFF	4
+#define V1P35_ON		6
+#define COLD_BOOT_DELAY_OFF_MIN	20000	/* 20 ms (use of usleep_range) */
+#define COLD_BOOT_DELAY_OFF_MAX	25000	/* 25 ms (use of usleep_range) */
+#define COLD_BOOT_DELAY_ON_MIN	10000	/* 10 ms (use of usleep_range) */
+#define COLD_BOOT_DELAY_ON_MAX	15000	/* 15 ms (use of usleep_range) */
+
+
 /* forward reference */
 static void ifx_spi_handle_srdy(struct ifx_spi_device *ifx_dev);
 
@@ -81,6 +103,35 @@ static struct tty_driver *tty_drv;
 static struct ifx_spi_device *saved_ifx_dev;
 static struct lock_class_key ifx_spi_key;
 
+
+/**
+ * do_modem_power - activity required to bring up modem
+ *
+ * Toggle gpios required to bring up modem power and start modem.
+ */
+static void do_modem_power(void)
+{
+	gpio_set_value(IFX_MDM_PWR_ON, 1);
+	mdelay(PO_INTERLINE_DELAY);
+	gpio_set_value(IFX_MDM_PWR_ON, 0);
+	msleep(PO_POST_DELAY);
+}
+
+/**
+ * do_modem_reset - activity required to reset modem
+ *
+ * Toggle gpios required to reset modem.
+ */
+static void do_modem_reset(void)
+{
+	gpio_set_value(IFX_MDM_RST_PMU, 0);
+	mdelay(PO_INTERLINE_DELAY);
+	gpio_set_value(IFX_MDM_RST_PMU, 1);
+	msleep(PO_POST_DELAY);
+}
+
+
+
 /* GPIO/GPE settings */
 
 /**
@@ -229,6 +280,7 @@ static void ifx_spi_timeout(unsigned long arg)
 	struct ifx_spi_device *ifx_dev = (struct ifx_spi_device *)arg;
 
 	dev_warn(&ifx_dev->spi_dev->dev, "*** SPI Timeout ***");
+	ifx_dev->hangup_reasons |= HU_TIMEOUT;
 	ifx_spi_ttyhangup(ifx_dev);
 	mrdy_set_low(ifx_dev);
 	clear_bit(IFX_SPI_STATE_TIMER_PENDING, &ifx_dev->flags);
@@ -881,6 +933,7 @@ static irqreturn_t ifx_spi_reset_interrupt(int irq, void *dev)
 		/* exited reset */
 		clear_bit(MR_INPROGRESS, &ifx_dev->mdm_reset_state);
 		if (solreset) {
+			clear_bit(MR_START, &ifx_dev->mdm_reset_state);
 			set_bit(MR_COMPLETE, &ifx_dev->mdm_reset_state);
 			wake_up(&ifx_dev->mdm_reset_wait);
 		}
@@ -1405,6 +1458,146 @@ static int __init ifx_spi_init(void)
 module_init(ifx_spi_init);
 module_exit(ifx_spi_exit);
 
+/*
+ * Module parameters to manage the modem status through sysfs
+ */
+
+/**
+ * reset_modem - modem reset command function
+ * @val: a reference to the string where the modem reset query is given
+ * @kp: an unused reference to the kernel parameter
+ */
+
+static int reset_modem(const char *val, const struct kernel_param *kp)
+{
+	unsigned long reset_request;
+	int err = 0;
+
+	u16 addr = V1P35CNT_W;
+	u8 data, def_value;
+
+	if (kstrtoul(val, 10, &reset_request) < 0)
+		return -EINVAL;
+
+	if (!saved_ifx_dev) {
+		dev_dbg(&saved_ifx_dev->spi_dev->dev,
+				"%s is called before probe\n", __func__);
+		return -ENODEV;
+	}
+
+	dev_dbg(&saved_ifx_dev->spi_dev->dev,
+					"%s requested !\n", __func__);
+
+	if (test_and_set_bit(MR_START, &saved_ifx_dev->mdm_reset_state))
+		return -EBUSY;
+
+	if (reset_request == IFX_COLD_RESET_REQ) {
+		gpio_set_value(IFX_MDM_RST_PMU, 0);
+
+		/* Save the current register value */
+		err = intel_scu_ipc_readv(&addr, &def_value, 1);
+		if (err) {
+			dev_err(&saved_ifx_dev->spi_dev->dev,
+				" - %s -  read error: %d", __func__, err);
+			goto out;
+		}
+
+		/* Write the new register value (V1P35_OFF) */
+		data = (def_value & 0xf8) | V1P35_OFF;
+		err =  intel_scu_ipc_writev(&addr, &data, 1);
+		if (err) {
+			dev_err(&saved_ifx_dev->spi_dev->dev,
+				" - %s -  write error: %d", __func__, err);
+			goto out;
+		}
+		usleep_range(COLD_BOOT_DELAY_OFF_MIN, COLD_BOOT_DELAY_OFF_MAX);
+
+		/* Write the new register value (V1P35_ON) */
+		data = (def_value & 0xf8) | V1P35_ON;
+		err =  intel_scu_ipc_writev(&addr, &data, 1);
+		if (err) {
+			dev_err(&saved_ifx_dev->spi_dev->dev,
+				" - %s -  write error: %d", __func__, err);
+			goto out;
+		}
+		usleep_range(COLD_BOOT_DELAY_ON_MIN, COLD_BOOT_DELAY_ON_MAX);
+
+		/* Write back the initial register value */
+		err =  intel_scu_ipc_writev(&addr, &def_value, 1);
+		if (err) {
+			dev_err(&saved_ifx_dev->spi_dev->dev,
+				" - %s -  write error: %d", __func__, err);
+			goto out;
+		}
+
+	}
+
+	/* Perform a complete modem reset */
+	do_modem_reset();
+	do_modem_power();
+
+out:
+
+	return err;
+}
+
+
+/**
+* is_modem_reset - modem reset status module parameter callback function
+ * @val: a reference to the string where the modem reset status is returned
+ * @kp: an unused reference to the kernel parameter
+ */
+static int is_modem_reset(char *val, const struct kernel_param *kp)
+{
+	if (saved_ifx_dev)
+		return sprintf(val, "%lu", saved_ifx_dev->mdm_reset_state);
+	else
+		return -ENOTTY;
+}
+
+
+/**
+ * clear_hangup_reasons - clearing all hangup reasons
+ * @val: a reference to the string where the hangup reasons clear query is given
+ * @kp: an unused reference to the kernel parameter
+ */
+static int clear_hangup_reasons(const char *val, const struct kernel_param *kp)
+{
+	if (saved_ifx_dev) {
+		saved_ifx_dev->hangup_reasons = 0;
+		return 0;
+	} else
+		return -ENOTTY;
+}
+
+/**
+ * hangup_reasons - modem hangup reasons module parameter callback function
+ * @val: a reference to the string where the hangup reasons are returned
+ * @kp: an unused reference to the kernel parameter
+ */
+
+static int hangup_reasons(char *val, const struct kernel_param *kp)
+{
+	if (saved_ifx_dev)
+		return sprintf(val, "%lu", saved_ifx_dev->hangup_reasons);
+	else
+		return -ENOTTY;
+}
+
+
+static struct kernel_param_ops reset_modem_ops = {
+	.set = reset_modem,
+	.get = is_modem_reset,
+};
+module_param_cb(reset_modem, &reset_modem_ops, NULL, 0644);
+
+static struct kernel_param_ops hangup_reasons_ops = {
+	.set = clear_hangup_reasons,
+	.get = hangup_reasons,
+};
+module_param_cb(hangup_reasons, &hangup_reasons_ops, NULL, 0644);
+
+
 MODULE_AUTHOR("Intel");
 MODULE_DESCRIPTION("IFX6x60 spi driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/tty/serial/ifx6x60.h b/drivers/tty/serial/ifx6x60.h
index e8464ba..274b468 100644
--- a/drivers/tty/serial/ifx6x60.h
+++ b/drivers/tty/serial/ifx6x60.h
@@ -66,6 +66,13 @@
 #define IFX_SPI_POWER_DATA_PENDING	1
 #define IFX_SPI_POWER_SRDY		2
 
+
+/* reasons for hanging up */
+#define	HU_TIMEOUT		1	/* spi timer out */
+#define	HU_RESET			2	/* modem initiative reset */
+#define	HU_COREDUMP		4	/* modem crash coredump */
+#define	HU_RORTUR			8	/* transfer error:ROR or TUR */
+
 struct ifx_spi_device {
 	/* Our SPI device */
 	struct spi_device *spi_dev;
@@ -120,6 +127,7 @@ struct ifx_spi_device {
 
 	/* modem reset */
 	unsigned long mdm_reset_state;
+	unsigned long hangup_reasons;
 #define MR_START	0
 #define MR_INPROGRESS	1
 #define MR_COMPLETE	2
-- 
1.7.4.1



