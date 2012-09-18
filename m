Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab2IRXhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 19:37:16 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:45964 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab2IRXhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 19:37:13 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, Jim Cromie <jim.cromie@gmail.com>,
        Jianpeng Ma <majianpeng@gmail.com>
Subject: [PATCH 1/6] dyndbg: fix usability bug by adding pr_errs for -EINVALs
Date: Tue, 18 Sep 2012 17:36:42 -0600
Message-Id: <1348011407-24108-2-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348011407-24108-1-git-send-email-jim.cromie@gmail.com>
References: <1348011407-24108-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent usability grumble on LKML prompted a review of error
reporting when writing dyndbg queries.  For each -EINVAL, this adds
pr_err()s to explain the error.

To: Jason Baron <jbaron@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jianpeng Ma <majianpeng@gmail.com>
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c | 40 ++++++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index e7f7d99..ceda053 100644
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
+		pr_err("illegal line-number: %s\n", str);
+		return -EINVAL;
+	}
+	return 0;
 }
 
 /*
@@ -344,8 +352,10 @@ static int ddebug_parse_query(char *words[], int nwords,
 	int rc;
 
 	/* check we have an even number of words */
-	if (nwords % 2 != 0)
+	if (nwords % 2 != 0) {
+		pr_err("legal query spec is pairs of: spec value\n");
 		return -EINVAL;
+	}
 	memset(query, 0, sizeof(*query));
 
 	if (modname)
@@ -371,8 +381,10 @@ static int ddebug_parse_query(char *words[], int nwords,
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
@@ -413,6 +425,7 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 		op = *str++;
 		break;
 	default:
+		pr_err("bad flags-op, expecting [+-=], not %c\n", *str);
 		return -EINVAL;
 	}
 	vpr_info("op='%c'\n", op);
@@ -424,8 +437,10 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 				break;
 			}
 		}
-		if (i < 0)
+		if (i < 0) {
+			pr_err("unknown flag: %c\n", *str);
 			return -EINVAL;
+		}
 	}
 	vpr_info("flags=0x%x\n", flags);
 
@@ -457,13 +472,18 @@ static int ddebug_exec_query(char *query_string, const char *modname)
 	char *words[MAXWORDS];
 
 	nwords = ddebug_tokenize(query_string, words, MAXWORDS);
-	if (nwords <= 0)
+	if (nwords <= 0) {
+		pr_err("tokenize failed\n");
 		return -EINVAL;
-	if (ddebug_parse_query(words, nwords-1, &query, modname))
+	}
+	if (ddebug_parse_query(words, nwords-1, &query, modname)) {
+		pr_err("query spec parse failed\n");
 		return -EINVAL;
-	if (ddebug_parse_flags(words[nwords-1], &flags, &mask))
+	}
+	if (ddebug_parse_flags(words[nwords-1], &flags, &mask)) {
+		pr_err("flags parse failed\n");
 		return -EINVAL;
-
+	}
 	/* actually go and implement the change */
 	nfound = ddebug_change(&query, flags, mask);
 	vpr_info_dq((&query), (nfound) ? "applied" : "no-match");
-- 
1.7.11.4

