Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab0ICL0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 07:26:47 -0400
Received: from smtp.nokia.com ([192.100.105.134]:24168 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756560Ab0ICL0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 07:26:44 -0400
Subject: Re: [PATCH RFC 1/1] MISC: Broadcom BCM4751 GPS driver
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "akpm@kernel.org" <akpm@kernel.org>
In-Reply-To: <1282572026-14905-2-git-send-email-matti.j.aaltonen@nokia.com>
References: <1282572026-14905-1-git-send-email-matti.j.aaltonen@nokia.com>
	 <1282572026-14905-2-git-send-email-matti.j.aaltonen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Fri, 03 Sep 2010 14:07:27 +0300
Message-ID: <1283512047.26985.119.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Sep 2010 11:07:33.0091 (UTC) FILETIME=[35236B30:01CB4B58]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2010-08-23 at 16:00 +0200, Aaltonen Matti.J (Nokia-MS/Tampere)
wrote:
> Driver for Broadcom BCM4751 GPS chip.

I sent this a while ago but didn't get any comments about the code. What
do you think should something be changed or is it ready to get accepted?

B.R.
Matti A.


> Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
> ---
>  drivers/misc/Kconfig            |   11 +
>  drivers/misc/Makefile           |    1 +
>  drivers/misc/bcm4751-gps.c      |  490 +++++++++++++++++++++++++++++++++++++++
>  include/linux/i2c/bcm4751-gps.h |   59 +++++
>  4 files changed, 561 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/misc/bcm4751-gps.c
>  create mode 100644 include/linux/i2c/bcm4751-gps.h
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 0b591b6..1680673 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -390,6 +390,17 @@ config BMP085
>           To compile this driver as a module, choose M here: the
>           module will be called bmp085.
> 
> +config BCM4751_GPS
> +       tristate "BCM4751 GPS driver"
> +       depends on I2C
> +       default n
> +       ---help---
> +         If you say yes here you get support for the Broadcom BCM4751 GPS
> +         chip driver.
> +
> +         The driver supports only GPS in BCM4751 chip. When built as a driver
> +         driver name is: bcm4751-gps. If unsure, say N here.
> +
>  source "drivers/misc/c2port/Kconfig"
>  source "drivers/misc/eeprom/Kconfig"
>  source "drivers/misc/cb710/Kconfig"
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index 255a80d..cfda6fb 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -9,6 +9,7 @@ obj-$(CONFIG_AD525X_DPOT_SPI)   += ad525x_dpot-spi.o
>  obj-$(CONFIG_ATMEL_PWM)                += atmel_pwm.o
>  obj-$(CONFIG_ATMEL_SSC)                += atmel-ssc.o
>  obj-$(CONFIG_ATMEL_TCLIB)      += atmel_tclib.o
> +obj-$(CONFIG_BCM4751_GPS)      += bcm4751-gps.o
>  obj-$(CONFIG_BMP085)           += bmp085.o
>  obj-$(CONFIG_ICS932S401)       += ics932s401.o
>  obj-$(CONFIG_LKDTM)            += lkdtm.o
> diff --git a/drivers/misc/bcm4751-gps.c b/drivers/misc/bcm4751-gps.c
> new file mode 100644
> index 0000000..03a3752
> --- /dev/null
> +++ b/drivers/misc/bcm4751-gps.c
> @@ -0,0 +1,490 @@
> +/*
> + * bcm4751-gps.c - Hardware interface for Broadcom BCM4751 GPS chip.
> + *
> + * Copyright (C)       2010 Nokia Corporation
> + * Contact             Matti Aaltonen, matti.j.aaltonen@nokia.com
> + *
> + * Written by Andrei Emeltchenko <andrei.emeltchenko@nokia.com>
> + * Modified by Yuri Zaporozhets <ext-yuri.zaporozhets@nokia.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.         See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + */
> +
> +#define DEBUG
> +
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/fs.h>
> +#include <linux/gpio.h>
> +#include <linux/i2c.h>
> +#include <linux/i2c-dev.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/miscdevice.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/poll.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/slab.h>
> +
> +#include <linux/i2c/bcm4751-gps.h>
> +
> +static struct bcm4751_gps_data         *bcm4751_gps_device;
> +
> +static const char reg_vbat[] = "Vbat";
> +static const char reg_vddio[] = "Vddio";
> +
> +/*
> + * Part of initialization is done in the board support file.
> + */
> +
> +static inline void bcm4751_gps_enable(struct bcm4751_gps_data *self)
> +{
> +       mutex_lock(&self->mutex);
> +       if (!self->enable) {
> +               regulator_bulk_enable(ARRAY_SIZE(self->regs), self->regs);
> +               if (self->pdata->enable)
> +                       self->pdata->enable(self->client);
> +               self->enable = 1;
> +       }
> +       mutex_unlock(&self->mutex);
> +}
> +
> +static inline void bcm4751_gps_disable(struct bcm4751_gps_data *self)
> +{
> +       mutex_lock(&self->mutex);
> +       if (self->enable) {
> +               if (self->pdata->disable)
> +                       self->pdata->disable(self->client);
> +               self->enable = 0;
> +               regulator_bulk_disable(ARRAY_SIZE(self->regs), self->regs);
> +       }
> +       mutex_unlock(&self->mutex);
> +}
> +
> +static inline void bcm4751_gps_wakeup_value(struct bcm4751_gps_data *self,
> +               int value)
> +{
> +       mutex_lock(&self->mutex);
> +       if (self->pdata->wakeup_ctrl)
> +               self->pdata->wakeup_ctrl(self->client, value);
> +       self->wakeup = value;
> +       mutex_unlock(&self->mutex);
> +}
> +
> +
> +/*
> + * miscdevice interface
> + */
> +
> +static int bcm4751_gps_open(struct inode *inode, struct file *file)
> +{
> +       return 0;
> +}
> +
> +static int bcm4751_gps_release(struct inode *inode, struct file *file)
> +{
> +       return 0;
> +}
> +
> +static ssize_t bcm4751_gps_read(struct file *file, char __user *buf,
> +               size_t count, loff_t *offset)
> +{
> +       struct i2c_client *client = bcm4751_gps_device->client;
> +       int num_read;
> +       uint8_t tmp[BCM4751_MAX_BINPKT_RX_LEN];
> +
> +       /* Adjust for binary packet size */
> +       if (count > BCM4751_MAX_BINPKT_RX_LEN)
> +               count = BCM4751_MAX_BINPKT_RX_LEN;
> +
> +       dev_dbg(&client->dev, "reading %d bytes\n", count);
> +
> +       num_read = i2c_master_recv(client, tmp, count);
> +
> +       if (num_read < 0) {
> +               dev_err(&client->dev, "got %d bytes instead of %d\n",
> +                       num_read, count);
> +               return num_read;
> +       } else {
> +               dev_dbg(&client->dev, "reading %d bytes returns %d",
> +                       count, num_read);
> +       }
> +
> +       return copy_to_user(buf, tmp, num_read) ? -EFAULT : num_read;
> +}
> +
> +static ssize_t bcm4751_gps_write(struct file *file, const char __user *buf,
> +               size_t count, loff_t *offset)
> +{
> +       struct i2c_client *client = bcm4751_gps_device->client;
> +       uint8_t tmp[BCM4751_MAX_BINPKT_TX_LEN];
> +       int num_sent;
> +
> +       if (count > BCM4751_MAX_BINPKT_TX_LEN)
> +               count = BCM4751_MAX_BINPKT_TX_LEN;
> +
> +       dev_dbg(&client->dev, "writing %d bytes\n", count);
> +
> +       if (copy_from_user(tmp, buf, count))
> +               return -EFAULT;
> +
> +       num_sent = i2c_master_send(client, tmp, count);
> +
> +       dev_dbg(&client->dev, "writing %d bytes returns %d",
> +               count, num_sent);
> +
> +       return num_sent;
> +}
> +
> +static int bcm4751_gps_ioctl(struct inode *inode, struct file *file,
> +               unsigned int cmd, unsigned long arg)
> +{
> +       struct i2c_client *client = bcm4751_gps_device->client;
> +
> +       dev_dbg(&client->dev, "ioctl: cmd = 0x%02x, arg=0x%02lx\n", cmd, arg);
> +
> +       switch (cmd) {
> +       case I2C_SLAVE:
> +       case I2C_SLAVE_FORCE:
> +               if ((arg > 0x3ff) ||
> +                               (((client->flags & I2C_M_TEN) == 0) &&
> +                                arg > 0x7f))
> +                       return -EINVAL;
> +               client->addr = arg;
> +               dev_dbg(&client->dev, "ioctl: client->addr = %x", client->addr);
> +               return 0;
> +       case I2C_TENBIT:
> +               if (arg)
> +                       client->flags |= I2C_M_TEN;
> +               else
> +                       client->flags &= ~I2C_M_TEN;
> +               return 0;
> +       default:
> +               return -ENOTTY;
> +       }
> +       return 0;
> +}
> +
> +static const struct file_operations bcm4751_gps_fileops = {
> +       .owner = THIS_MODULE,
> +       .llseek         = no_llseek,
> +       .read           = bcm4751_gps_read,
> +       .write          = bcm4751_gps_write,
> +       .unlocked_ioctl = bcm4751_gps_ioctl,
> +       .open           = bcm4751_gps_open,
> +       .release        = bcm4751_gps_release,
> +};
> +
> +static struct miscdevice bcm4751_gps_miscdevice = {
> +       .minor = MISC_DYNAMIC_MINOR,
> +       .name = "bcm4751-gps",
> +       .fops = &bcm4751_gps_fileops
> +};
> +
> +
> +/*
> + * sysfs interface
> + */
> +
> +static ssize_t bcm4751_gps_show_hostreq(struct device *dev,
> +               struct device_attribute *attr, char *buf)
> +{
> +       struct bcm4751_gps_data *self = dev_get_drvdata(dev);
> +       int value = -1;
> +
> +       if (self->pdata->show_irq)
> +               value = self->pdata->show_irq(self->client);
> +
> +       return snprintf(buf, PAGE_SIZE, "%d\n", value);
> +}
> +
> +static ssize_t bcm4751_gps_show_enable(struct device *dev,
> +               struct device_attribute *attr, char *buf)
> +{
> +       struct bcm4751_gps_data *self = dev_get_drvdata(dev);
> +
> +       return snprintf(buf, PAGE_SIZE, "%d\n", self->enable);
> +}
> +
> +static ssize_t bcm4751_gps_set_enable(struct device *dev,
> +               struct device_attribute *attr, const char *buf, size_t len)
> +{
> +       struct bcm4751_gps_data *self = dev_get_drvdata(dev);
> +       int value;
> +
> +       sscanf(buf, "%d", &value);
> +       dev_dbg(dev, "enable: %d", value);
> +
> +       switch (value) {
> +       case 0:
> +               bcm4751_gps_disable(self);
> +               break;
> +
> +       case 1:
> +               bcm4751_gps_enable(self);
> +               break;
> +
> +       default:
> +               return -EINVAL;
> +       }
> +       return len;
> +}
> +
> +static ssize_t bcm4751_gps_show_wakeup(struct device *dev,
> +               struct device_attribute *attr, char *buf)
> +{
> +       struct bcm4751_gps_data *self = dev_get_drvdata(dev);
> +
> +       return snprintf(buf, PAGE_SIZE, "%d\n", self->wakeup);
> +}
> +
> +static ssize_t bcm4751_gps_set_wakeup(struct device *dev,
> +               struct device_attribute *attr, const char *buf, size_t len)
> +{
> +       unsigned long val;
> +       int ret;
> +       struct bcm4751_gps_data *self = dev_get_drvdata(dev);
> +
> +       ret = strict_strtoul(buf, 0, &val);
> +       if (ret && val > 1)
> +               return -EINVAL;
> +       else {
> +               bcm4751_gps_wakeup_value(self, val);
> +               dev_dbg(dev, "new wakeup value = %d", self->wakeup);
> +       }
> +
> +       return len;
> +}
> +
> +static struct device_attribute bcm4751_gps_attrs[] = {
> +       __ATTR(enable, S_IRUGO|S_IWUSR,
> +                       bcm4751_gps_show_enable, bcm4751_gps_set_enable),
> +       __ATTR(hostreq, S_IRUGO|S_IWUSR,
> +                       bcm4751_gps_show_hostreq, NULL),
> +       __ATTR(wakeup, S_IRUGO|S_IWUSR,
> +                       bcm4751_gps_show_wakeup, bcm4751_gps_set_wakeup),
> +};
> +
> +static int bcm4751_gps_register_sysfs(struct i2c_client *client)
> +{
> +       struct device *dev = &client->dev;
> +       int i, ret;
> +
> +       for (i = 0; i < ARRAY_SIZE(bcm4751_gps_attrs); i++) {
> +               ret = device_create_file(dev, &bcm4751_gps_attrs[i]);
> +               if (ret)
> +                       goto fail;
> +       }
> +       return 0;
> +fail:
> +       while (i--)
> +               device_remove_file(dev, &bcm4751_gps_attrs[i]);
> +
> +       return ret;
> +}
> +
> +static void bcm4751_gps_unregister_sysfs(struct i2c_client *client)
> +{
> +       struct device *dev = &client->dev;
> +       int i;
> +
> +       for (i = ARRAY_SIZE(bcm4751_gps_attrs) - 1; i >= 0; i--)
> +               device_remove_file(dev, &bcm4751_gps_attrs[i]);
> +}
> +
> +/* IRQ thread */
> +static irqreturn_t bcm4751_gps_irq_thread(int irq, void *dev_id)
> +{
> +       struct bcm4751_gps_data *data = dev_id;
> +
> +       dev_dbg(&data->client->dev, "irq, HOST_REQ=%d",
> +                       data->pdata->show_irq(data->client));
> +
> +       /* Update sysfs GPIO line here */
> +       sysfs_notify(&data->client->dev.kobj, NULL, "hostreq");
> +       return IRQ_HANDLED;
> +}
> +
> +static int bcm4751_gps_probe(struct i2c_client *client,
> +               const struct i2c_device_id *device_id)
> +{
> +       struct bcm4751_gps_data                 *data;
> +       struct bcm4751_gps_platform_data        *pdata;
> +       int                                     err;
> +
> +       data = kzalloc(sizeof(*data), GFP_KERNEL);
> +       if (!data)
> +               return -ENOMEM;
> +
> +       bcm4751_gps_device = data;
> +
> +       pdata = client->dev.platform_data;
> +       if (!pdata) {
> +               dev_err(&client->dev, "no platform data\n");
> +               err = -ENODEV;
> +               goto clean_data;
> +       }
> +
> +       i2c_set_clientdata(client, data);
> +       data->client = client;
> +       data->pdata  = pdata;
> +
> +       data->gpio_irq    = pdata->gps_gpio_irq;
> +       data->gpio_enable = pdata->gps_gpio_enable;
> +       data->gpio_wakeup = pdata->gps_gpio_wakeup;
> +
> +       data->regs[0].supply = reg_vbat;
> +       data->regs[1].supply = reg_vddio;
> +       err = regulator_bulk_get(&client->dev,
> +                               ARRAY_SIZE(data->regs), data->regs);
> +       if (err < 0) {
> +               dev_err(&client->dev, "Can't get regulators\n");
> +               goto clean_data;
> +       }
> +
> +       if (pdata->setup) {
> +               err = pdata->setup(client);
> +               if (err)
> +                       goto clean_reg;
> +       }
> +
> +       mutex_init(&data->mutex);
> +       err = request_threaded_irq(client->irq, NULL,
> +                               bcm4751_gps_irq_thread,
> +                               IRQF_TRIGGER_RISING | IRQF_ONESHOT,
> +                               "bcm4751-gps", data);
> +       if (err) {
> +               dev_err(&client->dev, "could not get GPS_IRQ = %d\n",
> +                               client->irq);
> +               goto clean_setup;
> +       }
> +
> +       err = bcm4751_gps_register_sysfs(client);
> +       if (err) {
> +               dev_err(&client->dev,
> +                               "sysfs registration failed, error %d\n", err);
> +               goto clean_irq;
> +       }
> +
> +       bcm4751_gps_miscdevice.parent = &client->dev;
> +       err = misc_register(&bcm4751_gps_miscdevice);
> +       if (err) {
> +               dev_err(&client->dev, "Miscdevice register failed\n");
> +               goto clean_sysfs;
> +       }
> +
> +       return 0;
> +
> +clean_sysfs:
> +       bcm4751_gps_unregister_sysfs(client);
> +
> +clean_irq:
> +       free_irq(client->irq, data);
> +
> +clean_setup:
> +       if (pdata->cleanup)
> +               pdata->cleanup(client);
> +clean_reg:
> +       regulator_bulk_free(ARRAY_SIZE(data->regs), data->regs);
> +clean_data:
> +       bcm4751_gps_device = NULL;
> +       kfree(data);
> +
> +       return err;
> +}
> +
> +static int bcm4751_gps_remove(struct i2c_client *client)
> +{
> +       struct bcm4751_gps_data *data = i2c_get_clientdata(client);
> +
> +       bcm4751_gps_disable(data);
> +
> +       free_irq(client->irq, data);
> +       misc_deregister(&bcm4751_gps_miscdevice);
> +       bcm4751_gps_unregister_sysfs(client);
> +       if (data->pdata->cleanup)
> +               data->pdata->cleanup(client);
> +       regulator_bulk_free(ARRAY_SIZE(data->regs), data->regs);
> +       kfree(data);
> +       bcm4751_gps_device = NULL;
> +
> +       return 0;
> +}
> +
> +static void bcm4751_gps_shutdown(struct i2c_client *client)
> +{
> +       dev_dbg(&client->dev, "BCM4751 shutdown\n");
> +       bcm4751_gps_disable(i2c_get_clientdata(client));
> +}
> +
> +#ifdef CONFIG_PM
> +static int bcm4751_gps_suspend(struct i2c_client *client, pm_message_t mesg)
> +{
> +       struct bcm4751_gps_data *data = i2c_get_clientdata(client);
> +       data->pdata->wakeup_ctrl(data->client, 0);
> +       dev_dbg(&client->dev, "BCM4751 suspends\n");
> +       return 0;
> +}
> +
> +static int bcm4751_gps_resume(struct i2c_client *client)
> +{
> +       struct bcm4751_gps_data *data = i2c_get_clientdata(client);
> +       data->pdata->wakeup_ctrl(data->client, 1);
> +       dev_dbg(&client->dev, "BCM4751 resumes\n");
> +       return 0;
> +}
> +#else
> +#define bcm4751_gps_suspend NULL
> +#define bcm4751_gps_resume NULL
> +#endif
> +
> +static const struct i2c_device_id bcm4751_gps_id[] = {
> +       { "bcm4751-gps", 0 },
> +       { },
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, bcm4751_gps_id);
> +
> +static struct i2c_driver bcm4751_gps_i2c_driver = {
> +       .driver = {
> +               .name    = "bcm4751-gps",
> +       },
> +
> +       .id_table       = bcm4751_gps_id,
> +       .probe          = bcm4751_gps_probe,
> +       .remove         = __devexit_p(bcm4751_gps_remove),
> +       .shutdown       = bcm4751_gps_shutdown,
> +       .suspend        = bcm4751_gps_suspend,
> +       .resume         = bcm4751_gps_resume,
> +};
> +
> +static int __init bcm4751_gps_init(void)
> +{
> +       pr_info("Loading BCM4751 GPS driver\n");
> +
> +       return i2c_add_driver(&bcm4751_gps_i2c_driver);
> +}
> +module_init(bcm4751_gps_init);
> +
> +static void __exit bcm4751_gps_exit(void)
> +{
> +       i2c_del_driver(&bcm4751_gps_i2c_driver);
> +}
> +module_exit(bcm4751_gps_exit);
> +
> +MODULE_AUTHOR("Andrei Emeltchenko, Yuri Zaporozhets");
> +MODULE_DESCRIPTION("BCM4751 GPS driver");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/i2c/bcm4751-gps.h b/include/linux/i2c/bcm4751-gps.h
> new file mode 100644
> index 0000000..69834b9
> --- /dev/null
> +++ b/include/linux/i2c/bcm4751-gps.h
> @@ -0,0 +1,59 @@
> +/*
> + * @file include/linux/i2c/bcm4751-gps.h
> + *
> + *
> + * Copyright (C)       2010 Nokia Corporation
> + * Contact             Matti Aaltonen, matti.j.aaltonen@nokia.com
> + *
> + * Written by Andrei Emeltchenko <andrei.emeltchenko@nokia.com>
> + * Modified by Yuri Zaporozhets <ext-yuri.zaporozhets@nokia.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.         See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + */
> +
> +#ifndef _LINUX_I2C_BCM4751_GPS_H
> +#define _LINUX_I2C_BCM4751_GPS_H
> +
> +/* Max packet sizes for RX and TX */
> +#define BCM4751_MAX_BINPKT_RX_LEN      64
> +#define BCM4751_MAX_BINPKT_TX_LEN      64
> +
> +/* Plaform data, used by the board support file */
> +struct bcm4751_gps_platform_data {
> +       int gps_gpio_irq;
> +       int gps_gpio_enable;
> +       int gps_gpio_wakeup;
> +       int     (*setup)(struct i2c_client *client);
> +       void    (*cleanup)(struct i2c_client *client);
> +       void    (*enable)(struct i2c_client *client);
> +       void    (*disable)(struct i2c_client *client);
> +       void    (*wakeup_ctrl)(struct i2c_client *client, int value);
> +       int     (*show_irq)(struct i2c_client *client);
> +};
> +
> +/* Used internally by the driver */
> +struct bcm4751_gps_data {
> +       struct i2c_client               *client;
> +       struct bcm4751_gps_platform_data *pdata;
> +       struct mutex                    mutex; /* Serialize things */
> +       struct regulator_bulk_data      regs[2];
> +       unsigned int                    gpio_irq;
> +       unsigned int                    gpio_enable;
> +       unsigned int                    gpio_wakeup;
> +       int                             enable;
> +       int                             wakeup;
> +};
> +
> +#endif
> --
> 1.6.1.3
> 


