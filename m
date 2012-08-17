Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205Ab2HQXWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 19:22:34 -0400
Received: from [12.239.217.82] ([12.239.217.82]:28612 "EHLO
	venom.synaptics.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758920Ab2HQXVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 19:21:04 -0400
X-Greylist: delayed 3724 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Aug 2012 19:20:45 EDT
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Christopher Heiny <cheiny@synaptics.com>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Peichen Chang <peichen.chang@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [RFC PATCH 3/17] input: RMI4 physical layer drivers for I2C and SPI
Date: Fri, 17 Aug 2012 15:17:43 -0700
Message-Id: <1345241877-16200-4-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1345241877-16200-1-git-send-email-cheiny@synaptics.com>
References: <1345241877-16200-1-git-send-email-cheiny@synaptics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christopher Heiny <cheiny@synaptics.com>

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Cc: Joeri de Gram <j.de.gram@gmail.com>

Acked-by: Jean Delvare <khali@linux-fr.org>

---

 drivers/input/rmi4/rmi_i2c.c |  452 +++++++++++++++++++++
 drivers/input/rmi4/rmi_spi.c |  911 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 1363 insertions(+), 0 deletions(-)

diff --git a/drivers/input/rmi4/rmi_i2c.c b/drivers/input/rmi4/rmi_i2c.c
new file mode 100644
index 0000000..1da8d96
--- /dev/null
+++ b/drivers/input/rmi4/rmi_i2c.c
@@ -0,0 +1,452 @@
+/*
+ * Copyright (c) 2011, 2012 Synaptics Incorporated
+ * Copyright (c) 2011 Unixphere
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#define COMMS_DEBUG 0
+
+#define IRQ_DEBUG 0
+
+#if COMMS_DEBUG || IRQ_DEBUG
+#define DEBUG
+#endif
+
+#include <linux/kernel.h>
+#include <linux/lockdep.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/pm.h>
+#include <linux/gpio.h>
+#include <linux/rmi.h>
+#include "rmi_driver.h"
+
+#define RMI_PAGE_SELECT_REGISTER 0xff
+#define RMI_I2C_PAGE(addr) (((addr) >> 8) & 0xff)
+
+static char *phys_proto_name = "i2c";
+
+struct rmi_i2c_data {
+	struct mutex page_mutex;
+	int page;
+	int enabled;
+	int irq;
+	int irq_flags;
+	struct rmi_phys_device *phys;
+};
+
+static irqreturn_t rmi_i2c_irq_thread(int irq, void *p)
+{
+	struct rmi_phys_device *phys = p;
+	struct rmi_device *rmi_dev = phys->rmi_dev;
+	struct rmi_driver *driver = rmi_dev->driver;
+	struct rmi_device_platform_data *pdata = phys->dev->platform_data;
+
+#if IRQ_DEBUG
+	dev_dbg(phys->dev, "ATTN gpio, value: %d.\n",
+			gpio_get_value(pdata->attn_gpio));
+#endif
+	if (gpio_get_value(pdata->attn_gpio) == pdata->attn_polarity) {
+		phys->info.attn_count++;
+		if (driver && driver->irq_handler && rmi_dev)
+			driver->irq_handler(rmi_dev, irq);
+	}
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * rmi_set_page - Set RMI page
+ * @phys: The pointer to the rmi_phys_device struct
+ * @page: The new page address.
+ *
+ * RMI devices have 16-bit addressing, but some of the physical
+ * implementations (like SMBus) only have 8-bit addressing. So RMI implements
+ * a page address at 0xff of every page so we can reliable page addresses
+ * every 256 registers.
+ *
+ * The page_mutex lock must be held when this function is entered.
+ *
+ * Returns zero on success, non-zero on failure.
+ */
+static int rmi_set_page(struct rmi_phys_device *phys, unsigned int page)
+{
+	struct i2c_client *client = to_i2c_client(phys->dev);
+	struct rmi_i2c_data *data = phys->data;
+	char txbuf[2] = {RMI_PAGE_SELECT_REGISTER, page};
+	int retval;
+
+#if COMMS_DEBUG
+	dev_dbg(&client->dev, "RMI4 I2C writes 3 bytes: %02x %02x\n",
+		txbuf[0], txbuf[1]);
+#endif
+	phys->info.tx_count++;
+	phys->info.tx_bytes += sizeof(txbuf);
+	retval = i2c_master_send(client, txbuf, sizeof(txbuf));
+	if (retval != sizeof(txbuf)) {
+		phys->info.tx_errs++;
+		dev_err(&client->dev,
+			"%s: set page failed: %d.", __func__, retval);
+		return (retval < 0) ? retval : -EIO;
+	}
+	data->page = page;
+	return 0;
+}
+
+static int rmi_i2c_write_block(struct rmi_phys_device *phys, u16 addr, u8 *buf,
+			       int len)
+{
+	struct i2c_client *client = to_i2c_client(phys->dev);
+	struct rmi_i2c_data *data = phys->data;
+	u8 txbuf[len + 1];
+	int retval;
+#if	COMMS_DEBUG
+	char debug_buf[len*3 + 1];
+	int i, n;
+#endif
+
+	txbuf[0] = addr & 0xff;
+	memcpy(txbuf + 1, buf, len);
+
+	mutex_lock(&data->page_mutex);
+
+	if (RMI_I2C_PAGE(addr) != data->page) {
+		retval = rmi_set_page(phys, RMI_I2C_PAGE(addr));
+		if (retval < 0)
+			goto exit;
+	}
+
+#if COMMS_DEBUG
+	n = 0;
+	for (i = 0; i < len; i++)
+		n = snprintf(debug_buf+n, 4, "%02x ", buf[i]);
+	dev_dbg(&client->dev, "RMI4 I2C writes %d bytes at %#06x: %s\n",
+		len, addr, debug_buf);
+#endif
+
+	phys->info.tx_count++;
+	phys->info.tx_bytes += sizeof(txbuf);
+	retval = i2c_master_send(client, txbuf, sizeof(txbuf));
+	if (retval < 0)
+		phys->info.tx_errs++;
+	else
+		retval--; /* don't count the address byte */
+
+exit:
+	mutex_unlock(&data->page_mutex);
+	return retval;
+}
+
+static int rmi_i2c_write(struct rmi_phys_device *phys, u16 addr, u8 data)
+{
+	int retval = rmi_i2c_write_block(phys, addr, &data, 1);
+	return (retval < 0) ? retval : 0;
+}
+
+static int rmi_i2c_read_block(struct rmi_phys_device *phys, u16 addr, u8 *buf,
+			      int len)
+{
+	struct i2c_client *client = to_i2c_client(phys->dev);
+	struct rmi_i2c_data *data = phys->data;
+	u8 txbuf[1] = {addr & 0xff};
+	int retval;
+#if	COMMS_DEBUG
+	char debug_buf[len*3 + 1];
+	char *temp = debug_buf;
+	int i, n;
+#endif
+
+	mutex_lock(&data->page_mutex);
+
+	if (RMI_I2C_PAGE(addr) != data->page) {
+		retval = rmi_set_page(phys, RMI_I2C_PAGE(addr));
+		if (retval < 0)
+			goto exit;
+	}
+
+#if COMMS_DEBUG
+	dev_dbg(&client->dev, "RMI4 I2C writes 1 bytes: %02x\n", txbuf[0]);
+#endif
+	phys->info.tx_count++;
+	phys->info.tx_bytes += sizeof(txbuf);
+	retval = i2c_master_send(client, txbuf, sizeof(txbuf));
+	if (retval != sizeof(txbuf)) {
+		phys->info.tx_errs++;
+		retval = (retval < 0) ? retval : -EIO;
+		goto exit;
+	}
+
+	retval = i2c_master_recv(client, buf, len);
+
+	phys->info.rx_count++;
+	phys->info.rx_bytes += len;
+	if (retval < 0)
+		phys->info.rx_errs++;
+#if COMMS_DEBUG
+	else {
+		n = 0;
+		for (i = 0; i < len; i++) {
+			n = sprintf(temp, " %02x", buf[i]);
+			temp += n;
+		}
+		dev_dbg(&client->dev, "RMI4 I2C read %d bytes at %#06x:%s\n",
+			len, addr, debug_buf);
+	}
+#endif
+
+exit:
+	mutex_unlock(&data->page_mutex);
+	return retval;
+}
+
+static int rmi_i2c_read(struct rmi_phys_device *phys, u16 addr, u8 *buf)
+{
+	int retval = rmi_i2c_read_block(phys, addr, buf, 1);
+	return (retval < 0) ? retval : 0;
+}
+
+static int acquire_attn_irq(struct rmi_i2c_data *data)
+{
+	return request_threaded_irq(data->irq, NULL, rmi_i2c_irq_thread,
+			data->irq_flags, dev_name(data->phys->dev), data->phys);
+}
+
+static int enable_device(struct rmi_phys_device *phys)
+{
+	int retval = 0;
+
+	struct rmi_i2c_data *data = phys->data;
+
+	if (data->enabled)
+		return 0;
+
+	retval = acquire_attn_irq(data);
+	if (retval)
+		goto error_exit;
+
+	data->enabled = true;
+	dev_dbg(phys->dev, "Physical device enabled.\n");
+	return 0;
+
+error_exit:
+	dev_err(phys->dev, "Failed to enable physical device. Code=%d.\n",
+		retval);
+	return retval;
+}
+
+static void disable_device(struct rmi_phys_device *phys)
+{
+	struct rmi_i2c_data *data = phys->data;
+
+	if (!data->enabled)
+		return;
+
+	disable_irq(data->irq);
+	free_irq(data->irq, data->phys);
+
+	dev_dbg(phys->dev, "Physical device disabled.\n");
+	data->enabled = false;
+}
+
+static int __devinit rmi_i2c_probe(struct i2c_client *client,
+				  const struct i2c_device_id *id)
+{
+	struct rmi_phys_device *rmi_phys;
+	struct rmi_i2c_data *data;
+	struct rmi_device_platform_data *pdata = client->dev.platform_data;
+	int error;
+
+	if (!pdata) {
+		dev_err(&client->dev, "no platform data\n");
+		return -EINVAL;
+	}
+	dev_info(&client->dev, "Probing %s at %#02x (IRQ %d).\n",
+		pdata->sensor_name ? pdata->sensor_name : "-no name-",
+		client->addr, pdata->attn_gpio);
+
+	if (pdata->gpio_config) {
+		dev_info(&client->dev, "Configuring GPIOs.\n");
+		error = pdata->gpio_config(pdata->gpio_data, true);
+		if (error < 0) {
+			dev_err(&client->dev, "Failed to configure GPIOs, code: %d.\n",
+				error);
+			return error;
+		}
+		dev_info(&client->dev, "Done with GPIO configuration.\n");
+	}
+
+	error = i2c_check_functionality(client->adapter, I2C_FUNC_I2C);
+	if (!error) {
+		dev_err(&client->dev, "i2c_check_functionality error %d.\n",
+			error);
+		return error;
+	}
+
+	rmi_phys = kzalloc(sizeof(struct rmi_phys_device), GFP_KERNEL);
+	if (!rmi_phys)
+		return -ENOMEM;
+
+	data = kzalloc(sizeof(struct rmi_i2c_data), GFP_KERNEL);
+	if (!data) {
+		error = -ENOMEM;
+		goto err_phys;
+	}
+
+	data->enabled = true;	/* We plan to come up enabled. */
+	data->irq = gpio_to_irq(pdata->attn_gpio);
+	if (pdata->level_triggered) {
+		data->irq_flags = IRQF_ONESHOT |
+			((pdata->attn_polarity == RMI_ATTN_ACTIVE_HIGH) ?
+			IRQF_TRIGGER_HIGH : IRQF_TRIGGER_LOW);
+	} else {
+		data->irq_flags =
+			(pdata->attn_polarity == RMI_ATTN_ACTIVE_HIGH) ?
+			IRQF_TRIGGER_RISING : IRQF_TRIGGER_FALLING;
+	}
+	data->phys = rmi_phys;
+
+	rmi_phys->data = data;
+	rmi_phys->dev = &client->dev;
+
+	rmi_phys->write = rmi_i2c_write;
+	rmi_phys->write_block = rmi_i2c_write_block;
+	rmi_phys->read = rmi_i2c_read;
+	rmi_phys->read_block = rmi_i2c_read_block;
+	rmi_phys->enable_device = enable_device;
+	rmi_phys->disable_device = disable_device;
+
+	rmi_phys->info.proto = phys_proto_name;
+
+	mutex_init(&data->page_mutex);
+
+	/* Setting the page to zero will (a) make sure the PSR is in a
+	 * known state, and (b) make sure we can talk to the device.
+	 */
+	error = rmi_set_page(rmi_phys, 0);
+	if (error) {
+		dev_err(&client->dev, "Failed to set page select to 0.\n");
+		goto err_data;
+	}
+
+	error = rmi_register_phys_device(rmi_phys);
+	if (error) {
+		dev_err(&client->dev,
+			"failed to register physical driver at 0x%.2X.\n",
+			client->addr);
+		goto err_gpio;
+	}
+	i2c_set_clientdata(client, rmi_phys);
+
+	if (pdata->attn_gpio > 0) {
+		error = acquire_attn_irq(data);
+		if (error < 0) {
+			dev_err(&client->dev,
+				"request_threaded_irq failed %d\n",
+				pdata->attn_gpio);
+			goto err_unregister;
+		}
+	}
+
+#if defined(CONFIG_RMI4_DEV)
+	error = gpio_export(pdata->attn_gpio, false);
+	if (error) {
+		dev_warn(&client->dev,
+			 "WARNING: Failed to export ATTN gpio!\n");
+		error = 0;
+	} else {
+		error = gpio_export_link(&(rmi_phys->rmi_dev->dev), "attn",
+					pdata->attn_gpio);
+		if (error) {
+			dev_warn(&(rmi_phys->rmi_dev->dev),
+				 "WARNING: Failed to symlink ATTN gpio!\n");
+			error = 0;
+		} else {
+			dev_info(&(rmi_phys->rmi_dev->dev),
+				"%s: Exported ATTN GPIO %d.", __func__,
+				pdata->attn_gpio);
+		}
+	}
+#endif /* CONFIG_RMI4_DEV */
+
+	dev_info(&client->dev, "registered rmi i2c driver at %#04x.\n",
+			client->addr);
+	return 0;
+
+err_unregister:
+	rmi_unregister_phys_device(rmi_phys);
+err_gpio:
+	if (pdata->gpio_config)
+		pdata->gpio_config(pdata->gpio_data, false);
+err_data:
+	kfree(data);
+err_phys:
+	kfree(rmi_phys);
+	return error;
+}
+
+static int __devexit rmi_i2c_remove(struct i2c_client *client)
+{
+	struct rmi_phys_device *phys = i2c_get_clientdata(client);
+	struct rmi_device_platform_data *pd = client->dev.platform_data;
+
+	disable_device(phys);
+	rmi_unregister_phys_device(phys);
+	kfree(phys->data);
+	kfree(phys);
+
+	if (pd->gpio_config)
+		pd->gpio_config(&pd->gpio_data, false);
+
+	return 0;
+}
+
+static const struct i2c_device_id rmi_id[] = {
+	{ "rmi", 0 },
+	{ "rmi_i2c", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, rmi_id);
+
+static struct i2c_driver rmi_i2c_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "rmi_i2c"
+	},
+	.id_table	= rmi_id,
+	.probe		= rmi_i2c_probe,
+	.remove		= __devexit_p(rmi_i2c_remove),
+};
+
+static int __init rmi_i2c_init(void)
+{
+	return i2c_add_driver(&rmi_i2c_driver);
+}
+
+static void __exit rmi_i2c_exit(void)
+{
+	i2c_del_driver(&rmi_i2c_driver);
+}
+
+module_init(rmi_i2c_init);
+module_exit(rmi_i2c_exit);
+
+MODULE_AUTHOR("Christopher Heiny <cheiny@synaptics.com>");
+MODULE_DESCRIPTION("RMI I2C driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(RMI_DRIVER_VERSION);
diff --git a/drivers/input/rmi4/rmi_spi.c b/drivers/input/rmi4/rmi_spi.c
new file mode 100644
index 0000000..4f446af
--- /dev/null
+++ b/drivers/input/rmi4/rmi_spi.c
@@ -0,0 +1,911 @@
+/*
+ * Copyright (c) 2011, 2012 Synaptics Incorporated
+ * Copyright (c) 2011 Unixphere
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/spi/spi.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/completion.h>
+#include <linux/sched.h>
+#include <linux/gpio.h>
+#include <linux/rmi.h>
+
+#define COMMS_DEBUG 0
+#define FF_DEBUG 0
+
+#define RMI_PROTOCOL_VERSION_ADDRESS	0xa0fd
+#define SPI_V2_UNIFIED_READ		0xc0
+#define SPI_V2_WRITE			0x40
+#define SPI_V2_PREPARE_SPLIT_READ	0xc8
+#define SPI_V2_EXECUTE_SPLIT_READ	0xca
+
+#define RMI_SPI_BLOCK_DELAY_US		65
+#define RMI_SPI_BYTE_DELAY_US		65
+#define RMI_SPI_WRITE_DELAY_US		0
+
+#define RMI_V1_READ_FLAG		0x80
+
+#define RMI_PAGE_SELECT_REGISTER 0x00FF
+#define RMI_SPI_PAGE(addr) (((addr) >> 8) & 0x80)
+
+#define DEFAULT_POLL_INTERVAL_MS	13
+
+static char *spi_v1_proto_name = "spi";
+static char *spi_v2_proto_name = "spiv2";
+
+struct rmi_spi_data {
+	struct mutex page_mutex;
+	int page;
+	int (*set_page) (struct rmi_phys_device *phys, u8 page);
+	bool split_read_pending;
+	int enabled;
+	int irq;
+	int irq_flags;
+	struct rmi_phys_device *phys;
+	struct completion irq_comp;
+
+	/* Following are used when polling. */
+	struct hrtimer poll_timer;
+	struct work_struct poll_work;
+	int poll_interval;
+
+};
+
+static irqreturn_t rmi_spi_hard_irq(int irq, void *p)
+{
+	struct rmi_phys_device *phys = p;
+	struct rmi_spi_data *data = phys->data;
+	struct rmi_device_platform_data *pdata = phys->dev->platform_data;
+
+	if (data->split_read_pending &&
+		      gpio_get_value(pdata->attn_gpio) ==
+		      pdata->attn_polarity) {
+		phys->info.attn_count++;
+		complete(&data->irq_comp);
+		return IRQ_HANDLED;
+	}
+
+	return IRQ_WAKE_THREAD;
+}
+
+static irqreturn_t rmi_spi_irq_thread(int irq, void *p)
+{
+	struct rmi_phys_device *phys = p;
+	struct rmi_device *rmi_dev = phys->rmi_dev;
+	struct rmi_driver *driver = rmi_dev->driver;
+	struct rmi_device_platform_data *pdata = phys->dev->platform_data;
+
+	if (gpio_get_value(pdata->attn_gpio) == pdata->attn_polarity) {
+		phys->info.attn_count++;
+		if (driver && driver->irq_handler)
+			driver->irq_handler(rmi_dev, irq);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void spi_poll_work(struct work_struct *work)
+{
+	struct rmi_spi_data *data =
+			container_of(work, struct rmi_spi_data, poll_work);
+	struct rmi_device *rmi_dev = data->phys->rmi_dev;
+	struct rmi_driver *driver = rmi_dev->driver;
+
+	if (driver && driver->irq_handler)
+		driver->irq_handler(rmi_dev, 0);
+}
+
+/* This is the timer function for polling - it simply has to schedule work
+ * and restart the timer. */
+static enum hrtimer_restart spi_poll_timer(struct hrtimer *timer)
+{
+	struct rmi_spi_data *data =
+			container_of(timer, struct rmi_spi_data, poll_timer);
+
+	if (!work_pending(&data->poll_work))
+		schedule_work(&data->poll_work);
+	hrtimer_start(&data->poll_timer, ktime_set(0, data->poll_interval),
+		      HRTIMER_MODE_REL);
+	return HRTIMER_NORESTART;
+}
+
+
+
+static int rmi_spi_xfer(struct rmi_phys_device *phys,
+		    const u8 *txbuf, unsigned n_tx, u8 *rxbuf, unsigned n_rx)
+{
+	struct spi_device *client = to_spi_device(phys->dev);
+	struct rmi_spi_data *v2_data = phys->data;
+	struct rmi_device_platform_data *pdata = phys->dev->platform_data;
+	int status;
+	struct spi_message message;
+	struct spi_transfer *xfers;
+	int total_bytes = n_tx + n_rx;
+	u8 local_buf[total_bytes];
+	int xfer_count = 0;
+	int xfer_index = 0;
+	int block_delay = n_rx > 0 ? pdata->spi_data.block_delay_us : 0;
+	int byte_delay = n_rx > 1 ? pdata->spi_data.read_delay_us : 0;
+	int write_delay = n_tx > 1 ? pdata->spi_data.write_delay_us : 0;
+#if FF_DEBUG
+	bool bad_data = true;
+#endif
+#if COMMS_DEBUG || FF_DEBUG
+	int i;
+#endif
+
+	if (v2_data->split_read_pending) {
+		block_delay =
+		    n_rx > 0 ? pdata->spi_data.split_read_block_delay_us : 0;
+		byte_delay =
+		    n_rx > 1 ? pdata->spi_data.split_read_byte_delay_us : 0;
+		write_delay = 0;
+	}
+
+	if (n_tx) {
+		phys->info.tx_count++;
+		phys->info.tx_bytes += n_tx;
+		if (write_delay)
+			xfer_count += n_tx;
+		else
+			xfer_count += 1;
+	}
+
+	if (n_rx) {
+		phys->info.rx_count++;
+		phys->info.rx_bytes += n_rx;
+		if (byte_delay)
+			xfer_count += n_rx;
+		else
+			xfer_count += 1;
+	}
+
+	xfers = kcalloc(xfer_count,
+			    sizeof(struct spi_transfer), GFP_KERNEL);
+	if (!xfers)
+		return -ENOMEM;
+
+	spi_message_init(&message);
+
+	if (n_tx) {
+		if (write_delay) {
+			for (xfer_index = 0; xfer_index < n_tx;
+					xfer_index++) {
+				memset(&xfers[xfer_index], 0,
+				       sizeof(struct spi_transfer));
+				xfers[xfer_index].len = 1;
+				xfers[xfer_index].delay_usecs = write_delay;
+				xfers[xfer_index].tx_buf = txbuf + xfer_index;
+				spi_message_add_tail(&xfers[xfer_index],
+						     &message);
+			}
+		} else {
+			memset(&xfers[0], 0, sizeof(struct spi_transfer));
+			xfers[0].len = n_tx;
+			spi_message_add_tail(&xfers[0], &message);
+			memcpy(local_buf, txbuf, n_tx);
+			xfers[0].tx_buf = local_buf;
+			xfer_index++;
+		}
+		if (block_delay)
+			xfers[xfer_index-1].delay_usecs = block_delay;
+	}
+	if (n_rx) {
+		if (byte_delay) {
+			int buffer_offset = n_tx;
+			for (; xfer_index < xfer_count; xfer_index++) {
+				memset(&xfers[xfer_index], 0,
+				       sizeof(struct spi_transfer));
+				xfers[xfer_index].len = 1;
+				xfers[xfer_index].delay_usecs = byte_delay;
+				xfers[xfer_index].rx_buf =
+				    local_buf + buffer_offset;
+				buffer_offset++;
+				spi_message_add_tail(&xfers[xfer_index],
+						     &message);
+			}
+		} else {
+			memset(&xfers[xfer_index], 0,
+			       sizeof(struct spi_transfer));
+			xfers[xfer_index].len = n_rx;
+			xfers[xfer_index].rx_buf = local_buf + n_tx;
+			spi_message_add_tail(&xfers[xfer_index], &message);
+			xfer_index++;
+		}
+	}
+
+#if COMMS_DEBUG
+	if (n_tx) {
+		dev_dbg(&client->dev, "SPI sends %d bytes: ", n_tx);
+		for (i = 0; i < n_tx; i++)
+			pr_info("%02X ", txbuf[i]);
+		pr_info("\n");
+	}
+#endif
+
+	/* do the i/o */
+	if (pdata->spi_data.cs_assert) {
+		status = pdata->spi_data.cs_assert(
+			pdata->spi_data.cs_assert_data, true);
+		if (status) {
+			dev_err(phys->dev, "Failed to assert CS, code %d.\n",
+				status);
+			/* nonzero means error */
+			status = -1;
+			goto error_exit;
+		} else
+			status = 0;
+	}
+
+	if (pdata->spi_data.pre_delay_us)
+		udelay(pdata->spi_data.pre_delay_us);
+
+	status = spi_sync(client, &message);
+
+	if (pdata->spi_data.post_delay_us)
+		udelay(pdata->spi_data.post_delay_us);
+
+	if (pdata->spi_data.cs_assert) {
+		status = pdata->spi_data.cs_assert(
+			pdata->spi_data.cs_assert_data, false);
+		if (status) {
+			dev_err(phys->dev, "Failed to deassert CS. code %d.\n",
+				status);
+			/* nonzero means error */
+			status = -1;
+			goto error_exit;
+		} else
+			status = 0;
+	}
+
+	if (status == 0) {
+		memcpy(rxbuf, local_buf + n_tx, n_rx);
+		status = message.status;
+	} else {
+		if (n_tx)
+			phys->info.tx_errs++;
+		if (n_rx)
+			phys->info.rx_errs++;
+		dev_err(phys->dev, "spi_sync failed with error code %d.",
+		       status);
+		goto error_exit;
+	}
+
+#if COMMS_DEBUG
+	if (n_rx) {
+		dev_dbg(&client->dev, "SPI received %d bytes: ", n_rx);
+		for (i = 0; i < n_rx; i++)
+			pr_info("%02X ", rxbuf[i]);
+		pr_info("\n");
+	}
+#endif
+#if FF_DEBUG
+	if (n_rx) {
+		for (i = 0; i < n_rx; i++) {
+			if (rxbuf[i] != 0xFF) {
+				bad_data = false;
+				break;
+			}
+		}
+		if (bad_data) {
+			phys->info.rx_errs++;
+			dev_err(phys->dev, "BAD READ %lu out of %lu.\n",
+				phys->info.rx_errs, phys->info.rx_count);
+		}
+	}
+#endif
+
+error_exit:
+	kfree(xfers);
+	return status;
+}
+
+static int rmi_spi_v2_write_block(struct rmi_phys_device *phys, u16 addr,
+				  u8 *buf, int len)
+{
+	struct rmi_spi_data *data = phys->data;
+	u8 txbuf[len + 4];
+	int error;
+
+	txbuf[0] = SPI_V2_WRITE;
+	txbuf[1] = (addr >> 8) & 0x00FF;
+	txbuf[2] = addr & 0x00FF;
+	txbuf[3] = len;
+
+	memcpy(&txbuf[4], buf, len);
+
+	mutex_lock(&data->page_mutex);
+
+	if (RMI_SPI_PAGE(addr) != data->page) {
+		error = data->set_page(phys, RMI_SPI_PAGE(addr));
+		if (error < 0)
+			goto exit;
+	}
+
+	error = rmi_spi_xfer(phys, buf, len + 4, NULL, 0);
+	if (error < 0)
+		goto exit;
+	error = len;
+
+exit:
+	mutex_unlock(&data->page_mutex);
+	return error;
+}
+
+static int rmi_spi_v2_write(struct rmi_phys_device *phys, u16 addr, u8 data)
+{
+	int error = rmi_spi_v2_write_block(phys, addr, &data, 1);
+
+	return (error == 1) ? 0 : error;
+}
+
+static int rmi_spi_v1_write_block(struct rmi_phys_device *phys, u16 addr,
+				  u8 *buf, int len)
+{
+	struct rmi_spi_data *data = phys->data;
+	unsigned char txbuf[len + 2];
+	int error;
+
+	txbuf[0] = (addr >> 8) & ~RMI_V1_READ_FLAG;
+	txbuf[1] = addr;
+	memcpy(txbuf+2, buf, len);
+
+	mutex_lock(&data->page_mutex);
+
+	if (RMI_SPI_PAGE(addr) != data->page) {
+		error = data->set_page(phys, RMI_SPI_PAGE(addr));
+		if (error < 0)
+			goto exit;
+	}
+
+	error = rmi_spi_xfer(phys, txbuf, len + 2, NULL, 0);
+	if (error < 0)
+		goto exit;
+	error = len;
+
+exit:
+	mutex_unlock(&data->page_mutex);
+	return error;
+}
+
+static int rmi_spi_v1_write(struct rmi_phys_device *phys, u16 addr, u8 data)
+{
+	int error = rmi_spi_v1_write_block(phys, addr, &data, 1);
+
+	return (error == 1) ? 0 : error;
+}
+
+static int rmi_spi_v2_split_read_block(struct rmi_phys_device *phys, u16 addr,
+				       u8 *buf, int len)
+{
+	struct rmi_spi_data *data = phys->data;
+	u8 txbuf[4];
+	u8 rxbuf[len + 1]; /* one extra byte for read length */
+	int error;
+
+	txbuf[0] = SPI_V2_PREPARE_SPLIT_READ;
+	txbuf[1] = (addr >> 8) & 0x00FF;
+	txbuf[2] = addr & 0x00ff;
+	txbuf[3] = len;
+
+	mutex_lock(&data->page_mutex);
+
+	if (RMI_SPI_PAGE(addr) != data->page) {
+		error = data->set_page(phys, RMI_SPI_PAGE(addr));
+		if (error < 0)
+			goto exit;
+	}
+
+	data->split_read_pending = true;
+
+	error = rmi_spi_xfer(phys, txbuf, 4, NULL, 0);
+	if (error < 0) {
+		data->split_read_pending = false;
+		goto exit;
+	}
+
+	wait_for_completion(&data->irq_comp);
+
+	txbuf[0] = SPI_V2_EXECUTE_SPLIT_READ;
+	txbuf[1] = 0;
+
+	error = rmi_spi_xfer(phys, txbuf, 2, rxbuf, len + 1);
+	data->split_read_pending = false;
+	if (error < 0)
+		goto exit;
+
+	/* first byte is length */
+	if (rxbuf[0] != len) {
+		error = -EIO;
+		goto exit;
+	}
+
+	memcpy(buf, rxbuf + 1, len);
+	error = len;
+
+exit:
+	mutex_unlock(&data->page_mutex);
+	return error;
+}
+
+static int rmi_spi_v2_read_block(struct rmi_phys_device *phys, u16 addr,
+				 u8 *buf, int len)
+{
+	struct rmi_spi_data *data = phys->data;
+	u8 txbuf[4];
+	int error;
+
+	txbuf[0] = SPI_V2_UNIFIED_READ;
+	txbuf[1] = (addr >> 8) & 0x00FF;
+	txbuf[2] = addr & 0x00ff;
+	txbuf[3] = len;
+
+	mutex_lock(&data->page_mutex);
+
+	if (RMI_SPI_PAGE(addr) != data->page) {
+		error = data->set_page(phys, RMI_SPI_PAGE(addr));
+		if (error < 0)
+			goto exit;
+	}
+
+	error = rmi_spi_xfer(phys, txbuf, 4, buf, len);
+	if (error < 0)
+		goto exit;
+	error = len;
+
+exit:
+	mutex_unlock(&data->page_mutex);
+	return error;
+}
+
+static int rmi_spi_v2_read(struct rmi_phys_device *phys, u16 addr, u8 *buf)
+{
+	int error = rmi_spi_v2_read_block(phys, addr, buf, 1);
+
+	return (error == 1) ? 0 : error;
+}
+
+static int rmi_spi_v1_read_block(struct rmi_phys_device *phys, u16 addr,
+				 u8 *buf, int len)
+{
+	struct rmi_spi_data *data = phys->data;
+	u8 txbuf[2];
+	int error;
+
+	txbuf[0] = (addr >> 8) | RMI_V1_READ_FLAG;
+	txbuf[1] = addr;
+
+	mutex_lock(&data->page_mutex);
+
+	if (RMI_SPI_PAGE(addr) != data->page) {
+		error = data->set_page(phys, RMI_SPI_PAGE(addr));
+		if (error < 0)
+			goto exit;
+	}
+
+	error = rmi_spi_xfer(phys, txbuf, 2, buf, len);
+	if (error < 0)
+		goto exit;
+	error = len;
+
+exit:
+	mutex_unlock(&data->page_mutex);
+	return error;
+}
+
+static int rmi_spi_v1_read(struct rmi_phys_device *phys, u16 addr, u8 *buf)
+{
+	int error = rmi_spi_v1_read_block(phys, addr, buf, 1);
+
+	return (error == 1) ? 0 : error;
+}
+
+#define RMI_SPI_PAGE_SELECT_WRITE_LENGTH 1
+
+static int rmi_spi_v1_set_page(struct rmi_phys_device *phys, u8 page)
+{
+	struct rmi_spi_data *data = phys->data;
+	u8 txbuf[] = {RMI_PAGE_SELECT_REGISTER >> 8,
+		RMI_PAGE_SELECT_REGISTER & 0xFF, page};
+	int error;
+
+	error = rmi_spi_xfer(phys, txbuf, sizeof(txbuf), NULL, 0);
+	if (error < 0) {
+		dev_err(phys->dev, "Failed to set page select, code: %d.\n",
+			error);
+		return error;
+	}
+
+	data->page = page;
+
+	return RMI_SPI_PAGE_SELECT_WRITE_LENGTH;
+}
+
+static int rmi_spi_v2_set_page(struct rmi_phys_device *phys, u8 page)
+{
+	struct rmi_spi_data *data = phys->data;
+	u8 txbuf[] = {SPI_V2_WRITE, RMI_PAGE_SELECT_REGISTER >> 8,
+		RMI_PAGE_SELECT_REGISTER & 0xFF,
+		RMI_SPI_PAGE_SELECT_WRITE_LENGTH, page};
+	int error;
+
+	error = rmi_spi_xfer(phys, txbuf, sizeof(txbuf), NULL, 0);
+	if (error < 0) {
+		dev_err(phys->dev, "Failed to set page select, code: %d.\n",
+			error);
+		return error;
+	}
+
+	data->page = page;
+
+	return RMI_SPI_PAGE_SELECT_WRITE_LENGTH;
+}
+
+
+static int acquire_attn_irq(struct rmi_spi_data *data)
+{
+	int retval;
+	struct rmi_phys_device *rmi_phys = data->phys;
+
+	retval = request_threaded_irq(data->irq, rmi_spi_hard_irq,
+				rmi_spi_irq_thread, data->irq_flags,
+				dev_name(rmi_phys->dev), rmi_phys);
+	if (retval < 0) {
+		dev_err(&(rmi_phys->rmi_dev->dev), "request_threaded_irq "
+			"failed, code: %d.\n", retval);
+	}
+	return retval;
+}
+
+static int setup_attn(struct rmi_spi_data *data)
+{
+	int retval;
+	struct rmi_phys_device *rmi_phys = data->phys;
+	struct rmi_device_platform_data *pdata = rmi_phys->dev->platform_data;
+
+	retval = acquire_attn_irq(data);
+	if (retval < 0)
+		return retval;
+
+#if defined(CONFIG_RMI4_DEV)
+	retval = gpio_export(pdata->attn_gpio, false);
+	if (retval) {
+		dev_warn(&(rmi_phys->rmi_dev->dev),
+			 "WARNING: Failed to export ATTN gpio!\n");
+		retval = 0;
+	} else {
+		retval = gpio_export_link(&(rmi_phys->rmi_dev->dev), "attn",
+					pdata->attn_gpio);
+		if (retval) {
+			dev_warn(&(rmi_phys->rmi_dev->dev), "WARNING: "
+				"Failed to symlink ATTN gpio!\n");
+			retval = 0;
+		} else {
+			dev_info(&(rmi_phys->rmi_dev->dev),
+				"%s: Exported GPIO %d.", __func__,
+				pdata->attn_gpio);
+		}
+	}
+#endif /* CONFIG_RMI4_DEV */
+
+	return retval;
+}
+
+static int setup_polling(struct rmi_spi_data *data)
+{
+	INIT_WORK(&data->poll_work, spi_poll_work);
+	hrtimer_init(&data->poll_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	data->poll_timer.function = spi_poll_timer;
+	hrtimer_start(&data->poll_timer, ktime_set(1, 0), HRTIMER_MODE_REL);
+
+	return 0;
+}
+
+static int enable_device(struct rmi_phys_device *phys)
+{
+	int retval = 0;
+
+	struct rmi_spi_data *data = phys->data;
+
+	if (data->enabled) {
+		dev_dbg(phys->dev, "Physical device already enabled.\n");
+		return 0;
+	}
+
+	retval = acquire_attn_irq(data);
+	if (retval)
+		goto error_exit;
+
+	data->enabled = true;
+	dev_dbg(phys->dev, "Physical device enabled.\n");
+	return 0;
+
+error_exit:
+	dev_err(phys->dev, "Failed to enable physical device. Code=%d.\n",
+		retval);
+	return retval;
+}
+
+static void disable_device(struct rmi_phys_device *phys)
+{
+	struct rmi_spi_data *data = phys->data;
+
+	if (!data->enabled) {
+		dev_warn(phys->dev, "Physical device already disabled.\n");
+		return;
+	}
+	disable_irq(data->irq);
+	free_irq(data->irq, data->phys);
+
+	dev_dbg(phys->dev, "Physical device disabled.\n");
+	data->enabled = false;
+}
+
+#define DUMMY_READ_SLEEP_US 10
+
+static int rmi_spi_check_device(struct rmi_phys_device *rmi_phys)
+{
+	u8 buf[6];
+	int error;
+	int i;
+
+	/* Some SPI subsystems return 0 for the very first read you do.  So
+	 * we use this dummy read to get that out of the way.
+	 */
+	error = rmi_spi_v1_read_block(rmi_phys, PDT_START_SCAN_LOCATION,
+				      buf, sizeof(buf));
+	if (error < 0) {
+		dev_err(rmi_phys->dev, "dummy read failed with %d.\n", error);
+		return error;
+	}
+	udelay(DUMMY_READ_SLEEP_US);
+
+	/* Force page select to 0.
+	 */
+	error = rmi_spi_v1_set_page(rmi_phys, 0x00);
+	if (error < 0)
+		return error;
+
+	/* Now read the first PDT entry.  We know where this is, and if the
+	 * RMI4 device is out there, these 6 bytes will be something other
+	 * than all 0x00 or 0xFF.  We need to check for 0x00 and 0xFF,
+	 * because many (maybe all) SPI implementations will return all 0x00
+	 * or all 0xFF on read if the device is not connected.
+	 */
+	error = rmi_spi_v1_read_block(rmi_phys, PDT_START_SCAN_LOCATION,
+				      buf, sizeof(buf));
+	if (error < 0) {
+		dev_err(rmi_phys->dev, "probe read failed with %d.\n", error);
+		return error;
+	}
+	for (i = 0; i < sizeof(buf); i++) {
+		if (buf[i] != 0x00 && buf[i] != 0xFF)
+			return error;
+	}
+
+	dev_err(rmi_phys->dev, "probe read returned invalid block.\n");
+	return -ENODEV;
+}
+
+
+static int __devinit rmi_spi_probe(struct spi_device *spi)
+{
+	struct rmi_phys_device *rmi_phys;
+	struct rmi_spi_data *data;
+	struct rmi_device_platform_data *pdata = spi->dev.platform_data;
+	u8 buf[2];
+	int retval;
+
+	if (!pdata) {
+		dev_err(&spi->dev, "no platform data\n");
+		return -EINVAL;
+	}
+
+	if (spi->master->flags & SPI_MASTER_HALF_DUPLEX)
+		return -EINVAL;
+
+	spi->bits_per_word = 8;
+	spi->mode = SPI_MODE_3;
+	retval = spi_setup(spi);
+	if (retval < 0) {
+		dev_err(&spi->dev, "spi_setup failed!\n");
+		return retval;
+	}
+
+	if (pdata->gpio_config) {
+		retval = pdata->gpio_config(pdata->gpio_data, true);
+		if (retval < 0) {
+			dev_err(&spi->dev, "Failed to setup GPIOs, code: %d.\n",
+				retval);
+			return retval;
+		}
+	}
+
+	rmi_phys = kzalloc(sizeof(struct rmi_phys_device), GFP_KERNEL);
+	if (!rmi_phys)
+		return -ENOMEM;
+
+	data = kzalloc(sizeof(struct rmi_spi_data), GFP_KERNEL);
+	if (!data) {
+		retval = -ENOMEM;
+		goto err_phys;
+	}
+	data->enabled = true;	/* We plan to come up enabled. */
+	data->irq = gpio_to_irq(pdata->attn_gpio);
+	if (pdata->level_triggered) {
+		data->irq_flags = IRQF_ONESHOT |
+			((pdata->attn_polarity == RMI_ATTN_ACTIVE_HIGH) ?
+			IRQF_TRIGGER_HIGH : IRQF_TRIGGER_LOW);
+	} else {
+		data->irq_flags =
+			(pdata->attn_polarity == RMI_ATTN_ACTIVE_HIGH) ?
+			IRQF_TRIGGER_RISING : IRQF_TRIGGER_FALLING;
+	}
+	data->phys = rmi_phys;
+
+	rmi_phys->data = data;
+	rmi_phys->dev = &spi->dev;
+
+	rmi_phys->write = rmi_spi_v1_write;
+	rmi_phys->write_block = rmi_spi_v1_write_block;
+	rmi_phys->read = rmi_spi_v1_read;
+	rmi_phys->read_block = rmi_spi_v1_read_block;
+	rmi_phys->enable_device = enable_device;
+	rmi_phys->disable_device = disable_device;
+	data->set_page = rmi_spi_v1_set_page;
+
+	rmi_phys->info.proto = spi_v1_proto_name;
+
+	mutex_init(&data->page_mutex);
+
+	dev_set_drvdata(&spi->dev, rmi_phys);
+
+	pdata->spi_data.block_delay_us = pdata->spi_data.block_delay_us ?
+			pdata->spi_data.block_delay_us : RMI_SPI_BLOCK_DELAY_US;
+	pdata->spi_data.read_delay_us = pdata->spi_data.read_delay_us ?
+			pdata->spi_data.read_delay_us : RMI_SPI_BYTE_DELAY_US;
+	pdata->spi_data.write_delay_us = pdata->spi_data.write_delay_us ?
+			pdata->spi_data.write_delay_us : RMI_SPI_BYTE_DELAY_US;
+	pdata->spi_data.split_read_block_delay_us =
+			pdata->spi_data.split_read_block_delay_us ?
+			pdata->spi_data.split_read_block_delay_us :
+			RMI_SPI_BLOCK_DELAY_US;
+	pdata->spi_data.split_read_byte_delay_us =
+			pdata->spi_data.split_read_byte_delay_us ?
+			pdata->spi_data.split_read_byte_delay_us :
+			RMI_SPI_BYTE_DELAY_US;
+
+	retval = rmi_spi_check_device(rmi_phys);
+	if (retval < 0)
+		goto err_gpio;
+
+	/* check if this is an SPI v2 device */
+	retval = rmi_spi_v1_read_block(rmi_phys, RMI_PROTOCOL_VERSION_ADDRESS,
+				      buf, 2);
+	if (retval < 0) {
+		dev_err(&spi->dev, "failed to get SPI version number!\n");
+		goto err_gpio;
+	}
+	dev_dbg(&spi->dev, "SPI version is %d", buf[0]);
+
+	if (buf[0] == 1) {
+		/* SPIv2 */
+		rmi_phys->write		= rmi_spi_v2_write;
+		rmi_phys->write_block	= rmi_spi_v2_write_block;
+		rmi_phys->read		= rmi_spi_v2_read;
+		data->set_page		= rmi_spi_v2_set_page;
+
+		rmi_phys->info.proto = spi_v2_proto_name;
+
+		if (pdata->attn_gpio > 0) {
+			init_completion(&data->irq_comp);
+			rmi_phys->read_block = rmi_spi_v2_split_read_block;
+		} else {
+			dev_warn(&spi->dev, "WARNING: SPI V2 detected, but no "
+				"attention GPIO was specified. This is unlikely"
+				" to work well.\n");
+			rmi_phys->read_block = rmi_spi_v2_read_block;
+		}
+	} else if (buf[0] != 0) {
+		dev_err(&spi->dev, "Unrecognized SPI version %d.\n", buf[0]);
+		retval = -ENODEV;
+		goto err_gpio;
+	}
+
+	retval = rmi_register_phys_device(rmi_phys);
+	if (retval) {
+		dev_err(&spi->dev, "failed to register physical driver\n");
+		goto err_gpio;
+	}
+
+	if (pdata->attn_gpio > 0) {
+		retval = setup_attn(data);
+		if (retval < 0)
+			goto err_unregister;
+	} else {
+		retval = setup_polling(data);
+		if (retval < 0)
+			goto err_unregister;
+	}
+
+	dev_info(&spi->dev, "registered RMI SPI driver\n");
+	return 0;
+
+err_unregister:
+	rmi_unregister_phys_device(rmi_phys);
+err_gpio:
+	if (pdata->gpio_config)
+		pdata->gpio_config(pdata->gpio_data, false);
+err_data:
+	kfree(data);
+err_phys:
+	kfree(rmi_phys);
+	return retval;
+}
+
+static int __devexit rmi_spi_remove(struct spi_device *spi)
+{
+	struct rmi_phys_device *phys = dev_get_drvdata(&spi->dev);
+	struct rmi_device_platform_data *pd = spi->dev.platform_data;
+
+	disable_device(phys);
+	rmi_unregister_phys_device(phys);
+	kfree(phys->data);
+	kfree(phys);
+
+	if (pd->gpio_config)
+		pd->gpio_config(pdata->gpio_data, false);
+
+	return 0;
+}
+
+static const struct spi_device_id rmi_id[] = {
+	{ "rmi", 0 },
+	{ "rmi_spi", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(spi, rmi_id);
+
+static struct spi_driver rmi_spi_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "rmi_spi",
+	},
+	.id_table	= rmi_id,
+	.probe		= rmi_spi_probe,
+	.remove		= __devexit_p(rmi_spi_remove),
+};
+
+static int __init rmi_spi_init(void)
+{
+	return spi_register_driver(&rmi_spi_driver);
+}
+
+static void __exit rmi_spi_exit(void)
+{
+	spi_unregister_driver(&rmi_spi_driver);
+}
+
+module_init(rmi_spi_init);
+module_exit(rmi_spi_exit);
+
+MODULE_AUTHOR("Christopher Heiny <cheiny@synaptics.com>");
+MODULE_DESCRIPTION("RMI SPI driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(RMI_DRIVER_VERSION);
