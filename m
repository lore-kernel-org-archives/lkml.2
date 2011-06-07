Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab1FGX4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:56:41 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57456 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab1FGX4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:56:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=luWiEBYrYLx9pCwRYDcYFImjxp5W2hQULDC08L0FV9dWkAQNsWld4W2I/3rQnT4C1/
         XB9Wn6pXEX1OL6iEdswxSNHBF8ox0h+POGh0XTrdoHbi0AwMpLe3CFUF/bxV7ezAChDG
         818mGbRHWWAAZ7qboZAFeDW50HSmw5h6AifSA=
From: David Ahern <dsahern@gmail.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 6/6] perf script: add time-of-day option for displaying events
Date: Tue,  7 Jun 2011 17:56:33 -0600
Message-Id: <1307490993-24788-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1307490806-24548-1-git-send-email-dsahern@gmail.com>
References: <1307490806-24548-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Default format is %H:%M:%S and the format can be changed via the --tod argument.
Timekeeping tracepoints are parsed to update the correlation between
perf_clock and time-of-day.

e.g.,
perf script -i perf-cs-tod.data  -f 'tod,comm,tid,cpu,event,ip'

14:06:24.860431         rcuc3    21 [003] context-switches:  ffffffff81040b13
14:06:24.860448   kworker/3:1    83 [003] context-switches:  ffffffff81040b13
14:06:24.860606       swapper     0 [011] context-switches:  ffffffff81040b13
14:06:24.860610  ksoftirqd/11    54 [011] context-switches:  ffffffff81040b13

And capturing a time change:

14:06:24.860606       swapper     0 [011] context-switches:  ffffffff81040b13
14:06:24.860610  ksoftirqd/11    54 [011] context-switches:  ffffffff81040b13
13:50:00.000000          date  5412 [011] settimeofday:  ffffffff81071891
13:50:00.000127       swapper     0 [003] context-switches:  ffffffff81040b13
13:50:00.000137         rcuc3    21 [003] context-switches:  ffffffff81040b13

And it's reset by ntpd:
14:09:26.750894   kworker/1:1    81 [001] context-switches:  ffffffff81040b13
14:09:26.758159       swapper     0 [000] context-switches:  ffffffff81040b13
14:25:54.391283          ntpd  5465 [000] settimeofday:  ffffffff81071891
14:25:54.391296       swapper     0 [008] context-switches:  ffffffff81040b13
14:25:54.391363      rsyslogd  1642 [008] context-switches:  ffffffff81040b13

Another example with user formatted time:

perf script -i perf-cs-tod.data  --tod "%D-%T" -v -f 'tod,comm,tid,event,ip'

06/07/11-14:06:24.860606       swapper     0 context-switches:  ffffffff81040b13
06/07/11-14:06:24.860610  ksoftirqd/11    54 context-switches:  ffffffff81040b13
06/07/11-13:50:00.000000          date  5412 settimeofday:  ffffffff81071891
06/07/11-13:50:00.000127       swapper     0 context-switches:  ffffffff81040b13
06/07/11-13:50:00.000137         rcuc3    21 context-switches:  ffffffff81040b13

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/Documentation/perf-script.txt |    8 ++-
 tools/perf/builtin-script.c              |  141 ++++++++++++++++++++++++++++++
 2 files changed, 148 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index c6068cb..bd30279 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -115,7 +115,7 @@ OPTIONS
 -f::
 --fields::
         Comma separated list of fields to print. Options are:
-        comm, tid, pid, time, cpu, event, trace, ip, sym, dso, addr.
+        comm, tid, pid, time, cpu, event, trace, ip, sym, dso, addr, tod.
         Field list can be prepended with the type, trace, sw or hw,
         to indicate to which event type the field list applies.
         e.g., -f sw:comm,tid,time,ip,sym  and -f trace:time,cpu,trace
@@ -182,6 +182,12 @@ OPTIONS
 --hide-call-graph::
         When printing symbols do not display call chain.
 
+--tod=<format>::
+        Add time-of-day to output using specified format string. Format
+        string is passed to strftime, so any format recognized by it
+        can be used (see man strftime). Default format is "%H:%M:%S".
+        Microseocnds are appended to the time string.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script-perl[1],
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index c61ae26..94dc7b0 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -21,6 +21,8 @@ static u64			last_timestamp;
 static u64			nr_unordered;
 extern const struct option	record_options[];
 static bool			no_callchain;
+static char 			default_tod_fmt[] = "%H:%M:%S";
+static char 			*tod_fmt = default_tod_fmt;
 
 enum perf_output_field {
 	PERF_OUTPUT_COMM            = 1U << 0,
@@ -34,6 +36,7 @@ enum perf_output_field {
 	PERF_OUTPUT_SYM             = 1U << 8,
 	PERF_OUTPUT_DSO             = 1U << 9,
 	PERF_OUTPUT_ADDR            = 1U << 10,
+	PERF_OUTPUT_TIMEOFDAY       = 1U << 11,
 };
 
 struct output_option {
@@ -51,6 +54,7 @@ struct output_option {
 	{.str = "sym",   .field = PERF_OUTPUT_SYM},
 	{.str = "dso",   .field = PERF_OUTPUT_DSO},
 	{.str = "addr",  .field = PERF_OUTPUT_ADDR},
+	{.str = "tod",   .field = PERF_OUTPUT_TIMEOFDAY},
 };
 
 /* default set to maintain compatibility with current format */
@@ -209,6 +213,13 @@ static int perf_evsel__check_attr(struct perf_evsel *evsel,
 				       PERF_OUTPUT_CPU))
 		return -EINVAL;
 
+	if (PRINT_FIELD(TIMEOFDAY) &&
+		perf_event_attr__check_stype(attr, PERF_SAMPLE_TIME, "TIME",
+				       PERF_OUTPUT_TIME)) {
+		pr_err("Samples do not contain timestamps.\n");
+		pr_err("Was --tod used with perf-record?\n");
+	}
+
 	return 0;
 }
 
@@ -243,6 +254,80 @@ static int perf_session__check_output_opt(struct perf_session *session)
 	return 0;
 }
 
+static struct timeval tv_ref;
+static u64 timestamp_ref;
+static const char *timeofday_str(u64 timestamp)
+{
+	struct tm ltime;
+	u64 dt;
+	struct timeval tv_dt, tv_res;
+	static char tstr[64];
+
+	if (timestamp_ref == 0) {
+		static bool show_msg = true;
+		if (show_msg) {
+			warning("Reference clock event not seen; "
+				"Cannot generate time-of-day strings until then.\n"
+				"Was --tod used with perf-record?\n");
+			show_msg = false;
+		}
+		snprintf(tstr, sizeof(tstr), "%16" PRId64, timestamp);
+		return tstr;
+	} else if (timestamp == 0) {
+		snprintf(tstr, sizeof(tstr), "%16" PRId64, timestamp);
+		return tstr;
+	}
+	if (timestamp > timestamp_ref) {
+		dt = timestamp - timestamp_ref;
+		tv_dt.tv_sec = (time_t) (dt / NSEC_PER_SEC);
+		tv_dt.tv_usec = (dt - tv_dt.tv_sec * NSEC_PER_SEC) / 1000;
+		timeradd(&tv_ref, &tv_dt, &tv_res);
+	} else {
+		dt = timestamp_ref - timestamp;
+		tv_dt.tv_sec = (time_t) (dt / NSEC_PER_SEC);
+		tv_dt.tv_usec = (dt - tv_dt.tv_sec * NSEC_PER_SEC) / 1000;
+		timersub(&tv_ref, &tv_dt, &tv_res);
+	}
+
+	if (localtime_r(&tv_res.tv_sec, &ltime) == NULL) {
+		snprintf(tstr, sizeof(tstr), "%15" PRId64, timestamp);
+	} else {
+		char date[64];
+		strftime(date, sizeof(date), tod_fmt, &ltime);
+		snprintf(tstr, sizeof(tstr), "%s.%06ld", date, tv_res.tv_usec);
+	}
+
+	return tstr;
+}
+
+static void process_timeofday_event(struct event *event,
+				    struct perf_sample *sample)
+{
+	unsigned long val;
+
+	if (strcmp(event->name, "settimeofday") &&
+	    strcmp(event->name, "timekeeping_inject_offset") &&
+		strcmp(event->name, "timekeeping_inject_sleeptime"))
+		return;
+
+	val = raw_field_value(event, "tv_sec", sample->raw_data);
+	tv_ref.tv_sec = val;
+
+	val = raw_field_value(event, "tv_nsec", sample->raw_data);
+	tv_ref.tv_usec = val / NSECS_PER_USEC;
+
+	timestamp_ref = sample->time;
+}
+
+static int perf_event__process_reftime(union perf_event *event,
+				       struct perf_session *session __used)
+{
+	tv_ref = event->reftime.tv;
+	timestamp_ref = event->reftime.nsec;
+
+	return 0;
+}
+
 static void print_sample_start(struct perf_sample *sample,
 			       struct thread *thread,
 			       struct perf_event_attr *attr)
@@ -254,6 +339,9 @@ static void print_sample_start(struct perf_sample *sample,
 	unsigned long usecs;
 	unsigned long long nsecs;
 
+	if (PRINT_FIELD(TIMEOFDAY))
+		printf("%s ", timeofday_str(sample->time));
+
 	if (PRINT_FIELD(COMM)) {
 		if (latency_format)
 			printf("%8.8s ", thread->comm);
@@ -376,6 +464,8 @@ static void process_event(union perf_event *event __unused,
 			warning("ug! no event found for type %d", type);
 			return;
 		}
+
+		process_timeofday_event(tr_event, sample);
 	}
 
 	print_sample_start(sample, thread, attr);
@@ -481,6 +571,7 @@ static struct perf_event_ops event_ops = {
 	.event_type	 = perf_event__process_event_type,
 	.tracing_data	 = perf_event__process_tracing_data,
 	.build_id	 = perf_event__process_build_id,
+	.reftime     = perf_event__process_reftime,
 	.ordered_samples = true,
 	.ordering_requires_timestamps = true,
 };
@@ -764,6 +855,49 @@ out:
 	return rc;
 }
 
+static int parse_tod_format(const struct option *opt __used,
+			    const char *arg, int unset __used)
+{
+	int i;
+	char date[128];
+	size_t rc;
+	struct tm ltime;
+
+	if (strlen(arg) == 0) {
+		pr_debug("Time-of-day strings will be suppressed\n");
+		goto out;
+	}
+
+	/* test input string for validity and length of output */
+	localtime_r(0, &ltime);
+	rc = strftime(date, sizeof(date), arg, &ltime);
+	if (rc == 0) {
+		fprintf(stderr, "Invalid format string for time-of-day\n");
+		return -EINVAL;
+	}
+
+out:
+	for (i = 0; i < PERF_TYPE_MAX; ++i) {
+		if (output[i].fields == 0)
+			continue;
+		if (strlen(arg))
+			output[i].fields |= PERF_OUTPUT_TIMEOFDAY;
+		else
+			output[i].fields &= ~PERF_OUTPUT_TIMEOFDAY;
+	}
+
+	if (tod_fmt != default_tod_fmt)
+		free(tod_fmt);
+
+	tod_fmt = strdup(arg);
+	if (!tod_fmt) {
+		fprintf(stderr, "Failed to copy time-of-day format string\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
 /* Helper function for filesystems that return a dent->d_type DT_UNKNOWN */
 static int is_directory(const char *base_path, const struct dirent *dent)
 {
@@ -1087,6 +1221,9 @@ static const struct option options[] = {
 	OPT_CALLBACK('f', "fields", NULL, "str",
 		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso,addr",
 		     parse_output_fields),
+	OPT_CALLBACK(0, "tod", NULL, "str",
+		     "Format for time-of-day strings. Option is passed to strftime; microseconds are appended. Default is %H:%M:%S.",
+		     parse_tod_format),
 
 	OPT_END()
 };
@@ -1325,6 +1462,10 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 
 	perf_session__delete(session);
 	cleanup_scripting();
+
+	if (tod_fmt != default_tod_fmt)
+		free(tod_fmt);
+
 out:
 	return err;
 }
-- 
1.7.5.2

