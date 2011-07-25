Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab1GYVoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:44:55 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:46811 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab1GYVnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:43:52 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: bvanassche@acm.org, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 22/25] dynamic_debug: call ddebug_add_module() on dynamic_debug first.
Date: Mon, 25 Jul 2011 15:42:47 -0600
Message-Id: <1311630170-26057-23-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In dynamic_debug_init(), find the dynamic-debug entries in the debug
section, and call ddebug_add_module on those entries 1st, before
doing all the others.  Doing this activates debug callsites in
dynamic_debug before the functions they're part of are used to
process other modules, making them useful for debugging debug
queries on those modules.  Without this, the debuggability of
queries depends upon whether the module is before or after
dynamic-debug in the __verbose data, ie link order.

Finding the dynamic-debug entries effectively splits the __verbose
data in 2; 1st we mark the found spot and process mark to end
(which starts with dynamic-debug entries), then process start to mark.
Refactor the block-finding code into dynamic_debug_init_helper(),
then call it on the 2 halves of the __verbose data.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   53 ++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 5ec8165..6dbefb7 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -1068,29 +1068,52 @@ static int __init dynamic_debug_init_debugfs(void)
 	return 0;
 }
 
+static int __init dynamic_debug_init_helper(struct _ddebug *start,
+					struct _ddebug *end)
+{
+	struct _ddebug *iter, *block;
+	const char *modname = start->modname;
+	int ret, n = 0;
+
+	for (block = iter = start; iter < end; iter++) {
+		if (strcmp(modname, iter->modname)) {
+			ret = ddebug_add_module(block, n, modname);
+			if (ret)
+				return ret;
+			n = 0;
+			modname = iter->modname;
+			block = iter;
+		}
+		n++;
+	}
+	return ddebug_add_module(block, n, modname);
+}
+
 static int __init dynamic_debug_init(void)
 {
-	struct _ddebug *iter, *iter_start;
+	struct _ddebug *iter;
 	const char *modname = NULL;
 	int ret = 0;
-	int n = 0;
 
 	if (__start___verbose != __stop___verbose) {
+		/* find and process dynamic_debug entries 1st
+		   this might allow activating ddebug_add_module callsites
+		   prior to their use processing other modules. TBI
+		*/
 		iter = __start___verbose;
 		modname = iter->modname;
-		iter_start = iter;
-		for (; iter < __stop___verbose; iter++) {
-			if (strcmp(modname, iter->modname)) {
-				ret = ddebug_add_module(iter_start, n, modname);
-				if (ret)
-					goto out_free;
-				n = 0;
-				modname = iter->modname;
-				iter_start = iter;
-			}
-			n++;
-		}
-		ret = ddebug_add_module(iter_start, n, modname);
+
+		for (; iter < __stop___verbose; iter++)
+			if (!strcmp("dynamic_debug", iter->modname))
+				break;
+
+		ret = dynamic_debug_init_helper(iter, __stop___verbose);
+		if (ret)
+			goto out_free;
+
+		ret = dynamic_debug_init_helper(__start___verbose, iter);
+		if (ret)
+			goto out_free;
 	}
 
 	/* ddebug_query boot param got passed -> set it up */
-- 
1.7.4.1

