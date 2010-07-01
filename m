Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab0GAPC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:02:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:50884 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756544Ab0GAPCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:02:54 -0400
From: Thomas Renninger <trenn@suse.de>
To: lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       platform-driver-x86@vger.kernel.org, astarikovskiy@suse.de,
       Thomas Renninger <trenn@suse.de>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH 1/6] ACPI: Provide /sys/devices/system/ec/
Date: Thu,  1 Jul 2010 17:02:45 +0200
Message-Id: <1277996570-2686-2-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1277996570-2686-1-git-send-email-trenn@suse.de>
References: <1277996570-2686-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides the same information through sysfs, which previously was
provided through /proc/acpi/embedded_controller/*/info

Signed-off-by: Thomas Renninger <trenn@suse.de>

CC: Alexey Starikovskiy <astarikovskiy@suse.de>
CC: Len Brown <lenb@kernel.org>
CC: linux-kernel@vger.kernel.org
CC: linux-acpi@vger.kernel.org
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: platform-driver-x86@vger.kernel.org

Index: linux-2.6.34-master/drivers/acpi/Kconfig
===================================================================
---
 drivers/acpi/Kconfig    |   13 +++++++
 drivers/acpi/Makefile   |    1 +
 drivers/acpi/ec.c       |   18 +++-------
 drivers/acpi/ec_sys.c   |   92 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/internal.h |   24 ++++++++++++
 5 files changed, 135 insertions(+), 13 deletions(-)
 create mode 100644 drivers/acpi/ec_sys.c

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 7464115..f13708a 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -104,6 +104,19 @@ config ACPI_SYSFS_POWER
 	help
 	  Say N to disable power /sys interface
 
+config ACPI_EC_SYSFS
+	tristate "EC read/write access through sysfs"
+	default y
+	help
+	  Say N to disable Embedded Controller /sys interface
+
+	  An Embedded Controller typically is available on laptops and reads
+	  sensor values like battery state and temperature.
+	  The kernel access the EC through ACPI parsed code provided by BIOS
+	  tables.
+	  Thus this option is a debug option that helps to write ACPI drivers
+	  and which can be used to identify ACPI code or EC firmware bugs.
+
 config ACPI_PROC_EVENT
 	bool "Deprecated /proc/acpi/event support"
 	depends on PROC_FS
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 6ee3316..a33a2ef 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -60,6 +60,7 @@ obj-$(CONFIG_ACPI_SBS)		+= sbshc.o
 obj-$(CONFIG_ACPI_SBS)		+= sbs.o
 obj-$(CONFIG_ACPI_POWER_METER)	+= power_meter.o
 obj-$(CONFIG_ACPI_HED)		+= hed.o
+obj-$(CONFIG_ACPI_EC_SYSFS)     += ec_sys.o
 
 # processor has its own "processor." module_param namespace
 processor-y			:= processor_driver.o processor_throttling.o
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 1e6d418..4b6759f 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -45,10 +45,13 @@
 #include <acpi/acpi_drivers.h>
 #include <linux/dmi.h>
 
+#include "internal.h"
+
 #define ACPI_EC_CLASS			"embedded_controller"
 #define ACPI_EC_DEVICE_NAME		"Embedded Controller"
 #define ACPI_EC_FILE_INFO		"info"
 
+#undef PREFIX
 #define PREFIX				"ACPI: EC: "
 
 /* EC status register */
@@ -106,19 +109,8 @@ struct transaction {
 	bool done;
 };
 
-static struct acpi_ec {
-	acpi_handle handle;
-	unsigned long gpe;
-	unsigned long command_addr;
-	unsigned long data_addr;
-	unsigned long global_lock;
-	unsigned long flags;
-	struct mutex lock;
-	wait_queue_head_t wait;
-	struct list_head list;
-	struct transaction *curr;
-	spinlock_t curr_lock;
-} *boot_ec, *first_ec;
+struct acpi_ec *boot_ec, *first_ec;
+EXPORT_SYMBOL(first_ec);
 
 static int EC_FLAGS_MSI; /* Out-of-spec MSI controller */
 static int EC_FLAGS_VALIDATE_ECDT; /* ASUStec ECDTs need to be validated */
diff --git a/drivers/acpi/ec_sys.c b/drivers/acpi/ec_sys.c
new file mode 100644
index 0000000..c64236f
--- /dev/null
+++ b/drivers/acpi/ec_sys.c
@@ -0,0 +1,92 @@
+#include <linux/kernel.h>
+#include <linux/sysdev.h>
+#include <linux/acpi.h>
+
+#include "internal.h"
+
+MODULE_AUTHOR("Thomas Renninger <trenn@suse.de>");
+MODULE_DESCRIPTION("ACPI EC sysfs access driver");
+MODULE_LICENSE("GPL");
+
+struct sysdev_class acpi_ec_sysdev_class = {
+	.name = "ec",
+};
+
+/* sys_dev -> per EC device stuff */
+static ssize_t show_ec_gpe(struct sys_device *dev,
+			   struct sysdev_attribute *attr,
+			   char *buf)
+{
+	struct acpi_ec *ec = container_of(dev, struct acpi_ec, sysdev);
+	return sprintf(buf, "%lu\n", ec->gpe);
+}
+
+static ssize_t show_ec_global_lock(struct sys_device *dev,
+				   struct sysdev_attribute *attr,
+				   char *buf)
+{
+	struct acpi_ec *ec = container_of(dev, struct acpi_ec, sysdev);
+	return sprintf(buf, "%s\n", ec->global_lock ? "yes" : "no");
+}
+
+SYSDEV_ATTR(gpe, 0444, show_ec_gpe, NULL);
+SYSDEV_ATTR(use_global_lock, 0444, show_ec_global_lock, NULL);
+
+int acpi_ec_add_sysfs(struct acpi_ec *ec, int ec_device_count)
+{
+	int err = 0;
+
+	if (ec_device_count == 0) {
+		err = sysdev_class_register(&acpi_ec_sysdev_class);
+		if (err)
+			return err;
+	}
+
+	ec->sysdev.id = ec_device_count;
+	ec->sysdev.cls = &acpi_ec_sysdev_class;
+	err = sysdev_register(&ec->sysdev);
+	if (err)
+		goto sysdev_err;
+	err = sysdev_create_file(&ec->sysdev, &attr_use_global_lock);
+	if (err)
+		goto file_err_1;
+	err = sysdev_create_file(&ec->sysdev, &attr_gpe);
+	if (err)
+		goto file_err_2;
+	return err;
+
+ file_err_2:
+	sysdev_remove_file(&ec->sysdev, &attr_use_global_lock);
+ file_err_1:
+	sysdev_class_unregister(&acpi_ec_sysdev_class);
+ sysdev_err:
+	sysdev_class_register(&acpi_ec_sysdev_class);
+	return err;
+}
+
+void acpi_ec_remove_sysfs(struct acpi_ec *ec)
+{
+	sysdev_remove_file(&ec->sysdev, &attr_use_global_lock);
+	sysdev_remove_file(&ec->sysdev, &attr_gpe);
+
+	sysdev_unregister(&ec->sysdev);
+	sysdev_class_unregister(&acpi_ec_sysdev_class);
+}
+
+static int __init acpi_ec_sys_init(void)
+{
+	int err = 0;
+	if (first_ec)
+		err = acpi_ec_add_sysfs(first_ec, 0);
+	else
+		err = -ENODEV;
+	return err;
+}
+
+static void __exit acpi_ec_sys_exit(void)
+{
+	acpi_ec_remove_sysfs(first_ec);
+}
+
+module_init(acpi_ec_sys_init);
+module_exit(acpi_ec_sys_exit);
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index f8f190e..8ae2726 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -18,6 +18,11 @@
  * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
+#ifndef _ACPI_INTERNAL_H_
+#define _ACPI_INTERNAL_H_
+
+#include <linux/sysdev.h>
+
 #define PREFIX "ACPI: "
 
 int init_acpi_device_notify(void);
@@ -46,6 +51,23 @@ void acpi_early_processor_set_pdc(void);
 /* --------------------------------------------------------------------------
                                   Embedded Controller
    -------------------------------------------------------------------------- */
+struct acpi_ec {
+	acpi_handle handle;
+	unsigned long gpe;
+	unsigned long command_addr;
+	unsigned long data_addr;
+	unsigned long global_lock;
+	unsigned long flags;
+	struct mutex lock;
+	wait_queue_head_t wait;
+	struct list_head list;
+	struct transaction *curr;
+	spinlock_t curr_lock;
+	struct sys_device sysdev;
+};
+
+extern struct acpi_ec *first_ec;
+
 int acpi_ec_init(void);
 int acpi_ec_ecdt_probe(void);
 int acpi_boot_ec_enable(void);
@@ -63,3 +85,5 @@ int acpi_sleep_proc_init(void);
 #else
 static inline int acpi_sleep_proc_init(void) { return 0; }
 #endif
+
+#endif /* _ACPI_INTERNAL_H_ */
-- 
1.6.3

