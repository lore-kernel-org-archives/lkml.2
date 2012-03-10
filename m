Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab2CJHEn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 02:04:43 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:39647 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932653Ab2CJHEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 02:04:30 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ashok Raj <ashok.raj@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v2 36/37] ACPI: Enable SCI_EMULATE to manually simulate physical hotplug testing.
Date: Fri,  9 Mar 2012 23:00:36 -0800
Message-Id: <1331362837-10740-37-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090209.4F5AFCBD.0069,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ashok Raj <ashok.raj@intel.com>

Emulate an ACPI SCI interrupt to emulate a hot-plug event. Useful
for testing ACPI based hot-plug on systems that don't have the
necessary firmware support.

Enable CONFIG_ACPI_SCI_EMULATE on kernel compile.

Now you will notice /proc/acpi/sci/notify when new kernel is booted.

echo "\_SB.CPU4 1" > /proc/acpi/sci/notify to trigger a hot-add of CPU4.
You will now notice an entry /sys/firmware/acpi/namespace/ACPI/_SB/CPU4
if the namespace had an entry CPU4 under _SB scope. If the entry had a
_EJ0 method, you will also notice a file "eject" under the CPU4 directory.

-v2: Update to current upstream, and remove not related stuff.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org

===================================================================
---
 drivers/acpi/Kconfig    |   10 +++
 drivers/acpi/Makefile   |    1 +
 drivers/acpi/bus.c      |    2 +
 drivers/acpi/internal.h |    6 ++
 drivers/acpi/sci_emu.c  |  141 +++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 160 insertions(+), 0 deletions(-)
 create mode 100644 drivers/acpi/sci_emu.c

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 7556913..b7b8541 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -272,6 +272,16 @@ config ACPI_BLACKLIST_YEAR
 	  Enter 0 to disable this mechanism and allow ACPI to
 	  run by default no matter what the year.  (default)
 
+config ACPI_SCI_EMULATE
+	bool "ACPI SCI Event Emulation Support"
+	depends on ACPI
+	default n
+	help
+	  This will enable your system to emulate sci hotplug event
+	  notification through proc file system. For example user needs to
+	  echo "XXX 0" > /proc/acpi/sci/notify (where, XXX is a target ACPI
+	  device object name present under \_SB scope).
+
 config ACPI_DEBUG
 	bool "Debug Statements"
 	default n
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index bc6e53f..3580f04 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -31,6 +31,7 @@ acpi-$(CONFIG_ACPI_SLEEP)	+= proc.o
 # ACPI Bus and Device Drivers
 #
 acpi-y				+= bus.o glue.o
+acpi-$(CONFIG_ACPI_SCI_EMULATE)	+= sci_emu.o
 acpi-y				+= scan.o
 acpi-y				+= processor_core.o
 acpi-y				+= ec.o
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 9ecec98..512235e 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -1001,6 +1001,8 @@ static int __init acpi_bus_init(void)
 	 */
 	acpi_root_dir = proc_mkdir(ACPI_BUS_FILE_ROOT, NULL);
 
+	acpi_init_sci_emulate();
+
 	return 0;
 
 	/* Mimic structured exception handling */
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index ca75b9c..5b22cd2 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -34,6 +34,12 @@ int acpi_debugfs_init(void);
 static inline void acpi_debugfs_init(void) { return; }
 #endif
 
+#ifdef CONFIG_ACPI_SCI_EMULATE
+int acpi_init_sci_emulate(void);
+#else
+static inline int acpi_init_sci_emulate(void) { return 0; }
+#endif
+
 /* --------------------------------------------------------------------------
                                   Power Resource
    -------------------------------------------------------------------------- */
diff --git a/drivers/acpi/sci_emu.c b/drivers/acpi/sci_emu.c
new file mode 100644
index 0000000..d972436
--- /dev/null
+++ b/drivers/acpi/sci_emu.c
@@ -0,0 +1,141 @@
+/*
+ *  Code to emulate SCI interrupt for Hotplug node insertion/removal
+ */
+#include <linux/kernel.h>
+#include <linux/proc_fs.h>
+#include <linux/acpi.h>
+
+#include "internal.h"
+
+#include "acpica/accommon.h"
+#include "acpica/acnamesp.h"
+#include "acpica/acevents.h"
+
+#define _COMPONENT		ACPI_SYSTEM_COMPONENT
+ACPI_MODULE_NAME("sci_emu");
+
+static void acpi_sci_notify_client(char *acpi_name, u32 event);
+static int acpi_sci_notify_write_proc(struct file *file, const char *buffer, \
+	unsigned long count, void *data);
+struct proc_dir_entry *acpi_sci_dir;
+
+static int acpi_sci_notify_write_proc(struct file *file, const char *buffer,
+				      unsigned long count, void *data)
+{
+	u32 event;
+	char *name1 = NULL;
+	char *name2 = NULL;
+	char *end_name = NULL;
+	const char *delim = " ";
+	char *temp_buf = NULL;
+	char *temp_buf_addr = NULL;
+
+	temp_buf = kmalloc(count+1, GFP_ATOMIC);
+	if (!temp_buf) {
+		printk(KERN_WARNING PREFIX
+		 "acpi_sci_notify_wire_proc: Memory allocation failed\n");
+		return count;
+	}
+	temp_buf[count] = '\0';
+	temp_buf_addr = temp_buf;
+	memcpy(temp_buf, buffer, count);
+	name1 = strsep(&temp_buf, delim);
+	name2 = strsep(&temp_buf, delim);
+
+	if (name1 && name2)
+		event = simple_strtoul(name2, &end_name, 10);
+	else {
+		printk(KERN_WARNING PREFIX "unknown device\n");
+		kfree(temp_buf_addr);
+		return count;
+	}
+
+	printk(KERN_INFO PREFIX
+		"ACPI device name is <%s>, event code is <%d>\n",
+		name1, event);
+
+	acpi_sci_notify_client(name1, event);
+
+	kfree(temp_buf_addr);
+
+	return count;
+}
+
+static void acpi_sci_notify_client(char *acpi_name, u32 event)
+{
+	struct acpi_namespace_node *node;
+	acpi_status status, status1;
+	acpi_handle hlsb, hsb;
+	union acpi_operand_object *obj_desc;
+
+	status = acpi_get_handle(NULL, "\\_SB", &hsb);
+	status1 = acpi_get_handle(hsb, acpi_name, &hlsb);
+	if (ACPI_FAILURE(status) || ACPI_FAILURE(status1)) {
+		printk(KERN_ERR PREFIX
+	"acpi getting handle to <\\_SB.%s> failed inside notify_client\n",
+			acpi_name);
+		return;
+	}
+
+	status = acpi_ut_acquire_mutex(ACPI_MTX_NAMESPACE);
+	if (ACPI_FAILURE(status)) {
+		printk(KERN_ERR PREFIX "Acquiring acpi namespace mutext failed\n");
+		return;
+	}
+
+	node = acpi_ns_validate_handle(hlsb);
+	if (!node) {
+		acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
+		printk(KERN_ERR PREFIX "Mapping handle to node failed\n");
+		return;
+	}
+
+	/*
+	 * Check for internal object and make sure there is a handler
+	 * registered for this object
+	 */
+	obj_desc = acpi_ns_get_attached_object(node);
+	if (obj_desc) {
+		if (obj_desc->common_notify.system_notify) {
+			/*
+			 * Release the lock and queue the item for later
+			 * exectuion
+			 */
+			acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
+			status = acpi_ev_queue_notify_request(node, event);
+			if (ACPI_FAILURE(status))
+				printk(KERN_ERR PREFIX "acpi_ev_queue_notify_request failed\n");
+			else
+				printk(KERN_INFO PREFIX "Notify event is queued\n");
+			return;
+		}
+	} else {
+		printk(KERN_INFO PREFIX "Notify handler not registered for this device\n");
+	}
+
+	acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
+	return;
+}
+
+int __init acpi_init_sci_emulate(void)
+{
+	struct proc_dir_entry   *notify_entry = NULL;
+
+	ACPI_FUNCTION_TRACE("acpi_init_sci_emulate");
+
+	acpi_sci_dir = proc_mkdir("sci", acpi_root_dir);
+	if (!acpi_sci_dir)
+		return_VALUE(-ENODEV);
+
+	notify_entry = create_proc_entry("notify", \
+		S_IWUGO|S_IRUGO, acpi_sci_dir);
+	if (!notify_entry) {
+		ACPI_DEBUG_PRINT((ACPI_DB_INIT,
+			"Unable to create '%s' fs entry\n", "notify"));
+	} else {
+		notify_entry->write_proc = acpi_sci_notify_write_proc;
+		notify_entry->data = NULL;
+	}
+
+	return_VALUE(0);
+}
-- 
1.7.7

