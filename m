Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab1AWB4x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 20:56:53 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59193 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab1AWB4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 20:56:43 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Denis Kirjanov <dkirjanov@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, Pingtian Han <phan@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/6] perf tools: Fix 64 bit integer format strings
Date: Sat, 22 Jan 2011 23:56:14 -0200
Message-Id: <1295747778-26186-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295747778-26186-1-git-send-email-acme@infradead.org>
References: <1295747778-26186-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Using %L[uxd] has issues in some architectures, like on ppc64.  Fix it
by making our 64 bit integers typedefs of stdint.h types and using
PRI[ux]64 like, for instance, git does.

Reported by Denis Kirjanov that provided a patch for one case, I went
and changed all cases.

Reported-by: Denis Kirjanov <dkirjanov@kernel.org>
Tested-by: Denis Kirjanov <dkirjanov@kernel.org>
LKML-Reference: <20110120093246.GA8031@hera.kernel.org>
Cc: Denis Kirjanov <dkirjanov@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Pingtian Han <phan@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c       |    6 +++---
 tools/perf/builtin-kmem.c           |    4 ++--
 tools/perf/builtin-lock.c           |    6 +++---
 tools/perf/builtin-record.c         |    2 +-
 tools/perf/builtin-report.c         |    2 +-
 tools/perf/builtin-sched.c          |   20 ++++++++++----------
 tools/perf/builtin-script.c         |    6 +++---
 tools/perf/builtin-stat.c           |    4 ++--
 tools/perf/builtin-test.c           |   14 +++++++-------
 tools/perf/builtin-top.c            |    9 +++++----
 tools/perf/util/event.c             |    5 +++--
 tools/perf/util/header.c            |    4 ++--
 tools/perf/util/hist.c              |   17 +++++++++--------
 tools/perf/util/map.c               |    3 ++-
 tools/perf/util/parse-events.c      |    2 +-
 tools/perf/util/probe-event.c       |    2 +-
 tools/perf/util/session.c           |   28 +++++++++++++++-------------
 tools/perf/util/svghelper.c         |    5 +++--
 tools/perf/util/symbol.c            |    9 +++++----
 tools/perf/util/types.h             |   10 ++++++----
 tools/perf/util/ui/browsers/hists.c |    2 +-
 tools/perf/util/ui/browsers/map.c   |    5 +++--
 tools/perf/util/values.c            |   10 +++++-----
 23 files changed, 93 insertions(+), 82 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index c056cdc..8879463 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -212,7 +212,7 @@ get_source_line(struct hist_entry *he, int len, const char *filename)
 			continue;
 
 		offset = start + i;
-		sprintf(cmd, "addr2line -e %s %016llx", filename, offset);
+		sprintf(cmd, "addr2line -e %s %016" PRIx64, filename, offset);
 		fp = popen(cmd, "r");
 		if (!fp)
 			continue;
@@ -270,9 +270,9 @@ static void hist_entry__print_hits(struct hist_entry *self)
 
 	for (offset = 0; offset < len; ++offset)
 		if (h->ip[offset] != 0)
-			printf("%*Lx: %Lu\n", BITS_PER_LONG / 2,
+			printf("%*" PRIx64 ": %" PRIu64 "\n", BITS_PER_LONG / 2,
 			       sym->start + offset, h->ip[offset]);
-	printf("%*s: %Lu\n", BITS_PER_LONG / 2, "h->sum", h->sum);
+	printf("%*s: %" PRIu64 "\n", BITS_PER_LONG / 2, "h->sum", h->sum);
 }
 
 static int hist_entry__tty_annotate(struct hist_entry *he)
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index def7ddc..d97256d 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -371,10 +371,10 @@ static void __print_result(struct rb_root *root, struct perf_session *session,
 			addr = data->ptr;
 
 		if (sym != NULL)
-			snprintf(buf, sizeof(buf), "%s+%Lx", sym->name,
+			snprintf(buf, sizeof(buf), "%s+%" PRIx64 "", sym->name,
 				 addr - map->unmap_ip(map, sym->start));
 		else
-			snprintf(buf, sizeof(buf), "%#Lx", addr);
+			snprintf(buf, sizeof(buf), "%#" PRIx64 "", addr);
 		printf(" %-34s |", buf);
 
 		printf(" %9llu/%-5lu | %9llu/%-5lu | %8lu | %8lu | %6.3f%%\n",
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index b9c6e54..2b36def 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -782,9 +782,9 @@ static void print_result(void)
 		pr_info("%10u ", st->nr_acquired);
 		pr_info("%10u ", st->nr_contended);
 
-		pr_info("%15llu ", st->wait_time_total);
-		pr_info("%15llu ", st->wait_time_max);
-		pr_info("%15llu ", st->wait_time_min == ULLONG_MAX ?
+		pr_info("%15" PRIu64 " ", st->wait_time_total);
+		pr_info("%15" PRIu64 " ", st->wait_time_max);
+		pr_info("%15" PRIu64 " ", st->wait_time_min == ULLONG_MAX ?
 		       0 : st->wait_time_min);
 		pr_info("\n");
 	}
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index fcd29e8..b2f729f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -817,7 +817,7 @@ static int __cmd_record(int argc, const char **argv)
 	 * Approximate RIP event size: 24 bytes.
 	 */
 	fprintf(stderr,
-		"[ perf record: Captured and wrote %.3f MB %s (~%lld samples) ]\n",
+		"[ perf record: Captured and wrote %.3f MB %s (~%" PRIu64 " samples) ]\n",
 		(double)bytes_written / 1024.0 / 1024.0,
 		output_name,
 		bytes_written / 24);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 75183a4..c27e31f 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -197,7 +197,7 @@ static int process_read_event(event_t *event, struct sample_data *sample __used,
 					   event->read.value);
 	}
 
-	dump_printf(": %d %d %s %Lu\n", event->read.pid, event->read.tid,
+	dump_printf(": %d %d %s %" PRIu64 "\n", event->read.pid, event->read.tid,
 		    attr ? __event_name(attr->type, attr->config) : "FAIL",
 		    event->read.value);
 
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 29e7ffd..29acb89 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -193,7 +193,7 @@ static void calibrate_run_measurement_overhead(void)
 	}
 	run_measurement_overhead = min_delta;
 
-	printf("run measurement overhead: %Ld nsecs\n", min_delta);
+	printf("run measurement overhead: %" PRIu64 " nsecs\n", min_delta);
 }
 
 static void calibrate_sleep_measurement_overhead(void)
@@ -211,7 +211,7 @@ static void calibrate_sleep_measurement_overhead(void)
 	min_delta -= 10000;
 	sleep_measurement_overhead = min_delta;
 
-	printf("sleep measurement overhead: %Ld nsecs\n", min_delta);
+	printf("sleep measurement overhead: %" PRIu64 " nsecs\n", min_delta);
 }
 
 static struct sched_atom *
@@ -617,13 +617,13 @@ static void test_calibrations(void)
 	burn_nsecs(1e6);
 	T1 = get_nsecs();
 
-	printf("the run test took %Ld nsecs\n", T1-T0);
+	printf("the run test took %" PRIu64 " nsecs\n", T1 - T0);
 
 	T0 = get_nsecs();
 	sleep_nsecs(1e6);
 	T1 = get_nsecs();
 
-	printf("the sleep test took %Ld nsecs\n", T1-T0);
+	printf("the sleep test took %" PRIu64 " nsecs\n", T1 - T0);
 }
 
 #define FILL_FIELD(ptr, field, event, data)	\
@@ -816,10 +816,10 @@ replay_switch_event(struct trace_switch_event *switch_event,
 		delta = 0;
 
 	if (delta < 0)
-		die("hm, delta: %Ld < 0 ?\n", delta);
+		die("hm, delta: %" PRIu64 " < 0 ?\n", delta);
 
 	if (verbose) {
-		printf(" ... switch from %s/%d to %s/%d [ran %Ld nsecs]\n",
+		printf(" ... switch from %s/%d to %s/%d [ran %" PRIu64 " nsecs]\n",
 			switch_event->prev_comm, switch_event->prev_pid,
 			switch_event->next_comm, switch_event->next_pid,
 			delta);
@@ -1048,7 +1048,7 @@ latency_switch_event(struct trace_switch_event *switch_event,
 		delta = 0;
 
 	if (delta < 0)
-		die("hm, delta: %Ld < 0 ?\n", delta);
+		die("hm, delta: %" PRIu64 " < 0 ?\n", delta);
 
 
 	sched_out = perf_session__findnew(session, switch_event->prev_pid);
@@ -1221,7 +1221,7 @@ static void output_lat_thread(struct work_atoms *work_list)
 
 	avg = work_list->total_lat / work_list->nb_atoms;
 
-	printf("|%11.3f ms |%9llu | avg:%9.3f ms | max:%9.3f ms | max at: %9.6f s\n",
+	printf("|%11.3f ms |%9" PRIu64 " | avg:%9.3f ms | max:%9.3f ms | max at: %9.6f s\n",
 	      (double)work_list->total_runtime / 1e6,
 		 work_list->nb_atoms, (double)avg / 1e6,
 		 (double)work_list->max_lat / 1e6,
@@ -1423,7 +1423,7 @@ map_switch_event(struct trace_switch_event *switch_event,
 		delta = 0;
 
 	if (delta < 0)
-		die("hm, delta: %Ld < 0 ?\n", delta);
+		die("hm, delta: %" PRIu64 " < 0 ?\n", delta);
 
 
 	sched_out = perf_session__findnew(session, switch_event->prev_pid);
@@ -1713,7 +1713,7 @@ static void __cmd_lat(void)
 	}
 
 	printf(" -----------------------------------------------------------------------------------------\n");
-	printf("  TOTAL:                |%11.3f ms |%9Ld |\n",
+	printf("  TOTAL:                |%11.3f ms |%9" PRIu64 " |\n",
 		(double)all_runtime/1e6, all_count);
 
 	printf(" ---------------------------------------------------\n");
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 150a606..b766c2a 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -77,8 +77,8 @@ static int process_sample_event(event_t *event, struct sample_data *sample,
 	if (session->sample_type & PERF_SAMPLE_RAW) {
 		if (debug_mode) {
 			if (sample->time < last_timestamp) {
-				pr_err("Samples misordered, previous: %llu "
-					"this: %llu\n", last_timestamp,
+				pr_err("Samples misordered, previous: %" PRIu64
+					" this: %" PRIu64 "\n", last_timestamp,
 					sample->time);
 				nr_unordered++;
 			}
@@ -126,7 +126,7 @@ static int __cmd_script(struct perf_session *session)
 	ret = perf_session__process_events(session, &event_ops);
 
 	if (debug_mode)
-		pr_err("Misordered timestamps: %llu\n", nr_unordered);
+		pr_err("Misordered timestamps: %" PRIu64 "\n", nr_unordered);
 
 	return ret;
 }
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 0ff11d9..a482a19 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -206,8 +206,8 @@ static int read_counter_aggr(struct perf_evsel *counter)
 		update_stats(&ps->res_stats[i], count[i]);
 
 	if (verbose) {
-		fprintf(stderr, "%s: %Ld %Ld %Ld\n", event_name(counter),
-				count[0], count[1], count[2]);
+		fprintf(stderr, "%s: %" PRIu64 " %" PRIu64 " %" PRIu64 "\n",
+			event_name(counter), count[0], count[1], count[2]);
 	}
 
 	/*
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 0e01834..5dcdba6 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -146,7 +146,7 @@ next_pair:
 				if (llabs(skew) < page_size)
 					continue;
 
-				pr_debug("%#Lx: diff end addr for %s v: %#Lx k: %#Lx\n",
+				pr_debug("%#" PRIx64 ": diff end addr for %s v: %#" PRIx64 " k: %#" PRIx64 "\n",
 					 sym->start, sym->name, sym->end, pair->end);
 			} else {
 				struct rb_node *nnd;
@@ -168,11 +168,11 @@ detour:
 					goto detour;
 				}
 
-				pr_debug("%#Lx: diff name v: %s k: %s\n",
+				pr_debug("%#" PRIx64 ": diff name v: %s k: %s\n",
 					 sym->start, sym->name, pair->name);
 			}
 		} else
-			pr_debug("%#Lx: %s not on kallsyms\n", sym->start, sym->name);
+			pr_debug("%#" PRIx64 ": %s not on kallsyms\n", sym->start, sym->name);
 
 		err = -1;
 	}
@@ -211,10 +211,10 @@ detour:
 
 		if (pair->start == pos->start) {
 			pair->priv = 1;
-			pr_info(" %Lx-%Lx %Lx %s in kallsyms as",
+			pr_info(" %" PRIx64 "-%" PRIx64 " %" PRIx64 " %s in kallsyms as",
 				pos->start, pos->end, pos->pgoff, pos->dso->name);
 			if (pos->pgoff != pair->pgoff || pos->end != pair->end)
-				pr_info(": \n*%Lx-%Lx %Lx",
+				pr_info(": \n*%" PRIx64 "-%" PRIx64 " %" PRIx64 "",
 					pair->start, pair->end, pair->pgoff);
 			pr_info(" %s\n", pair->dso->name);
 			pair->priv = 1;
@@ -307,7 +307,7 @@ static int test__open_syscall_event(void)
 	}
 
 	if (evsel->counts->cpu[0].val != nr_open_calls) {
-		pr_debug("perf_evsel__read_on_cpu: expected to intercept %d calls, got %Ld\n",
+		pr_debug("perf_evsel__read_on_cpu: expected to intercept %d calls, got %" PRIu64 "\n",
 			 nr_open_calls, evsel->counts->cpu[0].val);
 		goto out_close_fd;
 	}
@@ -421,7 +421,7 @@ static int test__open_syscall_event_on_all_cpus(void)
 
 		expected = nr_open_calls + cpu;
 		if (evsel->counts->cpu[cpu].val != expected) {
-			pr_debug("perf_evsel__read_on_cpu: expected to intercept %d calls on cpu %d, got %Ld\n",
+			pr_debug("perf_evsel__read_on_cpu: expected to intercept %d calls on cpu %d, got %" PRIu64 "\n",
 				 expected, cpus->map[cpu], evsel->counts->cpu[cpu].val);
 			goto out_close_fd;
 		}
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 05344c6..b6998e0 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -40,6 +40,7 @@
 #include <stdio.h>
 #include <termios.h>
 #include <unistd.h>
+#include <inttypes.h>
 
 #include <errno.h>
 #include <time.h>
@@ -214,7 +215,7 @@ static int parse_source(struct sym_entry *syme)
 	len = sym->end - sym->start;
 
 	sprintf(command,
-		"objdump --start-address=%#0*Lx --stop-address=%#0*Lx -dS %s",
+		"objdump --start-address=%#0*" PRIx64 " --stop-address=%#0*" PRIx64 " -dS %s",
 		BITS_PER_LONG / 4, map__rip_2objdump(map, sym->start),
 		BITS_PER_LONG / 4, map__rip_2objdump(map, sym->end), path);
 
@@ -308,7 +309,7 @@ static void lookup_sym_source(struct sym_entry *syme)
 	struct source_line *line;
 	char pattern[PATTERN_LEN + 1];
 
-	sprintf(pattern, "%0*Lx <", BITS_PER_LONG / 4,
+	sprintf(pattern, "%0*" PRIx64 " <", BITS_PER_LONG / 4,
 		map__rip_2objdump(syme->map, symbol->start));
 
 	pthread_mutex_lock(&syme->src->lock);
@@ -537,7 +538,7 @@ static void print_sym_table(void)
 	if (nr_counters == 1 || !display_weighted) {
 		struct perf_evsel *first;
 		first = list_entry(evsel_list.next, struct perf_evsel, node);
-		printf("%Ld", first->attr.sample_period);
+		printf("%" PRIu64, (uint64_t)first->attr.sample_period);
 		if (freq)
 			printf("Hz ");
 		else
@@ -640,7 +641,7 @@ static void print_sym_table(void)
 
 		percent_color_fprintf(stdout, "%4.1f%%", pcnt);
 		if (verbose)
-			printf(" %016llx", sym->start);
+			printf(" %016" PRIx64, sym->start);
 		printf(" %-*.*s", sym_width, sym_width, sym->name);
 		printf(" %-*.*s\n", dso_width, dso_width,
 		       dso_width >= syme->map->dso->long_name_len ?
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 2302ec0..1478ab4 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -459,7 +459,8 @@ int event__process_comm(event_t *self, struct sample_data *sample __used,
 int event__process_lost(event_t *self, struct sample_data *sample __used,
 			struct perf_session *session)
 {
-	dump_printf(": id:%Ld: lost:%Ld\n", self->lost.id, self->lost.lost);
+	dump_printf(": id:%" PRIu64 ": lost:%" PRIu64 "\n",
+		    self->lost.id, self->lost.lost);
 	session->hists.stats.total_lost += self->lost.lost;
 	return 0;
 }
@@ -575,7 +576,7 @@ int event__process_mmap(event_t *self, struct sample_data *sample __used,
 	u8 cpumode = self->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 	int ret = 0;
 
-	dump_printf(" %d/%d: [%#Lx(%#Lx) @ %#Lx]: %s\n",
+	dump_printf(" %d/%d: [%#" PRIx64 "(%#" PRIx64 ") @ %#" PRIx64 "]: %s\n",
 			self->mmap.pid, self->mmap.tid, self->mmap.start,
 			self->mmap.len, self->mmap.pgoff, self->mmap.filename);
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 989fa2d..f6a929e 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -798,8 +798,8 @@ static int perf_file_section__process(struct perf_file_section *self,
 				      int feat, int fd)
 {
 	if (lseek(fd, self->offset, SEEK_SET) == (off_t)-1) {
-		pr_debug("Failed to lseek to %Ld offset for feature %d, "
-			 "continuing...\n", self->offset, feat);
+		pr_debug("Failed to lseek to %" PRIu64 " offset for feature "
+			  "%d, continuing...\n", self->offset, feat);
 		return 0;
 	}
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index c749ba6..32f4f1f 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -636,13 +636,13 @@ int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
 			}
 		}
 	} else
-		ret = snprintf(s, size, sep ? "%lld" : "%12lld ", period);
+		ret = snprintf(s, size, sep ? "%" PRIu64 : "%12" PRIu64 " ", period);
 
 	if (symbol_conf.show_nr_samples) {
 		if (sep)
-			ret += snprintf(s + ret, size - ret, "%c%lld", *sep, period);
+			ret += snprintf(s + ret, size - ret, "%c%" PRIu64, *sep, period);
 		else
-			ret += snprintf(s + ret, size - ret, "%11lld", period);
+			ret += snprintf(s + ret, size - ret, "%11" PRIu64, period);
 	}
 
 	if (pair_hists) {
@@ -971,7 +971,7 @@ int hist_entry__inc_addr_samples(struct hist_entry *self, u64 ip)
 	sym_size = sym->end - sym->start;
 	offset = ip - sym->start;
 
-	pr_debug3("%s: ip=%#Lx\n", __func__, self->ms.map->unmap_ip(self->ms.map, ip));
+	pr_debug3("%s: ip=%#" PRIx64 "\n", __func__, self->ms.map->unmap_ip(self->ms.map, ip));
 
 	if (offset >= sym_size)
 		return 0;
@@ -980,8 +980,9 @@ int hist_entry__inc_addr_samples(struct hist_entry *self, u64 ip)
 	h->sum++;
 	h->ip[offset]++;
 
-	pr_debug3("%#Lx %s: period++ [ip: %#Lx, %#Lx] => %Ld\n", self->ms.sym->start,
-		  self->ms.sym->name, ip, ip - self->ms.sym->start, h->ip[offset]);
+	pr_debug3("%#" PRIx64 " %s: period++ [ip: %#" PRIx64 ", %#" PRIx64
+		  "] => %" PRIu64 "\n", self->ms.sym->start, self->ms.sym->name,
+		  ip, ip - self->ms.sym->start, h->ip[offset]);
 	return 0;
 }
 
@@ -1132,7 +1133,7 @@ fallback:
 		goto out_free_filename;
 	}
 
-	pr_debug("%s: filename=%s, sym=%s, start=%#Lx, end=%#Lx\n", __func__,
+	pr_debug("%s: filename=%s, sym=%s, start=%#" PRIx64 ", end=%#" PRIx64 "\n", __func__,
 		 filename, sym->name, map->unmap_ip(map, sym->start),
 		 map->unmap_ip(map, sym->end));
 
@@ -1142,7 +1143,7 @@ fallback:
 		 dso, dso->long_name, sym, sym->name);
 
 	snprintf(command, sizeof(command),
-		 "objdump --start-address=0x%016Lx --stop-address=0x%016Lx -dS -C %s|grep -v %s|expand",
+		 "objdump --start-address=0x%016" PRIx64 " --stop-address=0x%016" PRIx64 " -dS -C %s|grep -v %s|expand",
 		 map__rip_2objdump(map, sym->start),
 		 map__rip_2objdump(map, sym->end),
 		 symfs_filename, filename);
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 3a7eb6e..a16ecab 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -1,5 +1,6 @@
 #include "symbol.h"
 #include <errno.h>
+#include <inttypes.h>
 #include <limits.h>
 #include <stdlib.h>
 #include <string.h>
@@ -195,7 +196,7 @@ int map__overlap(struct map *l, struct map *r)
 
 size_t map__fprintf(struct map *self, FILE *fp)
 {
-	return fprintf(fp, " %Lx-%Lx %Lx %s\n",
+	return fprintf(fp, " %" PRIx64 "-%" PRIx64 " %" PRIx64 " %s\n",
 		       self->start, self->end, self->pgoff, self->dso->name);
 }
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index bc2732e..135f69b 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -279,7 +279,7 @@ const char *__event_name(int type, u64 config)
 	static char buf[32];
 
 	if (type == PERF_TYPE_RAW) {
-		sprintf(buf, "raw 0x%llx", config);
+		sprintf(buf, "raw 0x%" PRIx64, config);
 		return buf;
 	}
 
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 128aaab..6e29d9c 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -172,7 +172,7 @@ static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
 	sym = __find_kernel_function_by_name(tp->symbol, &map);
 	if (sym) {
 		addr = map->unmap_ip(map, sym->start + tp->offset);
-		pr_debug("try to find %s+%ld@%llx\n", tp->symbol,
+		pr_debug("try to find %s+%ld@%" PRIx64 "\n", tp->symbol,
 			 tp->offset, addr);
 		ret = find_perf_probe_point((unsigned long)addr, pp);
 	}
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 313dac2..105f00b 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -652,10 +652,11 @@ static void callchain__printf(struct sample_data *sample)
 {
 	unsigned int i;
 
-	printf("... chain: nr:%Lu\n", sample->callchain->nr);
+	printf("... chain: nr:%" PRIu64 "\n", sample->callchain->nr);
 
 	for (i = 0; i < sample->callchain->nr; i++)
-		printf("..... %2d: %016Lx\n", i, sample->callchain->ips[i]);
+		printf("..... %2d: %016" PRIx64 "\n",
+		       i, sample->callchain->ips[i]);
 }
 
 static void perf_session__print_tstamp(struct perf_session *session,
@@ -672,7 +673,7 @@ static void perf_session__print_tstamp(struct perf_session *session,
 		printf("%u ", sample->cpu);
 
 	if (session->sample_type & PERF_SAMPLE_TIME)
-		printf("%Lu ", sample->time);
+		printf("%" PRIu64 " ", sample->time);
 }
 
 static void dump_event(struct perf_session *session, event_t *event,
@@ -681,16 +682,16 @@ static void dump_event(struct perf_session *session, event_t *event,
 	if (!dump_trace)
 		return;
 
-	printf("\n%#Lx [%#x]: event: %d\n", file_offset, event->header.size,
-	       event->header.type);
+	printf("\n%#" PRIx64 " [%#x]: event: %d\n",
+	       file_offset, event->header.size, event->header.type);
 
 	trace_event(event);
 
 	if (sample)
 		perf_session__print_tstamp(session, event, sample);
 
-	printf("%#Lx [%#x]: PERF_RECORD_%s", file_offset, event->header.size,
-	       event__get_event_name(event->header.type));
+	printf("%#" PRIx64 " [%#x]: PERF_RECORD_%s", file_offset,
+	       event->header.size, event__get_event_name(event->header.type));
 }
 
 static void dump_sample(struct perf_session *session, event_t *event,
@@ -699,8 +700,9 @@ static void dump_sample(struct perf_session *session, event_t *event,
 	if (!dump_trace)
 		return;
 
-	printf("(IP, %d): %d/%d: %#Lx period: %Ld\n", event->header.misc,
-	       sample->pid, sample->tid, sample->ip, sample->period);
+	printf("(IP, %d): %d/%d: %#" PRIx64 " period: %" PRIu64 "\n",
+	       event->header.misc, sample->pid, sample->tid, sample->ip,
+	       sample->period);
 
 	if (session->sample_type & PERF_SAMPLE_CALLCHAIN)
 		callchain__printf(sample);
@@ -843,8 +845,8 @@ static void perf_session__warn_about_errors(const struct perf_session *session,
 {
 	if (ops->lost == event__process_lost &&
 	    session->hists.stats.total_lost != 0) {
-		ui__warning("Processed %Lu events and LOST %Lu!\n\n"
-			    "Check IO/CPU overload!\n\n",
+		ui__warning("Processed %" PRIu64 " events and LOST %" PRIu64
+			    "!\n\nCheck IO/CPU overload!\n\n",
 			    session->hists.stats.total_period,
 			    session->hists.stats.total_lost);
 	}
@@ -918,7 +920,7 @@ more:
 
 	if (size == 0 ||
 	    (skip = perf_session__process_event(self, &event, ops, head)) < 0) {
-		dump_printf("%#Lx [%#x]: skipping unknown header type: %d\n",
+		dump_printf("%#" PRIx64 " [%#x]: skipping unknown header type: %d\n",
 			    head, event.header.size, event.header.type);
 		/*
 		 * assume we lost track of the stream, check alignment, and
@@ -1023,7 +1025,7 @@ more:
 
 	if (size == 0 ||
 	    perf_session__process_event(session, event, ops, file_pos) < 0) {
-		dump_printf("%#Lx [%#x]: skipping unknown header type: %d\n",
+		dump_printf("%#" PRIx64 " [%#x]: skipping unknown header type: %d\n",
 			    file_offset + head, event->header.size,
 			    event->header.type);
 		/*
diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index b3637db..805220a 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -12,6 +12,7 @@
  * of the License.
  */
 
+#include <inttypes.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
@@ -94,7 +95,7 @@ void open_svg(const char *filename, int cpus, int rows, u64 start, u64 end)
 
 	total_height = (1 + rows + cpu2slot(cpus)) * SLOT_MULT;
 	fprintf(svgfile, "<?xml version=\"1.0\" standalone=\"no\"?> \n");
-	fprintf(svgfile, "<svg width=\"%i\" height=\"%llu\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">\n", svg_page_width, total_height);
+	fprintf(svgfile, "<svg width=\"%i\" height=\"%" PRIu64 "\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">\n", svg_page_width, total_height);
 
 	fprintf(svgfile, "<defs>\n  <style type=\"text/css\">\n    <![CDATA[\n");
 
@@ -483,7 +484,7 @@ void svg_time_grid(void)
 			color = 128;
 		}
 
-		fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%llu\" style=\"stroke:rgb(%i,%i,%i);stroke-width:%1.3f\"/>\n",
+		fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%" PRIu64 "\" style=\"stroke:rgb(%i,%i,%i);stroke-width:%1.3f\"/>\n",
 			time2pixels(i), SLOT_MULT/2, time2pixels(i), total_height, color, color, color, thickness);
 
 		i += 10000000;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e32478e..7821d0e 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -11,6 +11,7 @@
 #include <sys/param.h>
 #include <fcntl.h>
 #include <unistd.h>
+#include <inttypes.h>
 #include "build-id.h"
 #include "debug.h"
 #include "symbol.h"
@@ -153,7 +154,7 @@ static struct symbol *symbol__new(u64 start, u64 len, u8 binding,
 	self->binding = binding;
 	self->namelen = namelen - 1;
 
-	pr_debug4("%s: %s %#Lx-%#Lx\n", __func__, name, start, self->end);
+	pr_debug4("%s: %s %#" PRIx64 "-%#" PRIx64 "\n", __func__, name, start, self->end);
 
 	memcpy(self->name, name, namelen);
 
@@ -167,7 +168,7 @@ void symbol__delete(struct symbol *self)
 
 static size_t symbol__fprintf(struct symbol *self, FILE *fp)
 {
-	return fprintf(fp, " %llx-%llx %c %s\n",
+	return fprintf(fp, " %" PRIx64 "-%" PRIx64 " %c %s\n",
 		       self->start, self->end,
 		       self->binding == STB_GLOBAL ? 'g' :
 		       self->binding == STB_LOCAL  ? 'l' : 'w',
@@ -1215,8 +1216,8 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 		}
 
 		if (curr_dso->adjust_symbols) {
-			pr_debug4("%s: adjusting symbol: st_value: %#Lx "
-				  "sh_addr: %#Lx sh_offset: %#Lx\n", __func__,
+			pr_debug4("%s: adjusting symbol: st_value: %#" PRIx64 " "
+				  "sh_addr: %#" PRIx64 " sh_offset: %#" PRIx64 "\n", __func__,
 				  (u64)sym.st_value, (u64)shdr.sh_addr,
 				  (u64)shdr.sh_offset);
 			sym.st_value -= shdr.sh_addr - shdr.sh_offset;
diff --git a/tools/perf/util/types.h b/tools/perf/util/types.h
index 7d6b833..5f3689a 100644
--- a/tools/perf/util/types.h
+++ b/tools/perf/util/types.h
@@ -1,12 +1,14 @@
 #ifndef __PERF_TYPES_H
 #define __PERF_TYPES_H
 
+#include <stdint.h>
+
 /*
- * We define u64 as unsigned long long for every architecture
- * so that we can print it with %Lx without getting warnings.
+ * We define u64 as uint64_t for every architecture
+ * so that we can print it with "%"PRIx64 without getting warnings.
  */
-typedef unsigned long long u64;
-typedef signed long long   s64;
+typedef uint64_t	   u64;
+typedef int64_t		   s64;
 typedef unsigned int	   u32;
 typedef signed int	   s32;
 typedef unsigned short	   u16;
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index ebda8c3..60c463c 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -350,7 +350,7 @@ static char *callchain_list__sym_name(struct callchain_list *self,
 	if (self->ms.sym)
 		return self->ms.sym->name;
 
-	snprintf(bf, bfsize, "%#Lx", self->ip);
+	snprintf(bf, bfsize, "%#" PRIx64, self->ip);
 	return bf;
 }
 
diff --git a/tools/perf/util/ui/browsers/map.c b/tools/perf/util/ui/browsers/map.c
index e35437d..e515836 100644
--- a/tools/perf/util/ui/browsers/map.c
+++ b/tools/perf/util/ui/browsers/map.c
@@ -1,5 +1,6 @@
 #include "../libslang.h"
 #include <elf.h>
+#include <inttypes.h>
 #include <sys/ttydefaults.h>
 #include <ctype.h>
 #include <string.h>
@@ -57,7 +58,7 @@ static void map_browser__write(struct ui_browser *self, void *nd, int row)
 	int width;
 
 	ui_browser__set_percent_color(self, 0, current_entry);
-	slsmg_printf("%*llx %*llx %c ",
+	slsmg_printf("%*" PRIx64 " %*" PRIx64 " %c ",
 		     mb->addrlen, sym->start, mb->addrlen, sym->end,
 		     sym->binding == STB_GLOBAL ? 'g' :
 		     sym->binding == STB_LOCAL  ? 'l' : 'w');
@@ -150,6 +151,6 @@ int map__browse(struct map *self)
 		++mb.b.nr_entries;
 	}
 
-	mb.addrlen = snprintf(tmp, sizeof(tmp), "%llx", maxaddr);
+	mb.addrlen = snprintf(tmp, sizeof(tmp), "%" PRIx64, maxaddr);
 	return map_browser__run(&mb);
 }
diff --git a/tools/perf/util/values.c b/tools/perf/util/values.c
index cfa55d6..bdd3347 100644
--- a/tools/perf/util/values.c
+++ b/tools/perf/util/values.c
@@ -150,7 +150,7 @@ static void perf_read_values__display_pretty(FILE *fp,
 		if (width > tidwidth)
 			tidwidth = width;
 		for (j = 0; j < values->counters; j++) {
-			width = snprintf(NULL, 0, "%Lu", values->value[i][j]);
+			width = snprintf(NULL, 0, "%" PRIu64, values->value[i][j]);
 			if (width > counterwidth[j])
 				counterwidth[j] = width;
 		}
@@ -165,7 +165,7 @@ static void perf_read_values__display_pretty(FILE *fp,
 		fprintf(fp, "  %*d  %*d", pidwidth, values->pid[i],
 			tidwidth, values->tid[i]);
 		for (j = 0; j < values->counters; j++)
-			fprintf(fp, "  %*Lu",
+			fprintf(fp, "  %*" PRIu64,
 				counterwidth[j], values->value[i][j]);
 		fprintf(fp, "\n");
 	}
@@ -196,13 +196,13 @@ static void perf_read_values__display_raw(FILE *fp,
 		width = strlen(values->countername[j]);
 		if (width > namewidth)
 			namewidth = width;
-		width = snprintf(NULL, 0, "%llx", values->counterrawid[j]);
+		width = snprintf(NULL, 0, "%" PRIx64, values->counterrawid[j]);
 		if (width > rawwidth)
 			rawwidth = width;
 	}
 	for (i = 0; i < values->threads; i++) {
 		for (j = 0; j < values->counters; j++) {
-			width = snprintf(NULL, 0, "%Lu", values->value[i][j]);
+			width = snprintf(NULL, 0, "%" PRIu64, values->value[i][j]);
 			if (width > countwidth)
 				countwidth = width;
 		}
@@ -214,7 +214,7 @@ static void perf_read_values__display_raw(FILE *fp,
 		countwidth, "Count");
 	for (i = 0; i < values->threads; i++)
 		for (j = 0; j < values->counters; j++)
-			fprintf(fp, "  %*d  %*d  %*s  %*llx  %*Lu\n",
+			fprintf(fp, "  %*d  %*d  %*s  %*" PRIx64 "  %*" PRIu64,
 				pidwidth, values->pid[i],
 				tidwidth, values->tid[i],
 				namewidth, values->countername[j],
-- 
1.6.2.5

