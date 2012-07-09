Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab2GIUjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:39:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490Ab2GIUiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:38:17 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 5/6] perf, tool: Add support to specify hw event as pmu event term
Date: Mon,  9 Jul 2012 22:37:49 +0200
Message-Id: <1341866270-4915-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1341866270-4915-1-git-send-email-jolsa@redhat.com>
References: <1341866270-4915-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a way to specify hw event as pmu event term like:
 'cpu/event=cpu-cycles/u'
 'cpu/event=instructions,.../u'

The 'event=cpu-cycles' term is replaced/translated by the hw events
term translation, which is exposed by sysfs 'events' group attribute.

Adding parser bits, the rest is already handled by the pmu alias code.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/parse-events.c |   13 +++++++++++++
 tools/perf/util/parse-events.h |    2 ++
 tools/perf/util/parse-events.y |    9 +++++++++
 3 files changed, 24 insertions(+)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 1aa721d..780bc45 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1045,6 +1045,19 @@ int parse_events__term_str(struct parse_events__term **term,
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
+	return new_term(term, PARSE_EVENTS__TERM_TYPE_STR,
+			PARSE_EVENTS__TERM_TYPE_USER, config,
+			(char *) sym->symbol, 0);
+}
+
 int parse_events__term_clone(struct parse_events__term **new,
 			     struct parse_events__term *term)
 {
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index ee9c218..eaf2fd7 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -76,6 +76,8 @@ int parse_events__term_num(struct parse_events__term **_term,
 			   int type_term, char *config, long num);
 int parse_events__term_str(struct parse_events__term **_term,
 			   int type_term, char *config, char *str);
+int parse_events__term_sym_hw(struct parse_events__term **term,
+			      char *config, unsigned idx);
 int parse_events__term_clone(struct parse_events__term **new,
 			     struct parse_events__term *term);
 void parse_events__free_terms(struct list_head *terms);
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 2bc5fbf..9c74d8a 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -269,6 +269,15 @@ PE_NAME '=' PE_VALUE
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
-- 
1.7.10.4

