Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574Ab0GHVkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 17:40:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab0GHVkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 17:40:31 -0400
Date: Thu, 8 Jul 2010 17:39:28 -0400
From: Jason Baron <jbaron@redhat.com>
To: Thomas Renninger <trenn@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Hannes Reinecke <hare@suse.de>, akpm@linux-foundation.org
Subject: Re: Dynamic Debug broken on 2.6.35-rc3?
Message-ID: <20100708213927.GB2934@redhat.com>
References: <201007011744.19564.trenn@suse.de> <20100701162601.GC2829@redhat.com> <201007021856.00139.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007021856.00139.trenn@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 06:55:59PM +0200, Thomas Renninger wrote:
> On Thursday 01 July 2010 18:26:01 Jason Baron wrote:
> > On Thu, Jul 01, 2010 at 05:44:19PM +0200, Thomas Renninger wrote:
> > > 
> > > Hi,
> > > 
> > > Doing:
> > > echo "file ec.c +p" >/sys/kernel/debug/dynamic_debug/control
> > > 
> > > I got x
> > > RIP: 0010:[<ffffffff81251267>]  [<ffffffff81251267>] 
> > > ddebug_change+0x87/0x240
> ... 
> > I just tried the same command on 2.6.35-rc3, and it worked fine. I
> > noticed that the kernel your running is: "2.6.35-rc3-0.0.10.4cae135-default",
> > so perhaps there are some other changes there causing this problem? Can
> > you re-produce the bug on a purely upstream kernel?
> I am able to create another crash with plain 2.6.35-rc3 kernel.

Hi,

So dynamic debug was not properly unregistering debug calls when modules
were removed. Specifically, we were leaving around references to debug
statements in modules that were no longer loaded. Thus, we would end up
touching invalid parts of memory, leading to these panics. The missing
unregister calls, were during module loading races, and error
conditions, and that probably explains why we haven't seen them before.
Also, I didn't see this problem initially b/c I was not using modules.
Anyways, please try the patch below to verify that it resolves this
issue.

thanks,

-Jason

Make sure we properly call ddebug_remove_module() when a module fails to
load. In addition, pass the pointer to the "debug table", to both
ddebug_add_module(), and ddebug_remove_module() so that we can uniquely
identify each set of debug statements. In this way even modules with the
same name can be properly identified and removed.


Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/dynamic_debug.h |    7 ++-----
 include/linux/module.h        |    4 ++++
 kernel/module.c               |   10 +++++++---
 lib/dynamic_debug.c           |    4 ++--
 4 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index b3cd4de..a5c133e 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -40,7 +40,7 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 				const char *modname);
 
 #if defined(CONFIG_DYNAMIC_DEBUG)
-extern int ddebug_remove_module(char *mod_name);
+extern int ddebug_remove_module(struct _ddebug *tab, char *mod_name);
 
 #define __dynamic_dbg_enabled(dd)  ({	     \
 	int __ret = 0;							     \
@@ -73,10 +73,7 @@ extern int ddebug_remove_module(char *mod_name);
 
 #else
 
-static inline int ddebug_remove_module(char *mod)
-{
-	return 0;
-}
+#define ddebug_remove_module(tab, name) do {} while (0)
 
 #define dynamic_pr_debug(fmt, ...)					\
 	do { if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); } while (0)
diff --git a/include/linux/module.h b/include/linux/module.h
index 8a6b9fd..97ce090 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -387,6 +387,10 @@ struct module
 	ctor_fn_t *ctors;
 	unsigned int num_ctors;
 #endif
+
+#ifdef CONFIG_DYNAMIC_DEBUG
+	struct _ddebug *ddebug;
+#endif
 };
 #ifndef MODULE_ARCH_INIT
 #define MODULE_ARCH_INIT {}
diff --git a/kernel/module.c b/kernel/module.c
index 8c6b428..16bb044 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -787,7 +787,6 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 
 	/* Store the name of the last unloaded module for diagnostic purposes */
 	strlcpy(last_unloaded_module, mod->name, sizeof(last_unloaded_module));
-	ddebug_remove_module(mod->name);
 
 	free_module(mod);
 	return 0;
@@ -1550,6 +1549,8 @@ static void free_module(struct module *mod)
 	remove_sect_attrs(mod);
 	mod_kobject_remove(mod);
 
+	ddebug_remove_module(mod->ddebug, mod->name);
+
 	/* Arch-specific cleanup. */
 	module_arch_cleanup(mod);
 
@@ -2053,12 +2054,14 @@ static inline void add_kallsyms(struct module *mod,
 }
 #endif /* CONFIG_KALLSYMS */
 
-static void dynamic_debug_setup(struct _ddebug *debug, unsigned int num)
+static void dynamic_debug_setup(struct _ddebug *debug, unsigned int num,
+							struct module *mod)
 {
 #ifdef CONFIG_DYNAMIC_DEBUG
 	if (ddebug_add_module(debug, num, debug->modname))
 		printk(KERN_ERR "dynamic debug error adding module: %s\n",
 					debug->modname);
+	mod->ddebug = debug;
 #endif
 }
 
@@ -2483,7 +2486,7 @@ static noinline struct module *load_module(void __user *umod,
 		debug = section_objs(hdr, sechdrs, secstrings, "__verbose",
 				     sizeof(*debug), &num_debug);
 		if (debug)
-			dynamic_debug_setup(debug, num_debug);
+			dynamic_debug_setup(debug, num_debug, mod);
 	}
 
 	err = module_finalize(hdr, sechdrs, mod);
@@ -2562,6 +2565,7 @@ static noinline struct module *load_module(void __user *umod,
 	synchronize_sched();
 	module_arch_cleanup(mod);
  cleanup:
+	ddebug_remove_module(mod->ddebug, mod->name);
 	free_modinfo(mod);
 	module_unload_free(mod);
 #if defined(CONFIG_MODULE_UNLOAD)
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 3df8eb1..7d66180 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -692,7 +692,7 @@ static void ddebug_table_free(struct ddebug_table *dt)
  * Called in response to a module being unloaded.  Removes
  * any ddebug_table's which point at the module.
  */
-int ddebug_remove_module(char *mod_name)
+int ddebug_remove_module(struct _ddebug *tab, char *mod_name)
 {
 	struct ddebug_table *dt, *nextdt;
 	int ret = -ENOENT;
@@ -703,7 +703,7 @@ int ddebug_remove_module(char *mod_name)
 
 	mutex_lock(&ddebug_lock);
 	list_for_each_entry_safe(dt, nextdt, &ddebug_tables, link) {
-		if (!strcmp(dt->mod_name, mod_name)) {
+		if (!strcmp(dt->mod_name, mod_name) && (tab == dt->ddebugs)) {
 			ddebug_table_free(dt);
 			ret = 0;
 		}
-- 
1.7.1

