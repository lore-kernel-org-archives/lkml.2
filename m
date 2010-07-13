Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab0GMC1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 22:27:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756722Ab0GMC0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 22:26:10 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: KVM <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Subject: [PATCH 12/18] Add clock sync request to hardware enable
Date: Mon, 12 Jul 2010 16:25:32 -1000
Message-Id: <1278987938-23873-13-git-send-email-zamsden@redhat.com>
In-Reply-To: <1278987938-23873-1-git-send-email-zamsden@redhat.com>
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com>
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
index a4d7cb9..08bd15b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5533,7 +5533,15 @@ int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)
 
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
index d4853a5..c0f4e70 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1961,7 +1961,9 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
 	case CPU_STARTING:
 		printk(KERN_INFO "kvm: enabling virtualization on CPU%d\n",
 		       cpu);
+		spin_lock(&kvm_lock);
 		hardware_enable(NULL);
+		spin_unlock(&kvm_lock);
 		break;
 	}
 	return NOTIFY_OK;
@@ -2166,8 +2168,10 @@ static int kvm_suspend(struct sys_device *dev, pm_message_t state)
 
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

