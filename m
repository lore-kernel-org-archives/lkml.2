Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab2JTOfR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 10:35:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755749Ab2JTOdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 10:33:53 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 08/11] perf tool: Add 'S' event/group modifier to read sample value
Date: Sat, 20 Oct 2012 16:33:16 +0200
Message-Id: <1350743599-4805-9-git-send-email-jolsa@redhat.com>
In-Reply-To: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding 'S' event/group modifier to specify that the event value/s
are read by PERF_SAMPLE_READ sample type processing, instead of the
period value offered by lower layers.

There's additional behaviour change for 'S' modifier being specified
on event group:

Currently all the events within a group makes samples. If user now
specifies 'S' within group modifier, only the leader will trigger
samples. The rest of events in the group will have sampling disabled.

And same as for single events, values of all events within the group
(including leader) are read by PERF_SAMPLE_READ sample type processing.

Following example will create event group with cycles and cache-misses
events, setting the cycles as group leader and the only event to actually
sample. Both cycles and cache-misses event period values are read by
PERF_SAMPLE_READ sample type processing with PERF_FORMAT_GROUP read format.

  $ perf record -e '{cycles,cache-misses}:S' ls

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-list.txt |  1 +
 tools/perf/util/evsel.c                | 25 +++++++++++++++++++++++++
 tools/perf/util/evsel.h                |  1 +
 tools/perf/util/parse-events.c         |  6 ++++++
 tools/perf/util/parse-events.l         |  2 +-
 5 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index d1e39dc..7ddef65 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -29,6 +29,7 @@ counted. The following modifiers exist:
  G - guest counting (in KVM guests)
  H - host counting (not in KVM guests)
  p - precise level
+ S - read sample value (PERF_SAMPLE_READ)
 
 The 'p' modifier can be used for specifying how precise the instruction
 address should be. The 'p' modifier can be specified multiple times:
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index f37bec0..836a786 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -432,6 +432,7 @@ int perf_evsel__group_desc(struct perf_evsel *evsel, char *buf, size_t size)
 void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
 			struct perf_evsel *first)
 {
+	struct perf_evsel *leader = evsel->leader;
 	struct perf_event_attr *attr = &evsel->attr;
 	int track = !evsel->idx; /* only the first counter needs these */
 
@@ -442,6 +443,21 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
 			      PERF_FORMAT_TOTAL_TIME_RUNNING |
 			      PERF_FORMAT_ID;
 
+	if (evsel->sample_read) {
+		attr->sample_type |= PERF_SAMPLE_READ;
+
+		/*
+		 * Apply group format only if:
+		 * - we have a leader so there's a group and at
+		 *   least 2 events,
+		 * - we are a leader with more than 1 event
+		 */
+		if (evsel->leader || evsel->nr_members) {
+			attr->read_format |= PERF_FORMAT_GROUP;
+			attr->inherit = 0;
+		}
+	}
+
 	attr->sample_type  |= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
 
 	/*
@@ -459,6 +475,15 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
 		}
 	}
 
+	/*
+	 * We are safe here, because we have a leader so there's at
+	 * least 2 events in the group.
+	 */
+	if (leader && leader->sample_read) {
+		attr->sample_freq   = 0;
+		attr->sample_period = 0;
+	}
+
 	if (opts->no_samples)
 		attr->sample_freq = 0;
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 351b48e..1e34060 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -75,6 +75,7 @@ struct perf_evsel {
 	bool 			needs_swap;
 	/* parse modifier helper */
 	int			exclude_GH;
+	int			sample_read;
 	struct perf_evsel	*leader;
 	char			*group_name;
 	union {
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 364e518..5a6ca8a 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -642,6 +642,7 @@ struct event_modifier {
 	int eG;
 	int precise;
 	int exclude_GH;
+	int sample_read;
 };
 
 static int get_event_modifier(struct event_modifier *mod, char *str,
@@ -653,6 +654,7 @@ static int get_event_modifier(struct event_modifier *mod, char *str,
 	int eH = evsel ? evsel->attr.exclude_host : 0;
 	int eG = evsel ? evsel->attr.exclude_guest : 0;
 	int precise = evsel ? evsel->attr.precise_ip : 0;
+	int sample_read = 0;
 
 	int exclude = eu | ek | eh;
 	int exclude_GH = evsel ? evsel->exclude_GH : 0;
@@ -690,6 +692,8 @@ static int get_event_modifier(struct event_modifier *mod, char *str,
 			eH = 0;
 		} else if (*str == 'p') {
 			precise++;
+		} else if (*str == 'S') {
+			sample_read = 1;
 		} else
 			break;
 
@@ -716,6 +720,7 @@ static int get_event_modifier(struct event_modifier *mod, char *str,
 	mod->eG = eG;
 	mod->precise = precise;
 	mod->exclude_GH = exclude_GH;
+	mod->sample_read = sample_read;
 	return 0;
 }
 
@@ -742,6 +747,7 @@ int parse_events__modifier_event(struct list_head *list, char *str, bool add)
 		evsel->attr.exclude_host   = mod.eH;
 		evsel->attr.exclude_guest  = mod.eG;
 		evsel->exclude_GH          = mod.exclude_GH;
+		evsel->sample_read         = mod.sample_read;
 	}
 
 	return 0;
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index c87efc1..391aabb 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -81,7 +81,7 @@ num_dec		[0-9]+
 num_hex		0x[a-fA-F0-9]+
 num_raw_hex	[a-fA-F0-9]+
 name		[a-zA-Z_*?][a-zA-Z0-9_*?]*
-modifier_event	[ukhpGH]{1,8}
+modifier_event	[ukhpGHS]{1,9}
 modifier_bp	[rwx]{1,3}
 
 %%
-- 
1.7.11.4

