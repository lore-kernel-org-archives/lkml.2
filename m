Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab1HOOTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 10:19:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56318 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab1HOOTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 10:19:05 -0400
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Anton Vorontsov <avorontsov@ru.mvista.com>,
        Kumar Gala <galak@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@gmail.com>
Subject: [PATCH] mcu_mpc8349emitx.c: add shutdown request support
Date: Mon, 15 Aug 2011 16:19:30 +0200
Message-Id: <1313417970-28098-1-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add support for calling ctrl_alt_del() when the power button is
pressed for more than about 2 seconds on some freescale MPC83xx
evaluation boards and reference design.

The code uses a kthread to poll the CTRL_BTN bit each second.

Also change Kconfig entry of the driver to bool, as device's gpio
registration is broken when loading as module.

Tested on an MPC8315E RDB board.

Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
---
 arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c |   58 +++++++++++++++++++++++-
 arch/powerpc/platforms/Kconfig                 |    2 +-
 2 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c b/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
index 70798ac..ef6537b 100644
--- a/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
+++ b/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
@@ -21,6 +21,8 @@
 #include <linux/of.h>
 #include <linux/of_gpio.h>
 #include <linux/slab.h>
+#include <linux/kthread.h>
+#include <linux/reboot.h>
 #include <asm/prom.h>
 #include <asm/machdep.h>
 
@@ -30,6 +32,7 @@
  */
 #define MCU_REG_CTRL	0x20
 #define MCU_CTRL_POFF	0x40
+#define MCU_CTRL_BTN	0x80
 
 #define MCU_NUM_GPIO	2
 
@@ -42,13 +45,55 @@ struct mcu {
 
 static struct mcu *glob_mcu;
 
+struct task_struct *shutdown_thread;
+static int shutdown_thread_fn(void *data)
+{
+	int ret;
+	struct mcu *mcu = glob_mcu;
+
+	while (!kthread_should_stop()) {
+		ret = i2c_smbus_read_byte_data(mcu->client, MCU_REG_CTRL);
+		if (ret < 0)
+			pr_err("MCU status reg read failed.\n");
+		mcu->reg_ctrl = ret;
+
+
+		if (mcu->reg_ctrl & MCU_CTRL_BTN) {
+			i2c_smbus_write_byte_data(mcu->client, MCU_REG_CTRL,
+						  mcu->reg_ctrl & ~MCU_CTRL_BTN);
+
+			ctrl_alt_del();
+		}
+
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(HZ);
+	}
+
+	return 0;
+}
+
+static ssize_t show_status(struct device *d,
+			   struct device_attribute *attr, char *buf)
+{
+	int ret;
+	struct mcu *mcu = glob_mcu;
+
+	ret = i2c_smbus_read_byte_data(mcu->client, MCU_REG_CTRL);
+	if (ret < 0)
+		return -ENODEV;
+	mcu->reg_ctrl = ret;
+
+	return sprintf(buf, "%02x\n", ret);
+}
+static DEVICE_ATTR(status, S_IRUGO, show_status, NULL);
+
 static void mcu_power_off(void)
 {
 	struct mcu *mcu = glob_mcu;
 
 	pr_info("Sending power-off request to the MCU...\n");
 	mutex_lock(&mcu->lock);
-	i2c_smbus_write_byte_data(glob_mcu->client, MCU_REG_CTRL,
+	i2c_smbus_write_byte_data(mcu->client, MCU_REG_CTRL,
 				  mcu->reg_ctrl | MCU_CTRL_POFF);
 	mutex_unlock(&mcu->lock);
 }
@@ -130,6 +175,13 @@ static int __devinit mcu_probe(struct i2c_client *client,
 		dev_info(&client->dev, "will provide power-off service\n");
 	}
 
+	if (device_create_file(&client->dev, &dev_attr_status))
+		dev_err(&client->dev,
+			"couldn't create device file for status\n");
+
+	shutdown_thread = kthread_run(shutdown_thread_fn, NULL,
+				      "mcu-i2c-shdn");
+
 	return 0;
 err:
 	kfree(mcu);
@@ -141,6 +193,10 @@ static int __devexit mcu_remove(struct i2c_client *client)
 	struct mcu *mcu = i2c_get_clientdata(client);
 	int ret;
 
+	kthread_stop(shutdown_thread);
+
+	device_remove_file(&client->dev, &dev_attr_status);
+
 	if (glob_mcu == mcu) {
 		ppc_md.power_off = NULL;
 		glob_mcu = NULL;
diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
index b9ba861..7bfd30e 100644
--- a/arch/powerpc/platforms/Kconfig
+++ b/arch/powerpc/platforms/Kconfig
@@ -355,7 +355,7 @@ config SIMPLE_GPIO
 	  on-board peripherals.
 
 config MCU_MPC8349EMITX
-	tristate "MPC8349E-mITX MCU driver"
+	bool "MPC8349E-mITX MCU driver"
 	depends on I2C && PPC_83xx
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
-- 
1.7.5.1

