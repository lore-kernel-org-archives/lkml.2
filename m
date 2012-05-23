Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965228Ab2EWPWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:22:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40817 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965117Ab2EWPVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:21:06 -0400
Date: Wed, 23 May 2012 08:20:37 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-6b5fc39bdd781711d7da8b95ae0243df3b35c5bf@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1337584373-2741-6-git-send-email-jolsa@redhat.com>
References: <1337584373-2741-6-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add hardcoded name term for pmu events
Git-Commit-ID: 6b5fc39bdd781711d7da8b95ae0243df3b35c5bf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 23 May 2012 08:20:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6b5fc39bdd781711d7da8b95ae0243df3b35c5bf
Gitweb:     http://git.kernel.org/tip/6b5fc39bdd781711d7da8b95ae0243df3b35c5bf
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 21 May 2012 09:12:53 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 22 May 2012 11:47:54 -0300

perf tools: Add hardcoded name term for pmu events

Adding a new hardcoded term 'name' allowing to specify a name for the
pmu event. The term is defined along with standard pmu terms. If no
'name' term is given, the event name follows following template:

    "raw 0x<perf_event_attr::config>"

running:
    perf stat -e cpu/config=1,name=krava1/u ls

will produce following output:
    ...
    Performance counter stats for 'ls':
                 0 krava1
    ...

running:
    perf stat -e cpu/config=1/u ls

will produce following output:
    ...
    Performance counter stats for 'ls':
                 0 raw 0x1
    ...

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1337584373-2741-6-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events-test.c |   25 +++++++++++++++++++++++++
 tools/perf/util/parse-events.c      |   23 ++++++++++++++++++++++-
 tools/perf/util/parse-events.h      |    1 +
 tools/perf/util/parse-events.l      |    1 +
 tools/perf/util/parse-events.y      |    8 ++++++++
 tools/perf/util/pmu.c               |    4 ++--
 6 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index 2e8f435..76b98e2 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -409,6 +409,27 @@ static int test__checkevent_list(struct perf_evlist *evlist)
 	return 0;
 }
 
+static int test__checkevent_pmu_name(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+
+	/* cpu/config=1,name=krava1/u */
+	evsel = list_entry(evlist->entries.next, struct perf_evsel, node);
+	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",  1 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong name", !strcmp(evsel->name, "krava"));
+
+	/* cpu/config=2/" */
+	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
+	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",  2 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong name", !strcmp(evsel->name, "raw 0x2"));
+
+	return 0;
+}
+
 struct test__event_st {
 	const char *name;
 	__u32 type;
@@ -529,6 +550,10 @@ static struct test__event_st test__events_pmu[] = {
 		.name  = "cpu/config=10,config1,config2=3,period=1000/u",
 		.check = test__checkevent_pmu,
 	},
+	[1] = {
+		.name  = "cpu/config=1,name=krava/u,cpu/config=2/u",
+		.check = test__checkevent_pmu_name,
+	},
 };
 
 #define TEST__EVENTS_PMU_CNT (sizeof(test__events_pmu) / \
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 59324e7..fac7d59 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -634,6 +634,9 @@ do {								\
 		 * attr->branch_sample_type = term->val.num;
 		 */
 		break;
+	case PARSE_EVENTS__TERM_TYPE_NAME:
+		CHECK_TYPE_VAL(STR);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -672,6 +675,23 @@ int parse_events_add_numeric(struct list_head **list, int *idx,
 			 (char *) __event_name(type, config));
 }
 
+static int parse_events__is_name_term(struct parse_events__term *term)
+{
+	return term->type_term == PARSE_EVENTS__TERM_TYPE_NAME;
+}
+
+static char *pmu_event_name(struct perf_event_attr *attr,
+			    struct list_head *head_terms)
+{
+	struct parse_events__term *term;
+
+	list_for_each_entry(term, head_terms, list)
+		if (parse_events__is_name_term(term))
+			return term->val.str;
+
+	return (char *) __event_name(PERF_TYPE_RAW, attr->config);
+}
+
 int parse_events_add_pmu(struct list_head **list, int *idx,
 			 char *name, struct list_head *head_config)
 {
@@ -693,7 +713,8 @@ int parse_events_add_pmu(struct list_head **list, int *idx,
 	if (perf_pmu__config(pmu, &attr, head_config))
 		return -EINVAL;
 
-	return add_event(list, idx, &attr, (char *) "pmu");
+	return add_event(list, idx, &attr,
+			 pmu_event_name(&attr, head_config));
 }
 
 void parse_events_update_lists(struct list_head *list_event,
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 25ae373..8cac57a 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -47,6 +47,7 @@ enum {
 	PARSE_EVENTS__TERM_TYPE_CONFIG,
 	PARSE_EVENTS__TERM_TYPE_CONFIG1,
 	PARSE_EVENTS__TERM_TYPE_CONFIG2,
+	PARSE_EVENTS__TERM_TYPE_NAME,
 	PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD,
 	PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE,
 };
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 331d28a..618a8e7 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -105,6 +105,7 @@ misses|miss				{ return str(PE_NAME_CACHE_OP_RESULT); }
 config			{ return term(PARSE_EVENTS__TERM_TYPE_CONFIG); }
 config1			{ return term(PARSE_EVENTS__TERM_TYPE_CONFIG1); }
 config2			{ return term(PARSE_EVENTS__TERM_TYPE_CONFIG2); }
+name			{ return term(PARSE_EVENTS__TERM_TYPE_NAME); }
 period			{ return term(PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD); }
 branch_type		{ return term(PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE); }
 
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 126fad0..362cc59 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -237,6 +237,14 @@ PE_NAME
 	$$ = term;
 }
 |
+PE_TERM '=' PE_NAME
+{
+	struct parse_events__term *term;
+
+	ABORT_ON(parse_events__term_str(&term, $1, NULL, $3));
+	$$ = term;
+}
+|
 PE_TERM '=' PE_VALUE
 {
 	struct parse_events__term *term;
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 8ee219b..a119a53 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -258,9 +258,9 @@ static int pmu_config_term(struct list_head *formats,
 static int pmu_config(struct list_head *formats, struct perf_event_attr *attr,
 		      struct list_head *head_terms)
 {
-	struct parse_events__term *term, *h;
+	struct parse_events__term *term;
 
-	list_for_each_entry_safe(term, h, head_terms, list)
+	list_for_each_entry(term, head_terms, list)
 		if (pmu_config_term(formats, attr, term))
 			return -EINVAL;
 
