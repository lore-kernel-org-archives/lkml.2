Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031143Ab2CNXEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:04:07 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:34736 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760065Ab2CNXCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:02:39 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>,
        Thomas Renninger <trenn@suse.de>
Subject: [PATCH 07/11] dynamic_debug: make dynamic-debug work during module initialization
Date: Wed, 14 Mar 2012 17:02:02 -0600
Message-Id: <1331766126-11674-8-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.8.1
In-Reply-To: <1331766126-11674-1-git-send-email-jim.cromie@gmail.com>
References: <1331766126-11674-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

This introduces a fake module param $module.dyndbg.  Its based upon
Thomas Renninger's $module.ddebug boot-time debugging patch from
https://lkml.org/lkml/2010/9/15/397

The 'fake' module parameter is provided for all modules, whether or
not they need it.  It is not explicitly added to each module, but is
implemented in 2 common callbacks invoked from parse_args.

Now dynamic_debug_init() directly calls parse_args(), which calls
ddebug_dyndbg_boot_params_cb().  This callback handles both bare and
module-prefixed dyndbg params immediately after the ddebug tables are
loaded, and ignores all other parameters. For example, the following
will enable pr_debug()s in 4 builtin modules, in the order given:

  dyndbg="module params +p; module aio +p" module.dyndbg=+p pci.dyndbg

A previous patch changed "ddebug_query" to "dyndbg"; since this new
callback handles it, we can drop the special case "ddebug_query" code.

For loadable modules, parse_args() in load_module() calls
ddebug_dyndbg_module_params_cb().  This handles bare dyndbg params as
passed from modprobe, and errors on other unknown params.

These callbacks need to know the module name, as provided by the
"doing" arg added in the previous patch.

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
 include/linux/dynamic_debug.h |   17 +++++++++++++
 kernel/module.c               |    2 +-
 lib/dynamic_debug.c           |   53 +++++++++++++++++++++++++++++++---------
 3 files changed, 59 insertions(+), 13 deletions(-)

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
index 1435981..662204a 100644
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
 
@@ -955,18 +991,10 @@ static int __init dynamic_debug_init(void)
 	if (ret)
 		goto out_free;
 
-	/* ddebug_query boot param got passed -> set it up */
-	if (ddebug_setup_string[0] != '\0') {
-		ret = ddebug_exec_queries(ddebug_setup_string);
-		if (ret < 0)
-			pr_warn("Invalid ddebug boot param %s",
-				ddebug_setup_string);
-		else
-			pr_info("%d changes by ddebug_query\n", ret);
-
-		/* keep tables even on ddebug_query parse error */
-		ret = 0;
-	}
+	cmdline = kstrdup(saved_command_line, GFP_KERNEL);
+	parse_args("dyndbg params", cmdline, NULL,
+		   0, 0, 0, &ddebug_dyndbg_boot_param_cb);
+	kfree(cmdline);
 
 out_free:
 	if (ret)
@@ -977,5 +1005,6 @@ out_free:
 }
 /* Allow early initialization for boot messages via boot param */
 arch_initcall(dynamic_debug_init);
+
 /* Debugfs setup must be done later */
 module_init(dynamic_debug_init_debugfs);
-- 
1.7.7.6

