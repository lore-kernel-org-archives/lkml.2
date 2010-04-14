Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab0DNUvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 16:51:51 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42450 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab0DNUvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 16:51:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JTvLYoqdGlrgvVKweArLAjTdHzhP8puTLDlNj5KiIqDYn9WU/zOQld7riZLNwa0DMd
         +urDxykbhnS9sOCrUCMi1V03LU7RExFSIU9cQjz6U5efaZZUBgaCI/eDOrRwJlV6iD9H
         4IGqWYSxzP2PYBySA/JBfxsnXUddRcUXLIjbQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/3] perf: Make the trace events sample period default to 1
Date: Wed, 14 Apr 2010 22:51:34 +0200
Message-Id: <1271278294-7336-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1271278294-7336-1-git-send-regression-fweisbec@gmail.com>
References: <1271278294-7336-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trace events are mostly used for tracing and then require not to
be lost when possible. As opposite to hardware events that really
require to trigger after a given sample period, trace events mostly
need to trigger everytime.

It is a frustrating experience to trace with perf and realize we
lost a lot of events because we forgot the "-c 1" option.

Then default sample_period to 1 for trace events but let the user
override it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 tools/perf/builtin-record.c    |   36 ++++++++++++++++++++++--------------
 tools/perf/util/parse-events.c |    2 ++
 2 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index dcda899..ca2affc 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -33,11 +33,13 @@ enum write_mode_t {
 
 static int			*fd[MAX_NR_CPUS][MAX_COUNTERS];
 
+static unsigned int		user_interval 			= UINT_MAX;
 static long			default_interval		=      0;
 
 static int			nr_cpus				=      0;
 static unsigned int		page_size;
 static unsigned int		mmap_pages			=    128;
+static unsigned int		user_freq 			= UINT_MAX;
 static int			freq				=   1000;
 static int			output;
 static const char		*output_name			= "perf.data";
@@ -255,10 +257,19 @@ static void create_counter(int counter, int cpu)
 	if (nr_counters > 1)
 		attr->sample_type |= PERF_SAMPLE_ID;
 
-	if (freq) {
-		attr->sample_type	|= PERF_SAMPLE_PERIOD;
-		attr->freq		= 1;
-		attr->sample_freq	= freq;
+	/*
+	 * We default some events to a 1 default interval. But keep
+	 * it a weak assumption overridable by the user.
+	 */
+	if (!attr->sample_period || (user_freq != UINT_MAX &&
+				     user_interval != UINT_MAX)) {
+		if (freq) {
+			attr->sample_type	|= PERF_SAMPLE_PERIOD;
+			attr->freq		= 1;
+			attr->sample_freq	= freq;
+		} else {
+			attr->sample_period = default_interval;
+		}
 	}
 
 	if (no_samples)
@@ -689,13 +700,13 @@ static const struct option options[] = {
 			    "CPU to profile on"),
 	OPT_BOOLEAN('f', "force", &force,
 			"overwrite existing data file (deprecated)"),
-	OPT_LONG('c', "count", &default_interval,
+	OPT_LONG('c', "count", &user_interval,
 		    "event period to sample"),
 	OPT_STRING('o', "output", &output_name, "file",
 		    "output file name"),
 	OPT_BOOLEAN('i', "inherit", &inherit,
 		    "child tasks inherit counters"),
-	OPT_INTEGER('F', "freq", &freq,
+	OPT_INTEGER('F', "freq", &user_freq,
 		    "profile at this frequency"),
 	OPT_INTEGER('m', "mmap-pages", &mmap_pages,
 		    "number of mmap data pages"),
@@ -716,7 +727,6 @@ static const struct option options[] = {
 
 int cmd_record(int argc, const char **argv, const char *prefix __used)
 {
-	int counter;
 	int i,j;
 
 	argc = parse_options(argc, argv, options, record_usage,
@@ -774,6 +784,11 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	if (!event_array)
 		return -ENOMEM;
 
+	if (user_interval != UINT_MAX)
+		default_interval = user_interval;
+	if (user_freq != UINT_MAX)
+		freq = user_freq;
+
 	/*
 	 * User specified count overrides default frequency.
 	 */
@@ -786,12 +801,5 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		exit(EXIT_FAILURE);
 	}
 
-	for (counter = 0; counter < nr_counters; counter++) {
-		if (attrs[counter].sample_period)
-			continue;
-
-		attrs[counter].sample_period = default_interval;
-	}
-
 	return __cmd_record(argc, argv);
 }
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 880070c..3b4ec67 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -422,6 +422,8 @@ parse_single_tracepoint_event(char *sys_name,
 	attr->sample_type |= PERF_SAMPLE_TIME;
 	attr->sample_type |= PERF_SAMPLE_CPU;
 
+	attr->sample_period = 1;
+
 	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
 		 sys_name, evt_name);
 
-- 
1.6.2.3

