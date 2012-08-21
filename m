Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab2HUP1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:27:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59779 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab2HUP12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:27:28 -0400
Date: Tue, 21 Aug 2012 08:27:14 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-b527bab59be7ca2154f644fcc4b9e3c267a6d855@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, robert.richter@amd.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, robert.richter@amd.com, tglx@linutronix.de
In-Reply-To: <1344361396-7237-4-git-send-email-robert.richter@amd.com>
References: <1344361396-7237-4-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix parsing of 64 bit raw config value for 32 bit
Git-Commit-ID: b527bab59be7ca2154f644fcc4b9e3c267a6d855
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:27:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b527bab59be7ca2154f644fcc4b9e3c267a6d855
Gitweb:     http://git.kernel.org/tip/b527bab59be7ca2154f644fcc4b9e3c267a6d855
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Tue, 7 Aug 2012 19:43:13 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 8 Aug 2012 12:39:56 -0300

perf tools: Fix parsing of 64 bit raw config value for 32 bit

perf record fails on 32 bit with:

 invalid or unsupported event: 'r40000F7E0'

Fixing this by parsing 64 bit num values.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1344361396-7237-4-git-send-email-robert.richter@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c |    6 +++---
 tools/perf/util/parse-events.h |    6 +++---
 tools/perf/util/parse-events.l |    4 ++--
 tools/perf/util/parse-events.y |   10 +++++-----
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 74a5af4..8bdfa3e 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -551,7 +551,7 @@ static int config_attr(struct perf_event_attr *attr,
 }
 
 int parse_events_add_numeric(struct list_head **list, int *idx,
-			     unsigned long type, unsigned long config,
+			     u32 type, u64 config,
 			     struct list_head *head_config)
 {
 	struct perf_event_attr attr;
@@ -1005,7 +1005,7 @@ int parse_events__is_hardcoded_term(struct parse_events__term *term)
 
 static int new_term(struct parse_events__term **_term, int type_val,
 		    int type_term, char *config,
-		    char *str, long num)
+		    char *str, u64 num)
 {
 	struct parse_events__term *term;
 
@@ -1034,7 +1034,7 @@ static int new_term(struct parse_events__term **_term, int type_val,
 }
 
 int parse_events__term_num(struct parse_events__term **term,
-			   int type_term, char *config, long num)
+			   int type_term, char *config, u64 num)
 {
 	return new_term(term, PARSE_EVENTS__TERM_TYPE_NUM, type_term,
 			config, NULL, num);
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index ee9c218..163aad4 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -55,7 +55,7 @@ struct parse_events__term {
 	char *config;
 	union {
 		char *str;
-		long  num;
+		u64  num;
 	} val;
 	int type_val;
 	int type_term;
@@ -73,7 +73,7 @@ struct parse_events_data__terms {
 
 int parse_events__is_hardcoded_term(struct parse_events__term *term);
 int parse_events__term_num(struct parse_events__term **_term,
-			   int type_term, char *config, long num);
+			   int type_term, char *config, u64 num);
 int parse_events__term_str(struct parse_events__term **_term,
 			   int type_term, char *config, char *str);
 int parse_events__term_clone(struct parse_events__term **new,
@@ -83,7 +83,7 @@ int parse_events_modifier(struct list_head *list, char *str);
 int parse_events_add_tracepoint(struct list_head **list, int *idx,
 				char *sys, char *event);
 int parse_events_add_numeric(struct list_head **list, int *idx,
-			     unsigned long type, unsigned long config,
+			     u32 type, u64 config,
 			     struct list_head *head_config);
 int parse_events_add_cache(struct list_head **list, int *idx,
 			   char *type, char *op_result1, char *op_result2);
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 384ca74..e4abdf2 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -15,10 +15,10 @@ YYSTYPE *parse_events_get_lval(yyscan_t yyscanner);
 
 static int __value(YYSTYPE *yylval, char *str, int base, int token)
 {
-	long num;
+	u64 num;
 
 	errno = 0;
-	num = strtoul(str, NULL, base);
+	num = strtoull(str, NULL, base);
 	if (errno)
 		return PE_ERROR;
 
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 2bc5fbf..423d331 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -57,7 +57,7 @@ do { \
 %union
 {
 	char *str;
-	unsigned long num;
+	u64 num;
 	struct list_head *head;
 	struct parse_events__term *term;
 }
@@ -207,7 +207,7 @@ PE_VALUE ':' PE_VALUE
 	struct parse_events_data__events *data = _data;
 	struct list_head *list = NULL;
 
-	ABORT_ON(parse_events_add_numeric(&list, &data->idx, $1, $3, NULL));
+	ABORT_ON(parse_events_add_numeric(&list, &data->idx, (u32)$1, $3, NULL));
 	$$ = list;
 }
 
@@ -282,7 +282,7 @@ PE_TERM '=' PE_NAME
 {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__term_str(&term, $1, NULL, $3));
+	ABORT_ON(parse_events__term_str(&term, (int)$1, NULL, $3));
 	$$ = term;
 }
 |
@@ -290,7 +290,7 @@ PE_TERM '=' PE_VALUE
 {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__term_num(&term, $1, NULL, $3));
+	ABORT_ON(parse_events__term_num(&term, (int)$1, NULL, $3));
 	$$ = term;
 }
 |
@@ -298,7 +298,7 @@ PE_TERM
 {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__term_num(&term, $1, NULL, 1));
+	ABORT_ON(parse_events__term_num(&term, (int)$1, NULL, 1));
 	$$ = term;
 }
 
