Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab2KOH5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 02:57:40 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42796 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab2KOH5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 02:57:39 -0500
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com, linux-kernel@vger.kernel.org
Cc: Jim Cromie <jim.cromie@gmail.com>, Jianpeng Ma <majianpeng@gmail.com>,
        Joe Perches <joe@perches.com>, Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH] dyndbg: add pr_errs before -EINVALs
Date: Thu, 15 Nov 2012 00:57:18 -0700
Message-Id: <1352966238-22491-1-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.10.1.487.ga3935e6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ma noted that dynamic-debug is silent about many query errors, so add
pr_err()s to explain those errors, and tweak a few others.  Also parse
flags 1st, so that match-spec errs are slightly clearer.

To: Jason Baron <jbaron@redhat.com>
CC: Jianpeng Ma <majianpeng@gmail.com>
CC: Joe Perches <joe@perches.com>
CC: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c | 51 +++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 37 insertions(+), 14 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index e7f7d99..9b289d9 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -222,8 +222,10 @@ static int ddebug_tokenize(char *buf, char *words[], int maxwords)
 			int quote = *buf++;
 			for (end = buf ; *end && *end != quote ; end++)
 				;
-			if (!*end)
+			if (!*end) {
+				pr_err("unclosed quote: %s\n", buf);
 				return -EINVAL;	/* unclosed quote */
+			}
 		} else {
 			for (end = buf ; *end && !isspace(*end) ; end++)
 				;
@@ -231,8 +233,10 @@ static int ddebug_tokenize(char *buf, char *words[], int maxwords)
 		}
 
 		/* `buf' is start of word, `end' is one past its end */
-		if (nwords == maxwords)
+		if (nwords == maxwords) {
+			pr_err("too many words, legal max <=%d\n", maxwords);
 			return -EINVAL;	/* ran out of words[] before bytes */
+		}
 		if (*end)
 			*end++ = '\0';	/* terminate the word */
 		words[nwords++] = buf;
@@ -264,7 +268,11 @@ static inline int parse_lineno(const char *str, unsigned int *val)
 		return 0;
 	}
 	*val = simple_strtoul(str, &end, 10);
-	return end == NULL || end == str || *end != '\0' ? -EINVAL : 0;
+	if (end == NULL || end == str || *end != '\0') {
+		pr_err("bad line-number: %s\n", str);
+		return -EINVAL;
+	}
+	return 0;
 }
 
 /*
@@ -315,8 +323,8 @@ static int check_set(const char **dest, char *src, char *name)
 
 	if (*dest) {
 		rc = -EINVAL;
-		pr_err("match-spec:%s val:%s overridden by %s",
-			name, *dest, src);
+		pr_err("match-spec %s used 2x: %s then %s\n",
+		       name, *dest, src);
 	}
 	*dest = src;
 	return rc;
@@ -344,8 +352,10 @@ static int ddebug_parse_query(char *words[], int nwords,
 	int rc;
 
 	/* check we have an even number of words */
-	if (nwords % 2 != 0)
+	if (nwords % 2 != 0) {
+		pr_err("expecting pairs of match-spec <value>\n"); 
 		return -EINVAL;
+	}
 	memset(query, 0, sizeof(*query));
 
 	if (modname)
@@ -366,18 +376,22 @@ static int ddebug_parse_query(char *words[], int nwords,
 			char *first = words[i+1];
 			char *last = strchr(first, '-');
 			if (query->first_lineno || query->last_lineno) {
-				pr_err("match-spec:line given 2 times\n");
+				pr_err("match-spec: line used 2x\n");
 				return -EINVAL;
 			}
 			if (last)
 				*last++ = '\0';
-			if (parse_lineno(first, &query->first_lineno) < 0)
+			if (parse_lineno(first, &query->first_lineno) < 0) {
+				pr_err("line-number is <0\n");
 				return -EINVAL;
+			}
 			if (last) {
 				/* range <first>-<last> */
 				if (parse_lineno(last, &query->last_lineno)
 				    < query->first_lineno) {
-					pr_err("last-line < 1st-line\n");
+					pr_err("last-line:%d < 1st-line:%d\n",
+						query->last_lineno,
+						query->first_lineno);
 					return -EINVAL;
 				}
 			} else {
@@ -413,6 +427,7 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 		op = *str++;
 		break;
 	default:
+		pr_err("bad flag-op %c, at start of %s\n", *str, str);
 		return -EINVAL;
 	}
 	vpr_info("op='%c'\n", op);
@@ -424,8 +439,10 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 				break;
 			}
 		}
-		if (i < 0)
+		if (i < 0) {
+			pr_err("unknown flag '%c' in \"%s\"\n", *str, str);
 			return -EINVAL;
+		}
 	}
 	vpr_info("flags=0x%x\n", flags);
 
@@ -457,13 +474,19 @@ static int ddebug_exec_query(char *query_string, const char *modname)
 	char *words[MAXWORDS];
 
 	nwords = ddebug_tokenize(query_string, words, MAXWORDS);
-	if (nwords <= 0)
+	if (nwords <= 0) {
+		pr_err("tokenize failed\n");
 		return -EINVAL;
-	if (ddebug_parse_query(words, nwords-1, &query, modname))
+	}
+	/* check flags 1st (last arg) so query is pairs of spec,val */
+	if (ddebug_parse_flags(words[nwords-1], &flags, &mask)) {
+		pr_err("flags parse failed\n");
 		return -EINVAL;
-	if (ddebug_parse_flags(words[nwords-1], &flags, &mask))
+	}
+	if (ddebug_parse_query(words, nwords-1, &query, modname)) {
+		pr_err("query parse failed\n");
 		return -EINVAL;
-
+	}
 	/* actually go and implement the change */
 	nfound = ddebug_change(&query, flags, mask);
 	vpr_info_dq((&query), (nfound) ? "applied" : "no-match");
-- 
1.7.10.1.487.ga3935e6

