Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab0IXM2j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 08:28:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:41535 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728Ab0IXM2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 08:28:35 -0400
From: Thomas Renninger <trenn@suse.de>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, bjorn.helgaas@hp.com, jbaron@redhat.com,
        Thomas Renninger <trenn@suse.de>
Subject: [PATCH 1/4] Dynamic Debug: Introduce global fake module param module.ddebug - V4
Date: Fri, 24 Sep 2010 14:28:28 +0200
Message-Id: <1285331311-21753-2-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20100920184441.GA2915@redhat.com>
References: <20100920184441.GA2915@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamic Debug allows enabling of pr_debug and dev_dbg messages at runtime.
This is controlled via /sys/kernel/debug/dynamic_debug/control.
One major drawback is that the whole initialization of a module cannot be
tracked, because ddebug is only aware of debug strings of loaded modules.
But this is the most interesting part...

This patch introduces a fake module parameter module.ddebug(not shown in
/sys/module/*/parameters, thus it does not use any resources/memory).

If a module passes ddebug as a module parameter (e.g. via module.ddebug
kernel boot param or via "modprobe module ddebug"), all debug strings of this
module get activated by issuing "module module_name +p" internally
(not via sysfs) when the module gets loaded.

Possible enhancements for the future if ddebug might get extended with
further flags:
module.ddebug=flags
Then module.ddebug="p" would be the same as module.ddebug, but if there
is a "x" ddebug flag added, one could pass:
module.ddebug="xp"
which would result in such a dynamic debug query:
module module_name +xp

Modules must not use "ddebug" as module parameter or it will get ignored.
If it's tried, a warning will show up at module load time that it will get
ignored (only works for not built-in modules).

Tested with (additional added pr_debug messages):
options hp-wmi ddebug
in modprobe.conf
-> works and pr_debug messages issued at module initialization time show
up. Also "p" flag gets set for the whole hp-wmi module:
grep hp-wmi /sys/../dynamic_debug/control
also tested with compiled-in modules, e.g. pnp.ddebug and an additional
patch later in the patch series which instruments pnp code to work with ddebug.

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Jason Baron <jbaron@redhat.com>
CC: Greg KH <gregkh@suse.de>
CC: lkml <linux-kernel@vger.kernel.org>
---
 Documentation/dynamic-debug-howto.txt |   28 ++++++++++-
 include/linux/dynamic_debug.h         |   15 ++++++
 include/linux/moduleparam.h           |    3 +
 kernel/module.c                       |    1 +
 kernel/params.c                       |   13 +++++-
 lib/dynamic_debug.c                   |   89 +++++++++++++++++++++++++++++++-
 6 files changed, 144 insertions(+), 5 deletions(-)

diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
index 58ea64a..ebbbbdd 100644
--- a/Documentation/dynamic-debug-howto.txt
+++ b/Documentation/dynamic-debug-howto.txt
@@ -213,7 +213,7 @@ Note also that there is no convenient syntax to remove all
 the flags at once, you need to use "-psc".
 
 
-Debug messages during boot process
+Debug Messages during Boot Process
 ==================================
 
 To be able to activate debug messages during the boot process,
@@ -232,6 +232,32 @@ PCI (or other devices) initialization also is a hot candidate for using
 this boot parameter for debugging purposes.
 
 
+Debug Messages at Module Initialization Time
+============================================
+
+Enabling debug messages inside a module is only possible if the module itself
+is loaded already. If you unload a module, the dynamic debug flags associated
+to its debug messages are lost.
+Therefore, enabling debug messages that get processed at module initialization
+time through the <debugfs>/dynamic_debug/control interface is not possible.
+Instead, a "ddebug" module paramter can be passed:
+
+	- via kernel boot parameter:
+	  module.ddebug
+
+	- as an ordinary module parameter via modprobe
+	  modprobe module ddebug
+
+	- or the parameter can be used permanently via modprobe.conf(.local)
+	  options module ddebug
+
+The ddebug option is not implemented as an ordinary module parameter and thus
+will not show up in /sys/module/module_name/parameters/ddebug
+The settings can get reverted through the sysfs interface again when the
+module got loaded as soon as debug messages are not needed anymore:
+echo "module module_name -p" > <debugfs>/dynamic_debug/control
+as described in the "Command Language Reference" chapter above.
+
 Examples
 ========
 
diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 52c0da4..56c0c3a 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -39,8 +39,13 @@ struct _ddebug {
 int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 				const char *modname);
 
+struct kernel_param;
+
 #if defined(CONFIG_DYNAMIC_DEBUG)
 extern int ddebug_remove_module(const char *mod_name);
+extern int ddebug_exec_query(char *query_string);
+extern void ddebug_module_parse_args(const char *name, char* args,
+				     struct kernel_param *params, unsigned num);
 
 #define __dynamic_dbg_enabled(dd)  ({	     \
 	int __ret = 0;							     \
@@ -77,6 +82,16 @@ static inline int ddebug_remove_module(const char *mod)
 {
 	return 0;
 }
+static inline int ddebug_exec_query(char *query_string)
+{
+	return 0;
+}
+static incline void ddebug_module_parse_args(const char *name, char* args,
+					     struct kernel_param *params,
+					     unsigned num)
+{
+	return 0;
+}
 
 #define dynamic_pr_debug(fmt, ...)					\
 	do { if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); } while (0)
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 9d2f183..5cec3cc 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -405,4 +405,7 @@ static inline void module_param_sysfs_remove(struct module *mod)
 { }
 #endif
 
+/* For being able to parse parameters the same way params.c does */
+extern char *next_arg(char *args, char **param, char **val);
+
 #endif /* _LINUX_MODULE_PARAMS_H */
diff --git a/kernel/module.c b/kernel/module.c
index d0b5f8d..3912e12 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2628,6 +2628,7 @@ static struct module *load_module(void __user *umod,
 	list_add_rcu(&mod->list, &modules);
 	mutex_unlock(&module_mutex);
 
+	ddebug_module_parse_args(mod->name, mod->args, mod->kp, mod->num_kp);
 	/* Module is ready to execute: parsing args may do that. */
 	err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp, NULL);
 	if (err < 0)
diff --git a/kernel/params.c b/kernel/params.c
index 08107d1..44950c3 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -107,6 +107,16 @@ static int parse_one(char *param,
 		}
 	}
 
+	/*
+	 * Ignore ddebug module params and module.ddebug boot params:
+	 * Documentation/dynamic-debug-howto.txt
+	 */
+	tmp = strstr(param, ".ddebug");
+	if (parameq(param, "ddebug") || (tmp && strlen(tmp) == 7)) {
+		DEBUGP("Ignoring ddebug parameter %s\n", param);
+		return 0;
+	}
+
 	if (handle_unknown) {
 		DEBUGP("Unknown argument: calling %p\n", handle_unknown);
 		return handle_unknown(param, val);
@@ -118,7 +128,7 @@ static int parse_one(char *param,
 
 /* You can use " around spaces, but can't escape ". */
 /* Hyphens and underscores equivalent in parameter names. */
-static char *next_arg(char *args, char **param, char **val)
+char *next_arg(char *args, char **param, char **val)
 {
 	unsigned int i, equals = 0;
 	int in_quote = 0, quoted = 0;
@@ -713,6 +723,7 @@ void module_param_sysfs_remove(struct module *mod)
 void destroy_params(const struct kernel_param *params, unsigned num)
 {
 	unsigned int i;
+	char *tmp;
 
 	for (i = 0; i < num; i++)
 		if (params[i].ops->free)
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index a687d90..482ddc2 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kallsyms.h>
@@ -27,9 +28,13 @@
 #include <linux/debugfs.h>
 #include <linux/slab.h>
 
+#include <asm/setup.h>
+
 extern struct _ddebug __start___verbose[];
 extern struct _ddebug __stop___verbose[];
 
+#define DDEBUG_STRING_SIZE 1024
+
 /* dynamic_debug_enabled, and dynamic_debug_enabled2 are bitmasks in which
  * bit n is set to 1 if any modname hashes into the bucket n, 0 otherwise. They
  * use independent hash functions, to reduce the chance of false positives.
@@ -429,7 +434,7 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 	return 0;
 }
 
-static int ddebug_exec_query(char *query_string)
+int ddebug_exec_query(char *query_string)
 {
 	unsigned int flags = 0, mask = 0;
 	struct ddebug_query query;
@@ -437,6 +442,9 @@ static int ddebug_exec_query(char *query_string)
 	int nwords;
 	char *words[MAXWORDS];
 
+	if (verbose)
+		printk(KERN_INFO "%s: got query: %s\n", __func__, query_string);
+
 	nwords = ddebug_tokenize(query_string, words, MAXWORDS);
 	if (nwords <= 0)
 		return -EINVAL;
@@ -450,10 +458,10 @@ static int ddebug_exec_query(char *query_string)
 	return 0;
 }
 
-static __initdata char ddebug_setup_string[1024];
+static __initdata char ddebug_setup_string[DDEBUG_STRING_SIZE];
 static __init int ddebug_setup_query(char *str)
 {
-	if (strlen(str) >= 1024) {
+	if (strlen(str) >= DDEBUG_STRING_SIZE) {
 		pr_warning("ddebug boot param string too large\n");
 		return 0;
 	}
@@ -704,6 +712,78 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 }
 EXPORT_SYMBOL_GPL(ddebug_add_module);
 
+/* We search for *ddebug* module params */
+void ddebug_module_parse_args(const char *name, char* args,
+			      struct kernel_param *params, unsigned num)
+{
+	char *ddebug, *param, *val, *args_it, *arg_dup_ptr;
+	int i;
+
+	/*
+	 * We must not modify the passed args string and need to store the
+	 * kstrdup pointer to be able to free memory later, TBD: find a way
+	 * to do this nicer
+	 */
+	arg_dup_ptr = args_it = kstrdup(args, GFP_KERNEL);
+	ddebug = kzalloc(DDEBUG_STRING_SIZE, GFP_KERNEL);
+	if (verbose)
+		printk(KERN_INFO "%s: Parsing ARGS: -%s- of %s\n",
+		       __func__, args_it, name);
+
+	for (i = 0; i < num; i++) {
+		if (!strcmp("ddebug", params[i].name))
+			pr_warning("Module %s uses reserved keyword "
+				   "*ddebug* as parameter\n", name);
+	}
+
+	/* Chew leading spaces */
+	args_it = skip_spaces(args_it);
+
+	while (*args_it) {
+		args_it = next_arg(args_it, &param, &val);
+		if (verbose)
+			printk(KERN_INFO "%s: Param: %s, val: %s\n",
+			       __func__, param, val);
+		if (!strcmp(param, "ddebug")) {
+			pr_info("Enabling debugging for module %s\n", name);
+			snprintf(ddebug, DDEBUG_STRING_SIZE, "module %s +p",
+				 name);
+			ddebug_exec_query(ddebug);
+		}
+	}
+	kfree(arg_dup_ptr);
+	kfree(ddebug);
+}
+
+/* We search for module.ddebug kernel boot params */
+static void __init ddebug_boot_parse_args(void)
+{
+	char *param, *val, *tmp, *args_it, *arg_dup_ptr;
+	char module[MODULE_NAME_LEN];
+
+	/* next_arg touches the passed buffer and chops each argument */
+	arg_dup_ptr = args_it = kstrdup(saved_command_line, GFP_KERNEL);
+
+	/* Chew leading spaces */
+	args_it = skip_spaces(args_it);
+
+	while (*args_it) {
+		args_it = next_arg(args_it, &param, &val);
+		if (verbose)
+			printk(KERN_INFO "%s: Param: %s, val: %s\n",
+			       __func__, param, val);
+		tmp = strstr(param, ".ddebug");
+		if (tmp && strlen(tmp) == 7) {
+			strlcpy(module, param, tmp - param + 1);
+			pr_info("Enabling debugging for module %s\n", module);
+			snprintf(ddebug_setup_string, DDEBUG_STRING_SIZE,
+				 "module %s +p", module);
+			ddebug_exec_query(ddebug_setup_string);
+		}
+	}
+	kfree(arg_dup_ptr);
+}
+
 static void ddebug_table_free(struct ddebug_table *dt)
 {
 	list_del_init(&dt->link);
@@ -805,6 +885,9 @@ static int __init dynamic_debug_init(void)
 				ddebug_setup_string);
 	}
 
+	/* Must be called after above -> ddebug_setup_string gets reused */
+	ddebug_boot_parse_args();
+
 out_free:
 	if (ret)
 		ddebug_remove_all_tables();
-- 
1.6.4.2

