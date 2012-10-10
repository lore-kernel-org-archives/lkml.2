Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab2JJMyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 08:54:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756092Ab2JJMyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 08:54:21 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 7/8] perf tools: Add support to specify hw event as pmu event term
Date: Wed, 10 Oct 2012 14:53:17 +0200
Message-Id: <1349873598-12583-8-git-send-email-jolsa@redhat.com>
In-Reply-To: <1349873598-12583-1-git-send-email-jolsa@redhat.com>
References: <1349873598-12583-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a way to specify hw event as pmu event term like:
 'cpu/event=cpu-cycles/u'
 'cpu/event=instructions,.../u'
 'cpu/cycles,.../u'

The 'event=cpu-cycles' term is replaced/translated by the hw events
term translation, which is exposed by sysfs 'events' group attribute.

Adding parser bits, the rest is already handled by the pmu alias code.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/parse-events.c | 18 ++++++++++++++++++
 tools/perf/util/parse-events.h |  2 ++
 tools/perf/util/parse-events.y | 18 ++++++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index aed38e4..5ce6f8c 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1139,6 +1139,24 @@ int parse_events__term_str(struct parse_events__term **term,
 			config, str, 0);
 }
 
+int parse_events__term_sym_hw(struct parse_events__term **term,
+			      char *config, unsigned idx)
+{
+	struct event_symbol *sym;
+
+	BUG_ON(idx >= PERF_COUNT_HW_MAX);
+	sym = &event_symbols_hw[idx];
+
+	if (config)
+		return new_term(term, PARSE_EVENTS__TERM_TYPE_STR,
+				PARSE_EVENTS__TERM_TYPE_USER, config,
+				(char *) sym->symbol, 0);
+	else
+		return new_term(term, PARSE_EVENTS__TERM_TYPE_STR,
+				PARSE_EVENTS__TERM_TYPE_USER,
+				(char *) "event", (char *) sym->symbol, 0);
+}
+
 int parse_events__term_clone(struct parse_events__term **new,
 			     struct parse_events__term *term)
 {
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index c356e44..6b1e841 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -76,6 +76,8 @@ int parse_events__term_num(struct parse_events__term **_term,
 			   int type_term, char *config, u64 num);
 int parse_events__term_str(struct parse_events__term **_term,
 			   int type_term, char *config, char *str);
+int parse_events__term_sym_hw(struct parse_events__term **term,
+			      char *config, unsigned idx);
 int parse_events__term_clone(struct parse_events__term **new,
 			     struct parse_events__term *term);
 void parse_events__free_terms(struct list_head *terms);
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index cd88209..0f9914a 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -352,6 +352,15 @@ PE_NAME '=' PE_VALUE
 	$$ = term;
 }
 |
+PE_NAME '=' PE_VALUE_SYM_HW
+{
+	struct parse_events__term *term;
+	int config = $3 & 255;
+
+	ABORT_ON(parse_events__term_sym_hw(&term, $1, config));
+	$$ = term;
+}
+|
 PE_NAME
 {
 	struct parse_events__term *term;
@@ -361,6 +370,15 @@ PE_NAME
 	$$ = term;
 }
 |
+PE_VALUE_SYM_HW
+{
+	struct parse_events__term *term;
+	int config = $1 & 255;
+
+	ABORT_ON(parse_events__term_sym_hw(&term, NULL, config));
+	$$ = term;
+}
+|
 PE_TERM '=' PE_NAME
 {
 	struct parse_events__term *term;
-- 
1.7.11.4

