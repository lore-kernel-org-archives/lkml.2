Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab1GYVnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:43:45 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37386 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab1GYVni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:43:38 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: bvanassche@acm.org, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 14/25] dynamic_debug: refactor query_matches_callsite out of ddebug_change
Date: Mon, 25 Jul 2011 15:42:39 -0600
Message-Id: <1311630170-26057-15-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes no behavioral change, its just a code-move.  Originally
done cuz it looked momentarily to be useful in the query-vs-query
check needed soon.

If this function is reused, note that it excludes check of the module;
that is done once for the table, this code refactors the test inside
the loop over the module's ddebug callsites.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   52 +++++++++++++++++++++++++++++---------------------
 1 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 7e4f919..c0a5d20 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -143,6 +143,35 @@ static char *show_pending_query(struct pending_query *pq)
 	return p;
 }
 
+static bool query_matches_callsite(struct _ddebug *dp,
+				const struct ddebug_query *query)
+{
+	/* match against the source filename */
+	if (query->filename != NULL &&
+		strcmp(query->filename, dp->filename) &&
+		strcmp(query->filename, basename(dp->filename)))
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
@@ -170,28 +199,7 @@ static int ddebug_change(const struct ddebug_query *query,
 		for (i = 0 ; i < dt->num_ddebugs ; i++) {
 			struct _ddebug *dp = &dt->ddebugs[i];
 
-			/* match against the source filename */
-			if (query->filename != NULL &&
-			    strcmp(query->filename, dp->filename) &&
-			    strcmp(query->filename, basename(dp->filename)))
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
1.7.4.1

