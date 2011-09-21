Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab1IUV4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:56:24 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:36106 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab1IUV4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:56:21 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: joe@perches.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 14/26] dynamic_debug: refactor query_matches_callsite out of ddebug_change
Date: Wed, 21 Sep 2011 15:55:03 -0600
Message-Id: <1316642115-20029-15-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

This makes no behavioral change, its just a code-move/refactor
to encapsulate matching behavior.

If this function is reused, note that it excludes check of the module;
that is done once for the table, this code refactors the test inside
the loop over the module's ddebug callsites.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   54 +++++++++++++++++++++++++++++---------------------
 1 files changed, 31 insertions(+), 23 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 2f39b2f..329e18d 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -125,6 +125,36 @@ do {									\
 			q->first_lineno, q->last_lineno);		\
 } while (0)
 
+static bool query_matches_callsite(struct _ddebug *dp,
+				const struct ddebug_query *query)
+{
+	/* match against the source filename */
+	if (query->filename != NULL &&
+		strcmp(query->filename, dp->filename) &&
+		strcmp(query->filename, basename(dp->filename)) &&
+		strcmp(query->filename, trim_prefix(dp->filename)))
+		return false;
+
+	/* match against the function */
+	if (query->function != NULL &&
+		strcmp(query->function, dp->function))
+		return false;
+
+	/* match against the format */
+	if (query->format != NULL &&
+		strstr(dp->format, query->format) == NULL)
+		return false;
+
+	/* match against the line number range */
+	if (query->first_lineno && dp->lineno < query->first_lineno)
+		return false;
+
+	if (query->last_lineno && dp->lineno > query->last_lineno)
+		return false;
+
+	return true;
+}
+
 /*
  * Search the tables for _ddebug's which match the given
  * `query' and apply the `flags' and `mask' to them.  Tells
@@ -151,29 +181,7 @@ static void ddebug_change(const struct ddebug_query *query,
 		for (i = 0 ; i < dt->num_ddebugs ; i++) {
 			struct _ddebug *dp = &dt->ddebugs[i];
 
-			/* match against the source filename */
-			if (query->filename != NULL &&
-			    strcmp(query->filename, dp->filename) &&
-			    strcmp(query->filename, basename(dp->filename)) &&
-			    strcmp(query->filename, trim_prefix(dp->filename)))
-				continue;
-
-			/* match against the function */
-			if (query->function != NULL &&
-			    strcmp(query->function, dp->function))
-				continue;
-
-			/* match against the format */
-			if (query->format != NULL &&
-			    strstr(dp->format, query->format) == NULL)
-				continue;
-
-			/* match against the line number range */
-			if (query->first_lineno &&
-			    dp->lineno < query->first_lineno)
-				continue;
-			if (query->last_lineno &&
-			    dp->lineno > query->last_lineno)
+			if (!query_matches_callsite(dp, query))
 				continue;
 
 			nfound++;
-- 
1.7.4.4

