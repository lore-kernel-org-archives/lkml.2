Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab1B1Dwy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 22:52:54 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:20613 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab1B1Dw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 22:52:29 -0500
X-IronPort-AV: E=Sophos;i="4.62,237,1297036800"; 
   d="scan'208";a="266102199"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <daahern@cisco.com>
Subject: [PATCH 5/6] perf script: Prepend lines with time-of-day string
Date: Sun, 27 Feb 2011 20:52:30 -0700
Message-Id: <1298865151-23656-6-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298865151-23656-1-git-send-email-daahern@cisco.com>
References: <1298865151-23656-1-git-send-email-daahern@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle realtime-clock events and setting reference times that are then used
to correlate perf_clock times with time-of-day. Output lines are then
prepended with a time-of-day string if the --tod option was used with
perf-record.

Was:

swapper-0    [000] 5329.151669: context-switches: ...
   perf-5701 [001] 5329.151797: context-switches: ...
  sleep-5702 [000] 5329.155550: context-switches: ...
swapper-0    [001] 5329.158074: context-switches: ...

Now:

20:07:14.903936 swapper-0    [000] 5329.151669: context-switches: ...
20:07:14.904065    perf-5701 [001] 5329.151797: context-switches: ...
20:07:14.907817   sleep-5702 [000] 5329.155550: context-switches: ...
20:07:14.910342 swapper-0    [001] 5329.158074: context-switches: ...

Similarly for tracepoints:

20:11:11.659801        perf-5714 [001] 5565.907534: sched_switch: ...
20:11:11.659812     swapper-0    [001] 5565.907544: sched_switch: ...
20:11:11.659828 ksoftirqd/1-9    [001] 5565.907560: sched_switch: ...
20:11:12.857334     swapper-0    [001] 5567.105067: sched_switch: ...

Signed-off-by: David Ahern <daahern@cisco.com>
---
 tools/perf/builtin-script.c |   26 +++++++++++-
 tools/perf/util/event.c     |   95 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/event.h     |   10 +++++
 tools/perf/util/session.c   |   12 ++++--
 tools/perf/util/session.h   |    2 +-
 5 files changed, 139 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 4f4c63b..427c257 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -21,6 +21,8 @@ static u64			nr_unordered;
 extern const struct option	record_options[];
 static bool			hide_unresolved;
 static bool			no_callchain;
+static struct			timeval tv_ref;
+static u64 			timestamp_ref;
 
 static int default_start_script(const char *script __unused,
 				int argc __unused,
@@ -73,6 +75,7 @@ static int process_sample_event(union perf_event *event,
 	struct addr_location al;
 	struct thread *thread = perf_session__findnew(session, event->ip.pid);
 	const char *evname = NULL;
+	const char *tstr = NULL;
 	static bool check_raw = true;
 
 	if (thread == NULL) {
@@ -88,6 +91,16 @@ static int process_sample_event(union perf_event *event,
 		return -1;
 	}
 
+	if ((attr->type == PERF_TYPE_SOFTWARE) &&
+	    (attr->config == PERF_COUNT_SW_REALTIME_CLOCK) &&
+	    (perf_event__process_rclk(sample, session,
+				      &tv_ref, &timestamp_ref) == 0))
+		return 0;
+
+
+	if (session->sample_type & PERF_SAMPLE_TIME)
+		tstr = perf_event__timestr(sample, session, timestamp_ref, &tv_ref);
+
 	switch (attr->type) {
 	case PERF_TYPE_SOFTWARE:
 		if (perf_event__preprocess_sample(event, session, &al, sample,
@@ -96,7 +109,7 @@ static int process_sample_event(union perf_event *event,
 				event->header.type);
 			return -1;
 		}
-		perf_session__print_sample(session, &al, sample, hide_unresolved);
+		perf_session__print_sample(session, &al, sample, hide_unresolved, tstr);
 		break;
 
 	case PERF_TYPE_TRACEPOINT:
@@ -116,6 +129,9 @@ static int process_sample_event(union perf_event *event,
 			last_timestamp = sample->time;
 			return 0;
 		}
+		if (tstr)
+			printf("%15s ", tstr);
+
 		/*
 		 * FIXME: better resolve from pid from the struct trace_entry
 		 * field, although it should be the same than this perf
@@ -137,6 +153,13 @@ static int process_sample_event(union perf_event *event,
 	return 0;
 }
 
+static int process_reftime_event(union perf_event *event,
+                 struct perf_session *session)
+{
+	return perf_event__process_reftime(event, session,
+	                                   &tv_ref, &timestamp_ref);
+}
+
 static struct perf_event_ops event_ops = {
 	.sample		 = process_sample_event,
 	.comm		 = perf_event__process_comm,
@@ -144,6 +167,7 @@ static struct perf_event_ops event_ops = {
 	.event_type	 = perf_event__process_event_type,
 	.tracing_data	 = perf_event__process_tracing_data,
 	.build_id	 = perf_event__process_build_id,
+	.reftime	 = process_reftime_event,
 	.ordered_samples = true,
 	.ordering_requires_timestamps = true,
 };
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 6bbd551..ca1f56d 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -1,4 +1,6 @@
 #include <linux/types.h>
+#include <sys/time.h>
+#include <time.h>
 #include "event.h"
 #include "debug.h"
 #include "session.h"
@@ -847,3 +849,96 @@ out_filtered:
 	al->filtered = true;
 	return 0;
 }
+
+int perf_event__process_rclk(struct perf_sample *sample,
+                 struct perf_session *session, struct timeval *tv,
+				 u64 *ts)
+{
+	u64 s;
+
+	if (!(session->sample_type & PERF_SAMPLE_READ)) {
+		static bool show_msg = true;
+		if (show_msg) {
+			printf("rclk sample does not have event data.\n"
+			       "Was record done with --timehist option?\n");
+			show_msg = false;
+		}
+		return -1;
+	}
+
+	if (!(session->sample_type & PERF_SAMPLE_TIME)) {
+		printf("rclk sample does not have kernel sample time\n");
+		return -1;
+	}
+
+	/* convert raw sample to wall-clock reference time */
+	s = sample->values.value;
+	tv->tv_sec = s / NSEC_PER_SEC;
+	tv->tv_usec = (s - tv->tv_sec * NSEC_PER_SEC) / 1000;
+	
+	/* match event sample with kernel timestamp */
+	*ts= sample->time;
+
+	return 0;
+}
+
+/* 
+ *  process synthesized reference time event 
+ */
+int perf_event__process_reftime(union perf_event *event,
+                 struct perf_session *session __used,
+                 struct timeval *tv, u64 *ts)
+{
+	*tv = event->reftime.tv;
+	*ts = event->reftime.nsec;
+
+	return 0;
+}
+
+const char *perf_event__timestr(struct perf_sample *sample,
+				struct perf_session *session,
+				u64 tsref, struct timeval *tvref)
+{
+	static char buf[64];
+	u64 dt;
+	struct tm ltime;
+	struct timeval tv_dt, tv_res;
+	const char *fmt = "%H:%M:%S";
+
+	buf[0] = '\0';
+
+	/* no sample time in sample data */
+	if (!(session->sample_type & PERF_SAMPLE_TIME))
+		return NULL;
+
+	if (tsref == 0) {
+		static bool show_msg = true;
+		if (show_msg) {
+			if (verbose)
+			warning("Reference clock event not seen yet; "
+			        "Cannot generate wall-clock time strings until then.\n");
+			show_msg = false;
+		}
+		return NULL;
+	}
+
+	if (sample->time > tsref) {
+		dt = sample->time - tsref;
+		tv_dt.tv_sec = (time_t) (dt / NSEC_PER_SEC);
+		tv_dt.tv_usec = (dt - tv_dt.tv_sec * NSEC_PER_SEC) / 1000;
+		timeradd(tvref, &tv_dt, &tv_res);
+	} else {
+		dt = tsref - sample->time;
+		tv_dt.tv_sec = (time_t) (dt / NSEC_PER_SEC);
+		tv_dt.tv_usec = (dt - tv_dt.tv_sec * NSEC_PER_SEC) / 1000;
+		timersub(tvref, &tv_dt, &tv_res);
+	}
+
+	if (localtime_r(&tv_res.tv_sec, &ltime) != NULL) {
+		char date[64];
+		strftime(date, sizeof(date), fmt, &ltime);
+		snprintf(buf, sizeof(buf), "%s.%06ld", date, tv_res.tv_usec);
+	}
+
+	return buf;
+}
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index d4810e0..22e2af8 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -196,4 +196,14 @@ const char *perf_event__name(unsigned int id);
 int perf_event__parse_sample(const union perf_event *event, u64 type,
 			     u64 read_format, bool sample_id_all, struct perf_sample *sample);
 
+int perf_event__process_rclk(struct perf_sample *sample,
+				  struct perf_session *session, struct timeval *tv, u64 *ts);
+
+int perf_event__process_reftime(union perf_event *event,
+				  struct perf_session *session, struct timeval *tv, u64 *ts);
+
+const char *perf_event__timestr(struct perf_sample *sample,
+				  struct perf_session *session,
+				  u64 tsref, struct timeval *tvref);
+
 #endif /* __PERF_RECORD_H */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 7d46351..b68fd4f 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1157,8 +1157,12 @@ size_t perf_session__fprintf_dsos_buildid(struct perf_session *self, FILE *fp,
 
 static inline void print_sample(const char *comm, pid_t pid, 
 			u32 cpu, u64 secs, u64 usecs, const char *evname,
-			u64 addr, const char *symname, const char *dsoname)
+			u64 addr, const char *symname, const char *dsoname,
+			const char *timestr)
 {
+	if (timestr)
+		printf("%15s ", timestr);
+
 	printf("%16s-%-5d ", comm, pid);
 
 	if (cpu != (u32) -1)
@@ -1175,7 +1179,7 @@ static inline void print_sample(const char *comm, pid_t pid,
 void perf_session__print_sample(struct perf_session *session,
 				struct addr_location *al,
 				struct perf_sample *sample,
-				bool hide_unresolved)
+				bool hide_unresolved, const char *timestr)
 {
 	struct callchain_cursor_node *node, *prev;
 	struct perf_event_attr *attr;
@@ -1228,7 +1232,7 @@ void perf_session__print_sample(struct perf_session *session,
 				continue;
 
 			print_sample(comm, al->thread->pid, cpu, secs, usecs,
-			             evname, node->ip, symname, dsoname);
+			             evname, node->ip, symname, dsoname, timestr);
 
 			prev = node;
 			node = node->next;
@@ -1244,6 +1248,6 @@ void perf_session__print_sample(struct perf_session *session,
 			dsoname = al->map->dso->name;
 
 		print_sample(comm, al->thread->pid, cpu, secs, usecs,
-		             evname, al->addr, symname, dsoname);
+		             evname, al->addr, symname, dsoname, timestr);
 	}
 }
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index ff8791d..a4f1c4f 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -172,5 +172,5 @@ static inline int perf_session__parse_sample(struct perf_session *session,
 
 void perf_session__print_sample(struct perf_session *session,
 					struct addr_location *al, struct perf_sample *sample,
-					bool hide_unresolved);
+					bool hide_unresolved, const char *timestr);
 #endif /* __PERF_SESSION_H */
-- 
1.7.4

