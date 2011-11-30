Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab1K3UBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 15:01:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56503 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab1K3T5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 14:57:46 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 11/25] dynamic_debug: early return if _ddebug table is empty
Date: Wed, 30 Nov 2011 12:56:40 -0700
Message-Id: <1322683014-13285-12-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com>
References: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Iif _ddebug table is empty (in a CONFIG_DYNAMIC_DEBUG build this
shouldn't happen), then warn (error?) and return early.  This skips
empty table scan and parsing of setup-string, including the pr_info
call noting the parse.  By inspection, copy return-code handling from
1st ddebug_add_module() callsite to 2nd.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   35 ++++++++++++++++++++---------------
 1 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index f133e03..aaa29dc 100644
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

