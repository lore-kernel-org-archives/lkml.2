Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab2JZI55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 04:57:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51657 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757431Ab2JZI4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 04:56:33 -0400
Date: Fri, 26 Oct 2012 01:56:10 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-mzuli0srnxyi1o029py6537x@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Use sched:
 sched_stat_runtime to provide a thread summary
Git-Commit-ID: 1302d88e66f12a7b46a5598e641d93f0713007e0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 26 Oct 2012 01:56:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1302d88e66f12a7b46a5598e641d93f0713007e0
Gitweb:     http://git.kernel.org/tip/1302d88e66f12a7b46a5598e641d93f0713007e0
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 17 Oct 2012 17:13:12 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 25 Oct 2012 10:57:43 -0200

perf trace: Use sched:sched_stat_runtime to provide a thread summary

[root@sandy ~]# perf trace --sched --duration 0.100 --pid `pidof firefox`
<SNIP>
 17079.847 ( 0.009 ms): 17643 poll(ufds: 140037623086496, nfds: 11, timeout_msecs: 0) = 0 Timeout
 17079.892 ( 0.010 ms): 17643 read(fd: 4, buf: 140038178943092, count: 4096         ) = -1 EAGAIN Resource temporarily unavailable
 17079.921 ( 0.013 ms): 17643 poll(ufds: 140037623086496, nfds: 11, timeout_msecs: 0) = 0 Timeout
 17079.949 ( 0.009 ms): 17643 read(fd: 4, buf: 140038178943092, count: 4096         ) = -1 EAGAIN Resource temporarily unavailable
^C
 _____________________________________________________________________
 __)    Summary of events    (__

              [ task - pid ]     [ events ] [ ratio ]  [ runtime ]
 _____________________________________________________________________

             firefox - 17643 :      18013   [ 72.2% ]    359.110 ms
             firefox - 17663 :         41   [  0.2% ]     21.439 ms
             firefox - 17664 :       6840   [ 27.4% ]    133.642 ms
             firefox - 17667 :         46   [  0.2% ]      0.682 ms
[root@sandy ~]#

This is equivalent to the 'perf trace summary' subcomand in the tmp.perf/trace2
branch.

Another example, setting a huge duration filter to get just a system
wide summary:

[root@sandy ~]# perf trace --duration 10000.0 --sched
^C
 _____________________________________________________________________
 __)    Summary of events    (__

              [ task - pid ]     [ events ] [ ratio ]  [ runtime ]
 _____________________________________________________________________

           scsi_eh_1 - 258   :         15   [  0.0% ]      0.133 ms
        kworker/0:1H - 322   :         13   [  0.0% ]      0.032 ms
         jbd2/dm-0-8 - 384   :          4   [  0.0% ]      0.115 ms
         flush-253:0 - 470   :          1   [  0.0% ]      0.027 ms
             firefox - 950   :       4783   [  0.1% ]     24.863 ms
             firefox - 992   :       1883   [  0.1% ]      6.808 ms
             firefox - 995   :         35   [  0.0% ]      0.111 ms
         ksoftirqd/6 - 4362  :          2   [  0.0% ]      0.005 ms
         ksoftirqd/7 - 4365  :          1   [  0.0% ]      0.007 ms
                Xorg - 4671  :        148   [  0.0% ]      0.912 ms
     gnome-settings- - 4846  :         14   [  0.0% ]      0.086 ms
     seahorse-daemon - 4847  :         14   [  0.0% ]      0.092 ms
         gnome-panel - 4875  :         46   [  0.0% ]      0.159 ms
     gnome-power-man - 4918  :         16   [  0.0% ]      0.065 ms
     gvfs-afc-volume - 4992  :         77   [  0.0% ]      0.136 ms
     gnome-screensav - 5114  :         24   [  0.0% ]      0.128 ms
               xchat - 8082  :        466   [  0.0% ]      2.019 ms
            synergyc - 8369  :        941   [  0.0% ]      3.291 ms
            synergyc - 8371  :         85   [  0.0% ]      1.817 ms
         jbd2/dm-4-8 - 9352  :          4   [  0.0% ]      0.109 ms
             rpcbind - 9786  :          3   [  0.0% ]      0.017 ms
        rtkit-daemon - 12802 :         10   [  0.0% ]      0.038 ms
        rtkit-daemon - 12803 :          8   [  0.0% ]      0.000 ms
       udisks-daemon - 13020 :         27   [  0.0% ]      0.240 ms
         kworker/7:0 - 14651 :        669   [  0.0% ]      2.616 ms
         kworker/5:1 - 16220 :          2   [  0.0% ]      0.069 ms
         kworker/4:0 - 19776 :         13   [  0.0% ]      0.176 ms
             openvpn - 20131 :        133   [  0.0% ]      0.762 ms
     plugin-containe - 20508 :      60658   [  1.7% ]    131.153 ms
        npviewer.bin - 20520 :      72208   [  2.0% ]    138.945 ms
        npviewer.bin - 20542 :         35   [  0.0% ]      0.074 ms
        npviewer.bin - 20543 :         30   [  0.0% ]      0.074 ms
        npviewer.bin - 20547 :         35   [  0.0% ]      0.092 ms
        npviewer.bin - 20552 :         35   [  0.0% ]      0.093 ms
                sshd - 20645 :         32   [  0.0% ]      0.071 ms
        npviewer.bin - 21053 :         35   [  0.0% ]      0.074 ms
        npviewer.bin - 21054 :         35   [  0.0% ]      0.097 ms
         kworker/0:2 - 21169 :        149   [  0.0% ]      1.143 ms
         kworker/3:0 - 22171 :        113   [  0.0% ]     96.892 ms
         flush-253:4 - 22410 :          1   [  0.0% ]      0.028 ms
         kworker/6:0 - 24581 :         25   [  0.0% ]      0.275 ms
         kworker/1:0 - 25572 :          4   [  0.0% ]      0.103 ms
         kworker/2:1 - 26299 :        138   [  0.0% ]      1.440 ms
         kworker/0:0 - 26325 :          1   [  0.0% ]      0.003 ms
                perf - 26330 :    3506967   [ 96.1% ]   6648.310 ms
[root@sandy ~]#

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/n/tip-mzuli0srnxyi1o029py6537x@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-trace.txt |    3 +
 tools/perf/builtin-trace.c              |   88 ++++++++++++++++++++++++++++++-
 2 files changed, 90 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index 38d4b68..68718cc 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -51,6 +51,9 @@ the thread executes on the designated CPUs. Default is to monitor all CPUs.
 --duration:
 	Show only events that had a duration greater than N.M ms.
 
+--sched:
+	Accrue thread runtime and provide a summary at the end of the session.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script[1]
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index c95a3e9..7932ffa 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -69,6 +69,7 @@ struct thread_trace {
 	bool		  entry_pending;
 	unsigned long	  nr_events;
 	char		  *entry_str;
+	double		  runtime_ms;
 };
 
 static struct thread_trace *thread_trace__new(void)
@@ -109,8 +110,10 @@ struct trace {
 	struct machine		host;
 	u64			base_time;
 	unsigned long		nr_events;
+	bool			sched;
 	bool			multiple_threads;
 	double			duration_filter;
+	double			runtime_ms;
 };
 
 static bool trace__filter_duration(struct trace *trace, double t)
@@ -389,6 +392,31 @@ out:
 	return 0;
 }
 
+static int trace__sched_stat_runtime(struct trace *trace, struct perf_evsel *evsel,
+				     struct perf_sample *sample)
+{
+        u64 runtime = perf_evsel__intval(evsel, sample, "runtime");
+	double runtime_ms = (double)runtime / NSEC_PER_MSEC;
+	struct thread *thread = machine__findnew_thread(&trace->host, sample->tid);
+	struct thread_trace *ttrace = thread__trace(thread);
+
+	if (ttrace == NULL)
+		goto out_dump;
+
+	ttrace->runtime_ms += runtime_ms;
+	trace->runtime_ms += runtime_ms;
+	return 0;
+
+out_dump:
+	printf("%s: comm=%s,pid=%u,runtime=%" PRIu64 ",vruntime=%" PRIu64 ")\n",
+	       evsel->name,
+	       perf_evsel__strval(evsel, sample, "comm"),
+	       (pid_t)perf_evsel__intval(evsel, sample, "pid"),
+	       runtime,
+	       perf_evsel__intval(evsel, sample, "vruntime"));
+	return 0;
+}
+
 static int trace__run(struct trace *trace, int argc, const char **argv)
 {
 	struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
@@ -408,6 +436,13 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 		goto out_delete_evlist;
 	}
 
+	if (trace->sched &&
+	    perf_evlist__add_newtp(evlist, "sched", "sched_stat_runtime",
+				   trace__sched_stat_runtime)) {
+		printf("Couldn't read the sched_stat_runtime tracepoint information!\n");
+		goto out_delete_evlist;
+	}
+
 	err = perf_evlist__create_maps(evlist, &trace->opts.target);
 	if (err < 0) {
 		printf("Problems parsing the target to trace, check your options!\n");
@@ -521,6 +556,51 @@ out:
 	return err;
 }
 
+static size_t trace__fprintf_threads_header(FILE *fp)
+{
+	size_t printed;
+
+	printed  = fprintf(fp, "\n _____________________________________________________________________\n");
+	printed += fprintf(fp," __)    Summary of events    (__\n\n");
+	printed += fprintf(fp,"              [ task - pid ]     [ events ] [ ratio ]  [ runtime ]\n");
+	printed += fprintf(fp," _____________________________________________________________________\n\n");
+
+	return printed;
+}
+
+static size_t trace__fprintf_thread_summary(struct trace *trace, FILE *fp)
+{
+	size_t printed = trace__fprintf_threads_header(fp);
+	struct rb_node *nd;
+
+	for (nd = rb_first(&trace->host.threads); nd; nd = rb_next(nd)) {
+		struct thread *thread = rb_entry(nd, struct thread, rb_node);
+		struct thread_trace *ttrace = thread->priv;
+		const char *color;
+		double ratio;
+
+		if (ttrace == NULL)
+			continue;
+
+		ratio = (double)ttrace->nr_events / trace->nr_events * 100.0;
+
+		color = PERF_COLOR_NORMAL;
+		if (ratio > 50.0)
+			color = PERF_COLOR_RED;
+		else if (ratio > 25.0)
+			color = PERF_COLOR_GREEN;
+		else if (ratio > 5.0)
+			color = PERF_COLOR_YELLOW;
+
+		printed += color_fprintf(fp, color, "%20s", thread->comm);
+		printed += fprintf(fp, " - %-5d :%11lu   [", thread->pid, ttrace->nr_events);
+		printed += color_fprintf(fp, color, "%5.1f%%", ratio);
+		printed += fprintf(fp, " ] %10.3f ms\n", ttrace->runtime_ms);
+	}
+
+	return printed;
+}
+
 static int trace__set_duration(const struct option *opt, const char *str,
 			       int unset __maybe_unused)
 {
@@ -571,6 +651,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_CALLBACK(0, "duration", &trace, "float",
 		     "show only events with duration > N.M ms",
 		     trace__set_duration),
+	OPT_BOOLEAN(0, "sched", &trace.sched, "show blocking scheduler events"),
 	OPT_END()
 	};
 	int err;
@@ -595,5 +676,10 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (!argc && perf_target__none(&trace.opts.target))
 		trace.opts.target.system_wide = true;
 
-	return trace__run(&trace, argc, argv);
+	err = trace__run(&trace, argc, argv);
+
+	if (trace.sched && !err)
+		trace__fprintf_thread_summary(&trace, stdout);
+
+	return err;
 }
