Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933302Ab2GEPpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:45:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:59136 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030234Ab2GEPpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:45:38 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 19/20] perf tools: Split out PE_VALUE_SYM parsing token to SW and HW tokens
Date: Thu,  5 Jul 2012 12:45:17 -0300
Message-Id: <1341503118-13198-20-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1341503118-13198-1-git-send-email-acme@infradead.org>
References: <1341503118-13198-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Spliting PE_VALUE_SYM token to PE_VALUE_SYM_HW and PE_VALUE_SYM_SW
tokens to separate hardware and software symbols.

This will be useful in upcomming patch where we want to be able to parse
out only hardware events.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1341352848-11833-6-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.l |    2 +-
 tools/perf/util/parse-events.y |   15 +++++++++++----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 6cbe092..384ca74 100644
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
1.7.9.2.358.g22243

