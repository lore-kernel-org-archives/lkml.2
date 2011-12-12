Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab1LLXNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:13:51 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42879 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab1LLXNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:13:40 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        Jim Cromie <jim.cromie@gmail.com>, Thomas Renninger <trenn@suse.de>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 18/25] dynamic_debug: Introduce global fake module param $module.dyndbg
Date: Mon, 12 Dec 2011 16:12:44 -0700
Message-Id: <1323731569-20644-18-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323731569-20644-1-git-send-email-jim.cromie@gmail.com>
References: <1323731569-20644-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Rework Thomas Renninger's $module.ddebug boot-time debugging feature,
from https://lkml.org/lkml/2010/9/15/397

Extend dynamic-debug facility to work during module initialization:

   foo.dyndbg bar.dyndbg="$bar_query_string"

This patch introduces a 'fake' module parameter: $module.dyndbg for
all modules, whether or not they need it.  It is not explicitly added
to each module, but is implemented in common code, in 2 ways:

For builtin modules, dynamic_debug.c:ddebug_boot_parse_args() copies
and parses the command-line for each $module.dyndbg, and calls
ddebug_exec_queries to apply its value as a query-string.

For loadable modules, kernel/param's parse_args(), via parse_one(),
invokes an unknown-parameter callback, ddebug_dyndbg_param_cb(),
for each of $module's options given in /etc/modprobe.d/*, for
$module.dyndbg given in boot command-line, and for options given
in the modprobe command, with each augmenting or overriding
previous flag settings.

In both cases, if no value is given (as in foo.dyndbg example above),
"+p" is assumed, which enables all pr_debug callsites in the module.

The unknown-parameter callback signature is altered, adding module-name.
This lets ddebug_dyndbg_param_cb() know what module its applying a
query-string for, and is needed because the module-name prefix is
stripped by parse_args()/parse_one().  The callback returns 0 if the
unknown param is "dyndbg", even if query-string is wrong; modprobe
shouldnt fail just because the dyndbg query is bad.

The parameter is not shown in /sys/module/*/parameters, thus it does
not use any resources.  Changes to the parameter are made via the
control file.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
CC: Thomas Renninger <trenn@suse.de>
CC: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/dynamic_debug.h |   11 ++++++++++
 include/linux/moduleparam.h   |    6 ++++-
 init/main.c                   |    5 ++-
 kernel/module.c               |    3 +-
 kernel/params.c               |   26 ++++++++++++++----------
 lib/dynamic_debug.c           |   44 ++++++++++++++++++++++++++++++++++++++++-
 6 files changed, 79 insertions(+), 16 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 7e3c53a..3027349 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -44,6 +44,8 @@ extern int ddebug_remove_module(const char *mod_name);
 extern __printf(2, 3)
 int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...);
 
+extern int ddebug_dyndbg_param_cb(char *param, char *val, const char *modname);
+
 struct device;
 
 extern __printf(3, 4)
@@ -99,6 +101,15 @@ static inline int ddebug_remove_module(const char *mod)
 	return 0;
 }
 
+static inline int ddebug_dyndbg_param_cb(char *param, char *val,
+					const char *modname)
+{
+	if (strcmp(param, "dyndbg"))
+		return -ENOENT;
+	pr_warn("dyndbg supported only in CONFIG_DYNAMIC_DEBUG builds\n");
+	return 0; /* dont fail modprobe, warning is enough */
+}
+
 #define dynamic_pr_debug(fmt, ...)					\
 	do { if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); } while (0)
 #define dynamic_dev_dbg(dev, fmt, ...)					\
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 7939f63..3e272c7 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -292,7 +292,8 @@ extern int parse_args(const char *name,
 		      char *args,
 		      const struct kernel_param *params,
 		      unsigned num,
-		      int (*unknown)(char *param, char *val));
+		      int (*unknown)(char *param, char *val,
+			      const char *modname));
 
 /* Called by module remove. */
 #ifdef CONFIG_SYSFS
@@ -433,4 +434,7 @@ static inline void module_param_sysfs_remove(struct module *mod)
 { }
 #endif
 
+/* For being able to parse parameters the same way params.c does */
+extern char *next_arg(char *args, char **param, char **val);
+
 #endif /* _LINUX_MODULE_PARAMS_H */
diff --git a/init/main.c b/init/main.c
index 217ed23..928fab6 100644
--- a/init/main.c
+++ b/init/main.c
@@ -230,7 +230,8 @@ early_param("loglevel", loglevel);
  * Unknown boot options get handed to init, unless they look like
  * unused parameters (modprobe will find them in /proc/cmdline).
  */
-static int __init unknown_bootoption(char *param, char *val)
+static int __init unknown_bootoption(char *param, char *val,
+				const char *modname)
 {
 	/* Change NUL term back to "=", to make "param" the whole string. */
 	if (val) {
@@ -387,7 +388,7 @@ static noinline void __init_refok rest_init(void)
 }
 
 /* Check for early params. */
-static int __init do_early_param(char *param, char *val)
+static int __init do_early_param(char *param, char *val, const char *modname)
 {
 	const struct obs_kernel_param *p;
 
diff --git a/kernel/module.c b/kernel/module.c
index 39a7888..78b229e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2887,7 +2887,8 @@ static struct module *load_module(void __user *umod,
 	mutex_unlock(&module_mutex);
 
 	/* Module is ready to execute: parsing args may do that. */
-	err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp, NULL);
+	err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp,
+			 ddebug_dyndbg_param_cb);
 	if (err < 0)
 		goto unlink;
 
diff --git a/kernel/params.c b/kernel/params.c
index 9240664..4c39c0e 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -86,9 +86,11 @@ bool parameq(const char *a, const char *b)
 
 static int parse_one(char *param,
 		     char *val,
+		     const char *doing,
 		     const struct kernel_param *params,
 		     unsigned num_params,
-		     int (*handle_unknown)(char *param, char *val))
+		     int (*handle_unknown)(char *param, char *val,
+					   const char *modname))
 {
 	unsigned int i;
 	int err;
@@ -109,8 +111,10 @@ static int parse_one(char *param,
 	}
 
 	if (handle_unknown) {
-		pr_debug("Unknown argument: calling %p\n", handle_unknown);
-		return handle_unknown(param, val);
+		/* Booting kernel, early options are too early for this */
+		pr_debug("doing %s: %s = %s, callback %p\n",
+			doing, param, val, handle_unknown);
+		return handle_unknown(param, val, doing);
 	}
 
 	pr_debug("Unknown argument `%s'\n", param);
@@ -119,7 +123,7 @@ static int parse_one(char *param,
 
 /* You can use " around spaces, but can't escape ". */
 /* Hyphens and underscores equivalent in parameter names. */
-static char *next_arg(char *args, char **param, char **val)
+char *next_arg(char *args, char **param, char **val)
 {
 	unsigned int i, equals = 0;
 	int in_quote = 0, quoted = 0;
@@ -170,15 +174,15 @@ static char *next_arg(char *args, char **param, char **val)
 }
 
 /* Args looks like "foo=bar,bar2 baz=fuz wiz". */
-int parse_args(const char *name,
+int parse_args(const char *doing, /* modname, Booting kernel, early options */
 	       char *args,
 	       const struct kernel_param *params,
 	       unsigned num,
-	       int (*unknown)(char *param, char *val))
+	       int (*unknown)(char *param, char *val, const char *modname))
 {
 	char *param, *val;
 
-	pr_debug("Parsing ARGS: %s\n", args);
+	pr_debug("doing %s, parsing ARGS: %s\n", doing, args);
 
 	/* Chew leading spaces */
 	args = skip_spaces(args);
@@ -189,7 +193,7 @@ int parse_args(const char *name,
 
 		args = next_arg(args, &param, &val);
 		irq_was_disabled = irqs_disabled();
-		ret = parse_one(param, val, params, num, unknown);
+		ret = parse_one(param, val, doing, params, num, unknown);
 		if (irq_was_disabled && !irqs_disabled()) {
 			printk(KERN_WARNING "parse_args(): option '%s' enabled "
 					"irq's!\n", param);
@@ -197,19 +201,19 @@ int parse_args(const char *name,
 		switch (ret) {
 		case -ENOENT:
 			printk(KERN_ERR "%s: Unknown parameter `%s'\n",
-			       name, param);
+			       doing, param);
 			return ret;
 		case -ENOSPC:
 			printk(KERN_ERR
 			       "%s: `%s' too large for parameter `%s'\n",
-			       name, val ?: "", param);
+			       doing, val ?: "", param);
 			return ret;
 		case 0:
 			break;
 		default:
 			printk(KERN_ERR
 			       "%s: `%s' invalid for parameter `%s'\n",
-			       name, val ?: "", param);
+			       doing, val ?: "", param);
 			return ret;
 		}
 	}
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 516ad4e..4cdcc64 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -618,7 +618,7 @@ static __initdata char ddebug_setup_string[DDEBUG_STRING_SIZE];
 
 static __init int ddebug_setup_query(char *str)
 {
-	if (strlen(str) >= 1024) {
+	if (strlen(str) >= DDEBUG_STRING_SIZE) {
 		pr_warn("ddebug boot param string too large\n");
 		return 0;
 	}
@@ -872,6 +872,47 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 }
 EXPORT_SYMBOL_GPL(ddebug_add_module);
 
+/* called from params.c:parse_one for unknown params, gets bare params */
+int ddebug_dyndbg_param_cb(char *param, char* val, const char* modname)
+{
+	if (strcmp(param, "dyndbg")) {
+		pr_info("skip modname: %s %s=\"%s\"\n", modname, param, val);
+		return -ENOENT;
+	}
+	if (verbose)
+		pr_info("module: %s %s=\"%s\"\n", modname, param, val);
+
+	ddebug_exec_queries(val ? val : "+p");
+	return 0; /* query failure shouldnt stop module load */
+}
+
+#define COMMAND_LINE_SIZE 1024
+static __initdata char tmp_cmd_arr[COMMAND_LINE_SIZE];
+
+/* find & process .dyndbg params (prefixed by modname) in cmdline */
+static __init void ddebug_boot_parse_args(void)
+{
+	char *tmp_cmd_ptr, *param, *val, *modname;
+
+	/* copy cmdline before mangling it */
+	strlcpy(tmp_cmd_arr, saved_command_line, COMMAND_LINE_SIZE);
+	tmp_cmd_ptr = skip_spaces(tmp_cmd_arr);
+
+	while (*tmp_cmd_ptr) {
+		tmp_cmd_ptr = next_arg(tmp_cmd_ptr, &param, &val);
+		modname = param;
+		param = strstr(param, ".dyndbg");
+		if (!param)
+			continue;
+		*(param++) = '\0';
+		pr_info("Enabling debugging for module %s\n", modname);
+		if (verbose)
+			pr_info("Param: %s, val: %s\n", param, val);
+
+		ddebug_exec_queries(val ? val : "+p");
+	}
+}
+
 static void ddebug_table_free(struct ddebug_table *dt)
 {
 	list_del_init(&dt->link);
@@ -978,6 +1019,7 @@ static int __init dynamic_debug_init(void)
 		/* keep tables even on ddebug_query parse error */
 		ret = 0;
 	}
+	ddebug_boot_parse_args();
 
 out_free:
 	if (ret)
-- 
1.7.7.3

