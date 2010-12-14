Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab0LNDsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 22:48:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab0LNDso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 22:48:44 -0500
Date: Mon, 13 Dec 2010 22:45:58 -0500
From: Rik van Riel <riel@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [RFC -v2 PATCH 1/3] kvm: keep track of which task is running a KVM
 vcpu
Message-ID: <20101213224558.1074e7fd@annuminas.surriel.com>
In-Reply-To: <20101213224434.7495edb2@annuminas.surriel.com>
References: <20101213224434.7495edb2@annuminas.surriel.com>
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
 
