Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab1IUV7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:59:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33832 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab1IUV4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:56:13 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: joe@perches.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 11/26] dynamic_debug: hoist locking in ddebug_change to callers
Date: Wed, 21 Sep 2011 15:55:00 -0600
Message-Id: <1316642115-20029-12-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Hoist locking out of ddebug_change() into ddebug_exec_queries().
This reduces lock fiddling, but will increase hold-times slightly,
at least when many queries are submitted.

With verbose off, on a 266 MHz, takes, I get a reasonable:

 #> time cat query-file-w-300-pending-queries > $CONTROL
 real	0m0.508s
 user	0m0.009s
 sys	0m0.290s

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 2b3393f..0676de0 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -113,7 +113,7 @@ static char *ddebug_describe_flags(struct _ddebug *dp, char *buf,
  * Search the tables for _ddebug's which match the given
  * `query' and apply the `flags' and `mask' to them.  Tells
  * the user which ddebug's were changed, or whether none
- * were matched.
+ * were matched.  Called with ddebug_lock held.
  */
 static void ddebug_change(const struct ddebug_query *query,
 			   unsigned int flags, unsigned int mask)
@@ -125,7 +125,6 @@ static void ddebug_change(const struct ddebug_query *query,
 	char flagbuf[8];
 
 	/* search for matching ddebugs */
-	mutex_lock(&ddebug_lock);
 	list_for_each_entry(dt, &ddebug_tables, link) {
 
 		/* match against the module name */
@@ -175,8 +174,6 @@ static void ddebug_change(const struct ddebug_query *query,
 							sizeof(flagbuf)));
 		}
 	}
-	mutex_unlock(&ddebug_lock);
-
 	if (!nfound && verbose)
 		pr_info("no matches for query\n");
 }
@@ -450,6 +447,7 @@ static int ddebug_exec_queries(char *query)
 	char *split;
 	int i, errs = 0, exitcode = 0, rc;
 
+	mutex_lock(&ddebug_lock);
 	for (i = 0; query; query = split) {
 		split = strpbrk(query, ";\n");
 		if (split)
@@ -468,6 +466,7 @@ static int ddebug_exec_queries(char *query)
 		}
 		i++;
 	}
+	mutex_unlock(&ddebug_lock);
 	pr_info("processed %d queries, with %d errs\n", i, errs);
 
 	return exitcode;
-- 
1.7.4.4

