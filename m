Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab1LFTNB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:13:01 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51011 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab1LFTM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:12:57 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>,
        Thomas Renninger <trenn@suse.de>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 18/25] dynamic_debug: Introduce global fake module param $module.dyndbg
Date: Tue,  6 Dec 2011 12:11:28 -0700
Message-Id: <1323198694-7186-19-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>, <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
 <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Rework Thomas Renninger's $module.ddebug boot-time debugging feature,
from https://lkml.org/lkml/2010/9/15/397

Extend dynamic-debug facility to work during module initialization:

  foo.dyndbg bar.dyndbg="$bar-query-string"

This patch introduces a 'fake' module parameter: $module.ddebug for
all modules.  It is not explicitly added to each module, but is
implemented as an unknown-parameter callback invoked by kernel/param's
parse_one(), and it applies each module's query-string as if it were
written to the $DBGFS/dynamic_debug/control file.

The module-name is added to the unknown-parameter callback signature
and to its caller: parse_one().  This lets the common callback know
what module its handling a common parameter for.

If no value is given (as in foo.dyndbg example above), "+p" is
assumed, which enables all pr_debug callsites in the module.

The parameter is not shown in /sys/module/*/parameters, thus it does
not use any resources.  Changes to the parameter are made via the
control file.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
CC: Thomas Renninger <trenn@suse.de>
CC: Rusty Russell <rusty@rustcorp.com.au>
---
 Documentation/dynamic-debug-howto.txt |   52 ++++++++++++++++++++++++++++++++-
 include/linux/dynamic_debug.h         |   11 +++++++
 include/linux/moduleparam.h           |    2 +-
 init/main.c                           |    7 ++--
 kernel/module.c                       |    3 +-
 kernel/params.c                       |   10 ++++--
 lib/dynamic_debug.c                   |   16 +++++++++-
 7 files changed, 89 insertions(+), 12 deletions(-)

diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
index 989a892..56e496a 100644
--- a/Documentation/dynamic-debug-howto.txt
+++ b/Documentation/dynamic-debug-howto.txt
@@ -219,7 +219,7 @@ Note also that there is no convenient syntax to remove all
 the flags at once, you need to use "-flmpt".
 
 
-Debug messages during boot process
+Debug messages during Boot Process
 ==================================
 
 To be able to activate debug messages during the boot process,
@@ -238,6 +238,45 @@ PCI (or other devices) initialization also is a hot candidate for using
 this boot parameter for debugging purposes.
 
 
+Debug Messages at Module Initialization Time
+============================================
+
+Enabling a module's debug messages via debug control file only works
+once the module is loaded; too late for callsites in init functions.
+And when module is unloaded, debug flag settings for the module are
+lost.  Instead, a "dyndbg" module parameter can be passed:
+
+	- via kernel boot parameter: (this form works on built-ins too)
+	  module.dyndbg=+mfp
+	  module.dyndbg	# defaults to +p
+
+	- as an ordinary module parameter via modprobe
+	  modprobe module dyndbg=+pmfl
+	  modprobe module dyndbg # defaults to +p
+
+	- or the parameter can be used permanently via modprobe.conf(.local)
+	  options module dyndbg=+pmflt
+	  options module dyndbg # defaults to +p
+
+The $modname.dyndbg="value" should exclude "module $modname", as the
+$modname is taken from the param-name, and only 1 spec of each type is
+allowed.
+
+The dyndbg option is not implemented as an ordinary module parameter
+and thus will not show up in /sys/module/module_name/parameters/dyndbg
+The settings can be reverted later via the sysfs interface if the
+debug messages are no longer needed:
+
+      echo "module module_name -p" > <debugfs>/dynamic_debug/control
+
+$module.dyndbg="..." on boot-line works on built-in modules as well as
+those loaded by modprobe (from either early or normal userspace), and
+somewhat overlaps debug_query functionality.
+
+Modprobed modules get dyndbg flags given on boot-line after those
+given via modprobe (either explicitly, or from /etc/modprobe.d/*).
+This can surprise if boot-line arg subtracts flags.
+
 Examples
 ========
 
@@ -264,3 +303,14 @@ nullarbor:~ # echo -n 'func svc_process -p' >
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
index 7e3c53a..b77f43b 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -39,11 +39,16 @@ struct _ddebug {
 int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 				const char *modname);
 
+struct kernel_param;
+
 #if defined(CONFIG_DYNAMIC_DEBUG)
 extern int ddebug_remove_module(const char *mod_name);
+
 extern __printf(2, 3)
 int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...);
 
+extern int ddebug_dyndbg_param_cb(char *param, char *val, const char *modname);
+
 struct device;
 
 extern __printf(3, 4)
@@ -99,6 +104,12 @@ static inline int ddebug_remove_module(const char *mod)
 	return 0;
 }
 
+static inline int ddebug_dyndbg_param_cb(char *param, char *val, const char *modname)
+{
+	pr_warn("dyndbg supported only in CONFIG_DYNAMIC_DEBUG builds\n");
+	return 0; /* dont fail modprobe, warning is enough */
+}
+
 #define dynamic_pr_debug(fmt, ...)					\
 	do { if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); } while (0)
 #define dynamic_dev_dbg(dev, fmt, ...)					\
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 7939f63..91bd56a 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -292,7 +292,7 @@ extern int parse_args(const char *name,
 		      char *args,
 		      const struct kernel_param *params,
 		      unsigned num,
-		      int (*unknown)(char *param, char *val));
+		      int (*unknown)(char *param, char *val, const char *modname));
 
 /* Called by module remove. */
 #ifdef CONFIG_SYSFS
diff --git a/init/main.c b/init/main.c
index 217ed23..4a591ec 100644
--- a/init/main.c
+++ b/init/main.c
@@ -230,7 +230,7 @@ early_param("loglevel", loglevel);
  * Unknown boot options get handed to init, unless they look like
  * unused parameters (modprobe will find them in /proc/cmdline).
  */
-static int __init unknown_bootoption(char *param, char *val)
+static int __init unknown_bootoption(char *param, char *val, const char *modname)
 {
 	/* Change NUL term back to "=", to make "param" the whole string. */
 	if (val) {
@@ -387,7 +387,7 @@ static noinline void __init_refok rest_init(void)
 }
 
 /* Check for early params. */
-static int __init do_early_param(char *param, char *val)
+static int __init do_early_param(char *param, char *val, const char *modname)
 {
 	const struct obs_kernel_param *p;
 
@@ -510,8 +510,7 @@ asmlinkage void __init start_kernel(void)
 	printk(KERN_NOTICE "Kernel command line: %s\n", boot_command_line);
 	parse_early_param();
 	parse_args("Booting kernel", static_command_line, __start___param,
-		   __stop___param - __start___param,
-		   &unknown_bootoption);
+		   __stop___param - __start___param, &unknown_bootoption);
 
 	jump_label_init();
 
diff --git a/kernel/module.c b/kernel/module.c
index 30ffed4..c7b495e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2893,7 +2893,8 @@ static struct module *load_module(void __user *umod,
 	mutex_unlock(&module_mutex);
 
 	/* Module is ready to execute: parsing args may do that. */
-	err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp, NULL);
+	err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp,
+			 ddebug_dyndbg_param_cb);
 	if (err < 0)
 		goto unlink;
 
diff --git a/kernel/params.c b/kernel/params.c
index 65aae11..70a9878 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -92,9 +92,11 @@ bool parameq(const char *a, const char *b)
 
 static int parse_one(char *param,
 		     char *val,
+		     const char *modname,
 		     const struct kernel_param *params,
 		     unsigned num_params,
-		     int (*handle_unknown)(char *param, char *val))
+		     int (*handle_unknown)(char *param, char *val,
+					   const char *modname))
 {
 	unsigned int i;
 	int err;
@@ -116,7 +118,7 @@ static int parse_one(char *param,
 
 	if (handle_unknown) {
 		DEBUGP("Unknown argument: calling %p\n", handle_unknown);
-		return handle_unknown(param, val);
+		return handle_unknown(param, val, modname);
 	}
 
 	DEBUGP("Unknown argument `%s'\n", param);
@@ -180,7 +182,7 @@ int parse_args(const char *name,
 	       char *args,
 	       const struct kernel_param *params,
 	       unsigned num,
-	       int (*unknown)(char *param, char *val))
+	       int (*unknown)(char *param, char *val, const char *modname))
 {
 	char *param, *val;
 
@@ -195,7 +197,7 @@ int parse_args(const char *name,
 
 		args = next_arg(args, &param, &val);
 		irq_was_disabled = irqs_disabled();
-		ret = parse_one(param, val, params, num, unknown);
+		ret = parse_one(param, val, name, params, num, unknown);
 		if (irq_was_disabled && !irqs_disabled()) {
 			printk(KERN_WARNING "parse_args(): option '%s' enabled "
 					"irq's!\n", param);
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 516ad4e..b774849 100644
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
@@ -872,6 +872,20 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 }
 EXPORT_SYMBOL_GPL(ddebug_add_module);
 
+int ddebug_dyndbg_param_cb(char *param, char* val, const char* modname)
+{
+	if (strcmp(param, "dyndbg")) {
+		pr_warn("bogus param %s=%s received for %s\n",
+			param, val, modname);
+		return -EINVAL;
+	}
+	if (verbose)
+		pr_info("module: %s %s=\"%s\"\n", modname, param, val);
+
+	ddebug_exec_queries((val ? val : "+p"));
+	return 0; /* query failure shouldnt stop module load */
+}
+
 static void ddebug_table_free(struct ddebug_table *dt)
 {
 	list_del_init(&dt->link);
-- 
1.7.7.3

