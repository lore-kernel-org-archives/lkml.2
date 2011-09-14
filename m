Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666Ab1IQAqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 20:46:36 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27878 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595Ab1IQAqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 20:46:33 -0400
Message-Id: <e97c6e$3hnnvk@wolverine02.qualcomm.com>
X-IronPort-AV: E=McAfee;i="5400,1158,6471"; a="119267316"
From: Richard Kuo <rkuo@codeaurora.org>
Date: Wed, 14 Sep 2011 13:18:57 -0500
Subject: [PATCH v4 13/36] Hexagon: Support dynamic module loading.
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modules should be compiled as ordinary .o's; shared objects are not
supported.

Signed-off-by: Linas Vepstas <linas@codeaurora.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/hexagon/kernel/module.c |  162 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 162 insertions(+), 0 deletions(-)
 create mode 100644 arch/hexagon/kernel/module.c

diff --git a/arch/hexagon/kernel/module.c b/arch/hexagon/kernel/module.c
new file mode 100644
index 0000000..61a76ba
--- /dev/null
+++ b/arch/hexagon/kernel/module.c
@@ -0,0 +1,162 @@
+/*
+ * Kernel module loader for Hexagon
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <asm/module.h>
+#include <linux/elf.h>
+#include <linux/module.h>
+#include <linux/moduleloader.h>
+#include <linux/vmalloc.h>
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(fmt , ...)
+#endif
+
+/*
+ * module_frob_arch_sections - tweak got/plt sections.
+ * @hdr - pointer to elf header
+ * @sechdrs - pointer to elf load section headers
+ * @secstrings - symbol names
+ * @mod - pointer to module
+ */
+int module_frob_arch_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
+				char *secstrings,
+				struct module *mod)
+{
+	unsigned int i;
+	int found = 0;
+
+	/* Look for .plt and/or .got.plt and/or .init.plt sections */
+	for (i = 0; i < hdr->e_shnum; i++) {
+		DEBUGP("Section %d is %s\n", i,
+		       secstrings + sechdrs[i].sh_name);
+		if (strcmp(secstrings + sechdrs[i].sh_name, ".plt") == 0)
+			found = i+1;
+		if (strcmp(secstrings + sechdrs[i].sh_name, ".got.plt") == 0)
+			found = i+1;
+		if (strcmp(secstrings + sechdrs[i].sh_name, ".rela.plt") == 0)
+			found = i+1;
+	}
+
+	/* At this time, we don't support modules comiled with -shared */
+	if (found) {
+		printk(KERN_WARNING
+			"Module '%s' contains unexpected .plt/.got sections.\n",
+			mod->name);
+		/*  return -ENOEXEC;  */
+	}
+
+	return 0;
+}
+
+/*
+ * apply_relocate_add - perform rela relocations.
+ * @sechdrs - pointer to section headers
+ * @strtab - some sort of start address?
+ * @symindex - symbol index offset or something?
+ * @relsec - address to relocate to?
+ * @module - pointer to module
+ *
+ * Perform rela relocations.
+ */
+int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
+			unsigned int symindex, unsigned int relsec,
+			struct module *module)
+{
+	unsigned int i;
+	Elf32_Sym *sym;
+	uint32_t *location;
+	uint32_t value;
+	unsigned int nrelocs = sechdrs[relsec].sh_size / sizeof(Elf32_Rela);
+	Elf32_Rela *rela = (void *)sechdrs[relsec].sh_addr;
+	Elf32_Word sym_info = sechdrs[relsec].sh_info;
+	Elf32_Sym *sym_base = (Elf32_Sym *) sechdrs[symindex].sh_addr;
+	void *loc_base = (void *) sechdrs[sym_info].sh_addr;
+
+	DEBUGP("Applying relocations in section %u to section %u base=%p\n",
+	       relsec, sym_info, loc_base);
+
+	for (i = 0; i < nrelocs; i++) {
+
+		/* Symbol to relocate */
+		sym = sym_base + ELF32_R_SYM(rela[i].r_info);
+
+		/* Where to make the change */
+		location = loc_base + rela[i].r_offset;
+
+		/* `Everything is relative'. */
+		value = sym->st_value + rela[i].r_addend;
+
+		DEBUGP("%d: value=%08x loc=%p reloc=%d symbol=%s\n",
+		       i, value, location, ELF32_R_TYPE(rela[i].r_info),
+		       sym->st_name ?
+		       &strtab[sym->st_name] : "(anonymous)");
+
+		switch (ELF32_R_TYPE(rela[i].r_info)) {
+		case R_HEXAGON_B22_PCREL: {
+			int dist = (int)(value - (uint32_t)location);
+			if ((dist < -0x00800000) ||
+			    (dist >= 0x00800000)) {
+				printk(KERN_ERR
+				       "%s: %s: %08x=%08x-%08x %s\n",
+				       module->name,
+				       "R_HEXAGON_B22_PCREL reloc out of range",
+				       dist, value, (uint32_t)location,
+				       sym->st_name ?
+				       &strtab[sym->st_name] : "(anonymous)");
+				return -ENOEXEC;
+			}
+			DEBUGP("B22_PCREL contents: %08X.\n", *location);
+			*location &= ~0x01ff3fff;
+			*location |= 0x00003fff & dist;
+			*location |= 0x01ff0000 & (dist<<2);
+			DEBUGP("Contents after reloc: %08x\n", *location);
+			break;
+		}
+		case R_HEXAGON_HI16:
+			value = (value>>16) & 0xffff;
+			/* fallthrough */
+		case R_HEXAGON_LO16:
+			*location &= ~0x00c03fff;
+			*location |= value & 0x3fff;
+			*location |= (value & 0xc000) << 8;
+			break;
+		case R_HEXAGON_32:
+			*location = value;
+			break;
+		case R_HEXAGON_32_PCREL:
+			*location = value - (uint32_t)location;
+			break;
+		case R_HEXAGON_PLT_B22_PCREL:
+		case R_HEXAGON_GOTOFF_LO16:
+		case R_HEXAGON_GOTOFF_HI16:
+			printk(KERN_ERR "%s: GOT/PLT relocations unsupported\n",
+			       module->name);
+			return -ENOEXEC;
+		default:
+			printk(KERN_ERR "%s: unknown relocation: %u\n",
+			       module->name,
+			       ELF32_R_TYPE(rela[i].r_info));
+			return -ENOEXEC;
+		}
+	}
+	return 0;
+}
-- 
1.7.1


--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
