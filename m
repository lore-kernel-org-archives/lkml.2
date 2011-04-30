Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752Ab1D3Pcr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 11:32:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33830 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757320Ab1D3PcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 11:32:13 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=vhdKIqpQuCYA:10 a=e4u95OiyKvEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=4D7iCPThkUTzqto6mGEA:9 a=QxF5Z8cTfduNvBs5tCcA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110430153212.152717553@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 30 Apr 2011 11:30:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 8/8] ftrace: Consolidate the function match routines for normal and mods
References: <20110430153040.354378898@goodmis.org>
Content-Disposition: inline; filename=0008-ftrace-Consolidate-the-function-match-routines-for-n.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The code used for matching functions is almost identical between normal
selecting of functions and using the :mod: feature of set_ftrace_notrace.

Consolidate the two users into one function.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   98 ++++++++++++++++++-------------------------------
 1 files changed, 36 insertions(+), 62 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 33bcc71..4f19dbb 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1726,34 +1726,52 @@ update_record(struct dyn_ftrace *rec, unsigned long flag, int not)
 }
 
 static int
-ftrace_match_record(struct dyn_ftrace *rec, char *regex, int len, int type)
+ftrace_match_record(struct dyn_ftrace *rec, char *mod,
+		    char *regex, int len, int type)
 {
 	char str[KSYM_SYMBOL_LEN];
+	char *modname;
+
+	kallsyms_lookup(rec->ip, NULL, NULL, &modname, str);
+
+	if (mod) {
+		/* module lookup requires matching the module */
+		if (!modname || strcmp(modname, mod))
+			return 0;
+
+		/* blank search means to match all funcs in the mod */
+		if (!len)
+			return 1;
+	}
 
-	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
 	return ftrace_match(str, regex, len, type);
 }
 
-static int ftrace_match_records(char *buff, int len, int enable)
+static int match_records(char *buff, int len, char *mod, int enable, int not)
 {
-	unsigned int search_len;
+	unsigned search_len = 0;
 	struct ftrace_page *pg;
 	struct dyn_ftrace *rec;
+	int type = MATCH_FULL;
+	char *search = buff;
 	unsigned long flag;
-	char *search;
-	int type;
-	int not;
 	int found = 0;
 
-	flag = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
-	type = filter_parse_regex(buff, len, &search, &not);
+	if (len) {
+		type = filter_parse_regex(buff, len, &search, &not);
+		search_len = strlen(search);
+	}
 
-	search_len = strlen(search);
+	flag = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
 
 	mutex_lock(&ftrace_lock);
+
+	if (unlikely(ftrace_disabled))
+		goto out_unlock;
+
 	do_for_each_ftrace_rec(pg, rec) {
 
-		if (ftrace_match_record(rec, search, search_len, type)) {
+		if (ftrace_match_record(rec, mod, search, search_len, type)) {
 			update_record(rec, flag, not);
 			found = 1;
 		}
@@ -1763,43 +1781,23 @@ static int ftrace_match_records(char *buff, int len, int enable)
 		 */
 		if (enable && (rec->flags & FTRACE_FL_FILTER))
 			ftrace_filtered = 1;
+
 	} while_for_each_ftrace_rec();
+ out_unlock:
 	mutex_unlock(&ftrace_lock);
 
 	return found;
 }
 
 static int
-ftrace_match_module_record(struct dyn_ftrace *rec, char *mod,
-			   char *regex, int len, int type)
+ftrace_match_records(char *buff, int len, int enable)
 {
-	char str[KSYM_SYMBOL_LEN];
-	char *modname;
-
-	kallsyms_lookup(rec->ip, NULL, NULL, &modname, str);
-
-	if (!modname || strcmp(modname, mod))
-		return 0;
-
-	/* blank search means to match all funcs in the mod */
-	if (len)
-		return ftrace_match(str, regex, len, type);
-	else
-		return 1;
+	return match_records(buff, len, NULL, enable, 0);
 }
 
 static int ftrace_match_module_records(char *buff, char *mod, int enable)
 {
-	unsigned search_len = 0;
-	struct ftrace_page *pg;
-	struct dyn_ftrace *rec;
-	int type = MATCH_FULL;
-	char *search = buff;
-	unsigned long flag;
 	int not = 0;
-	int found = 0;
-
-	flag = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
 
 	/* blank or '*' mean the same */
 	if (strcmp(buff, "*") == 0)
@@ -1811,31 +1809,7 @@ static int ftrace_match_module_records(char *buff, char *mod, int enable)
 		not = 1;
 	}
 
-	if (strlen(buff)) {
-		type = filter_parse_regex(buff, strlen(buff), &search, &not);
-		search_len = strlen(search);
-	}
-
-	mutex_lock(&ftrace_lock);
-
-	if (unlikely(ftrace_disabled))
-		goto out_unlock;
-
-	do_for_each_ftrace_rec(pg, rec) {
-
-		if (ftrace_match_module_record(rec, mod,
-					       search, search_len, type)) {
-			update_record(rec, flag, not);
-			found = 1;
-		}
-		if (enable && (rec->flags & FTRACE_FL_FILTER))
-			ftrace_filtered = 1;
-
-	} while_for_each_ftrace_rec();
- out_unlock:
-	mutex_unlock(&ftrace_lock);
-
-	return found;
+	return match_records(buff, strlen(buff), mod, enable, not);
 }
 
 /*
@@ -1993,7 +1967,7 @@ register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 
 	do_for_each_ftrace_rec(pg, rec) {
 
-		if (!ftrace_match_record(rec, search, len, type))
+		if (!ftrace_match_record(rec, NULL, search, len, type))
 			continue;
 
 		entry = kmalloc(sizeof(*entry), GFP_KERNEL);
@@ -2548,7 +2522,7 @@ ftrace_set_func(unsigned long *array, int *idx, char *buffer)
 		if (rec->flags & FTRACE_FL_FREE)
 			continue;
 
-		if (ftrace_match_record(rec, search, search_len, type)) {
+		if (ftrace_match_record(rec, NULL, search, search_len, type)) {
 			/* if it is in the array */
 			exists = false;
 			for (i = 0; i < *idx; i++) {
-- 
1.7.2.3


