Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab3ADAHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:07:10 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:59162 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797Ab3ADAHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:07:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/12] ACPI: Use system level attribute of wakeup power resources
Date: Fri, 04 Jan 2013 01:10:18 +0100
Message-ID: <4222987.iOLcPTWjtZ@vostro.rjw.lan>
User-Agent: KMail/4.9.4 (Linux/3.8.0-rc1+; KDE/4.9.4; x86_64; ; )
In-Reply-To: <1418767.4KIZOTK1lk@vostro.rjw.lan>
References: <1418767.4KIZOTK1lk@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The system level attribute of ACPI power resources is the lowest
system sleep level (S0, S2 etc.) in which the given resource can be
"on" (ACPI 5.0, Section 7.1).  On the other hand, wakeup power
resources have to be "on" for devices depending on them to be able to
signal wakeup.  Therefore devices cannot wake up the system from
sleep states higher than the minimum of the system level attributes
of their wakeup power resources.

Use the wakeup power resources' system level values to get the
deepest system sleep state (highest system sleep level) the given
device can wake up the system from.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/internal.h |    1 +
 drivers/acpi/power.c    |   14 ++++++++++++++
 drivers/acpi/scan.c     |   11 +++++++++++
 3 files changed, 26 insertions(+)

Index: linux/drivers/acpi/internal.h
===================================================================
--- linux.orig/drivers/acpi/internal.h
+++ linux/drivers/acpi/internal.h
@@ -55,6 +55,7 @@ int acpi_extract_power_resources(union a
 				 struct list_head *list);
 int acpi_add_power_resource(acpi_handle handle);
 void acpi_power_add_remove_device(struct acpi_device *adev, bool add);
+int acpi_power_min_system_level(struct list_head *list);
 int acpi_device_sleep_wake(struct acpi_device *dev,
                            int enable, int sleep_state, int dev_state);
 int acpi_power_get_inferred_state(struct acpi_device *device, int *state);
Index: linux/drivers/acpi/power.c
===================================================================
--- linux.orig/drivers/acpi/power.c
+++ linux/drivers/acpi/power.c
@@ -429,6 +429,20 @@ void acpi_power_add_remove_device(struct
 	}
 }
 
+int acpi_power_min_system_level(struct list_head *list)
+{
+	struct acpi_power_resource_entry *entry;
+	int system_level = 5;
+
+	list_for_each_entry(entry, list, node) {
+		struct acpi_power_resource *resource = entry->resource;
+
+		if (system_level > resource->system_level)
+			system_level = resource->system_level;
+	}
+	return system_level;
+}
+
 /* --------------------------------------------------------------------------
                              Device Power Management
    -------------------------------------------------------------------------- */
Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -954,6 +954,17 @@ static int acpi_bus_extract_wakeup_devic
 	if (err)
 		goto out;
 
+	if (!list_empty(&wakeup->resources)) {
+		int sleep_state;
+
+		sleep_state = acpi_power_min_system_level(&wakeup->resources);
+		if (sleep_state < wakeup->sleep_state) {
+			acpi_handle_warn(handle, "Overriding _PRW sleep state "
+					 "(S%d) by S%d from power resources\n",
+				 	 (int)wakeup->sleep_state, sleep_state);
+			wakeup->sleep_state = sleep_state;
+		}
+	}
 	acpi_setup_gpe_for_wake(handle, wakeup->gpe_device, wakeup->gpe_number);
 
  out:

