Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab0J3X6c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 19:58:32 -0400
Received: from mail.perches.com ([173.55.12.10]:3863 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295Ab0J3X6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 19:58:25 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 2/2] kernel/module.c: Use pr_debug and other neatening
Date: Sat, 30 Oct 2010 16:58:22 -0700
Message-Id: <4910ddce43486672abd515009bc10b24e76a9753.1288482645.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288482645.git.joe@perches.com>
References: <cover.1288482645.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use <linux/foo> not <asm/foo>
Convert DEBUGP to pr_debug
Use 0x%llx and (unsigned long long)shdr->sh_addr
Remove static initializations to 0
checkpatch whitespace cleanups
Use temporary for sym[i].st_shndx
Move const after static
Hoist assigns from ifs

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/module.c |  197 ++++++++++++++++++++++++++++---------------------------
 1 files changed, 100 insertions(+), 97 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 9b6b0da..d3fe6c5 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -48,9 +48,9 @@
 #include <linux/string.h>
 #include <linux/mutex.h>
 #include <linux/rculist.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/cacheflush.h>
-#include <asm/mmu_context.h>
+#include <linux/mmu_context.h>
 #include <linux/license.h>
 #include <asm/sections.h>
 #include <linux/tracepoint.h>
@@ -63,12 +63,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/module.h>
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(fmt , a...)
-#endif
-
 #ifndef ARCH_SHF_SMALL
 #define ARCH_SHF_SMALL 0
 #endif
@@ -91,7 +85,7 @@ struct list_head *kdb_modules = &modules; /* kdb needs the list of modules */
 
 
 /* Block module loading/unloading? */
-int modules_disabled = 0;
+int modules_disabled;
 
 /* Waiting for a module to finish initializing? */
 static DECLARE_WAIT_QUEUE_HEAD(module_wq);
@@ -100,15 +94,16 @@ static BLOCKING_NOTIFIER_HEAD(module_notify_list);
 
 /* Bounds of module allocation, for speeding __module_address.
  * Protected by module_mutex. */
-static unsigned long module_addr_min = -1UL, module_addr_max = 0;
+static unsigned long module_addr_min = -1UL;
+static unsigned long module_addr_max;
 
-int register_module_notifier(struct notifier_block * nb)
+int register_module_notifier(struct notifier_block *nb)
 {
 	return blocking_notifier_chain_register(&module_notify_list, nb);
 }
 EXPORT_SYMBOL(register_module_notifier);
 
-int unregister_module_notifier(struct notifier_block * nb)
+int unregister_module_notifier(struct notifier_block *nb)
 {
 	return blocking_notifier_chain_unregister(&module_notify_list, nb);
 }
@@ -165,8 +160,8 @@ static unsigned int find_sec(const struct load_info *info, const char *name)
 	for (i = 1; i < info->hdr->e_shnum; i++) {
 		Elf_Shdr *shdr = &info->sechdrs[i];
 		/* Alloc bit cleared means "ignore it." */
-		if ((shdr->sh_flags & SHF_ALLOC)
-		    && strcmp(info->secstrings + shdr->sh_name, name) == 0)
+		if ((shdr->sh_flags & SHF_ALLOC) &&
+		    strcmp(info->secstrings + shdr->sh_name, name) == 0)
 			return i;
 	}
 	return 0;
@@ -361,7 +356,7 @@ const struct kernel_symbol *find_symbol(const char *name,
 		return fsa.sym;
 	}
 
-	DEBUGP("Failed to find symbol %s\n", name);
+	pr_debug("Failed to find symbol %s\n", name);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(find_symbol);
@@ -489,31 +484,31 @@ bool is_module_percpu_address(unsigned long addr)
 
 #endif /* CONFIG_SMP */
 
-#define MODINFO_ATTR(field)	\
-static void setup_modinfo_##field(struct module *mod, const char *s)  \
-{                                                                     \
-	mod->field = kstrdup(s, GFP_KERNEL);                          \
-}                                                                     \
-static ssize_t show_modinfo_##field(struct module_attribute *mattr,   \
-	                struct module *mod, char *buffer)             \
-{                                                                     \
-	return sprintf(buffer, "%s\n", mod->field);                   \
-}                                                                     \
-static int modinfo_##field##_exists(struct module *mod)               \
-{                                                                     \
-	return mod->field != NULL;                                    \
-}                                                                     \
-static void free_modinfo_##field(struct module *mod)                  \
-{                                                                     \
-	kfree(mod->field);                                            \
-	mod->field = NULL;                                            \
-}                                                                     \
-static struct module_attribute modinfo_##field = {                    \
-	.attr = { .name = __stringify(field), .mode = 0444 },         \
-	.show = show_modinfo_##field,                                 \
-	.setup = setup_modinfo_##field,                               \
-	.test = modinfo_##field##_exists,                             \
-	.free = free_modinfo_##field,                                 \
+#define MODINFO_ATTR(field)						\
+static void setup_modinfo_##field(struct module *mod, const char *s)	\
+{									\
+	mod->field = kstrdup(s, GFP_KERNEL);				\
+}									\
+static ssize_t show_modinfo_##field(struct module_attribute *mattr,	\
+				    struct module *mod, char *buffer)	\
+{									\
+	return sprintf(buffer, "%s\n", mod->field);			\
+}									\
+static int modinfo_##field##_exists(struct module *mod)			\
+{									\
+	return mod->field != NULL;					\
+}									\
+static void free_modinfo_##field(struct module *mod)			\
+{									\
+	kfree(mod->field);						\
+	mod->field = NULL;						\
+}									\
+static struct module_attribute modinfo_##field = {			\
+	.attr = { .name = __stringify(field), .mode = 0444 },		\
+	.show = show_modinfo_##field,					\
+	.setup = setup_modinfo_##field,					\
+	.test = modinfo_##field##_exists,				\
+	.free = free_modinfo_##field,					\
 };
 
 MODINFO_ATTR(version);
@@ -550,11 +545,11 @@ static int already_uses(struct module *a, struct module *b)
 
 	list_for_each_entry(use, &b->source_list, source_list) {
 		if (use->source == a) {
-			DEBUGP("%s uses %s!\n", a->name, b->name);
+			pr_debug("%s uses %s!\n", a->name, b->name);
 			return 1;
 		}
 	}
-	DEBUGP("%s does not use %s!\n", a->name, b->name);
+	pr_debug("%s does not use %s!\n", a->name, b->name);
 	return 0;
 }
 
@@ -569,7 +564,7 @@ static int add_module_usage(struct module *a, struct module *b)
 {
 	struct module_use *use;
 
-	DEBUGP("Allocating new usage for %s.\n", a->name);
+	pr_debug("Allocating new usage for %s\n", a->name);
 	use = kmalloc(sizeof(*use), GFP_ATOMIC);
 	if (!use) {
 		pr_warn("%s: out of memory loading\n", a->name);
@@ -613,7 +608,7 @@ static void module_unload_free(struct module *mod)
 	mutex_lock(&module_mutex);
 	list_for_each_entry_safe(use, tmp, &mod->target_list, target_list) {
 		struct module *i = use->target;
-		DEBUGP("%s unusing %s\n", mod->name, i->name);
+		pr_debug("%s unusing %s\n", mod->name, i->name);
 		module_put(i);
 		list_del(&use->source_list);
 		list_del(&use->target_list);
@@ -639,8 +634,7 @@ static inline int try_force_unload(unsigned int flags)
 }
 #endif /* CONFIG_MODULE_FORCE_UNLOAD */
 
-struct stopref
-{
+struct stopref {
 	struct module *mod;
 	int flags;
 	int *forced;
@@ -653,7 +647,8 @@ static int __try_stop_module(void *_sref)
 
 	/* If it's not unused, quit unless we're forcing. */
 	if (module_refcount(sref->mod) != 0) {
-		if (!(*sref->forced = try_force_unload(sref->flags)))
+		*sref->forced = try_force_unload(sref->flags);
+		if (!*sref->forced)
 			return -EWOULDBLOCK;
 	}
 
@@ -711,7 +706,7 @@ static void wait_for_zero_refcount(struct module *mod)
 	/* Since we might sleep for some time, release the mutex first */
 	mutex_unlock(&module_mutex);
 	for (;;) {
-		DEBUGP("Looking at refcount...\n");
+		pr_debug("Looking at refcount...\n");
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		if (module_refcount(mod) == 0)
 			break;
@@ -753,8 +748,8 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 	/* Doing init or already dying? */
 	if (mod->state != MODULE_STATE_LIVE) {
 		/* FIXME: if (force), slam module count and wake up
-                   waiter --RR */
-		DEBUGP("%s already dying\n", mod->name);
+		 * waiter --RR */
+		pr_debug("%s already dying\n", mod->name);
 		ret = -EBUSY;
 		goto out;
 	}
@@ -807,7 +802,7 @@ static inline void print_unload_info(struct seq_file *m, struct module *mod)
 	seq_printf(m, " %u ", module_refcount(mod));
 
 	/* Always include a trailing , so userspace can differentiate
-           between this and the old multi-field proc format. */
+	 * between this and the old multi-field proc format. */
 	list_for_each_entry(use, &mod->source_list, source_list) {
 		printed_something = 1;
 		seq_printf(m, "%s,", use->source->name);
@@ -964,7 +959,7 @@ static unsigned long maybe_relocated(unsigned long crc,
 static int check_version(Elf_Shdr *sechdrs,
 			 unsigned int versindex,
 			 const char *symname,
-			 struct module *mod, 
+			 struct module *mod,
 			 const unsigned long *crc,
 			 const struct module *crc_owner)
 {
@@ -989,8 +984,8 @@ static int check_version(Elf_Shdr *sechdrs,
 
 		if (versions[i].crc == maybe_relocated(*crc, crc_owner))
 			return 1;
-		DEBUGP("Found checksum %lX vs module %lX\n",
-		       maybe_relocated(*crc, crc_owner), versions[i].crc);
+		pr_debug("Found checksum %lX vs module %lX\n",
+			 maybe_relocated(*crc, crc_owner), versions[i].crc);
 		goto bad_version;
 	}
 
@@ -1032,7 +1027,7 @@ static inline int same_magic(const char *amagic, const char *bmagic,
 static inline int check_version(Elf_Shdr *sechdrs,
 				unsigned int versindex,
 				const char *symname,
-				struct module *mod, 
+				struct module *mod,
 				const unsigned long *crc,
 				const struct module *crc_owner)
 {
@@ -1066,7 +1061,8 @@ static const struct kernel_symbol *resolve_symbol(struct module *mod,
 
 	mutex_lock(&module_mutex);
 	sym = find_symbol(name, &owner, &crc,
-			  !(mod->taints & (1 << TAINT_PROPRIETARY_MODULE)), true);
+			  !(mod->taints & (1 << TAINT_PROPRIETARY_MODULE)),
+			  true);
 	if (!sym)
 		goto unlock;
 
@@ -1120,15 +1116,13 @@ static inline bool sect_empty(const Elf_Shdr *sect)
 	return !(sect->sh_flags & SHF_ALLOC) || sect->sh_size == 0;
 }
 
-struct module_sect_attr
-{
+struct module_sect_attr {
 	struct module_attribute mattr;
 	char *name;
 	unsigned long address;
 };
 
-struct module_sect_attrs
-{
+struct module_sect_attrs {
 	struct attribute_group grp;
 	unsigned int nsections;
 	struct module_sect_attr attrs[0];
@@ -1201,7 +1195,7 @@ static void add_sect_attrs(struct module *mod, const struct load_info *info)
 
 	mod->sect_attrs = sect_attrs;
 	return;
-  out:
+out:
 	free_sect_attrs(sect_attrs);
 }
 
@@ -1305,7 +1299,7 @@ static void add_notes_attrs(struct module *mod, const struct load_info *info)
 	mod->notes_attrs = notes_attrs;
 	return;
 
-  out:
+out:
 	free_notes_attrs(notes_attrs, i);
 }
 
@@ -1382,7 +1376,8 @@ static int module_add_modinfo_attrs(struct module *mod)
 		    (attr->test && attr->test(mod))) {
 			memcpy(temp_attr, attr, sizeof(*temp_attr));
 			sysfs_attr_init(&temp_attr->attr);
-			error = sysfs_create_file(&mod->mkobj.kobj,&temp_attr->attr);
+			error = sysfs_create_file(&mod->mkobj.kobj,
+						  &temp_attr->attr);
 			++temp_attr;
 		}
 	}
@@ -1398,7 +1393,7 @@ static void module_remove_modinfo_attrs(struct module *mod)
 		/* pick a field to test for end of list */
 		if (!attr->attr.name)
 			break;
-		sysfs_remove_file(&mod->mkobj.kobj,&attr->attr);
+		sysfs_remove_file(&mod->mkobj.kobj, &attr->attr);
 		if (attr->free)
 			attr->free(mod);
 	}
@@ -1635,12 +1630,12 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
 
 	for (i = 1; i < symsec->sh_size / sizeof(Elf_Sym); i++) {
 		const char *name = info->strtab + sym[i].st_name;
-
-		switch (sym[i].st_shndx) {
+		typeof (sym[i].st_shndx) index = sym[i].st_shndx;
+		switch (index) {
 		case SHN_COMMON:
 			/* We compiled with -fno-common.  These are not
 			   supposed to happen.  */
-			DEBUGP("Common symbol: %s\n", name);
+			pr_debug("Common symbol: %s\n", name);
 			pr_info("%s: please compile with -fno-common\n",
 				mod->name);
 			ret = -ENOEXEC;
@@ -1648,8 +1643,8 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
 
 		case SHN_ABS:
 			/* Don't need to do anything */
-			DEBUGP("Absolute symbol: 0x%08lx\n",
-			       (long)sym[i].st_value);
+			pr_debug("Absolute symbol: 0x%08lx\n",
+				 (long)sym[i].st_value);
 			break;
 
 		case SHN_UNDEF:
@@ -1671,10 +1666,10 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
 
 		default:
 			/* Divert to percpu allocation if a percpu var. */
-			if (sym[i].st_shndx == info->index.pcpu)
+			if (index == info->index.pcpu)
 				secbase = (unsigned long)mod_percpu(mod);
 			else
-				secbase = info->sechdrs[sym[i].st_shndx].sh_addr;
+				secbase = info->sechdrs[index].sh_addr;
 			sym[i].st_value += secbase;
 			break;
 		}
@@ -1738,7 +1733,7 @@ static long get_offset(struct module *mod, unsigned int *size,
    belongs in init. */
 static void layout_sections(struct module *mod, struct load_info *info)
 {
-	static unsigned long const masks[][2] = {
+	static const unsigned long masks[][2] = {
 		/* NOTE: all executable code must be the first section
 		 * in this array; otherwise modify the text_size
 		 * finder in the two loops below */
@@ -1752,7 +1747,7 @@ static void layout_sections(struct module *mod, struct load_info *info)
 	for (i = 0; i < info->hdr->e_shnum; i++)
 		info->sechdrs[i].sh_entsize = ~0UL;
 
-	DEBUGP("Core section allocation order:\n");
+	pr_debug("Core section allocation order:\n");
 	for (m = 0; m < ARRAY_SIZE(masks); ++m) {
 		for (i = 0; i < info->hdr->e_shnum; ++i) {
 			Elf_Shdr *s = &info->sechdrs[i];
@@ -1764,13 +1759,13 @@ static void layout_sections(struct module *mod, struct load_info *info)
 			    || strstarts(sname, ".init"))
 				continue;
 			s->sh_entsize = get_offset(mod, &mod->core_size, s, i);
-			DEBUGP("\t%s\n", name);
+			pr_debug("\t%s\n", sname);
 		}
 		if (m == 0)
 			mod->core_text_size = mod->core_size;
 	}
 
-	DEBUGP("Init section allocation order:\n");
+	pr_debug("Init section allocation order:\n");
 	for (m = 0; m < ARRAY_SIZE(masks); ++m) {
 		for (i = 0; i < info->hdr->e_shnum; ++i) {
 			Elf_Shdr *s = &info->sechdrs[i];
@@ -1783,7 +1778,7 @@ static void layout_sections(struct module *mod, struct load_info *info)
 				continue;
 			s->sh_entsize = (get_offset(mod, &mod->init_size, s, i)
 					 | INIT_OFFSET_MASK);
-			DEBUGP("\t%s\n", sname);
+			pr_debug("\t%s\n", sname);
 		}
 		if (m == 0)
 			mod->init_text_size = mod->init_size;
@@ -1925,7 +1920,7 @@ static char elf_type(const Elf_Sym *sym, const struct load_info *info)
 }
 
 static bool is_core_symbol(const Elf_Sym *src, const Elf_Shdr *sechdrs,
-                           unsigned int shnum)
+			   unsigned int shnum)
 {
 	const Elf_Shdr *sec;
 
@@ -1956,7 +1951,7 @@ static void layout_symtab(struct module *mod, struct load_info *info)
 	symsect->sh_flags |= SHF_ALLOC;
 	symsect->sh_entsize = get_offset(mod, &mod->init_size, symsect,
 					 info->index.sym) | INIT_OFFSET_MASK;
-	DEBUGP("\t%s\n", info->secstrings + symsect->sh_name);
+	pr_debug("\t%s\n", info->secstrings + symsect->sh_name);
 
 	src = (void *)info->hdr + symsect->sh_offset;
 	nsrc = symsect->sh_size / sizeof(*src);
@@ -1978,7 +1973,7 @@ static void layout_symtab(struct module *mod, struct load_info *info)
 	strsect->sh_flags |= SHF_ALLOC;
 	strsect->sh_entsize = get_offset(mod, &mod->init_size, strsect,
 					 info->index.str) | INIT_OFFSET_MASK;
-	DEBUGP("\t%s\n", info->secstrings + strsect->sh_name);
+	pr_debug("\t%s\n", info->secstrings + strsect->sh_name);
 
 	/* Append room for core symbols' strings at end of core part. */
 	info->stroffs = mod->core_size;
@@ -2364,7 +2359,7 @@ static int move_module(struct module *mod, struct load_info *info)
 	mod->module_init = ptr;
 
 	/* Transfer each section which specifies SHF_ALLOC */
-	DEBUGP("final section addresses:\n");
+	pr_debug("final section addresses:\n");
 	for (i = 0; i < info->hdr->e_shnum; i++) {
 		void *dest;
 		Elf_Shdr *shdr = &info->sechdrs[i];
@@ -2382,8 +2377,9 @@ static int move_module(struct module *mod, struct load_info *info)
 			memcpy(dest, (void *)shdr->sh_addr, shdr->sh_size);
 		/* Update sh_addr to point to copy in image. */
 		shdr->sh_addr = (unsigned long)dest;
-		DEBUGP("\t0x%lx %s\n",
-		       shdr->sh_addr, info->secstrings + shdr->sh_name);
+		pr_debug("\t0x%llx %s\n",
+			 (unsigned long long)shdr->sh_addr,
+			 info->secstrings + shdr->sh_name);
 	}
 
 	return 0;
@@ -2478,8 +2474,9 @@ static struct module *layout_and_allocate(struct load_info *info)
 	   special cases for the architectures. */
 	layout_sections(mod, info);
 
-	info->strmap = kzalloc(BITS_TO_LONGS(info->sechdrs[info->index.str].sh_size)
-			 * sizeof(long), GFP_KERNEL);
+	info->strmap =
+		kzalloc(BITS_TO_LONGS(info->sechdrs[info->index.str].sh_size)
+			* sizeof(long), GFP_KERNEL);
 	if (!info->strmap) {
 		err = -ENOMEM;
 		goto free_percpu;
@@ -2539,8 +2536,7 @@ static struct module *load_module(void __user *umod,
 	struct module *mod;
 	long err;
 
-	DEBUGP("load_module: umod=%p, len=%lu, uargs=%p\n",
-	       umod, len, uargs);
+	pr_debug("load_module: umod=%p, len=%lu, uargs=%p\n", umod, len, uargs);
 
 	/* Copy in the blobs from userspace, check they are vaguely sane. */
 	err = copy_and_check(&info, umod, len, uargs);
@@ -2700,8 +2696,8 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 	if (mod->init != NULL)
 		ret = do_one_initcall(mod->init);
 	if (ret < 0) {
-		/* Init routine failed: abort.  Try to protect us from
-                   buggy refcounters. */
+		/* Init routine failed: abort.
+		 * Try to protect us from buggy refcounters. */
 		mod->state = MODULE_STATE_GOING;
 		synchronize_sched();
 		module_put(mod);
@@ -2725,7 +2721,8 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 	blocking_notifier_call_chain(&module_notify_list,
 				     MODULE_STATE_LIVE, mod);
 
-	/* We need to finish all async code before the module init sequence is done */
+	/* We need to finish all async code before the module init sequence
+	 * is done */
 	async_synchronize_full();
 
 	mutex_lock(&module_mutex);
@@ -2787,12 +2784,14 @@ static const char *get_ksymbol(struct module *mod,
 		if (mod->symtab[i].st_value <= addr
 		    && mod->symtab[i].st_value > mod->symtab[best].st_value
 		    && *(mod->strtab + mod->symtab[i].st_name) != '\0'
-		    && !is_arm_mapping_symbol(mod->strtab + mod->symtab[i].st_name))
+		    && !is_arm_mapping_symbol(mod->strtab +
+					      mod->symtab[i].st_name))
 			best = i;
 		if (mod->symtab[i].st_value > addr
 		    && mod->symtab[i].st_value < nextval
 		    && *(mod->strtab + mod->symtab[i].st_name) != '\0'
-		    && !is_arm_mapping_symbol(mod->strtab + mod->symtab[i].st_name))
+		    && !is_arm_mapping_symbol(mod->strtab +
+					      mod->symtab[i].st_name))
 			nextval = mod->symtab[i].st_value;
 	}
 
@@ -2929,15 +2928,19 @@ unsigned long module_kallsyms_lookup_name(const char *name)
 
 	/* Don't lock: we're in enough trouble already. */
 	preempt_disable();
-	if ((colon = strchr(name, ':')) != NULL) {
+	colon = strchr(name, ':');
+	if (colon != NULL) {
 		*colon = '\0';
-		if ((mod = find_module(name)) != NULL)
+		mod = find_module(name);
+		if (mod != NULL)
 			ret = mod_find_symname(mod, colon+1);
 		*colon = ':';
 	} else {
-		list_for_each_entry_rcu(mod, &modules, list)
-			if ((ret = mod_find_symname(mod, name)) != 0)
+		list_for_each_entry_rcu(mod, &modules, list) {
+			ret = mod_find_symname(mod, name);
+			if (ret != 0)
 				break;
+		}
 	}
 	preempt_enable();
 	return ret;
@@ -3025,8 +3028,8 @@ static int m_show(struct seq_file *m, void *p)
 
 	/* Informative for users. */
 	seq_printf(m, " %s",
-		   mod->state == MODULE_STATE_GOING ? "Unloading":
-		   mod->state == MODULE_STATE_COMING ? "Loading":
+		   mod->state == MODULE_STATE_GOING ? "Unloading" :
+		   mod->state == MODULE_STATE_COMING ? "Loading" :
 		   "Live");
 	/* Used by oprofile and other similar tools. */
 	seq_printf(m, " 0x%p", mod->module_core);
-- 
1.7.3.1.g432b3.dirty

