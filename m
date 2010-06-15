Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab0FOHeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 03:34:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237Ab0FOHen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 03:34:43 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: avi@redhat.com, mtosatti@redhat.com, glommer@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>
Subject: [PATCH 08/17] Add clock sync request to hardware enable
Date: Mon, 14 Jun 2010 21:34:10 -1000
Message-Id: <1276587259-32319-9-git-send-email-zamsden@redhat.com>
In-Reply-To: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there are active VCPUs which are marked as belonging to
a particular hardware CPU, request a clock sync for them when
enabling hardware; the TSC could be desynchronized on a newly
arriving CPU, and we need to recompute guests system time
relative to boot after a suspend event.

This covers both cases.

Note that it is acceptable to take the spinlock, as either
no other tasks will be running and no locks held (BSP after
resume), or other tasks will be guaranteed to drop the lock
relatively quickly (AP on CPU_STARTING).

Noting we now get clock synchronization requests for VCPUs
which are starting up (or restarting), it is tempting to
attempt to remove the arch/x86/kvm/x86.c CPU hot-notifiers
at this time, however it is not correct to do so; they are
required for systems with non-constant TSC as the frequency
may not be known immediately after the processor has started
until the cpufreq driver has had a chance to run and query
the chipset.

Updated: implement better locking semantics for hardware_enable

Removed the hack of dropping and retaking the lock by adding the
semantic that we always hold kvm_lock when hardware_enable is
called.  The one place that doesn't need to worry about it is
resume, as resuming a frozen CPU, the spinlock won't be taken.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c  |    8 ++++++++
 virt/kvm/kvm_main.c |    6 +++++-
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4b15d03..05c559d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5442,7 +5442,15 @@ int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)
 
 int kvm_arch_hardware_enable(void *garbage)
 {
+	struct kvm *kvm;
+	struct kvm_vcpu *vcpu;
+	int i;
+
 	kvm_shared_msr_cpu_online();
+	list_for_each_entry(kvm, &vm_list, vm_list)
+		kvm_for_each_vcpu(i, vcpu, kvm)
+			if (vcpu->cpu == smp_processor_id())
+				kvm_request_guest_time_update(vcpu);
 	return kvm_x86_ops->hardware_enable(garbage);
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 01a8876..e35419a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1960,7 +1960,9 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
 	case CPU_STARTING:
 		printk(KERN_INFO "kvm: enabling virtualization on CPU%d\n",
 		       cpu);
+		spin_lock(&kvm_lock);
 		hardware_enable(NULL);
+		spin_unlock(&kvm_lock);
 		break;
 	}
 	return NOTIFY_OK;
@@ -2165,8 +2167,10 @@ static int kvm_suspend(struct sys_device *dev, pm_message_t state)
 
 static int kvm_resume(struct sys_device *dev)
 {
-	if (kvm_usage_count)
+	if (kvm_usage_count) {
+		WARN_ON(spin_is_locked(&kvm_lock));
 		hardware_enable(NULL);
+	}
 	return 0;
 }
 
-- 
1.7.1

