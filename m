Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab3ADV65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 16:58:57 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:60467 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934Ab3ADV6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 16:58:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Huang Ying <ying.huang@intel.com>
Subject: [PATCH 2/6] ACPI / PM: More visible function for retrieving device power states
Date: Fri, 04 Jan 2013 23:01:32 +0100
Message-ID: <2444054.uT8tz0M77e@vostro.rjw.lan>
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

The function used for retrieving ACPI device power states,
__acpi_bus_get_power(), is now static, because it is only used
internally in drivers/acpi/bus.c.  However, it will be used
outside of that file going forward, so rename it to
acpi_device_get_power(), in analogy with acpi_device_set_power(),
add a kerneldoc comment to it and add its header to acpi_bus.h.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/bus.c      |   15 ++++++++++++---
 include/acpi/acpi_bus.h |    1 +
 2 files changed, 13 insertions(+), 3 deletions(-)

Index: linux/drivers/acpi/bus.c
===================================================================
--- linux.orig/drivers/acpi/bus.c
+++ linux/drivers/acpi/bus.c
@@ -200,7 +200,16 @@ static const char *state_string(int stat
 	}
 }
 
-static int __acpi_bus_get_power(struct acpi_device *device, int *state)
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
 {
 	int result = ACPI_STATE_UNKNOWN;
 
@@ -397,7 +406,7 @@ int acpi_bus_init_power(struct acpi_devi
 
 	device->power.state = ACPI_STATE_UNKNOWN;
 
-	result = __acpi_bus_get_power(device, &state);
+	result = acpi_device_get_power(device, &state);
 	if (result)
 		return result;
 
@@ -421,7 +430,7 @@ int acpi_bus_update_power(acpi_handle ha
 	if (result)
 		return result;
 
-	result = __acpi_bus_get_power(device, &state);
+	result = acpi_device_get_power(device, &state);
 	if (result)
 		return result;
 
Index: linux/include/acpi/acpi_bus.h
===================================================================
--- linux.orig/include/acpi/acpi_bus.h
+++ linux/include/acpi/acpi_bus.h
@@ -334,6 +334,7 @@ acpi_status acpi_bus_get_status_handle(a
 				       unsigned long long *sta);
 int acpi_bus_get_status(struct acpi_device *device);
 int acpi_bus_set_power(acpi_handle handle, int state);
+int acpi_device_get_power(struct acpi_device *device, int *state);
 int acpi_device_set_power(struct acpi_device *device, int state);
 int acpi_bus_update_power(acpi_handle handle, int *state_p);
 bool acpi_bus_power_manageable(acpi_handle handle);

