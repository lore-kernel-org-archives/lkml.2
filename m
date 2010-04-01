Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646Ab0DAB7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 21:59:35 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51105 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756764Ab0DAB7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 21:59:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=KaTHSIwyCef6g4UTzNrwTNzTWdrcYgen6XBplcvI6SKrygPwhcUa/ZMdrA8wGyWqLp
         aN4P8EOcWb0TnIve1w93joEpT3mTWJNGVkxT2fGKdXAOk/5vUl7ZEx26suovmgffEL02
         rCcEoUzgy+giovFCTZaGE5cyXaKPocKnIl0SU=
MIME-Version: 1.0
Date: Wed, 31 Mar 2010 21:59:22 -0400
Message-ID: <g2g817ecb6f1003311859k505d752pb6f2a5d7a31e392@mail.gmail.com>
Subject: [PATCH 4/4] [tip:x86/mm] RO/NX protection for loadable kernel modules
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-next@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a logical extension of the protection provided by
CONFIG_DEBUG_RODATA to LKMs. The protection is provided by splitting
module_core and module_init into three logical parts each and setting
appropriate page access permissions for each individual section:

 1. Code: RO+X
 2. RO data: RO+NX
 3. RW data: RW+NX

In order to achieve proper protection, layout_sections() have been
modified to align each of the three parts mentioned above onto page
boundary. Next, the corresponding page access permissions are set
right before successful exit from load_module(). Further, free_module()
and sys_init_module have been modified to set module_core and
module_init as RW+NX right before calling module_free().

By default, the original section layout and access flags are preserved.
When compiled with CONFIG_DEBUG_SET_MODULE_RONX=y, the patch
will page-align each group of sections to ensure that each page contains
only one type of content and will enforce RO/NX for each group of pages.

V1: Initial proof-of-concept patch.
V2: The patch have been re-written to reduce the number of #ifdefs and
to make it architecture-agnostic. Code formatting have been corrected also.
V3: Opportunistic RO/NX protectiuon is now unconditional. Section
page-alignment is enabled when CONFIG_DEBUG_RODATA=y.
V4: Removed most macros and improved coding style.
V5: Changed page-alignment and RO/NX section size calculation
V6: Fixed comments. Restricted RO/NX enforcement to x86 only
V7: Introduced CONFIG_DEBUG_SET_MODULE_RONX, added calls to
set_all_modules_text_rw() and set_all_modules_text_ro() in ftrace
V8: updated for compatibility with linux 2.6.33-rc5
V9: coding style fixes
V10: more coding style fixes
V11: minor adjutments for -tip

Signed-off-by: Siarhei Liakh <sliakh.lkml@gmail.com>
Signed-off-by: Xuxian Jiang <jiang@cs.ncsu.edu>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Reviewed-by: James Morris <jmorris@namei.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 4814d35..2b1d2bd 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -115,6 +115,17 @@ config DEBUG_RODATA_TEST
 	  feature as well as for the change_page_attr() infrastructure.
 	  If in doubt, say "N"

+config DEBUG_SET_MODULE_RONX
+	bool "Set loadable kernel module data as NX and text as RO"
+	default n
+	depends on X86 && MODULES
+	---help---
+	  This option helps to catch unintended modifications to loadable
+	  kernel module's text and read-only data. It also prevents execution
+	  of LKM's data. Such protection may interfere with run-time code
+	  patching and dynamic kernel tracing.
+	  If in doubt, say "N".
+
 config DEBUG_NX_TEST
 	tristate "Testcase for the NX non-executable stack feature"
 	depends on DEBUG_KERNEL && m
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index cd37469..fa9f170 100644
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
index 5e869ff..239a34c 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -301,6 +301,9 @@ struct module
 	/* The size of the executable code in each section.  */
 	unsigned int init_text_size, core_text_size;

+	/* Size of RO sections of the module (text+rodata) */
+	unsigned int init_ro_size, core_ro_size;
+
 	/* Arch-specific module values */
 	struct mod_arch_specific arch;

@@ -534,6 +537,9 @@ extern void print_modules(void);
 extern void module_update_tracepoints(void);
 extern int module_get_iter_tracepoints(struct tracepoint_iter *iter);

+void set_all_modules_text_rw(void);
+void set_all_modules_text_ro(void);
+
 #else /* !CONFIG_MODULES... */
 #define EXPORT_SYMBOL(sym)
 #define EXPORT_SYMBOL_GPL(sym)
@@ -654,6 +660,13 @@ static inline int
module_get_iter_tracepoints(struct tracepoint_iter *iter)
 	return 0;
 }

+static inline void set_all_modules_text_rw(void)
+{
+}
+
+static inline void set_all_modules_text_ro(void)
+{
+}
 #endif /* CONFIG_MODULES */

 struct device_driver;
diff --git a/kernel/module.c b/kernel/module.c
index c968d36..2020c6d 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -55,6 +55,7 @@
 #include <linux/async.h>
 #include <linux/percpu.h>
 #include <linux/kmemleak.h>
+#include <linux/pfn.h>

 #define CREATE_TRACE_POINTS
 #include <trace/events/module.h>
@@ -71,6 +72,26 @@ EXPORT_TRACEPOINT_SYMBOL(module_get);
 #define ARCH_SHF_SMALL 0
 #endif

+/*
+ * Modules' sections will be aligned on page boundaries
+ * to ensure complete separation of code and data, but
+ * only when CONFIG_DEBUG_SET_MODULE_RONX=y
+ */
+#ifdef CONFIG_DEBUG_SET_MODULE_RONX
+#define debug_align(X) ALIGN(X, PAGE_SIZE)
+#else
+#define debug_align(X) (X)
+#endif
+
+/*
+ * Given BASE and SIZE this macro calculates the number of pages the
+ * memory regions occupies
+ */
+#define NUMBER_OF_PAGES(BASE, SIZE) (((SIZE) > 0) ?		\
+		(PFN_DOWN((unsigned long)(BASE) + (SIZE) - 1) -	\
+			 PFN_DOWN((unsigned long)BASE) + 1)	\
+		: (0UL))
+
 /* If this is set, the section belongs in the init part of the module */
 #define INIT_OFFSET_MASK (1UL << (BITS_PER_LONG-1))

@@ -1377,6 +1398,126 @@ static int __unlink_module(void *_mod)
 	return 0;
 }

+#ifdef CONFIG_DEBUG_SET_MODULE_RONX
+/*
+ * LKM RO/NX protection: protect module's text/ro-data
+ * from modification and any data from execution.
+ */
+void set_page_attributes(void *start, void *end,
+		int (*set)(unsigned long start, int num_pages))
+{
+	unsigned long begin_pfn = PFN_DOWN((unsigned long)start);
+	unsigned long end_pfn = PFN_DOWN((unsigned long)end);
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
+			set_memory_nx(begin_pfn << PAGE_SHIFT,
+						end_pfn - begin_pfn);
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
+		total_pages = NUMBER_OF_PAGES(mod->module_core, mod->core_size);
+		set_memory_nx((unsigned long)mod->module_core, total_pages);
+		set_memory_rw((unsigned long)mod->module_core, total_pages);
+
+	} else if (mod->module_init == module_region) {
+		/* Set init as NX+RW */
+		total_pages = NUMBER_OF_PAGES(mod->module_init, mod->init_size);
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
+						mod->module_core
+							+ mod->core_text_size,
+						set_memory_rw);
+		}
+		if ((mod->module_init) && (mod->init_text_size)) {
+			set_page_attributes(mod->module_init,
+						mod->module_init
+							+ mod->init_text_size,
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
+						mod->module_core
+							+ mod->core_text_size,
+						set_memory_ro);
+		}
+		if ((mod->module_init) && (mod->init_text_size)) {
+			set_page_attributes(mod->module_init,
+						mod->module_init
+							+ mod->init_text_size,
+						set_memory_ro);
+		}
+	}
+	mutex_unlock(&module_mutex);
+}
+#else
+static void set_section_ro_nx(void *base,
+			unsigned long text_size,
+			unsigned long ro_size,
+			unsigned long total_size) { }
+
+void unset_section_ro_nx(struct module *mod, void *module_region) { }
+void set_all_modules_text_rw() { }
+void set_all_modules_text_ro() { }
+#endif
+
 /* Free a module, remove from lists, etc (must hold module_mutex). */
 static void free_module(struct module *mod)
 {
@@ -1398,6 +1539,7 @@ static void free_module(struct module *mod)
 	destroy_params(mod->kp, mod->num_kp);

 	/* This may be NULL, but that's OK */
+	unset_section_ro_nx(mod, mod->module_init);
 	module_free(mod, mod->module_init);
 	kfree(mod->args);
 	if (mod->percpu)
@@ -1410,6 +1552,7 @@ static void free_module(struct module *mod)
 	lockdep_free_key_range(mod->module_core, mod->core_size);

 	/* Finally, free the core (containing the module structure) */
+	unset_section_ro_nx(mod, mod->module_core);
 	module_free(mod, mod->module_core);

 #ifdef CONFIG_MPU
@@ -1587,8 +1730,19 @@ static void layout_sections(struct module *mod,
 			s->sh_entsize = get_offset(mod, &mod->core_size, s, i);
 			DEBUGP("\t%s\n", secstrings + s->sh_name);
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
@@ -1605,8 +1759,19 @@ static void layout_sections(struct module *mod,
 					 | INIT_OFFSET_MASK);
 			DEBUGP("\t%s\n", secstrings + s->sh_name);
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

@@ -2386,6 +2551,18 @@ static noinline struct module *load_module(void
__user *umod,

 	trace_module_load(mod);

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
 	return mod;

@@ -2508,6 +2685,7 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 	mod->symtab = mod->core_symtab;
 	mod->strtab = mod->core_strtab;
 #endif
+	unset_section_ro_nx(mod, mod->module_init);
 	module_free(mod, mod->module_init);
 	mod->module_init = NULL;
 	mod->init_size = 0;
