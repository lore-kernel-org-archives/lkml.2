Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375Ab1AWNAz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 08:00:55 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39195 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab1AWNAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 08:00:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:x-url:user-agent;
        b=Aw2/5EnMcN6plkHoHym5WUzZruSfDZ7JlaylVNADuEJDy+/qWQBdjrf4w1ytJ3cAvV
         Kb4fhMli+xwGpp2JeH+Blm63/sVD5nhpYoryudZQRXNNDEND3qM7T4GUDOvCKtK5QY2p
         LZRLHHXpR875L6v7diHgsHubLhy2Y53mUWbnM=
Date: Sun, 23 Jan 2011 11:00:44 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/6] perf test: Fix build on older glibcs
Message-ID: <20110123130044.GA19537@ghostprotocols.net>
References: <1295747778-26186-1-git-send-email-acme@infradead.org>
 <1295747778-26186-2-git-send-email-acme@infradead.org>
 <1295771376.17333.1.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1295771376.17333.1.camel@edumazet-laptop>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Em Sun, Jan 23, 2011 at 09:29:36AM +0100, Eric Dumazet escreveu:
> Le samedi 22 janvier 2011 à 23:56 -0200, Arnaldo Carvalho de Melo a écrit :
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>

> > Where we don't have CPU_ALLOC & friends. As the tools are being used in older
> > distros where the only allowed change are to replace the kernel, like RHEL4 & 5.
> > Reported-by: Eric Dumazet <eric.dumazet@gmail.com>

> I tested the preliminary version you sent me, it worked well, but I
> could not apply this patch to current linux-2.6

There is at least one patch in perf/urgent that should be applied before
this one:

commit ffb5e0fb44d0829021a51f972df90166bc9b700e
Author: Han Pingtian <phan@redhat.com>

    perf test: Use cpu_map->[cpu] when setting affinity

-----------------------------------------------------------

Attached goes a combined patch with everything that is not yet in
.38-rc2, please test it. It is all about fixing the build in old
distros and in some arches like ppc64 where using %L[dux] in printf
functions is problematic.

I just checkd out a fresh copy of 2.6.38-rc2 and applied and built with
it.

- Arnaldo

--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="tip-perf-urgent.patch"

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2b5387d..7141c42 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -204,13 +204,11 @@ EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wshadow
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Winit-self
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wpacked
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wredundant-decls
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstack-protector
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-aliasing=3
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-default
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-enum
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wno-system-headers
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wundef
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wvolatile-register-var
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wwrite-strings
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wbad-function-cast
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wmissing-declarations
@@ -294,6 +292,13 @@ ifeq ($(call try-cc,$(SOURCE_HELLO),-Werror -fstack-protector-all),y)
 	CFLAGS := $(CFLAGS) -fstack-protector-all
 endif
 
+ifeq ($(call try-cc,$(SOURCE_HELLO),-Werror -Wstack-protector),y)
+       CFLAGS := $(CFLAGS) -Wstack-protector
+endif
+
+ifeq ($(call try-cc,$(SOURCE_HELLO),-Werror -Wvolatile-register-var),y)
+       CFLAGS := $(CFLAGS) -Wvolatile-register-var
+endif
 
 ### --- END CONFIGURATION SECTION ---
 
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
index ed56961..5dcdba6 100644
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
@@ -332,8 +332,7 @@ static int test__open_syscall_event_on_all_cpus(void)
 	struct perf_evsel *evsel;
 	struct perf_event_attr attr;
 	unsigned int nr_open_calls = 111, i;
-	cpu_set_t *cpu_set;
-	size_t cpu_set_size;
+	cpu_set_t cpu_set;
 	int id = trace_event__id("sys_enter_open");
 
 	if (id < 0) {
@@ -353,13 +352,8 @@ static int test__open_syscall_event_on_all_cpus(void)
 		return -1;
 	}
 
-	cpu_set = CPU_ALLOC(cpus->nr);
 
-	if (cpu_set == NULL)
-		goto out_thread_map_delete;
-
-	cpu_set_size = CPU_ALLOC_SIZE(cpus->nr);
-	CPU_ZERO_S(cpu_set_size, cpu_set);
+	CPU_ZERO(&cpu_set);
 
 	memset(&attr, 0, sizeof(attr));
 	attr.type = PERF_TYPE_TRACEPOINT;
@@ -367,7 +361,7 @@ static int test__open_syscall_event_on_all_cpus(void)
 	evsel = perf_evsel__new(&attr, 0);
 	if (evsel == NULL) {
 		pr_debug("perf_evsel__new\n");
-		goto out_cpu_free;
+		goto out_thread_map_delete;
 	}
 
 	if (perf_evsel__open(evsel, cpus, threads) < 0) {
@@ -379,14 +373,29 @@ static int test__open_syscall_event_on_all_cpus(void)
 
 	for (cpu = 0; cpu < cpus->nr; ++cpu) {
 		unsigned int ncalls = nr_open_calls + cpu;
+		/*
+		 * XXX eventually lift this restriction in a way that
+		 * keeps perf building on older glibc installations
+		 * without CPU_ALLOC. 1024 cpus in 2010 still seems
+		 * a reasonable upper limit tho :-)
+		 */
+		if (cpus->map[cpu] >= CPU_SETSIZE) {
+			pr_debug("Ignoring CPU %d\n", cpus->map[cpu]);
+			continue;
+		}
 
-		CPU_SET(cpu, cpu_set);
-		sched_setaffinity(0, cpu_set_size, cpu_set);
+		CPU_SET(cpus->map[cpu], &cpu_set);
+		if (sched_setaffinity(0, sizeof(cpu_set), &cpu_set) < 0) {
+			pr_debug("sched_setaffinity() failed on CPU %d: %s ",
+				 cpus->map[cpu],
+				 strerror(errno));
+			goto out_close_fd;
+		}
 		for (i = 0; i < ncalls; ++i) {
 			fd = open("/etc/passwd", O_RDONLY);
 			close(fd);
 		}
-		CPU_CLR(cpu, cpu_set);
+		CPU_CLR(cpus->map[cpu], &cpu_set);
 	}
 
 	/*
@@ -402,6 +411,9 @@ static int test__open_syscall_event_on_all_cpus(void)
 	for (cpu = 0; cpu < cpus->nr; ++cpu) {
 		unsigned int expected;
 
+		if (cpus->map[cpu] >= CPU_SETSIZE)
+			continue;
+
 		if (perf_evsel__read_on_cpu(evsel, cpu, 0) < 0) {
 			pr_debug("perf_evsel__open_read_on_cpu\n");
 			goto out_close_fd;
@@ -409,8 +421,8 @@ static int test__open_syscall_event_on_all_cpus(void)
 
 		expected = nr_open_calls + cpu;
 		if (evsel->counts->cpu[cpu].val != expected) {
-			pr_debug("perf_evsel__read_on_cpu: expected to intercept %d calls on cpu %d, got %Ld\n",
-				 expected, cpu, evsel->counts->cpu[cpu].val);
+			pr_debug("perf_evsel__read_on_cpu: expected to intercept %d calls on cpu %d, got %" PRIu64 "\n",
+				 expected, cpus->map[cpu], evsel->counts->cpu[cpu].val);
 			goto out_close_fd;
 		}
 	}
@@ -420,8 +432,6 @@ out_close_fd:
 	perf_evsel__close_fd(evsel, 1, threads->nr);
 out_evsel_delete:
 	perf_evsel__delete(evsel);
-out_cpu_free:
-	CPU_FREE(cpu_set);
 out_thread_map_delete:
 	thread_map__delete(threads);
 	return err;
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
index 989fa2d..f6a929e7 100644
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
diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index 8be0b96..305c848 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -2,6 +2,7 @@
 #define _PERF_LINUX_BITOPS_H_
 
 #include <linux/kernel.h>
+#include <linux/compiler.h>
 #include <asm/hweight.h>
 
 #define BITS_PER_LONG __WORDSIZE
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
 
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index b82cafb..458e3ec 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -23,7 +23,7 @@ struct tracepoint_path {
 };
 
 extern struct tracepoint_path *tracepoint_id_to_path(u64 config);
-extern bool have_tracepoints(struct list_head *evsel_list);
+extern bool have_tracepoints(struct list_head *evlist);
 
 extern int			nr_counters;
 
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
index b3637db..fb737fe 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -12,6 +12,7 @@
  * of the License.
  */
 
+#include <inttypes.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
@@ -43,11 +44,11 @@ static double cpu2y(int cpu)
 	return cpu2slot(cpu) * SLOT_MULT;
 }
 
-static double time2pixels(u64 time)
+static double time2pixels(u64 __time)
 {
 	double X;
 
-	X = 1.0 * svg_page_width * (time - first_time) / (last_time - first_time);
+	X = 1.0 * svg_page_width * (__time - first_time) / (last_time - first_time);
 	return X;
 }
 
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
index 15ccfba..7821d0e 100644
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
@@ -1161,6 +1162,13 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 
 		section_name = elf_sec__name(&shdr, secstrs);
 
+		/* On ARM, symbols for thumb functions have 1 added to
+		 * the symbol address as a flag - remove it */
+		if ((ehdr.e_machine == EM_ARM) &&
+		    (map->type == MAP__FUNCTION) &&
+		    (sym.st_value & 1))
+			--sym.st_value;
+
 		if (self->kernel != DSO_TYPE_USER || kmodule) {
 			char dso_name[PATH_MAX];
 
@@ -1208,8 +1216,8 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
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

--2oS5YaxWCcQjTEyO--
