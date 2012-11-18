Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab2KROgf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 09:36:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36551 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab2KROaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 09:30:15 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 32/32] perf evsel: Introduce is_group_member method
Date: Sun, 18 Nov 2012 11:29:57 -0300
Message-Id: <1353248997-30763-33-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1353248997-30763-1-git-send-email-acme@infradead.org>
References: <1353248997-30763-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

To clarify what is being tested, instead of assuming that evsel->leader
== NULL means either an 'isolated' evsel or a 'group leader'.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-lvdbvimaxw9nc5een5vmem0c@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c       |    3 ++-
 tools/perf/tests/parse-events.c |   20 ++++++++++----------
 tools/perf/util/evlist.c        |    4 ++--
 tools/perf/util/evsel.c         |    6 +++---
 tools/perf/util/evsel.h         |    6 ++++++
 5 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 557081e..c247fac 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -152,7 +152,8 @@ retry:
 		return 0;
 	}
 
-	if (!perf_target__has_task(&target) && (!evsel->leader)) {
+	if (!perf_target__has_task(&target) &&
+	    !perf_evsel__is_group_member(evsel)) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index f2a82d0..42a0c8c 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -521,7 +521,7 @@ static int test__group1(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+	TEST_ASSERT_VAL("wrong leader", !perf_evsel__is_group_member(evsel));
 
 	/* cycles:upp */
 	evsel = perf_evsel__next(evsel);
@@ -557,7 +557,7 @@ static int test__group2(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+	TEST_ASSERT_VAL("wrong leader", !perf_evsel__is_group_member(evsel));
 
 	/* cache-references + :u modifier */
 	evsel = perf_evsel__next(evsel);
@@ -583,7 +583,7 @@ static int test__group2(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+	TEST_ASSERT_VAL("wrong leader", !perf_evsel__is_group_member(evsel));
 
 	return 0;
 }
@@ -606,7 +606,7 @@ static int test__group3(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+	TEST_ASSERT_VAL("wrong leader", !perf_evsel__is_group_member(evsel));
 	TEST_ASSERT_VAL("wrong group name",
 		!strcmp(leader->group_name, "group1"));
 
@@ -636,7 +636,7 @@ static int test__group3(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
 	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+	TEST_ASSERT_VAL("wrong leader", !perf_evsel__is_group_member(evsel));
 	TEST_ASSERT_VAL("wrong group name",
 		!strcmp(leader->group_name, "group2"));
 
@@ -663,7 +663,7 @@ static int test__group3(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+	TEST_ASSERT_VAL("wrong leader", !perf_evsel__is_group_member(evsel));
 
 	return 0;
 }
@@ -687,7 +687,7 @@ static int test__group4(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 1);
 	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+	TEST_ASSERT_VAL("wrong leader", !perf_evsel__is_group_member(evsel));
 
 	/* instructions:kp + p */
 	evsel = perf_evsel__next(evsel);
@@ -724,7 +724,7 @@ static int test__group5(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+	TEST_ASSERT_VAL("wrong leader", !perf_evsel__is_group_member(evsel));
 
 	/* instructions + G */
 	evsel = perf_evsel__next(evsel);
@@ -751,7 +751,7 @@ static int test__group5(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+	TEST_ASSERT_VAL("wrong leader", !perf_evsel__is_group_member(evsel));
 
 	/* instructions:G */
 	evsel = perf_evsel__next(evsel);
@@ -777,7 +777,7 @@ static int test__group5(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+	TEST_ASSERT_VAL("wrong leader", !perf_evsel__is_group_member(evsel));
 
 	return 0;
 }
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index e9d2d5d..7052934 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -222,7 +222,7 @@ void perf_evlist__disable(struct perf_evlist *evlist)
 
 	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
 		list_for_each_entry(pos, &evlist->entries, node) {
-			if (pos->leader)
+			if (perf_evsel__is_group_member(pos))
 				continue;
 			for (thread = 0; thread < evlist->threads->nr; thread++)
 				ioctl(FD(pos, cpu, thread),
@@ -238,7 +238,7 @@ void perf_evlist__enable(struct perf_evlist *evlist)
 
 	for (cpu = 0; cpu < cpu_map__nr(evlist->cpus); cpu++) {
 		list_for_each_entry(pos, &evlist->entries, node) {
-			if (pos->leader)
+			if (perf_evsel__is_group_member(pos))
 				continue;
 			for (thread = 0; thread < evlist->threads->nr; thread++)
 				ioctl(FD(pos, cpu, thread),
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index fc4faaa..1fb636c 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -519,14 +519,14 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	 * Disabling only independent events or group leaders,
 	 * keeping group members enabled.
 	 */
-	if (!evsel->leader)
+	if (!perf_evsel__is_group_member(evsel))
 		attr->disabled = 1;
 
 	/*
 	 * Setting enable_on_exec for independent events and
 	 * group leaders for traced executed by perf.
 	 */
-	if (perf_target__none(&opts->target) && (!evsel->leader))
+	if (perf_target__none(&opts->target) && !perf_evsel__is_group_member(evsel))
 		attr->enable_on_exec = 1;
 }
 
@@ -707,7 +707,7 @@ static int get_group_fd(struct perf_evsel *evsel, int cpu, int thread)
 	struct perf_evsel *leader = evsel->leader;
 	int fd;
 
-	if (!leader)
+	if (!perf_evsel__is_group_member(evsel))
 		return -1;
 
 	/*
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 32d7ec7..a4c1dd4 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -3,6 +3,7 @@
 
 #include <linux/list.h>
 #include <stdbool.h>
+#include <stddef.h>
 #include "../../../include/uapi/linux/perf_event.h"
 #include "types.h"
 #include "xyarray.h"
@@ -224,4 +225,9 @@ static inline struct perf_evsel *perf_evsel__next(struct perf_evsel *evsel)
 {
 	return list_entry(evsel->node.next, struct perf_evsel, node);
 }
+
+static inline bool perf_evsel__is_group_member(const struct perf_evsel *evsel)
+{
+	return evsel->leader != NULL;
+}
 #endif /* __PERF_EVSEL_H */
-- 
1.7.9.2.358.g22243

