Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab0FADm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 23:42:27 -0400
Received: from ozlabs.org ([203.10.76.45]:34302 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319Ab0FADm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 23:42:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/2] Make the module 'usage' lists be two-way
Date: Tue, 1 Jun 2010 13:12:20 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
References: <201005252300.07739.rjw@sisk.pl> <alpine.LFD.2.00.1005311315460.3637@i5.linux-foundation.org> <201006011107.35722.rusty@rustcorp.com.au>
In-Reply-To: <201006011107.35722.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006011312.22198.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010 11:07:34 am Rusty Russell wrote:
> On Tue, 1 Jun 2010 05:46:23 am Linus Torvalds wrote:
> > +static int add_module_usage(struct module *a, struct module *b)
> > +{
> > +	int no_warn;
> > +	struct module_use *use;
> 
> These days I tend to use bool for functions which return 1/0 like this.

Actually, I changed it to -ENOMEM/0 when I applied it on top of the other
fixes.

But this is ugly:

> +       use = kmalloc(sizeof(*use), GFP_ATOMIC);
> +       if (!use) {
> +               printk("%s: out of memory loading\n", a->name);
> +               module_put(b);
> +               return 0;

The module_get is in the caller, but the module_put is here on failure.
Don't half split-out a function like this.  I also added KERN_WARNING to the
printk and fixed the Subject line.

Result below (rebased on top of the locking cleanup).  Here's the
updated git tree, too:

	git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6 modules

Thanks,
Rusty.

Subject: module: Make the 'usage' lists be two-way
Date: Mon, 31 May 2010 12:19:37 -0700
From: Linus Torvalds <torvalds@linux-foundation.org>

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
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (cleaned & rebased)
---
 include/linux/module.h |    4 +-
 kernel/module.c        |   86 ++++++++++++++++++++++++++++---------------------
 2 files changed, 53 insertions(+), 37 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
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
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -524,7 +524,8 @@ static void module_unload_init(struct mo
 {
 	int cpu;
 
-	INIT_LIST_HEAD(&mod->modules_which_use_me);
+	INIT_LIST_HEAD(&mod->source_list);
+	INIT_LIST_HEAD(&mod->target_list);
 	for_each_possible_cpu(cpu) {
 		per_cpu_ptr(mod->refptr, cpu)->incs = 0;
 		per_cpu_ptr(mod->refptr, cpu)->decs = 0;
@@ -539,8 +540,9 @@ static void module_unload_init(struct mo
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
@@ -548,8 +550,8 @@ static int already_uses(struct module *a
 {
 	struct module_use *use;
 
-	list_for_each_entry(use, &b->modules_which_use_me, list) {
-		if (use->module_which_uses == a) {
+	list_for_each_entry(use, &b->source_list, source_list) {
+		if (use->source == a) {
 			DEBUGP("%s uses %s!\n", a->name, b->name);
 			return 1;
 		}
@@ -558,11 +560,37 @@ static int already_uses(struct module *a
 	return 0;
 }
 
+/*
+ * Module a uses b
+ *  - we add 'a' as a "source", 'b' as a "target" of module use
+ *  - the module_use is added to the list of 'b' sources (so
+ *    'b' can walk the list to see who sourced them), and of 'a'
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
+		printk(KERN_WARNING "%s: out of memory loading\n", a->name);
+		return -ENOMEM;
+	}
+
+	use->source = a;
+	use->target = b;
+	list_add(&use->source_list, &b->source_list);
+	list_add(&use->target_list, &a->target_list);
+	no_warn = sysfs_create_link(b->holders_dir, &a->mkobj.kobj, a->name);
+	return 0;
+}
+
 /* Module a uses b: caller needs module_mutex() */
 int ref_module(struct module *a, struct module *b)
 {
-	struct module_use *use;
-	int no_warn, err;
+	int err;
 
 	if (b == NULL || already_uses(a, b))
 		return 0;
@@ -572,41 +600,27 @@ int ref_module(struct module *a, struct 
 	if (err)
 		return err;
 
-	DEBUGP("Allocating new usage for %s.\n", a->name);
-	use = kmalloc(sizeof(*use), GFP_ATOMIC);
-	if (!use) {
-		printk("%s: out of memory loading\n", a->name);
+	err = add_module_usage(a, b);
+	if (err)
 		module_put(b);
-		return -ENOMEM;
-	}
-
-	use->module_which_uses = a;
-	list_add(&use->list, &b->modules_which_use_me);
-	no_warn = sysfs_create_link(b->holders_dir, &a->mkobj.kobj, a->name);
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL_GPL(ref_module);
 
 /* Clear the unload stuff of the module. */
 static void module_unload_free(struct module *mod)
 {
-	struct module *i;
+	struct module_use *use, *tmp;
 
 	mutex_lock(&module_mutex);
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
 	mutex_unlock(&module_mutex);
 }
@@ -731,7 +745,7 @@ SYSCALL_DEFINE2(delete_module, const cha
 		goto out;
 	}
 
-	if (!list_empty(&mod->modules_which_use_me)) {
+	if (!list_empty(&mod->source_list)) {
 		/* Other modules depend on us: get rid of them first. */
 		ret = -EWOULDBLOCK;
 		goto out;
@@ -796,9 +810,9 @@ static inline void print_unload_info(str
 
 	/* Always include a trailing , so userspace can differentiate
            between this and the old multi-field proc format. */
-	list_for_each_entry(use, &mod->modules_which_use_me, list) {
+	list_for_each_entry(use, &mod->source_list, source_list) {
 		printed_something = 1;
-		seq_printf(m, "%s,", use->module_which_uses->name);
+		seq_printf(m, "%s,", use->source->name);
 	}
 
 	if (mod->init != NULL && mod->exit == NULL) {
