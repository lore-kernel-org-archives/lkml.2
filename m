Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab1F3TWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 15:22:20 -0400
Received: from mail.southpole.se ([193.12.106.18]:37702 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab1F3TWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 15:22:18 -0400
From: Jonas Bonn <jonas@southpole.se>
To: rusty@rustcorp.com.au
Cc: arnd@ardnb.de, geert@linux-m68k.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        monstr@monstr.eu, cmetcalf@tilera.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, Jonas Bonn <jonas@southpole.se>
Subject: [PATCH 1/2] modules: add default loader hook implementations
Date: Thu, 30 Jun 2011 21:22:11 +0200
Message-Id: <1309461732-2875-1-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <201106281245.19457.arnd@arndb.de>
References: <201106281245.19457.arnd@arndb.de>
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The module loader code allows architectures to hook into the code by
providing a small number of entry points that each arch must implement.
This patch provides __weakly linked generic implementations of these
entry points for architectures that don't need to do anything special.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 include/linux/moduleloader.h |    7 +++++-
 kernel/module.c              |   49 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 1 deletions(-)

diff --git a/include/linux/moduleloader.h b/include/linux/moduleloader.h
index c1f40c2..b2be02e 100644
--- a/include/linux/moduleloader.h
+++ b/include/linux/moduleloader.h
@@ -5,7 +5,12 @@
 #include <linux/module.h>
 #include <linux/elf.h>
 
-/* These must be implemented by the specific architecture */
+/* These may be implemented by architectures that need to hook into the
+ * module loader code.  Architectures that don't need to do anything special
+ * can just rely on the 'weak' default hooks defined in kernel/module.c.
+ * Note, however, that at least one of apply_relocate or apply_relocate_add
+ * must be implemented by each architecture.
+ */
 
 /* Adjust arch-specific sections.  Return 0 on success.  */
 int module_frob_arch_sections(Elf_Ehdr *hdr,
diff --git a/kernel/module.c b/kernel/module.c
index 795bdc7..6301d6e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1697,6 +1697,15 @@ static void unset_module_core_ro_nx(struct module *mod) { }
 static void unset_module_init_ro_nx(struct module *mod) { }
 #endif
 
+void __weak module_free(struct module *mod, void *module_region)
+{
+	vfree(module_region);
+}
+
+void __weak module_arch_cleanup(struct module *mod)
+{
+}
+
 /* Free a module, remove from lists, etc. */
 static void free_module(struct module *mod)
 {
@@ -1851,6 +1860,26 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
 	return ret;
 }
 
+int __weak apply_relocate(Elf_Shdr *sechdrs,
+			  const char *strtab,
+			  unsigned int symindex,
+			  unsigned int relsec,
+			  struct module *me)
+{
+	pr_err("module %s: REL relocation unsupported\n", me->name);
+	return -ENOEXEC;
+}
+
+int __weak apply_relocate_add(Elf_Shdr *sechdrs,
+			      const char *strtab,
+			      unsigned int symindex,
+			      unsigned int relsec,
+			      struct module *me)
+{
+	pr_err("module %s: RELA relocation unsupported\n", me->name);
+	return -ENOEXEC;
+}
+
 static int apply_relocations(struct module *mod, const struct load_info *info)
 {
 	unsigned int i;
@@ -2235,6 +2264,11 @@ static void dynamic_debug_remove(struct _ddebug *debug)
 		ddebug_remove_module(debug->modname);
 }
 
+void * __weak module_alloc(unsigned long size)
+{
+	return size == 0 ? NULL : vmalloc_exec(size);
+}
+
 static void *module_alloc_update_bounds(unsigned long size)
 {
 	void *ret = module_alloc(size);
@@ -2645,6 +2679,14 @@ static void flush_module_icache(const struct module *mod)
 	set_fs(old_fs);
 }
 
+int __weak module_frob_arch_sections(Elf_Ehdr *hdr,
+				     Elf_Shdr *sechdrs,
+				     char *secstrings,
+				     struct module *mod)
+{
+	return 0;
+}
+
 static struct module *layout_and_allocate(struct load_info *info)
 {
 	/* Module within temporary copy. */
@@ -2716,6 +2758,13 @@ static void module_deallocate(struct module *mod, struct load_info *info)
 	module_free(mod, mod->module_core);
 }
 
+int __weak module_finalize(const Elf_Ehdr *hdr,
+			   const Elf_Shdr *sechdrs,
+			   struct module *me)
+{
+	return 0;
+}
+
 static int post_relocation(struct module *mod, const struct load_info *info)
 {
 	/* Sort exception table now relocations are done. */
-- 
1.7.4.1

