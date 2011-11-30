Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125Ab1K3RXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 12:23:17 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:61266 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab1K3RVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 12:21:50 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: ke.yu@intel.com, kevin.tian@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org, rjw@sisk.pl
Cc: xen-devel@lists.xensource.com, jeremy@goop.org, konrad@kernel.org,
        stefan.bader@canonical.com, Ian.Campbell@citrix.com,
        mike.mcclurg@citrix.com, liang.tang@oracle.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/8] ACPI: processor: add __acpi_processor_[un]register_driver helpers.
Date: Wed, 30 Nov 2011 12:20:59 -0500
Message-Id: <1322673664-14642-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322673664-14642-1-git-send-email-konrad.wilk@oracle.com>
References: <1322673664-14642-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4ED66623.006A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tang Liang <liang.tang@oracle.com>

This patch implement __acpi_processor_[un]register_driver helper,
so we can registry override processor driver function. Specifically
the Xen processor driver.

By default the values are set to the native one.

Signed-off-by: Tang Liang <liang.tang@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/acpi/processor_driver.c |   35 +++++++++++++++++++++++++++++------
 include/acpi/processor.h        |    6 +++++-
 2 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 211c078..55f0b89 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -90,6 +90,11 @@ static const struct acpi_device_id processor_device_ids[] = {
 };
 MODULE_DEVICE_TABLE(acpi, processor_device_ids);
 
+int (*__acpi_processor_register_driver)(void) = acpi_processor_register_driver;
+void (*__acpi_processor_unregister_driver)(void) \
+	= acpi_processor_unregister_driver;
+
+
 static struct acpi_driver acpi_processor_driver = {
 	.name = "processor",
 	.class = ACPI_PROCESSOR_CLASS,
@@ -779,6 +784,22 @@ void acpi_processor_uninstall_hotplug_notify(void)
 	unregister_hotcpu_notifier(&acpi_cpu_notifier);
 }
 
+int acpi_processor_register_driver(void)
+{
+	int result = 0;
+
+	result = acpi_bus_register_driver(&acpi_processor_driver);
+	return result;
+}
+
+void acpi_processor_unregister_driver(void)
+{
+	acpi_bus_unregister_driver(&acpi_processor_driver);
+
+	cpuidle_unregister_driver(&acpi_idle_driver);
+
+	return;
+}
 /*
  * We keep the driver loaded even when ACPI is not running.
  * This is needed for the powernow-k8 driver, that works even without
@@ -794,9 +815,11 @@ static int __init acpi_processor_init(void)
 
 	memset(&errata, 0, sizeof(errata));
 
-	result = acpi_bus_register_driver(&acpi_processor_driver);
-	if (result < 0)
-		return result;
+	if (__acpi_processor_register_driver) {
+		result = __acpi_processor_register_driver();
+		if (result < 0)
+			return result;
+	}
 
 	acpi_processor_install_hotplug_notify();
 
@@ -809,6 +832,7 @@ static int __init acpi_processor_init(void)
 	return 0;
 }
 
+
 static void __exit acpi_processor_exit(void)
 {
 	if (acpi_disabled)
@@ -820,9 +844,8 @@ static void __exit acpi_processor_exit(void)
 
 	acpi_processor_uninstall_hotplug_notify();
 
-	acpi_bus_unregister_driver(&acpi_processor_driver);
-
-	cpuidle_unregister_driver(&acpi_idle_driver);
+	if (__acpi_processor_unregister_driver)
+		__acpi_processor_unregister_driver();
 
 	return;
 }
diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index bd99fb6..969cbc9 100644
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -225,6 +225,9 @@ struct acpi_processor_errata {
 	} piix4;
 };
 
+extern int (*__acpi_processor_register_driver)(void);
+extern void (*__acpi_processor_unregister_driver)(void);
+
 extern int acpi_processor_preregister_performance(struct
 						  acpi_processor_performance
 						  __percpu *performance);
@@ -242,7 +245,8 @@ int acpi_processor_notify_smm(struct module *calling_module);
 
 void acpi_processor_install_hotplug_notify(void);
 void acpi_processor_uninstall_hotplug_notify(void);
-
+int acpi_processor_register_driver(void);
+void acpi_processor_unregister_driver(void);
 int acpi_processor_add(struct acpi_device *device);
 int acpi_processor_remove(struct acpi_device *device, int type);
 void acpi_processor_notify(struct acpi_device *device, u32 event);
-- 
1.7.7.3

