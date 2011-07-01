Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab1GACVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 22:21:23 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:60161 "HELO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754517Ab1GACTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 22:19:20 -0400
From: Nathan Royer <nroyer@invensense.com>
To: Nathan Royer <nroyer@invensense.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        Alan Cox <alan@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 04/11] misc: IRQ handling for MPU3050 and slave devices
Date: Thu, 30 Jun 2011 19:18:20 -0700
Message-Id: <1309486707-1658-4-git-send-email-nroyer@invensense.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nathan Royer <nroyer@invensense.com>
---
 drivers/misc/inv_mpu/mpuirq.c   |  256 +++++++++++++++++++++++++++++++++++++
 drivers/misc/inv_mpu/mpuirq.h   |   36 ++++++
 drivers/misc/inv_mpu/slaveirq.c |  265 +++++++++++++++++++++++++++++++++++++++
 drivers/misc/inv_mpu/slaveirq.h |   38 ++++++
 4 files changed, 595 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/inv_mpu/mpuirq.c
 create mode 100644 drivers/misc/inv_mpu/mpuirq.h
 create mode 100644 drivers/misc/inv_mpu/slaveirq.c
 create mode 100644 drivers/misc/inv_mpu/slaveirq.h

diff --git a/drivers/misc/inv_mpu/mpuirq.c b/drivers/misc/inv_mpu/mpuirq.c
new file mode 100644
index 0000000..ffe0e05
--- /dev/null
+++ b/drivers/misc/inv_mpu/mpuirq.c
@@ -0,0 +1,256 @@
+/*
+	$License:
+	Copyright (C) 2011 InvenSense Corporation, All Rights Reserved.
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program.  If not, see <http://www.gnu.org/licenses/>.
+	$
+ */
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/stat.h>
+#include <linux/irq.h>
+#include <linux/signal.h>
+#include <linux/miscdevice.h>
+#include <linux/i2c.h>
+#include <linux/i2c-dev.h>
+#include <linux/poll.h>
+
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+
+#include <linux/mpu.h>
+#include "mpuirq.h"
+#include "mldl_cfg.h"
+
+#define MPUIRQ_NAME "mpuirq"
+
+/* function which gets accel data and sends it to MPU */
+
+DECLARE_WAIT_QUEUE_HEAD(mpuirq_wait);
+
+struct mpuirq_dev_data {
+	struct i2c_client *mpu_client;
+	struct miscdevice *dev;
+	int irq;
+	int pid;
+	int accel_divider;
+	int data_ready;
+	int timeout;
+};
+
+static struct mpuirq_dev_data mpuirq_dev_data;
+static struct mpuirq_data mpuirq_data;
+static char *interface = MPUIRQ_NAME;
+
+static int mpuirq_open(struct inode *inode, struct file *file)
+{
+	dev_dbg(mpuirq_dev_data.dev->this_device,
+		"%s current->pid %d\n", __func__, current->pid);
+	mpuirq_dev_data.pid = current->pid;
+	file->private_data = &mpuirq_dev_data;
+	return 0;
+}
+
+/* close function - called when the "file" /dev/mpuirq is closed in userspace */
+static int mpuirq_release(struct inode *inode, struct file *file)
+{
+	dev_dbg(mpuirq_dev_data.dev->this_device, "mpuirq_release\n");
+	return 0;
+}
+
+/* read function called when from /dev/mpuirq is read */
+static ssize_t mpuirq_read(struct file *file,
+			   char *buf, size_t count, loff_t *ppos)
+{
+	int len, err;
+	struct mpuirq_dev_data *p_mpuirq_dev_data = file->private_data;
+
+	if (!mpuirq_dev_data.data_ready &&
+	    mpuirq_dev_data.timeout && (!(file->f_flags & O_NONBLOCK))) {
+		wait_event_interruptible_timeout(mpuirq_wait,
+						 mpuirq_dev_data.data_ready,
+						 mpuirq_dev_data.timeout);
+	}
+
+	if (mpuirq_dev_data.data_ready && NULL != buf
+	    && count >= sizeof(mpuirq_data)) {
+		err = copy_to_user(buf, &mpuirq_data, sizeof(mpuirq_data));
+		mpuirq_data.data_type = 0;
+	} else {
+		return 0;
+	}
+	if (err != 0) {
+		dev_err(p_mpuirq_dev_data->dev->this_device,
+			"Copy to user returned %d\n", err);
+		return -EFAULT;
+	}
+	mpuirq_dev_data.data_ready = 0;
+	len = sizeof(mpuirq_data);
+	return len;
+}
+
+unsigned int mpuirq_poll(struct file *file, struct poll_table_struct *poll)
+{
+	int mask = 0;
+
+	poll_wait(file, &mpuirq_wait, poll);
+	if (mpuirq_dev_data.data_ready)
+		mask |= POLLIN | POLLRDNORM;
+	return mask;
+}
+
+/* ioctl - I/O control */
+static long mpuirq_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	int retval = 0;
+	int data;
+
+	switch (cmd) {
+	case MPUIRQ_SET_TIMEOUT:
+		mpuirq_dev_data.timeout = arg;
+		break;
+
+	case MPUIRQ_GET_INTERRUPT_CNT:
+		data = mpuirq_data.interruptcount - 1;
+		if (mpuirq_data.interruptcount > 1)
+			mpuirq_data.interruptcount = 1;
+
+		if (copy_to_user((int *)arg, &data, sizeof(int)))
+			return -EFAULT;
+		break;
+	case MPUIRQ_GET_IRQ_TIME:
+		if (copy_to_user((int *)arg, &mpuirq_data.irqtime,
+				 sizeof(mpuirq_data.irqtime)))
+			return -EFAULT;
+		mpuirq_data.irqtime = 0;
+		break;
+	case MPUIRQ_SET_FREQUENCY_DIVIDER:
+		mpuirq_dev_data.accel_divider = arg;
+		break;
+	default:
+		retval = -EINVAL;
+	}
+	return retval;
+}
+
+static irqreturn_t mpuirq_handler(int irq, void *dev_id)
+{
+	static int mycount;
+	struct timeval irqtime;
+	mycount++;
+
+	mpuirq_data.interruptcount++;
+
+	/* wake up (unblock) for reading data from userspace */
+	/* and ignore first interrupt generated in module init */
+	mpuirq_dev_data.data_ready = 1;
+
+	do_gettimeofday(&irqtime);
+	mpuirq_data.irqtime = (((long long)irqtime.tv_sec) << 32);
+	mpuirq_data.irqtime += irqtime.tv_usec;
+	mpuirq_data.data_type = MPUIRQ_DATA_TYPE_MPU_IRQ;
+	mpuirq_data.data = 0;
+
+	wake_up_interruptible(&mpuirq_wait);
+
+	return IRQ_HANDLED;
+
+}
+
+/* define which file operations are supported */
+const struct file_operations mpuirq_fops = {
+	.owner = THIS_MODULE,
+	.read = mpuirq_read,
+	.poll = mpuirq_poll,
+
+	.unlocked_ioctl = mpuirq_ioctl,
+	.open = mpuirq_open,
+	.release = mpuirq_release,
+};
+
+static struct miscdevice mpuirq_device = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = MPUIRQ_NAME,
+	.fops = &mpuirq_fops,
+};
+
+int mpuirq_init(struct i2c_client *mpu_client, struct mldl_cfg *mldl_cfg)
+{
+
+	int res;
+
+	mpuirq_dev_data.mpu_client = mpu_client;
+
+	dev_info(&mpu_client->adapter->dev,
+		 "Module Param interface = %s\n", interface);
+
+	mpuirq_dev_data.irq = mpu_client->irq;
+	mpuirq_dev_data.pid = 0;
+	mpuirq_dev_data.accel_divider = -1;
+	mpuirq_dev_data.data_ready = 0;
+	mpuirq_dev_data.timeout = 0;
+	mpuirq_dev_data.dev = &mpuirq_device;
+
+	if (mpuirq_dev_data.irq) {
+		unsigned long flags;
+		if (BIT_ACTL_LOW == ((mldl_cfg->pdata->int_config) & BIT_ACTL))
+			flags = IRQF_TRIGGER_FALLING;
+		else
+			flags = IRQF_TRIGGER_RISING;
+
+		res =
+		    request_irq(mpuirq_dev_data.irq, mpuirq_handler, flags,
+				interface, &mpuirq_dev_data.irq);
+		if (res) {
+			dev_err(&mpu_client->adapter->dev,
+				"myirqtest: cannot register IRQ %d\n",
+				mpuirq_dev_data.irq);
+		} else {
+			res = misc_register(&mpuirq_device);
+			if (res < 0) {
+				dev_err(&mpu_client->adapter->dev,
+					"misc_register returned %d\n", res);
+				free_irq(mpuirq_dev_data.irq,
+					 &mpuirq_dev_data.irq);
+			}
+		}
+
+	} else {
+		res = 0;
+	}
+
+	return res;
+}
+
+void mpuirq_exit(void)
+{
+	if (mpuirq_dev_data.irq > 0)
+		free_irq(mpuirq_dev_data.irq, &mpuirq_dev_data.irq);
+
+	dev_info(mpuirq_device.this_device, "Unregistering %s\n", MPUIRQ_NAME);
+	misc_deregister(&mpuirq_device);
+
+	return;
+}
+
+module_param(interface, charp, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(interface, "The Interface name");
diff --git a/drivers/misc/inv_mpu/mpuirq.h b/drivers/misc/inv_mpu/mpuirq.h
new file mode 100644
index 0000000..3348071
--- /dev/null
+++ b/drivers/misc/inv_mpu/mpuirq.h
@@ -0,0 +1,36 @@
+/*
+	$License:
+	Copyright (C) 2011 InvenSense Corporation, All Rights Reserved.
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program.  If not, see <http://www.gnu.org/licenses/>.
+	$
+ */
+
+#ifndef __MPUIRQ__
+#define __MPUIRQ__
+
+#include <linux/i2c-dev.h>
+#include <linux/time.h>
+#include <linux/ioctl.h>
+#include "mldl_cfg.h"
+
+#define MPUIRQ_SET_TIMEOUT           _IOW(MPU_IOCTL, 0x40, unsigned long)
+#define MPUIRQ_GET_INTERRUPT_CNT     _IOR(MPU_IOCTL, 0x41, unsigned long)
+#define MPUIRQ_GET_IRQ_TIME          _IOR(MPU_IOCTL, 0x42, struct timeval)
+#define MPUIRQ_SET_FREQUENCY_DIVIDER _IOW(MPU_IOCTL, 0x43, unsigned long)
+
+void mpuirq_exit(void);
+int mpuirq_init(struct i2c_client *mpu_client, struct mldl_cfg *mldl_cfg);
+
+#endif
diff --git a/drivers/misc/inv_mpu/slaveirq.c b/drivers/misc/inv_mpu/slaveirq.c
new file mode 100644
index 0000000..9044d06
--- /dev/null
+++ b/drivers/misc/inv_mpu/slaveirq.c
@@ -0,0 +1,265 @@
+/*
+	$License:
+	Copyright (C) 2011 InvenSense Corporation, All Rights Reserved.
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program.  If not, see <http://www.gnu.org/licenses/>.
+	$
+ */
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/stat.h>
+#include <linux/irq.h>
+#include <linux/signal.h>
+#include <linux/miscdevice.h>
+#include <linux/i2c.h>
+#include <linux/i2c-dev.h>
+#include <linux/poll.h>
+
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+#include <linux/wait.h>
+#include <linux/slab.h>
+
+#include <linux/mpu.h>
+#include "slaveirq.h"
+#include "mldl_cfg.h"
+
+/* function which gets slave data and sends it to SLAVE */
+
+struct slaveirq_dev_data {
+	struct miscdevice dev;
+	struct i2c_client *slave_client;
+	struct mpuirq_data data;
+	wait_queue_head_t slaveirq_wait;
+	int irq;
+	int pid;
+	int data_ready;
+	int timeout;
+};
+
+/* The following depends on patch fa1f68db6ca7ebb6fc4487ac215bffba06c01c28
+ * drivers: misc: pass miscdevice pointer via file private data
+ */
+static int slaveirq_open(struct inode *inode, struct file *file)
+{
+	/* Device node is availabe in the file->private_data, this is
+	 * exactly what we want so we leave it there */
+	struct slaveirq_dev_data *data =
+	    container_of(file->private_data, struct slaveirq_dev_data, dev);
+
+	dev_dbg(data->dev.this_device,
+		"%s current->pid %d\n", __func__, current->pid);
+	data->pid = current->pid;
+	return 0;
+}
+
+static int slaveirq_release(struct inode *inode, struct file *file)
+{
+	struct slaveirq_dev_data *data =
+	    container_of(file->private_data, struct slaveirq_dev_data, dev);
+	dev_dbg(data->dev.this_device, "slaveirq_release\n");
+	return 0;
+}
+
+/* read function called when from /dev/slaveirq is read */
+static ssize_t slaveirq_read(struct file *file,
+			     char *buf, size_t count, loff_t *ppos)
+{
+	int len, err;
+	struct slaveirq_dev_data *data =
+	    container_of(file->private_data, struct slaveirq_dev_data, dev);
+
+	if (!data->data_ready && data->timeout &&
+	    !(file->f_flags & O_NONBLOCK)) {
+		wait_event_interruptible_timeout(data->slaveirq_wait,
+						 data->data_ready,
+						 data->timeout);
+	}
+
+	if (data->data_ready && NULL != buf && count >= sizeof(data->data)) {
+		err = copy_to_user(buf, &data->data, sizeof(data->data));
+		data->data.data_type = 0;
+	} else {
+		return 0;
+	}
+	if (err != 0) {
+		dev_err(data->dev.this_device,
+			"Copy to user returned %d\n", err);
+		return -EFAULT;
+	}
+	data->data_ready = 0;
+	len = sizeof(data->data);
+	return len;
+}
+
+static unsigned int slaveirq_poll(struct file *file,
+				  struct poll_table_struct *poll)
+{
+	int mask = 0;
+	struct slaveirq_dev_data *data =
+	    container_of(file->private_data, struct slaveirq_dev_data, dev);
+
+	poll_wait(file, &data->slaveirq_wait, poll);
+	if (data->data_ready)
+		mask |= POLLIN | POLLRDNORM;
+	return mask;
+}
+
+/* ioctl - I/O control */
+static long slaveirq_ioctl(struct file *file,
+			   unsigned int cmd, unsigned long arg)
+{
+	int retval = 0;
+	int tmp;
+	struct slaveirq_dev_data *data =
+	    container_of(file->private_data, struct slaveirq_dev_data, dev);
+
+	switch (cmd) {
+	case SLAVEIRQ_SET_TIMEOUT:
+		data->timeout = arg;
+		break;
+
+	case SLAVEIRQ_GET_INTERRUPT_CNT:
+		tmp = data->data.interruptcount - 1;
+		if (data->data.interruptcount > 1)
+			data->data.interruptcount = 1;
+
+		if (copy_to_user((int *)arg, &tmp, sizeof(int)))
+			return -EFAULT;
+		break;
+	case SLAVEIRQ_GET_IRQ_TIME:
+		if (copy_to_user((int *)arg, &data->data.irqtime,
+				 sizeof(data->data.irqtime)))
+			return -EFAULT;
+		data->data.irqtime = 0;
+		break;
+	default:
+		retval = -EINVAL;
+	}
+	return retval;
+}
+
+static irqreturn_t slaveirq_handler(int irq, void *dev_id)
+{
+	struct slaveirq_dev_data *data = (struct slaveirq_dev_data *)dev_id;
+	static int mycount;
+	struct timeval irqtime;
+	mycount++;
+
+	data->data.interruptcount++;
+
+	/* wake up (unblock) for reading data from userspace */
+	data->data_ready = 1;
+
+	do_gettimeofday(&irqtime);
+	data->data.irqtime = (((long long)irqtime.tv_sec) << 32);
+	data->data.irqtime += irqtime.tv_usec;
+	data->data.data_type |= 1;
+
+	wake_up_interruptible(&data->slaveirq_wait);
+
+	return IRQ_HANDLED;
+
+}
+
+/* define which file operations are supported */
+static const struct file_operations slaveirq_fops = {
+	.owner = THIS_MODULE,
+	.read = slaveirq_read,
+	.poll = slaveirq_poll,
+
+#if HAVE_COMPAT_IOCTL
+	.compat_ioctl = slaveirq_ioctl,
+#endif
+#if HAVE_UNLOCKED_IOCTL
+	.unlocked_ioctl = slaveirq_ioctl,
+#endif
+	.open = slaveirq_open,
+	.release = slaveirq_release,
+};
+
+int slaveirq_init(struct i2c_adapter *slave_adapter,
+		  struct ext_slave_platform_data *pdata, char *name)
+{
+
+	int res;
+	struct slaveirq_dev_data *data;
+
+	if (!pdata->irq)
+		return -EINVAL;
+
+	pdata->irq_data = kzalloc(sizeof(*data), GFP_KERNEL);
+	data = (struct slaveirq_dev_data *)pdata->irq_data;
+	if (!data)
+		return -ENOMEM;
+
+	data->dev.minor = MISC_DYNAMIC_MINOR;
+	data->dev.name = name;
+	data->dev.fops = &slaveirq_fops;
+	data->irq = pdata->irq;
+	data->pid = 0;
+	data->data_ready = 0;
+	data->timeout = 0;
+
+	init_waitqueue_head(&data->slaveirq_wait);
+
+	res = request_irq(data->irq, slaveirq_handler, IRQF_TRIGGER_RISING,
+			  data->dev.name, data);
+
+	if (res) {
+		dev_err(&slave_adapter->dev,
+			"myirqtest: cannot register IRQ %d\n", data->irq);
+		goto out_request_irq;
+	}
+
+	res = misc_register(&data->dev);
+	if (res < 0) {
+		dev_err(&slave_adapter->dev,
+			"misc_register returned %d\n", res);
+		goto out_misc_register;
+	}
+
+	return res;
+
+out_misc_register:
+	free_irq(data->irq, data);
+out_request_irq:
+	kfree(pdata->irq_data);
+	pdata->irq_data = NULL;
+
+	return res;
+}
+
+void slaveirq_exit(struct ext_slave_platform_data *pdata)
+{
+	struct slaveirq_dev_data *data = pdata->irq_data;
+
+	if (!pdata->irq_data || data->irq <= 0)
+		return;
+
+	dev_info(data->dev.this_device, "Unregistering %s\n", data->dev.name);
+
+	free_irq(data->irq, data);
+	misc_deregister(&data->dev);
+	kfree(pdata->irq_data);
+	pdata->irq_data = NULL;
+}
diff --git a/drivers/misc/inv_mpu/slaveirq.h b/drivers/misc/inv_mpu/slaveirq.h
new file mode 100644
index 0000000..fe05b6f
--- /dev/null
+++ b/drivers/misc/inv_mpu/slaveirq.h
@@ -0,0 +1,38 @@
+/*
+	$License:
+	Copyright (C) 2011 InvenSense Corporation, All Rights Reserved.
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program.  If not, see <http://www.gnu.org/licenses/>.
+	$
+ */
+
+#ifndef __SLAVEIRQ__
+#define __SLAVEIRQ__
+
+#include <linux/i2c-dev.h>
+
+#include <linux/mpu.h>
+#include "mpuirq.h"
+
+#define SLAVEIRQ_SET_TIMEOUT           _IOW(MPU_IOCTL, 0x50, unsigned long)
+#define SLAVEIRQ_GET_INTERRUPT_CNT     _IOR(MPU_IOCTL, 0x51, unsigned long)
+#define SLAVEIRQ_GET_IRQ_TIME          _IOR(MPU_IOCTL, 0x52, unsigned long)
+
+
+void slaveirq_exit(struct ext_slave_platform_data *pdata);
+int slaveirq_init(struct i2c_adapter *slave_adapter,
+		  struct ext_slave_platform_data *pdata, char *name);
+
+
+#endif
-- 
1.7.4.1

