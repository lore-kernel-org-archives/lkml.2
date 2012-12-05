Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab2LEVst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 16:48:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095Ab2LEVsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 16:48:32 -0500
Date: Wed, 5 Dec 2012 16:48:27 -0500
From: Jason Baron <jbaron@redhat.com>
To: gregkh@linuxfoundation.org
Cc: joe@perches.com, jim.cromie@gmail.com, majianpeng@gmail.com,
        linux-kernel@vger.kernel.org
Message-Id: <824103ca530aab9ab12d4c46e21e2b13f2aced9b.1354741891.git.jbaron@redhat.com>
In-Reply-To: <cover.1354741891.git.jbaron@redhat.com>
References: <cover.1354741891.git.jbaron@redhat.com>
Subject: [PATCH 3/3] dynamic_debug: add pr_errs before -EINVALs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Ma noted that dynamic-debug is silent about many query errors, so add
pr_err()s to explain those errors, and tweak a few others.  Also parse
flags 1st, so that match-spec errs are slightly clearer.

CC: Jianpeng Ma <majianpeng@gmail.com>
CC: Joe Perches <joe@perches.com>
CC: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 lib/dynamic_debug.c |   47 +++++++++++++++++++++++++++++++++++------------
 1 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index c0869f1..da820f2 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -230,8 +230,10 @@ static int ddebug_tokenize(char *buf, char *words[], int maxwords)
 			int quote = *buf++;
 			for (end = buf; *end && *end != quote; end++)
 				;
-			if (!*end)
+			if (!*end) {
+				pr_err("unclosed quote: %s\n", buf);
 				return -EINVAL;	/* unclosed quote */
+			}
 		} else {
 			for (end = buf; *end && !isspace(*end); end++)
 				;
@@ -239,8 +241,10 @@ static int ddebug_tokenize(char *buf, char *words[], int maxwords)
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
@@ -272,7 +276,11 @@ static inline int parse_lineno(const char *str, unsigned int *val)
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
@@ -352,8 +360,10 @@ static int ddebug_parse_query(char *words[], int nwords,
 	int rc;
 
 	/* check we have an even number of words */
-	if (nwords % 2 != 0)
+	if (nwords % 2 != 0) {
+		pr_err("expecting pairs of match-spec <value>\n");
 		return -EINVAL;
+	}
 	memset(query, 0, sizeof(*query));
 
 	if (modname)
@@ -374,18 +384,22 @@ static int ddebug_parse_query(char *words[], int nwords,
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
@@ -421,6 +435,7 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 		op = *str++;
 		break;
 	default:
+		pr_err("bad flag-op %c, at start of %s\n", *str, str);
 		return -EINVAL;
 	}
 	vpr_info("op='%c'\n", op);
@@ -432,8 +447,10 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
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
 
@@ -465,13 +482,19 @@ static int ddebug_exec_query(char *query_string, const char *modname)
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
 	vpr_info_dq(&query, nfound ? "applied" : "no-match");
-- 
1.7.1

