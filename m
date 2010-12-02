Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061Ab0LBTps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 14:45:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758041Ab0LBTpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 14:45:45 -0500
Date: Thu, 2 Dec 2010 14:43:24 -0500
From: Rik van Riel <riel@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: [RFC PATCH 1/3] kvm: keep track of which task is running a KVM vcpu
Message-ID: <20101202144324.4a79263b@annuminas.surriel.com>
In-Reply-To: <20101202144129.4357fe00@annuminas.surriel.com>
References: <20101202144129.4357fe00@annuminas.surriel.com>
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

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5fbdb55..cb73a73 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -79,6 +79,7 @@ struct kvm_vcpu {
 #endif
 	int vcpu_id;
 	struct mutex mutex;
+	struct task_struct *task;
 	int   cpu;
 	struct kvm_run *run;
 	unsigned long requests;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 050577a..2bffa47 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -741,6 +741,7 @@ void vcpu_load(struct kvm_vcpu *vcpu)
 	int cpu;
 
 	mutex_lock(&vcpu->mutex);
+	vcpu->task = current;
 	cpu = get_cpu();
 	preempt_notifier_register(&vcpu->preempt_notifier);
 	kvm_arch_vcpu_load(vcpu, cpu);
@@ -749,6 +750,7 @@ void vcpu_load(struct kvm_vcpu *vcpu)
 
 void vcpu_put(struct kvm_vcpu *vcpu)
 {
+	vcpu->task = NULL;
 	preempt_disable();
 	kvm_arch_vcpu_put(vcpu);
 	preempt_notifier_unregister(&vcpu->preempt_notifier);



-- 
All rights reversed.
