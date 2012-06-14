Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab2FNUj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 16:39:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756679Ab2FNUjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 16:39:22 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 5/6] perf, tool: event parsing - split PE_VALUE_SYM to SW and HW tokens
Date: Thu, 14 Jun 2012 22:38:40 +0200
Message-Id: <1339706321-8802-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1339706321-8802-1-git-send-email-jolsa@redhat.com>
References: <1339706321-8802-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spliting PE_VALUE_SYM token to PE_VALUE_SYM_HW and PE_VALUE_SYM_SW
tokens to separate hardware and software symbols.

This will be usefull in upcomming patches where we want to be able
to parse out only hardware events.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/parse-events.l |    2 +-
 tools/perf/util/parse-events.y |   15 +++++++++++----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 618a8e7..f804c91 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -40,7 +40,7 @@ static int str(int token)
 static int sym(int type, int config)
 {
 	parse_events_lval.num = (type << 16) + config;
-	return PE_VALUE_SYM;
+	return type == PERF_TYPE_HARDWARE ? PE_VALUE_SYM_HW : PE_VALUE_SYM_SW;
 }
 
 static int term(int type)
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 362cc59..d3dce39 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -23,14 +23,15 @@ do { \
 
 %}
 
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
@@ -38,6 +39,7 @@ do { \
 %type <str> PE_NAME_CACHE_OP_RESULT
 %type <str> PE_MODIFIER_EVENT
 %type <str> PE_MODIFIER_BP
+%type <num> value_sym
 %type <head> event_config
 %type <term> event_term
 %type <head> event_pmu
@@ -96,8 +98,13 @@ PE_NAME '/' event_config '/'
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
 	struct list_head *list = NULL;
 	int type = $1 >> 16;
@@ -108,7 +115,7 @@ PE_VALUE_SYM '/' event_config '/'
 	$$ = list;
 }
 |
-PE_VALUE_SYM sep_slash_dc
+value_sym sep_slash_dc
 {
 	struct list_head *list = NULL;
 	int type = $1 >> 16;
-- 
1.7.7.6

