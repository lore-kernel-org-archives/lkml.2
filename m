Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933632Ab2GFLY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:24:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52301 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab2GFLY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:24:56 -0400
Date: Fri, 6 Jul 2012 04:24:33 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-cf3506dcc4a855d11af20bcb271ac921033ba0de@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1341352848-11833-6-git-send-email-jolsa@redhat.com>
References: <1341352848-11833-6-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Split out PE_VALUE_SYM parsing token to SW and HW tokens
Git-Commit-ID: cf3506dcc4a855d11af20bcb271ac921033ba0de
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 04:24:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf3506dcc4a855d11af20bcb271ac921033ba0de
Gitweb:     http://git.kernel.org/tip/cf3506dcc4a855d11af20bcb271ac921033ba0de
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 4 Jul 2012 00:00:43 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 5 Jul 2012 11:29:56 -0300

perf tools: Split out PE_VALUE_SYM parsing token to SW and HW tokens

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
