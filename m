Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab2I1ClH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 22:41:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:43222 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756010Ab2I1ClE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 22:41:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,498,1344236400"; 
   d="scan'208";a="150101453"
From: Lv Zheng <lv.zheng@intel.com>
To: Len Brown <len.brown@intel.com>
Cc: <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>
Subject: [PATCH v4 1/2] ACPI: Add early console framework for DBGP/DBG2.
Date: Fri, 28 Sep 2012 10:40:18 +0800
Message-Id: <f6e58d76efcbdb935b9f433c624686f7d34e0151.1348652044.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1348652044.git.lv.zheng@intel.com>
References: <cover.1347453194.git.zetalog@gmail.com> <cover.1348652044.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Microsoft Debug Port Table (DBGP or DBG2) is required for Windows SoC
platforms.  This patch is introduced to fix the gap between Windows
and Linux.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 Documentation/kernel-parameters.txt |    1 +
 arch/x86/Kconfig.debug              |   15 +++
 arch/x86/kernel/acpi/boot.c         |    1 +
 arch/x86/kernel/early_printk.c      |   13 +++
 drivers/acpi/Makefile               |    2 +
 drivers/acpi/early_printk.c         |  201 +++++++++++++++++++++++++++++++++++
 include/linux/acpi.h                |   24 +++++
 7 files changed, 257 insertions(+)
 create mode 100644 drivers/acpi/early_printk.c

Index: linux-acpi/Documentation/kernel-parameters.txt
===================================================================
--- linux-acpi.orig/Documentation/kernel-parameters.txt	2012-09-27 22:35:07.000000000 +0800
+++ linux-acpi/Documentation/kernel-parameters.txt	2012-09-27 22:35:44.000000000 +0800
@@ -763,6 +763,7 @@
 			earlyprintk=serial[,ttySn[,baudrate]]
 			earlyprintk=ttySn[,baudrate]
 			earlyprintk=dbgp[debugController#]
+			earlyprintk=acpi[debugController#]
 
 			Append ",keep" to not disable it when the real console
 			takes over.
Index: linux-acpi/arch/x86/Kconfig.debug
===================================================================
--- linux-acpi.orig/arch/x86/Kconfig.debug	2012-09-27 22:35:07.000000000 +0800
+++ linux-acpi/arch/x86/Kconfig.debug	2012-09-27 22:35:44.000000000 +0800
@@ -59,6 +59,21 @@
 	  with klogd/syslogd or the X server. You should normally N here,
 	  unless you want to debug such a crash. You need usb debug device.
 
+config EARLY_PRINTK_ACPI
+	bool "Early printk launcher via ACPI debug port tables"
+	depends on EARLY_PRINTK && ACPI
+	---help---
+	  Write kernel log output directly into the debug ports described
+	  in the ACPI tables known as DBGP and DBG2.
+
+	  To enable such debugging facilities, you need to enable this
+	  configuration option and append the "earlyprintk=acpi" kernel
+	  parameter through the boot loaders.  Please refer the
+	  "Documentation/kernel-parameters.txt" for details.  Since this
+	  is an early console launcher, you still need to enable actual
+	  early console drivers that are suitable for your platform.
+	  If in doubt, say "N".
+
 config DEBUG_STACKOVERFLOW
 	bool "Check for stack overflows"
 	depends on DEBUG_KERNEL
Index: linux-acpi/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-acpi.orig/arch/x86/kernel/acpi/boot.c	2012-09-27 22:35:07.000000000 +0800
+++ linux-acpi/arch/x86/kernel/acpi/boot.c	2012-09-27 22:35:13.000000000 +0800
@@ -1518,6 +1518,7 @@
 		return;
 	}
 
+	acpi_early_console_parse();
 	acpi_table_parse(ACPI_SIG_BOOT, acpi_parse_sbf);
 
 	/*
Index: linux-acpi/arch/x86/kernel/early_printk.c
===================================================================
--- linux-acpi.orig/arch/x86/kernel/early_printk.c	2012-09-27 22:35:07.000000000 +0800
+++ linux-acpi/arch/x86/kernel/early_printk.c	2012-09-27 22:35:44.000000000 +0800
@@ -200,6 +200,15 @@
 	register_console(early_console);
 }
 
+#ifdef CONFIG_EARLY_PRINTK_ACPI
+#include <linux/acpi.h>
+
+int __init acpi_early_console_setup(struct acpi_debug_port *info)
+{
+	return 0;
+}
+#endif
+
 static int __init setup_early_printk(char *buf)
 {
 	int keep;
@@ -236,6 +245,10 @@
 		if (!strncmp(buf, "dbgp", 4) && !early_dbgp_init(buf + 4))
 			early_console_register(&early_dbgp_console, keep);
 #endif
+#ifdef CONFIG_EARLY_PRINTK_ACPI
+		if (!strncmp(buf, "acpi", 4))
+			acpi_early_console_init(buf + 4, keep);
+#endif
 #ifdef CONFIG_HVC_XEN
 		if (!strncmp(buf, "xen", 3))
 			early_console_register(&xenboot_console, keep);
Index: linux-acpi/drivers/acpi/Makefile
===================================================================
--- linux-acpi.orig/drivers/acpi/Makefile	2012-09-27 22:35:07.000000000 +0800
+++ linux-acpi/drivers/acpi/Makefile	2012-09-27 22:35:36.000000000 +0800
@@ -46,6 +46,8 @@
 acpi-y				+= video_detect.o
 endif
 
+obj-$(CONFIG_EARLY_PRINTK_ACPI)	+= early_printk.o
+
 # These are (potentially) separate modules
 obj-$(CONFIG_ACPI_AC) 		+= ac.o
 obj-$(CONFIG_ACPI_BUTTON)	+= button.o
Index: linux-acpi/drivers/acpi/early_printk.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-acpi/drivers/acpi/early_printk.c	2012-09-27 22:35:13.000000000 +0800
@@ -0,0 +1,201 @@
+/*
+ *  acpi/early_printk.c - ACPI Boot-Time Debug Ports
+ *
+ *  Copyright (C) 2012 Lv Zheng <lv.zheng@intel.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/acpi.h>
+#include <linux/bootmem.h>
+
+#define ACPI_EARLY_DISABLED	0x0000
+#define ACPI_EARLY_ENABLED	0x0001
+#define ACPI_EARLY_KEEP		0x0002
+#define ACPI_EARLY_PORT_MSK	0xFF00
+#define ACPI_EARLY_PORT_OFF	8
+
+u16 acpi_early_flags = ACPI_EARLY_DISABLED;
+
+static inline bool acpi_early_enabled(void)
+{
+	return acpi_early_flags & ACPI_EARLY_ENABLED;
+}
+
+static inline u8 acpi_early_port_index(void)
+{
+	return (acpi_early_flags & ACPI_EARLY_PORT_MSK) >> ACPI_EARLY_PORT_OFF;
+}
+
+int __init acpi_early_console_keep(void)
+{
+	return acpi_early_flags & ACPI_EARLY_KEEP ? 1 : 0;
+}
+
+static inline int acpi_table_parse_dbg2(acpi_early_console_handler handler)
+{
+	struct acpi_table_header *table_header = NULL;
+	struct acpi_dbg2_device *entry;
+	unsigned int count = 0;
+	unsigned long table_end;
+	acpi_size tbl_size;
+	unsigned int max_entries;
+	struct acpi_debug_port devinfo;
+
+	if (acpi_disabled)
+		return -ENODEV;
+
+	if (!handler)
+		return -EINVAL;
+
+	acpi_get_table(ACPI_SIG_DBG2, 0, &table_header);
+	if (!table_header) {
+		pr_warn("DBG2 not present\n");
+		return -ENODEV;
+	}
+	tbl_size = table_header->length;
+	table_end = (unsigned long)table_header + table_header->length;
+
+	entry = (struct acpi_dbg2_device *)
+	    ((unsigned long)table_header +
+	     ((struct acpi_table_dbg2 *)table_header)->info_offset);
+	max_entries = ((struct acpi_table_dbg2 *)table_header)->info_count;
+
+	while (((unsigned long)entry) + sizeof(struct acpi_dbg2_device) <
+	       table_end) {
+		if (entry->revision != 0) {
+			pr_warn("DBG2 revision %d not supported\n",
+				entry->revision);
+			count = -ENODEV;
+			goto fail;
+		}
+		if (!max_entries || count++ < max_entries) {
+			devinfo.port_index = (u8)count;
+			devinfo.port_type = entry->port_type;
+			devinfo.port_subtype = entry->port_subtype;
+			devinfo.register_count = entry->register_count;
+			devinfo.registers = (struct acpi_generic_address *)
+			    ((unsigned long)entry + entry->base_address_offset);
+			devinfo.namepath_length = entry->namepath_length;
+			devinfo.namepath = (char *)
+			    ((unsigned long)entry + entry->namepath_offset);
+			devinfo.oem_data_length = entry->oem_data_length;
+			devinfo.oem_data = (u8 *)
+			    ((unsigned long)entry + entry->oem_data_offset);
+
+			if (handler(&devinfo, table_end)) {
+				count = -ENODEV;
+				goto fail;
+			}
+		}
+
+		entry = (struct acpi_dbg2_device *)
+		    ((unsigned long)entry + entry->length);
+	}
+
+fail:
+	early_acpi_os_unmap_memory((char *)table_header, tbl_size);
+	return count;
+}
+
+static int __init acpi_parse_early_console(struct acpi_debug_port *info,
+					   const unsigned long end)
+{
+	pr_info("early: DBG2 console %d detected: %04x:%04x.\n",
+		info->port_index, info->port_type, info->port_subtype);
+
+	if (acpi_early_port_index() != 0 &&
+	    acpi_early_port_index() != info->port_index)
+		return 0;
+
+	acpi_early_console_setup(info);
+
+	return 0;
+}
+
+static int __init acpi_parse_dbgp(struct acpi_table_header *table)
+{
+	struct acpi_table_dbgp *dbgp;
+	struct acpi_debug_port devinfo;
+
+	if (acpi_early_port_index() != 0 &&
+	    acpi_early_port_index() != 1)
+		return 0;
+
+	dbgp = (struct acpi_table_dbgp *)table;
+	if (!dbgp) {
+		pr_warn("Unable to map DBGP\n");
+		return -ENODEV;
+	}
+
+	pr_info("early: DBGP console detected: %04x.\n",
+		dbgp->type);
+
+	devinfo.port_index = 1;
+	devinfo.port_type = ACPI_DBG2_SERIAL_PORT;
+	devinfo.port_subtype = dbgp->type;
+	devinfo.register_count = 1;
+	devinfo.registers = (struct acpi_generic_address *)&dbgp->debug_port;
+	devinfo.namepath_length = 0;
+	devinfo.namepath = NULL;
+	devinfo.oem_data_length = 0;
+	devinfo.oem_data = NULL;
+
+	acpi_parse_early_console(&devinfo, 0);
+
+	return 0;
+}
+
+int __init acpi_early_console_parse(void)
+{
+	if (!acpi_early_enabled())
+		return -EINVAL;
+
+	if (acpi_table_parse_dbg2(acpi_parse_early_console) == 0)
+		acpi_table_parse(ACPI_SIG_DBGP, acpi_parse_dbgp);
+
+	return 0;
+}
+
+int __init acpi_early_console_init(char *s, int keep)
+{
+	acpi_early_flags = ACPI_EARLY_ENABLED;
+	if (keep)
+		acpi_early_flags |= ACPI_EARLY_KEEP;
+
+	if (*s) {
+		int ret;
+		unsigned long port;
+
+		ret = kstrtoul(s, 10, &port);
+		if (!ret)
+			acpi_early_flags |= ((u8)port) << ACPI_EARLY_PORT_OFF;
+	}
+
+	pr_info("early: debug port index %d.\n", acpi_early_port_index());
+
+	return 0;
+}
+
Index: linux-acpi/include/linux/acpi.h
===================================================================
--- linux-acpi.orig/include/linux/acpi.h	2012-09-27 22:35:07.000000000 +0800
+++ linux-acpi/include/linux/acpi.h	2012-09-27 22:35:41.000000000 +0800
@@ -430,4 +430,28 @@
 #define acpi_os_set_prepare_sleep(func, pm1a_ctrl, pm1b_ctrl) do { } while (0)
 #endif
 
+#ifdef CONFIG_EARLY_PRINTK_ACPI
+struct acpi_debug_port {
+	u8 port_index;
+	u16 port_type;
+	u16 port_subtype;
+	u16 register_count;
+	struct acpi_generic_address *registers;
+	u16 namepath_length;
+	char *namepath;
+	u16 oem_data_length;
+	u8 *oem_data;
+};
+
+typedef int (*acpi_early_console_handler)(struct acpi_debug_port *dev,
+					  const unsigned long end);
+
+int __init acpi_early_console_keep(void);
+int __init acpi_early_console_init(char *s, int keep);
+int __init acpi_early_console_parse(void);
+int __init acpi_early_console_setup(struct acpi_debug_port *info);
+#else
+static int acpi_early_console_parse(void) { return 0; }
+#endif
+
 #endif	/*_LINUX_ACPI_H*/
