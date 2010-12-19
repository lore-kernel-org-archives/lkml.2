Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab0LSPek (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 10:34:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36295 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932147Ab0LSPej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 10:34:39 -0500
Date: Sun, 19 Dec 2010 16:34:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20101219153423.GA20874@elte.hu>
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
Dan Carpenter (1):
      perf: Fix off by one in perf_swevent_init()

John Reiser (1):
      ftrace: Have recordmcount honor endianness in fn_ELF_R_INFO

Peter Zijlstra (2):
      scripts/tags.sh: Add magic for trace-events
      perf: Fix duplicate events with multiple-pmu vs software events

Slava Pestov (1):
      tracing: Fix panic when lseek() called on "trace" opened for writing


 include/linux/perf_event.h |    1 +
 kernel/perf_event.c        |   37 ++++++++++++++++++++++++++++++-------
 kernel/trace/trace.c       |   10 +++++++++-
 scripts/recordmcount.h     |    2 +-
 scripts/tags.sh            |    4 +++-
 5 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index de2c417..4f1279e 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -887,6 +887,7 @@ struct perf_cpu_context {
 	int				exclusive;
 	struct list_head		rotation_list;
 	int				jiffies_interval;
+	struct pmu			*active_pmu;
 };
 
 struct perf_output_handle {
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index eac7e33..2870fee 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3824,6 +3824,8 @@ static void perf_event_task_event(struct perf_task_event *task_event)
 	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
+		if (cpuctx->active_pmu != pmu)
+			goto next;
 		perf_event_task_ctx(&cpuctx->ctx, task_event);
 
 		ctx = task_event->task_ctx;
@@ -3959,6 +3961,8 @@ static void perf_event_comm_event(struct perf_comm_event *comm_event)
 	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
+		if (cpuctx->active_pmu != pmu)
+			goto next;
 		perf_event_comm_ctx(&cpuctx->ctx, comm_event);
 
 		ctxn = pmu->task_ctx_nr;
@@ -4144,6 +4148,8 @@ got_name:
 	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
+		if (cpuctx->active_pmu != pmu)
+			goto next;
 		perf_event_mmap_ctx(&cpuctx->ctx, mmap_event,
 					vma->vm_flags & VM_EXEC);
 
@@ -4713,7 +4719,7 @@ static int perf_swevent_init(struct perf_event *event)
 		break;
 	}
 
-	if (event_id > PERF_COUNT_SW_MAX)
+	if (event_id >= PERF_COUNT_SW_MAX)
 		return -ENOENT;
 
 	if (!event->parent) {
@@ -5145,20 +5151,36 @@ static void *find_pmu_context(int ctxn)
 	return NULL;
 }
 
-static void free_pmu_context(void * __percpu cpu_context)
+static void update_pmu_context(struct pmu *pmu, struct pmu *old_pmu)
 {
-	struct pmu *pmu;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct perf_cpu_context *cpuctx;
+
+		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
+
+		if (cpuctx->active_pmu == old_pmu)
+			cpuctx->active_pmu = pmu;
+	}
+}
+
+static void free_pmu_context(struct pmu *pmu)
+{
+	struct pmu *i;
 
 	mutex_lock(&pmus_lock);
 	/*
 	 * Like a real lame refcount.
 	 */
-	list_for_each_entry(pmu, &pmus, entry) {
-		if (pmu->pmu_cpu_context == cpu_context)
+	list_for_each_entry(i, &pmus, entry) {
+		if (i->pmu_cpu_context == pmu->pmu_cpu_context) {
+			update_pmu_context(i, pmu);
 			goto out;
+		}
 	}
 
-	free_percpu(cpu_context);
+	free_percpu(pmu->pmu_cpu_context);
 out:
 	mutex_unlock(&pmus_lock);
 }
@@ -5190,6 +5212,7 @@ int perf_pmu_register(struct pmu *pmu)
 		cpuctx->ctx.pmu = pmu;
 		cpuctx->jiffies_interval = 1;
 		INIT_LIST_HEAD(&cpuctx->rotation_list);
+		cpuctx->active_pmu = pmu;
 	}
 
 got_cpu_context:
@@ -5241,7 +5264,7 @@ void perf_pmu_unregister(struct pmu *pmu)
 	synchronize_rcu();
 
 	free_percpu(pmu->pmu_disable_count);
-	free_pmu_context(pmu->pmu_cpu_context);
+	free_pmu_context(pmu);
 }
 
 struct pmu *perf_init_event(struct perf_event *event)
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c380612..f8cf959 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2338,11 +2338,19 @@ tracing_write_stub(struct file *filp, const char __user *ubuf,
 	return count;
 }
 
+static loff_t tracing_seek(struct file *file, loff_t offset, int origin)
+{
+	if (file->f_mode & FMODE_READ)
+		return seq_lseek(file, offset, origin);
+	else
+		return 0;
+}
+
 static const struct file_operations tracing_fops = {
 	.open		= tracing_open,
 	.read		= seq_read,
 	.write		= tracing_write_stub,
-	.llseek		= seq_lseek,
+	.llseek		= tracing_seek,
 	.release	= tracing_release,
 };
 
diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
index 58e933a..3966717 100644
--- a/scripts/recordmcount.h
+++ b/scripts/recordmcount.h
@@ -119,7 +119,7 @@ static uint_t (*Elf_r_sym)(Elf_Rel const *rp) = fn_ELF_R_SYM;
 
 static void fn_ELF_R_INFO(Elf_Rel *const rp, unsigned sym, unsigned type)
 {
-	rp->r_info = ELF_R_INFO(sym, type);
+	rp->r_info = _w(ELF_R_INFO(sym, type));
 }
 static void (*Elf_r_info)(Elf_Rel *const rp, unsigned sym, unsigned type) = fn_ELF_R_INFO;
 
diff --git a/scripts/tags.sh b/scripts/tags.sh
index 8509bb5..bbbe584 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -125,7 +125,9 @@ exuberant()
 	-I DEFINE_TRACE,EXPORT_TRACEPOINT_SYMBOL,EXPORT_TRACEPOINT_SYMBOL_GPL \
 	--extra=+f --c-kinds=-px                                \
 	--regex-asm='/^ENTRY\(([^)]*)\).*/\1/'                  \
-	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/'
+	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/' \
+	--regex-c++='/^TRACE_EVENT\(([^,)]*).*/trace_\1/'		\
+	--regex-c++='/^DEFINE_EVENT\(([^,)]*).*/trace_\1/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--langdef=kconfig --language-force=kconfig              \
