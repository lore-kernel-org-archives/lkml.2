Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab2KLLuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:50:37 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:64698 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab2KLLu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:50:28 -0500
From: <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC Patch v1 37/55] ARC: dynamic loadable module support
Date: Mon, 12 Nov 2012 17:18:55 +0530
Message-ID: <1352720953-24321-7-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/module.h |    4 ++
 arch/arc/kernel/Makefile      |    1 +
 arch/arc/kernel/module.c      |  117 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 122 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/kernel/module.c

diff --git a/arch/arc/include/asm/module.h b/arch/arc/include/asm/module.h
index 165d768..234b435 100644
--- a/arch/arc/include/asm/module.h
+++ b/arch/arc/include/asm/module.h
@@ -14,4 +14,8 @@
 
 #include <asm-generic/module.h>
 
+#define MODULE_PROC_FAMILY "ARC700"
+
+#define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY
+
 #endif /* _ASM_ARC_MODULE_H */
diff --git a/arch/arc/kernel/Makefile b/arch/arc/kernel/Makefile
index 4ddef9a..9151bbe 100644
--- a/arch/arc/kernel/Makefile
+++ b/arch/arc/kernel/Makefile
@@ -11,6 +11,7 @@ CFLAGS_ptrace.o		+= -DUTS_MACHINE='"$(UTS_MACHINE)"'
 obj-y	:= arcksyms.o setup.o irq.o time.o reset.o ptrace.o entry.o process.o \
 	   signal.o traps.o sys.o troubleshoot.o stacktrace.o
 
+obj-$(CONFIG_MODULES)			+= arcksyms.o module.o
 obj-$(CONFIG_ARC_FPU_SAVE_RESTORE)	+= fpu.o
 CFLAGS_fpu.o   += -mdpfp
 
diff --git a/arch/arc/kernel/module.c b/arch/arc/kernel/module.c
new file mode 100644
index 0000000..cc13df4
--- /dev/null
+++ b/arch/arc/kernel/module.c
@@ -0,0 +1,117 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleloader.h>
+#include <linux/kernel.h>
+#include <linux/elf.h>
+#include <linux/vmalloc.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/string.h>
+
+static inline void arc_write_me(unsigned short *addr, unsigned long value)
+{
+	*addr = (value & 0xffff0000) >> 16;
+	*(addr + 1) = (value & 0xffff);
+}
+
+void *module_alloc(unsigned long size)
+{
+	if (size == 0)
+		return NULL;
+
+	return vmalloc(size);
+
+}
+
+void module_free(struct module *module, void *region)
+{
+	vfree(region);
+}
+
+int module_frob_arch_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
+			      char *secstr, struct module *mod)
+{
+    return 0;
+}
+
+void module_arch_cleanup(struct module *mod)
+{
+}
+
+int apply_relocate_add(Elf32_Shdr *sechdrs,
+		       const char *strtab,
+		       unsigned int symindex,	/* sec index for sym tbl */
+		       unsigned int relsec,	/* sec index for relo sec */
+		       struct module *module)
+{
+	int i, n;
+	Elf32_Rela *rel_entry = (void *)sechdrs[relsec].sh_addr;
+	Elf32_Sym *sym_entry, *sym_sec;
+	Elf32_Addr relocation;
+	Elf32_Addr location;
+	Elf32_Addr sec_to_patch;
+	int relo_type;
+
+	sec_to_patch = sechdrs[sechdrs[relsec].sh_info].sh_addr;
+	sym_sec = (Elf32_Sym *) sechdrs[symindex].sh_addr;
+	n = sechdrs[relsec].sh_size / sizeof(*rel_entry);
+
+	pr_debug("\n========== Module Sym reloc ===========================\n");
+	pr_debug("Section to fixup %x\n", sec_to_patch);
+	pr_debug("=========================================================\n");
+	pr_debug("rela->r_off | rela->addend | sym->st_value | ADDR | VALUE\n");
+	pr_debug("=========================================================\n");
+
+	/* Loop thru entries in relocation section */
+	for (i = 0; i < n; i++) {
+
+		/* This is where to make the change */
+		location = sec_to_patch + rel_entry[i].r_offset;
+
+		/* This is the symbol it is referring to.  Note that all
+		   undefined symbols have been resolved.  */
+		sym_entry = sym_sec + ELF32_R_SYM(rel_entry[i].r_info);
+
+		relocation = sym_entry->st_value + rel_entry[i].r_addend;
+
+		pr_debug("\t%x\t\t%x\t\t%x  %x %x [%s]\n",
+			rel_entry[i].r_offset, rel_entry[i].r_addend,
+			sym_entry->st_value, location, relocation,
+			strtab + sym_entry->st_name);
+
+		/* This assumes modules are built with -mlong-calls
+		 * so any branches/jumps are absolute 32 bit jmps
+		 * global data access again is abs 32 bit.
+		 * Both of these are handled by same relocation type
+		 */
+		relo_type = ELF32_R_TYPE(rel_entry[i].r_info);
+
+		if (likely(R_ARC_32_ME == relo_type))
+			arc_write_me((unsigned short *)location, relocation);
+		else if (R_ARC_32 == relo_type)
+			*((Elf32_Addr *) location) = relocation;
+		else
+			goto relo_err;
+
+	}
+	return 0;
+
+relo_err:
+	pr_err("%s: unknown relocation: %u\n",
+		module->name, ELF32_R_TYPE(rel_entry[i].r_info));
+	return -ENOEXEC;
+
+}
+
+int module_finalize(const Elf32_Ehdr *hdr, const Elf_Shdr *sechdrs,
+		    struct module *mod)
+{
+    return 0;
+}
-- 
1.7.4.1

