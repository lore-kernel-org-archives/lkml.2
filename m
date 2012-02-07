Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab2BGCeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 21:34:25 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:36455 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755447Ab2BGCeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 21:34:23 -0500
From: Liu Ping Fan <kernelfans@gmail.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, aliguori@us.ibm.com,
        gleb@redhat.com, mtosatti@redhat.com, xiaoguangrong.eric@gmail.com,
        jan.kiszka@web.de, yoshikawa.takuya@oss.ntt.co.jp
Subject: [PATCH v8] kvm: make vcpu life cycle separated from kvm instance
Date: Tue,  7 Feb 2012 10:34:17 +0800
Message-Id: <1328582057-31549-1-git-send-email-kernelfans@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>

Currently, vcpu will be destructed only after kvm instance is
destroyed. This result to vcpu keep idle in kernel, but can not
be freed when it is unplugged in guest.

Change this to vcpu's destruction before kvm instance, so vcpu
CAN be destroyed before kvm instance. By this way, we can remove
vcpu when guest does not need it any longer.

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>

Changelog v7->v8
-Instead of using srcu linked list, resort to kvm->vcpus_array to store
 vcpu pointers. The vcpus_array is split into two areas, one for cur,
 the other for rcu updating.

TBD
-Choose better name for kvm_vcpu_destruct. Maybe we can rename
 kvm_arch_vcpu_destory() for the fail path in kvm_vm_ioctl_create_vcpu()
 to kvm_arch_vcpu_abort(). Any suggestion?
---
 arch/x86/kvm/i8254.c     |    4 +-
 arch/x86/kvm/i8259.c     |   14 ++++++----
 arch/x86/kvm/x86.c       |   39 ++++++++++--------------------
 include/linux/kvm_host.h |   15 +++++++----
 virt/kvm/irq_comm.c      |    4 +-
 virt/kvm/kvm_main.c      |   58 +++++++++++++++++++++++++++++++++++++--------
 6 files changed, 81 insertions(+), 53 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index d68f99d..b043bf7 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -288,7 +288,7 @@ static void pit_do_work(struct work_struct *work)
 {
 	struct kvm_pit *pit = container_of(work, struct kvm_pit, expired);
 	struct kvm *kvm = pit->kvm;
-	struct kvm_vcpu *vcpu;
+	struct kvm_vcpu *vcpu, *vcpus;
 	int i;
 	struct kvm_kpit_state *ps = &pit->pit_state;
 	int inject = 0;
@@ -316,7 +316,7 @@ static void pit_do_work(struct work_struct *work)
 		 * VCPU0, and only if its LVT0 is in EXTINT mode.
 		 */
 		if (kvm->arch.vapics_in_nmi_mode > 0)
-			kvm_for_each_vcpu(i, vcpu, kvm)
+			kvm_for_each_vcpu(i, vcpu, kvm, vcpus)
 				kvm_apic_nmi_wd_deliver(vcpu);
 	}
 }
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index b6a7353..3f67b59 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -49,7 +49,7 @@ static void pic_unlock(struct kvm_pic *s)
 	__releases(&s->lock)
 {
 	bool wakeup = s->wakeup_needed;
-	struct kvm_vcpu *vcpu, *found = NULL;
+	struct kvm_vcpu *vcpu, *vcpus, *found = NULL;
 	int i;
 
 	s->wakeup_needed = false;
@@ -57,13 +57,14 @@ static void pic_unlock(struct kvm_pic *s)
 	spin_unlock(&s->lock);
 
 	if (wakeup) {
-		kvm_for_each_vcpu(i, vcpu, s->kvm) {
+		rcu_read_lock();
+		kvm_for_each_vcpu(i, vcpu, s->kvm, vcpus) {
 			if (kvm_apic_accept_pic_intr(vcpu)) {
 				found = vcpu;
 				break;
 			}
 		}
-
+		rcu_read_unlock();
 		if (!found)
 			return;
 
@@ -263,7 +264,7 @@ int kvm_pic_read_irq(struct kvm *kvm)
 void kvm_pic_reset(struct kvm_kpic_state *s)
 {
 	int irq, i;
-	struct kvm_vcpu *vcpu;
+	struct kvm_vcpu *vcpu, *vcpus;
 	u8 irr = s->irr, isr = s->imr;
 	bool found = false;
 
@@ -282,12 +283,13 @@ void kvm_pic_reset(struct kvm_kpic_state *s)
 	s->special_fully_nested_mode = 0;
 	s->init4 = 0;
 
-	kvm_for_each_vcpu(i, vcpu, s->pics_state->kvm)
+	rcu_read_lock();
+	kvm_for_each_vcpu(i, vcpu, s->pics_state->kvm, vcpus)
 		if (kvm_apic_accept_pic_intr(vcpu)) {
 			found = true;
 			break;
 		}
-
+	rcu_read_unlock();
 
 	if (!found)
 		return;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2bd77a3..897fecc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1814,8 +1814,8 @@ static int get_msr_hyperv(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	switch (msr) {
 	case HV_X64_MSR_VP_INDEX: {
 		int r;
-		struct kvm_vcpu *v;
-		kvm_for_each_vcpu(r, v, vcpu->kvm)
+		struct kvm_vcpu *v, *vcpus;
+		kvm_for_each_vcpu(r, v, vcpu->kvm, vcpus)
 			if (v == vcpu)
 				data = r;
 		break;
@@ -4607,7 +4607,7 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
 {
 	struct cpufreq_freqs *freq = data;
 	struct kvm *kvm;
-	struct kvm_vcpu *vcpu;
+	struct kvm_vcpu *vcpu, *vcpus;
 	int i, send_ipi = 0;
 
 	/*
@@ -4658,7 +4658,7 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
 
 	raw_spin_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list) {
-		kvm_for_each_vcpu(i, vcpu, kvm) {
+		kvm_for_each_vcpu(i, vcpu, kvm, vcpus) {
 			if (vcpu->cpu != freq->cpu)
 				continue;
 			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
@@ -5950,12 +5950,12 @@ int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)
 int kvm_arch_hardware_enable(void *garbage)
 {
 	struct kvm *kvm;
-	struct kvm_vcpu *vcpu;
+	struct kvm_vcpu *vcpu, *vcpus;
 	int i;
 
 	kvm_shared_msr_cpu_online();
 	list_for_each_entry(kvm, &vm_list, vm_list)
-		kvm_for_each_vcpu(i, vcpu, kvm)
+		kvm_for_each_vcpu(i, vcpu, kvm, vcpus)
 			if (vcpu->cpu == smp_processor_id())
 				kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 	return kvm_x86_ops->hardware_enable(garbage);
@@ -6079,27 +6079,14 @@ static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
 	vcpu_put(vcpu);
 }
 
-static void kvm_free_vcpus(struct kvm *kvm)
+void kvm_arch_vcpu_destruct(struct kvm_vcpu *vcpu)
 {
-	unsigned int i;
-	struct kvm_vcpu *vcpu;
-
-	/*
-	 * Unpin any mmu pages first.
-	 */
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		kvm_clear_async_pf_completion_queue(vcpu);
-		kvm_unload_vcpu_mmu(vcpu);
-	}
-	kvm_for_each_vcpu(i, vcpu, kvm)
-		kvm_arch_vcpu_free(vcpu);
-
-	mutex_lock(&kvm->lock);
-	for (i = 0; i < atomic_read(&kvm->online_vcpus); i++)
-		kvm->vcpus[i] = NULL;
+	struct kvm *kvm = vcpu->kvm;
 
-	atomic_set(&kvm->online_vcpus, 0);
-	mutex_unlock(&kvm->lock);
+	kvm_clear_async_pf_completion_queue(vcpu);
+	kvm_unload_vcpu_mmu(vcpu);
+	kvm_arch_vcpu_free(vcpu);
+	kvm_put_kvm(kvm);
 }
 
 void kvm_arch_sync_events(struct kvm *kvm)
@@ -6113,7 +6100,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_iommu_unmap_guest(kvm);
 	kfree(kvm->arch.vpic);
 	kfree(kvm->arch.vioapic);
-	kvm_free_vcpus(kvm);
+	kfree(kvm->vcpus_array);
 	if (kvm->arch.apic_access_page)
 		put_page(kvm->arch.apic_access_page);
 	if (kvm->arch.ept_identity_pagetable)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index eada8e6..d3aa2a2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -254,7 +254,8 @@ struct kvm {
 #ifdef CONFIG_KVM_APIC_ARCHITECTURE
 	u32 bsp_vcpu_id;
 #endif
-	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
+	struct kvm_vcpu *vcpus;
+	struct kvm_vcpu *vcpus_array;
 	atomic_t online_vcpus;
 	int last_boosted_vcpu;
 	struct list_head vm_list;
@@ -303,16 +304,18 @@ struct kvm {
 #define kvm_printf(kvm, fmt ...) printk(KERN_DEBUG fmt)
 #define vcpu_printf(vcpu, fmt...) kvm_printf(vcpu->kvm, fmt)
 
-static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
+void kvm_arch_vcpu_destruct(struct kvm_vcpu *vcpu);
+
+static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm_vcpu *vcpus, int i)
 {
 	smp_rmb();
-	return kvm->vcpus[i];
+	return vcpus + i;
 }
 
-#define kvm_for_each_vcpu(idx, vcpup, kvm) \
-	for (idx = 0; \
+#define kvm_for_each_vcpu(idx, vcpup, kvm, vcpus) \
+	for (vcpus = rcu_dereference(kvm->vcpus), idx = 0; \
 	     idx < atomic_read(&kvm->online_vcpus) && \
-	     (vcpup = kvm_get_vcpu(kvm, idx)) != NULL; \
+	     (vcpup = kvm_get_vcpu(vcpus, idx)) != NULL; \
 	     idx++)
 
 #define kvm_for_each_memslot(memslot, slots)	\
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 9f614b4..010d317 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -82,13 +82,13 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 		struct kvm_lapic_irq *irq)
 {
 	int i, r = -1;
-	struct kvm_vcpu *vcpu, *lowest = NULL;
+	struct kvm_vcpu *vcpu, *vcpus, *lowest = NULL;
 
 	if (irq->dest_mode == 0 && irq->dest_id == 0xff &&
 			kvm_is_dm_lowest_prio(irq))
 		printk(KERN_INFO "kvm: apic: phys broadcast and lowest prio\n");
 
-	kvm_for_each_vcpu(i, vcpu, kvm) {
+	kvm_for_each_vcpu(i, vcpu, kvm, vcpus) {
 		if (!kvm_apic_present(vcpu))
 			continue;
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9f32bff..41a58ae 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -174,12 +174,12 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
 	int i, cpu, me;
 	cpumask_var_t cpus;
 	bool called = true;
-	struct kvm_vcpu *vcpu;
+	struct kvm_vcpu *vcpu, *vcpus;
 
 	zalloc_cpumask_var(&cpus, GFP_ATOMIC);
 
 	me = get_cpu();
-	kvm_for_each_vcpu(i, vcpu, kvm) {
+	kvm_for_each_vcpu(i, vcpu, kvm, vcpus) {
 		kvm_make_request(req, vcpu);
 		cpu = vcpu->cpu;
 
@@ -497,6 +497,9 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	if (r)
 		goto out_err;
 
+	kvm->vcpus_array = kzalloc(sizeof(struct kvm_vcpu *)*KVM_MAX_VCPUS*2,
+		GFP_KERNEL);
+	kvm->vcpus = kvm->vcpus_array;
 	raw_spin_lock(&kvm_lock);
 	list_add(&kvm->vm_list, &vm_list);
 	raw_spin_unlock(&kvm_lock);
@@ -1592,7 +1595,7 @@ EXPORT_SYMBOL_GPL(kvm_resched);
 void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 {
 	struct kvm *kvm = me->kvm;
-	struct kvm_vcpu *vcpu;
+	struct kvm_vcpu *vcpu, *vcpus;
 	int last_boosted_vcpu = me->kvm->last_boosted_vcpu;
 	int yielded = 0;
 	int pass;
@@ -1606,7 +1609,8 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 	 * We approximate round-robin by starting at the last boosted VCPU.
 	 */
 	for (pass = 0; pass < 2 && !yielded; pass++) {
-		kvm_for_each_vcpu(i, vcpu, kvm) {
+		rcu_read_lock();
+		kvm_for_each_vcpu(i, vcpu, kvm, vcpus) {
 			struct task_struct *task = NULL;
 			struct pid *pid;
 			if (!pass && i < last_boosted_vcpu) {
@@ -1629,6 +1633,8 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 				put_task_struct(task);
 				continue;
 			}
+
+			rcu_read_unlock();
 			if (yield_to(task, 1)) {
 				put_task_struct(task);
 				kvm->last_boosted_vcpu = i;
@@ -1636,6 +1642,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 				break;
 			}
 			put_task_struct(task);
+			rcu_read_lock();
 		}
 	}
 }
@@ -1673,11 +1680,40 @@ static int kvm_vcpu_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
+static void kvm_vcpu_destruct(struct kvm_vcpu *vcpu)
+{
+	kvm_arch_vcpu_destruct(vcpu);
+}
+
 static int kvm_vcpu_release(struct inode *inode, struct file *filp)
 {
+	int i;
 	struct kvm_vcpu *vcpu = filp->private_data;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_vcpu *vcpus_next;
+	filp->private_data = NULL;
+
+	for (i = 0; i < atomic_read(&kvm->online_vcpus); i++) {
+		if (vcpu == kvm->vcpus+i)
+			break;
+	}
+	mutex_lock(&kvm->lock);
+	vcpus_next =  kvm->vcpus_array +
+		((kvm->vcpus - kvm->vcpus_array) ? 0 : KVM_MAX_VCPUS);
+
+	memset(vcpus_next, 0, KVM_MAX_VCPUS*sizeof(struct kvm_vcpu *));
+	memcpy(vcpus_next, kvm->vcpus, i*sizeof(struct kvm_vcpu *));
+	memcpy(vcpus_next+i, kvm->vcpus+i+1,
+		(atomic_read(&kvm->online_vcpus)-i)*sizeof(struct kvm_vcpu *));
+	atomic_dec(&kvm->online_vcpus);
+	/* Removed vcpu can not be seen from vcpus[] */
+	rcu_assign_pointer(kvm->vcpus, vcpus_next);
+	mutex_unlock(&kvm->lock);
+
+	synchronize_rcu();
 
-	kvm_put_kvm(vcpu->kvm);
+	/* vcpu is out of list,drop it safely */
+	kvm_vcpu_destruct(vcpu);
 	return 0;
 }
 
@@ -1705,7 +1741,7 @@ static int create_vcpu_fd(struct kvm_vcpu *vcpu)
 static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 {
 	int r;
-	struct kvm_vcpu *vcpu, *v;
+	struct kvm_vcpu *vcpu, *v, *vcpus;
 
 	vcpu = kvm_arch_vcpu_create(kvm, id);
 	if (IS_ERR(vcpu))
@@ -1723,13 +1759,13 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 		goto unlock_vcpu_destroy;
 	}
 
-	kvm_for_each_vcpu(r, v, kvm)
+	kvm_for_each_vcpu(r, v, kvm, vcpus)
 		if (v->vcpu_id == id) {
 			r = -EEXIST;
 			goto unlock_vcpu_destroy;
 		}
 
-	BUG_ON(kvm->vcpus[atomic_read(&kvm->online_vcpus)]);
+	BUG_ON(kvm->vcpus+atomic_read(&kvm->online_vcpus));
 
 	/* Now it's all set up, let userspace reach it */
 	kvm_get_kvm(kvm);
@@ -1739,7 +1775,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 		goto unlock_vcpu_destroy;
 	}
 
-	kvm->vcpus[atomic_read(&kvm->online_vcpus)] = vcpu;
+	memcpy(kvm->vcpus+atomic_read(&kvm->online_vcpus), vcpu, sizeof(vcpu));
 	smp_wmb();
 	atomic_inc(&kvm->online_vcpus);
 
@@ -2631,13 +2667,13 @@ static int vcpu_stat_get(void *_offset, u64 *val)
 {
 	unsigned offset = (long)_offset;
 	struct kvm *kvm;
-	struct kvm_vcpu *vcpu;
+	struct kvm_vcpu *vcpu, *vcpus;
 	int i;
 
 	*val = 0;
 	raw_spin_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list)
-		kvm_for_each_vcpu(i, vcpu, kvm)
+		kvm_for_each_vcpu(i, vcpu, kvm, vcpus)
 			*val += *(u32 *)((void *)vcpu + offset);
 
 	raw_spin_unlock(&kvm_lock);
-- 
1.7.4.4

