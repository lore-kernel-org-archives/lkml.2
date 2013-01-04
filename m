Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab3ADAHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:07:30 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:59167 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225Ab3ADAHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:07:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/12] ACPI / PM: Take order attribute of wakeup power resources into account
Date: Fri, 04 Jan 2013 01:06:18 +0100
Message-ID: <2549581.i2np0zGKZs@vostro.rjw.lan>
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

ACPI power resources have an order attribute that should be taken
into account when turning them on and off, but it is not used now.

Modify the power resources management code to preserve the
spec-compliant ordering of wakeup power resources.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/power.c    |   44 ++++++++++++++++----------------------------
 drivers/acpi/scan.c     |   24 ++++++++++++++----------
 include/acpi/acpi_bus.h |    2 +-
 3 files changed, 31 insertions(+), 39 deletions(-)

Index: linux/include/acpi/acpi_bus.h
===================================================================
--- linux.orig/include/acpi/acpi_bus.h
+++ linux/include/acpi/acpi_bus.h
@@ -244,7 +244,7 @@ struct acpi_device_wakeup {
 	acpi_handle gpe_device;
 	u64 gpe_number;
 	u64 sleep_state;
-	struct acpi_handle_list resources;
+	struct list_head resources;
 	struct acpi_device_wakeup_flags flags;
 	int prepare_count;
 };
Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -485,6 +485,7 @@ static void acpi_free_power_resources_li
 {
 	int i;
 
+	acpi_power_resources_list_free(&device->wakeup.resources);
 	if (!device->flags.power_manageable)
 		return;
 
@@ -908,6 +909,8 @@ acpi_bus_extract_wakeup_device_power_pac
 	if (!wakeup)
 		return AE_BAD_PARAMETER;
 
+	INIT_LIST_HEAD(&wakeup->resources);
+
 	/* _PRW */
 	status = acpi_evaluate_object(handle, "_PRW", NULL, &buffer);
 	if (ACPI_FAILURE(status)) {
@@ -954,19 +957,17 @@ acpi_bus_extract_wakeup_device_power_pac
 	}
 	wakeup->sleep_state = element->integer.value;
 
-	if ((package->package.count - 2) > ACPI_MAX_HANDLES) {
-		status = AE_NO_MEMORY;
-		goto out;
-	}
-	wakeup->resources.count = package->package.count - 2;
-	for (i = 0; i < wakeup->resources.count; i++) {
-		element = &(package->package.elements[i + 2]);
+	for (i = 2; i < package->package.count; i++) {
+		acpi_handle rhandle;
+
+		element = &(package->package.elements[i]);
 		if (element->type != ACPI_TYPE_LOCAL_REFERENCE) {
 			status = AE_BAD_DATA;
 			goto out;
 		}
-
-		wakeup->resources.handles[i] = element->reference.handle;
+		rhandle = element->reference.handle;
+		acpi_add_power_resource(rhandle);
+		acpi_power_resources_list_add(rhandle, &wakeup->resources);
 	}
 
 	acpi_setup_gpe_for_wake(handle, wakeup->gpe_device, wakeup->gpe_number);
@@ -1024,6 +1025,7 @@ static void acpi_bus_get_wakeup_device_f
 	status = acpi_bus_extract_wakeup_device_power_package(device->handle,
 							      &device->wakeup);
 	if (ACPI_FAILURE(status)) {
+		acpi_power_resources_list_free(&device->wakeup.resources);
 		ACPI_EXCEPTION((AE_INFO, status, "Extracting _PRW package"));
 		return;
 	}
@@ -1513,9 +1515,11 @@ static acpi_status acpi_bus_check_add(ac
 		acpi_handle temp;
 
 		status = acpi_get_handle(handle, "_PRW", &temp);
-		if (ACPI_SUCCESS(status))
+		if (ACPI_SUCCESS(status)) {
 			acpi_bus_extract_wakeup_device_power_package(handle,
 								     &wakeup);
+			acpi_power_resources_list_free(&wakeup.resources);
+		}
 		return AE_CTRL_DEPTH;
 	}
 
Index: linux/drivers/acpi/power.c
===================================================================
--- linux.orig/drivers/acpi/power.c
+++ linux/drivers/acpi/power.c
@@ -469,7 +469,7 @@ int acpi_device_sleep_wake(struct acpi_d
  */
 int acpi_enable_wakeup_device_power(struct acpi_device *dev, int sleep_state)
 {
-	int i, err = 0;
+	int err = 0;
 
 	if (!dev || !dev->wakeup.flags.valid)
 		return -EINVAL;
@@ -479,24 +479,17 @@ int acpi_enable_wakeup_device_power(stru
 	if (dev->wakeup.prepare_count++)
 		goto out;
 
-	/* Open power resource */
-	for (i = 0; i < dev->wakeup.resources.count; i++) {
-		int ret = acpi_power_on(dev->wakeup.resources.handles[i]);
-		if (ret) {
-			printk(KERN_ERR PREFIX "Transition power state\n");
-			dev->wakeup.flags.valid = 0;
-			err = -ENODEV;
-			goto err_out;
-		}
+	err = acpi_power_on_list(&dev->wakeup.resources);
+	if (err) {
+		dev_err(&dev->dev, "Cannot turn wakeup power resources on\n");
+		dev->wakeup.flags.valid = 0;
+	} else {
+		/*
+		 * Passing 3 as the third argument below means the device may be
+		 * put into arbitrary power state afterward.
+		 */
+		err = acpi_device_sleep_wake(dev, 1, sleep_state, 3);
 	}
-
-	/*
-	 * Passing 3 as the third argument below means the device may be placed
-	 * in arbitrary power state afterwards.
-	 */
-	err = acpi_device_sleep_wake(dev, 1, sleep_state, 3);
-
- err_out:
 	if (err)
 		dev->wakeup.prepare_count = 0;
 
@@ -513,7 +506,7 @@ int acpi_enable_wakeup_device_power(stru
  */
 int acpi_disable_wakeup_device_power(struct acpi_device *dev)
 {
-	int i, err = 0;
+	int err = 0;
 
 	if (!dev || !dev->wakeup.flags.valid)
 		return -EINVAL;
@@ -534,15 +527,10 @@ int acpi_disable_wakeup_device_power(str
 	if (err)
 		goto out;
 
-	/* Close power resource */
-	for (i = 0; i < dev->wakeup.resources.count; i++) {
-		int ret = acpi_power_off(dev->wakeup.resources.handles[i]);
-		if (ret) {
-			printk(KERN_ERR PREFIX "Transition power state\n");
-			dev->wakeup.flags.valid = 0;
-			err = -ENODEV;
-			goto out;
-		}
+	err = acpi_power_off_list(&dev->wakeup.resources);
+	if (err) {
+		dev_err(&dev->dev, "Cannot turn wakeup power resources off\n");
+		dev->wakeup.flags.valid = 0;
 	}
 
  out:

