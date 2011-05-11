Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab1EKUOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 16:14:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52706 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab1EKUOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 16:14:16 -0400
Subject: [PATCH v6 3/5] arm/dt: consolidate atags setup into
 setup_machine_atags
To: linaro-dev@lists.linaro.org, Thomas Gleixner <tglx@linutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 11 May 2011 22:14:12 +0200
Message-ID: <20110511201412.21615.39100.stgit@localhost6.localdomain6>
In-Reply-To: <20110511201401.21615.38893.stgit@localhost6.localdomain6>
References: <20110511201401.21615.38893.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for adding device tree support, this patch consolidates
all of the atag-specific setup into a single function.

v5: - drop double printk("Machine; %s\n", ...); call.
    - leave copying boot_command_line in setup_arch() since it isn't
      atags specific.
v4: - adapt to the removal of lookup_machine_type()
    - break out dump of machine_desc table into dump_machine_table()
      because the device tree probe code will use it.
    - Add for_each_machine_desc() macro

Tested-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/include/asm/mach/arch.h |    7 ++++
 arch/arm/kernel/setup.c          |   69 ++++++++++++++++++++++----------------
 2 files changed, 47 insertions(+), 29 deletions(-)

diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
index bf13b81..4764e67 100644
--- a/arch/arm/include/asm/mach/arch.h
+++ b/arch/arm/include/asm/mach/arch.h
@@ -48,6 +48,13 @@ struct machine_desc {
 extern struct machine_desc *machine_desc;
 
 /*
+ * Machine type table - also only accessible during boot
+ */
+extern struct machine_desc __arch_info_begin[], __arch_info_end[];
+#define for_each_machine_desc(p)			\
+	for (p = __arch_info_begin; p < __arch_info_end; p++)
+
+/*
  * Set of macros to define architecture features.  This is built into
  * a table by the linker.
  */
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 109997e..42c2f0c 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -439,25 +439,12 @@ void cpu_init(void)
 	    : "r14");
 }
 
-static struct machine_desc * __init setup_machine(unsigned int nr)
+static void __init dump_machine_table(void)
 {
-	extern struct machine_desc __arch_info_begin[], __arch_info_end[];
 	struct machine_desc *p;
 
-	/*
-	 * locate machine in the list of supported machines.
-	 */
-	for (p = __arch_info_begin; p < __arch_info_end; p++)
-		if (nr == p->nr) {
-			printk("Machine: %s\n", p->name);
-			return p;
-		}
-
-	early_print("\n"
-		"Error: unrecognized/unsupported machine ID (r1 = 0x%08x).\n\n"
-		"Available machine support:\n\nID (hex)\tNAME\n", nr);
-
-	for (p = __arch_info_begin; p < __arch_info_end; p++)
+	early_print("Available machine support:\n\nID (hex)\tNAME\n");
+	for_each_machine_desc(p)
 		early_print("%08x\t%s\n", p->nr, p->name);
 
 	early_print("\nPlease check your kernel config and/or bootloader.\n");
@@ -796,23 +783,29 @@ static void __init squash_mem_tags(struct tag *tag)
 			tag->hdr.tag = ATAG_NONE;
 }
 
-void __init setup_arch(char **cmdline_p)
+static struct machine_desc * __init setup_machine_tags(unsigned int nr)
 {
 	struct tag *tags = (struct tag *)&init_tags;
-	struct machine_desc *mdesc;
+	struct machine_desc *mdesc = NULL, *p;
 	char *from = default_command_line;
 
 	init_tags.mem.start = PHYS_OFFSET;
 
-	unwind_init();
-
-	setup_processor();
-	mdesc = setup_machine(machine_arch_type);
-	machine_desc = mdesc;
-	machine_name = mdesc->name;
+	/*
+	 * locate machine in the list of supported machines.
+	 */
+	for_each_machine_desc(p)
+		if (nr == p->nr) {
+			printk("Machine: %s\n", p->name);
+			mdesc = p;
+			break;
+		}
 
-	if (mdesc->soft_reboot)
-		reboot_setup("s");
+	if (!mdesc) {
+		early_print("\nError: unrecognized/unsupported machine ID"
+			" (r1 = 0x%08x).\n\n", nr);
+		dump_machine_table(); /* does not return */
+	}
 
 	if (__atags_pointer)
 		tags = phys_to_virt(__atags_pointer);
@@ -857,14 +850,32 @@ void __init setup_arch(char **cmdline_p)
 		parse_tags(tags);
 	}
 
+	/* parse_early_param needs a boot_command_line */
+	strlcpy(boot_command_line, from, COMMAND_LINE_SIZE);
+
+	return mdesc;
+}
+
+
+void __init setup_arch(char **cmdline_p)
+{
+	struct machine_desc *mdesc;
+
+	unwind_init();
+
+	setup_processor();
+	mdesc = setup_machine_tags(machine_arch_type);
+	machine_desc = mdesc;
+	machine_name = mdesc->name;
+
+	if (mdesc->soft_reboot)
+		reboot_setup("s");
+
 	init_mm.start_code = (unsigned long) _text;
 	init_mm.end_code   = (unsigned long) _etext;
 	init_mm.end_data   = (unsigned long) _edata;
 	init_mm.brk	   = (unsigned long) _end;
 
-	/* parse_early_param needs a boot_command_line */
-	strlcpy(boot_command_line, from, COMMAND_LINE_SIZE);
-
 	/* populate cmd_line too for later use, preserving boot_command_line */
 	strlcpy(cmd_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = cmd_line;

