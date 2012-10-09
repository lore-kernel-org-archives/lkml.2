Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab2JIChf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 22:37:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:5876 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332Ab2JIChd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 22:37:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,556,1344236400"; 
   d="scan'208";a="202132193"
From: Lv Zheng <lv.zheng@intel.com>
To: Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Feng Tang <feng.tang@intel.com>
Cc: <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org, x86@kernel.org,
        platform-driver-x86@vger.kernel.org, Lv Zheng <lv.zheng@intel.com>
Subject: [PATCH v5 1/2] ACPI: Add early console framework for DBGP/DBG2.
Date: Tue,  9 Oct 2012 10:36:56 +0800
Message-Id: <6a6a79654294bf4a3a9df1cf81880a44aeea4b44.1349749925.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1347453194.git.zetalog@gmail.com>
References: <cover.1347453194.git.zetalog@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Microsoft Debug Port Table (DBGP or DBG2) is used by the Windows SoC
platforms to describe their debugging facilities.
DBGP: http://msdn.microsoft.com/en-us/windows/hardware/hh134821
DBG2: http://msdn.microsoft.com/en-us/library/windows/hardware/hh673515

This patch enables the DBGP/DBG2 debug ports as Linux early console
launcher.  Individual early console drivers are also needed to get the
early kernel messages dumped on the consoles.  For example, to use the
SPI UART early console for the Low Power Intel Architecture (LPIA)
platforms, you need to enable the following kernel configurations:
  CONFIG_EARLY_PRINTK_ACPI=y
  CONFIG_EARLY_PRINTK_INTEL_MID_SPI=y
Then you need to append the following kernel parameter to the kernel
command line in your the boot loader configuration file:
  earlyprintk=acpi

There is a dilemma in designing this patch set.  Let me describe it in
details.
There should be three steps to enable an early console for an operating
system:
1. Probe: In this stage, the Linux kernel can detect the early consoles
          and the base address of their register block can be determined.
          This can be done by parsing the descriptors in the ACPI DBGP/DBG2
          tables.  Note that acpi_table_init() must be called before
          parsing.
2. Setup: In this stage, the Linux kernel can apply user specified
          configuration options (ex. baudrate of serial ports) for the
          early consoles.  This is done by parsing the early parameters
          passed to the kernel from the boot loaders.  Note that
          parse_early_params() is called very early to allow parameters to
          be passed to other kernel subsystems.
3. Start: In this stage, the Linux kernel can make the consoles ready to
          output logs.  Since the early consoles are always used for the
          kernel boot up debugging, this must be done as early as possible
          to arm the kernel with the highest testability for other kernel
          subsystems.  Note that, this stage happens when the
          register_console() is called.
The preferred sequence for the above steps is:
   +-----------------+    +-------------------+    +--------------------+
   | ACPI DBGP PROBE | -> | EARLY_PARAM SETUP | -> | EARLY_RPINTK START |
   +-----------------+    +-------------------+    +--------------------+
But unfortunately, in the current x86 implementation, early parameters and
early printk initialization are called before acpi_table_init() which
depends on the early memory mapping facility.
There are some choices for me to design this patch set:
1. Invoking acpi_table_init() before parse_early_param() to maintain the
   sequence:
   +-----------------+    +-------------------+    +--------------------+
   | ACPI DBGP PROBE | -> | EARLY_PARAM SETUP | -> | EARLY_RPINTK START |
   +-----------------+    +-------------------+    +--------------------+
   This requires other subsystem maintainers' review to ensure no
   regressions will be introduced.  At the first glance, I found there
   might be problems for the EFI subsystsm:
   The EFI boot services and runtime services are mixed up in the x86
   specific initialization process before the ACPI table initialization.
   Things are much worse that you even cannot disable the runtime services
   while still allow the boot services codes to be executed in the kernel
   compilation stage.  Enabling the early consoles after the ACPI table
   initialization will make it difficult to debug the runtime BIOS bugs.
   If any progress is made to the kernel boot sequences, please let me
   know.  I'll be willing to redesign the ACPI DBGP/DBG2 console probing
   facility.  You can reach me at <lv.zheng@intel.com> and
   <zetalog@gmail.com>.
2. Modifying the above sequece to make it look like:
   +-------------------+    +-----------------+    +--------------------+
   | EARLY_PARAM SETUP | -> | ACPI DBGP PROBE | -> | EARLY_RPINTK START |
   +-------------------+    +-----------------+    +--------------------+
   Early consoles started in this style will lose part of the testability
   in the kernel boot up sequence.  If the system does not crash very
   early, developers still can see the bufferred kernel outputs when the
   register_console() is called.
   Current early console implementations need to be modified to be
   compatible with this design.  The original codes need to be split up
   into tow parts:
   1. Detecting hardware.  This part can be called in the PROBE stage.
   2. Applying user parameters.  This part can be called in the SETUP
      stage.
   Individual early console drver maintainers need to be involved to avoid
   regressions that might occur if we do things in this way.  And the
   maintainers can offer better tests than I can do.
3. Introducing a brand new debugging facility that does not relate to the
   current early console implementation to allow the early consoles to be
   automatically detected.
   +-------------------+    +--------------------+
   | EARLY_PARAM SETUP | -> | EARLY_RPINTK START |
   +-------------------+    +--------------------+
   +-----------------+    +--------------------+
   | ACPI DBGP PROBE | -> | EARLY_RPINTK START |
   +-----------------+    +--------------------+
   Early consoles started in this style will lose part of the testability
   in the kernel boot up sequence.  If the system does not crash very
   early, developers still can see the bufferred kernel outputs when the
   register_console() is called.
   Comparing to the solution 2, we can notice that the user configuration
   can not be applied to the registered early consoles in this way as the
   acpi_table_init() is still called after the parse_early_param().
   Instead, the early consoles should derive the hardware settings used in
   the BIOS/bootloaders.
   This is what the patch set has done to enable this new usage model.
   It is known as "ACPI early console launcher mode".
   As a launcher, ACPI DBGP will not actually output kernel messages
   without the real early console drivers, that's why the
   CONFIG_EARLY_PRINTK_INTEL_MID_SPI still need to be enabled along with
   the CONFIG_EARLY_PRINTK_ACPI.
   In order to disable this facility by default and enable it at runtime,
   an kernel parameter "earlyprintk=acpi" is introduced.  This makes the
   actual sequence look like:
   +-------------------+    +--------------------+
   | EARLY_PARAM SETUP | -> | EARLY_RPINTK START |
   +-------------------+    +....................+
                            | ACPI DBGP LAUNCH   | ->
                            +--------------------+
      +-----------------+    +--------------------+
   -> | ACPI DBGP PROBE | -> | EARLY_PRINTK START |
      +-----------------+    +--------------------+

Version 1:
 1. Enables single DBG2 debug port support.
Version 2:
 1. Applies Rui's comments.
Version 3:
 1. Applies Len's comments (earlycon should be disabled by default).
 2. Enables single DBG2 debug ports support.
Version 4:
 1. Fixes the CodingStyle issues reported by checkpatch.pl.
 2. Enables single DBGP debug port support.
Version 5:
 1. Enables multiple DBG2 debug ports support.
 2. Applies Konrad's comments (pr_debug should be used in earlycon).
 3. Changes kstrtoul back to simple_strtoul.

Known Issues:
1. The simple_strtoul function cannot be replaced by the kstrtoul in
   the x86 specific booting codes.  The kstrtoul will return error on
   strings like "acpi0,keep".  This will leave one CodingStyle issue
   reported by the checkpatch.pl.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Reviewed-by: Rui Zhang <rui.zhang@intel.com>
Reviewed-by: Ying Huang <ying.huang@intel.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad@kernel.org>
---
 Documentation/kernel-parameters.txt |    1 +
 arch/x86/Kconfig.debug              |   15 +++
 arch/x86/kernel/acpi/boot.c         |    1 +
 arch/x86/kernel/early_printk.c      |   13 +++
 drivers/acpi/Makefile               |    2 +
 drivers/acpi/early_printk.c         |  173 +++++++++++++++++++++++++++++++++++
 include/linux/acpi.h                |   22 +++++
 7 files changed, 227 insertions(+)
 create mode 100644 drivers/acpi/early_printk.c

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index ad7e2e5..f656765 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -763,6 +763,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			earlyprintk=serial[,ttySn[,baudrate]]
 			earlyprintk=ttySn[,baudrate]
 			earlyprintk=dbgp[debugController#]
+			earlyprintk=acpi[debugController#]
 
 			Append ",keep" to not disable it when the real console
 			takes over.
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index b322f12..5778082 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -59,6 +59,21 @@ config EARLY_PRINTK_DBGP
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
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index b2297e5..cc10ea5 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1518,6 +1518,7 @@ void __init acpi_boot_table_init(void)
 		return;
 	}
 
+	acpi_early_console_probe();
 	acpi_table_parse(ACPI_SIG_BOOT, acpi_parse_sbf);
 
 	/*
diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 9b9f18b..bf5b596 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -200,6 +200,15 @@ static inline void early_console_register(struct console *con, int keep_early)
 	register_console(early_console);
 }
 
+#ifdef CONFIG_EARLY_PRINTK_ACPI
+#include <linux/acpi.h>
+
+int __init __acpi_early_console_start(struct acpi_debug_port *info)
+{
+	return 0;
+}
+#endif
+
 static int __init setup_early_printk(char *buf)
 {
 	int keep;
@@ -236,6 +245,10 @@ static int __init setup_early_printk(char *buf)
 		if (!strncmp(buf, "dbgp", 4) && !early_dbgp_init(buf + 4))
 			early_console_register(&early_dbgp_console, keep);
 #endif
+#ifdef CONFIG_EARLY_PRINTK_ACPI
+		if (!strncmp(buf, "acpi", 4))
+			acpi_early_console_launch(buf + 4, keep);
+#endif
 #ifdef CONFIG_HVC_XEN
 		if (!strncmp(buf, "xen", 3))
 			early_console_register(&xenboot_console, keep);
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 47199e2..99dbd64 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -46,6 +46,8 @@ ifdef CONFIG_ACPI_VIDEO
 acpi-y				+= video_detect.o
 endif
 
+obj-$(CONFIG_EARLY_PRINTK_ACPI)	+= early_printk.o
+
 # These are (potentially) separate modules
 obj-$(CONFIG_ACPI_AC) 		+= ac.o
 obj-$(CONFIG_ACPI_BUTTON)	+= button.o
diff --git a/drivers/acpi/early_printk.c b/drivers/acpi/early_printk.c
new file mode 100644
index 0000000..3e5c1f3
--- /dev/null
+++ b/drivers/acpi/early_printk.c
@@ -0,0 +1,173 @@
+/*
+ * acpi/early_printk.c - ACPI Boot-Time Debug Ports
+ *
+ * Copyright (c) 2012, Intel Corporation
+ * Author: Lv Zheng <lv.zheng@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#define DEBUG
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/acpi.h>
+#include <linux/bitmap.h>
+#include <linux/bootmem.h>
+
+#define MAX_ACPI_DBG_PORTS	16
+
+DECLARE_BITMAP(acpi_early_flags, MAX_ACPI_DBG_PORTS);
+int acpi_early_enabled;
+
+static int acpi_early_console_enable(u8 port, int keep)
+{
+	if (port >= MAX_ACPI_DBG_PORTS)
+		return -ENODEV;
+
+	set_bit(port, acpi_early_flags);
+	if (keep)
+		set_bit(port+MAX_ACPI_DBG_PORTS, acpi_early_flags);
+	acpi_early_enabled = 1;
+
+	pr_debug("early: DBGx LAUNCH - console %d.\n", port);
+
+	return 0;
+}
+
+static inline bool acpi_early_console_enabled(u8 port)
+{
+	BUG_ON(port >= MAX_ACPI_DBG_PORTS);
+	return test_bit(port, acpi_early_flags);
+}
+
+int __init acpi_early_console_keep(struct acpi_debug_port *info)
+{
+	BUG_ON(!info || info->port_index >= MAX_ACPI_DBG_PORTS);
+	return test_bit(info->port_index+MAX_ACPI_DBG_PORTS, acpi_early_flags);
+}
+
+static int __init acpi_early_console_start(struct acpi_debug_port *info)
+{
+	if (!acpi_early_console_enabled(info->port_index))
+		return 0;
+
+	pr_debug("early: DBGx START - console %d(%04x:%04x).\n",
+		 info->port_index, info->port_type, info->port_subtype);
+	__acpi_early_console_start(info);
+
+	return 0;
+}
+
+static int __init acpi_parse_dbg2(struct acpi_table_header *table)
+{
+	struct acpi_table_dbg2 *dbg2;
+	struct acpi_dbg2_device *entry;
+	unsigned int count = 0;
+	unsigned long tbl_end;
+	unsigned int max_entries;
+	struct acpi_debug_port devinfo;
+
+	dbg2 = (struct acpi_table_dbg2 *)table;
+	if (!dbg2) {
+		pr_debug("early: DBG2 not present.\n");
+		return -ENODEV;
+	}
+
+	tbl_end = (unsigned long)table + table->length;
+
+	entry = (struct acpi_dbg2_device *)
+		((unsigned long)dbg2 + dbg2->info_offset);
+	max_entries = min_t(u32, MAX_ACPI_DBG_PORTS, dbg2->info_count);
+
+	while (((unsigned long)entry) + sizeof(struct acpi_dbg2_device) <
+	       tbl_end) {
+		if (entry->revision != 0) {
+			pr_debug("early: DBG2 revision %d not supported.\n",
+				 entry->revision);
+			return -ENODEV;
+		}
+		if (!max_entries || count++ < max_entries) {
+			pr_debug("early: DBG2 PROBE - console %d(%04x:%04x).\n",
+				 count-1,
+				 entry->port_type, entry->port_subtype);
+
+			devinfo.port_index = (u8)count-1;
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
+			acpi_early_console_start(&devinfo);
+		}
+
+		entry = (struct acpi_dbg2_device *)
+		    ((unsigned long)entry + entry->length);
+	}
+
+	return 0;
+}
+
+static int __init acpi_parse_dbgp(struct acpi_table_header *table)
+{
+	struct acpi_table_dbgp *dbgp;
+	struct acpi_debug_port devinfo;
+
+	dbgp = (struct acpi_table_dbgp *)table;
+	if (!dbgp) {
+		pr_debug("early: DBGP not present.\n");
+		return -ENODEV;
+	}
+
+	pr_debug("early: DBGP PROBE - console (%04x).\n", dbgp->type);
+
+	devinfo.port_index = 0;
+	devinfo.port_type = ACPI_DBG2_SERIAL_PORT;
+	devinfo.port_subtype = dbgp->type;
+	devinfo.register_count = 1;
+	devinfo.registers = (struct acpi_generic_address *)&dbgp->debug_port;
+	devinfo.namepath_length = 0;
+	devinfo.namepath = NULL;
+	devinfo.oem_data_length = 0;
+	devinfo.oem_data = NULL;
+
+	acpi_early_console_start(&devinfo);
+
+	return 0;
+}
+
+int __init acpi_early_console_probe(void)
+{
+	if (!acpi_early_enabled)
+		return -EINVAL;
+
+	if (acpi_table_parse(ACPI_SIG_DBG2, acpi_parse_dbg2) != 0)
+		acpi_table_parse(ACPI_SIG_DBGP, acpi_parse_dbgp);
+
+	return 0;
+}
+
+int __init acpi_early_console_launch(char *s, int keep)
+{
+	char *e;
+	unsigned long port = 0;
+
+	if (*s)
+		port = simple_strtoul(s, &e, 10);
+
+	return acpi_early_console_enable(port, keep);
+}
+
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 4f2a762..641366c 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -430,4 +430,26 @@ acpi_status acpi_os_prepare_sleep(u8 sleep_state,
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
+int __init acpi_early_console_keep(struct acpi_debug_port *info);
+int __init acpi_early_console_launch(char *s, int keep);
+int __init acpi_early_console_probe(void);
+/* This interface is arch specific. */
+int __init __acpi_early_console_start(struct acpi_debug_port *info);
+#else
+static int acpi_early_console_probe(void) { return 0; }
+#endif
+
 #endif	/*_LINUX_ACPI_H*/
-- 
1.7.10

