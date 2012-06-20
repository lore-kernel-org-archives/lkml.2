Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab2FTLBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 07:01:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34693 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2FTLBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 07:01:38 -0400
Date: Wed, 20 Jun 2012 04:01:23 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-4429392e1484319df4209d41a98244c76d0caf56@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1339741902-8449-14-git-send-email-zheng.z.yan@intel.com>
References: <1339741902-8449-14-git-send-email-zheng.z.yan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/tool:
  Add automated test for pure terms parsing
Git-Commit-ID: 4429392e1484319df4209d41a98244c76d0caf56
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 04:01:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4429392e1484319df4209d41a98244c76d0caf56
Gitweb:     http://git.kernel.org/tip/4429392e1484319df4209d41a98244c76d0caf56
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 15 Jun 2012 14:31:42 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 18 Jun 2012 12:13:26 +0200

perf/tool: Add automated test for pure terms parsing

Adding automated test for parsing terms out of the event grammar.
Also slightly changing current event parsing test functions to
follow up more generic namespace.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1339741902-8449-14-git-send-email-zheng.z.yan@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/util/parse-events-test.c |  122 +++++++++++++++++++++++++++++++++--
 1 files changed, 117 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index 76b98e2..af1039c 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -430,6 +430,49 @@ static int test__checkevent_pmu_name(struct perf_evlist *evlist)
 	return 0;
 }
 
+static int test__checkterms_simple(struct list_head *terms)
+{
+	struct parse_events__term *term;
+
+	/* config=10 */
+	term = list_entry(terms->next, struct parse_events__term, list);
+	TEST_ASSERT_VAL("wrong type term",
+			term->type_term == PARSE_EVENTS__TERM_TYPE_CONFIG);
+	TEST_ASSERT_VAL("wrong type val",
+			term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
+	TEST_ASSERT_VAL("wrong val", term->val.num == 10);
+	TEST_ASSERT_VAL("wrong config", !term->config);
+
+	/* config1 */
+	term = list_entry(term->list.next, struct parse_events__term, list);
+	TEST_ASSERT_VAL("wrong type term",
+			term->type_term == PARSE_EVENTS__TERM_TYPE_CONFIG1);
+	TEST_ASSERT_VAL("wrong type val",
+			term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
+	TEST_ASSERT_VAL("wrong val", term->val.num == 1);
+	TEST_ASSERT_VAL("wrong config", !term->config);
+
+	/* config2=3 */
+	term = list_entry(term->list.next, struct parse_events__term, list);
+	TEST_ASSERT_VAL("wrong type term",
+			term->type_term == PARSE_EVENTS__TERM_TYPE_CONFIG2);
+	TEST_ASSERT_VAL("wrong type val",
+			term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
+	TEST_ASSERT_VAL("wrong val", term->val.num == 3);
+	TEST_ASSERT_VAL("wrong config", !term->config);
+
+	/* umask=1*/
+	term = list_entry(term->list.next, struct parse_events__term, list);
+	TEST_ASSERT_VAL("wrong type term",
+			term->type_term == PARSE_EVENTS__TERM_TYPE_USER);
+	TEST_ASSERT_VAL("wrong type val",
+			term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
+	TEST_ASSERT_VAL("wrong val", term->val.num == 1);
+	TEST_ASSERT_VAL("wrong config", !strcmp(term->config, "umask"));
+
+	return 0;
+}
+
 struct test__event_st {
 	const char *name;
 	__u32 type;
@@ -559,7 +602,23 @@ static struct test__event_st test__events_pmu[] = {
 #define TEST__EVENTS_PMU_CNT (sizeof(test__events_pmu) / \
 			      sizeof(struct test__event_st))
 
-static int test(struct test__event_st *e)
+struct test__term {
+	const char *str;
+	__u32 type;
+	int (*check)(struct list_head *terms);
+};
+
+static struct test__term test__terms[] = {
+	[0] = {
+		.str   = "config=10,config1,config2=3,umask=1",
+		.check = test__checkterms_simple,
+	},
+};
+
+#define TEST__TERMS_CNT (sizeof(test__terms) / \
+			 sizeof(struct test__term))
+
+static int test_event(struct test__event_st *e)
 {
 	struct perf_evlist *evlist;
 	int ret;
@@ -590,7 +649,48 @@ static int test_events(struct test__event_st *events, unsigned cnt)
 		struct test__event_st *e = &events[i];
 
 		pr_debug("running test %d '%s'\n", i, e->name);
-		ret = test(e);
+		ret = test_event(e);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+static int test_term(struct test__term *t)
+{
+	struct list_head *terms;
+	int ret;
+
+	terms = malloc(sizeof(*terms));
+	if (!terms)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(terms);
+
+	ret = parse_events_terms(terms, t->str);
+	if (ret) {
+		pr_debug("failed to parse terms '%s', err %d\n",
+			 t->str , ret);
+		return ret;
+	}
+
+	ret = t->check(terms);
+	parse_events__free_terms(terms);
+
+	return ret;
+}
+
+static int test_terms(struct test__term *terms, unsigned cnt)
+{
+	int ret = 0;
+	unsigned i;
+
+	for (i = 0; i < cnt; i++) {
+		struct test__term *t = &terms[i];
+
+		pr_debug("running test %d '%s'\n", i, t->str);
+		ret = test_term(t);
 		if (ret)
 			break;
 	}
@@ -617,9 +717,21 @@ int parse_events__test(void)
 {
 	int ret;
 
-	ret = test_events(test__events, TEST__EVENTS_CNT);
-	if (!ret && test_pmu())
-		ret = test_events(test__events_pmu, TEST__EVENTS_PMU_CNT);
+	do {
+		ret = test_events(test__events, TEST__EVENTS_CNT);
+		if (ret)
+			break;
+
+		if (test_pmu()) {
+			ret = test_events(test__events_pmu,
+					  TEST__EVENTS_PMU_CNT);
+			if (ret)
+				break;
+		}
+
+		ret = test_terms(test__terms, TEST__TERMS_CNT);
+
+	} while (0);
 
 	return ret;
 }
