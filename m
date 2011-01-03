Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab1ACVa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 16:30:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407Ab1ACVa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 16:30:26 -0500
Date: Mon, 3 Jan 2011 16:27:40 -0500
From: Rik van Riel <riel@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [RFC -v3 PATCH 1/3] kvm: keep track of which task is running a KVM
 vcpu
Message-ID: <20110103162740.0af52955@annuminas.surriel.com>
In-Reply-To: <20110103162637.29f23c40@annuminas.surriel.com>
References: <20110103162637.29f23c40@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep track of which task is running a KVM vcpu.  This helps us
figure out later what task to wake up if we want to boost a
vcpu that got preempted.

Unfortunately there are no guarantees that the same task
always keeps the same vcpu, so we can only track the task
across a single "run" of the vcpu.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
- move vcpu->task manipulation as suggested by Chris Wright

 include/linux/kvm_host.h |    1 +
 virt/kvm/kvm_main.c      |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a055742..180085b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -81,6 +81,7 @@ struct kvm_vcpu {
 #endif
 	int vcpu_id;
 	struct mutex mutex;
+	struct task_struct *task;
 	int   cpu;
 	atomic_t guest_mode;
 	struct kvm_run *run;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5225052..c95bad1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2248,6 +2248,7 @@ static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
 {
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
 
+	vcpu->task = NULL;
 	kvm_arch_vcpu_load(vcpu, cpu);
 }
 
@@ -2256,6 +2257,7 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 {
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
 
+	vcpu->task = current;
 	kvm_arch_vcpu_put(vcpu);
 }
 
