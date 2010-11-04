Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab0KDT2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 15:28:11 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42120 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab0KDT2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 15:28:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pEkF14WRMckht87k4zYM424UqfpkawgKy/MEbZvQOitay4I4uKj9pExuoDTRIywvzM
         h8/fCbt8UneiCv6pf0TmBHaDBDFg4SxaQU5vIPXs/d/VBRMo2vzHCmelkm1bkzb8tG6y
         BwkbtVKE1PThdyAmuiTIBIUn3WMFIw89SfEzY=
Date: Thu, 4 Nov 2010 20:28:01 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        John Stultz <johnstul@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH RFC 1/8] Introduce dynamic clock devices
Message-ID: <031a33e771a3c8bd95ed2c88ede4820b7675ceca.1288897198.git.richard.cochran@omicron.at>
References: <cover.1288897198.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1288897198.git.richard.cochran@omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for adding and removing clock devices. The clock
lifetime cycle is patterned after usb devices. Each clock is represented
by a standard character device. In addition, the driver may optionally
implemented custom character device operations.

The clock devices do not yet do anything useful. This patch merely
provides some needed infrastructure.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
---
 include/linux/clockdevice.h |   97 +++++++++++++++++++++++++++
 kernel/time/Makefile        |    3 +-
 kernel/time/clockdevice.c   |  155 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 254 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/clockdevice.h
 create mode 100644 kernel/time/clockdevice.c

diff --git a/include/linux/clockdevice.h b/include/linux/clockdevice.h
new file mode 100644
index 0000000..a8f9359
--- /dev/null
+++ b/include/linux/clockdevice.h
@@ -0,0 +1,97 @@
+/*
+ * clockdevice.h - support for dynmanic clock devices
+ *
+ * Copyright (C) 2010 OMICRON electronics GmbH
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#ifndef _LINUX_CLOCKDEVICE_H_
+#define _LINUX_CLOCKDEVICE_H_
+
+#include <linux/fs.h>
+#include <linux/posix-timers.h>
+
+/**
+ * struct clock_device_operations - functional interface to the clock
+ * @owner: The clock driver should set to THIS_MODULE.
+ * @clock_gettime:  Read the current time
+ * @clock_getres:   Get the clock resolution
+ * @clock_settime:  Set the current time value
+ * @timer_create:   Create a new timer
+ * @timer_delete:   Remove a previously created timer
+ * @timer_gettime:  Get remaining time and interval of a timer
+ * @timer_setttime: Set a timer's initial expiration and interval
+ */
+struct clock_device_operations {
+	struct module *owner;
+	int  (*clock_gettime)(void *priv, struct timespec *ts);
+	int  (*clock_getres) (void *priv, struct timespec *ts);
+	int  (*clock_settime)(void *priv, struct timespec *ts);
+	int  (*timer_create) (void *priv, struct k_itimer *kit);
+	int  (*timer_delete) (void *priv, struct k_itimer *kit);
+	void (*timer_gettime)(void *priv, struct k_itimer *kit,
+			      struct itimerspec *tsp);
+	int  (*timer_settime)(void *priv, struct k_itimer *kit, int flags,
+			      struct itimerspec *tsp, struct itimerspec *old);
+};
+
+/**
+ * struct clock_device - an opaque type
+ */
+struct clock_device;
+
+/**
+ * create_clock_device() - register a new clock
+ * @cops:  Pointer to the clock's interface
+ * @fops:  The clock driver's custom character device functions.
+ *         Drivers without custom methods may pass NULL.  The file
+ *         operation callbacks should access private data using
+ *         clock_device_private(), see below.
+ * @devid: Allocated device id
+ * @priv:  Private data passed back to the driver via the interface functions
+ *
+ * A clock driver calls this function to register itself with the
+ * clock device subsystem. The pointers 'cops' and 'fops' must point
+ * to persistent data, so the caller should pass a static global.
+ *
+ * Returns a pointer to a new clock device, or PTR_ERR on error.
+ */
+struct clock_device *create_clock_device(struct clock_device_operations *cops,
+					 struct file_operations *fops,
+					 dev_t devid, void *priv);
+
+/**
+ * destroy_clock_device() - unregister a clock
+ * @clk:    Pointer obtained via create_clock_device()
+ *
+ * A clock driver calls this function to remove itself from the clock
+ * device subsystem. The clock_device itself will remain (in an
+ * inactive state) until its reference count drops to zero, at which
+ * point it will be deallocated.
+ */
+void destroy_clock_device(struct clock_device *clk);
+
+/**
+ * clock_device_private() - obtain clock driver's private data
+ *
+ * Character device file operations are first handled by the clock
+ * device layer, then passed on to the driver by calling its file
+ * operations functions. The clock device layer already uses
+ * fp->private_data, but drivers may use the following function to
+ * access their private data.
+ */
+void *clock_device_private(struct file *fp);
+
+#endif
diff --git a/kernel/time/Makefile b/kernel/time/Makefile
index ee26662..a573dd3 100644
--- a/kernel/time/Makefile
+++ b/kernel/time/Makefile
@@ -1,4 +1,5 @@
-obj-y += timekeeping.o ntp.o clocksource.o jiffies.o timer_list.o timecompare.o timeconv.o
+obj-y += timekeeping.o ntp.o clocksource.o jiffies.o timer_list.o \
+timecompare.o timeconv.o clockdevice.o
 
 obj-$(CONFIG_GENERIC_CLOCKEVENTS_BUILD)		+= clockevents.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS)		+= tick-common.o
diff --git a/kernel/time/clockdevice.c b/kernel/time/clockdevice.c
new file mode 100644
index 0000000..323b57b
--- /dev/null
+++ b/kernel/time/clockdevice.c
@@ -0,0 +1,155 @@
+/*
+ * clockdevice.c - support for dynmanic clock devices
+ *
+ * Copyright (C) 2010 OMICRON electronics GmbH
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/cdev.h>
+#include <linux/clockdevice.h>
+#include <linux/device.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+
+#define MAX_CLKDEV BITS_PER_LONG
+static DECLARE_BITMAP(clocks_map, MAX_CLKDEV);
+static DEFINE_MUTEX(clocks_mux); /* protects 'clocks_map' */
+
+struct clock_device {
+	struct file_operations fops;
+	struct file_operations *driver_fops;
+	struct clock_device_operations *ops;
+	struct cdev cdev;
+	struct kref kref;
+	struct mutex mux;
+	void *priv;
+	int index;
+	bool zombie;
+};
+
+static void delete_clock(struct kref *kref);
+
+static int clock_device_open(struct inode *inode, struct file *fp)
+{
+	struct clock_device *clk =
+		container_of(inode->i_cdev, struct clock_device, cdev);
+
+	kref_get(&clk->kref);
+	fp->private_data = clk;
+
+	if (clk->driver_fops && clk->driver_fops->open)
+		return clk->driver_fops->open(inode, fp);
+	else
+		return 0;
+}
+
+static int clock_device_release(struct inode *inode, struct file *fp)
+{
+	struct clock_device *clk = fp->private_data;
+	int err = 0;
+
+	if (clk->driver_fops && clk->driver_fops->release)
+		err = clk->driver_fops->release(inode, fp);
+
+	kref_put(&clk->kref, delete_clock);
+
+	return err;
+}
+
+struct clock_device *create_clock_device(struct clock_device_operations *cops,
+					 struct file_operations *fops,
+					 dev_t devid,
+					 void *priv)
+{
+	struct clock_device *clk;
+	int err;
+
+	mutex_lock(&clocks_mux);
+
+	err = -ENOMEM;
+	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
+	if (!clk)
+		goto no_memory;
+
+	err = -EBUSY;
+	clk->index = find_first_zero_bit(clocks_map, MAX_CLKDEV);
+	if (clk->index < MAX_CLKDEV)
+		set_bit(clk->index, clocks_map);
+	else
+		goto no_index;
+
+	clk->ops = cops;
+	clk->priv = priv;
+	kref_init(&clk->kref);
+	mutex_init(&clk->mux);
+
+	if (fops) {
+		clk->driver_fops = fops;
+		clk->fops = *fops;
+	}
+	clk->fops.open = clock_device_open;
+	clk->fops.release = clock_device_release;
+
+	cdev_init(&clk->cdev, &clk->fops);
+	clk->cdev.owner = clk->ops->owner;
+	err = cdev_add(&clk->cdev, devid, 1);
+	if (err)
+		goto no_cdev;
+
+	mutex_unlock(&clocks_mux);
+	return clk;
+
+no_cdev:
+	mutex_destroy(&clk->mux);
+	clear_bit(clk->index, clocks_map);
+no_index:
+	kfree(clk);
+no_memory:
+	mutex_unlock(&clocks_mux);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(create_clock_device);
+
+static void delete_clock(struct kref *kref)
+{
+	struct clock_device *clk =
+		container_of(kref, struct clock_device, kref);
+
+	mutex_lock(&clocks_mux);
+	clear_bit(clk->index, clocks_map);
+	mutex_unlock(&clocks_mux);
+
+	mutex_destroy(&clk->mux);
+	kfree(clk);
+}
+
+void destroy_clock_device(struct clock_device *clk)
+{
+	cdev_del(&clk->cdev);
+
+	mutex_lock(&clk->mux);
+	clk->zombie = true;
+	mutex_unlock(&clk->mux);
+
+	kref_put(&clk->kref, delete_clock);
+}
+EXPORT_SYMBOL_GPL(destroy_clock_device);
+
+void *clock_device_private(struct file *fp)
+{
+	struct clock_device *clk = fp->private_data;
+	return clk->priv;
+}
+EXPORT_SYMBOL_GPL(clock_device_private);
-- 
1.7.0.4

