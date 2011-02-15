Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab1BOQ6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 11:58:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39261 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716Ab1BOQ6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 11:58:31 -0500
Date: Tue, 15 Feb 2011 17:58:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110215165803.GA3700@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Ari Kauppi (2):
      oprofile: Fix usage of CONFIG_HW_PERF_EVENTS for oprofile_perf_init and friends
      ARM: oprofile: Fix backtraces in timer mode

Arnaldo Carvalho de Melo (1):
      perf tools: Fix thread_map event synthesizing in top and record

Don Zickus (1):
      watchdog, nmi: Lower the severity of error messages

Peter Zijlstra (1):
      x86: Fix text_poke_smp_batch() deadlock


 arch/arm/oprofile/common.c    |   12 ++----------
 arch/x86/kernel/alternative.c |    2 +-
 include/linux/oprofile.h      |   13 +++++++++++--
 kernel/watchdog.c             |   10 ++++++++--
 tools/perf/builtin-record.c   |    4 ++--
 tools/perf/builtin-top.c      |    2 +-
 tools/perf/util/event.c       |   18 +++++++++++++-----
 tools/perf/util/event.h       |    6 ++++--
 8 files changed, 42 insertions(+), 25 deletions(-)

diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index 8aa9744..2b66391 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -10,8 +10,6 @@
  */
 
 #include <linux/cpumask.h>
-#include <linux/err.h>
-#include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
 #include <linux/oprofile.h>
@@ -46,6 +44,7 @@ char *op_name_from_perf_id(void)
 		return NULL;
 	}
 }
+#endif
 
 static int report_trace(struct stackframe *frame, void *d)
 {
@@ -111,6 +110,7 @@ static void arm_backtrace(struct pt_regs * const regs, unsigned int depth)
 
 int __init oprofile_arch_init(struct oprofile_operations *ops)
 {
+	/* provide backtrace support also in timer mode: */
 	ops->backtrace		= arm_backtrace;
 
 	return oprofile_perf_init(ops);
@@ -120,11 +120,3 @@ void __exit oprofile_arch_exit(void)
 {
 	oprofile_perf_exit();
 }
-#else
-int __init oprofile_arch_init(struct oprofile_operations *ops)
-{
-	pr_info("oprofile: hardware counters not available\n");
-	return -ENODEV;
-}
-void __exit oprofile_arch_exit(void) {}
-#endif /* CONFIG_HW_PERF_EVENTS */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 1236085..7038b95 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -671,7 +671,7 @@ void __kprobes text_poke_smp_batch(struct text_poke_param *params, int n)
 
 	atomic_set(&stop_machine_first, 1);
 	wrote_text = 0;
-	stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
+	__stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
 }
 
 #if defined(CONFIG_DYNAMIC_FTRACE) || defined(HAVE_JUMP_LABEL)
diff --git a/include/linux/oprofile.h b/include/linux/oprofile.h
index 32fb812..1ca6411 100644
--- a/include/linux/oprofile.h
+++ b/include/linux/oprofile.h
@@ -16,6 +16,8 @@
 #include <linux/types.h>
 #include <linux/spinlock.h>
 #include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/printk.h>
 #include <asm/atomic.h>
  
 /* Each escaped entry is prefixed by ESCAPE_CODE
@@ -186,10 +188,17 @@ int oprofile_add_data(struct op_entry *entry, unsigned long val);
 int oprofile_add_data64(struct op_entry *entry, u64 val);
 int oprofile_write_commit(struct op_entry *entry);
 
-#ifdef CONFIG_PERF_EVENTS
+#ifdef CONFIG_HW_PERF_EVENTS
 int __init oprofile_perf_init(struct oprofile_operations *ops);
 void oprofile_perf_exit(void);
 char *op_name_from_perf_id(void);
-#endif /* CONFIG_PERF_EVENTS */
+#else
+static inline int __init oprofile_perf_init(struct oprofile_operations *ops)
+{
+	pr_info("oprofile: hardware counters not available\n");
+	return -ENODEV;
+}
+static inline void oprofile_perf_exit(void) { }
+#endif /* CONFIG_HW_PERF_EVENTS */
 
 #endif /* OPROFILE_H */
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index f37f974..18bb157 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -363,8 +363,14 @@ static int watchdog_nmi_enable(int cpu)
 		goto out_save;
 	}
 
-	printk(KERN_ERR "NMI watchdog disabled for cpu%i: unable to create perf event: %ld\n",
-	       cpu, PTR_ERR(event));
+
+	/* vary the KERN level based on the returned errno */
+	if (PTR_ERR(event) == -EOPNOTSUPP)
+		printk(KERN_INFO "NMI watchdog disabled (cpu%i): not supported (no LAPIC?)\n", cpu);
+	else if (PTR_ERR(event) == -ENOENT)
+		printk(KERN_WARNING "NMI watchdog disabled (cpu%i): hardware events not enabled\n", cpu);
+	else
+		printk(KERN_ERR "NMI watchdog disabled (cpu%i): unable to create perf event: %ld\n", cpu, PTR_ERR(event));
 	return PTR_ERR(event);
 
 	/* success path */
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index b2f729f..60cac6f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -759,8 +759,8 @@ static int __cmd_record(int argc, const char **argv)
 		perf_session__process_machines(session, event__synthesize_guest_os);
 
 	if (!system_wide)
-		event__synthesize_thread(target_tid, process_synthesized_event,
-					 session);
+		event__synthesize_thread_map(threads, process_synthesized_event,
+					     session);
 	else
 		event__synthesize_threads(process_synthesized_event, session);
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index b6998e0..5a29d9c 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1306,7 +1306,7 @@ static int __cmd_top(void)
 		return -ENOMEM;
 
 	if (target_tid != -1)
-		event__synthesize_thread(target_tid, event__process, session);
+		event__synthesize_thread_map(threads, event__process, session);
 	else
 		event__synthesize_threads(event__process, session);
 
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 1478ab4..50d0a93 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -263,11 +263,12 @@ static int __event__synthesize_thread(event_t *comm_event, event_t *mmap_event,
 					     process, session);
 }
 
-int event__synthesize_thread(pid_t pid, event__handler_t process,
-			     struct perf_session *session)
+int event__synthesize_thread_map(struct thread_map *threads,
+				 event__handler_t process,
+				 struct perf_session *session)
 {
 	event_t *comm_event, *mmap_event;
-	int err = -1;
+	int err = -1, thread;
 
 	comm_event = malloc(sizeof(comm_event->comm) + session->id_hdr_size);
 	if (comm_event == NULL)
@@ -277,8 +278,15 @@ int event__synthesize_thread(pid_t pid, event__handler_t process,
 	if (mmap_event == NULL)
 		goto out_free_comm;
 
-	err = __event__synthesize_thread(comm_event, mmap_event, pid,
-					 process, session);
+	err = 0;
+	for (thread = 0; thread < threads->nr; ++thread) {
+		if (__event__synthesize_thread(comm_event, mmap_event,
+					       threads->map[thread],
+					       process, session)) {
+			err = -1;
+			break;
+		}
+	}
 	free(mmap_event);
 out_free_comm:
 	free(comm_event);
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 2b7e919..cc7b52f 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -135,14 +135,16 @@ typedef union event_union {
 void event__print_totals(void);
 
 struct perf_session;
+struct thread_map;
 
 typedef int (*event__handler_synth_t)(event_t *event, 
 				      struct perf_session *session);
 typedef int (*event__handler_t)(event_t *event, struct sample_data *sample,
 				struct perf_session *session);
 
-int event__synthesize_thread(pid_t pid, event__handler_t process,
-			     struct perf_session *session);
+int event__synthesize_thread_map(struct thread_map *threads,
+				 event__handler_t process,
+				 struct perf_session *session);
 int event__synthesize_threads(event__handler_t process,
 			      struct perf_session *session);
 int event__synthesize_kernel_mmap(event__handler_t process,
