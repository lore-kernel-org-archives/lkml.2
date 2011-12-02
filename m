Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab1LBG0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 01:26:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47406 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab1LBG0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 01:26:40 -0500
From: Liu Ping Fan <kernelfans@gmail.com>
To: avi@redhat.com, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, aliguori@us.ibm.com, gleb@redhat.com,
        jan.kiszka@web.de
Subject: [PATCH] kvm: make vcpu life cycle separated from kvm instance
Date: Fri,  2 Dec 2011 14:26:32 +0800
Message-Id: <1322807192-14147-1-git-send-email-kernelfans@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <4ED212A1.3060300@redhat.com>
References: <4ED212A1.3060300@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>

Currently, vcpu can be destructed only when kvm instance destroyed.
Change this to vcpu's destruction taken when its refcnt is zero,
and then vcpu MUST and CAN be destroyed before kvm's destroy.

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
---
 arch/x86/kvm/i8254.c     |   14 +++++-
 arch/x86/kvm/i8259.c     |   14 +++++-
 arch/x86/kvm/mmu.c       |   12 ++++-
 arch/x86/kvm/x86.c       |   66 +++++++++++++++++++------------
 include/linux/kvm_host.h |   24 +++++++++--
 virt/kvm/irq_comm.c      |   16 ++++++--
 virt/kvm/kvm_main.c      |   98 ++++++++++++++++++++++++++++++++++++++++------
 7 files changed, 188 insertions(+), 56 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 76e3f1c..36e9943 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -289,7 +289,7 @@ static void pit_do_work(struct work_struct *work)
 	struct kvm_pit *pit = container_of(work, struct kvm_pit, expired);
 	struct kvm *kvm = pit->kvm;
 	struct kvm_vcpu *vcpu;
-	int i;
+	int i, cnt;
 	struct kvm_kpit_state *ps = &pit->pit_state;
 	int inject = 0;
 
@@ -315,9 +315,17 @@ static void pit_do_work(struct work_struct *work)
 		 * LVT0 to NMI delivery. Other PIC interrupts are just sent to
 		 * VCPU0, and only if its LVT0 is in EXTINT mode.
 		 */
-		if (kvm->arch.vapics_in_nmi_mode > 0)
-			kvm_for_each_vcpu(i, vcpu, kvm)
+		if (kvm->arch.vapics_in_nmi_mode > 0) {
+			rcu_read_lock();
+			kvm_for_each_vcpu(i, cnt, vcpu, kvm) {
+				vcpu = kvm_get_vcpu(kvm, i);
+				if (vcpu == NULL)
+					continue;
+				cnt++;
 				kvm_apic_nmi_wd_deliver(vcpu);
+			}
+			rcu_read_unlock();
+		}
 	}
 }
 
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index cac4746..529057c 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -50,25 +50,33 @@ static void pic_unlock(struct kvm_pic *s)
 {
 	bool wakeup = s->wakeup_needed;
 	struct kvm_vcpu *vcpu, *found = NULL;
-	int i;
+	struct kvm *kvm = s->kvm;
+	int i, cnt;
 
 	s->wakeup_needed = false;
 
 	spin_unlock(&s->lock);
 
 	if (wakeup) {
-		kvm_for_each_vcpu(i, vcpu, s->kvm) {
+		rcu_read_lock();
+		kvm_for_each_vcpu(i, cnt, vcpu, kvm) {
+			vcpu = kvm_get_vcpu(kvm, i);
+			if (vcpu == NULL)
+				continue;
+			cnt++;
 			if (kvm_apic_accept_pic_intr(vcpu)) {
 				found = vcpu;
 				break;
 			}
 		}
-
+		found = kvm_vcpu_get(found);
+		rcu_read_unlock();
 		if (!found)
 			return;
 
 		kvm_make_request(KVM_REQ_EVENT, found);
 		kvm_vcpu_kick(found);
+		kvm_vcpu_put(found);
 	}
 }
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index f1b36cf..b9c3a01 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1833,11 +1833,17 @@ static void kvm_mmu_put_page(struct kvm_mmu_page *sp, u64 *parent_pte)
 
 static void kvm_mmu_reset_last_pte_updated(struct kvm *kvm)
 {
-	int i;
+	int i, cnt;
 	struct kvm_vcpu *vcpu;
-
-	kvm_for_each_vcpu(i, vcpu, kvm)
+	rcu_read_lock();
+	kvm_for_each_vcpu(i, cnt, vcpu, kvm) {
+		vcpu = kvm_get_vcpu(kvm, i);
+		if (vcpu == NULL)
+			continue;
+		cnt++;
 		vcpu->arch.last_pte_updated = NULL;
+	}
+	rcu_read_unlock();
 }
 
 static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c38efd7..5bd8b95 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1830,11 +1830,19 @@ static int get_msr_hyperv(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 
 	switch (msr) {
 	case HV_X64_MSR_VP_INDEX: {
-		int r;
+		int r, cnt;
 		struct kvm_vcpu *v;
-		kvm_for_each_vcpu(r, v, vcpu->kvm)
+		struct kvm *kvm =  vcpu->kvm;
+		rcu_read_lock();
+		kvm_for_each_vcpu(r, cnt, v, kvm) {
+			v = kvm_get_vcpu(kvm, r);
+			if (v == NULL)
+				continue;
+			cnt++;
 			if (v == vcpu)
 				data = r;
+		}
+		rcu_read_unlock();
 		break;
 	}
 	case HV_X64_MSR_EOI:
@@ -4966,7 +4974,7 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
 	struct cpufreq_freqs *freq = data;
 	struct kvm *kvm;
 	struct kvm_vcpu *vcpu;
-	int i, send_ipi = 0;
+	int i, cnt, send_ipi = 0;
 
 	/*
 	 * We allow guests to temporarily run on slowing clocks,
@@ -5016,13 +5024,20 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
 
 	raw_spin_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list) {
-		kvm_for_each_vcpu(i, vcpu, kvm) {
+
+		rcu_read_lock();
+		kvm_for_each_vcpu(i, cnt, vcpu, kvm) {
+			vcpu = kvm_get_vcpu(kvm, i);
+			if (vcpu == NULL)
+				continue;
+			cnt++;
 			if (vcpu->cpu != freq->cpu)
 				continue;
 			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 			if (vcpu->cpu != smp_processor_id())
 				send_ipi = 1;
 		}
+		rcu_read_unlock();
 	}
 	raw_spin_unlock(&kvm_lock);
 
@@ -6433,13 +6448,21 @@ int kvm_arch_hardware_enable(void *garbage)
 {
 	struct kvm *kvm;
 	struct kvm_vcpu *vcpu;
-	int i;
+	int i, cnt;
 
 	kvm_shared_msr_cpu_online();
-	list_for_each_entry(kvm, &vm_list, vm_list)
-		kvm_for_each_vcpu(i, vcpu, kvm)
+	list_for_each_entry(kvm, &vm_list, vm_list) {
+		rcu_read_lock();
+		kvm_for_each_vcpu(i, cnt, vcpu, kvm) {
+			vcpu = kvm_get_vcpu(kvm, i);
+			if (vcpu == NULL)
+				continue;
+			cnt++;
 			if (vcpu->cpu == smp_processor_id())
 				kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
+		}
+		rcu_read_unlock();
+	}
 	return kvm_x86_ops->hardware_enable(garbage);
 }
 
@@ -6560,27 +6583,19 @@ static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
 	vcpu_put(vcpu);
 }
 
-static void kvm_free_vcpus(struct kvm *kvm)
-{
-	unsigned int i;
-	struct kvm_vcpu *vcpu;
 
-	/*
-	 * Unpin any mmu pages first.
-	 */
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		kvm_clear_async_pf_completion_queue(vcpu);
-		kvm_unload_vcpu_mmu(vcpu);
-	}
-	kvm_for_each_vcpu(i, vcpu, kvm)
-		kvm_arch_vcpu_free(vcpu);
 
-	mutex_lock(&kvm->lock);
-	for (i = 0; i < atomic_read(&kvm->online_vcpus); i++)
-		kvm->vcpus[i] = NULL;
+void kvm_arch_vcpu_zap(struct work_struct *work)
+{
+	struct kvm_vcpu *vcpu = container_of(work, struct kvm_vcpu,
+			zap_work);
+	struct kvm *kvm = vcpu->kvm;
 
-	atomic_set(&kvm->online_vcpus, 0);
-	mutex_unlock(&kvm->lock);
+	printk(KERN_INFO "%s, zap vcpu:0x%x\n", __func__, vcpu->vcpu_id);
+	kvm_clear_async_pf_completion_queue(vcpu);
+	kvm_unload_vcpu_mmu(vcpu);
+	kvm_arch_vcpu_free(vcpu);
+	kvm_put_kvm(kvm);
 }
 
 void kvm_arch_sync_events(struct kvm *kvm)
@@ -6594,7 +6609,6 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_iommu_unmap_guest(kvm);
 	kfree(kvm->arch.vpic);
 	kfree(kvm->arch.vioapic);
-	kvm_free_vcpus(kvm);
 	if (kvm->arch.apic_access_page)
 		put_page(kvm->arch.apic_access_page);
 	if (kvm->arch.ept_identity_pagetable)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d526231..4d70ff5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -19,6 +19,7 @@
 #include <linux/slab.h>
 #include <linux/rcupdate.h>
 #include <linux/ratelimit.h>
+#include <linux/atomic.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -113,6 +114,9 @@ enum {
 
 struct kvm_vcpu {
 	struct kvm *kvm;
+	atomic_t refcount;
+	struct rcu_head head;
+	struct work_struct zap_work;
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	struct preempt_notifier preempt_notifier;
 #endif
@@ -290,16 +294,26 @@ struct kvm {
 #define kvm_printf(kvm, fmt ...) printk(KERN_DEBUG fmt)
 #define vcpu_printf(vcpu, fmt...) kvm_printf(vcpu->kvm, fmt)
 
+struct kvm_vcpu *kvm_vcpu_get(struct kvm_vcpu *vcpu);
+void kvm_vcpu_put(struct kvm_vcpu *vcpu);
+void kvm_arch_vcpu_zap(struct work_struct *work);
+
+/*search vcpu, must be protected by rcu_read_lock*/
 static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
 {
+	struct kvm_vcpu *vcpu;
 	smp_rmb();
-	return kvm->vcpus[i];
+	vcpu = kvm->vcpus[i];
+	if (vcpu != NULL && atomic_read(&vcpu->refcount) != 0)
+		return vcpu;
+
+	return NULL;
 }
 
-#define kvm_for_each_vcpu(idx, vcpup, kvm) \
-	for (idx = 0; \
-	     idx < atomic_read(&kvm->online_vcpus) && \
-	     (vcpup = kvm_get_vcpu(kvm, idx)) != NULL; \
+#define kvm_for_each_vcpu(idx, cnt, vcpup, kvm) \
+	for (idx = 0, cnt = 0; \
+	     cnt < atomic_read(&kvm->online_vcpus) && \
+	     idx < KVM_MAX_VCPUS; \
 	     idx++)
 
 int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id);
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 9f614b4..3b805f3 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -81,14 +81,19 @@ inline static bool kvm_is_dm_lowest_prio(struct kvm_lapic_irq *irq)
 int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 		struct kvm_lapic_irq *irq)
 {
-	int i, r = -1;
+	int i, cnt, r = -1;
 	struct kvm_vcpu *vcpu, *lowest = NULL;
 
 	if (irq->dest_mode == 0 && irq->dest_id == 0xff &&
 			kvm_is_dm_lowest_prio(irq))
 		printk(KERN_INFO "kvm: apic: phys broadcast and lowest prio\n");
 
-	kvm_for_each_vcpu(i, vcpu, kvm) {
+	rcu_read_lock();
+	kvm_for_each_vcpu(i, cnt, vcpu, kvm) {
+		vcpu = kvm_get_vcpu(kvm, i);
+		if (vcpu == NULL)
+			continue;
+		cnt++;
 		if (!kvm_apic_present(vcpu))
 			continue;
 
@@ -107,10 +112,13 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 				lowest = vcpu;
 		}
 	}
+	lowest = kvm_vcpu_get(lowest);
+	rcu_read_unlock();
 
-	if (lowest)
+	if (lowest) {
 		r = kvm_apic_set_irq(lowest, irq);
-
+		kvm_vcpu_put(lowest);
+	}
 	return r;
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d9cfb78..87191bb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -171,7 +171,7 @@ static void ack_flush(void *_completed)
 
 static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
 {
-	int i, cpu, me;
+	int i, cnt, cpu, me;
 	cpumask_var_t cpus;
 	bool called = true;
 	struct kvm_vcpu *vcpu;
@@ -179,7 +179,13 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
 	zalloc_cpumask_var(&cpus, GFP_ATOMIC);
 
 	me = get_cpu();
-	kvm_for_each_vcpu(i, vcpu, kvm) {
+
+	rcu_read_lock();
+	kvm_for_each_vcpu(i, cnt, vcpu, kvm) {
+		vcpu = kvm_get_vcpu(kvm, i);
+		if (vcpu == NULL)
+			continue;
+		cnt++;
 		kvm_make_request(req, vcpu);
 		cpu = vcpu->cpu;
 
@@ -190,12 +196,15 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
 		      kvm_vcpu_exiting_guest_mode(vcpu) != OUTSIDE_GUEST_MODE)
 			cpumask_set_cpu(cpu, cpus);
 	}
+
 	if (unlikely(cpus == NULL))
 		smp_call_function_many(cpu_online_mask, ack_flush, NULL, 1);
 	else if (!cpumask_empty(cpus))
 		smp_call_function_many(cpus, ack_flush, NULL, 1);
 	else
 		called = false;
+	rcu_read_unlock();
+
 	put_cpu();
 	free_cpumask_var(cpus);
 	return called;
@@ -580,6 +589,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	kvm_arch_free_vm(kvm);
 	hardware_disable_all();
 	mmdrop(mm);
+	printk(KERN_INFO "%s finished\n", __func__);
 }
 
 void kvm_get_kvm(struct kvm *kvm)
@@ -1543,7 +1553,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 	int last_boosted_vcpu = me->kvm->last_boosted_vcpu;
 	int yielded = 0;
 	int pass;
-	int i;
+	int i, cnt;
 
 	/*
 	 * We boost the priority of a VCPU that is runnable but not
@@ -1553,9 +1563,14 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 	 * We approximate round-robin by starting at the last boosted VCPU.
 	 */
 	for (pass = 0; pass < 2 && !yielded; pass++) {
-		kvm_for_each_vcpu(i, vcpu, kvm) {
+		rcu_read_lock();
+		kvm_for_each_vcpu(i, cnt, vcpu, kvm) {
 			struct task_struct *task = NULL;
 			struct pid *pid;
+			vcpu = kvm_get_vcpu(kvm, i);
+			if (vcpu == NULL)
+				continue;
+			cnt++;
 			if (!pass && i < last_boosted_vcpu) {
 				i = last_boosted_vcpu;
 				continue;
@@ -1584,6 +1599,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 			}
 			put_task_struct(task);
 		}
+		rcu_read_unlock();
 	}
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_on_spin);
@@ -1623,8 +1639,8 @@ static int kvm_vcpu_mmap(struct file *file, struct vm_area_struct *vma)
 static int kvm_vcpu_release(struct inode *inode, struct file *filp)
 {
 	struct kvm_vcpu *vcpu = filp->private_data;
-
-	kvm_put_kvm(vcpu->kvm);
+	filp->private_data = NULL;
+	kvm_vcpu_put(vcpu);
 	return 0;
 }
 
@@ -1646,15 +1662,57 @@ static int create_vcpu_fd(struct kvm_vcpu *vcpu)
 	return anon_inode_getfd("kvm-vcpu", &kvm_vcpu_fops, vcpu, O_RDWR);
 }
 
+/*Can not block*/
+void kvm_vcpu_zap(struct rcu_head *rcu)
+{
+	struct kvm_vcpu *vcpu = container_of(rcu, struct kvm_vcpu, head);
+	schedule_work(&vcpu->zap_work);
+}
+
+/*increase refcnt*/
+struct kvm_vcpu *kvm_vcpu_get(struct kvm_vcpu *vcpu)
+{
+	if (vcpu == NULL)
+		return NULL;
+	if (atomic_add_unless(&vcpu->refcount, 1, 0))
+		return vcpu;
+	return NULL;
+}
+
+void kvm_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm;
+	if (atomic_dec_and_test(&vcpu->refcount)) {
+		kvm = vcpu->kvm;
+		mutex_lock(&kvm->lock);
+		kvm->vcpus[vcpu->vcpu_id] = NULL;
+		atomic_dec(&kvm->online_vcpus);
+		mutex_unlock(&kvm->lock);
+		call_rcu(&vcpu->head, kvm_vcpu_zap);
+	}
+}
+
+static struct kvm_vcpu *kvm_vcpu_create(struct kvm *kvm, u32 id)
+{
+	struct kvm_vcpu *vcpu;
+	vcpu = kvm_arch_vcpu_create(kvm, id);
+	if (IS_ERR(vcpu))
+		return vcpu;
+
+	atomic_set(&vcpu->refcount, 1);
+	INIT_WORK(&vcpu->zap_work, kvm_arch_vcpu_zap);
+	return vcpu;
+}
+
 /*
  * Creates some virtual cpus.  Good luck creating more than one.
  */
 static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 {
-	int r;
+	int r, cnt;
 	struct kvm_vcpu *vcpu, *v;
 
-	vcpu = kvm_arch_vcpu_create(kvm, id);
+	vcpu = kvm_vcpu_create(kvm, id);
 	if (IS_ERR(vcpu))
 		return PTR_ERR(vcpu);
 
@@ -1670,11 +1728,19 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 		goto unlock_vcpu_destroy;
 	}
 
-	kvm_for_each_vcpu(r, v, kvm)
+	rcu_read_lock();
+	kvm_for_each_vcpu(r, cnt, v, kvm) {
+		v = kvm_get_vcpu(kvm, r);
+		if (v == NULL)
+			continue;
+		cnt++;
 		if (v->vcpu_id == id) {
+			rcu_read_unlock();
 			r = -EEXIST;
 			goto unlock_vcpu_destroy;
 		}
+	}
+	rcu_read_unlock();
 
 	BUG_ON(kvm->vcpus[atomic_read(&kvm->online_vcpus)]);
 
@@ -2593,13 +2659,21 @@ static int vcpu_stat_get(void *_offset, u64 *val)
 	unsigned offset = (long)_offset;
 	struct kvm *kvm;
 	struct kvm_vcpu *vcpu;
-	int i;
+	int i, cnt;
 
 	*val = 0;
 	raw_spin_lock(&kvm_lock);
-	list_for_each_entry(kvm, &vm_list, vm_list)
-		kvm_for_each_vcpu(i, vcpu, kvm)
+	list_for_each_entry(kvm, &vm_list, vm_list) {
+		rcu_read_lock();
+		kvm_for_each_vcpu(i, cnt, vcpu, kvm) {
+			vcpu = kvm_get_vcpu(kvm, i);
+			if (vcpu == NULL)
+				continue;
+			cnt++;
 			*val += *(u32 *)((void *)vcpu + offset);
+		}
+		rcu_read_unlock();
+	}
 
 	raw_spin_unlock(&kvm_lock);
 	return 0;
-- 
1.7.4.4

