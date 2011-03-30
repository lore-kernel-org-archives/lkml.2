Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab1C3NKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 09:10:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977Ab1C3NKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 09:10:34 -0400
Date: Wed, 30 Mar 2011 15:09:51 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx value
Message-ID: <20110330130951.GA2124@jolsa.brq.redhat.com>
References: <1301153868.2250.359.camel@laptop>
 <20110326161346.GA18272@redhat.com>
 <1301157483.2250.366.camel@laptop>
 <20110326170922.GA20329@redhat.com>
 <20110326173545.GA22919@redhat.com>
 <1301164168.2250.370.camel@laptop>
 <20110328133033.GA8254@redhat.com>
 <1301324275.4859.25.camel@twins>
 <1301327368.4859.28.camel@twins>
 <20110328165648.GA9304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110328165648.GA9304@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 06:56:48PM +0200, Oleg Nesterov wrote:
> On 03/28, Peter Zijlstra wrote:
> >
> > Another fun race, suppose we do properly remove task_ctx and is_active,
> > but then the task gets scheduled back in before free_event() gets around
> > to disabling the jump_label..
> 
> Yes, this too...
> 
> Well, ignoring the HAVE_JUMP_LABEL case... perhaps we can split
> perf_sched_events into 2 counters? I mean,
> 
> 	atomic_t perf_sched_events_in, perf_sched_events_out;
> 
> 	static inline void perf_event_task_sched_in(struct task_struct *task)
> 	{
> 		COND_STMT(&perf_sched_events_in, __perf_event_task_sched_in(task));
> 	}
> 
> 	static inline
> 	void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next)
> 	{
> 		perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
> 
> 		COND_STMT(&perf_sched_events_out, __perf_event_task_sched_out(task, next));
> 	}
> 
> 	void perf_sched_events_inc(void)
> 	{
> 		atomic_inc(&perf_sched_events_out);
> 		smp_mb__after_atomic_inc();
> 		atomic_inc(&perf_sched_events_in);
> 	}
> 
> 	void perf_sched_events_dec(void)
> 	{
> 		if (atomic_dec_and_test(&perf_sched_events_in))
> 			synchronize_sched();
> 		atomic_dec(&perf_sched_events_out);
> 	}
> 
> The last 2 helpers should be used instead of jump_label_inc/dec.

this approach seems to work, plz check attached patch

> 
> 
> 
> Or we can remove COND_STMT() from perf_event_task_sched_out(). Say,
> __perf_event_task_sched_in() can set PF_PERF_XXX or something, then
> perf_event_task_sched_out() can check this bit.
> 
> 
> As for HAVE_JUMP_LABEL, I still can't understand why this test-case
> triggers the problem. But jump_label_inc/dec logic looks obviously
> racy.

I think the reason is, that there are actually 2 places that
needs to be updated by jump label code
 - perf_event_task_sched_in
 - perf_event_task_sched_out

As for my image it first patches perf_event_task_sched_out and then
perf_event_task_sched_in

Now, when the code is updated, migration thread is scheduled several times
and perf schedule callbacks are called.

This seems to be happening in my setup:

perf release:
- jump_label_dec(perf_sched_events)
- migration thread is scheduled for disabling perf_event_task_sched_out
  jump label
- perf_event_task_sched_out/perf_event_task_sched_in is called
- task_ctx is NULL, since migration thread does not have any events
- perf_event_task_sched_out jump label got disabled
- release code is rescheduled -> now only perf_event_task_sched_in jump
  label is called
- task_ctx is set
- migration thread is scheduled for disabling perf_event_task_sched_in
  jump label
- perf_event_task_sched_in is called for migration thread,
  task_ctx stays, since migration thread does not have any events
- perf_event_task_sched_in jump label is disabled
- release code is scheduled -> no sched callback is called
- task_ctx stays != NULL

I'm almost 5% sure it could happen as I described ;)


Back to the patch below:

IIUIC that calling synchronize_sched in perf_sched_events_dec
ensures that final schedule back to the release code will not
call perf_event_task_sched_in, so task_ctx stays sane (NULL).


The cool think is, that it also fixies the original issue,
which was: wrong counters for perf builtin test #3..
which I started with from the very beggining :)

please let me know what you think, thanks
jirka

---
 include/linux/perf_event.h |   44 +++++++++++++++++++++++++++++++++++++++++---
 kernel/perf_event.c        |   11 ++++++-----
 2 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 311b4dc..4b4f114 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1074,11 +1074,12 @@ have_event:
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
@@ -1086,9 +1087,46 @@ void perf_event_task_sched_out(struct task_struct *task, struct task_struct *nex
 {
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, 1, NULL, 0);
 
-	COND_STMT(&perf_sched_events, __perf_event_task_sched_out(task, next));
+	COND_STMT(&perf_sched_events_out, __perf_event_task_sched_out(task, next));
 }
 
+#ifdef HAVE_JUMP_LABEL
+static inline
+void perf_sched_events_inc(void)
+{
+	jump_label_inc(&perf_sched_events_out);
+	smp_mb__after_atomic_inc();
+	jump_label_inc(&perf_sched_events_in);
+}
+
+static inline
+void perf_sched_events_dec(void)
+{
+	if (atomic_dec_and_test(&perf_sched_events_in)) {
+		jump_label_disable(&perf_sched_events_in);
+		synchronize_sched();
+	}
+
+	jump_label_dec(&perf_sched_events_out);
+}
+#else
+static inline
+void perf_sched_events_inc(void)
+{
+	atomic_inc(&perf_sched_events_out);
+	smp_mb__after_atomic_inc();
+	atomic_inc(&perf_sched_events_in);
+}
+
+static inline
+void perf_sched_events_dec(void)
+{
+	if (atomic_dec_and_test(&perf_sched_events_in))
+		synchronize_sched();
+	atomic_dec(&perf_sched_events_out);
+}
+#endif /* HAVE_JUMP_LABEL */
+
 extern void perf_event_mmap(struct vm_area_struct *vma);
 extern struct perf_guest_info_callbacks *perf_guest_cbs;
 extern int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index c75925c..db38d6e 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -125,7 +125,8 @@ enum event_type_t {
  * perf_sched_events : >0 events exist
  * perf_cgroup_events: >0 per-cpu cgroup events exist on this cpu
  */
-atomic_t perf_sched_events __read_mostly;
+atomic_t perf_sched_events_in __read_mostly;
+atomic_t perf_sched_events_out __read_mostly;
 static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
 
 static atomic_t nr_mmap_events __read_mostly;
@@ -2894,7 +2895,7 @@ static void free_event(struct perf_event *event)
 
 	if (!event->parent) {
 		if (event->attach_state & PERF_ATTACH_TASK)
-			jump_label_dec(&perf_sched_events);
+			perf_sched_events_dec();
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_dec(&nr_mmap_events);
 		if (event->attr.comm)
@@ -2905,7 +2906,7 @@ static void free_event(struct perf_event *event)
 			put_callchain_buffers();
 		if (is_cgroup_event(event)) {
 			atomic_dec(&per_cpu(perf_cgroup_events, event->cpu));
-			jump_label_dec(&perf_sched_events);
+			perf_sched_events_dec();
 		}
 	}
 
@@ -6248,7 +6249,7 @@ done:
 
 	if (!event->parent) {
 		if (event->attach_state & PERF_ATTACH_TASK)
-			jump_label_inc(&perf_sched_events);
+			perf_sched_events_inc();
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_inc(&nr_mmap_events);
 		if (event->attr.comm)
@@ -6490,7 +6491,7 @@ SYSCALL_DEFINE5(perf_event_open,
 		 * - that may need work on context switch
 		 */
 		atomic_inc(&per_cpu(perf_cgroup_events, event->cpu));
-		jump_label_inc(&perf_sched_events);
+		perf_sched_events_inc();
 	}
 
 	/*
-- 
1.7.1

