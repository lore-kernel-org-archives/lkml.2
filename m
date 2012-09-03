Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab2ICV1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 17:27:19 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:49444 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab2ICV1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 17:27:17 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ashok Raj <ashok.raj@intel.com>, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] ACPI:  Enable SCI_EMULATE to manually simulate physical hotplug testing.
Date: Mon,  3 Sep 2012 14:27:03 -0700
Message-Id: <1346707623-31476-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ashok Raj <ashok.raj@intel.com>

Emulate an ACPI SCI interrupt to emulate a hot-plug event. Useful
for testing ACPI based hot-plug on systems that don't have the
necessary firmware support.

Enable CONFIG_ACPI_SCI_EMULATE on kernel compile.

Now you will notice /sys/kernel/debug/acpi/sci_notify when new kernel is
booted.

echo "\_SB.PCIB 1" > /sys/kernel/debug/acpi/sci_notify to trigger a hot-add
of root bus that is corresponding to PCIB.

echo "\_SB.PCIB 3" > /sys/kernel/debug/acpi/sci_notify to trigger a hot-remove
of root bus that is corresponding to PCIB.

-v2: Update to current upstream, and remove not related stuff.
-v3: According to Len's request, update it to use debugfs.  - Yinghai Lu

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org

===================================================================
---
 drivers/acpi/Kconfig   |   10 +++
 drivers/acpi/Makefile  |    1 
 drivers/acpi/sci_emu.c |  145 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 156 insertions(+)

Index: linux-2.6/drivers/acpi/Kconfig
===================================================================
--- linux-2.6.orig/drivers/acpi/Kconfig
+++ linux-2.6/drivers/acpi/Kconfig
@@ -272,6 +272,16 @@ config ACPI_BLACKLIST_YEAR
 	  Enter 0 to disable this mechanism and allow ACPI to
 	  run by default no matter what the year.  (default)
 
+config ACPI_SCI_EMULATE
+        bool "ACPI SCI Event Emulation Support"
+        depends on DEBUG_FS
+	default n
+	help
+	  This will enable your system to emulate sci hotplug event
+	  notification through proc file system. For example user needs to
+	  echo "XXX 0" > /sys/kernel/debug/acpi/sci_notify (where, XXX is
+	  a target ACPI device object name present under \_SB scope).
+
 config ACPI_DEBUG
 	bool "Debug Statements"
 	default n
Index: linux-2.6/drivers/acpi/sci_emu.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/acpi/sci_emu.c
@@ -0,0 +1,145 @@
+/*
+ *  Code to emulate SCI interrupt for Hotplug node insertion/removal
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/uaccess.h>
+#include <linux/debugfs.h>
+#include <acpi/acpi_drivers.h>
+
+#include "internal.h"
+
+#include "acpica/accommon.h"
+#include "acpica/acnamesp.h"
+#include "acpica/acevents.h"
+
+#define _COMPONENT		ACPI_SYSTEM_COMPONENT
+ACPI_MODULE_NAME("sci_emu");
+MODULE_LICENSE("GPL");
+
+static struct dentry *sci_notify_dentry;
+
+static void sci_notify_client(char *acpi_name, u32 event)
+{
+	struct acpi_namespace_node *node;
+	acpi_status status, status1;
+	acpi_handle hlsb, hsb;
+	union acpi_operand_object *obj_desc;
+
+	status = acpi_get_handle(NULL, "\\_SB", &hsb);
+	status1 = acpi_get_handle(hsb, acpi_name, &hlsb);
+	if (ACPI_FAILURE(status) || ACPI_FAILURE(status1)) {
+		pr_err(PREFIX
+	"acpi getting handle to <\\_SB.%s> failed inside notify_client\n",
+			acpi_name);
+		return;
+	}
+
+	status = acpi_ut_acquire_mutex(ACPI_MTX_NAMESPACE);
+	if (ACPI_FAILURE(status)) {
+		pr_err(PREFIX "Acquiring acpi namespace mutext failed\n");
+		return;
+	}
+
+	node = acpi_ns_validate_handle(hlsb);
+	if (!node) {
+		acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
+		pr_err(PREFIX "Mapping handle to node failed\n");
+		return;
+	}
+
+	/*
+	 * Check for internal object and make sure there is a handler
+	 * registered for this object
+	 */
+	obj_desc = acpi_ns_get_attached_object(node);
+	if (obj_desc) {
+		if (obj_desc->common_notify.notify_list[0]) {
+			/*
+			 * Release the lock and queue the item for later
+			 * exectuion
+			 */
+			acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
+			status = acpi_ev_queue_notify_request(node, event);
+			if (ACPI_FAILURE(status))
+				pr_err(PREFIX "acpi_ev_queue_notify_request failed\n");
+			else
+				pr_info(PREFIX "Notify event is queued\n");
+			return;
+		}
+	} else {
+		pr_info(PREFIX "Notify handler not registered for this device\n");
+	}
+
+	acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
+	return;
+}
+
+static ssize_t sci_notify_write(struct file *file, const char __user *user_buf,
+				 size_t count, loff_t *ppos)
+{
+	u32 event;
+	char *name1 = NULL;
+	char *name2 = NULL;
+	const char *delim = " ";
+	char *temp_buf = NULL;
+	char *temp_buf_addr = NULL;
+
+	temp_buf = kmalloc(count+1, GFP_ATOMIC);
+	if (!temp_buf) {
+		pr_warn(PREFIX "sci_notify_wire: Memory allocation failed\n");
+		return count;
+	}
+	temp_buf[count] = '\0';
+	temp_buf_addr = temp_buf;
+	if (copy_from_user(temp_buf, user_buf, count))
+		goto out;
+
+	name1 = strsep(&temp_buf, delim);
+	name2 = strsep(&temp_buf, delim);
+
+	if (name1 && name2) {
+		ssize_t ret;
+		unsigned long val;
+
+		ret = kstrtoul(name2, 10, &val);
+		if (ret) {
+			pr_warn(PREFIX "unknown event\n");
+			goto out;
+		}
+
+		event = (u32)val;
+	} else {
+		pr_warn(PREFIX "unknown device\n");
+		goto out;
+	}
+
+	pr_info(PREFIX "ACPI device name is <%s>, event code is <%d>\n",
+		name1, event);
+
+	sci_notify_client(name1, event);
+
+out:
+	kfree(temp_buf_addr);
+	return count;
+}
+
+static const struct file_operations sci_notify_fops = {
+	.write = sci_notify_write,
+};
+
+static int __init acpi_sci_notify_init(void)
+{
+	if (acpi_debugfs_dir == NULL)
+		return -ENOENT;
+
+	sci_notify_dentry = debugfs_create_file("sci_notify", S_IWUSR,
+				acpi_debugfs_dir, NULL, &sci_notify_fops);
+	if (sci_notify_dentry == NULL)
+		return -ENODEV;
+
+	return 0;
+}
+
+device_initcall(acpi_sci_notify_init);
Index: linux-2.6/drivers/acpi/Makefile
===================================================================
--- linux-2.6.orig/drivers/acpi/Makefile
+++ linux-2.6/drivers/acpi/Makefile
@@ -31,6 +31,7 @@ acpi-$(CONFIG_ACPI_SLEEP)	+= proc.o
 # ACPI Bus and Device Drivers
 #
 acpi-y				+= bus.o glue.o
+acpi-$(CONFIG_ACPI_SCI_EMULATE)	+= sci_emu.o
 acpi-y				+= scan.o
 acpi-y				+= processor_core.o
 acpi-y				+= ec.o
