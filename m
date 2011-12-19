Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1LSWNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 17:13:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab1LSWM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 17:12:57 -0500
Date: Mon, 19 Dec 2011 17:12:49 -0500
From: Jason Baron <jbaron@redhat.com>
To: greg@kroah.com
Cc: jim.cromie@gmail.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org
Message-Id: <01b746c156837251ab3977029d2252844c39d306.1324318997.git.jbaron@redhat.com>
In-Reply-To: <cover.1324318997.git.jbaron@redhat.com>
References: <cover.1324318997.git.jbaron@redhat.com>
Subject: [PATCH 09/16] dynamic_debug: tighten up error checking on debug queries
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Issue error when a match-spec is given multiple times in a rule.
Previous code kept last one, but was silent about it.  Docs imply only
one is allowed by saying match-specs are ANDed together, given that
module M cannot match both A and B.  Also error when last_line < 1st_line.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 lib/dynamic_debug.c |   39 +++++++++++++++++++++++++++++++++------
 1 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index cde4dfe..5a7bacc 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -276,6 +276,19 @@ static char *unescape(char *str)
 	return str;
 }
 
+static int check_set(const char **dest, char *src, char *name)
+{
+	int rc = 0;
+
+	if (*dest) {
+		rc = -EINVAL;
+		pr_err("match-spec:%s val:%s overridden by %s",
+			name, *dest, src);
+	}
+	*dest = src;
+	return rc;
+}
+
 /*
  * Parse words[] as a ddebug query specification, which is a series
  * of (keyword, value) pairs chosen from these possibilities:
@@ -287,11 +300,15 @@ static char *unescape(char *str)
  * format <escaped-string-to-find-in-format>
  * line <lineno>
  * line <first-lineno>-<last-lineno> // where either may be empty
+ *
+ * Only 1 of each type is allowed.
+ * Returns 0 on success, <0 on error.
  */
 static int ddebug_parse_query(char *words[], int nwords,
 			       struct ddebug_query *query)
 {
 	unsigned int i;
+	int rc;
 
 	/* check we have an even number of words */
 	if (nwords % 2 != 0)
@@ -300,24 +317,32 @@ static int ddebug_parse_query(char *words[], int nwords,
 
 	for (i = 0 ; i < nwords ; i += 2) {
 		if (!strcmp(words[i], "func"))
-			query->function = words[i+1];
+			rc = check_set(&query->function, words[i+1], "func");
 		else if (!strcmp(words[i], "file"))
-			query->filename = words[i+1];
+			rc = check_set(&query->filename, words[i+1], "file");
 		else if (!strcmp(words[i], "module"))
-			query->module = words[i+1];
+			rc = check_set(&query->module, words[i+1], "module");
 		else if (!strcmp(words[i], "format"))
-			query->format = unescape(words[i+1]);
+			rc = check_set(&query->format, unescape(words[i+1]),
+				"format");
 		else if (!strcmp(words[i], "line")) {
 			char *first = words[i+1];
 			char *last = strchr(first, '-');
+			if (query->first_lineno || query->last_lineno) {
+				pr_err("match-spec:line given 2 times\n");
+				return -EINVAL;
+			}
 			if (last)
 				*last++ = '\0';
 			if (parse_lineno(first, &query->first_lineno) < 0)
 				return -EINVAL;
-			if (last != NULL) {
+			if (last) {
 				/* range <first>-<last> */
-				if (parse_lineno(last, &query->last_lineno) < 0)
+				if (parse_lineno(last, &query->last_lineno)
+				    < query->first_lineno) {
+					pr_err("last-line < 1st-line\n");
 					return -EINVAL;
+				}
 			} else {
 				query->last_lineno = query->first_lineno;
 			}
@@ -325,6 +350,8 @@ static int ddebug_parse_query(char *words[], int nwords,
 			pr_err("unknown keyword \"%s\"\n", words[i]);
 			return -EINVAL;
 		}
+		if (rc)
+			return rc;
 	}
 
 	if (verbose)
-- 
1.7.7.3

