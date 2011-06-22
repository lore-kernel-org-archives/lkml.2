Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807Ab1FVTJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:09:05 -0400
Received: from mail.southpole.se ([193.12.106.18]:45939 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758730Ab1FVTJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:09:04 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Valdis.Kletnieks@vt.edu, arnd@arndb.de, Jonas Bonn <jonas@southpole.se>
Subject: [PATCH 1/1] Add default implementations for moduleloader hooks
Date: Wed, 22 Jun 2011 21:08:58 +0200
Message-Id: <1308769738-29549-1-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <201106221626.12023.arnd@arndb.de>
References: <201106221626.12023.arnd@arndb.de>
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch puts in place generic implementations for the moduleloader
hooks that can be used by architectures that don't need to do anything
fancy for module loading.

As an example, the OpenRISC architecture is modified to use these
generic hooks.

This patch is just for comment for now... will need to add the necessary
definitions to the other architectures if this deemed ok.

Verified for OpenRISC... no sign-off for now.
---

Hi Arnd,

Threw this together to check if this is what you had in mind... seems pretty
good to me.  Will have to do the cleanups in the other architectures, but
thought I'd post this in response to your suggestion first.  What do you think?

/Jonas

 arch/openrisc/include/asm/module.h |   31 +++++++++++++++++
 arch/openrisc/kernel/module.c      |   62 ++---------------------------------
 kernel/module.c                    |   63 ++++++++++++++++++++++++++++++++++++
 3 files changed, 98 insertions(+), 58 deletions(-)
 create mode 100644 arch/openrisc/include/asm/module.h

diff --git a/arch/openrisc/include/asm/module.h b/arch/openrisc/include/asm/module.h
new file mode 100644
index 0000000..c550bed
--- /dev/null
+++ b/arch/openrisc/include/asm/module.h
@@ -0,0 +1,31 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_MODULE_H__
+#define __ASM_OPENRISC_MODULE_H__
+
+/*
+ * include/linux/moduleloader.h provides a set of architecture specific hooks
+ * for the module loader.  There are trivial default implementations for
+ * all of these hooks, but we need to set up some definitions for those hooks
+ * that we need to override.
+ */
+
+#define apply_relocate_add apply_relocate_add
+
+#include <asm-generic/module.h>
+
+#endif
diff --git a/arch/openrisc/kernel/module.c b/arch/openrisc/kernel/module.c
index 952b129..6a35c86 100644
--- a/arch/openrisc/kernel/module.c
+++ b/arch/openrisc/kernel/module.c
@@ -16,49 +16,16 @@
 
 #include <linux/moduleloader.h>
 #include <linux/elf.h>
-#include <linux/vmalloc.h>
-#include <linux/fs.h>
-#include <linux/string.h>
-#include <linux/kernel.h>
-
-void *module_alloc(unsigned long size)
-{
-	pr_debug("module_alloc size: %lu\n", size);
-
-	if (size == 0)
-		return NULL;
-
-	return vmalloc(size);
-}
-
-
-/* Free memory returned from module_alloc */
-void module_free(struct module *mod, void *module_region)
-{
-	vfree(module_region);
-	/* FIXME: If module_region == mod->init_region, trim exception
-           table entries. */
-}
-
-/* We don't need anything special. */
-int module_frob_arch_sections(Elf_Ehdr *hdr,
-			      Elf_Shdr *sechdrs,
-			      char *secstrings,
-			      struct module *mod)
-{
-	return 0;
-}
 
 int apply_relocate_add(Elf32_Shdr *sechdrs,
-		       const char *strtab,
-		       unsigned int symindex,
-		       unsigned int relsec,
-		       struct module *me)
+                       const char *strtab,
+                       unsigned int symindex,
+                       unsigned int relsec,
+                       struct module *me)
 {
 	unsigned int i;
 	Elf32_Rela *rel = (void *)sechdrs[relsec].sh_addr;
 	Elf32_Sym *sym;
-//	Elf32_Addr relocation;
 	uint32_t *location;
 	uint32_t value;
 
@@ -103,24 +70,3 @@ int apply_relocate_add(Elf32_Shdr *sechdrs,
 
 	return 0;
 }
-
-int apply_relocate(Elf32_Shdr *sechdrs,
-		   const char *strtab,
-		   unsigned int symindex,
-		   unsigned int relsec,
-		   struct module *me)
-{
-	pr_err("module %s: REL relocation unsupported\n", me->name);
-	return -ENOEXEC;
-}
-
-int module_finalize(const Elf_Ehdr *hdr,
-		    const Elf_Shdr *sechdrs,
-		    struct module *me)
-{
-	return 0;
-}
-
-void module_arch_cleanup(struct module *mod)
-{
-}
diff --git a/kernel/module.c b/kernel/module.c
index 795bdc7..ecb5538 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1697,6 +1697,19 @@ static void unset_module_core_ro_nx(struct module *mod) { }
 static void unset_module_init_ro_nx(struct module *mod) { }
 #endif
 
+#ifndef module_free
+void module_free(struct module *mod, void *module_region)
+{
+	vfree(module_region);
+}
+#endif
+
+#ifndef module_arch_cleanup
+void module_arch_cleanup(struct module *mod)
+{
+}
+#endif
+
 /* Free a module, remove from lists, etc. */
 static void free_module(struct module *mod)
 {
@@ -1851,6 +1864,30 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
 	return ret;
 }
 
+#ifndef apply_relocate
+int apply_relocate(Elf32_Shdr *sechdrs,
+                   const char *strtab,
+                   unsigned int symindex,
+                   unsigned int relsec,
+                   struct module *me)
+{
+	pr_err("module %s: REL relocation unsupported\n", me->name);
+	return -ENOEXEC;
+}
+#endif
+
+#ifndef apply_relocate_add
+int apply_relocate_add(Elf32_Shdr *sechdrs,
+                   const char *strtab,
+                   unsigned int symindex,
+                   unsigned int relsec,
+                   struct module *me)
+{
+	pr_err("module %s: RELA relocation unsupported\n", me->name);
+	return -ENOEXEC;
+}
+#endif
+
 static int apply_relocations(struct module *mod, const struct load_info *info)
 {
 	unsigned int i;
@@ -2235,6 +2272,13 @@ static void dynamic_debug_remove(struct _ddebug *debug)
 		ddebug_remove_module(debug->modname);
 }
 
+#ifndef module_alloc
+void *module_alloc(unsigned long size)
+{
+	return size == 0 ? NULL : vmalloc(size);
+}
+#endif
+
 static void *module_alloc_update_bounds(unsigned long size)
 {
 	void *ret = module_alloc(size);
@@ -2645,6 +2689,16 @@ static void flush_module_icache(const struct module *mod)
 	set_fs(old_fs);
 }
 
+#ifndef module_frob_arch_sections
+int module_frob_arch_sections(Elf_Ehdr *hdr,
+                              Elf_Shdr *sechdrs,
+                              char *secstrings,
+                              struct module *mod)
+{
+	return 0;
+}
+#endif
+
 static struct module *layout_and_allocate(struct load_info *info)
 {
 	/* Module within temporary copy. */
@@ -2716,6 +2770,15 @@ static void module_deallocate(struct module *mod, struct load_info *info)
 	module_free(mod, mod->module_core);
 }
 
+#ifndef module_finalize
+int module_finalize(const Elf_Ehdr *hdr,
+                    const Elf_Shdr *sechdrs,
+                    struct module *me)
+{
+	return 0;
+}
+#endif
+
 static int post_relocation(struct module *mod, const struct load_info *info)
 {
 	/* Sort exception table now relocations are done. */
-- 
1.7.4.1

