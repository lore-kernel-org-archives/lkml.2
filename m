Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab2CYX1N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 19:27:13 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64965 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932375Ab2CYX0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 19:26:25 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 10/16] dynamic_debug: simplify dynamic_debug_init error exit
Date: Sun, 25 Mar 2012 17:25:48 -0600
Message-Id: <1332717954-5775-11-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332717954-5775-1-git-send-email-jim.cromie@gmail.com>
References: <1332717954-5775-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

We dont want errors while parsing ddebug_query to unload ddebug
tables, so set success after tables are loaded, and return 0 after
query parsing is done.

Simplify error handling code since its no longer used for success,
and change goto label to out_err to clarify this.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index baff763..5f0d31f 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -984,7 +984,7 @@ static int __init dynamic_debug_init(void)
 		if (strcmp(modname, iter->modname)) {
 			ret = ddebug_add_module(iter_start, n, modname);
 			if (ret)
-				goto out_free;
+				goto out_err;
 			n = 0;
 			modname = iter->modname;
 			iter_start = iter;
@@ -993,9 +993,11 @@ static int __init dynamic_debug_init(void)
 	}
 	ret = ddebug_add_module(iter_start, n, modname);
 	if (ret)
-		goto out_free;
+		goto out_err;
 
-	/* ddebug_query boot param got passed -> set it up */
+	ddebug_init_success = 1;
+
+	/* apply ddebug_query boot param, dont unload tables on err */
 	if (ddebug_setup_string[0] != '\0') {
 		pr_warn("ddebug_query param name is deprecated,"
 			" change it to dyndbg\n");
@@ -1005,9 +1007,6 @@ static int __init dynamic_debug_init(void)
 				ddebug_setup_string);
 		else
 			pr_info("%d changes by ddebug_query\n", ret);
-
-		/* keep tables even on ddebug_query parse error */
-		ret = 0;
 	}
 	/* now that ddebug tables are loaded, process all boot args
 	 * again to find and activate queries given in dyndbg params.
@@ -1021,12 +1020,10 @@ static int __init dynamic_debug_init(void)
 	parse_args("dyndbg params", cmdline, NULL,
 		   0, 0, 0, &ddebug_dyndbg_boot_param_cb);
 	kfree(cmdline);
+	return 0;
 
-out_free:
-	if (ret)
-		ddebug_remove_all_tables();
-	else
-		ddebug_init_success = 1;
+out_err:
+	ddebug_remove_all_tables();
 	return 0;
 }
 /* Allow early initialization for boot messages via boot param */
-- 
1.7.7.6

