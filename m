Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab1ANIG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 03:06:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757357Ab1ANIG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 03:06:27 -0500
Date: Fri, 14 Jan 2011 03:03:09 -0500
From: Rik van Riel <riel@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, dshaks@redhat.com
Subject: [RFC -v5 PATCH 1/4] kvm: keep track of which task is running a KVM
 vcpu
Message-ID: <20110114030309.3d158404@annuminas.surriel.com>
In-Reply-To: <20110114030209.53765a0a@annuminas.surriel.com>
References: <20110114030209.53765a0a@annuminas.surriel.com>
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
index a055742..9d56ed5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -81,6 +81,7 @@ struct kvm_vcpu {
 #endif
 	int vcpu_id;
 	struct mutex mutex;
+	struct pid *pid;
 	int   cpu;
 	atomic_t guest_mode;
 	struct kvm_run *run;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5225052..65e997a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -185,6 +185,7 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	vcpu->cpu = -1;
 	vcpu->kvm = kvm;
 	vcpu->vcpu_id = id;
+	vcpu->pid = 0;
 	init_waitqueue_head(&vcpu->wq);
 
 	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
@@ -208,6 +209,8 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_init);
 
 void kvm_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
+	if (vcpu->pid)
+		put_pid(vcpu->pid);
 	kvm_arch_vcpu_uninit(vcpu);
 	free_page((unsigned long)vcpu->run);
 }
@@ -1456,6 +1459,12 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		r = -EINVAL;
 		if (arg)
 			goto out;
+		if (unlikely(vcpu->pid != current->pids[PIDTYPE_PID].pid)) {
+			/* The thread running this VCPU changed. */
+			struct pid *oldpid = vcpu->pid;
+			vcpu->pid = get_task_pid(current, PIDTYPE_PID);
+			put_pid(oldpid);
+		}
 		r = kvm_arch_vcpu_ioctl_run(vcpu, vcpu->run);
 		break;
 	case KVM_GET_REGS: {

