Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab0H3MOB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 08:14:01 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:39392 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755573Ab0H3MN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 08:13:59 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Robert Richter <robert.richter@amd.com>,
        Lin Ming <ming.m.lin@intel.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [RFC][PATCH 5/5] perf: Add support for PERF_SAMPLE_READ samples
Date: Mon, 30 Aug 2010 13:13:47 +0100
Message-Id: <cad89c4291aeef68331fb71f174ad2005ea34399.1283123521.git.matt@console-pimps.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1283123521.git.matt@console-pimps.org>
References: <cover.1283123521.git.matt@console-pimps.org>
In-Reply-To: <cover.1283123521.git.matt@console-pimps.org>
References: <cover.1283123521.git.matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the counter values from PERF_SAMPLE_READ samples and weighting
them by the hrtimer period we can approximate a counter with a PMI. By
following how fast a counter varies over a hrtimer period we can figure
out which functions are causing the counters to change the fastest.

Suppose you have a workload consisting of two main parts:

  my_important_work()
  {
     load_my_data();
     compute_me_silly();
  }

Now, lets assume that both these functions take the same time to
complete for each part of work. In that case a periodic timer generate
samples that are about 50/50 distributed between these two functions.

Now, let us further assume that load_my_data() is so slow because its
missing all the caches and compute_me_silly() is slow because its
defeating the branch predictor.

So what we end up with, is that when we sample for cache-misses we get
load_my_data() as the predominant function, not a nice 50/50
relation. Idem for branch misses and compute_me_silly().

By weighting the samples by the hw counter delta we get this, if we
assume that the sampling frequency is not a harmonic of the runtime of
these functions, then statistics will dtrt.

Signed-off-by: Matt Fleming <matt@console-pimps.org>
---
 tools/perf/builtin-record.c |   70 ++++++++++++++++++++++++++++++++++++++-----
 tools/perf/builtin-report.c |   19 ++++++++++-
 tools/perf/util/event.c     |    7 +++-
 tools/perf/util/event.h     |   15 +++++++++
 4 files changed, 99 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index b530bee..4bd7c4a 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -224,20 +224,43 @@ static struct perf_header_attr *get_header_attr(struct perf_event_attr *a, int n
 	return h_attr;
 }
 
+struct read_format_single {
+	u64 count;
+	u64 time_enabled;
+	u64 time_running;
+	u64 id;
+};
+
+struct group_entry {
+	u64 value;
+	u64 id;
+};
+
+struct read_format_group {
+	u64 nr;
+	u64 time_enabled;
+	u64 time_running;
+	struct group_entry cntr[0];
+};
+
 static void create_counter(int counter, int cpu)
 {
 	char *filter = filters[counter];
 	struct perf_event_attr *attr = attrs + counter;
 	struct perf_header_attr *h_attr;
 	int track = !counter; /* only the first counter needs these */
+	size_t read_data_sz;
+	void *read_data;
 	int thread_index;
 	int ret;
-	struct {
-		u64 count;
-		u64 time_enabled;
-		u64 time_running;
-		u64 id;
-	} read_data;
+	u64 id;
+
+	read_data_sz = sizeof(struct read_format_single);
+	read_data = malloc(read_data_sz);
+	if (!read_data) {
+		perror("Unable to allocate read data");
+		return;
+	}
 
 	attr->read_format	= PERF_FORMAT_TOTAL_TIME_ENABLED |
 				  PERF_FORMAT_TOTAL_TIME_RUNNING |
@@ -325,6 +348,32 @@ try_again:
 				attr->config = PERF_COUNT_SW_CPU_CLOCK;
 				goto try_again;
 			}
+
+			/*
+			 * If we requested a sampling counter but the
+			 * hardware doesn't support it, create an
+			 * event group.
+			 */
+			if (err == EINVAL && attr->sample_period && !group) {
+				size_t sz = sizeof(struct read_format_group);
+
+				attr->read_format |= PERF_FORMAT_GROUP;
+				attr->sample_type |= PERF_SAMPLE_READ;
+
+				free(read_data);
+
+				read_data_sz = sz + (sizeof(struct group_entry) * nr_counters);
+				read_data = malloc(read_data_sz);
+				if (!read_data) {
+					perror("Unable to allocate read_data");
+					exit(-1);
+				}
+
+				/* Only try to fallback to a group once. */
+				group = 1;
+				goto try_again;
+			}
+
 			printf("\n");
 			error("perfcounter syscall returned with %d (%s)\n",
 					fd[nr_cpu][counter][thread_index], strerror(err));
@@ -352,12 +401,17 @@ try_again:
 			}
 		}
 
-		if (read(fd[nr_cpu][counter][thread_index], &read_data, sizeof(read_data)) == -1) {
+		if (read(fd[nr_cpu][counter][thread_index], read_data, read_data_sz) == -1) {
 			perror("Unable to read perf file descriptor");
 			exit(-1);
 		}
 
-		if (perf_header_attr__add_id(h_attr, read_data.id) < 0) {
+		if (attr->read_format & PERF_FORMAT_GROUP)
+			id = ((struct read_format_group *)read_data)->cntr[0].id;
+		else
+			id = ((struct read_format_single *)read_data)->id;
+
+		if (perf_header_attr__add_id(h_attr, id) < 0) {
 			pr_warning("Not enough memory to add id\n");
 			exit(-1);
 		}
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 5de405d..44772fb 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -139,14 +139,29 @@ static int add_event_total(struct perf_session *session,
 	if (!hists)
 		return -ENOMEM;
 
-	hists->stats.total_period += data->period;
+	if (attr && attr->type & PERF_SAMPLE_READ) {
+		u64 value;
+		unsigned int i;
+
+		for (i = 0; i < data->group->nr; i++) {
+			struct read_group_entry *entry = &data->group->entries[i];
+
+			value = entry->value * data->group->time_running;
+			hists->stats.total_period += value;
+			session->hists.stats.total_period += value;
+		}
+	} else {
+		hists->stats.total_period += data->period;
+		session->hists.stats.total_period += data->period;
+	}
+
 	/*
 	 * FIXME: add_event_total should be moved from here to
 	 * perf_session__process_event so that the proper hist is passed to
 	 * the event_op methods.
 	 */
 	hists__inc_nr_events(hists, PERF_RECORD_SAMPLE);
-	session->hists.stats.total_period += data->period;
+
 	return 0;
 }
 
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index dab9e75..c52b3ef 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -816,8 +816,11 @@ int event__parse_sample(const event_t *event, u64 type, struct sample_data *data
 	}
 
 	if (type & PERF_SAMPLE_READ) {
-		pr_debug("PERF_SAMPLE_READ is unsuported for now\n");
-		return -1;
+		/* FIXME assume group read event for now. */
+		size_t entry_sz = sizeof(struct read_group_entry);
+
+		data->group = (struct read_group *)array;
+		array += sizeof(struct read_group) + (data->group->nr * entry_sz);
 	}
 
 	if (type & PERF_SAMPLE_CALLCHAIN) {
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 8e790da..e7cadaa 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -56,6 +56,20 @@ struct read_event {
 	u64 id;
 };
 
+struct read_group_entry {
+	u64 value;
+	u64 id;
+};
+
+struct read_group {
+	struct perf_event_header header;
+	u32 pid, tid;
+	u64 nr;
+	u64 time_enabled;
+	u64 time_running;
+	struct read_group_entry entries[0];
+};
+
 struct sample_event {
 	struct perf_event_header        header;
 	u64 array[];
@@ -73,6 +87,7 @@ struct sample_data {
 	u32 raw_size;
 	void *raw_data;
 	struct ip_callchain *callchain;
+	struct read_group *group;
 };
 
 #define BUILD_ID_SIZE 20
-- 
1.7.1

