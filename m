Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab1LFTNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:13:09 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48902 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab1LFTNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:13:06 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 21/25] kernel/module: replace DEBUGP with pr_debug
Date: Tue,  6 Dec 2011 12:11:31 -0700
Message-Id: <1323198694-7186-22-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>, <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
 <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Use more flexible pr_debug.  This allows:

  echo "module module +p" > /dbg/dynamic_debug/control

to turn on debug messages when needed.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 kernel/module.c |   44 +++++++++++++++++++-------------------------
 kernel/params.c |   14 ++++----------
 2 files changed, 23 insertions(+), 35 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index c7b495e..78b229e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -62,12 +62,6 @@
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
@@ -410,7 +404,7 @@ const struct kernel_symbol *find_symbol(const char *name,
 		return fsa.sym;
 	}
 
-	DEBUGP("Failed to find symbol %s\n", name);
+	pr_debug("Failed to find symbol %s\n", name);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(find_symbol);
@@ -600,11 +594,11 @@ static int already_uses(struct module *a, struct module *b)
 
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
 
@@ -619,7 +613,7 @@ static int add_module_usage(struct module *a, struct module *b)
 {
 	struct module_use *use;
 
-	DEBUGP("Allocating new usage for %s.\n", a->name);
+	pr_debug("Allocating new usage for %s.\n", a->name);
 	use = kmalloc(sizeof(*use), GFP_ATOMIC);
 	if (!use) {
 		printk(KERN_WARNING "%s: out of memory loading\n", a->name);
@@ -663,7 +657,7 @@ static void module_unload_free(struct module *mod)
 	mutex_lock(&module_mutex);
 	list_for_each_entry_safe(use, tmp, &mod->target_list, target_list) {
 		struct module *i = use->target;
-		DEBUGP("%s unusing %s\n", mod->name, i->name);
+		pr_debug("%s unusing %s\n", mod->name, i->name);
 		module_put(i);
 		list_del(&use->source_list);
 		list_del(&use->target_list);
@@ -761,7 +755,7 @@ static void wait_for_zero_refcount(struct module *mod)
 	/* Since we might sleep for some time, release the mutex first */
 	mutex_unlock(&module_mutex);
 	for (;;) {
-		DEBUGP("Looking at refcount...\n");
+		pr_debug("Looking at refcount...\n");
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		if (module_refcount(mod) == 0)
 			break;
@@ -804,7 +798,7 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 	if (mod->state != MODULE_STATE_LIVE) {
 		/* FIXME: if (force), slam module count and wake up
                    waiter --RR */
-		DEBUGP("%s already dying\n", mod->name);
+		pr_debug("%s already dying\n", mod->name);
 		ret = -EBUSY;
 		goto out;
 	}
@@ -1057,7 +1051,7 @@ static int check_version(Elf_Shdr *sechdrs,
 
 		if (versions[i].crc == maybe_relocated(*crc, crc_owner))
 			return 1;
-		DEBUGP("Found checksum %lX vs module %lX\n",
+		pr_debug("Found checksum %lX vs module %lX\n",
 		       maybe_relocated(*crc, crc_owner), versions[i].crc);
 		goto bad_version;
 	}
@@ -1834,7 +1828,7 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
 		case SHN_COMMON:
 			/* We compiled with -fno-common.  These are not
 			   supposed to happen.  */
-			DEBUGP("Common symbol: %s\n", name);
+			pr_debug("Common symbol: %s\n", name);
 			printk("%s: please compile with -fno-common\n",
 			       mod->name);
 			ret = -ENOEXEC;
@@ -1842,7 +1836,7 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
 
 		case SHN_ABS:
 			/* Don't need to do anything */
-			DEBUGP("Absolute symbol: 0x%08lx\n",
+			pr_debug("Absolute symbol: 0x%08lx\n",
 			       (long)sym[i].st_value);
 			break;
 
@@ -1966,7 +1960,7 @@ static void layout_sections(struct module *mod, struct load_info *info)
 	for (i = 0; i < info->hdr->e_shnum; i++)
 		info->sechdrs[i].sh_entsize = ~0UL;
 
-	DEBUGP("Core section allocation order:\n");
+	pr_debug("Core section allocation order:\n");
 	for (m = 0; m < ARRAY_SIZE(masks); ++m) {
 		for (i = 0; i < info->hdr->e_shnum; ++i) {
 			Elf_Shdr *s = &info->sechdrs[i];
@@ -1978,7 +1972,7 @@ static void layout_sections(struct module *mod, struct load_info *info)
 			    || strstarts(sname, ".init"))
 				continue;
 			s->sh_entsize = get_offset(mod, &mod->core_size, s, i);
-			DEBUGP("\t%s\n", sname);
+			pr_debug("\t%s\n", sname);
 		}
 		switch (m) {
 		case 0: /* executable */
@@ -1995,7 +1989,7 @@ static void layout_sections(struct module *mod, struct load_info *info)
 		}
 	}
 
-	DEBUGP("Init section allocation order:\n");
+	pr_debug("Init section allocation order:\n");
 	for (m = 0; m < ARRAY_SIZE(masks); ++m) {
 		for (i = 0; i < info->hdr->e_shnum; ++i) {
 			Elf_Shdr *s = &info->sechdrs[i];
@@ -2008,7 +2002,7 @@ static void layout_sections(struct module *mod, struct load_info *info)
 				continue;
 			s->sh_entsize = (get_offset(mod, &mod->init_size, s, i)
 					 | INIT_OFFSET_MASK);
-			DEBUGP("\t%s\n", sname);
+			pr_debug("\t%s\n", sname);
 		}
 		switch (m) {
 		case 0: /* executable */
@@ -2189,7 +2183,7 @@ static void layout_symtab(struct module *mod, struct load_info *info)
 	symsect->sh_flags |= SHF_ALLOC;
 	symsect->sh_entsize = get_offset(mod, &mod->init_size, symsect,
 					 info->index.sym) | INIT_OFFSET_MASK;
-	DEBUGP("\t%s\n", info->secstrings + symsect->sh_name);
+	pr_debug("\t%s\n", info->secstrings + symsect->sh_name);
 
 	src = (void *)info->hdr + symsect->sh_offset;
 	nsrc = symsect->sh_size / sizeof(*src);
@@ -2211,7 +2205,7 @@ static void layout_symtab(struct module *mod, struct load_info *info)
 	strsect->sh_flags |= SHF_ALLOC;
 	strsect->sh_entsize = get_offset(mod, &mod->init_size, strsect,
 					 info->index.str) | INIT_OFFSET_MASK;
-	DEBUGP("\t%s\n", info->secstrings + strsect->sh_name);
+	pr_debug("\t%s\n", info->secstrings + strsect->sh_name);
 
 	/* Append room for core symbols' strings at end of core part. */
 	info->stroffs = mod->core_size;
@@ -2621,7 +2615,7 @@ static int move_module(struct module *mod, struct load_info *info)
 	mod->module_init = ptr;
 
 	/* Transfer each section which specifies SHF_ALLOC */
-	DEBUGP("final section addresses:\n");
+	pr_debug("final section addresses:\n");
 	for (i = 0; i < info->hdr->e_shnum; i++) {
 		void *dest;
 		Elf_Shdr *shdr = &info->sechdrs[i];
@@ -2639,7 +2633,7 @@ static int move_module(struct module *mod, struct load_info *info)
 			memcpy(dest, (void *)shdr->sh_addr, shdr->sh_size);
 		/* Update sh_addr to point to copy in image. */
 		shdr->sh_addr = (unsigned long)dest;
-		DEBUGP("\t0x%p %s\n",
+		pr_debug("\t0x%p %s\n",
 		       (void *)shdr->sh_addr, info->secstrings + shdr->sh_name);
 	}
 
@@ -2811,7 +2805,7 @@ static struct module *load_module(void __user *umod,
 	struct module *mod;
 	long err;
 
-	DEBUGP("load_module: umod=%p, len=%lu, uargs=%p\n",
+	pr_debug("load_module: umod=%p, len=%lu, uargs=%p\n",
 	       umod, len, uargs);
 
 	/* Copy in the blobs from userspace, check they are vaguely sane. */
diff --git a/kernel/params.c b/kernel/params.c
index 70a9878..c649593 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -25,12 +25,6 @@
 #include <linux/slab.h>
 #include <linux/ctype.h>
 
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(fmt, a...)
-#endif
-
 /* Protects all parameters, and incidentally kmalloced_param list. */
 static DEFINE_MUTEX(param_lock);
 
@@ -107,7 +101,7 @@ static int parse_one(char *param,
 			/* No one handled NULL, so do it here. */
 			if (!val && params[i].ops->set != param_set_bool)
 				return -EINVAL;
-			DEBUGP("They are equal!  Calling %p\n",
+			pr_debug("They are equal!  Calling %p\n",
 			       params[i].ops->set);
 			mutex_lock(&param_lock);
 			err = params[i].ops->set(val, &params[i]);
@@ -117,11 +111,11 @@ static int parse_one(char *param,
 	}
 
 	if (handle_unknown) {
-		DEBUGP("Unknown argument: calling %p\n", handle_unknown);
+		pr_debug("Unknown argument: calling %p\n", handle_unknown);
 		return handle_unknown(param, val, modname);
 	}
 
-	DEBUGP("Unknown argument `%s'\n", param);
+	pr_debug("Unknown argument `%s'\n", param);
 	return -ENOENT;
 }
 
@@ -186,7 +180,7 @@ int parse_args(const char *name,
 {
 	char *param, *val;
 
-	DEBUGP("Parsing ARGS: %s\n", args);
+	pr_debug("Parsing ARGS: %s\n", args);
 
 	/* Chew leading spaces */
 	args = skip_spaces(args);
-- 
1.7.7.3

