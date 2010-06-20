Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab0FTDP4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 23:15:56 -0400
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:43512 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755200Ab0FTDPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 23:15:54 -0400
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: linux-kernel@vger.kernel.org
Cc: Hagen Paul Pfeifer <hagen@jauu.net>
Subject: [PATCH] [RFC] kvm: time accelerator/decelerator for kvm guests
Date: Sun, 20 Jun 2010 05:09:30 +0200
Message-Id: <1277003370-6817-1-git-send-email-hagen@jauu.net>
X-Mailer: git-send-email 1.6.6.196.g1f735.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds functionality to accelerate/decelerate VM guests. The
patch provides a outline of the considered feature. Currently the
functionality is limited for the x86 architecture and kvm-clock sources.
No APIC/PIC/HPET support. Furthermore, the tunable variables are
compile time static and some sysfs accessors are still missing.

Anyway, the proposed mechanism provides functionality to accelerate VM
guests to e.g. analyze some network protocol behavior where the analysis
time to complete normally takes several hours (think about emulated
network environments, connected via virtual distributed environment and
some routing protocols). On the other hand the functionality can be
handy to decelerate some environments, your ideas here.

Signed-off-by: Hagen Paul Pfeifer <hagen@jauu.net>
---
 arch/x86/kvm/x86.c       |   17 ++++++++++++++++-
 include/linux/kvm_host.h |    3 +++
 2 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 05d571f..047b001 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -834,6 +834,7 @@ static void kvm_write_guest_time(struct kvm_vcpu *v)
 	struct kvm_vcpu_arch *vcpu = &v->arch;
 	void *shared_kaddr;
 	unsigned long this_tsc_khz;
+	u64 diff;
 
 	if ((!vcpu->time_page))
 		return;
@@ -852,9 +853,12 @@ static void kvm_write_guest_time(struct kvm_vcpu *v)
 	monotonic_to_bootbased(&ts);
 	local_irq_restore(flags);
 
+	diff =  ktime_us_delta(timespec_to_ktime(ts), timespec_to_ktime(v->kvm->ref_ts));
+	diff = ((diff * v->kvm->time_machine_num) / v->kvm->time_machine_den) * MSEC_PER_SEC;
+
 	/* With all the info we got, fill in the values */
 
-	vcpu->hv_clock.system_time = ts.tv_nsec +
+	vcpu->hv_clock.system_time = ts.tv_nsec + diff +
 				     (NSEC_PER_SEC * (u64)ts.tv_sec) + v->kvm->arch.kvmclock_offset;
 
 	vcpu->hv_clock.flags = 0;
@@ -5357,6 +5361,12 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 	free_page((unsigned long)vcpu->arch.pio_data);
 }
 
+static void kvm_take_ref_time(struct kvm *kvm)
+{
+	ktime_get_ts(&kvm->ref_ts);
+}
+
+
 struct  kvm *kvm_arch_create_vm(void)
 {
 	struct kvm *kvm = kzalloc(sizeof(struct kvm), GFP_KERNEL);
@@ -5378,6 +5388,11 @@ struct  kvm *kvm_arch_create_vm(void)
 
 	rdtscll(kvm->arch.vm_init_tsc);
 
+	kvm_take_ref_time(kvm);
+
+	kvm->time_machine_num = 0;
+	kvm->time_machine_den = 1;
+
 	return kvm;
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7cb116a..c94d405 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -213,6 +213,9 @@ struct kvm {
 	unsigned long mmu_notifier_seq;
 	long mmu_notifier_count;
 #endif
+	struct timespec ref_ts;
+	unsigned time_machine_num;
+	unsigned time_machine_den;
 };
 
 /* The guest did something we don't support. */
-- 
1.6.6.196.g1f735.dirty

