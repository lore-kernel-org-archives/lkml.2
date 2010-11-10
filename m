Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab0KJGNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 01:13:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:52326 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab0KJGNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 01:13:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,177,1288594800"; 
   d="scan'208";a="856007898"
Subject: [RFC PATCH 2/2] perf stat: Use event group to simulate PMI on
 PMI-less hardware counter
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Matt Fleming <matt@console-pimps.org>
Cc: Zhang Rui <rui.zhang@intel.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 14:15:25 +0800
Message-ID: <1289369725.2430.39.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some hardware counters(for example, Intel RAPL) can't generate interrupt
when overflow. So we need to simulate the interrupt to periodically
record the counter values. Otherwise, the counter may overflow and the
wrong value is read.

This patch uses event group to simulate PMI as suggested by Peter
Zijlstra, http://marc.info/?l=linux-kernel&m=128220854801819&w=2

create_group_counters() will create a group with 2 events, one hrtimer
based event as the group leader, and the other event to count. The
hrtimer is fired periodically, so the sibling event can record its
counter value periodically as well.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 include/linux/perf_event.h |    4 ++-
 tools/perf/builtin-stat.c  |   58 +++++++++++++++++++++++++++++++++++++++----
 2 files changed, 55 insertions(+), 7 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 057bf22..8a4c0aa 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -216,7 +216,9 @@ struct perf_event_attr {
 				precise_ip     :  2, /* skid constraint       */
 				mmap_data      :  1, /* non-exec mmap data    */
 
-				__reserved_1   : 46;
+				pmi_simulate   :  1, /* simulate pmi with group events */
+
+				__reserved_1   : 45;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index a6b4d44..e0497cf 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -148,6 +148,38 @@ struct stats			runtime_branches_stats;
 #define ERR_PERF_OPEN \
 "Error: counter %d, sys_perf_event_open() syscall returned with %d (%s)\n"
 
+/*
+ * Create a group with hrtimer event(task-clock) as leader
+ * to simulate PMI
+ */
+static int create_group_counters(struct perf_event_attr *attr,
+	pid_t pid, int cpu, int flags)
+{
+	int leader_fd, counter_fd;
+	struct perf_event_attr leader;
+
+	memset(&leader, 0, sizeof(struct perf_event_attr));
+	leader.type = PERF_TYPE_SOFTWARE;
+	leader.config = PERF_COUNT_SW_TASK_CLOCK;
+	leader.sample_type = PERF_SAMPLE_READ;
+	leader.read_format = attr->read_format | PERF_FORMAT_GROUP;
+	leader.sample_period = attr->sample_period;
+	leader.disabled = attr->disabled;
+	leader.enable_on_exec = attr->enable_on_exec;
+
+	leader_fd = sys_perf_event_open(&leader, pid, cpu, -1, flags);
+	if (leader_fd < 0)
+		return leader_fd;
+
+	counter_fd = sys_perf_event_open(attr, pid, cpu, leader_fd, flags);
+	if (counter_fd < 0) {
+		close(leader_fd);
+		return counter_fd;
+	}
+
+	return leader_fd;
+}
+
 static int create_perf_stat_counter(int counter)
 {
 	struct perf_event_attr *attr = attrs + counter;
@@ -162,8 +194,12 @@ static int create_perf_stat_counter(int counter)
 		int cpu;
 
 		for (cpu = 0; cpu < nr_cpus; cpu++) {
-			fd[cpu][counter][0] = sys_perf_event_open(attr,
+			if (!attr->pmi_simulate)
+				fd[cpu][counter][0] = sys_perf_event_open(attr,
 					-1, cpumap[cpu], -1, 0);
+			else
+				fd[cpu][counter][0] = create_group_counters(attr,
+					-1, cpumap[cpu], 0);
 			if (fd[cpu][counter][0] < 0)
 				pr_debug(ERR_PERF_OPEN, counter,
 					 fd[cpu][counter][0], strerror(errno));
@@ -177,8 +213,12 @@ static int create_perf_stat_counter(int counter)
 			attr->enable_on_exec = 1;
 		}
 		for (thread = 0; thread < thread_num; thread++) {
-			fd[0][counter][thread] = sys_perf_event_open(attr,
-				all_tids[thread], -1, -1, 0);
+			if (!attr->pmi_simulate)
+				fd[0][counter][thread] = sys_perf_event_open(attr,
+					all_tids[thread], -1, -1, 0);
+			else
+				fd[0][counter][thread] = create_group_counters(attr,
+					all_tids[thread], -1, 0);
 			if (fd[0][counter][thread] < 0)
 				pr_debug(ERR_PERF_OPEN, counter,
 					 fd[0][counter][thread],
@@ -208,15 +248,21 @@ static inline int nsec_counter(int counter)
  */
 static void read_counter(int counter)
 {
-	u64 count[3], single_count[3];
+	u64 count[3], single_count[5];
 	int cpu;
 	size_t res, nv;
 	int scaled;
 	int i, thread;
+	int data_idx = 0;
 
 	count[0] = count[1] = count[2] = 0;
 
-	nv = scale ? 3 : 1;
+	if (!attrs[counter].pmi_simulate)
+		nv = scale ? 3 : 1;
+	else {
+		nv = scale ? 5 : 3;
+		data_idx = nv - 1;
+	}
 	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		for (thread = 0; thread < thread_num; thread++) {
 			if (fd[cpu][counter][thread] < 0)
@@ -229,7 +275,7 @@ static void read_counter(int counter)
 			close(fd[cpu][counter][thread]);
 			fd[cpu][counter][thread] = -1;
 
-			count[0] += single_count[0];
+			count[0] += single_count[data_idx];
 			if (scale) {
 				count[1] += single_count[1];
 				count[2] += single_count[2];
-- 
1.7.1



