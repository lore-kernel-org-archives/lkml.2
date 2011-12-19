Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab1LSWNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 17:13:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262Ab1LSWNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 17:13:21 -0500
Date: Mon, 19 Dec 2011 17:13:16 -0500
From: Jason Baron <jbaron@redhat.com>
To: greg@kroah.com
Cc: jim.cromie@gmail.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org
Message-Id: <d3379e3504fcb51e666d85b0a7aef33f27e0c353.1324318997.git.jbaron@redhat.com>
In-Reply-To: <cover.1324318997.git.jbaron@redhat.com>
References: <cover.1324318997.git.jbaron@redhat.com>
Subject: [PATCH 15/16] dynamic_debug: factor vpr_info_dq out of ddebug_parse_query
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Factor pr_info(query) out of ddebug_parse_query, into pr_info_dq(),
for reuse later.  Also change the printed labels: file, func to agree
with the query-spec keywords accepted in the control file.  Pass ""
when string is null, to avoid "(null)" output from sprintf.  For
format print, use precision to skip last char, assuming its '\n', no
great harm if not, its a debug msg.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 lib/dynamic_debug.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index a5508a1..93fc5d5 100644
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

