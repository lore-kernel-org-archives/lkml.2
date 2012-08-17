Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab2HQRog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 13:44:36 -0400
Received: from hedgehog.storkhole.cz ([90.183.218.18]:14525 "EHLO
	hedgehog.storkhole.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab2HQRoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 13:44:30 -0400
From: Martin Pelikan <pelikan@storkhole.cz>
To: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Martin Pelikan <mpelikan@redhat.com>
Cc: Martin Pelikan <pelikan@storkhole.cz>
Subject: [PATCH] KDB: prettify and fix lsmod
Date: Fri, 17 Aug 2012 19:43:49 +0200
Message-Id: <1345225429-26459-1-git-send-email-pelikan@storkhole.cz>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the header describe all the columns and align the description properly.
Display taint flags with shorter coming/going, and reuse the code for that.
Module usage dependencies are displayed separately, because that information
is a) not that important and likely to be the same across all systems,
b) too long for 80x25 terminal and c) confusing when long lines are wrapped.

Also, module_use->source is always myself, and I'm "used by" the _target_.

Signed-off-by: Martin Pelikan <mpelikan@redhat.com>
---
 include/linux/module.h      |    1 +
 kernel/debug/kdb/kdb_main.c |   46 ++++++++++++++++++++++++------------------
 kernel/module.c             |    2 +-
 3 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index fbcafe2..76e75f9 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -387,6 +387,7 @@ struct module *__module_address(unsigned long addr);
 bool is_module_address(unsigned long addr);
 bool is_module_percpu_address(unsigned long addr);
 bool is_module_text_address(unsigned long addr);
+char *module_flags(struct module *mod, char *buf);
 
 static inline int within_module_core(unsigned long addr, struct module *mod)
 {
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 31df170..0427c49 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1955,6 +1955,7 @@ static int kdb_ef(int argc, const char **argv)
 }
 
 #if defined(CONFIG_MODULES)
+#define PTR_STRING_SIZE (2 + BITS_PER_LONG /4)
 /*
  * kdb_lsmod - This function implements the 'lsmod' command.  Lists
  *	currently loaded kernel modules.
@@ -1963,36 +1964,41 @@ static int kdb_ef(int argc, const char **argv)
 static int kdb_lsmod(int argc, const char **argv)
 {
 	struct module *mod;
+	int show_users = 0;
+	char flags[8];
+	unsigned long refc;
 
-	if (argc != 0)
+	switch (argc) {
+	case 1:
+		show_users = ! strcmp(argv[1], "-u");
+		/* FALLTHROUGH */
+	case 0:
+		break;
+	default:
 		return KDB_ARGCOUNT;
+	}
 
-	kdb_printf("Module                  Size  modstruct     Used by\n");
+	kdb_printf("Name                    Size  %*s %*s   Flags %s\n",
+	    PTR_STRING_SIZE, "modstruct",
+	    PTR_STRING_SIZE, "Core",
+	    show_users ? "Refs" : "");
 	list_for_each_entry(mod, kdb_modules, list) {
+		module_flags(mod, flags);
+		kdb_printf("%-20s%8u  0x%p 0x%p %7s", mod->name, mod->core_size,
+		    mod, mod->module_core, flags);
 
-		kdb_printf("%-20s%8u  0x%p ", mod->name,
-			   mod->core_size, (void *)mod);
 #ifdef CONFIG_MODULE_UNLOAD
-		kdb_printf("%4ld ", module_refcount(mod));
-#endif
-		if (mod->state == MODULE_STATE_GOING)
-			kdb_printf(" (Unloading)");
-		else if (mod->state == MODULE_STATE_COMING)
-			kdb_printf(" (Loading)");
-		else
-			kdb_printf(" (Live)");
-		kdb_printf(" 0x%p", mod->module_core);
-
-#ifdef CONFIG_MODULE_UNLOAD
-		{
+		refc = module_refcount(mod);
+		if (refc && show_users) {
 			struct module_use *use;
-			kdb_printf(" [ ");
+			kdb_printf("%5lu\n  [ ", refc);
 			list_for_each_entry(use, &mod->source_list,
 					    source_list)
-				kdb_printf("%s ", use->target->name);
-			kdb_printf("]\n");
+				kdb_printf("%s ", use->source->name);
+			kdb_printf("]");
 		}
 #endif
+		kdb_printf("\n");
 	}
 
 	return 0;
@@ -2840,7 +2846,7 @@ static void __init kdb_inittab(void)
 	kdb_register_repeat("reboot", kdb_reboot, "",
 	  "Reboot the machine immediately", 0, KDB_REPEAT_NONE);
 #if defined(CONFIG_MODULES)
-	kdb_register_repeat("lsmod", kdb_lsmod, "",
+	kdb_register_repeat("lsmod", kdb_lsmod, "[-u]",
 	  "List loaded kernel modules", 0, KDB_REPEAT_NONE);
 #endif
 #if defined(CONFIG_MAGIC_SYSRQ)
diff --git a/kernel/module.c b/kernel/module.c
index 4edbd9c..69c5f9e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3308,7 +3308,7 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 }
 #endif /* CONFIG_KALLSYMS */
 
-static char *module_flags(struct module *mod, char *buf)
+char *module_flags(struct module *mod, char *buf)
 {
 	int bx = 0;
 
-- 
1.7.6

