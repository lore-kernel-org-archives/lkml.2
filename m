Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab2ICAEZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 20:04:25 -0400
Received: from caiajhbdccah.dreamhost.com ([208.97.132.207]:44283 "EHLO
	homiemail-a62.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755333Ab2ICADt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 20:03:49 -0400
Subject: [PATCH 5/5] acpi: events: remove procfs interface
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Len Brown <lenb@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Mon, 03 Sep 2012 02:03:34 +0200
Message-ID: <1346630614.3170.33.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The /proc/acpi/event interface has been replaced by events through the
input layer and netlink, and scheduled for removal over four years ago.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 Documentation/feature-removal-schedule.txt |    8 --
 drivers/acpi/Kconfig                       |   18 -----
 drivers/acpi/ac.c                          |    1 -
 drivers/acpi/acpi_pad.c                    |    1 -
 drivers/acpi/battery.c                     |    2 -
 drivers/acpi/bus.c                         |   98 -------------------------
 drivers/acpi/button.c                      |    2 -
 drivers/acpi/event.c                       |  107 +---------------------------
 drivers/acpi/processor_driver.c            |    4 -
 drivers/acpi/sbs.c                         |   16 +----
 drivers/acpi/thermal.c                     |    3 -
 drivers/acpi/video.c                       |   10 ---
 include/acpi/acpi_bus.h                    |    8 --
 13 files changed, 4 insertions(+), 274 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index db385ee..3021e77 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -181,14 +181,6 @@ Who:	Zhang Rui <rui.zhang@intel.com>
 
 ---------------------------
 
-What:	/proc/acpi/event
-When:	February 2008
-Why:	/proc/acpi/event has been replaced by events via the input layer
-	and netlink since 2.6.23.
-Who:	Len Brown <len.brown@intel.com>
-
----------------------------
-
 What:	i386/x86_64 bzImage symlinks
 When:	April 2010
 
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 6aa0cc8..37110d1 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -74,24 +74,6 @@ config ACPI_EC_DEBUGFS
 	  Thus this option is a debug option that helps to write ACPI drivers
 	  and can be used to identify ACPI code or EC firmware bugs.
 
-config ACPI_PROC_EVENT
-	bool "Deprecated /proc/acpi/event support"
-	depends on PROC_FS
-	default y
-	help
-	  A user-space daemon, acpid, typically reads /proc/acpi/event
-	  and handles all ACPI-generated events.
-
-	  These events are now delivered to user-space either
-	  via the input layer or as netlink events.
-
-	  This build option enables the old code for legacy
-	  user-space implementation.  After some time, this will
-	  be moved under CONFIG_ACPI_PROCFS, and then deleted.
-
-	  Say Y here to retain the old behaviour.  Say N if your
-	  user-space is newer than kernel 2.6.23 (September 2007).
-
 config ACPI_AC
 	tristate "AC Adapter"
 	depends on X86
diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index 7e00303..af56697 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -156,7 +156,6 @@ static void acpi_ac_notify(struct acpi_device *device, u32 event)
 	case ACPI_NOTIFY_BUS_CHECK:
 	case ACPI_NOTIFY_DEVICE_CHECK:
 		acpi_ac_get_state(ac);
-		acpi_bus_generate_proc_event(device, event, (u32) ac->state);
 		acpi_bus_generate_netlink_event(device->pnp.device_class,
 						  dev_name(&device->dev), event,
 						  (u32) ac->state);
diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index af4aad6..fe1085d 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -452,7 +452,6 @@ static void acpi_pad_notify(acpi_handle handle, u32 event,
 	switch (event) {
 	case ACPI_PROCESSOR_AGGREGATOR_NOTIFY:
 		acpi_pad_handle_notify(handle);
-		acpi_bus_generate_proc_event(device, event, 0);
 		acpi_bus_generate_netlink_event(device->pnp.device_class,
 			dev_name(&device->dev), event, 0);
 		break;
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index bd364a4..38a37bd 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -657,8 +657,6 @@ static void acpi_battery_notify(struct acpi_device *device, u32 event)
 	if (event == ACPI_BATTERY_NOTIFY_INFO)
 		acpi_battery_refresh(battery);
 	acpi_battery_update(battery);
-	acpi_bus_generate_proc_event(device, event,
-				     acpi_battery_present(battery));
 	acpi_bus_generate_netlink_event(device->pnp.device_class,
 					dev_name(&device->dev), event,
 					acpi_battery_present(battery));
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 9628652..63b903b 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -593,104 +593,6 @@ static void acpi_bus_osc_support(void)
 }
 
 /* --------------------------------------------------------------------------
-                                Event Management
-   -------------------------------------------------------------------------- */
-
-#ifdef CONFIG_ACPI_PROC_EVENT
-static DEFINE_SPINLOCK(acpi_bus_event_lock);
-
-LIST_HEAD(acpi_bus_event_list);
-DECLARE_WAIT_QUEUE_HEAD(acpi_bus_event_queue);
-
-extern int event_is_open;
-
-int acpi_bus_generate_proc_event4(const char *device_class, const char *bus_id, u8 type, int data)
-{
-	struct acpi_bus_event *event;
-	unsigned long flags = 0;
-
-	/* drop event on the floor if no one's listening */
-	if (!event_is_open)
-		return 0;
-
-	event = kzalloc(sizeof(struct acpi_bus_event), GFP_ATOMIC);
-	if (!event)
-		return -ENOMEM;
-
-	strcpy(event->device_class, device_class);
-	strcpy(event->bus_id, bus_id);
-	event->type = type;
-	event->data = data;
-
-	spin_lock_irqsave(&acpi_bus_event_lock, flags);
-	list_add_tail(&event->node, &acpi_bus_event_list);
-	spin_unlock_irqrestore(&acpi_bus_event_lock, flags);
-
-	wake_up_interruptible(&acpi_bus_event_queue);
-
-	return 0;
-
-}
-
-EXPORT_SYMBOL_GPL(acpi_bus_generate_proc_event4);
-
-int acpi_bus_generate_proc_event(struct acpi_device *device, u8 type, int data)
-{
-	if (!device)
-		return -EINVAL;
-	return acpi_bus_generate_proc_event4(device->pnp.device_class,
-					     device->pnp.bus_id, type, data);
-}
-
-EXPORT_SYMBOL(acpi_bus_generate_proc_event);
-
-int acpi_bus_receive_event(struct acpi_bus_event *event)
-{
-	unsigned long flags = 0;
-	struct acpi_bus_event *entry = NULL;
-
-	DECLARE_WAITQUEUE(wait, current);
-
-
-	if (!event)
-		return -EINVAL;
-
-	if (list_empty(&acpi_bus_event_list)) {
-
-		set_current_state(TASK_INTERRUPTIBLE);
-		add_wait_queue(&acpi_bus_event_queue, &wait);
-
-		if (list_empty(&acpi_bus_event_list))
-			schedule();
-
-		remove_wait_queue(&acpi_bus_event_queue, &wait);
-		set_current_state(TASK_RUNNING);
-
-		if (signal_pending(current))
-			return -ERESTARTSYS;
-	}
-
-	spin_lock_irqsave(&acpi_bus_event_lock, flags);
-	if (!list_empty(&acpi_bus_event_list)) {
-		entry = list_entry(acpi_bus_event_list.next,
-				   struct acpi_bus_event, node);
-		list_del(&entry->node);
-	}
-	spin_unlock_irqrestore(&acpi_bus_event_lock, flags);
-
-	if (!entry)
-		return -ENODEV;
-
-	memcpy(event, entry, sizeof(struct acpi_bus_event));
-
-	kfree(entry);
-
-	return 0;
-}
-
-#endif	/* CONFIG_ACPI_PROC_EVENT */
-
-/* --------------------------------------------------------------------------
                              Notification Handling
    -------------------------------------------------------------------------- */
 
diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 314a3b8..2bedd8d 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -302,8 +302,6 @@ static void acpi_button_notify(struct acpi_device *device, u32 event)
 
 			pm_wakeup_event(&device->dev, 0);
 		}
-
-		acpi_bus_generate_proc_event(device, event, ++button->pushed);
 		break;
 	default:
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
diff --git a/drivers/acpi/event.c b/drivers/acpi/event.c
index 1442737..04239ee 100644
--- a/drivers/acpi/event.c
+++ b/drivers/acpi/event.c
@@ -1,5 +1,5 @@
 /*
- * event.c - exporting ACPI events via procfs
+ * event.c - exporting ACPI events
  *
  *  Copyright (C) 2001, 2002 Andy Grover <andrew.grover@intel.com>
  *  Copyright (C) 2001, 2002 Paul Diefenbaugh <paul.s.diefenbaugh@intel.com>
@@ -21,100 +21,6 @@
 #define _COMPONENT		ACPI_SYSTEM_COMPONENT
 ACPI_MODULE_NAME("event");
 
-#ifdef CONFIG_ACPI_PROC_EVENT
-/* Global vars for handling event proc entry */
-static DEFINE_SPINLOCK(acpi_system_event_lock);
-int event_is_open = 0;
-extern struct list_head acpi_bus_event_list;
-extern wait_queue_head_t acpi_bus_event_queue;
-
-static int acpi_system_open_event(struct inode *inode, struct file *file)
-{
-	spin_lock_irq(&acpi_system_event_lock);
-
-	if (event_is_open)
-		goto out_busy;
-
-	event_is_open = 1;
-
-	spin_unlock_irq(&acpi_system_event_lock);
-	return 0;
-
-      out_busy:
-	spin_unlock_irq(&acpi_system_event_lock);
-	return -EBUSY;
-}
-
-static ssize_t
-acpi_system_read_event(struct file *file, char __user * buffer, size_t count,
-		       loff_t * ppos)
-{
-	int result = 0;
-	struct acpi_bus_event event;
-	static char str[ACPI_MAX_STRING];
-	static int chars_remaining = 0;
-	static char *ptr;
-
-	if (!chars_remaining) {
-		memset(&event, 0, sizeof(struct acpi_bus_event));
-
-		if ((file->f_flags & O_NONBLOCK)
-		    && (list_empty(&acpi_bus_event_list)))
-			return -EAGAIN;
-
-		result = acpi_bus_receive_event(&event);
-		if (result)
-			return result;
-
-		chars_remaining = sprintf(str, "%s %s %08x %08x\n",
-					  event.device_class ? event.
-					  device_class : "<unknown>",
-					  event.bus_id ? event.
-					  bus_id : "<unknown>", event.type,
-					  event.data);
-		ptr = str;
-	}
-
-	if (chars_remaining < count) {
-		count = chars_remaining;
-	}
-
-	if (copy_to_user(buffer, ptr, count))
-		return -EFAULT;
-
-	*ppos += count;
-	chars_remaining -= count;
-	ptr += count;
-
-	return count;
-}
-
-static int acpi_system_close_event(struct inode *inode, struct file *file)
-{
-	spin_lock_irq(&acpi_system_event_lock);
-	event_is_open = 0;
-	spin_unlock_irq(&acpi_system_event_lock);
-	return 0;
-}
-
-static unsigned int acpi_system_poll_event(struct file *file, poll_table * wait)
-{
-	poll_wait(file, &acpi_bus_event_queue, wait);
-	if (!list_empty(&acpi_bus_event_list))
-		return POLLIN | POLLRDNORM;
-	return 0;
-}
-
-static const struct file_operations acpi_system_event_ops = {
-	.owner = THIS_MODULE,
-	.open = acpi_system_open_event,
-	.read = acpi_system_read_event,
-	.release = acpi_system_close_event,
-	.poll = acpi_system_poll_event,
-	.llseek = default_llseek,
-};
-#endif	/* CONFIG_ACPI_PROC_EVENT */
-
 /* ACPI notifier chain */
 static BLOCKING_NOTIFIER_HEAD(acpi_chain_head);
 
@@ -280,9 +186,6 @@ static int acpi_event_genetlink_init(void)
 
 static int __init acpi_event_init(void)
 {
-#ifdef CONFIG_ACPI_PROC_EVENT
-	struct proc_dir_entry *entry;
-#endif
 	int error = 0;
 
 	if (acpi_disabled)
@@ -294,14 +197,6 @@ static int __init acpi_event_init(void)
 		printk(KERN_WARNING PREFIX
 		       "Failed to create genetlink family for ACPI event\n");
 
-#ifdef CONFIG_ACPI_PROC_EVENT
-	/* 'event' [R] */
-	entry = proc_create("event", S_IRUSR, acpi_root_dir,
-			    &acpi_system_event_ops);
-	if (!entry)
-		return -ENODEV;
-#endif
-
 	return 0;
 }
 
diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index bfc31cb..0976f3c 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -392,21 +392,17 @@ static void acpi_processor_notify(struct acpi_device *device, u32 event)
 		acpi_processor_ppc_has_changed(pr, 1);
 		if (saved == pr->performance_platform_limit)
 			break;
-		acpi_bus_generate_proc_event(device, event,
-					pr->performance_platform_limit);
 		acpi_bus_generate_netlink_event(device->pnp.device_class,
 						  dev_name(&device->dev), event,
 						  pr->performance_platform_limit);
 		break;
 	case ACPI_PROCESSOR_NOTIFY_POWER:
 		acpi_processor_cst_has_changed(pr);
-		acpi_bus_generate_proc_event(device, event, 0);
 		acpi_bus_generate_netlink_event(device->pnp.device_class,
 						  dev_name(&device->dev), event, 0);
 		break;
 	case ACPI_PROCESSOR_NOTIFY_THROTTLING:
 		acpi_processor_tstate_has_changed(pr);
-		acpi_bus_generate_proc_event(device, event, 0);
 		acpi_bus_generate_netlink_event(device->pnp.device_class,
 						  dev_name(&device->dev), event, 0);
 	default:
diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
index 1a8f83d..48e5765 100644
--- a/drivers/acpi/sbs.c
+++ b/drivers/acpi/sbs.c
@@ -586,14 +586,9 @@ static void acpi_sbs_callback(void *context)
 	u8 saved_charger_state = sbs->charger_present;
 	u8 saved_battery_state;
 	acpi_ac_get_present(sbs);
-	if (sbs->charger_present != saved_charger_state) {
-#ifdef CONFIG_ACPI_PROC_EVENT
-		acpi_bus_generate_proc_event4(ACPI_AC_CLASS, ACPI_AC_DIR_NAME,
-					      ACPI_SBS_NOTIFY_STATUS,
-					      sbs->charger_present);
-#endif
+	if (sbs->charger_present != saved_charger_state)
 		kobject_uevent(&sbs->charger.dev->kobj, KOBJ_CHANGE);
-	}
+
 	if (sbs->manager_present) {
 		for (id = 0; id < MAX_SBS_BAT; ++id) {
 			if (!(sbs->batteries_supported & (1 << id)))
@@ -603,12 +598,7 @@ static void acpi_sbs_callback(void *context)
 			acpi_battery_read(bat);
 			if (saved_battery_state == bat->present)
 				continue;
-#ifdef CONFIG_ACPI_PROC_EVENT
-			acpi_bus_generate_proc_event4(ACPI_BATTERY_CLASS,
-						      bat->name,
-						      ACPI_SBS_NOTIFY_STATUS,
-						      bat->present);
-#endif
+
 			kobject_uevent(&bat->bat.dev->kobj, KOBJ_CHANGE);
 		}
 	}
diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index edda74a..fd76ecf 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -721,7 +721,6 @@ static int thermal_notify(struct thermal_zone_device *thermal, int trip,
 	else
 		return 0;
 
-	acpi_bus_generate_proc_event(tz->device, type, 1);
 	acpi_bus_generate_netlink_event(tz->device->pnp.device_class,
 					dev_name(&tz->device->dev), type, 1);
 
@@ -917,14 +916,12 @@ static void acpi_thermal_notify(struct acpi_device *device, u32 event)
 	case ACPI_THERMAL_NOTIFY_THRESHOLDS:
 		acpi_thermal_trips_update(tz, ACPI_TRIPS_REFRESH_THRESHOLDS);
 		acpi_thermal_check(tz);
-		acpi_bus_generate_proc_event(device, event, 0);
 		acpi_bus_generate_netlink_event(device->pnp.device_class,
 						  dev_name(&device->dev), event, 0);
 		break;
 	case ACPI_THERMAL_NOTIFY_DEVICES:
 		acpi_thermal_trips_update(tz, ACPI_TRIPS_REFRESH_DEVICES);
 		acpi_thermal_check(tz);
-		acpi_bus_generate_proc_event(device, event, 0);
 		acpi_bus_generate_netlink_event(device->pnp.device_class,
 						  dev_name(&device->dev), event, 0);
 		break;
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 1e0a9e1..861247b 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1447,7 +1447,6 @@ static void acpi_video_bus_notify(struct acpi_device *device, u32 event)
 	switch (event) {
 	case ACPI_VIDEO_NOTIFY_SWITCH:	/* User requested a switch,
 					 * most likely via hotkey. */
-		acpi_bus_generate_proc_event(device, event, 0);
 		if (!acpi_notifier_call_chain(device, event, 0))
 			keycode = KEY_SWITCHVIDEOMODE;
 		break;
@@ -1456,20 +1455,16 @@ static void acpi_video_bus_notify(struct acpi_device *device, u32 event)
 					 * connector. */
 		acpi_video_device_enumerate(video);
 		acpi_video_device_rebind(video);
-		acpi_bus_generate_proc_event(device, event, 0);
 		keycode = KEY_SWITCHVIDEOMODE;
 		break;
 
 	case ACPI_VIDEO_NOTIFY_CYCLE:	/* Cycle Display output hotkey pressed. */
-		acpi_bus_generate_proc_event(device, event, 0);
 		keycode = KEY_SWITCHVIDEOMODE;
 		break;
 	case ACPI_VIDEO_NOTIFY_NEXT_OUTPUT:	/* Next Display output hotkey pressed. */
-		acpi_bus_generate_proc_event(device, event, 0);
 		keycode = KEY_VIDEO_NEXT;
 		break;
 	case ACPI_VIDEO_NOTIFY_PREV_OUTPUT:	/* previous Display output hotkey pressed. */
-		acpi_bus_generate_proc_event(device, event, 0);
 		keycode = KEY_VIDEO_PREV;
 		break;
 
@@ -1511,31 +1506,26 @@ static void acpi_video_device_notify(acpi_handle handle, u32 event, void *data)
 	case ACPI_VIDEO_NOTIFY_CYCLE_BRIGHTNESS:	/* Cycle brightness */
 		if (brightness_switch_enabled)
 			acpi_video_switch_brightness(video_device, event);
-		acpi_bus_generate_proc_event(device, event, 0);
 		keycode = KEY_BRIGHTNESS_CYCLE;
 		break;
 	case ACPI_VIDEO_NOTIFY_INC_BRIGHTNESS:	/* Increase brightness */
 		if (brightness_switch_enabled)
 			acpi_video_switch_brightness(video_device, event);
-		acpi_bus_generate_proc_event(device, event, 0);
 		keycode = KEY_BRIGHTNESSUP;
 		break;
 	case ACPI_VIDEO_NOTIFY_DEC_BRIGHTNESS:	/* Decrease brightness */
 		if (brightness_switch_enabled)
 			acpi_video_switch_brightness(video_device, event);
-		acpi_bus_generate_proc_event(device, event, 0);
 		keycode = KEY_BRIGHTNESSDOWN;
 		break;
 	case ACPI_VIDEO_NOTIFY_ZERO_BRIGHTNESS:	/* zero brightness */
 		if (brightness_switch_enabled)
 			acpi_video_switch_brightness(video_device, event);
-		acpi_bus_generate_proc_event(device, event, 0);
 		keycode = KEY_BRIGHTNESS_ZERO;
 		break;
 	case ACPI_VIDEO_NOTIFY_DISPLAY_OFF:	/* display device off */
 		if (brightness_switch_enabled)
 			acpi_video_switch_brightness(video_device, event);
-		acpi_bus_generate_proc_event(device, event, 0);
 		keycode = KEY_DISPLAY_OFF;
 		break;
 	default:
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index bde976e..c41b85b 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -360,14 +360,6 @@ bool acpi_bus_power_manageable(acpi_handle handle);
 bool acpi_bus_can_wakeup(acpi_handle handle);
 int acpi_power_resource_register_device(struct device *dev, acpi_handle handle);
 void acpi_power_resource_unregister_device(struct device *dev, acpi_handle handle);
-#ifdef CONFIG_ACPI_PROC_EVENT
-int acpi_bus_generate_proc_event(struct acpi_device *device, u8 type, int data);
-int acpi_bus_generate_proc_event4(const char *class, const char *bid, u8 type, int data);
-int acpi_bus_receive_event(struct acpi_bus_event *event);
-#else
-static inline int acpi_bus_generate_proc_event(struct acpi_device *device, u8 type, int data)
-	{ return 0; }
-#endif
 int acpi_bus_register_driver(struct acpi_driver *driver);
 void acpi_bus_unregister_driver(struct acpi_driver *driver);
 int acpi_bus_add(struct acpi_device **child, struct acpi_device *parent,
-- 
1.7.4.1




