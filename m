Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab1ABLnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 06:43:19 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50000 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab1ABLnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 06:43:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=NB/EQvvU1RU4A7+VVydEIfyIl+r7PaCZLZrVWJ+8RhzvedFJj5lZqKtkXgXJbcWBqU
         Av+3MspPBJp/nPOCRgXtLsDh8Xl1NQly1oRLzDFh+0Wzna1INP3RKHcvyTBJKcxCiB4t
         muQ8DbmlXGpwV6aZBMCRPmLEbs8lloUGauR2c=
MIME-Version: 1.0
Date: Sun, 2 Jan 2011 19:43:16 +0800
Message-ID: <AANLkTikqDDq2GWYONu=JyGkrETMATx14LCFbm+e4PSSZ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] sched: add yield_to function
From: Hillf Danton <dhillf@gmail.com>
To: Rik van Riel <riel@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Dec 2010 14:44:23 -0500, Rik van Riel wrote:
> Add a yield_to function to the scheduler code, allowing us to
> give the remainder of our timeslice to another thread.
>
> We may want to use this to provide a sys_yield_to system call
> one day.
>
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

Hey all

The following work is based on what Rik posted, with a few changes.

[1] the added requeue_task() is replaced with resched_task().
[2] there is no longer change by slice_remain() in schedule class.
[3] the schedule_hrtimeout() in KVM still plays its role, and it looks
     nicer to move the searching of task out of kvm_vcpu_on_spin()
     to be a function.

The compensation of yielded nanoseconds is not considered
or corrected in this work for both lender and borrower, but it looks
not a vulnerability since the lock contention is detected by CPU,
as Rik mentioned, and since both lender and borrower are marked
with PF_VCPU.

What scheduler should consider further for the PF_VCPU?

Cheers
Hillf
---

--- a/include/linux/sched.h	2010-11-01 19:54:12.000000000 +0800
+++ b/include/linux/sched.h	2011-01-02 18:09:38.000000000 +0800
@@ -1945,6 +1945,7 @@ static inline int rt_mutex_getprio(struc
 extern void set_user_nice(struct task_struct *p, long nice);
 extern int task_prio(const struct task_struct *p);
 extern int task_nice(const struct task_struct *p);
+extern void yield_to(struct task_struct *, u64 *);
 extern int can_nice(const struct task_struct *p, const int nice);
 extern int task_curr(const struct task_struct *p);
 extern int idle_cpu(int cpu);
--- a/kernel/sched.c	2010-11-01 19:54:12.000000000 +0800
+++ b/kernel/sched.c	2011-01-02 18:14:20.000000000 +0800
@@ -5151,6 +5151,42 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t
 	return ret;
 }

+/*
+ * Yield the CPU, giving the remainder of our time slice to task p.
+ * Typically used to hand CPU time to another thread inside the same
+ * process, eg. when p holds a resource other threads are waiting for.
+ * Giving priority to p may help get that resource released sooner.
+ *
+ * @nsecs: feedback to caller the nanoseconds yielded
+ */
+void yield_to(struct task_struct *p, u64 *nsecs)
+{
+	unsigned long flags;
+	struct sched_entity *se = &p->se;
+	struct rq *rq;
+	struct cfs_rq *cfs_rq;
+	u64 vruntime;
+
+	rq = task_rq_lock(p, &flags);
+	if (task_running(rq, p) || task_has_rt_policy(p))
+		goto out;
+	cfs_rq = cfs_rq_of(se);
+	vruntime = se->vruntime;
+	se->vruntime = cfs_rq->min_vruntime;
+	if (nsecs) {
+		if (vruntime > se->vruntime)
+			vruntime -= se->vruntime;
+		else
+			vruntime = 0;
+		*nsecs = vruntime;
+	}
+	/* kick p onto its CPU */
+	resched_task(rq->curr);
+ out:
+	task_rq_unlock(rq, &flags);
+}
+EXPORT_SYMBOL_GPL(yield_to);
+
 /**
  * sys_sched_yield - yield the current processor to other threads.
  *
--- a/include/linux/kvm_host.h	2010-11-01 19:54:12.000000000 +0800
+++ b/include/linux/kvm_host.h	2011-01-02 17:43:26.000000000 +0800
@@ -91,6 +91,7 @@ struct kvm_vcpu {
 	int fpu_active;
 	int guest_fpu_loaded, guest_xcr0_loaded;
 	wait_queue_head_t wq;
+	int spinning;
 	int sigset_active;
 	sigset_t sigset;
 	struct kvm_vcpu_stat stat;
@@ -186,6 +187,7 @@ struct kvm {
 #endif
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 	atomic_t online_vcpus;
+	int last_boosted_vcpu;
 	struct list_head vm_list;
 	struct mutex lock;
 	struct kvm_io_bus *buses[KVM_NR_BUSES];
--- a/virt/kvm/kvm_main.c	2010-11-01 19:54:12.000000000 +0800
+++ b/virt/kvm/kvm_main.c	2011-01-02 18:03:42.000000000 +0800
@@ -1289,18 +1289,65 @@ void kvm_resched(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_resched);

-void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu)
+void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 {
 	ktime_t expires;
 	DEFINE_WAIT(wait);
+	u64 nsecs;
+	struct kvm *kvm = me->kvm;
+	struct kvm_vcpu *vcpu;
+	int last_boosted_vcpu = me->kvm->last_boosted_vcpu;
+	int first_round = 1;
+	int i;

-	prepare_to_wait(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
+	me->spinning = 1;

+	/*
+	 * We boost the priority of a VCPU that is runnable but not
+	 * currently running, because it got preempted by something
+	 * else and called schedule in __vcpu_run.  Hopefully that
+	 * VCPU is holding the lock that we need and will release it.
+	 * We approximate round-robin by starting at the last boosted VCPU.
+	 */
+ again:
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		struct task_struct *task = vcpu->task;
+		if (first_round && i < last_boosted_vcpu) {
+			i = last_boosted_vcpu;
+			continue;
+		} else if (!first_round && i > last_boosted_vcpu)
+			break;
+		if (vcpu == me)
+			continue;
+		if (vcpu->spinning)
+			continue;
+		if (!task)
+			continue;
+		if (waitqueue_active(&vcpu->wq))
+			continue;
+		if (task->flags & PF_VCPU)
+			continue;
+		kvm->last_boosted_vcpu = i;
+		goto yield;
+	}
+	if (first_round && last_boosted_vcpu == kvm->last_boosted_vcpu) {
+		/* We have not found anyone yet. */
+		first_round = 0;
+		goto again;
+	}
+	me->spinning = 0;
+	return;
+ yield:
+	yield_to(task, &(nsecs=0));
 	/* Sleep for 100 us, and hope lock-holder got scheduled */
-	expires = ktime_add_ns(ktime_get(), 100000UL);
+	if (nsecs < 100000)
+		nsecs = 100000;
+	prepare_to_wait(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
+	expires = ktime_add_ns(ktime_get(), nsecs);
 	schedule_hrtimeout(&expires, HRTIMER_MODE_ABS);
-
 	finish_wait(&vcpu->wq, &wait);
+
+	me->spinning = 0;
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_on_spin);
