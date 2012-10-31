Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab2JaJe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:34:26 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:48161 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab2JaJeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:34:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Huang Ying <ying.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 list <x86@kernel.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH 2/5] ACPI: Provide generic functions for matching ACPI device nodes
Date: Wed, 31 Oct 2012 10:33:38 +0100
Message-ID: <7917960.sQJPenFZz7@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1421417.rIOjExM5Pt@vostro.rjw.lan>
References: <1421417.rIOjExM5Pt@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

Introduce function acpi_match_device() allowing callers to match
struct device objects with populated acpi_handle fields against
arrays of ACPI device IDs.  Also introduce function
acpi_driver_match_device() using acpi_match_device() internally and
allowing callers to match a struct device object against an array of
ACPI device IDs provided by a device driver.

Additionally, introduce macro ACPI_PTR() that may be used by device
drivers to escape pointers to data structures whose definitions
depend on CONFIG_ACPI.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c  |   40 +++++++++++++++++++++++++++++++++++-----
 include/linux/acpi.h |   28 ++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 5 deletions(-)

Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -372,8 +372,8 @@ static void acpi_device_remove_files(str
 			ACPI Bus operations
    -------------------------------------------------------------------------- */
 
-int acpi_match_device_ids(struct acpi_device *device,
-			  const struct acpi_device_id *ids)
+static const struct acpi_device_id *__acpi_match_device(
+	struct acpi_device *device, const struct acpi_device_id *ids)
 {
 	const struct acpi_device_id *id;
 	struct acpi_hardware_id *hwid;
@@ -383,14 +383,44 @@ int acpi_match_device_ids(struct acpi_de
 	 * driver for it.
 	 */
 	if (!device->status.present)
-		return -ENODEV;
+		return NULL;
 
 	for (id = ids; id->id[0]; id++)
 		list_for_each_entry(hwid, &device->pnp.ids, list)
 			if (!strcmp((char *) id->id, hwid->id))
-				return 0;
+				return id;
+
+	return NULL;
+}
+
+/**
+ * acpi_match_device - Match a struct device against a given list of ACPI IDs
+ * @ids: Array of struct acpi_device_id object to match against.
+ * @dev: The device structure to match.
+ *
+ * Check if @dev has a valid ACPI handle and if there is a struct acpi_device
+ * object for that handle and use that object to match against a given list of
+ * device IDs.
+ *
+ * Return a pointer to the first matching ID on success or %NULL on failure.
+ */
+const struct acpi_device_id *acpi_match_device(const struct acpi_device_id *ids,
+					       const struct device *dev)
+{
+	struct acpi_device *adev;
 
-	return -ENOENT;
+	if (!ids || !dev->acpi_handle
+	    || ACPI_FAILURE(acpi_bus_get_device(dev->acpi_handle, &adev)))
+		return NULL;
+
+	return __acpi_match_device(adev, ids);
+}
+EXPORT_SYMBOL_GPL(acpi_match_device);
+
+int acpi_match_device_ids(struct acpi_device *device,
+			  const struct acpi_device_id *ids)
+{
+	return __acpi_match_device(device, ids) ? 0 : -ENOENT;
 }
 EXPORT_SYMBOL(acpi_match_device_ids);
 
Index: linux/include/linux/acpi.h
===================================================================
--- linux.orig/include/linux/acpi.h
+++ linux/include/linux/acpi.h
@@ -26,6 +26,7 @@
 #define _LINUX_ACPI_H
 
 #include <linux/ioport.h>	/* for struct resource */
+#include <linux/device.h>
 
 #ifdef	CONFIG_ACPI
 
@@ -368,6 +369,17 @@ extern int acpi_nvs_register(__u64 start
 extern int acpi_nvs_for_each_region(int (*func)(__u64, __u64, void *),
 				    void *data);
 
+const struct acpi_device_id *acpi_match_device(const struct acpi_device_id *ids,
+					       const struct device *dev);
+
+static inline bool acpi_driver_match_device(struct device *dev,
+					    const struct device_driver *drv)
+{
+	return !!acpi_match_device(drv->acpi_match_table, dev);
+}
+
+#define ACPI_PTR(_ptr)	(_ptr)
+
 #else	/* !CONFIG_ACPI */
 
 #define acpi_disabled 1
@@ -422,6 +434,22 @@ static inline int acpi_nvs_for_each_regi
 	return 0;
 }
 
+struct acpi_device_id;
+
+static inline const struct acpi_device_id *acpi_match_device(
+	const struct acpi_device_id *ids, const struct device *dev)
+{
+	return NULL;
+}
+
+static inline bool acpi_driver_match_device(struct device *dev,
+					    const struct device_driver *drv)
+{
+	return false;
+}
+
+#define ACPI_PTR(_ptr)	(NULL)
+
 #endif	/* !CONFIG_ACPI */
 
 #ifdef CONFIG_ACPI

