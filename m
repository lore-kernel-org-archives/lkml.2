Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab2DQLNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 07:13:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302Ab2DQLNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 07:13:49 -0400
Date: Tue, 17 Apr 2012 14:13:45 +0300
From: Gleb Natapov <gleb@redhat.com>
To: acme@ghostprotocols.net
Cc: a.p.zijlstra@chello.nl, mingo@redhat.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, avi@redhat.com
Subject: [PATCHv2] perf tools: Add 'G' and 'H' modifiers to event parsing
Message-ID: <20120417111345.GK11918@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They were dropped during conversion of event parser. Add test case to
make sure this will not happen again.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
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
--
			Gleb.
