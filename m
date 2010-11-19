Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab0KSPkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 10:40:07 -0500
Received: from adelie.canonical.com ([91.189.90.139]:37414 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab0KSPkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 10:40:05 -0500
From: Colin King <colin.king@canonical.com>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>,
        platform-driver-x86@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] WMI: Cater for multiple events with same GUID
Date: Fri, 19 Nov 2010 15:40:02 +0000
Message-Id: <1290181202-9439-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WMI data blocks can contain WMI events with the same GUID but with
different notifiy_ids, for example volume up/down hotkeys.
This patch enables a single event handler to be registered and
unregistered against all events with same GUID but different
notify_ids.  Since an event handler is passed the notify_id of
an event it can can differentiate between the different events.

The patch also ensures we only register and unregister a device per
unique GUID.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/platform/x86/wmi.c |  135 ++++++++++++++++++++++++--------------------
 1 files changed, 73 insertions(+), 62 deletions(-)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index 104b77c..67a21a2 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -549,21 +549,34 @@ acpi_status wmi_install_notify_handler(const char *guid,
 wmi_notify_handler handler, void *data)
 {
 	struct wmi_block *block;
-	acpi_status status;
+	acpi_status status = AE_NOT_EXIST;
+	char tmp[16], guid_input[16];
+	struct list_head *p;
 
 	if (!guid || !handler)
 		return AE_BAD_PARAMETER;
 
-	if (!find_guid(guid, &block))
-		return AE_NOT_EXIST;
+	wmi_parse_guid(guid, tmp);
+	wmi_swap_bytes(tmp, guid_input);
 
-	if (block->handler && block->handler != wmi_notify_debug)
-		return AE_ALREADY_ACQUIRED;
+	list_for_each(p, &wmi_block_list) {
+		acpi_status wmi_status;
+		block = list_entry(p, struct wmi_block, list);
 
-	block->handler = handler;
-	block->handler_data = data;
+		if (memcmp(block->gblock.guid, guid_input, 16) == 0) {
+			if (block->handler &&
+			    block->handler != wmi_notify_debug)
+				return AE_ALREADY_ACQUIRED;
 
-	status = wmi_method_enable(block, 1);
+			block->handler = handler;
+			block->handler_data = data;
+
+			wmi_status = wmi_method_enable(block, 1);
+			if ((wmi_status != AE_OK) ||
+			    ((wmi_status == AE_OK) && (status == AE_NOT_EXIST)))
+				status = wmi_status;
+		}
+	}
 
 	return status;
 }
@@ -577,24 +590,40 @@ EXPORT_SYMBOL_GPL(wmi_install_notify_handler);
 acpi_status wmi_remove_notify_handler(const char *guid)
 {
 	struct wmi_block *block;
-	acpi_status status = AE_OK;
+	acpi_status status = AE_NOT_EXIST;
+	char tmp[16], guid_input[16];
+	struct list_head *p;
 
 	if (!guid)
 		return AE_BAD_PARAMETER;
 
-	if (!find_guid(guid, &block))
-		return AE_NOT_EXIST;
+	wmi_parse_guid(guid, tmp);
+	wmi_swap_bytes(tmp, guid_input);
 
-	if (!block->handler || block->handler == wmi_notify_debug)
-		return AE_NULL_ENTRY;
+	list_for_each(p, &wmi_block_list) {
+		acpi_status wmi_status;
+		block = list_entry(p, struct wmi_block, list);
 
-	if (debug_event) {
-		block->handler = wmi_notify_debug;
-	} else {
-		status = wmi_method_enable(block, 0);
-		block->handler = NULL;
-		block->handler_data = NULL;
+		if (memcmp(block->gblock.guid, guid_input, 16) == 0) {
+			if (!block->handler ||
+			    block->handler == wmi_notify_debug)
+				return AE_NULL_ENTRY;
+
+			if (debug_event) {
+				block->handler = wmi_notify_debug;
+				status = AE_OK;
+			} else {
+				wmi_status = wmi_method_enable(block, 0);
+				block->handler = NULL;
+				block->handler_data = NULL;
+				if ((wmi_status != AE_OK) ||
+				    ((wmi_status == AE_OK) &&
+				     (status == AE_NOT_EXIST)))
+					status = wmi_status;
+			}
+		}
 	}
+
 	return status;
 }
 EXPORT_SYMBOL_GPL(wmi_remove_notify_handler);
@@ -705,22 +734,11 @@ static struct class wmi_class = {
 	.dev_attrs = wmi_dev_attrs,
 };
 
-static struct wmi_block *wmi_create_device(const struct guid_block *gblock,
-					   acpi_handle handle)
+static int wmi_create_device(const struct guid_block *gblock,
+			     struct wmi_block *wblock, acpi_handle handle)
 {
-	struct wmi_block *wblock;
-	int error;
 	char guid_string[37];
 
-	wblock = kzalloc(sizeof(struct wmi_block), GFP_KERNEL);
-	if (!wblock) {
-		error = -ENOMEM;
-		goto err_out;
-	}
-
-	wblock->handle = handle;
-	wblock->gblock = *gblock;
-
 	wblock->dev.class = &wmi_class;
 
 	wmi_gtoa(gblock->guid, guid_string);
@@ -728,17 +746,7 @@ static struct wmi_block *wmi_create_device(const struct guid_block *gblock,
 
 	dev_set_drvdata(&wblock->dev, wblock);
 
-	error = device_register(&wblock->dev);
-	if (error)
-		goto err_free;
-
-	list_add_tail(&wblock->list, &wmi_block_list);
-	return wblock;
-
-err_free:
-	kfree(wblock);
-err_out:
-	return ERR_PTR(error);
+	return device_register(&wblock->dev);
 }
 
 static void wmi_free_devices(void)
@@ -747,7 +755,8 @@ static void wmi_free_devices(void)
 
 	/* Delete devices for all the GUIDs */
 	list_for_each_entry_safe(wblock, next, &wmi_block_list, list)
-		device_unregister(&wblock->dev);
+		if (wblock->dev.class)
+			device_unregister(&wblock->dev);
 }
 
 static bool guid_already_parsed(const char *guid_string)
@@ -770,7 +779,6 @@ static acpi_status parse_wdg(acpi_handle handle)
 	union acpi_object *obj;
 	const struct guid_block *gblock;
 	struct wmi_block *wblock;
-	char guid_string[37];
 	acpi_status status;
 	int retval;
 	u32 i, total;
@@ -792,28 +800,31 @@ static acpi_status parse_wdg(acpi_handle handle)
 	total = obj->buffer.length / sizeof(struct guid_block);
 
 	for (i = 0; i < total; i++) {
+		if (debug_dump_wdg)
+			wmi_dump_wdg(&gblock[i]);
+
+		wblock = kzalloc(sizeof(struct wmi_block), GFP_KERNEL);
+		if (!wblock)
+			return AE_NO_MEMORY;
+
+		wblock->handle = handle;
+		wblock->gblock = gblock[i];
+
 		/*
 		  Some WMI devices, like those for nVidia hooks, have a
 		  duplicate GUID. It's not clear what we should do in this
-		  case yet, so for now, we'll just ignore the duplicate.
-		  Anyone who wants to add support for that device can come
-		  up with a better workaround for the mess then.
+		  case yet, so for now, we'll just ignore the duplicate
+		  for device creation.
 		*/
-		if (guid_already_parsed(gblock[i].guid) == true) {
-			wmi_gtoa(gblock[i].guid, guid_string);
-			pr_info("Skipping duplicate GUID %s\n", guid_string);
-			continue;
+		if (!guid_already_parsed(gblock[i].guid)) {
+			retval = wmi_create_device(&gblock[i], wblock, handle);
+			if (retval) {
+				wmi_free_devices();
+				break;
+			}
 		}
 
-		if (debug_dump_wdg)
-			wmi_dump_wdg(&gblock[i]);
-
-		wblock = wmi_create_device(&gblock[i], handle);
-		if (IS_ERR(wblock)) {
-			retval = PTR_ERR(wblock);
-			wmi_free_devices();
-			break;
-		}
+		list_add_tail(&wblock->list, &wmi_block_list);
 
 		if (debug_event) {
 			wblock->handler = wmi_notify_debug;
-- 
1.7.0.4

