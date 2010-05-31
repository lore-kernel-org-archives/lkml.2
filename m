Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab0EaUUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 16:20:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750730Ab0EaUUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 16:20:44 -0400
Date: Mon, 31 May 2010 13:16:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rusty Russell <rusty@rustcorp.com.au>, Brandon Philips <brandon@ifup.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 1/2] Make the module 'usage' lists be two-way
In-Reply-To: <alpine.LFD.2.00.1005311311490.3637@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1005311315460.3637@i5.linux-foundation.org>
References: <201005252300.07739.rjw@sisk.pl> <201005312130.17038.rusty@rustcorp.com.au> <201005312131.43238.rusty@rustcorp.com.au> <201005312132.28631.rusty@rustcorp.com.au> <20100531094834.c1a684d1.akpm@linux-foundation.org> <alpine.LFD.2.00.1005311100220.3986@i5.linux-foundation.org>
 <alpine.LFD.2.00.1005311311490.3637@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 31 May 2010 12:19:37 -0700
Subject: [PATCH 1/2] Make the module 'usage' lists be two-way

When adding a module that depends on another one, we used to create a
one-way list of "modules_which_use_me", so that module unloading could
see who needs a module.

It's actually quite simple to make that list go both ways: so that we
not only can see "who uses me", but also see a list of modules that are
"used by me".

In fact, we always wanted that list in "module_unload_free()": when we
unload a module, we want to also release all the other modules that are
used by that module.  But because we didn't have that list, we used to
first iterate over all modules, and then iterate over each "used by me"
list of that module.

By making the list two-way, we simplify module_unload_free(), and it
allows for some trivial fixes later too.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 include/linux/module.h |    4 ++-
 kernel/module.c        |   86 +++++++++++++++++++++++++++--------------------
 2 files changed, 52 insertions(+), 38 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 6914fca..680db9e 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -359,7 +359,9 @@ struct module
 
 #ifdef CONFIG_MODULE_UNLOAD
 	/* What modules depend on me? */
-	struct list_head modules_which_use_me;
+	struct list_head source_list;
+	/* What modules do I depend on? */
+	struct list_head target_list;
 
 	/* Who is waiting for us to be unloaded */
 	struct task_struct *waiter;
diff --git a/kernel/module.c b/kernel/module.c
index d806e00..82ae1e4 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -523,7 +523,8 @@ static void module_unload_init(struct module *mod)
 {
 	int cpu;
 
-	INIT_LIST_HEAD(&mod->modules_which_use_me);
+	INIT_LIST_HEAD(&mod->source_list);
+	INIT_LIST_HEAD(&mod->target_list);
 	for_each_possible_cpu(cpu) {
 		per_cpu_ptr(mod->refptr, cpu)->incs = 0;
 		per_cpu_ptr(mod->refptr, cpu)->decs = 0;
@@ -538,8 +539,9 @@ static void module_unload_init(struct module *mod)
 /* modules using other modules */
 struct module_use
 {
-	struct list_head list;
-	struct module *module_which_uses;
+	struct list_head source_list;
+	struct list_head target_list;
+	struct module *source, *target;
 };
 
 /* Does a already use b? */
@@ -547,8 +549,8 @@ static int already_uses(struct module *a, struct module *b)
 {
 	struct module_use *use;
 
-	list_for_each_entry(use, &b->modules_which_use_me, list) {
-		if (use->module_which_uses == a) {
+	list_for_each_entry(use, &b->source_list, source_list) {
+		if (use->source == a) {
 			DEBUGP("%s uses %s!\n", a->name, b->name);
 			return 1;
 		}
@@ -557,11 +559,38 @@ static int already_uses(struct module *a, struct module *b)
 	return 0;
 }
 
+/*
+ * Module a uses b
+ *  - we add 'a' as a "source", 'b' as a "target" of module use
+ *  - the module_use is added to the list of 'b' sources (so
+ *    'b' can walk the list to see who sourced them, and of 'a'
+ *    targets (so 'a' can see what modules it targets).
+ */
+static int add_module_usage(struct module *a, struct module *b)
+{
+	int no_warn;
+	struct module_use *use;
+
+	DEBUGP("Allocating new usage for %s.\n", a->name);
+	use = kmalloc(sizeof(*use), GFP_ATOMIC);
+	if (!use) {
+		printk("%s: out of memory loading\n", a->name);
+		module_put(b);
+		return 0;
+	}
+
+	use->source = a;
+	use->target = b;
+	list_add(&use->source_list, &b->source_list);
+	list_add(&use->target_list, &a->target_list);
+	no_warn = sysfs_create_link(b->holders_dir, &a->mkobj.kobj, a->name);
+	return 1;
+}
+
 /* Module a uses b */
 int use_module(struct module *a, struct module *b)
 {
-	struct module_use *use;
-	int no_warn, err;
+	int err;
 
 	if (b == NULL || already_uses(a, b)) return 1;
 
@@ -578,40 +607,23 @@ int use_module(struct module *a, struct module *b)
 	if (err)
 		return 0;
 
-	DEBUGP("Allocating new usage for %s.\n", a->name);
-	use = kmalloc(sizeof(*use), GFP_ATOMIC);
-	if (!use) {
-		printk("%s: out of memory loading\n", a->name);
-		module_put(b);
-		return 0;
-	}
-
-	use->module_which_uses = a;
-	list_add(&use->list, &b->modules_which_use_me);
-	no_warn = sysfs_create_link(b->holders_dir, &a->mkobj.kobj, a->name);
-	return 1;
+	return add_module_usage(a, b);
 }
 EXPORT_SYMBOL_GPL(use_module);
 
 /* Clear the unload stuff of the module. */
 static void module_unload_free(struct module *mod)
 {
-	struct module *i;
+	struct module_use *use, *tmp;
 
-	list_for_each_entry(i, &modules, list) {
-		struct module_use *use;
-
-		list_for_each_entry(use, &i->modules_which_use_me, list) {
-			if (use->module_which_uses == mod) {
-				DEBUGP("%s unusing %s\n", mod->name, i->name);
-				module_put(i);
-				list_del(&use->list);
-				kfree(use);
-				sysfs_remove_link(i->holders_dir, mod->name);
-				/* There can be at most one match. */
-				break;
-			}
-		}
+	list_for_each_entry_safe(use, tmp, &mod->target_list, target_list) {
+		struct module *i = use->target;
+		DEBUGP("%s unusing %s\n", mod->name, i->name);
+		module_put(i);
+		list_del(&use->source_list);
+		list_del(&use->target_list);
+		kfree(use);
+		sysfs_remove_link(i->holders_dir, mod->name);
 	}
 }
 
@@ -735,7 +747,7 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 		goto out;
 	}
 
-	if (!list_empty(&mod->modules_which_use_me)) {
+	if (!list_empty(&mod->source_list)) {
 		/* Other modules depend on us: get rid of them first. */
 		ret = -EWOULDBLOCK;
 		goto out;
@@ -799,9 +811,9 @@ static inline void print_unload_info(struct seq_file *m, struct module *mod)
 
 	/* Always include a trailing , so userspace can differentiate
            between this and the old multi-field proc format. */
-	list_for_each_entry(use, &mod->modules_which_use_me, list) {
+	list_for_each_entry(use, &mod->source_list, source_list) {
 		printed_something = 1;
-		seq_printf(m, "%s,", use->module_which_uses->name);
+		seq_printf(m, "%s,", use->source->name);
 	}
 
 	if (mod->init != NULL && mod->exit == NULL) {
-- 
1.7.1.227.gb676f

