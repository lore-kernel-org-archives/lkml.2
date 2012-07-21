Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab2GUENy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 00:13:54 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59715 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab2GUENw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 00:13:52 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVNWOcrR9tYhU1wVUSJ_DJ8x+SCk993Sn9dYDe2kzJBDuQ@mail.gmail.com>
References: <CACVXFVNWOcrR9tYhU1wVUSJ_DJ8x+SCk993Sn9dYDe2kzJBDuQ@mail.gmail.com>
Date: Sat, 21 Jul 2012 12:13:51 +0800
Message-ID: <CACVXFVM0bWOzzPyL7ja2c4Uj56eEjA+-Qm744FBKxWP9j3MOrA@mail.gmail.com>
Subject: Re: [RFC] firmware load: defer request_firmware during early boot and resume
From: Ming Lei <tom.leiming@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Garrett <mjg@redhat.com>, Jack Stone <jwjstone@fastmail.fm>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Ming Lei <ming.lei@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC guys who discussed the problem in the below link in Jan. :

      http://marc.info/?t=132528956000002&r=10&w=2

On Fri, Jul 20, 2012 at 8:33 PM, Ming Lei <tom.leiming@gmail.com> wrote:
> The RFC patch is just for discussing if the idea of deferring
> request_firmware is doable for addressing the issue of
> request_firmware in resume path, which is caused by driver
> unbind/rebind during resume.
>
> At least usb bus is involved in such things, one driver may be
> unbound and rebound in resume path at several situations, and
> request_firmware is often called inside probe().
>
> Also the idea should be helpful for other hotplug buses too,
> at least there was the similar problem report on pcmcia bus.

Looks it works well in my two test cases: one is to call request_firmware
in early boot(initcall), another one is to call request_firmware in probe()
of resume path(caused by unbind & rebind).  And without the patch, both
two request_firmware return failure and can't complete the loading.

V1:
        only defer handling the requests called from probe()

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 6cd2c6c..fb02eff 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -123,7 +123,7 @@ static bool driver_deferred_probe_enable = false;
  * list and schedules the deferred probe workqueue to process them.  It
  * should be called anytime a driver is successfully bound to a device.
  */
-static void driver_deferred_probe_trigger(void)
+void driver_deferred_probe_trigger(void)
 {
 	if (!driver_deferred_probe_enable)
 		return;
@@ -144,6 +144,7 @@ static void driver_deferred_probe_trigger(void)
 	 */
 	queue_work(deferred_wq, &deferred_probe_work);
 }
+EXPORT_SYMBOL_GPL(driver_deferred_probe_trigger);

 /**
  * deferred_probe_initcall() - Enable probing of deferred devices
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 5401814..1b13536 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -21,6 +21,7 @@
 #include <linux/firmware.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include "base.h"

 #define to_dev(obj) container_of(obj, struct device, kobj)

@@ -593,6 +594,11 @@ request_firmware(const struct firmware
**firmware_p, const char *name,
 	if (IS_ERR_OR_NULL(fw_priv))
 		return PTR_RET(fw_priv);

+	/* only defer handling the requests called from probe() */
+	if (!klist_node_attached(&device->p->knode_driver) &&
+			system_state != SYSTEM_RUNNING)
+		return -EPROBE_DEFER;
+
 	ret = usermodehelper_read_trylock();
 	if (WARN_ON(ret)) {
 		dev_err(device, "firmware: %s will not be loaded\n", name);
diff --git a/include/linux/device.h b/include/linux/device.h
index d0e4d99..a63d3171 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -244,7 +244,7 @@ extern struct device_driver *driver_find(const char *name,
 					 struct bus_type *bus);
 extern int driver_probe_done(void);
 extern void wait_for_device_probe(void);
-
+extern void driver_deferred_probe_trigger(void);

 /* sysfs interface for exporting driver attributes */

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index e07f5e0..c8d74c6 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -378,6 +378,7 @@ extern enum system_states {
 	SYSTEM_POWER_OFF,
 	SYSTEM_RESTART,
 	SYSTEM_SUSPEND_DISK,
+	SYSTEM_SUSPEND,
 } system_state;

 #define TAINT_PROPRIETARY_MODULE	0
diff --git a/init/main.c b/init/main.c
index e60679d..02fc1c2 100644
--- a/init/main.c
+++ b/init/main.c
@@ -809,6 +809,9 @@ static noinline int init_post(void)
 	current->signal->flags |= SIGNAL_UNKILLABLE;
 	flush_delayed_fput();

+	/* defer handling request_firmware in probe of initcall path */
+	driver_deferred_probe_trigger();
+
 	if (ramdisk_execute_command) {
 		run_init_process(ramdisk_execute_command);
 		printk(KERN_WARNING "Failed to execute %s\n",
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 1da39ea..61c723f 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -224,6 +224,9 @@ int suspend_devices_and_enter(suspend_state_t state)
 		goto Recover_platform;
 	}
 	suspend_test_finish("suspend devices");
+
+	system_state = SYSTEM_SUSPEND;
+
 	if (suspend_test(TEST_DEVICES))
 		goto Recover_platform;

@@ -301,6 +304,12 @@ static int enter_state(suspend_state_t state)
  Finish:
 	pr_debug("PM: Finishing wakeup.\n");
 	suspend_finish();
+
+	system_state = SYSTEM_RUNNING;
+
+	/* defer handling request_firmware in probe of resume path */
+	driver_deferred_probe_trigger();
+
  Unlock:
 	mutex_unlock(&pm_mutex);
 	return error;



Thanks,
-- 
Ming Lei
