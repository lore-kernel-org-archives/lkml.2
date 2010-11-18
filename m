Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309Ab0KROOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:14:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:52258 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757681Ab0KROOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:14:32 -0500
Date: Thu, 18 Nov 2010 14:13:51 GMT
From: tip-bot for matthieu castet <castet.matthieu@free.fr>
Cc: linux-kernel@vger.kernel.org, jmorris@namei.org, sliakh.lkml@gmail.com,
        hpa@zytor.com, mingo@redhat.com, torvalds@linux-foundation.org,
        rusty@rustcorp.com.au, arjan@linux.intel.com, davej@redhat.com,
        ak@muc.de, jiang@cs.ncsu.edu, castet.matthieu@free.fr,
        kees.cook@canonical.com, sfr@canb.auug.org.au, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, sliakh.lkml@gmail.com,
        jmorris@namei.org, linux-kernel@vger.kernel.org, arjan@linux.intel.com,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org, ak@muc.de,
        davej@redhat.com, jiang@cs.ncsu.edu, castet.matthieu@free.fr,
        kees.cook@canonical.com, tglx@linutronix.de, sfr@canb.auug.org.au,
        mingo@elte.hu
In-Reply-To: <4CE2F914.9070106@free.fr>
References: <4CE2F914.9070106@free.fr>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/security] x86: Add RO/NX protection for loadable kernel modules
Message-ID: <tip-84e1c6bb38eb318e456558b610396d9f1afaabf0@git.kernel.org>
Git-Commit-ID: 84e1c6bb38eb318e456558b610396d9f1afaabf0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Nov 2010 14:13:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84e1c6bb38eb318e456558b610396d9f1afaabf0
Gitweb:     http://git.kernel.org/tip/84e1c6bb38eb318e456558b610396d9f1afaabf0
Author:     matthieu castet <castet.matthieu@free.fr>
AuthorDate: Tue, 16 Nov 2010 22:35:16 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Nov 2010 13:32:56 +0100

x86: Add RO/NX protection for loadable kernel modules

This patch is a logical extension of the protection provided by
CONFIG_DEBUG_RODATA to LKMs. The protection is provided by
splitting module_core and module_init into three logical parts
each and setting appropriate page access permissions for each
individual section:

 1. Code: RO+X
 2. RO data: RO+NX
 3. RW data: RW+NX

In order to achieve proper protection, layout_sections() have
been modified to align each of the three parts mentioned above
onto page boundary. Next, the corresponding page access
permissions are set right before successful exit from
load_module(). Further, free_module() and sys_init_module have
been modified to set module_core and module_init as RW+NX right
before calling module_free().

By default, the original section layout and access flags are
preserved. When compiled with CONFIG_DEBUG_SET_MODULE_RONX=y,
the patch will page-align each group of sections to ensure that
each page contains only one type of content and will enforce
RO/NX for each group of pages.

  -v1: Initial proof-of-concept patch.
  -v2: The patch have been re-written to reduce the number of #ifdefs
       and to make it architecture-agnostic. Code formatting has also
       been corrected.
  -v3: Opportunistic RO/NX protection is now unconditional. Section
       page-alignment is enabled when CONFIG_DEBUG_RODATA=y.
  -v4: Removed most macros and improved coding style.
  -v5: Changed page-alignment and RO/NX section size calculation
  -v6: Fixed comments. Restricted RO/NX enforcement to x86 only
  -v7: Introduced CONFIG_DEBUG_SET_MODULE_RONX, added
       calls to set_all_modules_text_rw() and set_all_modules_text_ro()
       in ftrace
  -v8: updated for compatibility with linux 2.6.33-rc5
  -v9: coding style fixes
 -v10: more coding style fixes
 -v11: minor adjustments for -tip
 -v12: minor adjustments for v2.6.35-rc2-tip
 -v13: minor adjustments for v2.6.37-rc1-tip

Signed-off-by: Siarhei Liakh <sliakh.lkml@gmail.com>
Signed-off-by: Xuxian Jiang <jiang@cs.ncsu.edu>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Reviewed-by: James Morris <jmorris@namei.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Andi Kleen <ak@muc.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dave Jones <davej@redhat.com>
Cc: Kees Cook <kees.cook@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <4CE2F914.9070106@free.fr>
[ minor cleanliness edits, -v14: build failure fix ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig.debug   |   11 +++
 arch/x86/kernel/ftrace.c |    3 +
 include/linux/module.h   |   11 +++-
 kernel/module.c          |  171 +++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 193 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index b59ee76..45143bb 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -117,6 +117,17 @@ config DEBUG_RODATA_TEST
 	  feature as well as for the change_page_attr() infrastructure.
 	  If in doubt, say "N"
 
+config DEBUG_SET_MODULE_RONX
+	bool "Set loadable kernel module data as NX and text as RO"
+	depends on MODULES
+	---help---
+	  This option helps catch unintended modifications to loadable
+	  kernel module's text and read-only data. It also prevents execution
+	  of module data. Such protection may interfere with run-time code
+	  patching and dynamic kernel tracing - and they might also protect
+	  against certain classes of kernel exploits.
+	  If in doubt, say "N".
+
 config DEBUG_NX_TEST
 	tristate "Testcase for the NX non-executable stack feature"
 	depends on DEBUG_KERNEL && m
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 3afb33f..2984486 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -19,6 +19,7 @@
 #include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/list.h>
+#include <linux/module.h>
 
 #include <trace/syscall.h>
 
@@ -49,6 +50,7 @@ static DEFINE_PER_CPU(int, save_modifying_code);
 int ftrace_arch_code_modify_prepare(void)
 {
 	set_kernel_text_rw();
+	set_all_modules_text_rw();
 	modifying_code = 1;
 	return 0;
 }
@@ -56,6 +58,7 @@ int ftrace_arch_code_modify_prepare(void)
 int ftrace_arch_code_modify_post_process(void)
 {
 	modifying_code = 0;
+	set_all_modules_text_ro();
 	set_kernel_text_ro();
 	return 0;
 }
diff --git a/include/linux/module.h b/include/linux/module.h
index b29e745..ddaa689 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -308,6 +308,9 @@ struct module
 	/* The size of the executable code in each section.  */
 	unsigned int init_text_size, core_text_size;
 
+	/* Size of RO sections of the module (text+rodata) */
+	unsigned int init_ro_size, core_ro_size;
+
 	/* Arch-specific module values */
 	struct mod_arch_specific arch;
 
@@ -672,7 +675,6 @@ static inline int module_get_iter_tracepoints(struct tracepoint_iter *iter)
 {
 	return 0;
 }
-
 #endif /* CONFIG_MODULES */
 
 #ifdef CONFIG_SYSFS
@@ -687,6 +689,13 @@ extern int module_sysfs_initialized;
 
 #define __MODULE_STRING(x) __stringify(x)
 
+#ifdef CONFIG_DEBUG_SET_MODULE_RONX
+extern void set_all_modules_text_rw(void);
+extern void set_all_modules_text_ro(void);
+#else
+static inline void set_all_modules_text_rw(void) { }
+static inline void set_all_modules_text_ro(void) { }
+#endif
 
 #ifdef CONFIG_GENERIC_BUG
 void module_bug_finalize(const Elf_Ehdr *, const Elf_Shdr *,
diff --git a/kernel/module.c b/kernel/module.c
index 437a74a..ba421e6 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -56,6 +56,7 @@
 #include <linux/percpu.h>
 #include <linux/kmemleak.h>
 #include <linux/jump_label.h>
+#include <linux/pfn.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/module.h>
@@ -70,6 +71,26 @@
 #define ARCH_SHF_SMALL 0
 #endif
 
+/*
+ * Modules' sections will be aligned on page boundaries
+ * to ensure complete separation of code and data, but
+ * only when CONFIG_DEBUG_SET_MODULE_RONX=y
+ */
+#ifdef CONFIG_DEBUG_SET_MODULE_RONX
+# define debug_align(X) ALIGN(X, PAGE_SIZE)
+#else
+# define debug_align(X) (X)
+#endif
+
+/*
+ * Given BASE and SIZE this macro calculates the number of pages the
+ * memory regions occupies
+ */
+#define MOD_NUMBER_OF_PAGES(BASE, SIZE) (((SIZE) > 0) ?		\
+		(PFN_DOWN((unsigned long)(BASE) + (SIZE) - 1) -	\
+			 PFN_DOWN((unsigned long)BASE) + 1)	\
+		: (0UL))
+
 /* If this is set, the section belongs in the init part of the module */
 #define INIT_OFFSET_MASK (1UL << (BITS_PER_LONG-1))
 
@@ -1542,6 +1563,115 @@ static int __unlink_module(void *_mod)
 	return 0;
 }
 
+#ifdef CONFIG_DEBUG_SET_MODULE_RONX
+/*
+ * LKM RO/NX protection: protect module's text/ro-data
+ * from modification and any data from execution.
+ */
+void set_page_attributes(void *start, void *end, int (*set)(unsigned long start, int num_pages))
+{
+	unsigned long begin_pfn = PFN_DOWN((unsigned long)start);
+	unsigned long end_pfn = PFN_DOWN((unsigned long)end);
+
+	if (end_pfn > begin_pfn)
+		set(begin_pfn << PAGE_SHIFT, end_pfn - begin_pfn);
+}
+
+static void set_section_ro_nx(void *base,
+			unsigned long text_size,
+			unsigned long ro_size,
+			unsigned long total_size)
+{
+	/* begin and end PFNs of the current subsection */
+	unsigned long begin_pfn;
+	unsigned long end_pfn;
+
+	/*
+	 * Set RO for module text and RO-data:
+	 * - Always protect first page.
+	 * - Do not protect last partial page.
+	 */
+	if (ro_size > 0)
+		set_page_attributes(base, base + ro_size, set_memory_ro);
+
+	/*
+	 * Set NX permissions for module data:
+	 * - Do not protect first partial page.
+	 * - Always protect last page.
+	 */
+	if (total_size > text_size) {
+		begin_pfn = PFN_UP((unsigned long)base + text_size);
+		end_pfn = PFN_UP((unsigned long)base + total_size);
+		if (end_pfn > begin_pfn)
+			set_memory_nx(begin_pfn << PAGE_SHIFT, end_pfn - begin_pfn);
+	}
+}
+
+/* Setting memory back to RW+NX before releasing it */
+void unset_section_ro_nx(struct module *mod, void *module_region)
+{
+	unsigned long total_pages;
+
+	if (mod->module_core == module_region) {
+		/* Set core as NX+RW */
+		total_pages = MOD_NUMBER_OF_PAGES(mod->module_core, mod->core_size);
+		set_memory_nx((unsigned long)mod->module_core, total_pages);
+		set_memory_rw((unsigned long)mod->module_core, total_pages);
+
+	} else if (mod->module_init == module_region) {
+		/* Set init as NX+RW */
+		total_pages = MOD_NUMBER_OF_PAGES(mod->module_init, mod->init_size);
+		set_memory_nx((unsigned long)mod->module_init, total_pages);
+		set_memory_rw((unsigned long)mod->module_init, total_pages);
+	}
+}
+
+/* Iterate through all modules and set each module's text as RW */
+void set_all_modules_text_rw()
+{
+	struct module *mod;
+
+	mutex_lock(&module_mutex);
+	list_for_each_entry_rcu(mod, &modules, list) {
+		if ((mod->module_core) && (mod->core_text_size)) {
+			set_page_attributes(mod->module_core,
+						mod->module_core + mod->core_text_size,
+						set_memory_rw);
+		}
+		if ((mod->module_init) && (mod->init_text_size)) {
+			set_page_attributes(mod->module_init,
+						mod->module_init + mod->init_text_size,
+						set_memory_rw);
+		}
+	}
+	mutex_unlock(&module_mutex);
+}
+
+/* Iterate through all modules and set each module's text as RO */
+void set_all_modules_text_ro()
+{
+	struct module *mod;
+
+	mutex_lock(&module_mutex);
+	list_for_each_entry_rcu(mod, &modules, list) {
+		if ((mod->module_core) && (mod->core_text_size)) {
+			set_page_attributes(mod->module_core,
+						mod->module_core + mod->core_text_size,
+						set_memory_ro);
+		}
+		if ((mod->module_init) && (mod->init_text_size)) {
+			set_page_attributes(mod->module_init,
+						mod->module_init + mod->init_text_size,
+						set_memory_ro);
+		}
+	}
+	mutex_unlock(&module_mutex);
+}
+#else
+static inline void set_section_ro_nx(void *base, unsigned long text_size, unsigned long ro_size, unsigned long total_size) { }
+static inline void unset_section_ro_nx(struct module *mod, void *module_region) { }
+#endif
+
 /* Free a module, remove from lists, etc. */
 static void free_module(struct module *mod)
 {
@@ -1566,6 +1696,7 @@ static void free_module(struct module *mod)
 	destroy_params(mod->kp, mod->num_kp);
 
 	/* This may be NULL, but that's OK */
+	unset_section_ro_nx(mod, mod->module_init);
 	module_free(mod, mod->module_init);
 	kfree(mod->args);
 	percpu_modfree(mod);
@@ -1574,6 +1705,7 @@ static void free_module(struct module *mod)
 	lockdep_free_key_range(mod->module_core, mod->core_size);
 
 	/* Finally, free the core (containing the module structure) */
+	unset_section_ro_nx(mod, mod->module_core);
 	module_free(mod, mod->module_core);
 
 #ifdef CONFIG_MPU
@@ -1777,8 +1909,19 @@ static void layout_sections(struct module *mod, struct load_info *info)
 			s->sh_entsize = get_offset(mod, &mod->core_size, s, i);
 			DEBUGP("\t%s\n", name);
 		}
-		if (m == 0)
+		switch (m) {
+		case 0: /* executable */
+			mod->core_size = debug_align(mod->core_size);
 			mod->core_text_size = mod->core_size;
+			break;
+		case 1: /* RO: text and ro-data */
+			mod->core_size = debug_align(mod->core_size);
+			mod->core_ro_size = mod->core_size;
+			break;
+		case 3: /* whole core */
+			mod->core_size = debug_align(mod->core_size);
+			break;
+		}
 	}
 
 	DEBUGP("Init section allocation order:\n");
@@ -1796,8 +1939,19 @@ static void layout_sections(struct module *mod, struct load_info *info)
 					 | INIT_OFFSET_MASK);
 			DEBUGP("\t%s\n", sname);
 		}
-		if (m == 0)
+		switch (m) {
+		case 0: /* executable */
+			mod->init_size = debug_align(mod->init_size);
 			mod->init_text_size = mod->init_size;
+			break;
+		case 1: /* RO: text and ro-data */
+			mod->init_size = debug_align(mod->init_size);
+			mod->init_ro_size = mod->init_size;
+			break;
+		case 3: /* whole init */
+			mod->init_size = debug_align(mod->init_size);
+			break;
+		}
 	}
 }
 
@@ -2650,6 +2804,18 @@ static struct module *load_module(void __user *umod,
 	kfree(info.strmap);
 	free_copy(&info);
 
+	/* Set RO and NX regions for core */
+	set_section_ro_nx(mod->module_core,
+				mod->core_text_size,
+				mod->core_ro_size,
+				mod->core_size);
+
+	/* Set RO and NX regions for init */
+	set_section_ro_nx(mod->module_init,
+				mod->init_text_size,
+				mod->init_ro_size,
+				mod->init_size);
+
 	/* Done! */
 	trace_module_load(mod);
 	return mod;
@@ -2753,6 +2919,7 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 	mod->symtab = mod->core_symtab;
 	mod->strtab = mod->core_strtab;
 #endif
+	unset_section_ro_nx(mod, mod->module_init);
 	module_free(mod, mod->module_init);
 	mod->module_init = NULL;
 	mod->init_size = 0;
