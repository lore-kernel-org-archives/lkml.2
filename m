Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab2JCVWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 17:22:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:13156 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755369Ab2JCVWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 17:22:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,529,1344236400"; 
   d="scan'208";a="219413754"
From: Andi Kleen <andi@firstfloor.org>
To: acme@redhat.com
Cc: jolsa@redhat.com, eranian@google.com, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/3] perf, tools: Support generic events as pmu event names
Date: Wed,  3 Oct 2012 14:22:41 -0700
Message-Id: <1349299363-30714-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1349299363-30714-1-git-send-email-andi@firstfloor.org>
References: <1349299363-30714-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Extend the parser/lexer to allow generic event names like,
"instructions" as a sysfs supplied PMU event name too.

This resolves the problem that cpu/instructions/ gives a parse
error, even when the kernel supplies a "instructions" event
This is useful to add sysfs specified qualifiers to these
events, for example cpu/instructions,intx=1/ and needed
for the TSX events

Simply extend the grammar to handle this case. The lexer
needs minor changes to save the original string.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/parse-events.l |    3 ++-
 tools/perf/util/parse-events.y |   27 +++++++++++++++++++++++----
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index c2e5142..dd3a901 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -55,7 +55,8 @@ static int sym(yyscan_t scanner, int type, int config)
 {
 	YYSTYPE *yylval = parse_events_get_lval(scanner);
 
-	yylval->num = (type << 16) + config;
+	yylval->namenum.num = (type << 16) + config;
+	yylval->namenum.name = strdup(parse_events_get_text(scanner));
 	return type == PERF_TYPE_HARDWARE ? PE_VALUE_SYM_HW : PE_VALUE_SYM_SW;
 }
 
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index cd88209..5b26ad3 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -34,8 +34,8 @@ do { \
 %token PE_PREFIX_MEM PE_PREFIX_RAW PE_PREFIX_GROUP
 %token PE_ERROR
 %type <num> PE_VALUE
-%type <num> PE_VALUE_SYM_HW
-%type <num> PE_VALUE_SYM_SW
+%type <namenum> PE_VALUE_SYM_HW
+%type <namenum> PE_VALUE_SYM_SW
 %type <num> PE_RAW
 %type <num> PE_TERM
 %type <str> PE_NAME
@@ -65,6 +65,7 @@ do { \
 
 %union
 {
+	struct { char *name; u64 num; } namenum;
 	char *str;
 	u64 num;
 	struct list_head *head;
@@ -195,9 +196,9 @@ PE_NAME '/' event_config '/'
 }
 
 value_sym:
-PE_VALUE_SYM_HW
+PE_VALUE_SYM_HW 	{ free($1.name); return $1.num; }
 |
-PE_VALUE_SYM_SW
+PE_VALUE_SYM_SW		{ free($1.name); return $1.num; }
 
 event_legacy_symbol:
 value_sym '/' event_config '/'
@@ -361,6 +362,24 @@ PE_NAME
 	$$ = term;
 }
 |
+PE_VALUE_SYM_HW
+{
+	struct parse_events__term *term;
+
+	ABORT_ON(parse_events__term_num(&term, PARSE_EVENTS__TERM_TYPE_USER,
+					$1.name, 1));
+	$$ = term;
+}
+|
+PE_VALUE_SYM_SW
+{
+	struct parse_events__term *term;
+
+	ABORT_ON(parse_events__term_num(&term, PARSE_EVENTS__TERM_TYPE_USER,
+					$1.name, 1));
+	$$ = term;
+}
+|
 PE_TERM '=' PE_NAME
 {
 	struct parse_events__term *term;
-- 
1.7.7.6

