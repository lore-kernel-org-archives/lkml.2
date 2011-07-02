Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab1GBVSn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 17:18:43 -0400
Received: from mail.southpole.se ([193.12.106.18]:45888 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872Ab1GBVQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 17:16:20 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH v2 14/19] OpenRISC: Module support
Date: Sat,  2 Jul 2011 23:15:47 +0200
Message-Id: <1309641352-18714-15-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309641352-18714-1-git-send-email-jonas@southpole.se>
References: <1309641352-18714-1-git-send-email-jonas@southpole.se>
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is still our old module support implementation.  There's a pending
patch to move a lot of this functionality into default hooks that are
available in core code to all arches; if that patch is accepted, this
patch becomes significantly smaller.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 arch/openrisc/kernel/module.c |  126 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 126 insertions(+), 0 deletions(-)
 create mode 100644 arch/openrisc/kernel/module.c

diff --git a/arch/openrisc/kernel/module.c b/arch/openrisc/kernel/module.c
new file mode 100644
index 0000000..952b129
--- /dev/null
+++ b/arch/openrisc/kernel/module.c
@@ -0,0 +1,126 @@
+/*
+ * OpenRISC module.c
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * Modifications for the OpenRISC architecture:
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/moduleloader.h>
+#include <linux/elf.h>
+#include <linux/vmalloc.h>
+#include <linux/fs.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+
+void *module_alloc(unsigned long size)
+{
+	pr_debug("module_alloc size: %lu\n", size);
+
+	if (size == 0)
+		return NULL;
+
+	return vmalloc(size);
+}
+
+
+/* Free memory returned from module_alloc */
+void module_free(struct module *mod, void *module_region)
+{
+	vfree(module_region);
+	/* FIXME: If module_region == mod->init_region, trim exception
+           table entries. */
+}
+
+/* We don't need anything special. */
+int module_frob_arch_sections(Elf_Ehdr *hdr,
+			      Elf_Shdr *sechdrs,
+			      char *secstrings,
+			      struct module *mod)
+{
+	return 0;
+}
+
+int apply_relocate_add(Elf32_Shdr *sechdrs,
+		       const char *strtab,
+		       unsigned int symindex,
+		       unsigned int relsec,
+		       struct module *me)
+{
+	unsigned int i;
+	Elf32_Rela *rel = (void *)sechdrs[relsec].sh_addr;
+	Elf32_Sym *sym;
+//	Elf32_Addr relocation;
+	uint32_t *location;
+	uint32_t value;
+
+	pr_debug("Applying relocate section %u to %u\n", relsec,
+		 sechdrs[relsec].sh_info);
+	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
+		/* This is where to make the change */
+		location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
+			+ rel[i].r_offset;
+
+		/* This is the symbol it is referring to.  Note that all
+		   undefined symbols have been resolved.  */
+		sym = (Elf32_Sym *)sechdrs[symindex].sh_addr
+			+ ELF32_R_SYM(rel[i].r_info);
+		value = sym->st_value + rel[i].r_addend;
+
+		switch(ELF32_R_TYPE(rel[i].r_info)) {
+		case R_OR32_32:
+			*location = value;
+			break;
+		case R_OR32_CONST:
+			location = (uint16_t*)location + 1;
+			*((uint16_t*)location) = (uint16_t) (value);
+			break;
+		case R_OR32_CONSTH:
+			location = (uint16_t*)location + 1;
+			*((uint16_t*)location) = (uint16_t) (value >> 16);
+			break;
+		case R_OR32_JUMPTARG:
+			value -= (uint32_t)location;
+			value >>= 2;
+			value &= 0x03ffffff;
+			value |= *location & 0xfc000000;
+			*location = value;
+			break;
+		default:
+			pr_err("module %s: Unknown relocation: %u\n",
+			       me->name, ELF32_R_TYPE(rel[i].r_info));
+			break;
+		}
+	}
+
+	return 0;
+}
+
+int apply_relocate(Elf32_Shdr *sechdrs,
+		   const char *strtab,
+		   unsigned int symindex,
+		   unsigned int relsec,
+		   struct module *me)
+{
+	pr_err("module %s: REL relocation unsupported\n", me->name);
+	return -ENOEXEC;
+}
+
+int module_finalize(const Elf_Ehdr *hdr,
+		    const Elf_Shdr *sechdrs,
+		    struct module *me)
+{
+	return 0;
+}
+
+void module_arch_cleanup(struct module *mod)
+{
+}
-- 
1.7.4.1

