Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab3ADV7C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 16:59:02 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:60464 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865Ab3ADV6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 16:58:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Huang Ying <ying.huang@intel.com>
Subject: [PATCH 3/6] ACPI / PM: Common string representations of device power states
Date: Fri, 04 Jan 2013 23:02:18 +0100
Message-ID: <5284267.VuqCP1J6ZC@vostro.rjw.lan>
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

The function returning string representations of ACPI device power
states, state_string((), is now static, because it is only used
internally in drivers/acpi/bus.c.  However, it will be used outside
of that file going forward, so rename it to
acpi_power_state_string(), add a kerneldoc comment to it and add its
header to acpi_bus.h.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/bus.c      |   18 ++++++++++++------
 include/acpi/acpi_bus.h |    1 +
 2 files changed, 13 insertions(+), 6 deletions(-)

Index: linux/drivers/acpi/bus.c
===================================================================
--- linux.orig/drivers/acpi/bus.c
+++ linux/drivers/acpi/bus.c
@@ -182,7 +182,11 @@ EXPORT_SYMBOL(acpi_bus_get_private_data)
                                  Power Management
    -------------------------------------------------------------------------- */
 
-static const char *state_string(int state)
+/**
+ * acpi_power_state_string - String representation of ACPI device power state.
+ * @state: ACPI device power state to return the string representation of.
+ */
+const char *acpi_power_state_string(int state)
 {
 	switch (state) {
 	case ACPI_STATE_D0:
@@ -260,7 +264,7 @@ int acpi_device_get_power(struct acpi_de
 
  out:
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device [%s] power state is %s\n",
-			  device->pnp.bus_id, state_string(*state)));
+			  device->pnp.bus_id, acpi_power_state_string(*state)));
 
 	return 0;
 }
@@ -288,13 +292,13 @@ int acpi_device_set_power(struct acpi_de
 
 	if (state == device->power.state) {
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device is already at %s\n",
-				  state_string(state)));
+				  acpi_power_state_string(state)));
 		return 0;
 	}
 
 	if (!device->power.states[state].flags.valid) {
 		printk(KERN_WARNING PREFIX "Device does not support %s\n",
-		       state_string(state));
+		       acpi_power_state_string(state));
 		return -ENODEV;
 	}
 	if (device->parent && (state < device->parent->power.state)) {
@@ -362,12 +366,14 @@ int acpi_device_set_power(struct acpi_de
 	if (result)
 		printk(KERN_WARNING PREFIX
 			      "Device [%s] failed to transition to %s\n",
-			      device->pnp.bus_id, state_string(state));
+			      device->pnp.bus_id,
+			      acpi_power_state_string(state));
 	else {
 		device->power.state = state;
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 				  "Device [%s] transitioned to %s\n",
-				  device->pnp.bus_id, state_string(state)));
+				  device->pnp.bus_id,
+				  acpi_power_state_string(state)));
 	}
 
 	return result;
Index: linux/include/acpi/acpi_bus.h
===================================================================
--- linux.orig/include/acpi/acpi_bus.h
+++ linux/include/acpi/acpi_bus.h
@@ -334,6 +334,7 @@ acpi_status acpi_bus_get_status_handle(a
 				       unsigned long long *sta);
 int acpi_bus_get_status(struct acpi_device *device);
 int acpi_bus_set_power(acpi_handle handle, int state);
+const char *acpi_power_state_string(int state);
 int acpi_device_get_power(struct acpi_device *device, int *state);
 int acpi_device_set_power(struct acpi_device *device, int state);
 int acpi_bus_update_power(acpi_handle handle, int *state_p);

