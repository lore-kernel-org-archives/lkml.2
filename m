Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018Ab2GYDsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:48:31 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:33308 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932970Ab2GYDnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:43:06 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jung-uk Kim <jkim@freebsd.org>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 34/52] ACPICA: Add support for implicit notify on multiple devices
Date: Tue, 24 Jul 2012 23:41:30 -0400
Message-Id: <5816b3430c4b5f31d9c35af1da7be721c9518137.1343187617.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.12.rc0
In-Reply-To: <1343187708-19532-1-git-send-email-lenb@kernel.org>
References: <1343187708-19532-1-git-send-email-lenb@kernel.org>
In-Reply-To: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
References: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Adds basic support to allow multiple devices to be implicitly
notified.

This change is partially derived from original commit 981858b("ACPI /
ACPICA: Implicit notify for multiple devices") by Rafael.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Jung-uk Kim <jkim@freebsd.org>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/aclocal.h   |  11 ++++-
 drivers/acpi/acpica/evgpe.c     |  22 ++++-----
 drivers/acpi/acpica/evgpeutil.c |  20 ++++++++
 drivers/acpi/acpica/evxfgpe.c   | 106 ++++++++++++++++++++++++++--------------
 4 files changed, 109 insertions(+), 50 deletions(-)

diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index af7330f..6b225e8 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -404,6 +404,13 @@ struct acpi_gpe_handler_info {
 	u8 originally_enabled;  /* True if GPE was originally enabled */
 };
 
+/* Notify info for implicit notify, multiple device objects */
+
+struct acpi_gpe_notify_info {
+	struct acpi_namespace_node *device_node;	/* Device to be notified */
+	struct acpi_gpe_notify_info *next;
+};
+
 struct acpi_gpe_notify_object {
 	struct acpi_namespace_node *node;
 	struct acpi_gpe_notify_object *next;
@@ -412,7 +419,7 @@ struct acpi_gpe_notify_object {
 union acpi_gpe_dispatch_info {
 	struct acpi_namespace_node *method_node;	/* Method node for this GPE level */
 	struct acpi_gpe_handler_info *handler;  /* Installed GPE handler */
-	struct acpi_gpe_notify_object device;   /* List of _PRW devices for implicit notify */
+	struct acpi_gpe_notify_info *notify_list;	/* List of _PRW devices for implicit notifies */
 };
 
 /*
@@ -420,7 +427,7 @@ union acpi_gpe_dispatch_info {
  * NOTE: Important to keep this struct as small as possible.
  */
 struct acpi_gpe_event_info {
-	union acpi_gpe_dispatch_info dispatch;	/* Either Method or Handler */
+	union acpi_gpe_dispatch_info dispatch;	/* Either Method, Handler, or notify_list */
 	struct acpi_gpe_register_info *register_info;	/* Backpointer to register info */
 	u8 flags;		/* Misc info about this GPE */
 	u8 gpe_number;		/* This GPE */
diff --git a/drivers/acpi/acpica/evgpe.c b/drivers/acpi/acpica/evgpe.c
index 8ba0e5f..afbd5cb 100644
--- a/drivers/acpi/acpica/evgpe.c
+++ b/drivers/acpi/acpica/evgpe.c
@@ -466,7 +466,7 @@ static void ACPI_SYSTEM_XFACE acpi_ev_asynch_execute_gpe_method(void *context)
 	acpi_status status;
 	struct acpi_gpe_event_info *local_gpe_event_info;
 	struct acpi_evaluate_info *info;
-	struct acpi_gpe_notify_object *notify_object;
+	struct acpi_gpe_notify_info *notify;
 
 	ACPI_FUNCTION_TRACE(ev_asynch_execute_gpe_method);
 
@@ -517,17 +517,17 @@ static void ACPI_SYSTEM_XFACE acpi_ev_asynch_execute_gpe_method(void *context)
 		 * completes. The notify handlers are NOT invoked synchronously
 		 * from this thread -- because handlers may in turn run other
 		 * control methods.
+		 *
+		 * June 2012: Expand implicit notify mechanism to support
+		 * notifies on multiple device objects.
 		 */
-		status = acpi_ev_queue_notify_request(
-				local_gpe_event_info->dispatch.device.node,
-				ACPI_NOTIFY_DEVICE_WAKE);
-
-		notify_object = local_gpe_event_info->dispatch.device.next;
-		while (ACPI_SUCCESS(status) && notify_object) {
-			status = acpi_ev_queue_notify_request(
-					notify_object->node,
-					ACPI_NOTIFY_DEVICE_WAKE);
-			notify_object = notify_object->next;
+		notify = local_gpe_event_info->dispatch.notify_list;
+		while (ACPI_SUCCESS(status) && notify) {
+			status =
+			    acpi_ev_queue_notify_request(notify->device_node,
+							 ACPI_NOTIFY_DEVICE_WAKE);
+
+			notify = notify->next;
 		}
 
 		break;
diff --git a/drivers/acpi/acpica/evgpeutil.c b/drivers/acpi/acpica/evgpeutil.c
index 3c43796..0c33c62 100644
--- a/drivers/acpi/acpica/evgpeutil.c
+++ b/drivers/acpi/acpica/evgpeutil.c
@@ -347,6 +347,8 @@ acpi_ev_delete_gpe_handlers(struct acpi_gpe_xrupt_info *gpe_xrupt_info,
 			    void *context)
 {
 	struct acpi_gpe_event_info *gpe_event_info;
+	struct acpi_gpe_notify_info *notify;
+	struct acpi_gpe_notify_info *next;
 	u32 i;
 	u32 j;
 
@@ -365,10 +367,28 @@ acpi_ev_delete_gpe_handlers(struct acpi_gpe_xrupt_info *gpe_xrupt_info,
 
 			if ((gpe_event_info->flags & ACPI_GPE_DISPATCH_MASK) ==
 			    ACPI_GPE_DISPATCH_HANDLER) {
+
+				/* Delete an installed handler block */
+
 				ACPI_FREE(gpe_event_info->dispatch.handler);
 				gpe_event_info->dispatch.handler = NULL;
 				gpe_event_info->flags &=
 				    ~ACPI_GPE_DISPATCH_MASK;
+			} else if ((gpe_event_info->
+				 flags & ACPI_GPE_DISPATCH_MASK) ==
+				ACPI_GPE_DISPATCH_NOTIFY) {
+
+				/* Delete the implicit notification device list */
+
+				notify = gpe_event_info->dispatch.notify_list;
+				while (notify) {
+					next = notify->next;
+					ACPI_FREE(notify);
+					notify = next;
+				}
+				gpe_event_info->dispatch.notify_list = NULL;
+				gpe_event_info->flags &=
+				    ~ACPI_GPE_DISPATCH_MASK;
 			}
 		}
 	}
diff --git a/drivers/acpi/acpica/evxfgpe.c b/drivers/acpi/acpica/evxfgpe.c
index 86f9b34..2ce4409 100644
--- a/drivers/acpi/acpica/evxfgpe.c
+++ b/drivers/acpi/acpica/evxfgpe.c
@@ -197,12 +197,12 @@ acpi_status
 acpi_setup_gpe_for_wake(acpi_handle wake_device,
 			acpi_handle gpe_device, u32 gpe_number)
 {
-	acpi_status status = AE_BAD_PARAMETER;
+	acpi_status status;
 	struct acpi_gpe_event_info *gpe_event_info;
 	struct acpi_namespace_node *device_node;
-	struct acpi_gpe_notify_object *notify_object;
+	struct acpi_gpe_notify_info *notify;
+	struct acpi_gpe_notify_info *new_notify;
 	acpi_cpu_flags flags;
-	u8 gpe_dispatch_mask;
 
 	ACPI_FUNCTION_TRACE(acpi_setup_gpe_for_wake);
 
@@ -216,63 +216,95 @@ acpi_setup_gpe_for_wake(acpi_handle wake_device,
 		return_ACPI_STATUS(AE_BAD_PARAMETER);
 	}
 
+	/* Handle root object case */
+
+	if (wake_device == ACPI_ROOT_OBJECT) {
+		device_node = acpi_gbl_root_node;
+	} else {
+		device_node = ACPI_CAST_PTR(struct acpi_namespace_node, wake_device);
+	}
+
+	/* Validate WakeDevice is of type Device */
+
+	if (device_node->type != ACPI_TYPE_DEVICE) {
+		return_ACPI_STATUS (AE_BAD_PARAMETER);
+	}
+
+	/*
+	 * Allocate a new notify object up front, in case it is needed.
+	 * Memory allocation while holding a spinlock is a big no-no
+	 * on some hosts.
+	 */
+	new_notify = ACPI_ALLOCATE_ZEROED(sizeof(struct acpi_gpe_notify_info));
+	if (!new_notify) {
+		return_ACPI_STATUS(AE_NO_MEMORY);
+	}
+
 	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
 
 	/* Ensure that we have a valid GPE number */
 
 	gpe_event_info = acpi_ev_get_gpe_event_info(gpe_device, gpe_number);
 	if (!gpe_event_info) {
+		status = AE_BAD_PARAMETER;
 		goto unlock_and_exit;
 	}
 
-	if (wake_device == ACPI_ROOT_OBJECT) {
-		goto out;
-	}
-
 	/*
 	 * If there is no method or handler for this GPE, then the
-	 * wake_device will be notified whenever this GPE fires (aka
-	 * "implicit notify") Note: The GPE is assumed to be
+	 * wake_device will be notified whenever this GPE fires. This is
+	 * known as an "implicit notify". Note: The GPE is assumed to be
 	 * level-triggered (for windows compatibility).
 	 */
-	gpe_dispatch_mask = gpe_event_info->flags & ACPI_GPE_DISPATCH_MASK;
-	if (gpe_dispatch_mask != ACPI_GPE_DISPATCH_NONE
-	    && gpe_dispatch_mask != ACPI_GPE_DISPATCH_NOTIFY) {
-		goto out;
-	}
-
-	/* Validate wake_device is of type Device */
-
-	device_node = ACPI_CAST_PTR(struct acpi_namespace_node, wake_device);
-	if (device_node->type != ACPI_TYPE_DEVICE) {
-		goto unlock_and_exit;
+	if ((gpe_event_info->flags & ACPI_GPE_DISPATCH_MASK) ==
+	    ACPI_GPE_DISPATCH_NONE) {
+		/*
+		 * This is the first device for implicit notify on this GPE.
+		 * Just set the flags here, and enter the NOTIFY block below.
+		 */
+		gpe_event_info->flags =
+		    (ACPI_GPE_DISPATCH_NOTIFY | ACPI_GPE_LEVEL_TRIGGERED);
 	}
 
-	if (gpe_dispatch_mask == ACPI_GPE_DISPATCH_NONE) {
-		gpe_event_info->flags = (ACPI_GPE_DISPATCH_NOTIFY |
-					 ACPI_GPE_LEVEL_TRIGGERED);
-		gpe_event_info->dispatch.device.node = device_node;
-		gpe_event_info->dispatch.device.next = NULL;
-	} else {
-		/* There are multiple devices to notify implicitly. */
-
-		notify_object = ACPI_ALLOCATE_ZEROED(sizeof(*notify_object));
-		if (!notify_object) {
-			status = AE_NO_MEMORY;
-			goto unlock_and_exit;
+	/*
+	 * If we already have an implicit notify on this GPE, add
+	 * this device to the notify list.
+	 */
+	if ((gpe_event_info->flags & ACPI_GPE_DISPATCH_MASK) ==
+	    ACPI_GPE_DISPATCH_NOTIFY) {
+
+		/* Ensure that the device is not already in the list */
+
+		notify = gpe_event_info->dispatch.notify_list;
+		while (notify) {
+			if (notify->device_node == device_node) {
+				status = AE_ALREADY_EXISTS;
+				goto unlock_and_exit;
+			}
+			notify = notify->next;
 		}
 
-		notify_object->node = device_node;
-		notify_object->next = gpe_event_info->dispatch.device.next;
-		gpe_event_info->dispatch.device.next = notify_object;
+		/* Add this device to the notify list for this GPE */
+
+		new_notify->device_node = device_node;
+		new_notify->next = gpe_event_info->dispatch.notify_list;
+		gpe_event_info->dispatch.notify_list = new_notify;
+		new_notify = NULL;
 	}
 
- out:
+	/* Mark the GPE as a possible wake event */
+
 	gpe_event_info->flags |= ACPI_GPE_CAN_WAKE;
 	status = AE_OK;
 
- unlock_and_exit:
+unlock_and_exit:
 	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+
+	/* Delete the notify object if it was not used above */
+
+	if (new_notify) {
+		ACPI_FREE(new_notify);
+	}
 	return_ACPI_STATUS(status);
 }
 ACPI_EXPORT_SYMBOL(acpi_setup_gpe_for_wake)
-- 
1.7.12.rc0

