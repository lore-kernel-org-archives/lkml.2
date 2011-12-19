Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab1LSWNE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 17:13:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050Ab1LSWM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 17:12:59 -0500
Date: Mon, 19 Dec 2011 17:12:54 -0500
From: Jason Baron <jbaron@redhat.com>
To: greg@kroah.com
Cc: jim.cromie@gmail.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org
Message-Id: <f10adb40a052e532996da95ce31d5e50573c7e69.1324318997.git.jbaron@redhat.com>
In-Reply-To: <cover.1324318997.git.jbaron@redhat.com>
References: <cover.1324318997.git.jbaron@redhat.com>
Subject: [PATCH 10/16] dynamic_debug: early return if _ddebug table is empty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

If _ddebug table is empty (in a CONFIG_DYNAMIC_DEBUG build this
shouldn't happen), then warn (error?) and return early.  This skips
empty table scan and parsing of setup-string, including the pr_info
call noting the parse.  By inspection, copy return-code handling from
1st ddebug_add_module() callsite to 2nd.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 lib/dynamic_debug.c |   35 ++++++++++++++++++++---------------
 1 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 5a7bacc..4be55d8 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -871,23 +871,28 @@ static int __init dynamic_debug_init(void)
 	int ret = 0;
 	int n = 0;
 
-	if (__start___verbose != __stop___verbose) {
-		iter = __start___verbose;
-		modname = iter->modname;
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
+	if (__start___verbose == __stop___verbose) {
+		pr_warn("_ddebug table is empty in a "
+			"CONFIG_DYNAMIC_DEBUG build");
+		return 1;
+	}
+	iter = __start___verbose;
+	modname = iter->modname;
+	iter_start = iter;
+	for (; iter < __stop___verbose; iter++) {
+		if (strcmp(modname, iter->modname)) {
+			ret = ddebug_add_module(iter_start, n, modname);
+			if (ret)
+				goto out_free;
+			n = 0;
+			modname = iter->modname;
+			iter_start = iter;
 		}
-		ret = ddebug_add_module(iter_start, n, modname);
+		n++;
 	}
+	ret = ddebug_add_module(iter_start, n, modname);
+	if (ret)
+		goto out_free;
 
 	/* ddebug_query boot param got passed -> set it up */
 	if (ddebug_setup_string[0] != '\0') {
-- 
1.7.7.3

