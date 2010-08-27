Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab0H0HQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 03:16:23 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:45866 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab0H0HQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 03:16:20 -0400
Date: Fri, 27 Aug 2010 09:16:07 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Chew <achew@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        alan@linux.intel.com, akpm@linux-foundation.org, olof@lixom.net
Subject: Re: [PATCH 1/1] drivers/misc/akm8975: Add compass sensor driver
Message-ID: <20100827091607.1bb889f2@hyperion.delvare>
In-Reply-To: <1282872717-12228-1-git-send-email-achew@nvidia.com>
References: <1282872717-12228-1-git-send-email-achew@nvidia.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Please note: lkml@vger.kernel.org doesn't exist.

Here's my review, as a complement to Andrew's.

On Thu, 26 Aug 2010 18:31:57 -0700, Andrew@vger.kernel.org, Chew@vger.kernel.org wrote:
> From: Andrew Chew <achew@nvidia.com>
> 
> This is for the Asahi Kasei's I2C compass sensor AK8975.
> 
> Signed-off-by: Andrew Chew <achew@nvidia.com>
> ---
>  drivers/misc/Kconfig    |    8 +
>  drivers/misc/Makefile   |    1 +
>  drivers/misc/akm8975.c  |  670 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/akm8975.h |   87 ++++++
>  4 files changed, 766 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/misc/akm8975.c
>  create mode 100644 include/linux/akm8975.h
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 26386a9..9bb3d03 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -304,6 +304,14 @@ config SENSORS_TSL2550
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called tsl2550.
>  
> +config SENSORS_AK8975
> +	tristate "AK8975 compass support"
> +	default n
> +	depends on I2C
> +	help
> +	  If you say yes here you get support for Asahi Kasei's
> +	  orientation sensor AK8975.
> +
>  config EP93XX_PWM
>  	tristate "EP93xx PWM support"
>  	depends on ARCH_EP93XX
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index 6ed06a1..366791b 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -31,3 +31,4 @@ obj-$(CONFIG_IWMC3200TOP)      += iwmc3200top/
>  obj-y				+= eeprom/
>  obj-y				+= cb710/
>  obj-$(CONFIG_VMWARE_BALLOON)	+= vmware_balloon.o
> +obj-$(CONFIG_SENSORS_AK8975)	+= akm8975.o

CONFIG_COMPASS_AK8975 would be a better name IMHO, in anticipation of a
compass subsystem being created someday.

> diff --git a/drivers/misc/akm8975.c b/drivers/misc/akm8975.c
> new file mode 100644
> index 0000000..17a096e
> --- /dev/null
> +++ b/drivers/misc/akm8975.c
> @@ -0,0 +1,670 @@
> +/* drivers/misc/akm8975.c - akm8975 compass driver
> + *
> + * Copyright (C) 2007-2008 HTC Corporation.
> + * Author: Hou-Kun Chen <houkun.chen@gmail.com>
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +/*
> + * Revised by AKM 2009/04/02
> + * Revised by Motorola 2010/05/27
> + *
> + */
> +
> +#include <linux/interrupt.h>
> +#include <linux/i2c.h>
> +#include <linux/slab.h>
> +#include <linux/irq.h>

Do you really need this one?

> +#include <linux/miscdevice.h>
> +#include <linux/gpio.h>

You don't seem to need this.

> +#include <linux/uaccess.h>
> +#include <linux/delay.h>

You don't need this?

> +#include <linux/input.h>
> +#include <linux/workqueue.h>
> +#include <linux/freezer.h>

What is this one being used for?

> +#include <linux/akm8975.h>
> +
> +#define AK8975DRV_CALL_DBG 0
> +#if AK8975DRV_CALL_DBG
> +#define FUNCDBG(msg)	pr_err("%s:%s\n", __func__, msg);
> +#else
> +#define FUNCDBG(msg)
> +#endif

This tracing can probably go away once this driver is considered good
for merging.

> +
> +#define AK8975DRV_DATA_DBG 0
> +#define MAX_FAILURE_COUNT 10

Not used anywhere?

> +
> +struct akm8975_data {
> +	struct i2c_client *this_client;

"this_" makes the name longer without adding any value..

> +	struct akm8975_platform_data *pdata;
> +	struct input_dev *input_dev;
> +	struct work_struct work;
> +	struct mutex flags_lock;
> +};
> +
> +/*
> +* Because misc devices can not carry a pointer from driver register to
> +* open, we keep this global. This limits the driver to a single instance.
> +*/
> +struct akm8975_data *akmd_data;

Should be static.

> +
> +static DECLARE_WAIT_QUEUE_HEAD(open_wq);
> +
> +static atomic_t open_flag;
> +
> +static short m_flag;
> +static short a_flag;
> +static short t_flag;
> +static short mv_flag;
> +
> +static short akmd_delay;
> +
> +static ssize_t akm8975_show(struct device *dev, struct device_attribute *attr,
> +				 char *buf)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	return sprintf(buf, "%u\n", i2c_smbus_read_byte_data(client,
> +							     AK8975_REG_CNTL));

Missing error handling. i2c_smbus_read_byte_data can return an error,
which you want to pass to user-space as a proper error code, not a
random negative value.

> +}
> +static ssize_t akm8975_store(struct device *dev, struct device_attribute *attr,
> +			    const char *buf, size_t count)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	unsigned long val;
> +	strict_strtoul(buf, 10, &val);
> +	if (val > 0xff)
> +		return -EINVAL;
> +	i2c_smbus_write_byte_data(client, AK8975_REG_CNTL, val);

Here again, error code is ignored.

> +	return count;
> +}
> +static DEVICE_ATTR(akm_ms1, S_IWUSR | S_IRUGO, akm8975_show, akm8975_store);
> +
> +static int akm8975_i2c_rxdata(struct akm8975_data *akm, char *buf, int length)
> +{
> +	struct i2c_msg msgs[] = {
> +		{
> +			.addr = akm->this_client->addr,
> +			.flags = 0,
> +			.len = 1,
> +			.buf = buf,
> +		},
> +		{
> +			.addr = akm->this_client->addr,
> +			.flags = I2C_M_RD,
> +			.len = length,
> +			.buf = buf,

Using the same buffer for writing and reading is unsupported. I think
it should work, but there's no guarantee.

> +		},
> +	};
> +
> +	FUNCDBG("called");
> +
> +	if (i2c_transfer(akm->this_client->adapter, msgs, 2) < 0) {

What's the largest data block you need to handle? If 32 or less, you
should be using i2c_smbus_read_i2c_block_data(), which is more portable.

> +		pr_err("akm8975_i2c_rxdata: transfer error\n");
> +		return EIO;

Should be -EIO, otherwise error handling won't trigger.

> +	} else
> +		return 0;
> +}
> +
> +static int akm8975_i2c_txdata(struct akm8975_data *akm, char *buf, int length)
> +{
> +	struct i2c_msg msgs[] = {
> +		{
> +			.addr = akm->this_client->addr,
> +			.flags = 0,
> +			.len = length,
> +			.buf = buf,
> +		},
> +	};
> +
> +	FUNCDBG("called");
> +
> +	if (i2c_transfer(akm->this_client->adapter, msgs, 1) < 0) {

What's the largest data block you need to handle? If 32 or less, you
should be using i2c_smbus_write_i2c_block_data(), which is more
portable.

> +		pr_err("akm8975_i2c_txdata: transfer error\n");
> +		return -EIO;
> +	} else
> +		return 0;
> +}
> +
> +static void akm8975_ecs_report_value(struct akm8975_data *akm, short *rbuf)
> +{
> +	struct akm8975_data *data = i2c_get_clientdata(akm->this_client);
> +
> +	FUNCDBG("called");
> +
> +#if AK8975DRV_DATA_DBG
> +	pr_info("akm8975_ecs_report_value: yaw = %d, pitch = %d, roll = %d\n",
> +				 rbuf[0], rbuf[1], rbuf[2]);
> +	pr_info("tmp = %d, m_stat= %d, g_stat=%d\n", rbuf[3], rbuf[4], rbuf[5]);
> +	pr_info("Acceleration:	 x = %d LSB, y = %d LSB, z = %d LSB\n",
> +				 rbuf[6], rbuf[7], rbuf[8]);
> +	pr_info("Magnetic:	 x = %d LSB, y = %d LSB, z = %d LSB\n\n",
> +				 rbuf[9], rbuf[10], rbuf[11]);
> +#endif
> +	mutex_lock(&akm->flags_lock);
> +	/* Report magnetic sensor information */
> +	if (m_flag) {
> +		input_report_abs(data->input_dev, ABS_RX, rbuf[0]);
> +		input_report_abs(data->input_dev, ABS_RY, rbuf[1]);
> +		input_report_abs(data->input_dev, ABS_RZ, rbuf[2]);
> +		input_report_abs(data->input_dev, ABS_RUDDER, rbuf[4]);
> +	}
> +
> +	/* Report acceleration sensor information */
> +	if (a_flag) {
> +		input_report_abs(data->input_dev, ABS_X, rbuf[6]);
> +		input_report_abs(data->input_dev, ABS_Y, rbuf[7]);
> +		input_report_abs(data->input_dev, ABS_Z, rbuf[8]);
> +		input_report_abs(data->input_dev, ABS_WHEEL, rbuf[5]);
> +	}
> +
> +	/* Report temperature information */
> +	if (t_flag)
> +		input_report_abs(data->input_dev, ABS_THROTTLE, rbuf[3]);
> +
> +	if (mv_flag) {
> +		input_report_abs(data->input_dev, ABS_HAT0X, rbuf[9]);
> +		input_report_abs(data->input_dev, ABS_HAT0Y, rbuf[10]);
> +		input_report_abs(data->input_dev, ABS_BRAKE, rbuf[11]);
> +	}
> +	mutex_unlock(&akm->flags_lock);
> +
> +	input_sync(data->input_dev);
> +}
> +
> +static void akm8975_ecs_close_done(struct akm8975_data *akm)
> +{
> +	FUNCDBG("called");
> +	mutex_lock(&akm->flags_lock);
> +	m_flag = 1;
> +	a_flag = 1;
> +	t_flag = 1;
> +	mv_flag = 1;
> +	mutex_unlock(&akm->flags_lock);
> +}
> +
> +static int akm_aot_open(struct inode *inode, struct file *file)
> +{
> +	int ret = -1;

Useless and dangerous initialization.

> +
> +	FUNCDBG("called");
> +	if (atomic_cmpxchg(&open_flag, 0, 1) == 0) {
> +		wake_up(&open_wq);
> +		ret = 0;
> +	}
> +
> +	ret = nonseekable_open(inode, file);
> +	if (ret)
> +		return ret;
> +
> +	file->private_data = akmd_data;
> +
> +	return ret;
> +}
> +
> +static int akm_aot_release(struct inode *inode, struct file *file)
> +{
> +	FUNCDBG("called");
> +	atomic_set(&open_flag, 0);
> +	wake_up(&open_wq);
> +	return 0;
> +}
> +
> +static int akm_aot_ioctl(struct inode *inode, struct file *file,
> +	      unsigned int cmd, unsigned long arg)
> +{
> +	void __user *argp = (void __user *) arg;
> +	short flag;
> +	struct akm8975_data *akm = file->private_data;
> +
> +	FUNCDBG("called");
> +
> +	switch (cmd) {
> +	case ECS_IOCTL_APP_SET_MFLAG:
> +	case ECS_IOCTL_APP_SET_AFLAG:
> +	case ECS_IOCTL_APP_SET_MVFLAG:
> +		if (copy_from_user(&flag, argp, sizeof(flag)))
> +			return -EFAULT;
> +		if (flag < 0 || flag > 1)
> +			return -EINVAL;
> +		break;
> +	case ECS_IOCTL_APP_SET_DELAY:
> +		if (copy_from_user(&flag, argp, sizeof(flag)))
> +			return -EFAULT;

No range check?

> +		break;
> +	default:
> +		break;

What's the point?

> +	}
> +
> +	mutex_lock(&akm->flags_lock);
> +	switch (cmd) {
> +	case ECS_IOCTL_APP_SET_MFLAG:
> +		m_flag = flag;
> +		break;
> +	case ECS_IOCTL_APP_GET_MFLAG:
> +		flag = m_flag;
> +		break;
> +	case ECS_IOCTL_APP_SET_AFLAG:
> +		a_flag = flag;
> +		break;
> +	case ECS_IOCTL_APP_GET_AFLAG:
> +		flag = a_flag;
> +		break;
> +	case ECS_IOCTL_APP_SET_MVFLAG:
> +		mv_flag = flag;
> +		break;
> +	case ECS_IOCTL_APP_GET_MVFLAG:
> +		flag = mv_flag;
> +		break;
> +	case ECS_IOCTL_APP_SET_DELAY:
> +		akmd_delay = flag;
> +		break;
> +	case ECS_IOCTL_APP_GET_DELAY:
> +		flag = akmd_delay;
> +		break;
> +	default:
> +		return -ENOTTY;

You return with a lock held...

> +	}
> +	mutex_unlock(&akm->flags_lock);
> +
> +	switch (cmd) {
> +	case ECS_IOCTL_APP_GET_MFLAG:
> +	case ECS_IOCTL_APP_GET_AFLAG:
> +	case ECS_IOCTL_APP_GET_MVFLAG:
> +	case ECS_IOCTL_APP_GET_DELAY:
> +		if (copy_to_user(argp, &flag, sizeof(flag)))
> +			return -EFAULT;
> +		break;
> +	default:
> +		break;

Needless statement.

> +	}
> +
> +	return 0;
> +}
> +
> +static int akmd_open(struct inode *inode, struct file *file)
> +{
> +	int err = 0;

Useless initialization.

> +
> +	FUNCDBG("called");
> +	err = nonseekable_open(inode, file);
> +	if (err)
> +		return err;
> +
> +	file->private_data = akmd_data;
> +	return 0;
> +}
> +
> +static int akmd_release(struct inode *inode, struct file *file)
> +{
> +	struct akm8975_data *akm = file->private_data;
> +
> +	FUNCDBG("called");
> +	akm8975_ecs_close_done(akm);
> +	return 0;
> +}
> +
> +static int akmd_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
> +		      unsigned long arg)
> +{
> +	void __user *argp = (void __user *) arg;
> +
> +	char rwbuf[16];
> +	int ret = -1;

Useless and dangerous initialization.

> +	int status;
> +	short value[12];
> +	short delay;
> +	struct akm8975_data *akm = file->private_data;
> +
> +	FUNCDBG("called");
> +
> +	switch (cmd) {
> +	case ECS_IOCTL_READ:
> +	case ECS_IOCTL_WRITE:
> +		if (copy_from_user(&rwbuf, argp, sizeof(rwbuf)))
> +			return -EFAULT;
> +		break;
> +
> +	case ECS_IOCTL_SET_YPR:
> +		if (copy_from_user(&value, argp, sizeof(value)))
> +			return -EFAULT;
> +		break;
> +
> +	default:
> +		break;

What's the point?

> +	}
> +
> +	switch (cmd) {
> +	case ECS_IOCTL_READ:
> +		if (rwbuf[0] < 1)
> +			return -EINVAL;

Missing upper bound check.

> +
> +		ret = akm8975_i2c_rxdata(akm, &rwbuf[1], rwbuf[0]);
> +		if (ret < 0)
> +			return ret;
> +		break;
> +
> +	case ECS_IOCTL_WRITE:
> +		if (rwbuf[0] < 2)
> +			return -EINVAL;
> +

Missing upper bound check.

> +		ret = akm8975_i2c_txdata(akm, &rwbuf[1], rwbuf[0]);
> +		if (ret < 0)
> +			return ret;
> +		break;
> +	case ECS_IOCTL_SET_YPR:
> +		akm8975_ecs_report_value(akm, value);
> +		break;
> +
> +	case ECS_IOCTL_GET_OPEN_STATUS:
> +		wait_event_interruptible(open_wq,
> +					 (atomic_read(&open_flag) != 0));
> +		status = atomic_read(&open_flag);
> +		break;
> +	case ECS_IOCTL_GET_CLOSE_STATUS:
> +		wait_event_interruptible(open_wq,
> +					 (atomic_read(&open_flag) == 0));
> +		status = atomic_read(&open_flag);
> +		break;
> +
> +	case ECS_IOCTL_GET_DELAY:
> +		delay = akmd_delay;
> +		break;
> +
> +	default:
> +		FUNCDBG("Unknown cmd\n");
> +		return -ENOTTY;
> +	}
> +
> +	switch (cmd) {
> +	case ECS_IOCTL_READ:
> +		if (copy_to_user(argp, &rwbuf, sizeof(rwbuf)))
> +			return -EFAULT;
> +		break;
> +	case ECS_IOCTL_GET_OPEN_STATUS:
> +	case ECS_IOCTL_GET_CLOSE_STATUS:
> +		if (copy_to_user(argp, &status, sizeof(status)))
> +			return -EFAULT;
> +		break;
> +	case ECS_IOCTL_GET_DELAY:
> +		if (copy_to_user(argp, &delay, sizeof(delay)))
> +			return -EFAULT;
> +		break;
> +	default:
> +		break;

Needless statement.

> +	}
> +
> +	return 0;
> +}
> +
> +/* needed to clear the int. pin */
> +static void akm_work_func(struct work_struct *work)
> +{
> +	struct akm8975_data *akm =
> +	    container_of(work, struct akm8975_data, work);
> +
> +	FUNCDBG("called");
> +	enable_irq(akm->this_client->irq);
> +}
> +
> +static irqreturn_t akm8975_interrupt(int irq, void *dev_id)
> +{
> +	struct akm8975_data *akm = dev_id;
> +	FUNCDBG("called");
> +
> +	disable_irq_nosync(akm->this_client->irq);
> +	schedule_work(&akm->work);
> +	return IRQ_HANDLED;
> +}
> +
> +static int akm8975_power_off(struct akm8975_data *akm)
> +{
> +#if AK8975DRV_CALL_DBG
> +	pr_info("%s\n", __func__);
> +#endif

Why not just FUNCDBG("called") as everywhere else?

> +	if (akm->pdata->power_off)
> +		akm->pdata->power_off();

This function could return an error, which you want to transmit.

> +
> +	return 0;
> +}
> +
> +static int akm8975_power_on(struct akm8975_data *akm)
> +{
> +	int err;
> +
> +#if AK8975DRV_CALL_DBG
> +	pr_info("%s\n", __func__);
> +#endif
> +	if (akm->pdata->power_on) {
> +		err = akm->pdata->power_on();
> +		if (err < 0)
> +			return err;
> +	}
> +	return 0;
> +}
> +
> +static int akm8975_init_client(struct i2c_client *client)
> +{
> +	struct akm8975_data *data;
> +	int ret;
> +
> +	data = i2c_get_clientdata(client);
> +
> +	ret = request_irq(client->irq, akm8975_interrupt, IRQF_TRIGGER_RISING,
> +				"akm8975", data);
> +
> +	if (ret < 0) {
> +		pr_err("akm8975_init_client: request irq failed\n");

Please use dev_err().

> +		goto err;
> +	}
> +
> +	init_waitqueue_head(&open_wq);
> +
> +	mutex_lock(&data->flags_lock);
> +	m_flag = 1;
> +	a_flag = 1;
> +	t_flag = 1;
> +	mv_flag = 1;
> +	mutex_unlock(&data->flags_lock);

Shouldn't you set up everything _before_ requesting the IRQ?

> +
> +	return 0;
> +err:
> +	return ret;
> +}
> +
> +static const struct file_operations akmd_fops = {
> +	.owner = THIS_MODULE,
> +	.open = akmd_open,
> +	.release = akmd_release,
> +	.ioctl = akmd_ioctl,
> +};
> +
> +static const struct file_operations akm_aot_fops = {
> +	.owner = THIS_MODULE,
> +	.open = akm_aot_open,
> +	.release = akm_aot_release,
> +	.ioctl = akm_aot_ioctl,
> +};
> +
> +static struct miscdevice akm_aot_device = {
> +	.minor = MISC_DYNAMIC_MINOR,
> +	.name = "akm8975_aot",
> +	.fops = &akm_aot_fops,
> +};
> +
> +static struct miscdevice akmd_device = {
> +	.minor = MISC_DYNAMIC_MINOR,
> +	.name = "akm8975_dev",
> +	.fops = &akmd_fops,
> +};
> +
> +int akm8975_probe(struct i2c_client *client,
> +		  const struct i2c_device_id *devid)
> +{
> +	struct akm8975_data *akm;
> +	int err;
> +	FUNCDBG("called");
> +
> +	if (client->dev.platform_data == NULL) {
> +		dev_err(&client->dev, "platform data is NULL. exiting.\n");
> +		err = -ENODEV;
> +		goto exit_platform_data_null;
> +	}
> +
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {

This check doesn't match the actual API use. Will need revisiting if
you go for i2c_smbus_{write,read}_i2c_block_data anyway.

> +		dev_err(&client->dev, "platform data is NULL. exiting.\n");

Wrong error message.

> +		err = -ENODEV;
> +		goto exit_check_functionality_failed;
> +	}
> +
> +	akm = kzalloc(sizeof(struct akm8975_data), GFP_KERNEL);
> +	if (!akm) {
> +		dev_err(&client->dev,
> +			"failed to allocate memory for module data\n");
> +		err = -ENOMEM;
> +		goto exit_alloc_data_failed;
> +	}
> +
> +	akm->pdata = client->dev.platform_data;
> +
> +	mutex_init(&akm->flags_lock);
> +	INIT_WORK(&akm->work, akm_work_func);
> +	i2c_set_clientdata(client, akm);
> +
> +	err = akm8975_power_on(akm);
> +	if (err < 0)
> +		goto exit_power_on_failed;
> +
> +	akm8975_init_client(client);
> +	akm->this_client = client;
> +	akmd_data = akm;
> +
> +	akm->input_dev = input_allocate_device();
> +	if (!akm->input_dev) {
> +		err = -ENOMEM;
> +		dev_err(&akm->this_client->dev,
> +			"input device allocate failed\n");
> +		goto exit_input_dev_alloc_failed;
> +	}
> +
> +	set_bit(EV_ABS, akm->input_dev->evbit);
> +
> +	/* yaw */
> +	input_set_abs_params(akm->input_dev, ABS_RX, 0, 23040, 0, 0);
> +	/* pitch */
> +	input_set_abs_params(akm->input_dev, ABS_RY, -11520, 11520, 0, 0);
> +	/* roll */
> +	input_set_abs_params(akm->input_dev, ABS_RZ, -5760, 5760, 0, 0);
> +	/* x-axis acceleration */
> +	input_set_abs_params(akm->input_dev, ABS_X, -5760, 5760, 0, 0);
> +	/* y-axis acceleration */
> +	input_set_abs_params(akm->input_dev, ABS_Y, -5760, 5760, 0, 0);
> +	/* z-axis acceleration */
> +	input_set_abs_params(akm->input_dev, ABS_Z, -5760, 5760, 0, 0);
> +	/* temparature */
> +	input_set_abs_params(akm->input_dev, ABS_THROTTLE, -30, 85, 0, 0);
> +	/* status of magnetic sensor */
> +	input_set_abs_params(akm->input_dev, ABS_RUDDER, 0, 3, 0, 0);
> +	/* status of acceleration sensor */
> +	input_set_abs_params(akm->input_dev, ABS_WHEEL, 0, 3, 0, 0);
> +	/* x-axis of raw magnetic vector */
> +	input_set_abs_params(akm->input_dev, ABS_HAT0X, -20480, 20479, 0, 0);
> +	/* y-axis of raw magnetic vector */
> +	input_set_abs_params(akm->input_dev, ABS_HAT0Y, -20480, 20479, 0, 0);
> +	/* z-axis of raw magnetic vector */
> +	input_set_abs_params(akm->input_dev, ABS_BRAKE, -20480, 20479, 0, 0);
> +
> +	akm->input_dev->name = "compass";
> +
> +	err = input_register_device(akm->input_dev);
> +	if (err) {
> +		pr_err("akm8975_probe: Unable to register input device: %s\n",
> +					 akm->input_dev->name);

dev_err()

> +		goto exit_input_register_device_failed;
> +	}
> +
> +	err = misc_register(&akmd_device);
> +	if (err) {
> +		pr_err("akm8975_probe: akmd_device register failed\n");

dev_err()

> +		goto exit_misc_device_register_failed;
> +	}
> +
> +	err = misc_register(&akm_aot_device);
> +	if (err) {
> +		pr_err("akm8975_probe: akm_aot_device register failed\n");

dev_err()

> +		goto exit_misc_device_register_failed;
> +	}
> +
> +	err = device_create_file(&client->dev, &dev_attr_akm_ms1);

Missing error handling.

> +
> +	return 0;
> +
> +exit_misc_device_register_failed:
> +exit_input_register_device_failed:
> +	input_free_device(akm->input_dev);
> +exit_input_dev_alloc_failed:
> +	akm8975_power_off(akm);
> +exit_power_on_failed:
> +	kfree(akm);
> +exit_alloc_data_failed:
> +exit_check_functionality_failed:
> +exit_platform_data_null:

It is more common to name the labels based on the next undo action.
This avoids having several labels for the same point.

> +	return err;
> +}
> +
> +static int __devexit akm8975_remove(struct i2c_client *client)
> +{
> +	struct akm8975_data *akm = i2c_get_clientdata(client);
> +	FUNCDBG("called");
> +	free_irq(client->irq, NULL);
> +	input_unregister_device(akm->input_dev);
> +	misc_deregister(&akmd_device);
> +	misc_deregister(&akm_aot_device);
> +	akm8975_power_off(akm);
> +	kfree(akm);
> +	return 0;
> +}
> +
> +static const struct i2c_device_id akm8975_id[] = {
> +	{ "akm8975", 0 },
> +	{ }
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, akm8975_id);
> +
> +static struct i2c_driver akm8975_driver = {
> +	.probe = akm8975_probe,
> +	.remove = akm8975_remove,

Missing __devexit_p().

> +	.id_table = akm8975_id,
> +	.driver = {
> +		.name = "akm8975",
> +	},
> +};
> +
> +static int __init akm8975_init(void)
> +{
> +	pr_info("AK8975 compass driver: init\n");

Debugging message shouldn't be printed with pr_info().

> +	FUNCDBG("AK8975 compass driver: init\n");
> +	return i2c_add_driver(&akm8975_driver);
> +}
> +
> +static void __exit akm8975_exit(void)
> +{
> +	FUNCDBG("AK8975 compass driver: exit\n");
> +	i2c_del_driver(&akm8975_driver);
> +}
> +
> +module_init(akm8975_init);
> +module_exit(akm8975_exit);
> +
> +MODULE_AUTHOR("Hou-Kun Chen <hk_chen@htc.com>");
> +MODULE_DESCRIPTION("AK8975 compass driver");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/akm8975.h b/include/linux/akm8975.h
> new file mode 100644
> index 0000000..7d02120
> --- /dev/null
> +++ b/include/linux/akm8975.h

This should be include/linux/i2c/akm8975.h, as all other i2c device
drivers to.

> @@ -0,0 +1,87 @@
> +/*
> + * Definitions for akm8975 compass chip.
> + */
> +#ifndef AKM8975_H
> +#define AKM8975_H

Should be __LINUX_I2C_AKM8975_H.

> +
> +#include <linux/ioctl.h>
> +
> +/*! \name AK8975 operation mode
> + \anchor AK8975_Mode
> + Defines an operation mode of the AK8975.*/
> +/*! @{*/

What's this ugly syntax? Please follow the standard documentation
syntax.

> +#define AK8975_MODE_SNG_MEASURE	0x01
> +#define	AK8975_MODE_SELF_TEST	0x08
> +#define	AK8975_MODE_FUSE_ACCESS	0x0F
> +#define	AK8975_MODE_POWER_DOWN	0x00

Incorrect alignment.

> +/*! @}*/
> +
> +#define RBUFF_SIZE		8	/* Rx buffer size */
> +
> +/*! \name AK8975 register address
> +\anchor AK8975_REG
> +Defines a register address of the AK8975.*/
> +/*! @{*/
> +#define AK8975_REG_WIA		0x00
> +#define AK8975_REG_INFO		0x01
> +#define AK8975_REG_ST1		0x02
> +#define AK8975_REG_HXL		0x03
> +#define AK8975_REG_HXH		0x04
> +#define AK8975_REG_HYL		0x05
> +#define AK8975_REG_HYH		0x06
> +#define AK8975_REG_HZL		0x07
> +#define AK8975_REG_HZH		0x08
> +#define AK8975_REG_ST2		0x09
> +#define AK8975_REG_CNTL		0x0A
> +#define AK8975_REG_RSV		0x0B
> +#define AK8975_REG_ASTC		0x0C
> +#define AK8975_REG_TS1		0x0D
> +#define AK8975_REG_TS2		0x0E
> +#define AK8975_REG_I2CDIS	0x0F
> +/*! @}*/

Do users need to know this? I guess not. Public header files should
only contain the API users need. Everything which is only used
internally by the driver shouldn't be there.

> +
> +/*! \name AK8975 fuse-rom address
> +\anchor AK8975_FUSE
> +Defines a read-only address of the fuse ROM of the AK8975.*/
> +/*! @{*/
> +#define AK8975_FUSE_ASAX	0x10
> +#define AK8975_FUSE_ASAY	0x11
> +#define AK8975_FUSE_ASAZ	0x12
> +/*! @}*/
> +
> +#define AKMIO			0xA1
> +
> +/* IOCTLs for AKM library */
> +#define ECS_IOCTL_WRITE                 _IOW(AKMIO, 0x02, char[5])
> +#define ECS_IOCTL_READ                  _IOWR(AKMIO, 0x03, char[5])
> +#define ECS_IOCTL_GETDATA               _IOR(AKMIO, 0x08, char[RBUFF_SIZE])
> +#define ECS_IOCTL_SET_YPR               _IOW(AKMIO, 0x0C, short[12])
> +#define ECS_IOCTL_GET_OPEN_STATUS       _IOR(AKMIO, 0x0D, int)
> +#define ECS_IOCTL_GET_CLOSE_STATUS      _IOR(AKMIO, 0x0E, int)
> +#define ECS_IOCTL_GET_DELAY             _IOR(AKMIO, 0x30, short)
> +
> +/* IOCTLs for APPs */
> +#define ECS_IOCTL_APP_SET_MFLAG		_IOW(AKMIO, 0x11, short)
> +#define ECS_IOCTL_APP_GET_MFLAG		_IOW(AKMIO, 0x12, short)
> +#define ECS_IOCTL_APP_SET_AFLAG		_IOW(AKMIO, 0x13, short)
> +#define ECS_IOCTL_APP_GET_AFLAG		_IOR(AKMIO, 0x14, short)
> +#define ECS_IOCTL_APP_SET_DELAY		_IOW(AKMIO, 0x18, short)
> +#define ECS_IOCTL_APP_GET_DELAY		ECS_IOCTL_GET_DELAY
> +/* Set raw magnetic vector flag */
> +#define ECS_IOCTL_APP_SET_MVFLAG	_IOW(AKMIO, 0x19, short)
> +/* Get raw magnetic vector flag */
> +#define ECS_IOCTL_APP_GET_MVFLAG	_IOR(AKMIO, 0x1A, short)
> +#define ECS_IOCTL_APP_SET_TFLAG         _IOR(AKMIO, 0x15, short)
> +
> +
> +struct akm8975_platform_data {
> +	int intr;
> +
> +	int (*init)(void);
> +	void (*exit)(void);
> +	int (*power_on)(void);
> +	int (*power_off)(void);

These "void" parameters seem suspicious. I would expect at least the
device to be passed as a parameter. I understand that your driver is
currently limited to supporting a single device, but you should avoid
designing everything based on this assumption, because hopefully it can
be solved someday.

> +};
> +
> +#endif
> +


-- 
Jean Delvare
