Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab1GKHuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 03:50:12 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33546 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218Ab1GKHrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 03:47:33 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, bvanassche@acm.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 11/21] dynamic_debug: refactor query_matches_callsite out of ddebug_change
Date: Mon, 11 Jul 2011 01:46:46 -0600
Message-Id: <1310370416-6322-12-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this makes no behavioral change, its just a code-move.
Originally done cuz it looked momentarily to be related to
query-vs-query check needed soon.

If this function is reused, note that it excludes check of the module;
that is done once for the table, this code refactors the test inside
the loop over the module's ddebug callsites.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   52 +++++++++++++++++++++++++++++---------------------
 1 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index cc8e157..bee1376 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -134,6 +134,35 @@ static char *show_pending_query(struct pending_query *pq)
 	return prbuf_query;
 }
 
+static int query_matches_callsite(struct _ddebug *dp,
+				const struct ddebug_query *query)
+{
+	/* match against the source filename */
+	if (query->filename != NULL &&
+		strcmp(query->filename, dp->filename) &&
+		strcmp(query->filename, basename(dp->filename)))
+		return 0;
+
+	/* match against the function */
+	if (query->function != NULL &&
+		strcmp(query->function, dp->function))
+		return 0;
+
+	/* match against the format */
+	if (query->format != NULL &&
+		strstr(dp->format, query->format) == NULL)
+		return 0;
+
+	/* match against the line number range */
+	if (query->first_lineno && dp->lineno < query->first_lineno)
+		return 0;
+
+	if (query->last_lineno && dp->lineno > query->last_lineno)
+		return 0;
+
+	return 1;
+}
+
 /*
  * Search the tables for _ddebug's which match the given
  * `query' and apply the `flags' and `mask' to them.  Tells
@@ -161,28 +190,7 @@ static int ddebug_change(const struct ddebug_query *query,
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

