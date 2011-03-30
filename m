Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab1C3Ovy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 10:51:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:40059 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269Ab1C3Ovx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 10:51:53 -0400
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
 value
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20110330130951.GA2124@jolsa.brq.redhat.com>
References: <1301153868.2250.359.camel@laptop>
	 <20110326161346.GA18272@redhat.com> <1301157483.2250.366.camel@laptop>
	 <20110326170922.GA20329@redhat.com> <20110326173545.GA22919@redhat.com>
	 <1301164168.2250.370.camel@laptop> <20110328133033.GA8254@redhat.com>
	 <1301324275.4859.25.camel@twins> <1301327368.4859.28.camel@twins>
	 <20110328165648.GA9304@redhat.com>
	 <20110330130951.GA2124@jolsa.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 30 Mar 2011 16:51:24 +0200
Message-ID: <1301496684.4859.192.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-30 at 15:09 +0200, Jiri Olsa wrote:
> 
>  
> +#ifdef HAVE_JUMP_LABEL
> +static inline
> +void perf_sched_events_inc(void)
> +{
> +       jump_label_inc(&perf_sched_events_out);
> +       smp_mb__after_atomic_inc();
> +       jump_label_inc(&perf_sched_events_in);
> +}
> +
> +static inline
> +void perf_sched_events_dec(void)
> +{
> +       if (atomic_dec_and_test(&perf_sched_events_in)) {
> +               jump_label_disable(&perf_sched_events_in);
> +               synchronize_sched();
> +       }
> +
> +       jump_label_dec(&perf_sched_events_out);
> +}
> +#else
> +static inline
> +void perf_sched_events_inc(void)
> +{
> +       atomic_inc(&perf_sched_events_out);
> +       smp_mb__after_atomic_inc();
> +       atomic_inc(&perf_sched_events_in);
> +}
> +
> +static inline
> +void perf_sched_events_dec(void)
> +{
> +       if (atomic_dec_and_test(&perf_sched_events_in))
> +               synchronize_sched();
> +       atomic_dec(&perf_sched_events_out);
> +}
> +#endif /* HAVE_JUMP_LABEL */ 


I wrote a similar patch which is slightly smaller:

---
Subject: perf: Delay disabling the perf_event_task_sched_out() hook
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Mar 30 13:47:09 CEST 2011



Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_event.h |    7 ++++---
 kernel/perf_event.c        |   27 ++++++++++++++++++++++-----
 2 files changed, 26 insertions(+), 8 deletions(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -1074,11 +1074,12 @@ perf_sw_event(u32 event_id, u64 nr, int 
 	__perf_sw_event(event_id, nr, nmi, regs, addr);
 }
 
-extern atomic_t perf_sched_events;
+extern atomic_t perf_sched_events_in;
+extern atomic_t perf_sched_events_out;
 
 static inline void perf_event_task_sched_in(struct task_struct *task)
 {
-	COND_STMT(&perf_sched_events, __perf_event_task_sched_in(task));
+	COND_STMT(&perf_sched_events_in, __perf_event_task_sched_in(task));
 }
 
 static inline
@@ -1086,7 +1087,7 @@ void perf_event_task_sched_out(struct ta
 {
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
 
-	COND_STMT(&perf_sched_events, __perf_event_task_sched_out(task, next));
+	COND_STMT(&perf_sched_events_out, __perf_event_task_sched_out(task, next));
 }
 
 extern void perf_event_mmap(struct vm_area_struct *vma);
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -125,9 +125,25 @@ enum event_type_t {
  * perf_sched_events : >0 events exist
  * perf_cgroup_events: >0 per-cpu cgroup events exist on this cpu
  */
-atomic_t perf_sched_events __read_mostly;
+atomic_t perf_sched_events_in __read_mostly;
+atomic_t perf_sched_events_out __read_mostly;
 static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
 
+static void perf_sched_events_inc(void)
+{
+	jump_label_inc(&perf_sched_events_out);
+	jump_label_inc(&perf_sched_events_in);
+}
+
+static void perf_sched_events_dec(void)
+{
+	jump_label_dec(&perf_sched_events_in);
+	JUMP_LABEL(&perf_sched_events_in, no_sync);
+	synchronize_sched();
+no_sync:
+	jump_label_dec(&perf_sched_events_out);
+}
+
 static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
 static atomic_t nr_task_events __read_mostly;
@@ -2900,7 +2917,7 @@ static void free_event(struct perf_event
 
 	if (!event->parent) {
 		if (event->attach_state & PERF_ATTACH_TASK)
-			jump_label_dec(&perf_sched_events);
+			perf_sched_events_dec();
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_dec(&nr_mmap_events);
 		if (event->attr.comm)
@@ -2911,7 +2928,7 @@ static void free_event(struct perf_event
 			put_callchain_buffers();
 		if (is_cgroup_event(event)) {
 			atomic_dec(&per_cpu(perf_cgroup_events, event->cpu));
-			jump_label_dec(&perf_sched_events);
+			perf_sched_events_dec();
 		}
 	}
 
@@ -6256,7 +6273,7 @@ perf_event_alloc(struct perf_event_attr 
 
 	if (!event->parent) {
 		if (event->attach_state & PERF_ATTACH_TASK)
-			jump_label_inc(&perf_sched_events);
+			perf_sched_events_inc();
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_inc(&nr_mmap_events);
 		if (event->attr.comm)
@@ -6498,7 +6515,7 @@ SYSCALL_DEFINE5(perf_event_open,
 		 * - that may need work on context switch
 		 */
 		atomic_inc(&per_cpu(perf_cgroup_events, event->cpu));
-		jump_label_inc(&perf_sched_events);
+		perf_sched_events_inc();
 	}
 
 	/*

