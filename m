Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab1AZWZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 17:25:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223Ab1AZWZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 17:25:41 -0500
Date: Wed, 26 Jan 2011 17:25:02 -0500
From: Rik van Riel <riel@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: [RFC -v7 PATCH 7/7] kvm: use yield_to instead of sleep in
 kvm_vcpu_on_spin
Message-ID: <20110126172502.63462b77@annuminas.surriel.com>
In-Reply-To: <20110126165657.2ddd2ac9@annuminas.surriel.com>
References: <20110126165657.2ddd2ac9@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of sleeping in kvm_vcpu_on_spin, which can cause gigantic
slowdowns of certain workloads, we instead use yield_to to get
another VCPU in the same KVM guest to run sooner.

This seems to give a 10-15% speedup in certain workloads.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9d56ed5..fab2250 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -187,6 +187,7 @@ struct kvm {
 #endif
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 	atomic_t online_vcpus;
+	int last_boosted_vcpu;
 	struct list_head vm_list;
 	struct mutex lock;
 	struct kvm_io_bus *buses[KVM_NR_BUSES];
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 86c4905..8b761ba 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1292,18 +1292,55 @@ void kvm_resched(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_resched);
 
-void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu)
+void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 {
-	ktime_t expires;
-	DEFINE_WAIT(wait);
-
-	prepare_to_wait(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
-
-	/* Sleep for 100 us, and hope lock-holder got scheduled */
-	expires = ktime_add_ns(ktime_get(), 100000UL);
-	schedule_hrtimeout(&expires, HRTIMER_MODE_ABS);
+	struct kvm *kvm = me->kvm;
+	struct kvm_vcpu *vcpu;
+	int last_boosted_vcpu = me->kvm->last_boosted_vcpu;
+	int yielded = 0;
+	int pass;
+	int i;
 
-	finish_wait(&vcpu->wq, &wait);
+	/*
+	 * We boost the priority of a VCPU that is runnable but not
+	 * currently running, because it got preempted by something
+	 * else and called schedule in __vcpu_run.  Hopefully that
+	 * VCPU is holding the lock that we need and will release it.
+	 * We approximate round-robin by starting at the last boosted VCPU.
+	 */
+	for (pass = 0; pass < 2 && !yielded; pass++) {
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			struct task_struct *task = NULL;
+			struct pid *pid;
+			if (!pass && i < last_boosted_vcpu) {
+				i = last_boosted_vcpu;
+				continue;
+			} else if (pass && i > last_boosted_vcpu)
+				break;
+			if (vcpu == me)
+				continue;
+			if (waitqueue_active(&vcpu->wq))
+				continue;
+			rcu_read_lock();
+			pid = rcu_dereference(vcpu->pid);
+			if (pid)
+				task = get_pid_task(vcpu->pid, PIDTYPE_PID);
+			rcu_read_unlock();
+			if (!task)
+				continue;
+			if (task->flags & PF_VCPU) {
+				put_task_struct(task);
+				continue;
+			}
+			if (yield_to(task, 1)) {
+				put_task_struct(task);
+				kvm->last_boosted_vcpu = i;
+				yielded = 1;
+				break;
+			}
+			put_task_struct(task);
+		}
+	}
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_on_spin);
 

