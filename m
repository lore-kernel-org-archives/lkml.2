Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab3ADV7F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 16:59:05 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:60456 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041Ab3ADV6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 16:58:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Huang Ying <ying.huang@intel.com>
Subject: [PATCH 5/6] ACPI / PM: Move device power management functions to device_pm.c
Date: Fri, 04 Jan 2013 23:03:38 +0100
Message-ID: <6008717.ikrzm79TyJ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc2+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2311196.icSMDvAsYg@vostro.rjw.lan>
References: <2311196.icSMDvAsYg@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Move ACPI device power management functions from drivers/acpi/bus.c
to drivers/acpi/device_pm.c.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/bus.c       |  293 -----------------------------------------------
 drivers/acpi/device_pm.c |  288 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/internal.h  |    1 
 include/acpi/acpi_bus.h  |   38 ++++++
 4 files changed, 326 insertions(+), 294 deletions(-)

Index: linux/drivers/acpi/device_pm.c
===================================================================
--- linux.orig/drivers/acpi/device_pm.c
+++ linux/drivers/acpi/device_pm.c
@@ -30,6 +30,12 @@
 
 #include <acpi/acpi.h>
 #include <acpi/acpi_bus.h>
+#include <acpi/acpi_drivers.h>
+
+#include "internal.h"
+
+#define _COMPONENT	ACPI_POWER_COMPONENT
+ACPI_MODULE_NAME("device_pm");
 
 static DEFINE_MUTEX(acpi_pm_notifier_lock);
 
@@ -94,6 +100,288 @@ acpi_status acpi_remove_pm_notifier(stru
 }
 
 /**
+ * acpi_power_state_string - String representation of ACPI device power state.
+ * @state: ACPI device power state to return the string representation of.
+ */
+const char *acpi_power_state_string(int state)
+{
+	switch (state) {
+	case ACPI_STATE_D0:
+		return "D0";
+	case ACPI_STATE_D1:
+		return "D1";
+	case ACPI_STATE_D2:
+		return "D2";
+	case ACPI_STATE_D3_HOT:
+		return "D3hot";
+	case ACPI_STATE_D3_COLD:
+		return "D3";
+	default:
+		return "(unknown)";
+	}
+}
+
+/**
+ * acpi_device_get_power - Get power state of an ACPI device.
+ * @device: Device to get the power state of.
+ * @state: Place to store the power state of the device.
+ *
+ * This function does not update the device's power.state field, but it may
+ * update its parent's power.state field (when the parent's power state is
+ * unknown and the device's power state turns out to be D0).
+ */
+int acpi_device_get_power(struct acpi_device *device, int *state)
+{
+	int result = ACPI_STATE_UNKNOWN;
+
+	if (!device || !state)
+		return -EINVAL;
+
+	if (!device->flags.power_manageable) {
+		/* TBD: Non-recursive algorithm for walking up hierarchy. */
+		*state = device->parent ?
+			device->parent->power.state : ACPI_STATE_D0;
+		goto out;
+	}
+
+	/*
+	 * Get the device's power state either directly (via _PSC) or
+	 * indirectly (via power resources).
+	 */
+	if (device->power.flags.explicit_get) {
+		unsigned long long psc;
+		acpi_status status = acpi_evaluate_integer(device->handle,
+							   "_PSC", NULL, &psc);
+		if (ACPI_FAILURE(status))
+			return -ENODEV;
+
+		result = psc;
+	}
+	/* The test below covers ACPI_STATE_UNKNOWN too. */
+	if (result <= ACPI_STATE_D2) {
+	  ; /* Do nothing. */
+	} else if (device->power.flags.power_resources) {
+		int error = acpi_power_get_inferred_state(device, &result);
+		if (error)
+			return error;
+	} else if (result == ACPI_STATE_D3_HOT) {
+		result = ACPI_STATE_D3;
+	}
+
+	/*
+	 * If we were unsure about the device parent's power state up to this
+	 * point, the fact that the device is in D0 implies that the parent has
+	 * to be in D0 too.
+	 */
+	if (device->parent && device->parent->power.state == ACPI_STATE_UNKNOWN
+	    && result == ACPI_STATE_D0)
+		device->parent->power.state = ACPI_STATE_D0;
+
+	*state = result;
+
+ out:
+	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device [%s] power state is %s\n",
+			  device->pnp.bus_id, acpi_power_state_string(*state)));
+
+	return 0;
+}
+
+/**
+ * acpi_device_set_power - Set power state of an ACPI device.
+ * @device: Device to set the power state of.
+ * @state: New power state to set.
+ *
+ * Callers must ensure that the device is power manageable before using this
+ * function.
+ */
+int acpi_device_set_power(struct acpi_device *device, int state)
+{
+	int result = 0;
+	acpi_status status = AE_OK;
+	char object_name[5] = { '_', 'P', 'S', '0' + state, '\0' };
+	bool cut_power = false;
+
+	if (!device || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3_COLD))
+		return -EINVAL;
+
+	/* Make sure this is a valid target state */
+
+	if (state == device->power.state) {
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device is already at %s\n",
+				  acpi_power_state_string(state)));
+		return 0;
+	}
+
+	if (!device->power.states[state].flags.valid) {
+		printk(KERN_WARNING PREFIX "Device does not support %s\n",
+		       acpi_power_state_string(state));
+		return -ENODEV;
+	}
+	if (device->parent && (state < device->parent->power.state)) {
+		printk(KERN_WARNING PREFIX
+			      "Cannot set device to a higher-powered"
+			      " state than parent\n");
+		return -ENODEV;
+	}
+
+	/* For D3cold we should first transition into D3hot. */
+	if (state == ACPI_STATE_D3_COLD
+	    && device->power.states[ACPI_STATE_D3_COLD].flags.os_accessible) {
+		state = ACPI_STATE_D3_HOT;
+		object_name[3] = '3';
+		cut_power = true;
+	}
+
+	/*
+	 * Transition Power
+	 * ----------------
+	 * On transitions to a high-powered state we first apply power (via
+	 * power resources) then evalute _PSx.  Conversly for transitions to
+	 * a lower-powered state.
+	 */
+	if (state < device->power.state) {
+		if (device->power.state >= ACPI_STATE_D3_HOT &&
+		    state != ACPI_STATE_D0) {
+			printk(KERN_WARNING PREFIX
+			      "Cannot transition to non-D0 state from D3\n");
+			return -ENODEV;
+		}
+		if (device->power.flags.power_resources) {
+			result = acpi_power_transition(device, state);
+			if (result)
+				goto end;
+		}
+		if (device->power.states[state].flags.explicit_set) {
+			status = acpi_evaluate_object(device->handle,
+						      object_name, NULL, NULL);
+			if (ACPI_FAILURE(status)) {
+				result = -ENODEV;
+				goto end;
+			}
+		}
+	} else {
+		if (device->power.states[state].flags.explicit_set) {
+			status = acpi_evaluate_object(device->handle,
+						      object_name, NULL, NULL);
+			if (ACPI_FAILURE(status)) {
+				result = -ENODEV;
+				goto end;
+			}
+		}
+		if (device->power.flags.power_resources) {
+			result = acpi_power_transition(device, state);
+			if (result)
+				goto end;
+		}
+	}
+
+	if (cut_power)
+		result = acpi_power_transition(device, ACPI_STATE_D3_COLD);
+
+      end:
+	if (result)
+		printk(KERN_WARNING PREFIX
+			      "Device [%s] failed to transition to %s\n",
+			      device->pnp.bus_id,
+			      acpi_power_state_string(state));
+	else {
+		device->power.state = state;
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+				  "Device [%s] transitioned to %s\n",
+				  device->pnp.bus_id,
+				  acpi_power_state_string(state)));
+	}
+
+	return result;
+}
+EXPORT_SYMBOL(acpi_device_set_power);
+
+int acpi_bus_set_power(acpi_handle handle, int state)
+{
+	struct acpi_device *device;
+	int result;
+
+	result = acpi_bus_get_device(handle, &device);
+	if (result)
+		return result;
+
+	if (!device->flags.power_manageable) {
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+				"Device [%s] is not power manageable\n",
+				dev_name(&device->dev)));
+		return -ENODEV;
+	}
+
+	return acpi_device_set_power(device, state);
+}
+EXPORT_SYMBOL(acpi_bus_set_power);
+
+int acpi_bus_init_power(struct acpi_device *device)
+{
+	int state;
+	int result;
+
+	if (!device)
+		return -EINVAL;
+
+	device->power.state = ACPI_STATE_UNKNOWN;
+
+	result = acpi_device_get_power(device, &state);
+	if (result)
+		return result;
+
+	if (device->power.flags.power_resources)
+		result = acpi_power_on_resources(device, state);
+
+	if (!result)
+		device->power.state = state;
+
+	return result;
+}
+
+int acpi_bus_update_power(acpi_handle handle, int *state_p)
+{
+	struct acpi_device *device;
+	int state;
+	int result;
+
+	result = acpi_bus_get_device(handle, &device);
+	if (result)
+		return result;
+
+	result = acpi_device_get_power(device, &state);
+	if (result)
+		return result;
+
+	result = acpi_device_set_power(device, state);
+	if (!result && state_p)
+		*state_p = state;
+
+	return result;
+}
+EXPORT_SYMBOL_GPL(acpi_bus_update_power);
+
+bool acpi_bus_power_manageable(acpi_handle handle)
+{
+	struct acpi_device *device;
+	int result;
+
+	result = acpi_bus_get_device(handle, &device);
+	return result ? false : device->flags.power_manageable;
+}
+EXPORT_SYMBOL(acpi_bus_power_manageable);
+
+bool acpi_bus_can_wakeup(acpi_handle handle)
+{
+	struct acpi_device *device;
+	int result;
+
+	result = acpi_bus_get_device(handle, &device);
+	return result ? false : device->wakeup.flags.valid;
+}
+EXPORT_SYMBOL(acpi_bus_can_wakeup);
+
+/**
  * acpi_device_power_state - Get preferred power state of ACPI device.
  * @dev: Device whose preferred target power state to return.
  * @adev: ACPI device node corresponding to @dev.
Index: linux/include/acpi/acpi_bus.h
===================================================================
--- linux.orig/include/acpi/acpi_bus.h
+++ linux/include/acpi/acpi_bus.h
@@ -333,13 +333,51 @@ void acpi_bus_data_handler(acpi_handle h
 acpi_status acpi_bus_get_status_handle(acpi_handle handle,
 				       unsigned long long *sta);
 int acpi_bus_get_status(struct acpi_device *device);
+
+#ifdef CONFIG_PM
 int acpi_bus_set_power(acpi_handle handle, int state);
 const char *acpi_power_state_string(int state);
 int acpi_device_get_power(struct acpi_device *device, int *state);
 int acpi_device_set_power(struct acpi_device *device, int state);
+int acpi_bus_init_power(struct acpi_device *device);
 int acpi_bus_update_power(acpi_handle handle, int *state_p);
 bool acpi_bus_power_manageable(acpi_handle handle);
 bool acpi_bus_can_wakeup(acpi_handle handle);
+#else /* !CONFIG_PM */
+static inline int acpi_bus_set_power(acpi_handle handle, int state)
+{
+	return 0;
+}
+static inline const char *acpi_power_state_string(int state)
+{
+	return "D0";
+}
+static inline int acpi_device_get_power(struct acpi_device *device, int *state)
+{
+	return 0;
+}
+static inline int acpi_device_set_power(struct acpi_device *device, int state)
+{
+	return 0;
+}
+static inline int acpi_bus_init_power(struct acpi_device *device)
+{
+	return 0;
+}
+static inline int acpi_bus_update_power(acpi_handle handle, int *state_p)
+{
+	return 0;
+}
+static inline bool acpi_bus_power_manageable(acpi_handle handle)
+{
+	return false;
+}
+static inline bool acpi_bus_can_wakeup(acpi_handle handle)
+{
+	return false;
+}
+#endif /* !CONFIG_PM */
+
 #ifdef CONFIG_ACPI_PROC_EVENT
 int acpi_bus_generate_proc_event(struct acpi_device *device, u8 type, int data);
 int acpi_bus_generate_proc_event4(const char *class, const char *bid, u8 type, int data);
Index: linux/drivers/acpi/internal.h
===================================================================
--- linux.orig/drivers/acpi/internal.h
+++ linux/drivers/acpi/internal.h
@@ -61,7 +61,6 @@ int acpi_device_sleep_wake(struct acpi_d
 int acpi_power_get_inferred_state(struct acpi_device *device, int *state);
 int acpi_power_on_resources(struct acpi_device *device, int state);
 int acpi_power_transition(struct acpi_device *device, int state);
-int acpi_bus_init_power(struct acpi_device *device);
 
 int acpi_wakeup_device_init(void);
 void acpi_early_processor_set_pdc(void);
Index: linux/drivers/acpi/bus.c
===================================================================
--- linux.orig/drivers/acpi/bus.c
+++ linux/drivers/acpi/bus.c
@@ -178,299 +178,6 @@ int acpi_bus_get_private_data(acpi_handl
 }
 EXPORT_SYMBOL(acpi_bus_get_private_data);
 
-/* --------------------------------------------------------------------------
-                                 Power Management
-   -------------------------------------------------------------------------- */
-
-/**
- * acpi_power_state_string - String representation of ACPI device power state.
- * @state: ACPI device power state to return the string representation of.
- */
-const char *acpi_power_state_string(int state)
-{
-	switch (state) {
-	case ACPI_STATE_D0:
-		return "D0";
-	case ACPI_STATE_D1:
-		return "D1";
-	case ACPI_STATE_D2:
-		return "D2";
-	case ACPI_STATE_D3_HOT:
-		return "D3hot";
-	case ACPI_STATE_D3_COLD:
-		return "D3";
-	default:
-		return "(unknown)";
-	}
-}
-
-/**
- * acpi_device_get_power - Get power state of an ACPI device.
- * @device: Device to get the power state of.
- * @state: Place to store the power state of the device.
- *
- * This function does not update the device's power.state field, but it may
- * update its parent's power.state field (when the parent's power state is
- * unknown and the device's power state turns out to be D0).
- */
-int acpi_device_get_power(struct acpi_device *device, int *state)
-{
-	int result = ACPI_STATE_UNKNOWN;
-
-	if (!device || !state)
-		return -EINVAL;
-
-	if (!device->flags.power_manageable) {
-		/* TBD: Non-recursive algorithm for walking up hierarchy. */
-		*state = device->parent ?
-			device->parent->power.state : ACPI_STATE_D0;
-		goto out;
-	}
-
-	/*
-	 * Get the device's power state either directly (via _PSC) or
-	 * indirectly (via power resources).
-	 */
-	if (device->power.flags.explicit_get) {
-		unsigned long long psc;
-		acpi_status status = acpi_evaluate_integer(device->handle,
-							   "_PSC", NULL, &psc);
-		if (ACPI_FAILURE(status))
-			return -ENODEV;
-
-		result = psc;
-	}
-	/* The test below covers ACPI_STATE_UNKNOWN too. */
-	if (result <= ACPI_STATE_D2) {
-	  ; /* Do nothing. */
-	} else if (device->power.flags.power_resources) {
-		int error = acpi_power_get_inferred_state(device, &result);
-		if (error)
-			return error;
-	} else if (result == ACPI_STATE_D3_HOT) {
-		result = ACPI_STATE_D3;
-	}
-
-	/*
-	 * If we were unsure about the device parent's power state up to this
-	 * point, the fact that the device is in D0 implies that the parent has
-	 * to be in D0 too.
-	 */
-	if (device->parent && device->parent->power.state == ACPI_STATE_UNKNOWN
-	    && result == ACPI_STATE_D0)
-		device->parent->power.state = ACPI_STATE_D0;
-
-	*state = result;
-
- out:
-	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device [%s] power state is %s\n",
-			  device->pnp.bus_id, acpi_power_state_string(*state)));
-
-	return 0;
-}
-
-
-/**
- * acpi_device_set_power - Set power state of an ACPI device.
- * @device: Device to set the power state of.
- * @state: New power state to set.
- *
- * Callers must ensure that the device is power manageable before using this
- * function.
- */
-int acpi_device_set_power(struct acpi_device *device, int state)
-{
-	int result = 0;
-	acpi_status status = AE_OK;
-	char object_name[5] = { '_', 'P', 'S', '0' + state, '\0' };
-	bool cut_power = false;
-
-	if (!device || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3_COLD))
-		return -EINVAL;
-
-	/* Make sure this is a valid target state */
-
-	if (state == device->power.state) {
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device is already at %s\n",
-				  acpi_power_state_string(state)));
-		return 0;
-	}
-
-	if (!device->power.states[state].flags.valid) {
-		printk(KERN_WARNING PREFIX "Device does not support %s\n",
-		       acpi_power_state_string(state));
-		return -ENODEV;
-	}
-	if (device->parent && (state < device->parent->power.state)) {
-		printk(KERN_WARNING PREFIX
-			      "Cannot set device to a higher-powered"
-			      " state than parent\n");
-		return -ENODEV;
-	}
-
-	/* For D3cold we should first transition into D3hot. */
-	if (state == ACPI_STATE_D3_COLD
-	    && device->power.states[ACPI_STATE_D3_COLD].flags.os_accessible) {
-		state = ACPI_STATE_D3_HOT;
-		object_name[3] = '3';
-		cut_power = true;
-	}
-
-	/*
-	 * Transition Power
-	 * ----------------
-	 * On transitions to a high-powered state we first apply power (via
-	 * power resources) then evalute _PSx.  Conversly for transitions to
-	 * a lower-powered state.
-	 */
-	if (state < device->power.state) {
-		if (device->power.state >= ACPI_STATE_D3_HOT &&
-		    state != ACPI_STATE_D0) {
-			printk(KERN_WARNING PREFIX
-			      "Cannot transition to non-D0 state from D3\n");
-			return -ENODEV;
-		}
-		if (device->power.flags.power_resources) {
-			result = acpi_power_transition(device, state);
-			if (result)
-				goto end;
-		}
-		if (device->power.states[state].flags.explicit_set) {
-			status = acpi_evaluate_object(device->handle,
-						      object_name, NULL, NULL);
-			if (ACPI_FAILURE(status)) {
-				result = -ENODEV;
-				goto end;
-			}
-		}
-	} else {
-		if (device->power.states[state].flags.explicit_set) {
-			status = acpi_evaluate_object(device->handle,
-						      object_name, NULL, NULL);
-			if (ACPI_FAILURE(status)) {
-				result = -ENODEV;
-				goto end;
-			}
-		}
-		if (device->power.flags.power_resources) {
-			result = acpi_power_transition(device, state);
-			if (result)
-				goto end;
-		}
-	}
-
-	if (cut_power)
-		result = acpi_power_transition(device, ACPI_STATE_D3_COLD);
-
-      end:
-	if (result)
-		printk(KERN_WARNING PREFIX
-			      "Device [%s] failed to transition to %s\n",
-			      device->pnp.bus_id,
-			      acpi_power_state_string(state));
-	else {
-		device->power.state = state;
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-				  "Device [%s] transitioned to %s\n",
-				  device->pnp.bus_id,
-				  acpi_power_state_string(state)));
-	}
-
-	return result;
-}
-EXPORT_SYMBOL(acpi_device_set_power);
-
-
-int acpi_bus_set_power(acpi_handle handle, int state)
-{
-	struct acpi_device *device;
-	int result;
-
-	result = acpi_bus_get_device(handle, &device);
-	if (result)
-		return result;
-
-	if (!device->flags.power_manageable) {
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-				"Device [%s] is not power manageable\n",
-				dev_name(&device->dev)));
-		return -ENODEV;
-	}
-
-	return acpi_device_set_power(device, state);
-}
-EXPORT_SYMBOL(acpi_bus_set_power);
-
-
-int acpi_bus_init_power(struct acpi_device *device)
-{
-	int state;
-	int result;
-
-	if (!device)
-		return -EINVAL;
-
-	device->power.state = ACPI_STATE_UNKNOWN;
-
-	result = acpi_device_get_power(device, &state);
-	if (result)
-		return result;
-
-	if (device->power.flags.power_resources)
-		result = acpi_power_on_resources(device, state);
-
-	if (!result)
-		device->power.state = state;
-
-	return result;
-}
-
-
-int acpi_bus_update_power(acpi_handle handle, int *state_p)
-{
-	struct acpi_device *device;
-	int state;
-	int result;
-
-	result = acpi_bus_get_device(handle, &device);
-	if (result)
-		return result;
-
-	result = acpi_device_get_power(device, &state);
-	if (result)
-		return result;
-
-	result = acpi_device_set_power(device, state);
-	if (!result && state_p)
-		*state_p = state;
-
-	return result;
-}
-EXPORT_SYMBOL_GPL(acpi_bus_update_power);
-
-
-bool acpi_bus_power_manageable(acpi_handle handle)
-{
-	struct acpi_device *device;
-	int result;
-
-	result = acpi_bus_get_device(handle, &device);
-	return result ? false : device->flags.power_manageable;
-}
-
-EXPORT_SYMBOL(acpi_bus_power_manageable);
-
-bool acpi_bus_can_wakeup(acpi_handle handle)
-{
-	struct acpi_device *device;
-	int result;
-
-	result = acpi_bus_get_device(handle, &device);
-	return result ? false : device->wakeup.flags.valid;
-}
-
-EXPORT_SYMBOL(acpi_bus_can_wakeup);
-
 static void acpi_print_osc_error(acpi_handle handle,
 	struct acpi_osc_context *context, char *error)
 {

