Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934601Ab2JXKLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:11:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55294 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684Ab2JXKK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:10:58 -0400
Date: Wed, 24 Oct 2012 03:09:33 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-3f3a20648797c3ff49c6ebfe10747ef0acd37c50@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, acme@ghostprotocols.net,
        jolsa@redhat.com, fweisbec@gmail.com, akpm@linux-foundation.org,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, jolsa@redhat.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1349873598-12583-9-git-send-email-jolsa@redhat.com>
References: <1349873598-12583-9-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test:
  Add automated tests for pmu sysfs translated events
Git-Commit-ID: 3f3a20648797c3ff49c6ebfe10747ef0acd37c50
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 03:09:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3f3a20648797c3ff49c6ebfe10747ef0acd37c50
Gitweb:     http://git.kernel.org/tip/3f3a20648797c3ff49c6ebfe10747ef0acd37c50
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 10 Oct 2012 14:53:18 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 10:41:27 +0200

perf test: Add automated tests for pmu sysfs translated events

Add automated tests for all events found under PMU/events
directory. Tested events are in the 'cpu/event=xxx/u' format,
where 'xxx' is substituted by every event found.

The 'event=xxx' term is translated to the cpu specific term.
We only check that the event is created (not the real config
numbers) and that the modifier is properly set.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1349873598-12583-9-git-send-email-jolsa@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/util/parse-events-test.c |   68 +++++++++++++++++++++++++++++++++++
 1 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index 516ecd9..b49c2ee 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -443,6 +443,23 @@ static int test__checkevent_pmu_name(struct perf_evlist *evlist)
 	return 0;
 }
 
+static int test__checkevent_pmu_events(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+
+	evsel = list_entry(evlist->entries.next, struct perf_evsel, node);
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong exclude_user",
+			!evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel",
+			evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	return 0;
+}
+
 static int test__checkterms_simple(struct list_head *terms)
 {
 	struct parse_events__term *term;
@@ -1024,6 +1041,51 @@ static int test_pmu(void)
 	return !ret;
 }
 
+static int test_pmu_events(void)
+{
+	struct stat st;
+	char path[PATH_MAX];
+	struct dirent *ent;
+	DIR *dir;
+	int ret;
+
+	snprintf(path, PATH_MAX, "%s/bus/event_source/devices/cpu/events/",
+		 sysfs_find_mountpoint());
+
+	ret = stat(path, &st);
+	if (ret) {
+		pr_debug("ommiting PMU cpu events tests\n");
+		return 0;
+	}
+
+	dir = opendir(path);
+	if (!dir) {
+		pr_debug("can't open pmu event dir");
+		return -1;
+	}
+
+	while (!ret && (ent = readdir(dir))) {
+#define MAX_NAME 100
+		struct test__event_st e;
+		char name[MAX_NAME];
+
+		if (!strcmp(ent->d_name, ".") ||
+		    !strcmp(ent->d_name, ".."))
+			continue;
+
+		snprintf(name, MAX_NAME, "cpu/event=%s/u", ent->d_name);
+
+		e.name  = name;
+		e.check = test__checkevent_pmu_events;
+
+		ret = test_event(&e);
+#undef MAX_NAME
+	}
+
+	closedir(dir);
+	return ret;
+}
+
 int parse_events__test(void)
 {
 	int ret1, ret2 = 0;
@@ -1040,6 +1102,12 @@ do {							\
 	if (test_pmu())
 		TEST_EVENTS(test__events_pmu);
 
+	if (test_pmu()) {
+		int ret = test_pmu_events();
+		if (ret)
+			return ret;
+	}
+
 	ret1 = test_terms(test__terms, ARRAY_SIZE(test__terms));
 	if (!ret2)
 		ret2 = ret1;
