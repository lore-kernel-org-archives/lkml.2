Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab0KWKqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 05:46:20 -0500
Received: from smtp-out.google.com ([216.239.44.51]:13562 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab0KWKqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 05:46:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=jkbFdYFfuxcguWl8L8WH3uQ38Fym9vmH1am/C7vaRz8e6uKr43hxxfMPWQpcNTYTUj
         odUMohlriBE5XXZ+gEkA==
Message-ID: <4ceb9b74.e6edd80a.3271.fffff742@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Tue, 23 Nov 2010 11:45:05 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, eranian@google.com, robert.richter@amd.com
Subject: [PATCH] perf: add support for per-event sampling period or frequency in perf record
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows specifying a per event sampling period or frequency.
Up until now, the same sampling period or frequency was applied to all
the events specified on the command line of perf record. A sampling 
period depends on the event, thus it is necessary to specify it per event.

With this patch, both the -F and -c options now take a comma separated
list of values. If a value is omitted for an event, it defaults to 1000Hz
frequency mode as before.

$ perf record -e cycles,instructions -c 100000,200000 -a -- sleep 5

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 9426383..28ea0a5 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -35,14 +35,10 @@ enum write_mode_t {
 
 static int			*fd[MAX_NR_CPUS][MAX_COUNTERS];
 
-static u64			user_interval			= ULLONG_MAX;
-static u64			default_interval		=      0;
-
 static int			nr_cpus				=      0;
 static unsigned int		page_size;
 static unsigned int		mmap_pages			=    128;
-static unsigned int		user_freq			= UINT_MAX;
-static int			freq				=   1000;
+static u64			default_freq			=   1000;
 static int			output;
 static int			pipe_output			=      0;
 static const char		*output_name			= "perf.data";
@@ -85,6 +81,97 @@ struct mmap_data {
 };
 
 static struct mmap_data		mmap_array[MAX_NR_CPUS];
+static u64			user_periods[MAX_COUNTERS];
+static u64			user_freqs[MAX_COUNTERS];
+static int			nr_user_freqs;
+static int			nr_user_periods;
+
+static int parse_user_freqs(const struct option *opt __used, const char *str,
+		  int unset __used)
+{
+	const char *p, *e, *eos = str + strlen(str);
+	int n = 0, ret = 0;
+	for (;;) {
+		p = strchr(str, ',');
+		e = p ? p : eos;
+
+		if (n == MAX_COUNTERS)
+			goto error;
+		/* allow empty cgroups, i.e., skip */
+		if (e - str) {
+			/* termination added */
+			ret = sscanf(str, "%llu", user_freqs+n);
+			if (ret != 1)
+				goto error;
+			if (!user_freqs[n])
+				goto error_zero;
+			if (user_periods[n])
+				goto error_mix;
+			nr_user_freqs++;
+		} else {
+			user_freqs[n] = 0;
+		}
+		n++;
+		if (!p)
+			break;
+		str = p+1;
+	}
+	return 0;
+error:
+	fprintf(stderr, "cannot parse event frequency %s\n", str);
+	return -1;
+error_zero:
+	fprintf(stderr, "invalid zero frequency, aborting");
+	return -1;
+error_mix:
+	fprintf(stderr, "event %d has both a frequency and period,"
+			" must choose only one, aborting", n);
+	return -1;
+}
+
+static int parse_user_periods(const struct option *opt __used, const char *str,
+		  int unset __used)
+{
+	const char *p, *e, *eos = str + strlen(str);
+	int n = 0, ret;
+
+	for (;;) {
+		p = strchr(str, ',');
+		e = p ? p : eos;
+
+		if (n == MAX_COUNTERS)
+			goto error;
+		/* allow empty cgroups, i.e., skip */
+		if (e - str) {
+			/* termination added */
+			ret = sscanf(str, "%llu", user_periods+n);
+			if (ret != 1)
+				goto error;
+			if (!user_periods[n])
+				goto error_zero;
+			if (user_freqs[n])
+				goto error_mix;
+			nr_user_periods++;
+		} else {
+			user_periods[n] = 0;
+		}
+		n++;
+		if (!p)
+			break;
+		str = p+1;
+	}
+	return 0;
+error:
+	fprintf(stderr, "cannot parse event frequency %s\n", str);
+	return -1;
+error_zero:
+	fprintf(stderr, "invalid zero period, aborting");
+	return -1;
+error_mix:
+	fprintf(stderr, "event %d has both a frequency and period,"
+			" must choose only one, aborting", n);
+	return -1;
+}
 
 static unsigned long mmap_read_head(struct mmap_data *md)
 {
@@ -232,6 +319,7 @@ static void create_counter(int counter, int cpu)
 	struct perf_header_attr *h_attr;
 	int track = !counter; /* only the first counter needs these */
 	int thread_index;
+	u64 ufreq, uperiod;
 	int ret;
 	struct {
 		u64 count;
@@ -249,18 +337,19 @@ static void create_counter(int counter, int cpu)
 	if (nr_counters > 1)
 		attr->sample_type |= PERF_SAMPLE_ID;
 
+	ufreq = user_freqs[counter];
+	uperiod = user_periods[counter];
 	/*
-	 * We default some events to a 1 default interval. But keep
+	 * We default some events to a 1 default period. But keep
 	 * it a weak assumption overridable by the user.
 	 */
-	if (!attr->sample_period || (user_freq != UINT_MAX &&
-				     user_interval != ULLONG_MAX)) {
-		if (freq) {
-			attr->sample_type	|= PERF_SAMPLE_PERIOD;
-			attr->freq		= 1;
-			attr->sample_freq	= freq;
+	if (!attr->sample_period || ufreq != 0 || uperiod != 0) {
+		if (uperiod) {
+			attr->sample_period = uperiod;
 		} else {
-			attr->sample_period = default_interval;
+			attr->sample_type |= PERF_SAMPLE_PERIOD;
+			attr->freq = 1;
+			attr->sample_freq = ufreq ? ufreq : default_freq;
 		}
 	}
 
@@ -866,12 +955,14 @@ const struct option record_options[] = {
 		    "list of cpus to monitor"),
 	OPT_BOOLEAN('f', "force", &force,
 			"overwrite existing data file (deprecated)"),
-	OPT_U64('c', "count", &user_interval, "event period to sample"),
+	OPT_CALLBACK('c', "count", NULL, "period", "profile events at these "
+			  " periods", parse_user_periods),
 	OPT_STRING('o', "output", &output_name, "file",
 		    "output file name"),
 	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
 		    "child tasks do not inherit counters"),
-	OPT_UINTEGER('F', "freq", &user_freq, "profile at this frequency"),
+	OPT_CALLBACK('F', "freq", NULL, "freq", "profile events at these "
+			  " frequencies", parse_user_freqs),
 	OPT_UINTEGER('m', "mmap-pages", &mmap_pages, "number of mmap data pages"),
 	OPT_BOOLEAN('g', "call-graph", &call_graph,
 		    "do call-graph (stack chain/backtrace) recording"),
@@ -947,27 +1038,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	if (!event_array)
 		goto out_free_fd;
 
-	if (user_interval != ULLONG_MAX)
-		default_interval = user_interval;
-	if (user_freq != UINT_MAX)
-		freq = user_freq;
-
-	/*
-	 * User specified count overrides default frequency.
-	 */
-	if (default_interval)
-		freq = 0;
-	else if (freq) {
-		default_interval = freq;
-	} else {
-		fprintf(stderr, "frequency and count are zero, aborting\n");
-		err = -EINVAL;
-		goto out_free_event_array;
-	}
-
 	err = __cmd_record(argc, argv);
 
-out_free_event_array:
 	free(event_array);
 out_free_fd:
 	for (i = 0; i < MAX_NR_CPUS; i++) {
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 492d19d..c53cd10 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -543,7 +543,11 @@ static char *get_script_path(const char *script_root, const char *suffix)
 
 static bool is_top_script(const char *script_path)
 {
-	return ends_with((char *)script_path, "top") == NULL ? false : true;
+	char *str = strdup(script_path);
+	int ret;
+	ret = ends_with(str, "top") == NULL ? false : true;
+	free(str);
+	return ret;
 }
 
 static int has_required_arg(char *script_path)
