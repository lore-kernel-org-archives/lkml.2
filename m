Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab1LFRqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 12:46:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40775 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab1LFRqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 12:46:10 -0500
X-Authority-Analysis: v=2.0 cv=dOUkaZlb c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=Q4Yd4ZKXOnMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=Tsyu_oKutKAHPD9k1qYA:9 a=buC_g9bqSIVHg9QkTzgA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=BKvHwBWalnTClRh4ZHMA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111206174607.601438894@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 06 Dec 2011 12:45:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/2] tracing: Add irq, preempt-count and need resched info to default trace output
References: <20111206174537.048874021@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Add-irq-preempt-count-and-need-resched-info-.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

People keep asking how to get the preempt count, irq, and need resched info
and we keep telling them to enable the latency format. Some developers think
that traces without this info is completely useless, and for a lot of tasks
it is useless.

The first option was to enable the latency trace as the default format, but
the header for the latency format is pretty useless for most tracers and
it also does the timestamp in straight microseconds from the time the trace
started. This is sometimes more difficult to read as the default trace is
seconds from the start of boot up.

Latency format:

 # tracer: nop
 #
 # nop latency trace v1.1.5 on 3.2.0-rc1-test+
 # --------------------------------------------------------------------
 # latency: 0 us, #159771/64234230, CPU#1 | (M:preempt VP:0, KP:0, SP:0 HP:=
0 #P:4)
 #    -----------------
 #    | task: -0 (uid:0 nice:0 policy:0 rt_prio:0)
 #    -----------------
 #
 #                  _------=3D> CPU#
 #                 / _-----=3D> irqs-off
 #                | / _----=3D> need-resched
 #                || / _---=3D> hardirq/softirq
 #                ||| / _--=3D> preempt-depth
 #                |||| /     delay
 #  cmd     pid   ||||| time  |   caller
 #     \   /      |||||  \    |   /
 migratio-6       0...2 41778231us+: rcu_note_context_switch <-__schedule
 migratio-6       0...2 41778233us : trace_rcu_utilization <-rcu_note_conte=
xt_switch
 migratio-6       0...2 41778235us+: rcu_sched_qs <-rcu_note_context_switch
 migratio-6       0d..2 41778236us+: rcu_preempt_qs <-rcu_note_context_swit=
ch
 migratio-6       0...2 41778238us : trace_rcu_utilization <-rcu_note_conte=
xt_switch
 migratio-6       0...2 41778239us+: debug_lockdep_rcu_enabled <-__schedule

default format:

 # tracer: nop
 #
 #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
 #              | |       |          |         |
      migration/0-6     [000]    50.025810: rcu_note_context_switch <-__sch=
edule
      migration/0-6     [000]    50.025812: trace_rcu_utilization <-rcu_not=
e_context_switch
      migration/0-6     [000]    50.025813: rcu_sched_qs <-rcu_note_context=
_switch
      migration/0-6     [000]    50.025815: rcu_preempt_qs <-rcu_note_conte=
xt_switch
      migration/0-6     [000]    50.025817: trace_rcu_utilization <-rcu_not=
e_context_switch
      migration/0-6     [000]    50.025818: debug_lockdep_rcu_enabled <-__s=
chedule
      migration/0-6     [000]    50.025820: debug_lockdep_rcu_enabled <-__s=
chedule

The latency format header has latency information that is pretty meaningless
for most tracers. Although some of the header is useful, and we can add that
later to the default format as well.

What is really useful with the latency format is the irqs-off, need-resched
hard/softirq context and the preempt count.

This commit adds the option irq-info which is on by default that adds this
information:

 # tracer: nop
 #
 #                              _-----=3D> irqs-off
 #                             / _----=3D> need-resched
 #                            | / _---=3D> hardirq/softirq
 #                            || / _--=3D> preempt-depth
 #                            ||| /     delay
 #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
 #              | |       |   ||||       |         |
           <idle>-0     [000] d..2    49.309305: cpuidle_get_driver <-cpuid=
le_idle_call
           <idle>-0     [000] d..2    49.309307: mwait_idle <-cpu_idle
           <idle>-0     [000] d..2    49.309309: need_resched <-mwait_idle
           <idle>-0     [000] d..2    49.309310: test_ti_thread_flag <-need=
_resched
           <idle>-0     [000] d..2    49.309312: trace_power_start.constpro=
p.13 <-mwait_idle
           <idle>-0     [000] d..2    49.309313: trace_cpu_idle <-mwait_idle
           <idle>-0     [000] d..2    49.309315: need_resched <-mwait_idle

If a user wants the old format, they can disable the 'irq-info' option:

 # tracer: nop
 #
 #           TASK-PID   CPU#      TIMESTAMP  FUNCTION
 #              | |       |          |         |
           <idle>-0     [000]     49.309305: cpuidle_get_driver <-cpuidle_i=
dle_call
           <idle>-0     [000]     49.309307: mwait_idle <-cpu_idle
           <idle>-0     [000]     49.309309: need_resched <-mwait_idle
           <idle>-0     [000]     49.309310: test_ti_thread_flag <-need_res=
ched
           <idle>-0     [000]     49.309312: trace_power_start.constprop.13=
 <-mwait_idle
           <idle>-0     [000]     49.309313: trace_cpu_idle <-mwait_idle
           <idle>-0     [000]     49.309315: need_resched <-mwait_idle

Requested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c        |   24 ++++++++++++++++++++----
 kernel/trace/trace.h        |    1 +
 kernel/trace/trace_output.c |   16 ++++++++++++++--
 3 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9e158cc..fa5cee6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -338,7 +338,8 @@ static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
 /* trace_flags holds trace_options default values */
 unsigned long trace_flags =3D TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
 	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO | TRACE_ITER_SLEEP_TIME |
-	TRACE_ITER_GRAPH_TIME | TRACE_ITER_RECORD_CMD | TRACE_ITER_OVERWRITE;
+	TRACE_ITER_GRAPH_TIME | TRACE_ITER_RECORD_CMD | TRACE_ITER_OVERWRITE |
+	TRACE_ITER_IRQ_INFO;
=20
 static int trace_stop_count;
 static DEFINE_RAW_SPINLOCK(tracing_start_lock);
@@ -426,6 +427,7 @@ static const char *trace_options[] =3D {
 	"record-cmd",
 	"overwrite",
 	"disable_on_free",
+	"irq-info",
 	NULL
 };
=20
@@ -1857,10 +1859,20 @@ static void print_lat_help_header(struct seq_file *=
m)
=20
 static void print_func_help_header(struct seq_file *m)
 {
-	seq_puts(m, "#           TASK-PID    CPU#    TIMESTAMP  FUNCTION\n");
+	seq_puts(m, "#           TASK-PID   CPU#      TIMESTAMP  FUNCTION\n");
 	seq_puts(m, "#              | |       |          |         |\n");
 }
=20
+static void print_func_help_header_irq(struct seq_file *m)
+{
+	seq_puts(m, "#                              _-----=3D> irqs-off\n");
+	seq_puts(m, "#                             / _----=3D> need-resched\n");
+	seq_puts(m, "#                            | / _---=3D> hardirq/softirq\n"=
);
+	seq_puts(m, "#                            || / _--=3D> preempt-depth\n");
+	seq_puts(m, "#                            ||| /     delay\n");
+	seq_puts(m, "#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION\n");
+	seq_puts(m, "#              | |       |   ||||       |         |\n");
+}
=20
 void
 print_trace_header(struct seq_file *m, struct trace_iterator *iter)
@@ -2170,8 +2182,12 @@ void trace_default_header(struct seq_file *m)
 		if (!(trace_flags & TRACE_ITER_VERBOSE))
 			print_lat_help_header(m);
 	} else {
-		if (!(trace_flags & TRACE_ITER_VERBOSE))
-			print_func_help_header(m);
+		if (!(trace_flags & TRACE_ITER_VERBOSE)) {
+			if (trace_flags & TRACE_ITER_IRQ_INFO)
+				print_func_help_header_irq(m);
+			else
+				print_func_help_header(m);
+		}
 	}
 }
=20
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f8ec229..2c26574 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -655,6 +655,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_RECORD_CMD		=3D 0x100000,
 	TRACE_ITER_OVERWRITE		=3D 0x200000,
 	TRACE_ITER_STOP_ON_FREE		=3D 0x400000,
+	TRACE_ITER_IRQ_INFO		=3D 0x800000,
 };
=20
 /*
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 5199930..0d6ff355 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -627,11 +627,23 @@ int trace_print_context(struct trace_iterator *iter)
 	unsigned long usec_rem =3D do_div(t, USEC_PER_SEC);
 	unsigned long secs =3D (unsigned long)t;
 	char comm[TASK_COMM_LEN];
+	int ret;
=20
 	trace_find_cmdline(entry->pid, comm);
=20
-	return trace_seq_printf(s, "%16s-%-5d [%03d] %5lu.%06lu: ",
-				comm, entry->pid, iter->cpu, secs, usec_rem);
+	ret =3D trace_seq_printf(s, "%16s-%-5d [%03d] ",
+			       comm, entry->pid, iter->cpu);
+	if (!ret)
+		return 0;
+
+	if (trace_flags & TRACE_ITER_IRQ_INFO) {
+		ret =3D trace_print_lat_fmt(s, entry);
+		if (!ret)
+			return 0;
+	}
+
+	return trace_seq_printf(s, " %5lu.%06lu: ",
+				secs, usec_rem);
 }
=20
 int trace_print_lat_context(struct trace_iterator *iter)
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO3lTfAAoJEIy3vGnGbaoA2aQQALww7LyzlL6qAINaG/+zJoe4
frXsHXV4EFflWsjNPpW0mZhTyomXsKm3TFToM55z2Dup/6cjtkVasesYyd6BKJJB
5pJNf5WJUPwyQiDt1VLWRmvCG/UQLQmJUXSeIMLsPAEz62yF+c9Cpg76CaipfmWm
D99EXJNjVfpKbo6MUCTc4shX5OmZR8sYLUBj9+5dpAL9BiDL+wmA0XMxXfRIqyKl
rb/w9FDHg0/QdTEVxjZBhi0+EB3NoVN4VsQbI+U9LeW8vMgbdWv1cPJNtPfZU7+Q
SzyXNn50Y5P3iIb0Q9+IXBGbVA5moqA0F5PldlQpB/BRWF8Zhk2ejdYOaF1KG3AJ
bJTvmYq2fbLAcAGvqogmShV/6xZaOqTluC1ADzn0/+NW74216Ft4vMtlzEYEFcsV
FPUDjmd/ARht+i6pSzxrye8b4nIPLLgj4+/G4+QkkmEUH2FJAFdsQpsFH6Hhx8sF
hRXCxAqAxOwdzBw8tmTTxKOa9q2aAgOJqoKRYvPi8Q3n5UTpguT4hmJrPM6tTJbt
3VGa6o8UoNCDuG09oX5MsW4EAKavgfvr1TslLqWWAF5ENqgQuntPUNJx7NGTVxy8
XSYFG4Rd0yoxLRkIsCufAWgK1/9oXzU0bjUo0/2atJLCDNvuNBk6UXGgBa+ZOJ7z
QgCGytUJB2xoh+cEfH8E
=ogFV
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
