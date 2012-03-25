Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479Ab2CYX1E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 19:27:04 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64965 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab2CYX0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 19:26:20 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 06/16] params: add 3rd arg to option handler callback signature
Date: Sun, 25 Mar 2012 17:25:44 -0600
Message-Id: <1332717954-5775-7-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332717954-5775-1-git-send-email-jim.cromie@gmail.com>
References: <1332717954-5775-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Add a 3rd arg, named "doing", to unknown-options callbacks invoked
from parse_args(). The arg is passed as:

  "Booting kernel" from start_kernel(),
  initcall_level_names[i] from do_initcall_level(),
  mod->name from load_module(), via parse_args(), parse_one()

parse_args() already has the "name" parameter, which is renamed to
"doing" to better reflect current uses 1,2 above.  parse_args() passes
it to an altered parse_one(), which now passes it down into the
unknown option handler callbacks.

The mod->name is needed for loadable modules, since params passed
there are not qualified (they do not have a "$modname." prefix),
and by the time the unknown-param callback is called, the module
name is not otherwize available.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 include/linux/moduleparam.h |    3 ++-
 init/main.c                 |    8 +++++---
 kernel/params.c             |   22 ++++++++++++----------
 3 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index ea36486..1b14d25 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -320,7 +320,8 @@ extern int parse_args(const char *name,
 		      unsigned num,
 		      s16 level_min,
 		      s16 level_max,
-		      int (*unknown)(char *param, char *val));
+		      int (*unknown)(char *param, char *val,
+			      const char *doing));
 
 /* Called by module remove. */
 #ifdef CONFIG_SYSFS
diff --git a/init/main.c b/init/main.c
index 09f3105..f454e6a 100644
--- a/init/main.c
+++ b/init/main.c
@@ -230,7 +230,8 @@ early_param("loglevel", loglevel);
  * Unknown boot options get handed to init, unless they look like
  * unused parameters (modprobe will find them in /proc/cmdline).
  */
-static int __init unknown_bootoption(char *param, char *val)
+static int __init unknown_bootoption(char *param, char *val,
+				const char *unused)
 {
 	/* Change NUL term back to "=", to make "param" the whole string. */
 	if (val) {
@@ -380,7 +381,7 @@ static noinline void __init_refok rest_init(void)
 }
 
 /* Check for early params. */
-static int __init do_early_param(char *param, char *val)
+static int __init do_early_param(char *param, char *val, const char *unused)
 {
 	const struct obs_kernel_param *p;
 
@@ -733,7 +734,8 @@ static char *initcall_level_names[] __initdata = {
 	"late",
 };
 
-static int __init ignore_unknown_bootoption(char *param, char *val)
+static int __init ignore_unknown_bootoption(char *param, char *val,
+					const char *doing)
 {
 	return 0;
 }
diff --git a/kernel/params.c b/kernel/params.c
index 10eb451..be7cfe8 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -85,11 +85,13 @@ bool parameq(const char *a, const char *b)
 
 static int parse_one(char *param,
 		     char *val,
+		     const char *doing,
 		     const struct kernel_param *params,
 		     unsigned num_params,
 		     s16 min_level,
 		     s16 max_level,
-		     int (*handle_unknown)(char *param, char *val))
+		     int (*handle_unknown)(char *param, char *val,
+				     const char *doing))
 {
 	unsigned int i;
 	int err;
@@ -114,8 +116,8 @@ static int parse_one(char *param,
 	}
 
 	if (handle_unknown) {
-		pr_debug("Unknown argument: calling %p\n", handle_unknown);
-		return handle_unknown(param, val);
+		pr_debug("doing %s: %s = %s\n", doing, param, val);
+		return handle_unknown(param, val, doing);
 	}
 
 	pr_debug("Unknown argument `%s'\n", param);
@@ -175,17 +177,17 @@ static char *next_arg(char *args, char **param, char **val)
 }
 
 /* Args looks like "foo=bar,bar2 baz=fuz wiz". */
-int parse_args(const char *name,
+int parse_args(const char *doing,
 	       char *args,
 	       const struct kernel_param *params,
 	       unsigned num,
 	       s16 min_level,
 	       s16 max_level,
-	       int (*unknown)(char *param, char *val))
+	       int (*unknown)(char *param, char *val, const char *doing))
 {
 	char *param, *val;
 
-	pr_debug("Parsing ARGS: %s\n", args);
+	pr_debug("doing %s, parsing ARGS: %s\n", doing, args);
 
 	/* Chew leading spaces */
 	args = skip_spaces(args);
@@ -196,7 +198,7 @@ int parse_args(const char *name,
 
 		args = next_arg(args, &param, &val);
 		irq_was_disabled = irqs_disabled();
-		ret = parse_one(param, val, params, num,
+		ret = parse_one(param, val, doing, params, num,
 				min_level, max_level, unknown);
 		if (irq_was_disabled && !irqs_disabled()) {
 			printk(KERN_WARNING "parse_args(): option '%s' enabled "
@@ -205,19 +207,19 @@ int parse_args(const char *name,
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
-- 
1.7.7.6

