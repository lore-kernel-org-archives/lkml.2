Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab1LLXQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:16:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42879 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab1LLXNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:13:36 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 16/25] dynamic_debug: factor vpr_info_dq out of ddebug_parse_query
Date: Mon, 12 Dec 2011 16:12:42 -0700
Message-Id: <1323731569-20644-16-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323731569-20644-1-git-send-email-jim.cromie@gmail.com>
References: <1323731569-20644-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Factor pr_info(query) out of ddebug_parse_query, into pr_info_dq(),
for reuse later.  Also change the printed labels: file, func to agree
with the query-spec keywords accepted in the control file.  Pass ""
when string is null, to avoid "(null)" output from sprintf.  For
format print, use precision to skip last char, assuming its '\n', no
great harm if not, its a debug msg,

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index cb078d4..1a0e9bd 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -107,6 +107,22 @@ static char *ddebug_describe_flags(struct _ddebug *dp, char *buf,
 	return buf;
 }
 
+#define vpr_info_dq(q, msg)						\
+do {									\
+	if (verbose)							\
+		/* trim last char off format print */			\
+		pr_info("%s: func=\"%s\" file=\"%s\" "			\
+			"module=\"%s\" format=\"%.*s\" "		\
+			"lineno=%u-%u",					\
+			msg,						\
+			q->function ? q->function : "",			\
+			q->filename ? q->filename : "",			\
+			q->module ? q->module : "",			\
+			(int)(q->format ? strlen(q->format) - 1 : 0),	\
+			q->format ? q->format : "",			\
+			q->first_lineno, q->last_lineno);		\
+} while (0)
+
 /*
  * Search the tables for _ddebug's which match the given
  * `query' and apply the `flags' and `mask' to them.  Tells
@@ -367,14 +383,7 @@ static int ddebug_parse_query(char *words[], int nwords,
 		if (rc)
 			return rc;
 	}
-
-	if (verbose)
-		pr_info("q->function=\"%s\" q->filename=\"%s\" "
-			"q->module=\"%s\" q->format=\"%s\" q->lineno=%u-%u\n",
-			query->function, query->filename,
-			query->module, query->format, query->first_lineno,
-			query->last_lineno);
-
+	vpr_info_dq(query, "parsed");
 	return 0;
 }
 
-- 
1.7.7.3

