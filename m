Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965229Ab0GPLMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 07:12:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43434 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965151Ab0GPLLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 07:11:42 -0400
From: Thomas Renninger <trenn@suse.de>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
        Alexey Starikovskiy <astarikovskiy@suse.de>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH 1/7] ACPI: Provide /sys/kernel/debug/ec/...
Date: Fri, 16 Jul 2010 13:11:31 +0200
Message-Id: <1279278697-3694-2-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1279278697-3694-1-git-send-email-trenn@suse.de>
References: <1279278697-3694-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides the same information through debugfs, which previously was
provided through /proc/acpi/embedded_controller/*/info

This is the gpe the EC is connected to and whether the global lock
gets used.
The io ports used are added to /proc/ioports in another patch.
Beside the fact that /proc/acpi is deprecated for quite some time,
this info is not needed for applications and thus can be moved
to debugfs instead of a public interface like /sys.

Signed-off-by: Thomas Renninger <trenn@suse.de>

CC: Alexey Starikovskiy <astarikovskiy@suse.de>
CC: Len Brown <lenb@kernel.org>
CC: linux-kernel@vger.kernel.org
CC: linux-acpi@vger.kernel.org
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: platform-driver-x86@vger.kernel.org
---
 drivers/acpi/Kconfig    |   13 ++++++++++
 drivers/acpi/Makefile   |    1 +
 drivers/acpi/ec.c       |   18 ++++----------
 drivers/acpi/ec_sys.c   |   57 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/internal.h |   24 +++++++++++++++++++
 5 files changed, 100 insertions(+), 13 deletions(-)
 create mode 100644 drivers/acpi/ec_sys.c

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 7464115..f7226d1 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -104,6 +104,19 @@ config ACPI_SYSFS_POWER
 	help
 	  Say N to disable power /sys interface
 
+config ACPI_EC_DEBUGFS
+	tristate "EC read/write access through /sys/kernel/debug/ec"
+	default y
+	help
+	  Say N to disable Embedded Controller /sys/kernel/debug interface
+
+	  An Embedded Controller typically is available on laptops and reads
+	  sensor values like battery state and temperature.
+	  The kernel access the EC through ACPI parsed code provided by BIOS
+	  tables.
+	  Thus this option is a debug option that helps to write ACPI drivers
+	  and can be used to identify ACPI code or EC firmware bugs.
+
 config ACPI_PROC_EVENT
 	bool "Deprecated /proc/acpi/event support"
 	depends on PROC_FS
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 6ee3316..833b582 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -60,6 +60,7 @@ obj-$(CONFIG_ACPI_SBS)		+= sbshc.o
 obj-$(CONFIG_ACPI_SBS)		+= sbs.o
 obj-$(CONFIG_ACPI_POWER_METER)	+= power_meter.o
 obj-$(CONFIG_ACPI_HED)		+= hed.o
+obj-$(CONFIG_ACPI_EC_DEBUGFS)	+= ec_sys.o
 
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
index 0000000..834c21a
--- /dev/null
+++ b/drivers/acpi/ec_sys.c
@@ -0,0 +1,57 @@
+#include <linux/kernel.h>
+#include <linux/acpi.h>
+#include <linux/debugfs.h>
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
+static struct dentry *acpi_ec_debugfs_dir;
+
+int acpi_ec_add_debugfs(struct acpi_ec *ec, unsigned int ec_device_count)
+{
+	struct dentry *dev_dir;
+	char name[64];
+	if (ec_device_count == 0) {
+		acpi_ec_debugfs_dir = debugfs_create_dir("ec", NULL);
+		if (!acpi_ec_debugfs_dir)
+			return -ENOMEM;
+	}
+
+	sprintf(name, "ec%u", ec_device_count);
+	dev_dir = debugfs_create_dir(name, acpi_ec_debugfs_dir);
+	if (!dev_dir) {
+		if (ec_device_count == 0)
+			debugfs_remove_recursive(acpi_ec_debugfs_dir);
+		/* TBD: Proper cleanup for multiple ECs */
+		return -ENOMEM;
+	}
+
+	debugfs_create_x32("gpe", 0444, dev_dir, (u32 *)&first_ec->gpe);
+	debugfs_create_bool("use_global_lock", 0444, dev_dir,
+			    (u32 *)&first_ec->global_lock);
+	return 0;
+}
+
+static int __init acpi_ec_sys_init(void)
+{
+	int err = 0;
+	if (first_ec)
+		err = acpi_ec_add_debugfs(first_ec, 0);
+	else
+		err = -ENODEV;
+	return err;
+}
+
+static void __exit acpi_ec_sys_exit(void)
+{
+	debugfs_remove_recursive(acpi_ec_debugfs_dir);
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

