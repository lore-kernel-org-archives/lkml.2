Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab1IUV4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:56:47 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62277 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab1IUV4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:56:42 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: joe@perches.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 22/26] dynamic_debug: early return if _ddebug table is empty
Date: Wed, 21 Sep 2011 15:55:11 -0600
Message-Id: <1316642115-20029-23-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

if _ddebug table is empty (which shouldn't happen in a CONFIG_DYNAMIC_DEBUG
build), then warn (BUILD_BUG??) and return early.  This skips empty
table scan and parsing of setup-string, including the pr_info call
noting the parse.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 80b5322..1a8941e 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -1272,23 +1272,25 @@ static int __init dynamic_debug_init(void)
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
+		pr_warn("_ddebug table is empty in a CONFIG_DYNAMIC_DEBUG build");
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
 
 	/* ddebug_query boot param got passed -> set it up */
 	if (ddebug_setup_string[0] != '\0') {
-- 
1.7.4.4

