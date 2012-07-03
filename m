Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab2GCWBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 18:01:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757312Ab2GCWBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 18:01:14 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 05/10] perf, tool: Split out PE_VALUE_SYM parsing token to SW and HW tokens
Date: Wed,  4 Jul 2012 00:00:43 +0200
Message-Id: <1341352848-11833-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
References: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spliting PE_VALUE_SYM token to PE_VALUE_SYM_HW and PE_VALUE_SYM_SW
tokens to separate hardware and software symbols.

This will be usefull in upcomming patch where we want to be able
to parse out only hardware events.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/parse-events.l |    2 +-
 tools/perf/util/parse-events.y |   15 +++++++++++----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index c05dbef..86b27a5 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -56,7 +56,7 @@ static int sym(yyscan_t scanner, int type, int config)
 	YYSTYPE *yylval = parse_events_get_lval(scanner);
 
 	yylval->num = (type << 16) + config;
-	return PE_VALUE_SYM;
+	return type == PERF_TYPE_HARDWARE ? PE_VALUE_SYM_HW : PE_VALUE_SYM_SW;
 }
 
 static int term(yyscan_t scanner, int type)
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 9525c45..2bc5fbf 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -26,14 +26,15 @@ do { \
 %}
 
 %token PE_START_EVENTS PE_START_TERMS
-%token PE_VALUE PE_VALUE_SYM PE_RAW PE_TERM
+%token PE_VALUE PE_VALUE_SYM_HW PE_VALUE_SYM_SW PE_RAW PE_TERM
 %token PE_NAME
 %token PE_MODIFIER_EVENT PE_MODIFIER_BP
 %token PE_NAME_CACHE_TYPE PE_NAME_CACHE_OP_RESULT
 %token PE_PREFIX_MEM PE_PREFIX_RAW
 %token PE_ERROR
 %type <num> PE_VALUE
-%type <num> PE_VALUE_SYM
+%type <num> PE_VALUE_SYM_HW
+%type <num> PE_VALUE_SYM_SW
 %type <num> PE_RAW
 %type <num> PE_TERM
 %type <str> PE_NAME
@@ -41,6 +42,7 @@ do { \
 %type <str> PE_NAME_CACHE_OP_RESULT
 %type <str> PE_MODIFIER_EVENT
 %type <str> PE_MODIFIER_BP
+%type <num> value_sym
 %type <head> event_config
 %type <term> event_term
 %type <head> event_pmu
@@ -109,8 +111,13 @@ PE_NAME '/' event_config '/'
 	$$ = list;
 }
 
+value_sym:
+PE_VALUE_SYM_HW
+|
+PE_VALUE_SYM_SW
+
 event_legacy_symbol:
-PE_VALUE_SYM '/' event_config '/'
+value_sym '/' event_config '/'
 {
 	struct parse_events_data__events *data = _data;
 	struct list_head *list = NULL;
@@ -123,7 +130,7 @@ PE_VALUE_SYM '/' event_config '/'
 	$$ = list;
 }
 |
-PE_VALUE_SYM sep_slash_dc
+value_sym sep_slash_dc
 {
 	struct parse_events_data__events *data = _data;
 	struct list_head *list = NULL;
-- 
1.7.10.4

