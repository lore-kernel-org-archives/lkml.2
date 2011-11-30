Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab1K3T7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 14:59:25 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36603 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab1K3T6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 14:58:10 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>,
        Thomas Renninger <trenn@suse.de>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 20/25] dynamic_debug: rename ddebug param to dyndbg, plus minor tweaks
Date: Wed, 30 Nov 2011 12:56:49 -0700
Message-Id: <1322683014-13285-21-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com>
References: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

user-visible:
- change param-name from "ddebug" to "dyndbg".  This is more clearly
  associated with dynamic-debug, and more distinct from other *debug*
  names.

minor internal tweaks:
- drop return 0 in the inline void ddebug_module_parse_args stub,
  in #ifndef CONFIG_DYNAMIC_DEBUG case, to silence warning.
- make ddebug_exec_query static again, its not used elsewhere.
- shrink stack in ddebug_boot_parse_args, move auto vars to __initdata.
- convert printk()s to pr_info()s.
- add "mod" prefix to ddebug_module_parse_args(name, args, ...) parameters.
- in ddebug_module_parse_args(), return early if no mod-params,
  to avoid non-pertinent pr_info()s and kstrdup.
- in ddebug_module_parse_args() and ddebug_boot_parse_args() arg scan
  loops, invert param-name == "ddebug" checks and continue.  This
  avoids pr_info()s for uninteresting args, and reduces indenting.
- use ddebug_exec_queries() instead of ddebug_exec_query().

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
CC: Thomas Renninger <trenn@suse.de>
CC: Rusty Russell <rusty@rustcorp.com.au>
---
 Documentation/dynamic-debug-howto.txt |   57 +++++++++++++++++++--------
 include/linux/dynamic_debug.h         |    7 +---
 kernel/params.c                       |    8 ++--
 lib/dynamic_debug.c                   |   67 +++++++++++++++++----------------
 4 files changed, 79 insertions(+), 60 deletions(-)

diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
index 269065d..8363a56 100644
--- a/Documentation/dynamic-debug-howto.txt
+++ b/Documentation/dynamic-debug-howto.txt
@@ -241,28 +241,40 @@ this boot parameter for debugging purposes.
 Debug Messages at Module Initialization Time
 ============================================
 
-Enabling debug messages inside a module is only possible if the module itself
-is loaded already. If you unload a module, the dynamic debug flags associated
-to its debug messages are lost.
-Therefore, enabling debug messages that get processed at module initialization
-time through the <debugfs>/dynamic_debug/control interface is not possible.
-Instead, a "ddebug" module paramter can be passed:
+Enabling a module's debug messages via debug control file only works
+once the module is loaded; too late for callsites in init functions.
+And when module is unloaded, debug flag settings for the module are
+lost.  Instead, a "dyndbg" module parameter can be passed:
 
-	- via kernel boot parameter:
-	  module.ddebug
+	- via kernel boot parameter: (this form works on built-ins too)
+	  module.dyndbg=+mfp
+	  module.dyndbg	# defaults to +p
 
-	- as an ordinary module parameter via modprobe
-	  modprobe module ddebug
+	- as an ordinary module parameter via modprobe modprobe module
+	  $> modprobe module dyndbg +pmfl # defaults to +p
 
 	- or the parameter can be used permanently via modprobe.conf(.local)
-	  options module ddebug
+	  options module dyndbg=+pmflt
+	  options module dyndbg # defaults to +p
 
-The ddebug option is not implemented as an ordinary module parameter and thus
-will not show up in /sys/module/module_name/parameters/ddebug
-The settings can get reverted through the sysfs interface again when the
-module got loaded as soon as debug messages are not needed anymore:
-echo "module module_name -p" > <debugfs>/dynamic_debug/control
-as described in the "Command Language Reference" chapter above.
+The $modname.dyndbg="value" should exclude "module $modname", as the
+$modname is taken from the param-name, and only 1 spec of each type is
+allowed.
+
+The ddebug option is not implemented as an ordinary module parameter
+and thus will not show up in /sys/module/module_name/parameters/ddebug
+The settings can be reverted later via the sysfs interface if the
+debug messages are no longer needed:
+
+      echo "module module_name -p" > <debugfs>/dynamic_debug/control
+
+$module.dyndbg="..." on boot-line works on built-in modules as well as
+those loaded by modprobe (from either early or normal userspace), and
+somewhat overlaps debug_query functionality.
+
+Modprobed modules get ddebug flags given on boot-line after those
+given via modprobe (either explicitly, or from /etc/modprobe.d/*).
+This can surprise if boot-line arg subtracts flags.
 
 Examples
 ========
@@ -290,3 +302,14 @@ nullarbor:~ # echo -n 'func svc_process -p' >
 // enable messages for NFS calls READ, READLINK, READDIR and READDIR+.
 nullarbor:~ # echo -n 'format "nfsd: READ" +p' >
 				<debugfs>/dynamic_debug/control
+
+// boot-args example, with newlines and comments
+Kernel command line: ... 
+  ddebug_query="func i2c_del_adapter +p; func tboot_probe +p"
+  dynamic_debug.verbose=1 		// see whats going on
+  nouveau.dyndbg 			// implicit =+p
+  tsc_sync.dyndbg=+p 			// builtin on my kernel
+  i2c_core.dyndbg=+p			// loaded by udev
+  *.dyndbg="=_"				// wildcard applies to builtins
+  k10temp.dyndbg="+p # comment in query is stripped "
+  pnp.dyndbg="func pnpacpi_get_resources +p; func pnp_assign_mem +p" # multi
diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index d6f5b5c..29b57e5 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -47,7 +47,6 @@ extern int ddebug_remove_module(const char *mod_name);
 extern __printf(2, 3)
 int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...);
 
-extern int ddebug_exec_query(char *query_string);
 extern void ddebug_module_parse_args(const char *name, char* args,
 				struct kernel_param *params, unsigned num);
 
@@ -105,15 +104,11 @@ static inline int ddebug_remove_module(const char *mod)
 {
 	return 0;
 }
-static inline int ddebug_exec_query(char *query_string)
-{
-	return 0;
-}
+
 static inline void ddebug_module_parse_args(const char *name, char* args,
 					struct kernel_param *params,
 					unsigned num)
 {
-	return 0;
 }
 
 #define dynamic_pr_debug(fmt, ...)					\
diff --git a/kernel/params.c b/kernel/params.c
index 313ea84..010f167 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -116,12 +116,12 @@ static int parse_one(char *param,
 	}
 
 	/*
-	 * Ignore ddebug module params and module.ddebug boot params:
+	 * Ignore ddebug module params and module.dyndbg boot params:
 	 * Documentation/dynamic-debug-howto.txt
 	 */
-	tmp = strstr(param, ".ddebug");
-	if (parameq(param, "ddebug") || (tmp && strlen(tmp) == 7)) {
-		DEBUGP("Ignoring ddebug parameter %s\n", param);
+	tmp = strstr(param, ".dyndbg");
+	if (parameq(param, "dyndbg") || (tmp && strlen(tmp) == 7)) {
+		pr_debug("Ignoring ddebug parameter %s\n", param);
 		return 0;
 	}
 
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index bb66251..afc9bd3 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -449,7 +449,7 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 	return 0;
 }
 
-int ddebug_exec_query(char *query_string)
+static int ddebug_exec_query(char *query_string)
 {
 	unsigned int flags = 0, mask = 0;
 	struct ddebug_query query;
@@ -458,7 +458,7 @@ int ddebug_exec_query(char *query_string)
 	char *words[MAXWORDS];
 
 	if (verbose)
-		printk(KERN_INFO "%s: got query: %s\n", __func__, query_string);
+		pr_info("got query: %s\n", query_string);
 
 	nwords = ddebug_tokenize(query_string, words, MAXWORDS);
 	if (nwords <= 0)
@@ -879,53 +879,55 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 EXPORT_SYMBOL_GPL(ddebug_add_module);
 
 /* We search for *ddebug* module params */
-void ddebug_module_parse_args(const char *name, char* args,
+void ddebug_module_parse_args(const char *modname, char* modargs,
 			      struct kernel_param *params, unsigned num)
 {
 	char ddebug[DDEBUG_STRING_SIZE], *param, *val, *args_it, *arg_dup_ptr;
 	int i;
 
+	if (!modargs || !*modargs)
+		return; /* no args, return now, avoid pr_infos */
 	/*
 	 * We must not modify the passed args string and need to store the
 	 * kstrdup pointer to be able to free memory later, TBD: find a way
 	 * to do this nicer
 	 */
-	arg_dup_ptr = args_it = kstrdup(args, GFP_KERNEL);
+	arg_dup_ptr = args_it = kstrdup(modargs, GFP_KERNEL);
+	args_it = skip_spaces(args_it);
 
 	if (verbose)
-		printk(KERN_INFO "%s: Parsing ARGS: -%s- of %s\n",
-		       __func__, args_it, name);
+		pr_info("%s ARGS: %s\n", modname, args_it);
 
+	/* warn if modules declare ddebug param - todo BUILD_BUG ?? */
 	for (i = 0; i < num; i++) {
 		if (!strcmp("ddebug", params[i].name))
 			pr_warning("Module %s uses reserved keyword "
-				   "*ddebug* as parameter\n", name);
+				   "*ddebug* as parameter\n", modname);
 	}
 
-	/* Chew leading spaces */
-	args_it = skip_spaces(args_it);
-
 	while (*args_it) {
 		args_it = next_arg(args_it, &param, &val);
+		if (strcmp(param, "dyndbg"))
+			continue;
+		pr_info("Enabling debugging for module %s\n", modname);
 		if (verbose)
-			printk(KERN_INFO "%s: Param: %s, val: %s\n",
-			       __func__, param, val);
-		if (!strcmp(param, "ddebug")) {
-			pr_info("Enabling debugging for module %s\n", name);
-			snprintf(ddebug, DDEBUG_STRING_SIZE, "module %s +p",
-				 name);
-			ddebug_exec_query(ddebug);
-		}
+			pr_info("Param: %s, val: %s\n", param, val);
+
+		snprintf(ddebug, DDEBUG_STRING_SIZE, "module %s +p", modname);
+		ddebug_exec_queries(ddebug);
 	}
 	kfree(arg_dup_ptr);
 	if (verbose)
-		printk(KERN_INFO "%s: Finished %s parsing\n",  __func__, name);
+		pr_info("Finished %s parsing\n", modname);
 }
-/* We search for module.ddebug kernel boot params */
-static void ddebug_boot_parse_args(void)
+
+char __initdata tmp_cmd_arr[COMMAND_LINE_SIZE];
+char __initdata module[MODULE_NAME_LEN], ddebug[DDEBUG_STRING_SIZE];
+
+/* We search for module.dyndbg kernel boot params */
+static __init void ddebug_boot_parse_args(void)
 {
-	char tmp_cmd_arr[COMMAND_LINE_SIZE], *tmp_cmd_ptr, *param, *val, *tmp;
-	char module[MODULE_NAME_LEN], ddebug[DDEBUG_STRING_SIZE];
+	char *tmp_cmd_ptr, *param, *val, *tmp;
 
 	/* next_arg touches the passed buffer and chops each argument */
 	strlcpy(tmp_cmd_arr, saved_command_line, COMMAND_LINE_SIZE);
@@ -934,17 +936,16 @@ static void ddebug_boot_parse_args(void)
 
 	while (*tmp_cmd_ptr) {
 		tmp_cmd_ptr = next_arg(tmp_cmd_ptr, &param, &val);
+		tmp = strstr(param, ".dyndbg");
+		if (!tmp || strlen(tmp) != 7)
+			continue;
+		strlcpy(module, param, tmp - param + 1);
+		pr_info("Enabling debugging for module %s\n", module);
 		if (verbose)
-			printk(KERN_INFO "%s: Param: %s, val: %s\n",
-			       __func__, param, val);
-		tmp = strstr(param, ".ddebug");
-		if (tmp && strlen(tmp) == 7) {
-			strlcpy(module, param, tmp - param + 1);
-			pr_info("Enabling debugging for module %s\n", module);
-			snprintf(ddebug, DDEBUG_STRING_SIZE, "module %s +p",
-				 module);
-			ddebug_exec_query(ddebug);
-		}
+			pr_info("Param: %s, val: %s\n", param, val);
+
+		snprintf(ddebug, DDEBUG_STRING_SIZE, "module %s +p", module);
+		ddebug_exec_queries(ddebug);
 	}
 }
 
-- 
1.7.7.3

