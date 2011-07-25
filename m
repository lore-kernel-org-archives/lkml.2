Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1GYVr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:47:27 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:46811 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab1GYVnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:43:32 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: bvanassche@acm.org, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 11/25] dynamic_debug: factor show_ddebug_query out of ddebug_parse_query
Date: Mon, 25 Jul 2011 15:42:36 -0600
Message-Id: <1311630170-26057-12-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor show_ddebug_query out of ddebug_parse_query.  Also change
the printed labels to agree with the query-spec keywords accepted in
the control file; file, func.  Pass "" when string is null,
to avoid "(null)" output from sprintf.

Code uses sprintf into a large buffer, kallocd and freed from
ddebug_exec_queries.  function has 1 caller now, will add more later.
Will also reuse the buffer and function for show_pending_query().
This is in lieu of char *p=kasprintf; free(p) everywhere the
function will be used.  TBD.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   30 ++++++++++++++++++++++++------
 1 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 1ced79e..5774a6f 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -96,6 +96,21 @@ static char *ddebug_describe_flags(struct _ddebug *dp, char *buf,
 	return buf;
 }
 
+static char *prbuf_query;
+
+static char *show_ddebug_query(const struct ddebug_query *q)
+{
+	char *p = kasprintf(GFP_KERNEL,
+			"func=\"%s\" file=\"%s\" "
+			"module=\"%s\" format=\"%s\" lineno=%u-%u",
+			q->function ? q->function : "",
+			q->filename ? q->filename : "",
+			q->module ? q->module : "",
+			q->format ? q->format : "",
+			q->first_lineno, q->last_lineno);
+	return p;
+}
+
 /*
  * Search the tables for _ddebug's which match the given
  * `query' and apply the `flags' and `mask' to them.  Tells
@@ -307,6 +322,7 @@ static int ddebug_parse_query(char *words[], int nwords,
 			       struct ddebug_query *query)
 {
 	unsigned int i;
+	char *qstr;
 
 	/* check we have an even number of words */
 	if (nwords % 2 != 0)
@@ -342,12 +358,9 @@ static int ddebug_parse_query(char *words[], int nwords,
 			return -EINVAL;
 		}
 	}
-
-	pr_debug("q->function=\"%s\" q->filename=\"%s\" "
-		"q->module=\"%s\" q->format=\"%s\" q->lineno=%u-%u\n",
-		query->function, query->filename,
-		query->module, query->format, query->first_lineno,
-		query->last_lineno);
+	qstr = show_ddebug_query(query);
+	pr_debug("parsed %s\n", qstr);
+	kfree(qstr);
 
 	return 0;
 }
@@ -435,6 +448,10 @@ static int ddebug_exec_queries(char *query)
 	char *split;
 	int i, errs = 0, exitcode = 0, rc;
 
+	prbuf_query = kmalloc(1024, GFP_KERNEL);
+	if (prbuf_query == NULL)
+		return -ENOMEM;
+
 	for (i = 0; query; query = split) {
 		split = strpbrk(query, ";\n");
 		if (split)
@@ -452,6 +469,7 @@ static int ddebug_exec_queries(char *query)
 		}
 		i++;
 	}
+	kfree(prbuf_query);
 	pr_debug("processed %d queries, with %d errs\n", i, errs);
 
 	return exitcode;
-- 
1.7.4.1

