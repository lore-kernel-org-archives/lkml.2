Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab2CYX1L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 19:27:11 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61995 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373Ab2CYX0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 19:26:24 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 09/16] dynamic_debug: combine parse_args callbacks together
Date: Sun, 25 Mar 2012 17:25:47 -0600
Message-Id: <1332717954-5775-10-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332717954-5775-1-git-send-email-jim.cromie@gmail.com>
References: <1332717954-5775-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Refactor ddebug_dyndbg_boot_param_cb and ddebug_dyndbg_module_param_cb
into a common helper function, and call it from both.  The handling of
foo.dyndbg is unneeded by the latter, but harmless.  The 2 callers
differ only by pr_info and the return code they pass to the helper for
when an unknown param is handled.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   36 ++++++++++++++++++++----------------
 1 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index a3ab3bd..baff763 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -862,39 +862,43 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 }
 EXPORT_SYMBOL_GPL(ddebug_add_module);
 
-/* handle both dyndbg=".." and $module.dyndbg=".." params at boot */
-static int ddebug_dyndbg_boot_param_cb(char *param, char *val,
-				const char *unused)
+/* helper for ddebug_dyndbg_(boot|module)_param_cb */
+static int ddebug_dyndbg_param_cb(char *param, char *val,
+				const char *modname, int on_err)
 {
-	const char *modname = NULL;
 	char *sep;
 
 	sep = strchr(param, '.');
 	if (sep) {
+		/* needed only for ddebug_dyndbg_boot_param_cb */
 		*sep = '\0';
 		modname = param;
 		param = sep + 1;
 	}
 	if (strcmp(param, "dyndbg"))
-		return 0; /* skip all other params w/o error */
-
-	vpr_info("module: %s %s=\"%s\"\n", modname, param, val);
+		return on_err; /* determined by caller */
 
 	ddebug_exec_queries(val ? val : "+p");
 	return 0; /* query failure shouldnt stop module load */
 }
 
-/* handle dyndbg args to modprobe */
-int ddebug_dyndbg_module_param_cb(char *param, char *val, const char *doing)
+/* handle both dyndbg and $module.dyndbg params at boot */
+static int ddebug_dyndbg_boot_param_cb(char *param, char *val,
+				const char *unused)
 {
-	if (strcmp(param, "dyndbg"))
-		return -ENOENT;
-
-	vpr_info("module: %s %s=\"%s\"\n", doing, param, val);
-
-	ddebug_exec_queries((val ? val : "+p"), doing);
+	vpr_info("%s=\"%s\"\n", param, val);
+	return ddebug_dyndbg_param_cb(param, val, NULL, 0);
+}
 
-	return 0; /* query failure shouldnt stop module load */
+/*
+ * modprobe foo finds foo.params in boot-args, strips "foo.", and
+ * passes them to load_module().  This callback gets unknown params,
+ * processes dyndbg params, rejects others.
+ */
+int ddebug_dyndbg_module_param_cb(char *param, char *val, const char *module)
+{
+	vpr_info("module: %s %s=\"%s\"\n", module, param, val);
+	return ddebug_dyndbg_param_cb(param, val, module, -ENOENT);
 }
 
 static void ddebug_table_free(struct ddebug_table *dt)
-- 
1.7.7.6

