Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039Ab2DYNt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 09:49:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44452 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab2DYNt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 09:49:27 -0400
Date: Wed, 25 Apr 2012 06:49:10 -0700
From: tip-bot for Gleb Natapov <gleb@redhat.com>
Message-ID: <tip-e7c72d888dac2c81003401d663bd8abd68e7c5cd@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, gleb@redhat.com, tglx@linutronix.de, avi@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, gleb@redhat.com, tglx@linutronix.de, avi@redhat.com
In-Reply-To: <20120417111345.GK11918@redhat.com>
References: <20120417111345.GK11918@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Add 'G' and 'H'
  modifiers to event parsing
Git-Commit-ID: e7c72d888dac2c81003401d663bd8abd68e7c5cd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 25 Apr 2012 06:49:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e7c72d888dac2c81003401d663bd8abd68e7c5cd
Gitweb:     http://git.kernel.org/tip/e7c72d888dac2c81003401d663bd8abd68e7c5cd
Author:     Gleb Natapov <gleb@redhat.com>
AuthorDate: Tue, 17 Apr 2012 14:13:45 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 17 Apr 2012 11:20:23 -0300

perf tools: Add 'G' and 'H' modifiers to event parsing

They were dropped during conversion of event parser. Add test case to
make sure this will not happen again.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/20120417111345.GK11918@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c      |   30 ++++++++++++++++++++++++++++++
 tools/perf/util/parse-events.l |    2 +-
 2 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 1c5b980..223ffdc 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -851,6 +851,28 @@ static int test__checkevent_symbolic_name_modifier(struct perf_evlist *evlist)
 	return test__checkevent_symbolic_name(evlist);
 }
 
+static int test__checkevent_exclude_host_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
+
+	return test__checkevent_symbolic_name(evlist);
+}
+
+static int test__checkevent_exclude_guest_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+
+	return test__checkevent_symbolic_name(evlist);
+}
+
 static int test__checkevent_symbolic_alias_modifier(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel = list_entry(evlist->entries.next,
@@ -1091,6 +1113,14 @@ static struct test__event_st {
 		.name  = "r1,syscalls:sys_enter_open:k,1:1:hp",
 		.check = test__checkevent_list,
 	},
+	{
+		.name  = "instructions:G",
+		.check = test__checkevent_exclude_host_modifier,
+	},
+	{
+		.name  = "instructions:H",
+		.check = test__checkevent_exclude_guest_modifier,
+	},
 };
 
 #define TEST__EVENTS_CNT (sizeof(test__events) / sizeof(struct test__event_st))
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 05d766e..1fcf1bb 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -54,7 +54,7 @@ num_dec		[0-9]+
 num_hex		0x[a-fA-F0-9]+
 num_raw_hex	[a-fA-F0-9]+
 name		[a-zA-Z_*?][a-zA-Z0-9_*?]*
-modifier_event	[ukhp]{1,5}
+modifier_event	[ukhpGH]{1,8}
 modifier_bp	[rwx]
 
 %%
