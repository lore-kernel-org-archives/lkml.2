Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab1FYHil (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 03:38:41 -0400
Received: from mail.southpole.se ([193.12.106.18]:32993 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab1FYHih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 03:38:37 -0400
From: Jonas Bonn <jonas@southpole.se>
To: rusty@rustcorp.com.au
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        monstr@monstr.eu, cmetcalf@tilera.com, Jonas Bonn <jonas@southpole.se>
Subject: [PATCH] modules: add default loader hook implementations
Date: Sat, 25 Jun 2011 09:38:32 +0200
Message-Id: <1308987512-6583-1-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The module loader code allows architectures to hook into the code by
providing a small number of entry points that each arch must implement.  This
patch provides generic implementations of these entry points for arch's
that don't need to do anything special.

The generic implementations are set to be used by default only for those
architectures that use asm-generic/module.h.  Architectures that do not use
this generic header will be required to implement all of the hooks as before.

Architectures that do use asm-generic/module.h get the default implementation
automatically and will need to provide a #define in their asm/module.h for
each of the hooks that they wish to override.  Being explicit about needing
to override the function should reduce some confusion as to which hook is
actually being used, and throws a nice link-time error if you try to
override the hook without providing the implementation.

An alternative would have been to provide the hooks and just mark them as
__weak, but there's reluctance to do so as it makes it more difficult to figure
out where the code that finally gets linked in is actually located.

This patch is as non-invasive as possible, changing the default behaviour
only for architectures that use asm-generic.  A review of the other arch's
should follow, as many of them can presumably also be simplified by making
use of these default hooks.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---

Hi Rusty,

The alternative implementation, just marking the default implementations as
__weak, is less invasive, but this patch is more along the lines of what
Arnd preferred.  If this version isn't to your liking, I can submit the
__weak alternative instead.

Tested on the OpenRISC architecture and build-tested for x86.

/Jonas

 arch/microblaze/include/asm/module.h |    4 ++
 arch/microblaze/kernel/module.c      |   35 -------------------
 arch/tile/include/asm/module.h       |   10 +++++
 arch/tile/kernel/module.c            |   31 ----------------
 arch/x86/include/asm/module.h        |   10 +++++
 arch/x86/kernel/module.c             |   37 --------------------
 include/asm-generic/module.h         |   13 +++++++
 include/linux/moduleloader.h         |   29 +++++++++++++++-
 kernel/module.c                      |   63 ++++++++++++++++++++++++++++++++++
 9 files changed, 128 insertions(+), 104 deletions(-)

diff --git a/arch/microblaze/include/asm/module.h b/arch/microblaze/include/asm/module.h
index 7be1347..e2d51d6 100644
--- a/arch/microblaze/include/asm/module.h
+++ b/arch/microblaze/include/asm/module.h
@@ -28,4 +28,8 @@
 
 typedef struct { volatile int counter; } module_t;
 
+/* Set defines for the moduleloader hooks that need to be overridden */
+#define apply_relocate_add apply_relocate_add
+#define module_finalize module_finalize
+
 #endif /* _ASM_MICROBLAZE_MODULE_H */
diff --git a/arch/microblaze/kernel/module.c b/arch/microblaze/kernel/module.c
index 0e73f66..142426f 100644
--- a/arch/microblaze/kernel/module.c
+++ b/arch/microblaze/kernel/module.c
@@ -18,37 +18,6 @@
 #include <asm/pgtable.h>
 #include <asm/cacheflush.h>
 
-void *module_alloc(unsigned long size)
-{
-	void *ret;
-	ret = (size == 0) ? NULL : vmalloc(size);
-	pr_debug("module_alloc (%08lx@%08lx)\n", size, (unsigned long int)ret);
-	return ret;
-}
-
-void module_free(struct module *module, void *region)
-{
-	pr_debug("module_free(%s,%08lx)\n", module->name,
-					(unsigned long)region);
-	vfree(region);
-}
-
-int module_frob_arch_sections(Elf_Ehdr *hdr,
-				Elf_Shdr *sechdrs,
-				char *secstrings,
-				struct module *mod)
-{
-	return 0;
-}
-
-int apply_relocate(Elf32_Shdr *sechdrs, const char *strtab,
-	unsigned int symindex, unsigned int relsec, struct module *module)
-{
-	printk(KERN_ERR "module %s: ADD RELOCATION unsupported\n",
-		module->name);
-	return -ENOEXEC;
-}
-
 int apply_relocate_add(Elf32_Shdr *sechdrs, const char *strtab,
 	unsigned int symindex, unsigned int relsec, struct module *module)
 {
@@ -155,7 +124,3 @@ int module_finalize(const Elf32_Ehdr *hdr, const Elf_Shdr *sechdrs,
 	flush_dcache();
 	return 0;
 }
-
-void module_arch_cleanup(struct module *mod)
-{
-}
diff --git a/arch/tile/include/asm/module.h b/arch/tile/include/asm/module.h
index 1e4b79f..670d266 100644
--- a/arch/tile/include/asm/module.h
+++ b/arch/tile/include/asm/module.h
@@ -1 +1,11 @@
+#ifndef _ASM_TILE_SYSTEM_H
+#define _ASM_TILE_SYSTEM_H
+
 #include <asm-generic/module.h>
+
+/* Set defines for the moduleloader hooks that need to be overridden */
+#define module_alloc module_alloc
+#define module_free module_free
+#define apply_relocate_add apply_relocate_add
+
+#endif
diff --git a/arch/tile/kernel/module.c b/arch/tile/kernel/module.c
index f68df69..28fa6ec 100644
--- a/arch/tile/kernel/module.c
+++ b/arch/tile/kernel/module.c
@@ -98,25 +98,6 @@ void module_free(struct module *mod, void *module_region)
 	 */
 }
 
-/* We don't need anything special. */
-int module_frob_arch_sections(Elf_Ehdr *hdr,
-			      Elf_Shdr *sechdrs,
-			      char *secstrings,
-			      struct module *mod)
-{
-	return 0;
-}
-
-int apply_relocate(Elf_Shdr *sechdrs,
-		   const char *strtab,
-		   unsigned int symindex,
-		   unsigned int relsec,
-		   struct module *me)
-{
-	pr_err("module %s: .rel relocation unsupported\n", me->name);
-	return -ENOEXEC;
-}
-
 #ifdef __tilegx__
 /*
  * Validate that the high 16 bits of "value" is just the sign-extension of
@@ -249,15 +230,3 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
 	}
 	return 0;
 }
-
-int module_finalize(const Elf_Ehdr *hdr,
-		    const Elf_Shdr *sechdrs,
-		    struct module *me)
-{
-	/* FIXME: perhaps remove the "writable" bit from the TLB? */
-	return 0;
-}
-
-void module_arch_cleanup(struct module *mod)
-{
-}
diff --git a/arch/x86/include/asm/module.h b/arch/x86/include/asm/module.h
index 9eae775..8ec7dc3 100644
--- a/arch/x86/include/asm/module.h
+++ b/arch/x86/include/asm/module.h
@@ -63,4 +63,14 @@
 # define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY
 #endif
 
+/* Set defines for the moduleloader hooks that need to be overridden */
+#define module_alloc module_alloc
+#ifdef CONFIG_X86_32
+#define apply_relocate apply_relocate
+#else
+#define apply_relocate_add apply_relocate_add
+#endif
+#define module_finalize module_finalize
+#define module_arch_cleanup module_arch_cleanup
+
 #endif /* _ASM_X86_MODULE_H */
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index 52f256f..925179f 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -45,21 +45,6 @@ void *module_alloc(unsigned long size)
 				-1, __builtin_return_address(0));
 }
 
-/* Free memory returned from module_alloc */
-void module_free(struct module *mod, void *module_region)
-{
-	vfree(module_region);
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
-
 #ifdef CONFIG_X86_32
 int apply_relocate(Elf32_Shdr *sechdrs,
 		   const char *strtab,
@@ -100,17 +85,6 @@ int apply_relocate(Elf32_Shdr *sechdrs,
 	}
 	return 0;
 }
-
-int apply_relocate_add(Elf32_Shdr *sechdrs,
-		       const char *strtab,
-		       unsigned int symindex,
-		       unsigned int relsec,
-		       struct module *me)
-{
-	printk(KERN_ERR "module %s: ADD RELOCATION unsupported\n",
-	       me->name);
-	return -ENOEXEC;
-}
 #else /*X86_64*/
 int apply_relocate_add(Elf64_Shdr *sechdrs,
 		   const char *strtab,
@@ -181,17 +155,6 @@ overflow:
 	       me->name);
 	return -ENOEXEC;
 }
-
-int apply_relocate(Elf_Shdr *sechdrs,
-		   const char *strtab,
-		   unsigned int symindex,
-		   unsigned int relsec,
-		   struct module *me)
-{
-	printk(KERN_ERR "non add relocation not supported\n");
-	return -ENOSYS;
-}
-
 #endif
 
 int module_finalize(const Elf_Ehdr *hdr,
diff --git a/include/asm-generic/module.h b/include/asm-generic/module.h
index ed5b44d..4e5dec8 100644
--- a/include/asm-generic/module.h
+++ b/include/asm-generic/module.h
@@ -19,4 +19,17 @@ struct mod_arch_specific
 #define Elf_Ehdr Elf32_Ehdr
 #endif
 
+/* This configures the module loader code to use the default implementations
+ * for the architecture specific hooks.  Architectures should set a #define
+ * for each of the hooks that it needs to override.
+ */
+#define asm_generic_moduleloader_hooks 1
+#undef module_frob_arch_sections
+#undef module_alloc
+#undef module_free
+#undef apply_relocate
+#undef apply_relocate_add
+#undef module_finalize
+#undef module_arch_cleanup
+
 #endif /* __ASM_GENERIC_MODULE_H */
diff --git a/include/linux/moduleloader.h b/include/linux/moduleloader.h
index c1f40c2..a21589b 100644
--- a/include/linux/moduleloader.h
+++ b/include/linux/moduleloader.h
@@ -1,6 +1,33 @@
 #ifndef _LINUX_MODULELOADER_H
 #define _LINUX_MODULELOADER_H
-/* The stuff needed for archs to support modules. */
+
+/* Architecture specific hooks into the module loader code */
+
+/* The hooks declared in this file all have trivial default implementations
+ * that can be used by architectures that don't have special requirements for
+ * these entry points.  They are 'effectively weak':  they can be overridden
+ * but require an explicit 'declaration of intent' in that they require the
+ * architecture to set a #define in their asm/module.h for each of the hooks
+ * they wish to override.  If no define is set, the default hook will be
+ * called and you'll get a link error if you try to override the function
+ * elsewhere.  This (hopefully) will prevent some confusion as to which
+ * implementation of the hook is actually being used...
+ */
+
+/* The default behaviour requires that an architecture implement each of
+ * these hooks.  The asm-generic/module.h header reverses this behaviour
+ * and defaults to using the default hooks, which should be reasonable
+ * for new architectures.
+ */
+#ifndef asm_generic_moduleloader_hooks
+#define module_frob_arch_sections module_frob_arch_sections
+#define module_alloc module_alloc
+#define module_free module_free
+#define apply_relocate apply_relocate
+#define apply_relocate_add apply_relocate_add
+#define module_finalize module_finalize
+#define module_arch_cleanup module_arch_cleanup
+#endif
 
 #include <linux/module.h>
 #include <linux/elf.h>
diff --git a/kernel/module.c b/kernel/module.c
index 795bdc7..71a2dbe4 100644
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
+int apply_relocate(Elf_Shdr *sechdrs,
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
+int apply_relocate_add(Elf_Shdr *sechdrs,
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

