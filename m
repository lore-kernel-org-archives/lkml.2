Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab2I1Hhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 03:37:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:36990 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299Ab2I1Hhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 03:37:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,499,1344236400"; 
   d="scan'208,223";a="215197569"
Message-ID: <1348817910.10877.321.camel@rui.sh.intel.com>
Subject: [RFC PATCH 1/6] Introduce acpi_match_device_id().
From: Zhang Rui <rui.zhang@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Len, Brown" <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Zhang, Rui" <rui.zhang@intel.com>
Date: Fri, 28 Sep 2012 15:38:30 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 72df5d1f51fb27a4ba7f70a3b07df759d32b8288 Mon Sep 17 00:00:00 2001
From: Zhang Rui <rui.zhang@intel.com>
Date: Thu, 27 Sep 2012 15:11:55 +0800
Subject: [RFC PATCH 1/6] Introduce acpi_match_device_id().

This API is used to check if a device id string is compatible
with an ACPI device,
either PNP id exported via _HID or compatible ids exported
via _CID control method.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/scan.c     |   22 ++++++++++++++++++++++
 include/acpi/acpi_bus.h |    6 ++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index d1ecca2..936a7c9 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -312,6 +312,28 @@ int acpi_match_device_ids(struct acpi_device *device,
 }
 EXPORT_SYMBOL(acpi_match_device_ids);
 
+int acpi_match_device_id(const struct device *dev, const char *id)
+{
+	acpi_handle handle = DEVICE_ACPI_HANDLE(dev);
+	struct acpi_device *device;
+	struct acpi_hardware_id *hwid;
+	acpi_status status;
+
+	if (!handle || !id)
+		return -ENODEV;
+
+	status = acpi_bus_get_device(handle, &device);
+	if (ACPI_FAILURE(status))
+		return -ENODEV;
+
+	list_for_each_entry(hwid, &device->pnp.ids, list)
+		if (!strcmp(id, hwid->id))
+			return 0;
+
+	return -ENODEV;
+}
+EXPORT_SYMBOL(acpi_match_device_id);
+
 static void acpi_free_ids(struct acpi_device *device)
 {
 	struct acpi_hardware_id *id, *tmp;
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index bde976e..8b5b124 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -378,6 +378,7 @@ int acpi_bus_start(struct acpi_device *device);
 acpi_status acpi_bus_get_ejd(acpi_handle handle, acpi_handle * ejd);
 int acpi_match_device_ids(struct acpi_device *device,
 			  const struct acpi_device_id *ids);
+int acpi_match_device_id(const struct device *, const char *);
 int acpi_create_dir(struct acpi_device *);
 void acpi_remove_dir(struct acpi_device *);
 
@@ -448,6 +449,11 @@ static inline int acpi_pm_device_sleep_wake(struct device *dev, bool enable)
 
 static inline int register_acpi_bus_type(void *bus) { return 0; }
 static inline int unregister_acpi_bus_type(void *bus) { return 0; }
+static inline int acpi_match_device_id(const struct device *device,
+					const char *name)
+{
+	return -ENODEV;
+}
 
 #endif				/* CONFIG_ACPI */
 
-- 
1.7.7.6



