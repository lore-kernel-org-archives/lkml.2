Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919Ab0FJLL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:11:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39178 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758877Ab0FJLKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:10:55 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20100610110.764742110@firstfloor.org>
In-Reply-To: <20100610110.764742110@firstfloor.org>
To: lenb@kernel.org, linux-acpi@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [18/23] ACPI: Fix unused but set variables in ACPI
Message-Id: <20100610111054.49C89B1A2B@basil.firstfloor.org>
Date: Thu, 10 Jun 2010 13:10:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some minor improvements in error handling, but overall
it was mostly dead code.

cc: lenb@kernel.org
cc: linux-acpi@vger.kernel.org

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/acpi/acpica/utmutex.c    |    5 +----
 drivers/acpi/numa.c              |    4 +---
 drivers/acpi/osl.c               |    7 +++----
 drivers/acpi/power.c             |    6 +-----
 drivers/acpi/processor_idle.c    |    3 +--
 drivers/acpi/processor_thermal.c |    2 ++
 drivers/acpi/video.c             |   10 +++++-----
 drivers/ata/libata-acpi.c        |    6 ------
 8 files changed, 14 insertions(+), 29 deletions(-)

Index: linux-2.6.35-rc2-gcc/drivers/acpi/processor_thermal.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/drivers/acpi/processor_thermal.c
+++ linux-2.6.35-rc2-gcc/drivers/acpi/processor_thermal.c
@@ -506,6 +506,8 @@ static ssize_t acpi_processor_write_limi
 	}
 
 	result = acpi_processor_apply_limit(pr);
+	if (result < 0)
+		return result;
 
 	return count;
 }
Index: linux-2.6.35-rc2-gcc/drivers/acpi/acpica/utmutex.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/drivers/acpi/acpica/utmutex.c
+++ linux-2.6.35-rc2-gcc/drivers/acpi/acpica/utmutex.c
@@ -279,13 +279,10 @@ acpi_status acpi_ut_acquire_mutex(acpi_m
 
 acpi_status acpi_ut_release_mutex(acpi_mutex_handle mutex_id)
 {
-	acpi_thread_id this_thread_id;
-
 	ACPI_FUNCTION_NAME(ut_release_mutex);
 
-	this_thread_id = acpi_os_get_thread_id();
 	ACPI_DEBUG_PRINT((ACPI_DB_MUTEX, "Thread %p releasing Mutex [%s]\n",
-			  ACPI_CAST_PTR(void, this_thread_id),
+			  ACPI_CAST_PTR(void, acpi_os_get_thread_id()),
 			  acpi_ut_get_mutex_name(mutex_id)));
 
 	if (mutex_id > ACPI_MAX_MUTEX) {
Index: linux-2.6.35-rc2-gcc/drivers/acpi/numa.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/drivers/acpi/numa.c
+++ linux-2.6.35-rc2-gcc/drivers/acpi/numa.c
@@ -255,12 +255,10 @@ acpi_parse_memory_affinity(struct acpi_s
 
 static int __init acpi_parse_srat(struct acpi_table_header *table)
 {
-	struct acpi_table_srat *srat;
-
 	if (!table)
 		return -EINVAL;
 
-	srat = (struct acpi_table_srat *)table;
+	/* Real work done in acpi_table_parse_srat below. */
 
 	return 0;
 }
Index: linux-2.6.35-rc2-gcc/drivers/acpi/osl.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/drivers/acpi/osl.c
+++ linux-2.6.35-rc2-gcc/drivers/acpi/osl.c
@@ -141,15 +141,14 @@ static struct osi_linux {
 static void __init acpi_request_region (struct acpi_generic_address *addr,
 	unsigned int length, char *desc)
 {
-	struct resource *res;
-
 	if (!addr->address || !length)
 		return;
 
+	/* Resources are never freed */
 	if (addr->space_id == ACPI_ADR_SPACE_SYSTEM_IO)
-		res = request_region(addr->address, length, desc);
+		request_region(addr->address, length, desc);
 	else if (addr->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
-		res = request_mem_region(addr->address, length, desc);
+		request_mem_region(addr->address, length, desc);
 }
 
 static int __init acpi_reserve_resources(void)
Index: linux-2.6.35-rc2-gcc/drivers/acpi/processor_idle.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/drivers/acpi/processor_idle.c
+++ linux-2.6.35-rc2-gcc/drivers/acpi/processor_idle.c
@@ -795,13 +795,12 @@ static inline void acpi_idle_do_entry(st
 	} else if (cx->entry_method == ACPI_CSTATE_HALT) {
 		acpi_safe_halt();
 	} else {
-		int unused;
 		/* IO port based C-state */
 		inb(cx->address);
 		/* Dummy wait op - must do something useless after P_LVL2 read
 		   because chipsets cannot guarantee that STPCLK# signal
 		   gets asserted in time to freeze execution properly. */
-		unused = inl(acpi_gbl_FADT.xpm_timer_block.address);
+		inl(acpi_gbl_FADT.xpm_timer_block.address);
 	}
 	start_critical_timings();
 }
Index: linux-2.6.35-rc2-gcc/drivers/acpi/video.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/drivers/acpi/video.c
+++ linux-2.6.35-rc2-gcc/drivers/acpi/video.c
@@ -2140,7 +2140,7 @@ acpi_video_bus_get_devices(struct acpi_v
 		status = acpi_video_bus_get_one_device(dev, video);
 		if (ACPI_FAILURE(status)) {
 			printk(KERN_WARNING PREFIX
-					"Cant attach device");
+					"Cant attach device\n");
 			continue;
 		}
 	}
@@ -2150,19 +2150,19 @@ acpi_video_bus_get_devices(struct acpi_v
 static int acpi_video_bus_put_one_device(struct acpi_video_device *device)
 {
 	acpi_status status;
-	struct acpi_video_bus *video;
-
 
 	if (!device || !device->video)
 		return -ENOENT;
 
-	video = device->video;
-
 	acpi_video_device_remove_fs(device->dev);
 
 	status = acpi_remove_notify_handler(device->dev->handle,
 					    ACPI_DEVICE_NOTIFY,
 					    acpi_video_device_notify);
+	if (ACPI_FAILURE(status)) {
+		printk(KERN_WARNING PREFIX
+		       "Cant remove video notify handler\n");
+	}
 	if (device->backlight) {
 		sysfs_remove_link(&device->backlight->dev.kobj, "device");
 		backlight_device_unregister(device->backlight);
Index: linux-2.6.35-rc2-gcc/drivers/ata/libata-acpi.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/drivers/ata/libata-acpi.c
+++ linux-2.6.35-rc2-gcc/drivers/ata/libata-acpi.c
@@ -145,12 +145,6 @@ static void ata_acpi_handle_hotplug(stru
 	struct ata_eh_info *ehi = &ap->link.eh_info;
 	int wait = 0;
 	unsigned long flags;
-	acpi_handle handle;
-
-	if (dev)
-		handle = dev->acpi_handle;
-	else
-		handle = ap->acpi_handle;
 
 	spin_lock_irqsave(ap->lock, flags);
 	/*
Index: linux-2.6.35-rc2-gcc/drivers/acpi/power.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/drivers/acpi/power.c
+++ linux-2.6.35-rc2-gcc/drivers/acpi/power.c
@@ -553,8 +553,6 @@ static int acpi_power_seq_show(struct se
 	int result = 0, state;
 	struct acpi_power_resource *resource = NULL;
 	struct list_head *node, *next;
-	struct acpi_power_reference *ref;
-
 
 	resource = seq->private;
 
@@ -579,10 +577,8 @@ static int acpi_power_seq_show(struct se
 	}
 
 	mutex_lock(&resource->resource_lock);
-	list_for_each_safe(node, next, &resource->reference) {
-		ref = container_of(node, struct acpi_power_reference, node);
+	list_for_each_safe(node, next, &resource->reference)
 		count++;
-	}
 	mutex_unlock(&resource->resource_lock);
 
 	seq_printf(seq, "system level:            S%d\n"
