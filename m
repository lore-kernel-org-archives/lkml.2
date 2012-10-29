Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab2J2OLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 10:11:44 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:36483 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab2J2OLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 10:11:42 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>
Cc: Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Jiannan Ouyang <ouyang@cs.pitt.edu>, Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
Date: Mon, 29 Oct 2012 19:37:03 +0530
Message-Id: <20121029140702.15448.56932.sendpatchset@codeblue>
In-Reply-To: <20121029140621.15448.92083.sendpatchset@codeblue>
References: <20121029140621.15448.92083.sendpatchset@codeblue>
Subject: [PATCH V2 RFC 2/3] kvm: Handle yield_to failure return code for potential undercommit case
x-cbid: 12102914-5564-0000-0000-000005135878
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

Also we do not update last boosted vcpu in failure cases.

Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---

 virt/kvm/kvm_main.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index be70035..e376434 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1639,6 +1639,7 @@ bool kvm_vcpu_yield_to(struct kvm_vcpu *target)
 {
 	struct pid *pid;
 	struct task_struct *task = NULL;
+	bool ret = false;
 
 	rcu_read_lock();
 	pid = rcu_dereference(target->pid);
@@ -1646,17 +1647,15 @@ bool kvm_vcpu_yield_to(struct kvm_vcpu *target)
 		task = get_pid_task(target->pid, PIDTYPE_PID);
 	rcu_read_unlock();
 	if (!task)
-		return false;
+		return ret;
 	if (task->flags & PF_VCPU) {
 		put_task_struct(task);
-		return false;
-	}
-	if (yield_to(task, 1)) {
-		put_task_struct(task);
-		return true;
+		return ret;
 	}
+	ret = yield_to(task, 1);
 	put_task_struct(task);
-	return false;
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_yield_to);
 
@@ -1697,6 +1696,7 @@ bool kvm_vcpu_eligible_for_directed_yield(struct kvm_vcpu *vcpu)
 	return eligible;
 }
 #endif
+
 void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 {
 	struct kvm *kvm = me->kvm;
@@ -1727,11 +1727,12 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 				continue;
 			if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
 				continue;
-			if (kvm_vcpu_yield_to(vcpu)) {
+
+			yielded = kvm_vcpu_yield_to(vcpu);
+			if (yielded > 0)
 				kvm->last_boosted_vcpu = i;
-				yielded = 1;
+			if (yielded)
 				break;
-			}
 		}
 	}
 	kvm_vcpu_set_in_spin_loop(me, false);

