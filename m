Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab3ADAH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:07:57 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:59166 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab3ADAHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:07:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 8/12] ACPI / scan: Move power state initialization to a separate routine
Date: Fri, 04 Jan 2013 01:07:05 +0100
Message-ID: <3426685.zRWDP3qKqq@vostro.rjw.lan>
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

To reduce indentation level and improve code readability, move the
initialization code related to device power states from
acpi_bus_get_power_flags() to a new routine,
acpi_bus_init_power_state().

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |   87 +++++++++++++++++++++++++++-------------------------
 1 file changed, 46 insertions(+), 41 deletions(-)

Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -1045,6 +1045,50 @@ static void acpi_bus_get_wakeup_device_f
 				"error in _DSW or _PSW evaluation\n"));
 }
 
+static void acpi_bus_init_power_state(struct acpi_device *device, int state)
+{
+	struct acpi_device_power_state *ps = &device->power.states[state];
+	char object_name[5] = { '_', 'P', 'R', '0' + state, '\0' };
+	struct acpi_handle_list resources;
+	acpi_handle handle;
+	acpi_status status;
+
+	INIT_LIST_HEAD(&ps->resources);
+
+	/* Evaluate "_PRx" to se if power resources are referenced */
+	acpi_evaluate_reference(device->handle, object_name, NULL, &resources);
+	if (resources.count) {
+		int j;
+
+		device->power.flags.power_resources = 1;
+		for (j = 0; j < resources.count; j++) {
+			acpi_handle rhandle = resources.handles[j];
+
+			acpi_add_power_resource(rhandle);
+			acpi_power_resources_list_add(rhandle, &ps->resources);
+		}
+	}
+
+	/* Evaluate "_PSx" to see if we can do explicit sets */
+	object_name[2] = 'S';
+	status = acpi_get_handle(device->handle, object_name, &handle);
+	if (ACPI_SUCCESS(status))
+		ps->flags.explicit_set = 1;
+
+	/*
+	 * State is valid if there are means to put the device into it.
+	 * D3hot is only valid if _PR3 present.
+	 */
+	if (resources.count
+	    || (ps->flags.explicit_set && state < ACPI_STATE_D3_HOT)) {
+		ps->flags.valid = 1;
+		ps->flags.os_accessible = 1;
+	}
+
+	ps->power = -1;		/* Unknown - driver assigned */
+	ps->latency = -1;	/* Unknown - driver assigned */
+}
+
 static void acpi_bus_get_power_flags(struct acpi_device *device)
 {
 	acpi_status status = 0;
@@ -1074,47 +1118,8 @@ static void acpi_bus_get_power_flags(str
 	/*
 	 * Enumerate supported power management states
 	 */
-	for (i = ACPI_STATE_D0; i <= ACPI_STATE_D3_HOT; i++) {
-		struct acpi_device_power_state *ps = &device->power.states[i];
-		char object_name[5] = { '_', 'P', 'R', '0' + i, '\0' };
-		struct acpi_handle_list resources;
-
-		INIT_LIST_HEAD(&ps->resources);
-		/* Evaluate "_PRx" to se if power resources are referenced */
-		acpi_evaluate_reference(device->handle, object_name, NULL,
-					&resources);
-		if (resources.count) {
-			int j;
-
-			device->power.flags.power_resources = 1;
-			for (j = 0; j < resources.count; j++) {
-				acpi_handle rhandle = resources.handles[j];
-
-				acpi_add_power_resource(rhandle);
-				acpi_power_resources_list_add(rhandle,
-							      &ps->resources);
-			}
-		}
-
-		/* Evaluate "_PSx" to see if we can do explicit sets */
-		object_name[2] = 'S';
-		status = acpi_get_handle(device->handle, object_name, &handle);
-		if (ACPI_SUCCESS(status))
-			ps->flags.explicit_set = 1;
-
-		/*
-		 * State is valid if there are means to put the device into it.
-		 * D3hot is only valid if _PR3 present.
-		 */
-		if (resources.count ||
-		    (ps->flags.explicit_set && i < ACPI_STATE_D3_HOT)) {
-			ps->flags.valid = 1;
-			ps->flags.os_accessible = 1;
-		}
-
-		ps->power = -1;	/* Unknown - driver assigned */
-		ps->latency = -1;	/* Unknown - driver assigned */
-	}
+	for (i = ACPI_STATE_D0; i <= ACPI_STATE_D3_HOT; i++)
+		acpi_bus_init_power_state(device, i);
 
 	INIT_LIST_HEAD(&device->power.states[ACPI_STATE_D3_COLD].resources);
 

