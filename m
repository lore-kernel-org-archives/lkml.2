Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab1FGX4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:56:11 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57456 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608Ab1FGX4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:56:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ej5p/SKWkiJ4K10ZO3+OKTLAnRZuF8mV7EuSRLC0UHQEHJD9s/2BhjJz4cD66YyoE8
         PAKGe3K+7ft5t/Kz/YWgghLBW9u2ArFU7k/VlHWzfhmsVpjRmy2QSMD4DFsVXnfKwEBE
         VkUczmghSB0t5l6D47AhEi5sCDb6YEQ95m3C0=
From: David Ahern <dsahern@gmail.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 4/6] perf record: add time-of-day option
Date: Tue,  7 Jun 2011 17:56:04 -0600
Message-Id: <1307490964-24714-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1307490806-24548-1-git-send-email-dsahern@gmail.com>
References: <1307490806-24548-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use reftime event for initial correlation of perf_clock to
time-of-day. Add timekeeping trace events to event list to
capture jumps in time-of-day.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/Documentation/perf-record.txt |    3 +
 tools/perf/builtin-record.c              |  102 +++++++++++++++++++++++++++++-
 2 files changed, 104 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 5a520f8..e4c87ba 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -148,6 +148,9 @@ an empty cgroup (monitor all the time) using, e.g., -G foo,,bar. Cgroups must ha
 corresponding events, i.e., they always refer to events defined earlier on the command
 line.
 
+--tod::
+Collect data for displaying time-of-day strings when printing events.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 8e2c857..4f8d5f2 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -32,6 +32,9 @@
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 
+#define TRACE_TOD_SUBSYSTEM      "timekeeping"
+#define TRACE_TOD_SUBSYSTEM_LEN  11
+
 enum write_mode_t {
 	WRITE_FORCE,
 	WRITE_APPEND
@@ -65,6 +68,8 @@ static bool			sample_address			=  false;
 static bool			sample_time			=  false;
 static bool			no_buildid			=  false;
 static bool			no_buildid_cache		=  false;
+static bool			want_tod			=  false;
+static u64 			tod_sample_type;
 static struct perf_evlist	*evsel_list;
 
 static long			samples				=      0;
@@ -215,6 +220,9 @@ static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 	}
 
+	if (want_tod)
+		attr->sample_type	|= tod_sample_type;
+
 	if (nodelay) {
 		attr->watermark = 0;
 		attr->wakeup_events = 1;
@@ -248,6 +256,86 @@ static bool perf_evlist__equal(struct perf_evlist *evlist,
 	return true;
 }
 
+static int perf_event__synthesize_reftime(perf_event__handler_t process)
+{
+	union perf_event ev;
+	struct timespec tp;
+
+	memset(&ev, 0, sizeof(ev));
+
+	if (gettimeofday(&ev.reftime.tv, NULL) != 0) {
+		error("gettimeofday failed.\n");
+		return -1;
+	}
+	if (clock_gettime(CLOCK_MONOTONIC, &tp) != 0) {
+		error("clock_gettime(CLOCK_MONOTONIC) failed.\n");
+		return -1;
+	}
+	ev.reftime.nsec = (u64) tp.tv_sec * NSEC_PER_SEC + (u64) tp.tv_nsec;
+
+	ev.header.type = PERF_RECORD_REFTIME;
+	ev.header.size = sizeof(ev.reftime);
+
+	return process(&ev, NULL, session);
+}
+
+static int add_timeofday_events(void)
+{
+	int rc, i, len;
+	struct perf_event_attr attr;
+	struct perf_evsel *evsel;
+
+	/* events that modify xtime */
+	const char *tod_events[] = {"settimeofday",
+				    "timekeeping_inject_offset",
+				    "timekeeping_inject_sleeptime",
+				    NULL};
+
+	i = 0;
+	rc = -1;
+	while (tod_events[i]) {
+		memset(&attr, 0, sizeof(attr));
+		len = strlen(tod_events[i]);
+
+		if (parse_single_tracepoint_event(TRACE_TOD_SUBSYSTEM,
+			tod_events[i], len, &attr, NULL) == EVT_FAILED) {
+			error("Failed to parse event %s\n", tod_events[i]);
+			goto out;
+		}
+
+		evsel = perf_evsel__new(&attr, evsel_list->nr_entries);
+		if (evsel == NULL)
+			return -1;
+
+		perf_evlist__add(evsel_list, evsel);
+
+		/* +2 for ':' delimiter and string terminator */
+		evsel->name = calloc(TRACE_TOD_SUBSYSTEM_LEN + len + 2, 1);
+		if (!evsel->name)
+			return -1;
+
+		sprintf(evsel->name, "timekeeping:%s", tod_events[i]);
+
+		tod_sample_type |= attr.sample_type;
+
+		++i;
+	}
+
+	/*
+	 * right now sample_type for all samples needs to be the same.
+	 * tracepoints are collected at sample period 1 and hence do not
+	 * request the period with the sample. However, default for record
+	 * is cycles at a frequency. So, until this sample_type mess is
+	 * fixed....
+	 */
+	if (freq)
+		tod_sample_type |= PERF_SAMPLE_PERIOD;
+
+	rc = 0;
+out:
+	return rc;
+}
+
 static void open_counters(struct perf_evlist *evlist)
 {
 	struct perf_evsel *pos;
@@ -289,7 +377,8 @@ try_again:
 				 * Old kernel, no attr->sample_id_type_all field
 				 */
 				sample_id_all_avail = false;
-				if (!sample_time && !raw_samples && !time_needed)
+				if (!sample_time && !raw_samples &&
+						!time_needed && !want_tod)
 					attr->sample_type &= ~PERF_SAMPLE_TIME;
 
 				goto retry_sample_id;
@@ -629,6 +718,11 @@ static int __cmd_record(int argc, const char **argv)
 		}
 	}
 
+	if (want_tod &&
+	    (perf_event__synthesize_reftime(process_synthesized_event) != 0))
+		error("Failed to create reftime event. "
+		      "Cannot generate wall-clock timestamps\n");
+
 	machine = perf_session__find_host_machine(session);
 	if (!machine) {
 		pr_err("Couldn't find native kernel information.\n");
@@ -787,6 +881,8 @@ const struct option record_options[] = {
 	OPT_CALLBACK('G', "cgroup", &evsel_list, "name",
 		     "monitor event in cgroup name only",
 		     parse_cgroups),
+	OPT_BOOLEAN(0, "tod", &want_tod,
+		    "Collect data for time-of-day strings"),
 	OPT_END()
 };
 
@@ -842,6 +938,10 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		goto out_symbol_exit;
 	}
 
+	if (want_tod && (add_timeofday_events() != 0))
+		error("Failed to add timekeeping events to event list.\n"
+		      "Cannot generate wall-clock timestamps\n");
+
 	if (target_pid != -1)
 		target_tid = target_pid;
 
-- 
1.7.5.2

