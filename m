Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab1F3TWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 15:22:34 -0400
Received: from mail.southpole.se ([193.12.106.18]:37710 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab1F3TWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 15:22:18 -0400
From: Jonas Bonn <jonas@southpole.se>
To: rusty@rustcorp.com.au
Cc: arnd@ardnb.de, geert@linux-m68k.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        monstr@monstr.eu, cmetcalf@tilera.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, Jonas Bonn <jonas@southpole.se>
Subject: [PATCH 2/2] modules: make arch's use default loader hooks
Date: Thu, 30 Jun 2011 21:22:12 +0200
Message-Id: <1309461732-2875-2-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309461732-2875-1-git-send-email-jonas@southpole.se>
References: <201106281245.19457.arnd@arndb.de>
 <1309461732-2875-1-git-send-email-jonas@southpole.se>
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch removes all the module loader hook implementations in the
architecture specific code where the functionality is the same as that
now provided by the recently added default hooks.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 arch/alpha/kernel/module.c      |   34 ---------------------
 arch/arm/kernel/module.c        |   29 +------------------
 arch/avr32/kernel/module.c      |   20 -------------
 arch/blackfin/kernel/module.c   |   21 -------------
 arch/cris/kernel/module.c       |   43 ++-------------------------
 arch/frv/kernel/module.c        |   57 ++----------------------------------
 arch/h8300/kernel/module.c      |   45 ----------------------------
 arch/ia64/kernel/module.c       |   16 ----------
 arch/m32r/kernel/module.c       |   38 ------------------------
 arch/m68k/kernel/module_mm.c    |   27 -----------------
 arch/m68k/kernel/module_no.c    |   34 ---------------------
 arch/microblaze/kernel/module.c |   35 ----------------------
 arch/mips/kernel/module.c       |   20 +-----------
 arch/mn10300/kernel/module.c    |   61 ---------------------------------------
 arch/parisc/kernel/module.c     |   12 -------
 arch/powerpc/kernel/module.c    |   18 -----------
 arch/powerpc/kernel/module_32.c |   11 -------
 arch/powerpc/kernel/module_64.c |   10 ------
 arch/s390/kernel/module.c       |   20 -------------
 arch/score/kernel/module.c      |   29 ++----------------
 arch/sh/kernel/module.c         |   35 ----------------------
 arch/sparc/kernel/module.c      |   28 ------------------
 arch/tile/kernel/module.c       |   31 --------------------
 arch/unicore32/kernel/module.c  |   35 ----------------------
 arch/x86/kernel/module.c        |   37 -----------------------
 arch/xtensa/kernel/module.c     |   43 ---------------------------
 26 files changed, 12 insertions(+), 777 deletions(-)

diff --git a/arch/alpha/kernel/module.c b/arch/alpha/kernel/module.c
index ebc3c89..2fd00b7 100644
--- a/arch/alpha/kernel/module.c
+++ b/arch/alpha/kernel/module.c
@@ -29,20 +29,6 @@
 #define DEBUGP(fmt...)
 #endif
 
-void *
-module_alloc(unsigned long size)
-{
-	if (size == 0)
-		return NULL;
-	return vmalloc(size);
-}
-
-void
-module_free(struct module *mod, void *module_region)
-{
-	vfree(module_region);
-}
-
 /* Allocate the GOT at the end of the core sections.  */
 
 struct got_entry {
@@ -156,14 +142,6 @@ module_frob_arch_sections(Elf64_Ehdr *hdr, Elf64_Shdr *sechdrs,
 }
 
 int
-apply_relocate(Elf64_Shdr *sechdrs, const char *strtab, unsigned int symindex,
-	       unsigned int relsec, struct module *me)
-{
-	printk(KERN_ERR "module %s: REL relocation unsupported\n", me->name);
-	return -ENOEXEC;
-}
-
-int
 apply_relocate_add(Elf64_Shdr *sechdrs, const char *strtab,
 		   unsigned int symindex, unsigned int relsec,
 		   struct module *me)
@@ -302,15 +280,3 @@ apply_relocate_add(Elf64_Shdr *sechdrs, const char *strtab,
 
 	return 0;
 }
-
-int
-module_finalize(const Elf_Ehdr *hdr, const Elf_Shdr *sechdrs,
-		struct module *me)
-{
-	return 0;
-}
-
-void
-module_arch_cleanup(struct module *mod)
-{
-}
diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
index fee7c36..85a68b1 100644
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -43,25 +43,7 @@ void *module_alloc(unsigned long size)
 				GFP_KERNEL, PAGE_KERNEL_EXEC, -1,
 				__builtin_return_address(0));
 }
-#else /* CONFIG_MMU */
-void *module_alloc(unsigned long size)
-{
-	return size == 0 ? NULL : vmalloc(size);
-}
-#endif /* !CONFIG_MMU */
-
-void module_free(struct module *module, void *region)
-{
-	vfree(region);
-}
-
-int module_frob_arch_sections(Elf_Ehdr *hdr,
-			      Elf_Shdr *sechdrs,
-			      char *secstrings,
-			      struct module *mod)
-{
-	return 0;
-}
+#endif
 
 int
 apply_relocate(Elf32_Shdr *sechdrs, const char *strtab, unsigned int symindex,
@@ -256,15 +238,6 @@ apply_relocate(Elf32_Shdr *sechdrs, const char *strtab, unsigned int symindex,
 	return 0;
 }
 
-int
-apply_relocate_add(Elf32_Shdr *sechdrs, const char *strtab,
-		   unsigned int symindex, unsigned int relsec, struct module *module)
-{
-	printk(KERN_ERR "module %s: ADD RELOCATION unsupported\n",
-	       module->name);
-	return -ENOEXEC;
-}
-
 struct mod_unwind_map {
 	const Elf_Shdr *unw_sec;
 	const Elf_Shdr *txt_sec;
diff --git a/arch/avr32/kernel/module.c b/arch/avr32/kernel/module.c
index a727f54..596f730 100644
--- a/arch/avr32/kernel/module.c
+++ b/arch/avr32/kernel/module.c
@@ -19,13 +19,6 @@
 #include <linux/moduleloader.h>
 #include <linux/vmalloc.h>
 
-void *module_alloc(unsigned long size)
-{
-	if (size == 0)
-		return NULL;
-	return vmalloc(size);
-}
-
 void module_free(struct module *mod, void *module_region)
 {
 	vfree(mod->arch.syminfo);
@@ -299,15 +292,6 @@ int apply_relocate_add(Elf32_Shdr *sechdrs, const char *strtab,
 	return ret;
 }
 
-int apply_relocate(Elf32_Shdr *sechdrs, const char *strtab,
-		   unsigned int symindex, unsigned int relindex,
-		   struct module *module)
-{
-	printk(KERN_ERR "module %s: REL relocations are not supported\n",
-		module->name);
-	return -ENOEXEC;
-}
-
 int module_finalize(const Elf_Ehdr *hdr, const Elf_Shdr *sechdrs,
 		    struct module *module)
 {
@@ -316,7 +300,3 @@ int module_finalize(const Elf_Ehdr *hdr, const Elf_Shdr *sechdrs,
 
 	return 0;
 }
-
-void module_arch_cleanup(struct module *module)
-{
-}
diff --git a/arch/blackfin/kernel/module.c b/arch/blackfin/kernel/module.c
index 35e350c..4489efc 100644
--- a/arch/blackfin/kernel/module.c
+++ b/arch/blackfin/kernel/module.c
@@ -16,19 +16,6 @@
 #include <asm/cacheflush.h>
 #include <asm/uaccess.h>
 
-void *module_alloc(unsigned long size)
-{
-	if (size == 0)
-		return NULL;
-	return vmalloc(size);
-}
-
-/* Free memory returned from module_alloc */
-void module_free(struct module *mod, void *module_region)
-{
-	vfree(module_region);
-}
-
 /* Transfer the section to the L1 memory */
 int
 module_frob_arch_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
@@ -150,14 +137,6 @@ module_frob_arch_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
 	return 0;
 }
 
-int
-apply_relocate(Elf_Shdr * sechdrs, const char *strtab,
-	       unsigned int symindex, unsigned int relsec, struct module *mod)
-{
-	pr_err(".rel unsupported\n");
-	return -ENOEXEC;
-}
-
 /*************************************************************************/
 /* FUNCTION : apply_relocate_add                                         */
 /* ABSTRACT : Blackfin specific relocation handling for the loadable     */
diff --git a/arch/cris/kernel/module.c b/arch/cris/kernel/module.c
index bcd502f..37400f5 100644
--- a/arch/cris/kernel/module.c
+++ b/arch/cris/kernel/module.c
@@ -30,45 +30,19 @@
 #endif
 
 #ifdef CONFIG_ETRAX_KMALLOCED_MODULES
-#define MALLOC_MODULE(size) kmalloc(size, GFP_KERNEL)
-#define FREE_MODULE(region) kfree(region)
-#else
-#define MALLOC_MODULE(size) vmalloc_exec(size)
-#define FREE_MODULE(region) vfree(region)
-#endif
-
 void *module_alloc(unsigned long size)
 {
 	if (size == 0)
 		return NULL;
-	return MALLOC_MODULE(size);
+	return kmalloc(size, GFP_KERNEL);
 }
 
-
 /* Free memory returned from module_alloc */
 void module_free(struct module *mod, void *module_region)
 {
-	FREE_MODULE(module_region);
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
-int apply_relocate(Elf32_Shdr *sechdrs,
-		   const char *strtab,
-		   unsigned int symindex,
-		   unsigned int relsec,
-		   struct module *me)
-{
-	printk(KERN_ERR "module %s: REL relocation unsupported\n", me->name);
-	return -ENOEXEC;
+	kfree(module_region);
 }
+#endif
 
 int apply_relocate_add(Elf32_Shdr *sechdrs,
 		       const char *strtab,
@@ -108,14 +82,3 @@ int apply_relocate_add(Elf32_Shdr *sechdrs,
 
 	return 0;
 }
-
-int module_finalize(const Elf_Ehdr *hdr,
-		    const Elf_Shdr *sechdrs,
-		    struct module *me)
-{
- 	return 0;
-}
-
-void module_arch_cleanup(struct module *mod)
-{
-}
diff --git a/arch/frv/kernel/module.c b/arch/frv/kernel/module.c
index 711763c..9d9835f 100644
--- a/arch/frv/kernel/module.c
+++ b/arch/frv/kernel/module.c
@@ -22,57 +22,6 @@
 #define DEBUGP(fmt...)
 #endif
 
-void *module_alloc(unsigned long size)
-{
-	if (size == 0)
-		return NULL;
-
-	return vmalloc_exec(size);
-}
-
-
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
-int apply_relocate(Elf32_Shdr *sechdrs,
-		   const char *strtab,
-		   unsigned int symindex,
-		   unsigned int relsec,
-		   struct module *me)
-{
-	printk(KERN_ERR "module %s: ADD RELOCATION unsupported\n", me->name);
-	return -ENOEXEC;
-}
-
-int apply_relocate_add(Elf32_Shdr *sechdrs,
-		       const char *strtab,
-		       unsigned int symindex,
-		       unsigned int relsec,
-		       struct module *me)
-{
-	printk(KERN_ERR "module %s: ADD RELOCATION unsupported\n", me->name);
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
+/* TODO: At least one of apply_relocate or apply_relocate_add must be
+ * implemented in order to get working module support.
+ */
diff --git a/arch/h8300/kernel/module.c b/arch/h8300/kernel/module.c
index db4953d..1d526e0 100644
--- a/arch/h8300/kernel/module.c
+++ b/arch/h8300/kernel/module.c
@@ -11,40 +11,6 @@
 #define DEBUGP(fmt...)
 #endif
 
-void *module_alloc(unsigned long size)
-{
-	if (size == 0)
-		return NULL;
-	return vmalloc(size);
-}
-
-
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
-int apply_relocate(Elf32_Shdr *sechdrs,
-		   const char *strtab,
-		   unsigned int symindex,
-		   unsigned int relsec,
-		   struct module *me)
-{
-	printk(KERN_ERR "module %s: RELOCATION unsupported\n",
-	       me->name);
-	return -ENOEXEC;
-}
-
 int apply_relocate_add(Elf32_Shdr *sechdrs,
 		       const char *strtab,
 		       unsigned int symindex,
@@ -107,14 +73,3 @@ int apply_relocate_add(Elf32_Shdr *sechdrs,
 	       me->name, rela[i].r_offset);
 	return -ENOEXEC;
 }
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
diff --git a/arch/ia64/kernel/module.c b/arch/ia64/kernel/module.c
index 1481b0a..24603be 100644
--- a/arch/ia64/kernel/module.c
+++ b/arch/ia64/kernel/module.c
@@ -304,14 +304,6 @@ plt_target (struct plt_entry *plt)
 
 #endif /* !USE_BRL */
 
-void *
-module_alloc (unsigned long size)
-{
-	if (!size)
-		return NULL;
-	return vmalloc(size);
-}
-
 void
 module_free (struct module *mod, void *module_region)
 {
@@ -853,14 +845,6 @@ apply_relocate_add (Elf64_Shdr *sechdrs, const char *strtab, unsigned int symind
 	return 0;
 }
 
-int
-apply_relocate (Elf64_Shdr *sechdrs, const char *strtab, unsigned int symindex,
-		unsigned int relsec, struct module *mod)
-{
-	printk(KERN_ERR "module %s: REL relocs in section %u unsupported\n", mod->name, relsec);
-	return -ENOEXEC;
-}
-
 /*
  * Modules contain a single unwind table which covers both the core and the init text
  * sections but since the two are not contiguous, we need to split this table up such that
diff --git a/arch/m32r/kernel/module.c b/arch/m32r/kernel/module.c
index cb5f37d..3071fe8 100644
--- a/arch/m32r/kernel/module.c
+++ b/arch/m32r/kernel/module.c
@@ -28,33 +28,6 @@
 #define DEBUGP(fmt...)
 #endif
 
-void *module_alloc(unsigned long size)
-{
-	if (size == 0)
-		return NULL;
-#ifdef CONFIG_MMU
-	return vmalloc_exec(size);
-#else
-	return vmalloc(size);
-#endif
-}
-
-
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
 #define COPY_UNALIGNED_WORD(sw, tw, align) \
 { \
 	void *__s = &(sw), *__t = &(tw); \
@@ -243,14 +216,3 @@ int apply_relocate(Elf32_Shdr *sechdrs,
 	return 0;
 
 }
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
diff --git a/arch/m68k/kernel/module_mm.c b/arch/m68k/kernel/module_mm.c
index cd6bcb1..ceafc47 100644
--- a/arch/m68k/kernel/module_mm.c
+++ b/arch/m68k/kernel/module_mm.c
@@ -19,29 +19,6 @@
 
 #ifdef CONFIG_MODULES
 
-void *module_alloc(unsigned long size)
-{
-	if (size == 0)
-		return NULL;
-	return vmalloc(size);
-}
-
-
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
 int apply_relocate(Elf32_Shdr *sechdrs,
 		   const char *strtab,
 		   unsigned int symindex,
@@ -131,10 +108,6 @@ int module_finalize(const Elf_Ehdr *hdr,
 	return 0;
 }
 
-void module_arch_cleanup(struct module *mod)
-{
-}
-
 #endif /* CONFIG_MODULES */
 
 void module_fixup(struct module *mod, struct m68k_fixup_info *start,
diff --git a/arch/m68k/kernel/module_no.c b/arch/m68k/kernel/module_no.c
index d11ffae..5a097c6 100644
--- a/arch/m68k/kernel/module_no.c
+++ b/arch/m68k/kernel/module_no.c
@@ -11,29 +11,6 @@
 #define DEBUGP(fmt...)
 #endif
 
-void *module_alloc(unsigned long size)
-{
-	if (size == 0)
-		return NULL;
-	return vmalloc(size);
-}
-
-
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
 int apply_relocate(Elf32_Shdr *sechdrs,
 		   const char *strtab,
 		   unsigned int symindex,
@@ -113,14 +90,3 @@ int apply_relocate_add(Elf32_Shdr *sechdrs,
 	}
 	return 0;
 }
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
diff --git a/arch/mips/kernel/module.c b/arch/mips/kernel/module.c
index dd940b7..4b930ac 100644
--- a/arch/mips/kernel/module.c
+++ b/arch/mips/kernel/module.c
@@ -45,30 +45,14 @@ static struct mips_hi16 *mips_hi16_list;
 static LIST_HEAD(dbe_list);
 static DEFINE_SPINLOCK(dbe_lock);
 
+#ifdef MODULE_START
 void *module_alloc(unsigned long size)
 {
-#ifdef MODULE_START
 	return __vmalloc_node_range(size, 1, MODULE_START, MODULE_END,
 				GFP_KERNEL, PAGE_KERNEL, -1,
 				__builtin_return_address(0));
-#else
-	if (size == 0)
-		return NULL;
-	return vmalloc(size);
-#endif
-}
-
-/* Free memory returned from module_alloc */
-void module_free(struct module *mod, void *module_region)
-{
-	vfree(module_region);
-}
-
-int module_frob_arch_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
-			      char *secstrings, struct module *mod)
-{
-	return 0;
 }
+#endif
 
 static int apply_r_mips_none(struct module *me, u32 *location, Elf_Addr v)
 {
diff --git a/arch/mn10300/kernel/module.c b/arch/mn10300/kernel/module.c
index 196a111..216ad23 100644
--- a/arch/mn10300/kernel/module.c
+++ b/arch/mn10300/kernel/module.c
@@ -32,36 +32,6 @@
 #define DEBUGP(fmt, ...)
 #endif
 
-/*
- * allocate storage for a module
- */
-void *module_alloc(unsigned long size)
-{
-	if (size == 0)
-		return NULL;
-	return vmalloc_exec(size);
-}
-
-/*
- * free memory returned from module_alloc()
- */
-void module_free(struct module *mod, void *module_region)
-{
-	vfree(module_region);
-}
-
-/*
- * allow the arch to fix up the section table
- * - we don't need anything special
- */
-int module_frob_arch_sections(Elf_Ehdr *hdr,
-			      Elf_Shdr *sechdrs,
-			      char *secstrings,
-			      struct module *mod)
-{
-	return 0;
-}
-
 static void reloc_put16(uint8_t *p, uint32_t val)
 {
 	p[0] = val & 0xff;
@@ -81,20 +51,6 @@ static void reloc_put32(uint8_t *p, uint32_t val)
 }
 
 /*
- * apply a REL relocation
- */
-int apply_relocate(Elf32_Shdr *sechdrs,
-		   const char *strtab,
-		   unsigned int symindex,
-		   unsigned int relsec,
-		   struct module *me)
-{
-	printk(KERN_ERR "module %s: RELOCATION unsupported\n",
-	       me->name);
-	return -ENOEXEC;
-}
-
-/*
  * apply a RELA relocation
  */
 int apply_relocate_add(Elf32_Shdr *sechdrs,
@@ -198,20 +154,3 @@ int apply_relocate_add(Elf32_Shdr *sechdrs,
 	}
 	return 0;
 }
-
-/*
- * finish loading the module
- */
-int module_finalize(const Elf_Ehdr *hdr,
-		    const Elf_Shdr *sechdrs,
-		    struct module *me)
-{
-	return 0;
-}
-
-/*
- * finish clearing the module
- */
-void module_arch_cleanup(struct module *mod)
-{
-}
diff --git a/arch/parisc/kernel/module.c b/arch/parisc/kernel/module.c
index cedbbb8..5e34ccf 100644
--- a/arch/parisc/kernel/module.c
+++ b/arch/parisc/kernel/module.c
@@ -540,18 +540,6 @@ static Elf_Addr get_stub(struct module *me, unsigned long value, long addend,
 	return (Elf_Addr)stub;
 }
 
-int apply_relocate(Elf_Shdr *sechdrs,
-		   const char *strtab,
-		   unsigned int symindex,
-		   unsigned int relsec,
-		   struct module *me)
-{
-	/* parisc should not need this ... */
-	printk(KERN_ERR "module %s: RELOCATION unsupported\n",
-	       me->name);
-	return -ENOEXEC;
-}
-
 #ifndef CONFIG_64BIT
 int apply_relocate_add(Elf_Shdr *sechdrs,
 		       const char *strtab,
diff --git a/arch/powerpc/kernel/module.c b/arch/powerpc/kernel/module.c
index 49cee9d..a1cd701 100644
--- a/arch/powerpc/kernel/module.c
+++ b/arch/powerpc/kernel/module.c
@@ -31,20 +31,6 @@
 
 LIST_HEAD(module_bug_list);
 
-void *module_alloc(unsigned long size)
-{
-	if (size == 0)
-		return NULL;
-
-	return vmalloc_exec(size);
-}
-
-/* Free memory returned from module_alloc */
-void module_free(struct module *mod, void *module_region)
-{
-	vfree(module_region);
-}
-
 static const Elf_Shdr *find_section(const Elf_Ehdr *hdr,
 				    const Elf_Shdr *sechdrs,
 				    const char *name)
@@ -93,7 +79,3 @@ int module_finalize(const Elf_Ehdr *hdr,
 
 	return 0;
 }
-
-void module_arch_cleanup(struct module *mod)
-{
-}
diff --git a/arch/powerpc/kernel/module_32.c b/arch/powerpc/kernel/module_32.c
index f832773..0b6d796 100644
--- a/arch/powerpc/kernel/module_32.c
+++ b/arch/powerpc/kernel/module_32.c
@@ -174,17 +174,6 @@ int module_frob_arch_sections(Elf32_Ehdr *hdr,
 	return 0;
 }
 
-int apply_relocate(Elf32_Shdr *sechdrs,
-		   const char *strtab,
-		   unsigned int symindex,
-		   unsigned int relsec,
-		   struct module *module)
-{
-	printk(KERN_ERR "%s: Non-ADD RELOCATION unsupported\n",
-	       module->name);
-	return -ENOEXEC;
-}
-
 static inline int entry_matches(struct ppc_plt_entry *entry, Elf32_Addr val)
 {
 	if (entry->jump[0] == 0x3d600000 + ((val + 0x8000) >> 16)
diff --git a/arch/powerpc/kernel/module_64.c b/arch/powerpc/kernel/module_64.c
index 8fbb125..9f44a77 100644
--- a/arch/powerpc/kernel/module_64.c
+++ b/arch/powerpc/kernel/module_64.c
@@ -243,16 +243,6 @@ int module_frob_arch_sections(Elf64_Ehdr *hdr,
 	return 0;
 }
 
-int apply_relocate(Elf64_Shdr *sechdrs,
-		   const char *strtab,
-		   unsigned int symindex,
-		   unsigned int relsec,
-		   struct module *me)
-{
-	printk(KERN_ERR "%s: Non-ADD RELOCATION unsupported\n", me->name);
-	return -ENOEXEC;
-}
-
 /* r2 is the TOC pointer: it actually points 0x8000 into the TOC (this
    gives the value maximum span in an instruction which uses a signed
    offset) */
diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
index f7167ee..dfcb343 100644
--- a/arch/s390/kernel/module.c
+++ b/arch/s390/kernel/module.c
@@ -45,13 +45,6 @@
 #define PLT_ENTRY_SIZE 20
 #endif /* CONFIG_64BIT */
 
-void *module_alloc(unsigned long size)
-{
-	if (size == 0)
-		return NULL;
-	return vmalloc(size);
-}
-
 /* Free memory returned from module_alloc */
 void module_free(struct module *mod, void *module_region)
 {
@@ -176,15 +169,6 @@ module_frob_arch_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
 	return 0;
 }
 
-int
-apply_relocate(Elf_Shdr *sechdrs, const char *strtab, unsigned int symindex,
-	       unsigned int relsec, struct module *me)
-{
-	printk(KERN_ERR "module %s: RELOCATION unsupported\n",
-	       me->name);
-	return -ENOEXEC;
-}
-
 static int
 apply_rela(Elf_Rela *rela, Elf_Addr base, Elf_Sym *symtab, 
 	   struct module *me)
@@ -409,7 +393,3 @@ int module_finalize(const Elf_Ehdr *hdr,
 	me->arch.syminfo = NULL;
 	return 0;
 }
-
-void module_arch_cleanup(struct module *mod)
-{
-}
diff --git a/arch/score/kernel/module.c b/arch/score/kernel/module.c
index 4de8d47..469e3b6 100644
--- a/arch/score/kernel/module.c
+++ b/arch/score/kernel/module.c
@@ -27,23 +27,6 @@
 #include <linux/module.h>
 #include <linux/vmalloc.h>
 
-void *module_alloc(unsigned long size)
-{
-	return size ? vmalloc(size) : NULL;
-}
-
-/* Free memory returned from module_alloc */
-void module_free(struct module *mod, void *module_region)
-{
-	vfree(module_region);
-}
-
-int module_frob_arch_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
-			char *secstrings, struct module *mod)
-{
-	return 0;
-}
-
 int apply_relocate(Elf_Shdr *sechdrs, const char *strtab,
 		unsigned int symindex, unsigned int relindex,
 		struct module *me)
@@ -146,6 +129,9 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 		unsigned int symindex, unsigned int relsec,
 		struct module *me)
 {
+	/* Non-standard return value... most other arch's return -ENOEXEC
+	 * for an unsupported relocation variant
+	 */
 	return 0;
 }
 
@@ -154,12 +140,3 @@ const struct exception_table_entry *search_module_dbetables(unsigned long addr)
 {
 	return NULL;
 }
-
-/* Put in dbe list if necessary. */
-int module_finalize(const Elf_Ehdr *hdr, const Elf_Shdr *sechdrs,
-		struct module *me)
-{
-	return 0;
-}
-
-void module_arch_cleanup(struct module *mod) {}
diff --git a/arch/sh/kernel/module.c b/arch/sh/kernel/module.c
index 19b1f88..1b525de 100644
--- a/arch/sh/kernel/module.c
+++ b/arch/sh/kernel/module.c
@@ -34,30 +34,6 @@
 #include <asm/unaligned.h>
 #include <asm/dwarf.h>
 
-void *module_alloc(unsigned long size)
-{
-	if (size == 0)
-		return NULL;
-
-	return vmalloc_exec(size);
-}
-
-
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
 int apply_relocate_add(Elf32_Shdr *sechdrs,
 		   const char *strtab,
 		   unsigned int symindex,
@@ -133,17 +109,6 @@ int apply_relocate_add(Elf32_Shdr *sechdrs,
 	return 0;
 }
 
-int apply_relocate(Elf32_Shdr *sechdrs,
-		       const char *strtab,
-		       unsigned int symindex,
-		       unsigned int relsec,
-		       struct module *me)
-{
-	printk(KERN_ERR "module %s: REL RELOCATION unsupported\n",
-	       me->name);
-	return -ENOEXEC;
-}
-
 int module_finalize(const Elf_Ehdr *hdr,
 		    const Elf_Shdr *sechdrs,
 		    struct module *me)
diff --git a/arch/sparc/kernel/module.c b/arch/sparc/kernel/module.c
index 8d348c4..fe51fe60 100644
--- a/arch/sparc/kernel/module.c
+++ b/arch/sparc/kernel/module.c
@@ -68,12 +68,6 @@ void *module_alloc(unsigned long size)
 	return ret;
 }
 
-/* Free memory returned from module_core_alloc/module_init_alloc */
-void module_free(struct module *mod, void *module_region)
-{
-	vfree(module_region);
-}
-
 /* Make generic code ignore STT_REGISTER dummy undefined symbols.  */
 int module_frob_arch_sections(Elf_Ehdr *hdr,
 			      Elf_Shdr *sechdrs,
@@ -107,17 +101,6 @@ int module_frob_arch_sections(Elf_Ehdr *hdr,
 	return 0;
 }
 
-int apply_relocate(Elf_Shdr *sechdrs,
-		   const char *strtab,
-		   unsigned int symindex,
-		   unsigned int relsec,
-		   struct module *me)
-{
-	printk(KERN_ERR "module %s: non-ADD RELOCATION unsupported\n",
-	       me->name);
-	return -ENOEXEC;
-}
-
 int apply_relocate_add(Elf_Shdr *sechdrs,
 		       const char *strtab,
 		       unsigned int symindex,
@@ -239,15 +222,4 @@ int module_finalize(const Elf_Ehdr *hdr,
 
 	return 0;
 }
-#else
-int module_finalize(const Elf_Ehdr *hdr,
-                    const Elf_Shdr *sechdrs,
-                    struct module *me)
-{
-        return 0;
-}
 #endif /* CONFIG_SPARC64 */
-
-void module_arch_cleanup(struct module *mod)
-{
-}
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
diff --git a/arch/unicore32/kernel/module.c b/arch/unicore32/kernel/module.c
index 3e5a38d..8fbe857 100644
--- a/arch/unicore32/kernel/module.c
+++ b/arch/unicore32/kernel/module.c
@@ -37,19 +37,6 @@ void *module_alloc(unsigned long size)
 	return __vmalloc_area(area, GFP_KERNEL, PAGE_KERNEL_EXEC);
 }
 
-void module_free(struct module *module, void *region)
-{
-	vfree(region);
-}
-
-int module_frob_arch_sections(Elf_Ehdr *hdr,
-			      Elf_Shdr *sechdrs,
-			      char *secstrings,
-			      struct module *mod)
-{
-	return 0;
-}
-
 int
 apply_relocate(Elf32_Shdr *sechdrs, const char *strtab, unsigned int symindex,
 	       unsigned int relindex, struct module *module)
@@ -128,25 +115,3 @@ apply_relocate(Elf32_Shdr *sechdrs, const char *strtab, unsigned int symindex,
 	}
 	return 0;
 }
-
-int
-apply_relocate_add(Elf32_Shdr *sechdrs, const char *strtab,
-		   unsigned int symindex, unsigned int relsec,
-		   struct module *module)
-{
-	printk(KERN_ERR "module %s: ADD RELOCATION unsupported\n",
-	       module->name);
-	return -ENOEXEC;
-}
-
-int
-module_finalize(const Elf32_Ehdr *hdr, const Elf_Shdr *sechdrs,
-		struct module *module)
-{
-	return 0;
-}
-
-void
-module_arch_cleanup(struct module *mod)
-{
-}
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
diff --git a/arch/xtensa/kernel/module.c b/arch/xtensa/kernel/module.c
index c1accea..451dda9 100644
--- a/arch/xtensa/kernel/module.c
+++ b/arch/xtensa/kernel/module.c
@@ -24,26 +24,6 @@
 
 #undef DEBUG_RELOCATE
 
-void *module_alloc(unsigned long size)
-{
-	if (size == 0)
-		return NULL;
-	return vmalloc_exec(size);
-}
-
-void module_free(struct module *mod, void *module_region)
-{
-	vfree(module_region);
-}
-
-int module_frob_arch_sections(Elf32_Ehdr *hdr,
-    			      Elf32_Shdr *sechdrs,
-			      char *secstrings,
-			      struct module *mod)
-{
-	return 0;
-}
-
 static int
 decode_calln_opcode (unsigned char *location)
 {
@@ -66,18 +46,6 @@ decode_l32r_opcode (unsigned char *location)
 #endif
 }
 
-int apply_relocate(Elf32_Shdr *sechdrs,
-    		   const char *strtab,
-		   unsigned int symindex,
-		   unsigned int relsec,
-		   struct module *mod)
-{
-        printk(KERN_ERR "module %s: REL RELOCATION unsupported\n",
-               mod->name);
-        return -ENOEXEC;
-
-}
-
 int apply_relocate_add(Elf32_Shdr *sechdrs,
 		       const char *strtab,
 		       unsigned int symindex,
@@ -222,14 +190,3 @@ int apply_relocate_add(Elf32_Shdr *sechdrs,
 	}
 	return 0;
 }
-
-int module_finalize(const Elf_Ehdr *hdr,
-    		    const Elf_Shdr *sechdrs,
-		    struct module *mod)
-{
-	return 0;
-}
-
-void module_arch_cleanup(struct module *mod)
-{
-}
-- 
1.7.4.1

