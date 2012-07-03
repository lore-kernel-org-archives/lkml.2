Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463Ab2GCWBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 18:01:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757320Ab2GCWBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 18:01:25 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 10/10] perf, test: Add automated tests for pmu sysfs translated events
Date: Wed,  4 Jul 2012 00:00:48 +0200
Message-Id: <1341352848-11833-11-git-send-email-jolsa@redhat.com>
In-Reply-To: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
References: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addint automated tests for following events:
  cpu/event=cycles/u
  cpu/event=instructions/u
  cpu/event=branch_instructions/u
  cpu/event=branch_misses/u
  cpu/event=bus_cycles/u
  cpu/event=cache_misses/u
  cpu/event=cache_references/u
  cpu/event=ref_cycles/u
  cpu/event=stalled_cycles_backend/u
  cpu/event=stalled_cycles_frontend/u
  /* dash variants */
  cpu/event=branch-instructions/u
  cpu/event=branch-misses/u
  cpu/event=bus-cycles/u
  cpu/event=cache-misses/u
  cpu/event=cache-references/u
  cpu/event=ref-cycles/u
  cpu/event=stalled-cycles-backend/u
  cpu/event=stalled-cycles-frontend/u

The 'event=xxx' term is translated to the cpu specific term.
We check the final perf_event_attr::config to follow this term.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/parse-events-test.c |  133 +++++++++++++++++++++++++++++++++++
 1 file changed, 133 insertions(+)

diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index ef5cce0..95a501d 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -431,6 +431,45 @@ static int test__checkevent_pmu_name(struct perf_evlist *evlist)
 	return 0;
 }
 
+static __u64 get_config(const char *file)
+{
+#define DATASIZE 64
+	char data[DATASIZE];
+	u64 config;
+
+	TEST_ASSERT_VAL("cannot read sysfs events data",
+			!sysfs_read_file(file, data, DATASIZE));
+
+	TEST_ASSERT_VAL("cannot parse sysfs events data",
+			1 == sscanf(data, "config=0x%" PRIx64 "\n", &config));
+
+	return config;
+#undef DATASIZE
+}
+
+#define TEST__CHECKEVENT_PMU_EVENTS(event)				     \
+static int  test__checkevent_pmu_events_##event(struct perf_evlist *evlist)  \
+{									     \
+	struct perf_evsel *evsel;					     \
+	u64 config = get_config("devices/cpu/events/" # event);		     \
+	evsel = list_entry(evlist->entries.next, struct perf_evsel, node);   \
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries); \
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);    \
+	TEST_ASSERT_VAL("wrong config", evsel->attr.config == config);	     \
+	return 0;							     \
+}
+
+TEST__CHECKEVENT_PMU_EVENTS(cycles)
+TEST__CHECKEVENT_PMU_EVENTS(instructions)
+TEST__CHECKEVENT_PMU_EVENTS(branch_instructions)
+TEST__CHECKEVENT_PMU_EVENTS(branch_misses)
+TEST__CHECKEVENT_PMU_EVENTS(bus_cycles)
+TEST__CHECKEVENT_PMU_EVENTS(cache_misses)
+TEST__CHECKEVENT_PMU_EVENTS(cache_references)
+TEST__CHECKEVENT_PMU_EVENTS(ref_cycles)
+TEST__CHECKEVENT_PMU_EVENTS(stalled_cycles_backend)
+TEST__CHECKEVENT_PMU_EVENTS(stalled_cycles_frontend)
+
 static int test__checkterms_simple(struct list_head *terms)
 {
 	struct parse_events__term *term;
@@ -598,6 +637,82 @@ static struct test__event_st test__events_pmu[] = {
 	},
 };
 
+static struct test__event_st test__events_pmu_events[] = {
+	[0] = {
+		.name  = "cpu/event=cycles/u",
+		.check = test__checkevent_pmu_events_cycles,
+	},
+	[1] = {
+		.name  = "cpu/event=instructions/u",
+		.check = test__checkevent_pmu_events_instructions,
+	},
+	[2] = {
+		.name  = "cpu/event=branch_instructions/u",
+		.check = test__checkevent_pmu_events_branch_instructions,
+	},
+	[3] = {
+		.name  = "cpu/event=branch_misses/u",
+		.check = test__checkevent_pmu_events_branch_misses,
+	},
+	[4] = {
+		.name  = "cpu/event=bus_cycles/u",
+		.check = test__checkevent_pmu_events_bus_cycles,
+	},
+	[5] = {
+		.name  = "cpu/event=cache_misses/u",
+		.check = test__checkevent_pmu_events_cache_misses,
+	},
+	[6] = {
+		.name  = "cpu/event=cache_references/u",
+		.check = test__checkevent_pmu_events_cache_references,
+	},
+	[7] = {
+		.name  = "cpu/event=ref_cycles/u",
+		.check = test__checkevent_pmu_events_ref_cycles,
+	},
+	[8] = {
+		.name  = "cpu/event=stalled_cycles_backend/u",
+		.check = test__checkevent_pmu_events_stalled_cycles_backend,
+	},
+	[9] = {
+		.name  = "cpu/event=stalled_cycles_frontend/u",
+		.check = test__checkevent_pmu_events_stalled_cycles_frontend,
+	},
+	/* dash variants */
+	[10] = {
+		.name  = "cpu/event=branch-instructions/u",
+		.check = test__checkevent_pmu_events_branch_instructions,
+	},
+	[11] = {
+		.name  = "cpu/event=branch-misses/u",
+		.check = test__checkevent_pmu_events_branch_misses,
+	},
+	[12] = {
+		.name  = "cpu/event=bus-cycles/u",
+		.check = test__checkevent_pmu_events_bus_cycles,
+	},
+	[13] = {
+		.name  = "cpu/event=cache-misses/u",
+		.check = test__checkevent_pmu_events_cache_misses,
+	},
+	[14] = {
+		.name  = "cpu/event=cache-references/u",
+		.check = test__checkevent_pmu_events_cache_references,
+	},
+	[15] = {
+		.name  = "cpu/event=ref-cycles/u",
+		.check = test__checkevent_pmu_events_ref_cycles,
+	},
+	[16] = {
+		.name  = "cpu/event=stalled-cycles-backend/u",
+		.check = test__checkevent_pmu_events_stalled_cycles_backend,
+	},
+	[17] = {
+		.name  = "cpu/event=stalled-cycles-frontend/u",
+		.check = test__checkevent_pmu_events_stalled_cycles_frontend,
+	},
+};
+
 struct test__term {
 	const char *str;
 	__u32 type;
@@ -709,6 +824,21 @@ static int test_pmu(void)
 	return !ret;
 }
 
+static int test_pmu_events(void)
+{
+	struct stat st;
+	char path[PATH_MAX];
+	int ret;
+
+	snprintf(path, PATH_MAX, "%s/bus/event_source/devices/cpu/events/",
+		 sysfs_find_mountpoint());
+
+	ret = stat(path, &st);
+	if (ret)
+		pr_debug("ommiting PMU cpu events tests\n");
+	return !ret;
+}
+
 int parse_events__test(void)
 {
 	int ret;
@@ -725,5 +855,8 @@ do {							\
 	if (test_pmu())
 		TEST_EVENTS(test__events_pmu);
 
+	if (test_pmu() && test_pmu_events())
+		TEST_EVENTS(test__events_pmu_events);
+
 	return test_terms(test__terms, ARRAY_SIZE(test__terms));
 }
-- 
1.7.10.4

