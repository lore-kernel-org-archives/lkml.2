Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab0JEPYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 11:24:42 -0400
Received: from imr3.ericy.com ([198.24.6.13]:35915 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908Ab0JEPYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 11:24:40 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Ben Dooks <ben-linux@fluff.org>, Rodolfo Giometti <giometti@linux.it>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH] i2c/mux: Driver for PCA9541 I2C Master Selector
Date: Tue, 5 Oct 2010 08:34:22 -0700
Message-ID: <1286292862-28805-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 drivers/i2c/muxes/Kconfig   |   10 +
 drivers/i2c/muxes/Makefile  |    1 +
 drivers/i2c/muxes/pca9541.c |  419 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 430 insertions(+), 0 deletions(-)
 create mode 100644 drivers/i2c/muxes/pca9541.c

diff --git a/drivers/i2c/muxes/Kconfig b/drivers/i2c/muxes/Kconfig
index 4c9a99c..4d91d80 100644
--- a/drivers/i2c/muxes/Kconfig
+++ b/drivers/i2c/muxes/Kconfig
@@ -5,6 +5,16 @@
 menu "Multiplexer I2C Chip support"
 	depends on I2C_MUX
 
+config I2C_MUX_PCA9541
+	tristate "NXP PCA9541 I2C Master Selector"
+	depends on EXPERIMENTAL
+	help
+	  If you say yes here you get support for the NXP PCA9541
+	  I2C Master Selector.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called pca9541.
+
 config I2C_MUX_PCA954x
 	tristate "Philips PCA954x I2C Mux/switches"
 	depends on EXPERIMENTAL
diff --git a/drivers/i2c/muxes/Makefile b/drivers/i2c/muxes/Makefile
index bd83b52..4e27d0d 100644
--- a/drivers/i2c/muxes/Makefile
+++ b/drivers/i2c/muxes/Makefile
@@ -1,6 +1,7 @@
 #
 # Makefile for multiplexer I2C chip drivers.
 
+obj-$(CONFIG_I2C_MUX_PCA9541)	+= pca9541.o
 obj-$(CONFIG_I2C_MUX_PCA954x)	+= pca954x.o
 
 ifeq ($(CONFIG_I2C_DEBUG_BUS),y)
diff --git a/drivers/i2c/muxes/pca9541.c b/drivers/i2c/muxes/pca9541.c
new file mode 100644
index 0000000..e10a5d7
--- /dev/null
+++ b/drivers/i2c/muxes/pca9541.c
@@ -0,0 +1,419 @@
+/*
+ * I2C multiplexer driver for pca9541 bus master selector
+ *
+ * Copyright (c) 2010 Ericsson AB.
+ *
+ * Author: Guenter Roeck <guenter.roeck@ericsson.com>
+ *
+ * Derived from:
+ *  driver/i2c/muxes/pca954x.c
+ *
+ *  Copyright (c) 2008-2009 Rodolfo Giometti <giometti@linux.it>
+ *  Copyright (c) 2008-2009 Eurotech S.p.A. <info@eurotech.it>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/hrtimer.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/i2c.h>
+#include <linux/i2c-mux.h>
+
+#include <linux/i2c/pca954x.h>
+
+#define PCA9541_CONTROL		0x01
+#define PCA9541_ISTAT		0x02
+
+#define PCA9541_CTL_MYBUS	(1 << 0)
+#define PCA9541_CTL_NMYBUS	(1 << 1)
+#define PCA9541_CTL_BUSON	(1 << 2)
+#define PCA9541_CTL_NBUSON	(1 << 3)
+#define PCA9541_CTL_BUSINIT	(1 << 4)
+#define PCA9541_CTL_TESTON	(1 << 6)
+#define PCA9541_CTL_NTESTON	(1 << 7)
+
+#define PCA9541_ISTAT_INTIN	(1 << 0)
+#define PCA9541_ISTAT_BUSINIT	(1 << 1)
+#define PCA9541_ISTAT_BUSOK	(1 << 2)
+#define PCA9541_ISTAT_BUSLOST	(1 << 3)
+#define PCA9541_ISTAT_MYTEST	(1 << 6)
+#define PCA9541_ISTAT_NMYTEST	(1 << 7)
+
+#define BUSON		(PCA9541_CTL_BUSON | PCA9541_CTL_NBUSON)
+#define MYBUS		(PCA9541_CTL_MYBUS | PCA9541_CTL_NMYBUS)
+#define mybus(x)	(!((x) & MYBUS) || ((x) & MYBUS) == MYBUS)
+#define busoff(x)	(!((x) & BUSON) || ((x) & BUSON) == BUSON)
+
+/*
+ * Arbitration mechanism
+ *
+ * Bus has to be acquired for each read, and has to be released after the access
+ * is complete. If bus ownership can not be acquired within ARB2_TIMEOUT,
+ * channel selection code will return -ETIMEDOUT.
+ */
+
+/* jiffies timers */
+#define ARB_TIMEOUT	(HZ / 8)	/* 125 ms */
+#define ARB2_TIMEOUT	(HZ / 4)	/* 250 ms */
+
+/* high resolution timers */
+#define SELECT_TO_SHORT	(50 * 1000)	/* 50 us */
+#define SELECT_TO_LONG	(1000 * 1000)	/* 1 ms */
+
+struct pca9541 {
+	struct i2c_adapter *virt_adap;
+	struct i2c_client *client;
+	struct hrtimer select_timer;
+	unsigned long select_timeout;
+	unsigned long arb_timeout;
+	int select_result;
+	wait_queue_head_t wq;
+};
+
+static const struct i2c_device_id pca9541_id[] = {
+	{"pca9541", 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, pca9541_id);
+
+/*
+ * Write to selector register. Don't use i2c_transfer()/i2c_smbus_xfer()
+ * as they will try to lock the adapter a second time.
+ */
+static int pca9541_reg_write(struct i2c_adapter *adap,
+			     struct i2c_client *client, u8 command, u8 val)
+{
+	int ret;
+
+	if (adap->algo->master_xfer) {
+		struct i2c_msg msg;
+		char buf[2];
+
+		msg.addr = client->addr;
+		msg.flags = 0;
+		msg.len = 2;
+		buf[0] = command;
+		buf[1] = val;
+		msg.buf = buf;
+		ret = adap->algo->master_xfer(adap, &msg, 1);
+	} else {
+		union i2c_smbus_data data;
+
+		data.byte = val;
+		ret = adap->algo->smbus_xfer(adap, client->addr,
+					     client->flags,
+					     I2C_SMBUS_WRITE,
+					     command,
+					     I2C_SMBUS_BYTE_DATA, &data);
+	}
+
+	return ret;
+}
+
+/*
+ * Read from selector register. Don't use i2c_transfer()/i2c_smbus_xfer()
+ * as they will try to lock adapter a second time.
+ */
+static int pca9541_reg_read(struct i2c_adapter *adap,
+			    struct i2c_client *client, u8 command)
+{
+	int ret;
+	u8 val;
+
+	if (adap->algo->master_xfer) {
+		struct i2c_msg msg[2] = {
+			{
+				.addr = client->addr,
+				.flags = 0,
+				.len = 1,
+				.buf = &command
+			},
+			{
+				.addr = client->addr,
+				.flags = I2C_M_RD,
+				.len = 1,
+				.buf = &val
+			}
+		};
+		ret = adap->algo->master_xfer(adap, msg, 2);
+		if (ret == 2)
+			ret = val;
+		else if (ret >= 0)
+			ret = -EIO;
+	} else {
+		union i2c_smbus_data data;
+
+		ret = adap->algo->smbus_xfer(adap, client->addr,
+					     client->flags,
+					     I2C_SMBUS_READ,
+					     command,
+					     I2C_SMBUS_BYTE_DATA, &data);
+		if (!ret)
+			ret = data.byte;
+	}
+	return ret;
+}
+
+/*
+ * Arbitration management functions
+ */
+
+static void pca9541_release_bus(struct i2c_adapter *adap,
+				struct i2c_client *client)
+{
+	int reg;
+
+	reg = pca9541_reg_read(adap, client, PCA9541_CONTROL);
+	if (reg >= 0 && !busoff(reg) && mybus(reg))
+		pca9541_reg_write(adap, client, PCA9541_CONTROL,
+				  (reg & PCA9541_CTL_NBUSON) >> 1);
+}
+
+/*
+ * Control commands per pca9541 datasheet
+ *
+ * Arbitration is defined as a two-step process. A device can only activate
+ * the bus if it owns it; otherwise it has to request ownership first.
+ * This multi-step process ensures that access contention is resolved
+ * gracefully.
+ *
+ * bus off, other master requested access
+ *			--> wait for arbitration timeout or for other master
+ *			    to release request
+ * bus off, owner	--> bus on
+ * bus off, not owner	--> take ownership
+ * bus on, owner	--> done
+ * bus on, not owner	--> wait for arbitration timeout or for other master
+ *			    to release bus
+ */
+static u8 pca9541_control[] = {
+	4, 0, 1, 5, 4, 4, 5, 5, 0, 0, 1, 1, 0, 4, 5, 1
+};
+
+/*
+ * Channel arbitration
+ *
+ * Return values:
+ *  <0: error
+ *  0 : bus not acquired
+ *  1 : bus acquired
+ */
+static int pca9541_arbitrate(struct pca9541 *data)
+{
+	struct i2c_client *client = data->client;
+	struct i2c_adapter *adap = to_i2c_adapter(client->dev.parent);
+	int reg;
+
+	reg = pca9541_reg_read(adap, client, PCA9541_CONTROL);
+	if (reg < 0)
+		return reg;
+
+	if (busoff(reg)) {
+		int istat;
+		/*
+		 * Bus is off, request ownership or turn it on unless
+		 * other master requested access.
+		 */
+		istat = pca9541_reg_read(adap, client, PCA9541_ISTAT);
+		if (!(istat & PCA9541_ISTAT_NMYTEST)
+		    || time_is_before_eq_jiffies(data->arb_timeout)) {
+			/*
+			 * Other master did not request access, or arbitration
+			 * timeout expired. Take the bus.
+			 */
+			pca9541_reg_write(adap, client,
+					  PCA9541_CONTROL,
+					  pca9541_control[reg & 0x0f]
+					  | PCA9541_CTL_NTESTON);
+			data->select_timeout = SELECT_TO_SHORT;
+		} else {
+			/* Other master requested access. */
+			data->select_timeout = SELECT_TO_LONG * 2;
+		}
+	} else if (mybus(reg)) {
+		/* Bus is on, and we own it. We are done. */
+		if (reg & (PCA9541_CTL_NTESTON | PCA9541_CTL_BUSINIT))
+			pca9541_reg_write(adap, client,
+					  PCA9541_CONTROL,
+					  reg & ~(PCA9541_CTL_NTESTON
+						  | PCA9541_CTL_BUSINIT));
+		return 1;
+	} else {
+		/* Other master owns the bus */
+		data->select_timeout = SELECT_TO_LONG;
+		if (time_is_before_eq_jiffies(data->arb_timeout)) {
+			/* Time is up, take the bus and reset it. */
+			pca9541_reg_write(adap, client,
+					  PCA9541_CONTROL,
+					  pca9541_control[reg & 0x0f]
+					  | PCA9541_CTL_BUSINIT
+					  | PCA9541_CTL_NTESTON);
+		} else {
+			/* Request bus access if needed */
+			if (!(reg & PCA9541_CTL_NTESTON))
+				pca9541_reg_write(adap, client,
+						  PCA9541_CONTROL,
+						  reg | PCA9541_CTL_NTESTON);
+		}
+	}
+	return 0;
+}
+
+/* Channel select timeout */
+static enum hrtimer_restart pca9541_select_timeout(struct hrtimer *hrtimer)
+{
+	struct pca9541 *data = container_of(hrtimer, struct pca9541,
+					    select_timer);
+	int ret;
+
+	ret = pca9541_arbitrate(data);
+	if (ret)
+		goto wakeup;
+
+	hrtimer_forward(hrtimer, ktime_get(),
+			ktime_set(0, data->select_timeout));
+	return HRTIMER_RESTART;
+
+wakeup:
+	data->select_result = ret;
+	wake_up(&data->wq);
+	return HRTIMER_NORESTART;
+}
+
+static int pca9541_select_chan(struct i2c_adapter *adap, void *client, u32 chan)
+{
+	struct pca9541 *data = i2c_get_clientdata(client);
+	int ret;
+
+	data->arb_timeout = jiffies + ARB_TIMEOUT;
+	data->select_result = 0;
+
+	ret = pca9541_arbitrate(data);
+	if (ret)
+		return ret < 0 ? ret : 0;
+
+	hrtimer_start(&data->select_timer,
+		      ktime_set(0, data->select_timeout), HRTIMER_MODE_REL);
+	ret = wait_event_timeout(data->wq, data->select_result, ARB2_TIMEOUT);
+	hrtimer_cancel(&data->select_timer);
+
+	if (ret == 0 && data->select_result == 0)
+		return -ETIMEDOUT;
+
+	if (data->select_result < 0)
+		return data->select_result;
+
+	return 0;
+}
+
+static int pca9541_release_chan(struct i2c_adapter *adap,
+				void *client, u32 chan)
+{
+	pca9541_release_bus(adap, client);
+	return 0;
+}
+
+/*
+ * I2C init/probing/exit functions
+ */
+static int __devinit pca9541_probe(struct i2c_client *client,
+				   const struct i2c_device_id *id)
+{
+	struct i2c_adapter *adap = to_i2c_adapter(client->dev.parent);
+	struct pca954x_platform_data *pdata = client->dev.platform_data;
+	struct pca9541 *data;
+	int force;
+	int ret = -ENODEV;
+
+	if (!i2c_check_functionality(adap, I2C_FUNC_SMBUS_BYTE_DATA))
+		goto err;
+
+	/* Read control register to verify that the device exists */
+	if (i2c_smbus_read_byte_data(client, PCA9541_CONTROL) < 0)
+		goto err;
+
+	data = kzalloc(sizeof(struct pca9541), GFP_KERNEL);
+	if (!data) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	hrtimer_init(&data->select_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	data->select_timer.function = pca9541_select_timeout;
+
+	init_waitqueue_head(&data->wq);
+
+	data->client = client;
+	i2c_set_clientdata(client, data);
+
+	/* Create a virtual adapter */
+
+	force = 0;
+	if (pdata)
+		force = pdata->modes[0].adap_id;
+	data->virt_adap = i2c_add_mux_adapter(adap, client, force, 0,
+					      pca9541_select_chan,
+					      pca9541_release_chan);
+
+	if (data->virt_adap == NULL) {
+		dev_err(&client->dev,
+			"failed to register master selector as bus %d\n",
+			force);
+		goto exit_free;
+	}
+
+	dev_info(&client->dev, "registered master selector for I2C %s\n",
+		 client->name);
+
+	pca9541_release_bus(adap, client);
+
+	return 0;
+
+exit_free:
+	kfree(data);
+err:
+	return ret;
+}
+
+static int __devexit pca9541_remove(struct i2c_client *client)
+{
+	struct pca9541 *data = i2c_get_clientdata(client);
+
+	i2c_del_mux_adapter(data->virt_adap);
+
+	kfree(data);
+	return 0;
+}
+
+static struct i2c_driver pca9541_driver = {
+	.driver = {
+		   .name = "pca9541",
+		   .owner = THIS_MODULE,
+		   },
+	.probe = pca9541_probe,
+	.remove = __devexit_p(pca9541_remove),
+	.id_table = pca9541_id,
+};
+
+static int __init pca9541_init(void)
+{
+	return i2c_add_driver(&pca9541_driver);
+}
+
+static void __exit pca9541_exit(void)
+{
+	i2c_del_driver(&pca9541_driver);
+}
+
+module_init(pca9541_init);
+module_exit(pca9541_exit);
+
+MODULE_AUTHOR("Guenter Roeck <guenter.roeck@ericsson.com>");
+MODULE_DESCRIPTION("PCA9541 I2C master selector driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.3.1

