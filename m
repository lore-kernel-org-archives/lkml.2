Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab2DDUXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 16:23:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab2DDUV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 16:21:59 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/8] perf, tool: Add list type for event term parsing
Date: Wed,  4 Apr 2012 22:21:33 +0200
Message-Id: <1333570898-10505-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1333570898-10505-1-git-send-email-jolsa@redhat.com>
References: <1333570898-10505-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding list type for event term to hanle multiple values
for single term. Term values can be now cpecified via
following grammar:

  event_term_list: event_term_list '|' event_term_elem
  event_term_list: event_term_elem '|' event_term_elem
  event_term_elem: PE_NAME | PE_VALUE

eg.:
  ...,term=str1|str2|num1|num2,...

This is going to be used for branch_type term in future.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/parse-events.c |   58 ++++++++++++++++++++++++++++-
 tools/perf/util/parse-events.h |   23 ++++++++++-
 tools/perf/util/parse-events.l |    1 +
 tools/perf/util/parse-events.y |   80 +++++++++++++++++++++++++++++++---------
 4 files changed, 140 insertions(+), 22 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 37b8fc9..e910632 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1031,8 +1031,9 @@ int parse_events__is_hardcoded_term(struct parse_events__term *term)
 	return term->type_term != PARSE_EVENTS__TERM_TYPE_USER;
 }
 
-int parse_events__new_term(struct parse_events__term **_term, int type_val,
-			   int type_term, char *config, char *str, long num)
+static int new_term(struct parse_events__term **_term, int type_val,
+		    int type_term, char *config,
+		    char *str, long num, struct list_head *list)
 {
 	struct parse_events__term *term;
 
@@ -1052,6 +1053,10 @@ int parse_events__new_term(struct parse_events__term **_term, int type_val,
 	case PARSE_EVENTS__TERM_TYPE_STR:
 		term->val.str = str;
 		break;
+	case PARSE_EVENTS__TERM_TYPE_LIST:
+		INIT_LIST_HEAD(&term->val.list);
+		list_splice_tail(list, &term->val.list);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1060,6 +1065,55 @@ int parse_events__new_term(struct parse_events__term **_term, int type_val,
 	return 0;
 }
 
+int parse_events__term_num(struct parse_events__term **term,
+			   int type_term, char *config, long num)
+{
+	return new_term(term, PARSE_EVENTS__TERM_TYPE_NUM, type_term,
+			config, NULL, num, NULL);
+}
+
+int parse_events__term_str(struct parse_events__term **term,
+			   int type_term, char *config, char *str)
+{
+	return new_term(term, PARSE_EVENTS__TERM_TYPE_STR, type_term,
+			config, str, 0, NULL);
+}
+
+int parse_events__term_list(struct parse_events__term **term,
+			    int type_term, char *config,
+			    struct list_head *list)
+{
+	return new_term(term, PARSE_EVENTS__TERM_TYPE_LIST, type_term,
+			config, NULL, 0, list);
+}
+
+int parse_events__term_elem(struct parse_events__term_elem **_elem,
+				     int type_val, char *str, long num)
+{
+	struct parse_events__term_elem *elem;
+
+	elem = zalloc(sizeof(*elem));
+	if (!elem)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&elem->list);
+	elem->type_val = type_val;
+
+	switch (type_val) {
+	case PARSE_EVENTS__TERM_TYPE_NUM:
+		elem->val.num = num;
+		break;
+	case PARSE_EVENTS__TERM_TYPE_STR:
+		elem->val.str = str;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	*_elem = elem;
+	return 0;
+}
+
 void parse_events__free_terms(struct list_head *terms)
 {
 	struct parse_events__term *term, *h;
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 7053aa3..363aa22 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -36,6 +36,7 @@ extern int parse_filter(const struct option *opt, const char *str, int unset);
 enum {
 	PARSE_EVENTS__TERM_TYPE_NUM,
 	PARSE_EVENTS__TERM_TYPE_STR,
+	PARSE_EVENTS__TERM_TYPE_LIST,
 };
 
 enum {
@@ -47,11 +48,22 @@ enum {
 	PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE,
 };
 
+
+struct parse_events__term_elem {
+	union {
+		char *str;
+		long  num;
+	} val;
+	int type_val;
+	struct list_head list;
+};
+
 struct parse_events__term {
 	char *config;
 	union {
 		char *str;
 		long  num;
+		struct list_head list;
 	} val;
 	int type_val;
 	int type_term;
@@ -59,8 +71,15 @@ struct parse_events__term {
 };
 
 int parse_events__is_hardcoded_term(struct parse_events__term *term);
-int parse_events__new_term(struct parse_events__term **_term, int type_val,
-			   int type_term, char *config, char *str, long num);
+int parse_events__term_num(struct parse_events__term **_term,
+			   int type_term, char *config, long num);
+int parse_events__term_str(struct parse_events__term **_term,
+			   int type_term, char *config, char *str);
+int parse_events__term_list(struct parse_events__term **_term,
+			    int type_term, char *config,
+			    struct list_head *list);
+int parse_events__term_elem(struct parse_events__term_elem **_e,
+			    int type_val, char *str, long num);
 void parse_events__free_terms(struct list_head *terms);
 int parse_events_modifier(struct list_head *list __used, char *str __used);
 int parse_events_add_tracepoint(struct list_head *list, int *idx,
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 05d766e..46c5b3a 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -118,6 +118,7 @@ r{num_raw_hex}		{ return raw(); }
 ,			{ return ','; }
 :			{ return ':'; }
 =			{ return '='; }
+\|			{ return '|'; }
 
 %%
 
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index b3b45e4..6d447b7 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -41,6 +41,8 @@ do { \
 %type <str> PE_MODIFIER_BP
 %type <head> event_config
 %type <term> event_term
+%type <head> event_term_list
+%type <elem> event_term_elem
 
 %union
 {
@@ -48,6 +50,7 @@ do { \
 	unsigned long num;
 	struct list_head *head;
 	struct parse_events__term *term;
+	struct parse_events__term_elem *elem;
 }
 %%
 
@@ -176,10 +179,8 @@ PE_NAME '=' PE_NAME
 {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term,
-					PARSE_EVENTS__TERM_TYPE_STR,
-					PARSE_EVENTS__TERM_TYPE_USER,
-					$1, $3, 0));
+	ABORT_ON(parse_events__term_str(&term, PARSE_EVENTS__TERM_TYPE_USER,
+					$1, $3));
 	$$ = term;
 }
 |
@@ -187,10 +188,8 @@ PE_NAME '=' PE_VALUE
 {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term,
-					PARSE_EVENTS__TERM_TYPE_NUM,
-					PARSE_EVENTS__TERM_TYPE_USER,
-					$1, NULL, $3));
+	ABORT_ON(parse_events__term_num(&term, PARSE_EVENTS__TERM_TYPE_USER,
+					$1, $3));
 	$$ = term;
 }
 |
@@ -198,10 +197,8 @@ PE_NAME
 {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term,
-					PARSE_EVENTS__TERM_TYPE_NUM,
-					PARSE_EVENTS__TERM_TYPE_USER,
-					$1, NULL, 1));
+	ABORT_ON(parse_events__term_num(&term, PARSE_EVENTS__TERM_TYPE_USER,
+					$1, 1));
 	$$ = term;
 }
 |
@@ -209,9 +206,16 @@ PE_TERM '=' PE_VALUE
 {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term,
-					PARSE_EVENTS__TERM_TYPE_NUM,
-					$1, NULL, NULL, $3));
+	ABORT_ON(parse_events__term_num(&term, $1, NULL, $3));
+	$$ = term;
+}
+|
+PE_TERM '=' event_term_list
+{
+	struct parse_events__term *term;
+
+	ABORT_ON(parse_events__term_list(&term, $1, NULL, $3));
+	free($3);
 	$$ = term;
 }
 |
@@ -219,12 +223,52 @@ PE_TERM
 {
 	struct parse_events__term *term;
 
-	ABORT_ON(parse_events__new_term(&term,
-					PARSE_EVENTS__TERM_TYPE_NUM,
-					$1, NULL, NULL, 1));
+	ABORT_ON(parse_events__term_num(&term, $1, NULL, 1));
 	$$ = term;
 }
 
+event_term_list:
+event_term_list '|' event_term_elem
+{
+	struct list_head *list = $1;
+	struct parse_events__term_elem *elem = $3;
+
+	list_add_tail(&elem->list, list);
+	$$ = list;
+}
+|
+event_term_elem '|' event_term_elem
+{
+	struct list_head *list = malloc(sizeof(*list));
+	struct parse_events__term_elem *elem1 = $1;
+	struct parse_events__term_elem *elem2 = $3;
+
+	ABORT_ON(!list);
+	INIT_LIST_HEAD(list);
+	list_add_tail(&elem1->list, list);
+	list_add_tail(&elem2->list, list);
+	$$ = list;
+}
+
+event_term_elem:
+PE_NAME
+{
+	struct parse_events__term_elem *elem;
+
+	ABORT_ON(parse_events__term_elem(&elem, PARSE_EVENTS__TERM_TYPE_STR,
+					 $1, 0));
+	$$ = elem;
+}
+|
+PE_VALUE
+{
+	struct parse_events__term_elem *elem;
+
+	ABORT_ON(parse_events__term_elem(&elem, PARSE_EVENTS__TERM_TYPE_NUM,
+					 NULL, $1));
+	$$ = elem;
+}
+
 sep_dc: ':' |
 
 sep_slash_dc: '/' | ':' |
-- 
1.7.7.6

