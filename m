Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab0GJJmN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 05:42:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60245 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab0GJJmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 05:42:11 -0400
Message-ID: <4C383F74.4040606@cn.fujitsu.com>
Date: Sat, 10 Jul 2010 17:37:56 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH] KVM: PIT: stop vpit before irq_routing freed
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix:
general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
......
Call Trace:
 [<ffffffffa0159bd1>] ? kvm_set_irq+0xdd/0x24b [kvm]
 [<ffffffff8106ea8b>] ? trace_hardirqs_off_caller+0x1f/0x10e
 [<ffffffff813ad17f>] ? sub_preempt_count+0xe/0xb6
 [<ffffffff8106d273>] ? put_lock_stats+0xe/0x27
 [<ffffffff8106e94b>] ? lock_release_holdtime+0x104/0x109
 [<ffffffff813ad214>] ? sub_preempt_count+0xa3/0xb6
 [<ffffffffa017cdae>] pit_do_work+0x69/0xc8 [kvm]
 [<ffffffff8105a441>] worker_thread+0x28e/0x3b0
 [<ffffffff8105a3e5>] ? worker_thread+0x232/0x3b0
 [<ffffffffa017cd45>] ? pit_do_work+0x0/0xc8 [kvm]
 [<ffffffff8105eafe>] ? autoremove_wake_function+0x0/0x39
 [<ffffffff8105a1b3>] ? worker_thread+0x0/0x3b0
 [<ffffffff8105e571>] kthread+0x7f/0x87
 [<ffffffff810039d4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81036370>] ? finish_task_switch+0x70/0xe4
 [<ffffffff813a9e89>] ? _raw_spin_unlock_irq+0x3b/0x58
 [<ffffffff813aa400>] ? restore_args+0x0/0x30
 [<ffffffff8105e4f2>] ? kthread+0x0/0x87
 [<ffffffff810039d0>] ? kernel_thread_helper+0x0/0x10
Code: 24 e8 26 00 00 45 31 ed 3b 98 28 01 00 00 73 39 89 db 48 8d 95 40 ff ff ff 48 8b 84 d8 30 01 00 00 bb 0c 00 00 00 48 85 c0 74
1e <48> 8b 08 48 8d 70 e0 48 89 d7 41 ff c5 48 83 c2 30 0f 18 09 48
RIP  [<ffffffffa0159c72>] kvm_set_irq+0x17e/0x24b [kvm]

This bug is triggered when guest is shutdown, is because we freed
irq_routing before pit thread stopped

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/i8254.c |    3 +++
 arch/x86/kvm/x86.c   |    2 +-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 70db4d4..0fd6378 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -752,6 +752,9 @@ void kvm_free_pit(struct kvm *kvm)
 	struct hrtimer *timer;
 
 	if (kvm->arch.vpit) {
+		kvm_io_bus_unregister_dev(kvm, KVM_PIO_BUS, &kvm->arch.vpit->dev);
+		kvm_io_bus_unregister_dev(kvm, KVM_PIO_BUS,
+					      &kvm->arch.vpit->speaker_dev);
 		kvm_unregister_irq_mask_notifier(kvm, 0,
 					       &kvm->arch.vpit->mask_notifier);
 		kvm_unregister_irq_ack_notifier(kvm,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6ed3176..39a264e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5523,12 +5523,12 @@ static void kvm_free_vcpus(struct kvm *kvm)
 void kvm_arch_sync_events(struct kvm *kvm)
 {
 	kvm_free_all_assigned_devices(kvm);
+	kvm_free_pit(kvm);
 }
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
 	kvm_iommu_unmap_guest(kvm);
-	kvm_free_pit(kvm);
 	kfree(kvm->arch.vpic);
 	kfree(kvm->arch.vioapic);
 	kvm_free_vcpus(kvm);
-- 
1.6.1.2


