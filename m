Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab2FNUjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 16:39:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756592Ab2FNUjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 16:39:10 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 6/6] perf, tool: Support translate terms for hw events
Date: Thu, 14 Jun 2012 22:38:41 +0200
Message-Id: <1339706321-8802-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1339706321-8802-1-git-send-email-jolsa@redhat.com>
References: <1339706321-8802-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow to specify HW events mnemonics inside the PMU events
syntax, like:

  # perf stat -e cpu/event=instructions/u ls

The term value gets the value of the PERF_TYPE_HARDWARE event
translated for current CPU. The translation is obtained
from PMU sysfs events group attribute.

Above example will fill event term with translated value for
HW instruction event for current CPU model.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/parse-events.c |    8 +++++++-
 tools/perf/util/parse-events.h |    3 +++
 tools/perf/util/parse-events.y |   11 +++++++++++
 tools/perf/util/pmu.c          |   34 +++++++++++++++++++++++++++-------
 4 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 05dbc8b..7c64f43 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1057,9 +1057,15 @@ void print_events(const char *event_glob)
 	print_tracepoint_events(NULL, NULL);
 }
 
+int parse_events__is_translate_term(struct parse_events__term *term)
+{
+	return term->type_term == PARSE_EVENTS__TERM_TYPE_USER_TRANSLATE;
+}
+
 int parse_events__is_hardcoded_term(struct parse_events__term *term)
 {
-	return term->type_term != PARSE_EVENTS__TERM_TYPE_USER;
+	return (term->type_term != PARSE_EVENTS__TERM_TYPE_USER) &&
+	       (term->type_term != PARSE_EVENTS__TERM_TYPE_USER_TRANSLATE);
 }
 
 static int new_term(struct parse_events__term **_term, int type_val,
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 8cac57a..deae5d7 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -44,6 +44,7 @@ enum {
 
 enum {
 	PARSE_EVENTS__TERM_TYPE_USER,
+	PARSE_EVENTS__TERM_TYPE_USER_TRANSLATE,
 	PARSE_EVENTS__TERM_TYPE_CONFIG,
 	PARSE_EVENTS__TERM_TYPE_CONFIG1,
 	PARSE_EVENTS__TERM_TYPE_CONFIG2,
@@ -60,9 +61,11 @@ struct parse_events__term {
 	} val;
 	int type_val;
 	int type_term;
+	u64 flags;
 	struct list_head list;
 };
 
+int parse_events__is_translate_term(struct parse_events__term *term);
 int parse_events__is_hardcoded_term(struct parse_events__term *term);
 int parse_events__term_num(struct parse_events__term **_term,
 			   int type_term, char *config, long num);
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index d3dce39..0541cd1 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -235,6 +235,17 @@ PE_NAME '=' PE_VALUE
 	$$ = term;
 }
 |
+PE_NAME '=' PE_VALUE_SYM_HW
+{
+	struct parse_events__term *term;
+#define CONFIG_MASK ((1ULL << 16) - 1ULL)
+
+	ABORT_ON(parse_events__term_num(&term,
+					PARSE_EVENTS__TERM_TYPE_USER_TRANSLATE,
+					$1, $3 & CONFIG_MASK));
+	$$ = term;
+}
+|
 PE_NAME
 {
 	struct parse_events__term *term;
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index bf2a2a9..e7b3dea 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -315,11 +315,26 @@ static __u64 pmu_format_value(unsigned long *format, __u64 value)
 	return v;
 }
 
+static int translate_term(struct parse_events__term *term, __u64 *events)
+{
+	unsigned id = (unsigned) term->val.num;
+
+	if (!events)
+		return -EINVAL;
+
+	if (id >= PERF_COUNT_HW_MAX)
+		return -EINVAL;
+
+	term->val.num = events[id];
+	return 0;
+}
+
 /*
  * Setup one of config[12] attr members based on the
  * user input data - temr parameter.
  */
 static int pmu_config_term(struct list_head *formats,
+			   __u64 *events,
 			   struct perf_event_attr *attr,
 			   struct parse_events__term *term)
 {
@@ -356,21 +371,26 @@ static int pmu_config_term(struct list_head *formats,
 	}
 
 	/*
-	 * XXX If we ever decide to go with string values for
-	 * non-hardcoded terms, here's the place to translate
-	 * them into value.
+	 * We support translation only for PERF_TYPE_HARDWARE events,
+	 * which use config value only.
 	 */
+	if (parse_events__is_translate_term(term) &&
+	    (format->value == PERF_PMU_FORMAT_VALUE_CONFIG))
+		if (translate_term(term, events))
+			return -EINVAL;
+
 	*vp |= pmu_format_value(format->bits, term->val.num);
 	return 0;
 }
 
-static int pmu_config(struct list_head *formats, struct perf_event_attr *attr,
+static int pmu_config(struct list_head *formats, __u64 *events,
+		      struct perf_event_attr *attr,
 		      struct list_head *head_terms)
 {
 	struct parse_events__term *term;
 
 	list_for_each_entry(term, head_terms, list)
-		if (pmu_config_term(formats, attr, term))
+		if (pmu_config_term(formats, events, attr, term))
 			return -EINVAL;
 
 	return 0;
@@ -385,7 +405,7 @@ int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
 		     struct list_head *head_terms)
 {
 	attr->type = pmu->type;
-	return pmu_config(&pmu->format, attr, head_terms);
+	return pmu_config(&pmu->format, pmu->events, attr, head_terms);
 }
 
 int perf_pmu__new_format(struct list_head *list, char *name,
@@ -571,7 +591,7 @@ int perf_pmu__test(void)
 		if (ret)
 			break;
 
-		ret = pmu_config(&formats, &attr, terms);
+		ret = pmu_config(&formats, NULL, &attr, terms);
 		if (ret)
 			break;
 
-- 
1.7.7.6

