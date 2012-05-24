Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab2EXBjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 21:39:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33164 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab2EXBju convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 21:39:50 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1205231104540.1566-100000@iolanthe.rowland.org>
References: <CACVXFVOUmFvEoADMQoc1S4vcW80v1efNvX=eHJheQTZzkcV9gA@mail.gmail.com>
	<Pine.LNX.4.44L0.1205231104540.1566-100000@iolanthe.rowland.org>
Date: Thu, 24 May 2012 09:39:46 +0800
Message-ID: <CACVXFVMqWyT78h53WnLuMYuhfFK-sbGMkS+T8SjWad6kQVFGTw@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_Race_condition_between_driver=5Fprobe=5Fdevice_and_d?=
	=?UTF-8?Q?evice=5Fshutdown=E2=80=8F?=
From: Ming Lei <ming.lei@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Linux PM List <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 11:06 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 23 May 2012, Ming Lei wrote:
>> The .shutdown callback pointer is got from device->driver, which is
>> changed in probe and release path. Also runtime PM thing has been
>> involved into shutting down recently, so looks not only hardware parts
>> are involved now.
>
> This is a tricky question.  Overall I think you're probably right.
>
> It's certainly true that holding the device lock across the shutdown
> callback is the easiest and most reliable way to prevent these races.

But holding device lock across .shutdown is very inefficient because
most of devices' driver have not shutdown callback, so I think it is better
to fix the race by prevent driver core from probing or releasing once
shutdown is started.

How about the below patch?

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 346be8b..fc70930 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1803,6 +1803,18 @@ void device_shutdown(void)
 {
 	struct device *dev;

+	/*wait for completing of device probing and releasing*/
+	printk("%s: wait for completing of devices' probing and"
+			"releasing...");
+
+	/*
+	 * order between writing system_state and read probe/release
+	 * counter.
+	 */
+	smp_mb();
+	wait_for_device_probe_release();
+	printk("OK\n");
+
 	spin_lock(&devices_kset->list_lock);
 	/*
 	 * Walk the devices list backward, shutting down each in turn.
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 1b1cbb5..8328383 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -245,6 +245,7 @@ int device_bind_driver(struct device *dev)
 EXPORT_SYMBOL_GPL(device_bind_driver);

 static atomic_t probe_count = ATOMIC_INIT(0);
+static atomic_t release_count = ATOMIC_INIT(0);
 static DECLARE_WAIT_QUEUE_HEAD(probe_waitqueue);

 static int really_probe(struct device *dev, struct device_driver *drv)
@@ -252,6 +253,10 @@ static int really_probe(struct device *dev,
struct device_driver *drv)
 	int ret = 0;

 	atomic_inc(&probe_count);
+	smp_mb();
+	if (system_in_shutdown())
+		goto done;
+
 	pr_debug("bus: '%s': %s: probing driver %s with device %s\n",
 		 drv->bus->name, __func__, drv->name, dev_name(dev));
 	WARN_ON(!list_empty(&dev->devres_head));
@@ -336,6 +341,19 @@ void wait_for_device_probe(void)
 EXPORT_SYMBOL_GPL(wait_for_device_probe);

 /**
+ * wait_for_device_probe_release
+ * Wait for device probing and releasing to be completed.
+ */
+void wait_for_device_probe_release(void)
+{
+	/* wait for complete devices' probing and releasing*/
+	wait_event(probe_waitqueue, atomic_read(&probe_count) == 0 &&
+			atomic_read(&release_count) == 0);
+	async_synchronize_full();
+}
+EXPORT_SYMBOL_GPL(wait_for_device_probe_release);
+
+/**
  * driver_probe_device - attempt to bind device & driver together
  * @drv: driver to bind a device to
  * @dev: device to try to bind to the driver
@@ -470,6 +488,11 @@ static void __device_release_driver(struct device *dev)

 	drv = dev->driver;
 	if (drv) {
+		atomic_inc(&release_count);
+		smp_mb();
+		if (system_in_shutdown())
+			goto exit;
+
 		pm_runtime_get_sync(dev);

 		driver_sysfs_remove(dev);
@@ -492,7 +515,9 @@ static void __device_release_driver(struct device *dev)
 			blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 						     BUS_NOTIFY_UNBOUND_DRIVER,
 						     dev);
-
+exit:
+		atomic_dec(&release_count);
+		wake_up(&probe_waitqueue);
 	}
 }

diff --git a/include/linux/device.h b/include/linux/device.h
index 161d962..3fdf782 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -243,6 +243,7 @@ extern struct device_driver *driver_find(const char *name,
 					 struct bus_type *bus);
 extern int driver_probe_done(void);
 extern void wait_for_device_probe(void);
+extern void wait_for_device_probe_release(void);


 /* sysfs interface for exporting driver attributes */
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 64bdeeb8..3cf4f36 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -378,6 +378,12 @@ extern enum system_states {
 	SYSTEM_SUSPEND_DISK,
 } system_state;

+static inline int system_in_shutdown(void)
+{
+	return (system_state >= SYSTEM_HALT) &&
+		(system_state <= SYSTEM_RESTART);
+}
+
 #define TAINT_PROPRIETARY_MODULE	0
 #define TAINT_FORCED_MODULE		1
 #define TAINT_UNSAFE_SMP		2



Thanks,
--
Ming Lei
