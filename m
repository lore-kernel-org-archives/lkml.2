Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab0LBTpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 14:45:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757877Ab0LBTpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 14:45:40 -0500
Date: Thu, 2 Dec 2010 14:45:16 -0500
From: Rik van Riel <riel@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: [RFC PATCH 3/3] kvm: use yield_to instead of sleep in
 kvm_vcpu_on_spin
Message-ID: <20101202144516.45a0385d@annuminas.surriel.com>
In-Reply-To: <20101202144129.4357fe00@annuminas.surriel.com>
References: <20101202144129.4357fe00@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of sleeping in kvm_vcpu_on_spin, which can cause gigantic
slowdowns of certain workloads, we instead use yield_to to hand
the rest of our timeslice to another vcpu in the same KVM guest.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c011ba3..7637dd3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -90,6 +90,7 @@ struct kvm_vcpu {
 	int fpu_active;
 	int guest_fpu_loaded;
 	wait_queue_head_t wq;
+	int spinning;
 	int sigset_active;
 	sigset_t sigset;
 	struct kvm_vcpu_stat stat;
@@ -185,6 +186,7 @@ struct kvm {
 #endif
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 	atomic_t online_vcpus;
+	int last_boosted_vcpu;
 	struct list_head vm_list;
 	struct mutex lock;
 	struct kvm_io_bus *buses[KVM_NR_BUSES];
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 80f17db..a6eeafc 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1880,18 +1880,53 @@ void kvm_resched(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_resched);
 
-void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu)
+void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 {
-	ktime_t expires;
-	DEFINE_WAIT(wait);
+	struct kvm *kvm = me->kvm;
+	struct kvm_vcpu *vcpu;
+	int last_boosted_vcpu = me->kvm->last_boosted_vcpu;
+	int first_round = 1;
+	int i;
 
-	prepare_to_wait(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
+	me->spinning = 1;
+
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
+		yield_to(task);
+		break;
+	}
 
-	/* Sleep for 100 us, and hope lock-holder got scheduled */
-	expires = ktime_add_ns(ktime_get(), 100000UL);
-	schedule_hrtimeout(&expires, HRTIMER_MODE_ABS);
+	if (first_round && last_boosted_vcpu == kvm->last_boosted_vcpu) {
+		/* We have not found anyone yet. */
+		first_round = 0;
+		goto again;
+	}
 
-	finish_wait(&vcpu->wq, &wait);
+	me->spinning = 0;
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_on_spin);
 


-- 
All rights reversed.
