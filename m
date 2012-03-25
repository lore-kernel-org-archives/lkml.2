Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab2CYX1G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 19:27:06 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61995 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371Ab2CYX0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 19:26:21 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>,
        Thomas Renninger <trenn@suse.de>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 07/16] dynamic_debug: make dynamic-debug work for module initialization
Date: Sun, 25 Mar 2012 17:25:45 -0600
Message-Id: <1332717954-5775-8-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332717954-5775-1-git-send-email-jim.cromie@gmail.com>
References: <1332717954-5775-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

This introduces a fake module param $module.dyndbg.  Its based upon
Thomas Renninger's $module.ddebug boot-time debugging patch from
https://lkml.org/lkml/2010/9/15/397

The 'fake' module parameter is provided for all modules, whether or
not they need it.  It is not explicitly added to each module, but is
implemented in callbacks invoked from parse_args.

For builtin modules, dynamic_debug_init() now directly calls
parse_args(..., &ddebug_dyndbg_boot_params_cb), to process the params
undeclared in the modules, just after the ddebug tables are processed.
While its slightly weird to reprocess the boot params, the dyndbg
queries (given in dyndbg params) cannot be activated until after the
ddebug tables are ready, and reusing parse_args is cleaner than an
ad-hoc parse.  This reparse would break options like inc_verbosity,
but they probably should be params, like verbosity=3.

ddebug_dyndbg_boot_params_cb() handles both bare dyndbg (formerly
ddebug_query) and module-prefixed dyndbg params, and ignores all other
parameters.  For example, the following will enable pr_debug()s in 4
builtin modules, in the order given:

  dyndbg="module params +p; module aio +p" module.dyndbg=+p pci.dyndbg

With ddebug_query changed to dyndbg, we also deprecate "ddebug_query".
The code handling it will be removed later.  For now, both are active.

For loadable modules, parse_args() in load_module() calls
ddebug_dyndbg_module_params_cb().  This handles bare dyndbg params as
passed from modprobe, and errors on other unknown params.

Note that modprobe reads /proc/cmdline, so "modprobe foo" grabs all
foo.params, strips the "foo.", and passes these to the kernel.
ddebug_dyndbg_module_params_cb() is again called for the unknown
params; it handles dyndbg, and errors on others.  The "doing" arg
added previously contains the module name.

For non CONFIG_DYNAMIC_DEBUG builds, the stub function accepts
and ignores $module.dyndbg params, other unknowns get -ENOENT.

If no param value is given (as in pci.dyndbg example above), "+p" is
assumed, which enables all pr_debug callsites in the module.

The dyndbg fake parameter is not shown in /sys/module/*/parameters,
thus it does not use any resources.  Changes to it are made via the
control file.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
CC: Thomas Renninger <trenn@suse.de>
CC: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/dynamic_debug.h |   17 ++++++++++++++
 kernel/module.c               |    2 +-
 lib/dynamic_debug.c           |   49 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+), 1 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index bf1b0fc..4697e4b 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -44,6 +44,9 @@ extern int ddebug_remove_module(const char *mod_name);
 extern __printf(2, 3)
 int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...);
 
+extern int ddebug_dyndbg_module_param_cb(char *param, char *val,
+					const char *modname);
+
 struct device;
 
 extern __printf(3, 4)
@@ -94,11 +97,25 @@ do {								\
 
 #else
 
+#include <linux/string.h>
+#include <linux/errno.h>
+
 static inline int ddebug_remove_module(const char *mod)
 {
 	return 0;
 }
 
+static inline int ddebug_dyndbg_module_param_cb(char *param, char *val,
+						const char *modname)
+{
+	if (strstr(param, "dyndbg")) {
+		pr_warn("dyndbg supported only in "
+			"CONFIG_DYNAMIC_DEBUG builds\n");
+		return 0; /* allow and ignore */
+	}
+	return -EINVAL;
+}
+
 #define dynamic_pr_debug(fmt, ...)					\
 	do { if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); } while (0)
 #define dynamic_dev_dbg(dev, fmt, ...)					\
diff --git a/kernel/module.c b/kernel/module.c
index 78ac6ec..a4e6097 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2953,7 +2953,7 @@ static struct module *load_module(void __user *umod,
 
 	/* Module is ready to execute: parsing args may do that. */
 	err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp,
-			 -32768, 32767, NULL);
+			 -32768, 32767, &ddebug_dyndbg_module_param_cb);
 	if (err < 0)
 		goto unlink;
 
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 1435981..32e7c52 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -862,6 +862,41 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 }
 EXPORT_SYMBOL_GPL(ddebug_add_module);
 
+/* handle both dyndbg=".." and $module.dyndbg=".." params at boot */
+static int ddebug_dyndbg_boot_param_cb(char *param, char *val,
+				const char *unused)
+{
+	const char *modname = NULL;
+	char *sep;
+
+	sep = strchr(param, '.');
+	if (sep) {
+		*sep = '\0';
+		modname = param;
+		param = sep + 1;
+	}
+	if (strcmp(param, "dyndbg"))
+		return 0; /* skip all other params w/o error */
+
+	vpr_info("module: %s %s=\"%s\"\n", modname, param, val);
+
+	ddebug_exec_queries(val ? val : "+p");
+	return 0; /* query failure shouldnt stop module load */
+}
+
+/* handle dyndbg args to modprobe */
+int ddebug_dyndbg_module_param_cb(char *param, char *val, const char *doing)
+{
+	if (strcmp(param, "dyndbg"))
+		return -ENOENT;
+
+	vpr_info("module: %s %s=\"%s\"\n", doing, param, val);
+
+	ddebug_exec_queries((val ? val : "+p"), doing);
+
+	return 0; /* query failure shouldnt stop module load */
+}
+
 static void ddebug_table_free(struct ddebug_table *dt)
 {
 	list_del_init(&dt->link);
@@ -929,6 +964,7 @@ static int __init dynamic_debug_init(void)
 {
 	struct _ddebug *iter, *iter_start;
 	const char *modname = NULL;
+	char *cmdline;
 	int ret = 0;
 	int n = 0;
 
@@ -967,6 +1003,18 @@ static int __init dynamic_debug_init(void)
 		/* keep tables even on ddebug_query parse error */
 		ret = 0;
 	}
+	/* now that ddebug tables are loaded, process all boot args
+	 * again to find and activate queries given in dyndbg params.
+	 * While this has already been done for known boot params, it
+	 * ignored the unknown ones (dyndbg in particular).  Reusing
+	 * parse_args avoids ad-hoc parsing.  This will also attempt
+	 * to activate queries for not-yet-loaded modules, which is
+	 * slightly noisy if verbose, but harmless.
+	 */
+	cmdline = kstrdup(saved_command_line, GFP_KERNEL);
+	parse_args("dyndbg params", cmdline, NULL,
+		   0, 0, 0, &ddebug_dyndbg_boot_param_cb);
+	kfree(cmdline);
 
 out_free:
 	if (ret)
@@ -977,5 +1025,6 @@ out_free:
 }
 /* Allow early initialization for boot messages via boot param */
 arch_initcall(dynamic_debug_init);
+
 /* Debugfs setup must be done later */
 module_init(dynamic_debug_init_debugfs);
-- 
1.7.7.6

