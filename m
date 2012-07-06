Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab2GFK51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:57:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51462 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab2GFK5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:57:25 -0400
Date: Fri, 6 Jul 2012 03:57:07 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-7582732f57e547929d4c65ad8e38f3446e0538d8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, bookjovi@gmail.com, jolsa@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, bookjovi@gmail.com,
        tglx@linutronix.de
In-Reply-To: <20120629072254.GA940@krava.brq.redhat.com>
References: <20120629072254.GA940@krava.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix hw breakpoint'
 s type modifier parsing
Git-Commit-ID: 7582732f57e547929d4c65ad8e38f3446e0538d8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 03:57:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7582732f57e547929d4c65ad8e38f3446e0538d8
Gitweb:     http://git.kernel.org/tip/7582732f57e547929d4c65ad8e38f3446e0538d8
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 29 Jun 2012 09:22:54 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 29 Jun 2012 13:28:13 -0300

perf tools: Fix hw breakpoint's type modifier parsing

Fixing the hw breakpoint's type modifier parsing to allow all possible
combinations of 'rwx' characters.

Adding automated tests to the parsing test suite.

Reported-by: Jovi Zhang <bookjovi@gmail.com>
Original-patch-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Jovi Zhang <bookjovi@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120629072254.GA940@krava.brq.redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events-test.c |   37 +++++++++++++++++++++++++++++++++++
 tools/perf/util/parse-events.c      |   16 ++++++++++++--
 tools/perf/util/parse-events.l      |    2 +-
 3 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index a0f61a2..de81fe1 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -181,6 +181,22 @@ static int test__checkevent_breakpoint_w(struct perf_evlist *evlist)
 	return 0;
 }
 
+static int test__checkevent_breakpoint_rw(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type",
+			PERF_TYPE_BREAKPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong bp_type",
+		(HW_BREAKPOINT_R|HW_BREAKPOINT_W) == evsel->attr.bp_type);
+	TEST_ASSERT_VAL("wrong bp_len",
+			HW_BREAKPOINT_LEN_4 == evsel->attr.bp_len);
+	return 0;
+}
+
 static int test__checkevent_tracepoint_modifier(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel = list_entry(evlist->entries.next,
@@ -352,6 +368,19 @@ static int test__checkevent_breakpoint_w_modifier(struct perf_evlist *evlist)
 	return test__checkevent_breakpoint_w(evlist);
 }
 
+static int test__checkevent_breakpoint_rw_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+
+	return test__checkevent_breakpoint_rw(evlist);
+}
+
 static int test__checkevent_pmu(struct perf_evlist *evlist)
 {
 
@@ -585,6 +614,14 @@ static struct test__event_st test__events[] = {
 		.name  = "instructions:H",
 		.check = test__checkevent_exclude_guest_modifier,
 	},
+	[26] = {
+		.name  = "mem:0:rw",
+		.check = test__checkevent_breakpoint_rw,
+	},
+	[27] = {
+		.name  = "mem:0:rw:kp",
+		.check = test__checkevent_breakpoint_rw_modifier,
+	},
 };
 
 #define TEST__EVENTS_CNT (sizeof(test__events) / sizeof(struct test__event_st))
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 0cc27da..7ae76af 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -383,21 +383,31 @@ parse_breakpoint_type(const char *type, struct perf_event_attr *attr)
 		if (!type || !type[i])
 			break;
 
+#define CHECK_SET_TYPE(bit)		\
+do {					\
+	if (attr->bp_type & bit)	\
+		return -EINVAL;		\
+	else				\
+		attr->bp_type |= bit;	\
+} while (0)
+
 		switch (type[i]) {
 		case 'r':
-			attr->bp_type |= HW_BREAKPOINT_R;
+			CHECK_SET_TYPE(HW_BREAKPOINT_R);
 			break;
 		case 'w':
-			attr->bp_type |= HW_BREAKPOINT_W;
+			CHECK_SET_TYPE(HW_BREAKPOINT_W);
 			break;
 		case 'x':
-			attr->bp_type |= HW_BREAKPOINT_X;
+			CHECK_SET_TYPE(HW_BREAKPOINT_X);
 			break;
 		default:
 			return -EINVAL;
 		}
 	}
 
+#undef CHECK_SET_TYPE
+
 	if (!attr->bp_type) /* Default */
 		attr->bp_type = HW_BREAKPOINT_R | HW_BREAKPOINT_W;
 
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 488362e..a066894 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -76,7 +76,7 @@ num_hex		0x[a-fA-F0-9]+
 num_raw_hex	[a-fA-F0-9]+
 name		[a-zA-Z_*?][a-zA-Z0-9_*?]*
 modifier_event	[ukhpGH]{1,8}
-modifier_bp	[rwx]
+modifier_bp	[rwx]{1,3}
 
 %%
 
