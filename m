Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683Ab1LOE25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 23:28:57 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33659 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018Ab1LOE2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 23:28:55 -0500
From: Liu Ping Fan <kernelfans@gmail.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, aliguori@us.ibm.com,
        gleb@redhat.com, mtosatti@redhat.com, jan.kiszka@web.de
Subject: [PATCH v4] kvm: make vcpu life cycle separated from kvm instance
Date: Thu, 15 Dec 2011 12:28:48 +0800
Message-Id: <1323923328-917-1-git-send-email-kernelfans@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <CAFgQCTtkaTpjDyyzEaNwNv_+FdjTQ+ZbYAAbAUKZ6NmWXJfheA@mail.gmail.com>
References: <CAFgQCTtkaTpjDyyzEaNwNv_+FdjTQ+ZbYAAbAUKZ6NmWXJfheA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>

Currently, vcpu can be destructed only when kvm instance destroyed.
Change this to vcpu's destruction before kvm instance, so vcpu MUST
and CAN be destroyed before kvm's destroy.

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
---
 arch/x86/kvm/i8254.c     |    8 ++-
 arch/x86/kvm/i8259.c     |   11 +++--
 arch/x86/kvm/mmu.c       |    5 +-
 arch/x86/kvm/x86.c       |   50 ++++++++---------
 include/linux/kvm_host.h |   27 +++++----
 virt/kvm/irq_comm.c      |    6 ++-
 virt/kvm/kvm_main.c      |  131 ++++++++++++++++++++++++++++++++++++----------
 7 files changed, 161 insertions(+), 77 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 76e3f1c..b8990ca 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -289,7 +289,6 @@ static void pit_do_work(struct work_struct *work)
 	struct kvm_pit *pit = container_of(work, struct kvm_pit, expired);
 	struct kvm *kvm = pit->kvm;
 	struct kvm_vcpu *vcpu;
-	int i;
 	struct kvm_kpit_state *ps = &pit->pit_state;
 	int inject = 0;
 
@@ -315,9 +314,12 @@ static void pit_do_work(struct work_struct *work)
 		 * LVT0 to NMI delivery. Other PIC interrupts are just sent to
 		 * VCPU0, and only if its LVT0 is in EXTINT mode.
 		 */
-		if (kvm->arch.vapics_in_nmi_mode > 0)
-			kvm_for_each_vcpu(i, vcpu, kvm)
+		if (kvm->arch.vapics_in_nmi_mode > 0) {
+			rcu_read_lock();
+			kvm_for_each_vcpu(vcpu, kvm)
 				kvm_apic_nmi_wd_deliver(vcpu);
+			rcu_read_unlock();
+		}
 	}
 }
 
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index cac4746..f275b8c 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -50,25 +50,28 @@ static void pic_unlock(struct kvm_pic *s)
 {
 	bool wakeup = s->wakeup_needed;
 	struct kvm_vcpu *vcpu, *found = NULL;
-	int i;
+	struct kvm *kvm = s->kvm;
 
 	s->wakeup_needed = false;
 
 	spin_unlock(&s->lock);
 
 	if (wakeup) {
-		kvm_for_each_vcpu(i, vcpu, s->kvm) {
+		rcu_read_lock();
+		kvm_for_each_vcpu(vcpu, kvm)
 			if (kvm_apic_accept_pic_intr(vcpu)) {
 				found = vcpu;
 				break;
 			}
-		}
 
-		if (!found)
+		if (!found) {
+			rcu_read_unlock();
 			return;
+		}
 
 		kvm_make_request(KVM_REQ_EVENT, found);
 		kvm_vcpu_kick(found);
+		rcu_read_unlock();
 	}
 }
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index f1b36cf..ba082cd 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1833,11 +1833,12 @@ static void kvm_mmu_put_page(struct kvm_mmu_page *sp, u64 *parent_pte)
 
 static void kvm_mmu_reset_last_pte_updated(struct kvm *kvm)
 {
-	int i;
 	struct kvm_vcpu *vcpu;
 
-	kvm_for_each_vcpu(i, vcpu, kvm)
+	rcu_read_lock();
+	kvm_for_each_vcpu(vcpu, kvm)
 		vcpu->arch.last_pte_updated = NULL;
+	rcu_read_unlock();
 }
 
 static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c38efd7..acaa154 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1830,11 +1830,13 @@ static int get_msr_hyperv(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 
 	switch (msr) {
 	case HV_X64_MSR_VP_INDEX: {
-		int r;
+		int r = 0;
 		struct kvm_vcpu *v;
-		kvm_for_each_vcpu(r, v, vcpu->kvm)
+		kvm_for_each_vcpu(v, vcpu->kvm) {
 			if (v == vcpu)
 				data = r;
+			r++;
+		}
 		break;
 	}
 	case HV_X64_MSR_EOI:
@@ -4966,7 +4968,7 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
 	struct cpufreq_freqs *freq = data;
 	struct kvm *kvm;
 	struct kvm_vcpu *vcpu;
-	int i, send_ipi = 0;
+	int send_ipi = 0;
 
 	/*
 	 * We allow guests to temporarily run on slowing clocks,
@@ -5016,13 +5018,16 @@ static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long va
 
 	raw_spin_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list) {
-		kvm_for_each_vcpu(i, vcpu, kvm) {
+		rcu_read_lock();
+		kvm_for_each_vcpu(vcpu, kvm) {
 			if (vcpu->cpu != freq->cpu)
 				continue;
 			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 			if (vcpu->cpu != smp_processor_id())
 				send_ipi = 1;
 		}
+		rcu_read_unlock();
+
 	}
 	raw_spin_unlock(&kvm_lock);
 
@@ -6433,13 +6438,16 @@ int kvm_arch_hardware_enable(void *garbage)
 {
 	struct kvm *kvm;
 	struct kvm_vcpu *vcpu;
-	int i;
 
 	kvm_shared_msr_cpu_online();
-	list_for_each_entry(kvm, &vm_list, vm_list)
-		kvm_for_each_vcpu(i, vcpu, kvm)
+	list_for_each_entry(kvm, &vm_list, vm_list) {
+		rcu_read_lock();
+		kvm_for_each_vcpu(vcpu, kvm) {
 			if (vcpu->cpu == smp_processor_id())
 				kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
+		}
+		rcu_read_unlock();
+	}
 	return kvm_x86_ops->hardware_enable(garbage);
 }
 
@@ -6560,27 +6568,18 @@ static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
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
+	kvm_clear_async_pf_completion_queue(vcpu);
+	kvm_unload_vcpu_mmu(vcpu);
+	kvm_arch_vcpu_free(vcpu);
+	kvm_put_kvm(kvm);
 }
 
 void kvm_arch_sync_events(struct kvm *kvm)
@@ -6594,7 +6593,6 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_iommu_unmap_guest(kvm);
 	kfree(kvm->arch.vpic);
 	kfree(kvm->arch.vioapic);
-	kvm_free_vcpus(kvm);
 	if (kvm->arch.apic_access_page)
 		put_page(kvm->arch.apic_access_page);
 	if (kvm->arch.ept_identity_pagetable)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d526231..733de1c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -19,6 +19,7 @@
 #include <linux/slab.h>
 #include <linux/rcupdate.h>
 #include <linux/ratelimit.h>
+#include <linux/atomic.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -113,6 +114,10 @@ enum {
 
 struct kvm_vcpu {
 	struct kvm *kvm;
+	atomic_t refcount;
+	struct list_head list;
+	struct rcu_head head;
+	struct work_struct zap_work;
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	struct preempt_notifier preempt_notifier;
 #endif
@@ -241,9 +246,9 @@ struct kvm {
 	u32 bsp_vcpu_id;
 	struct kvm_vcpu *bsp_vcpu;
 #endif
-	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
+	struct list_head vcpus;
 	atomic_t online_vcpus;
-	int last_boosted_vcpu;
+	struct kvm_vcpu *last_boosted_vcpu;
 	struct list_head vm_list;
 	struct mutex lock;
 	struct kvm_io_bus *buses[KVM_NR_BUSES];
@@ -290,17 +295,15 @@ struct kvm {
 #define kvm_printf(kvm, fmt ...) printk(KERN_DEBUG fmt)
 #define vcpu_printf(vcpu, fmt...) kvm_printf(vcpu->kvm, fmt)
 
-static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
-{
-	smp_rmb();
-	return kvm->vcpus[i];
-}
+struct kvm_vcpu *kvm_vcpu_get(struct kvm_vcpu *vcpu);
+void kvm_vcpu_put(struct kvm_vcpu *vcpu);
+void kvm_arch_vcpu_zap(struct work_struct *work);
+
+#define kvm_for_each_vcpu(vcpu, kvm) \
+	list_for_each_entry_rcu(vcpu, &kvm->vcpus, list)
 
-#define kvm_for_each_vcpu(idx, vcpup, kvm) \
-	for (idx = 0; \
-	     idx < atomic_read(&kvm->online_vcpus) && \
-	     (vcpup = kvm_get_vcpu(kvm, idx)) != NULL; \
-	     idx++)
+#define kvm_for_each_vcpu_continue(vcpu, kvm) \
+	list_for_each_entry_continue_rcu(vcpu, &kvm->vcpus, list)
 
 int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id);
 void kvm_vcpu_uninit(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 9f614b4..1d0c3ab 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -81,14 +81,15 @@ inline static bool kvm_is_dm_lowest_prio(struct kvm_lapic_irq *irq)
 int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 		struct kvm_lapic_irq *irq)
 {
-	int i, r = -1;
+	int r = -1;
 	struct kvm_vcpu *vcpu, *lowest = NULL;
 
 	if (irq->dest_mode == 0 && irq->dest_id == 0xff &&
 			kvm_is_dm_lowest_prio(irq))
 		printk(KERN_INFO "kvm: apic: phys broadcast and lowest prio\n");
 
-	kvm_for_each_vcpu(i, vcpu, kvm) {
+	rcu_read_lock();
+	kvm_for_each_vcpu(vcpu, kvm) {
 		if (!kvm_apic_present(vcpu))
 			continue;
 
@@ -111,6 +112,7 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 	if (lowest)
 		r = kvm_apic_set_irq(lowest, irq);
 
+	rcu_read_unlock();
 	return r;
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d9cfb78..71dda47 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -141,6 +141,7 @@ void vcpu_load(struct kvm_vcpu *vcpu)
 {
 	int cpu;
 
+	kvm_vcpu_get(vcpu);
 	mutex_lock(&vcpu->mutex);
 	if (unlikely(vcpu->pid != current->pids[PIDTYPE_PID].pid)) {
 		/* The thread running this VCPU changed. */
@@ -163,6 +164,7 @@ void vcpu_put(struct kvm_vcpu *vcpu)
 	preempt_notifier_unregister(&vcpu->preempt_notifier);
 	preempt_enable();
 	mutex_unlock(&vcpu->mutex);
+	kvm_vcpu_put(vcpu);
 }
 
 static void ack_flush(void *_completed)
@@ -171,7 +173,7 @@ static void ack_flush(void *_completed)
 
 static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
 {
-	int i, cpu, me;
+	int cpu, me;
 	cpumask_var_t cpus;
 	bool called = true;
 	struct kvm_vcpu *vcpu;
@@ -179,7 +181,8 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
 	zalloc_cpumask_var(&cpus, GFP_ATOMIC);
 
 	me = get_cpu();
-	kvm_for_each_vcpu(i, vcpu, kvm) {
+	rcu_read_lock();
+	kvm_for_each_vcpu(vcpu, kvm) {
 		kvm_make_request(req, vcpu);
 		cpu = vcpu->cpu;
 
@@ -190,12 +193,15 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
 		      kvm_vcpu_exiting_guest_mode(vcpu) != OUTSIDE_GUEST_MODE)
 			cpumask_set_cpu(cpu, cpus);
 	}
+	rcu_read_unlock();
+
 	if (unlikely(cpus == NULL))
 		smp_call_function_many(cpu_online_mask, ack_flush, NULL, 1);
 	else if (!cpumask_empty(cpus))
 		smp_call_function_many(cpus, ack_flush, NULL, 1);
 	else
 		called = false;
+
 	put_cpu();
 	free_cpumask_var(cpus);
 	return called;
@@ -490,6 +496,7 @@ static struct kvm *kvm_create_vm(void)
 	raw_spin_lock(&kvm_lock);
 	list_add(&kvm->vm_list, &vm_list);
 	raw_spin_unlock(&kvm_lock);
+	INIT_LIST_HEAD(&kvm->vcpus);
 
 	return kvm;
 
@@ -600,6 +607,7 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
 {
 	struct kvm *kvm = filp->private_data;
 
+	kvm_vcpu_put(kvm->bsp_vcpu);
 	kvm_irqfd_release(kvm);
 
 	kvm_put_kvm(kvm);
@@ -1539,12 +1547,10 @@ EXPORT_SYMBOL_GPL(kvm_resched);
 void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 {
 	struct kvm *kvm = me->kvm;
-	struct kvm_vcpu *vcpu;
-	int last_boosted_vcpu = me->kvm->last_boosted_vcpu;
-	int yielded = 0;
-	int pass;
-	int i;
-
+	struct kvm_vcpu *vcpu, *v;
+	struct task_struct *task = NULL;
+	struct pid *pid;
+	int pass, firststart, lastone, yielded;
 	/*
 	 * We boost the priority of a VCPU that is runnable but not
 	 * currently running, because it got preempted by something
@@ -1552,15 +1558,22 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 	 * VCPU is holding the lock that we need and will release it.
 	 * We approximate round-robin by starting at the last boosted VCPU.
 	 */
-	for (pass = 0; pass < 2 && !yielded; pass++) {
-		kvm_for_each_vcpu(i, vcpu, kvm) {
-			struct task_struct *task = NULL;
-			struct pid *pid;
-			if (!pass && i < last_boosted_vcpu) {
-				i = last_boosted_vcpu;
+	for (pass = 0, firststart = 0; pass < 2 && !yielded; pass++) {
+
+		rcu_read_lock();
+		kvm_for_each_vcpu(vcpu, kvm) {
+			if (!pass && !firststart &&
+			    vcpu != kvm->last_boosted_vcpu &&
+			    kvm->last_boosted_vcpu != NULL) {
+				vcpu = kvm->last_boosted_vcpu;
+				firststart = 1;
 				continue;
-			} else if (pass && i > last_boosted_vcpu)
+			} else if (pass && !lastone) {
+				if (vcpu == kvm->last_boosted_vcpu)
+					lastone = 1;
+			} else if (pass && lastone)
 				break;
+
 			if (vcpu == me)
 				continue;
 			if (waitqueue_active(&vcpu->wq))
@@ -1576,15 +1589,29 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 				put_task_struct(task);
 				continue;
 			}
+			v = kvm_vcpu_get(vcpu);
+			if (v == NULL)
+				continue;
+
+			rcu_read_unlock();
 			if (yield_to(task, 1)) {
 				put_task_struct(task);
-				kvm->last_boosted_vcpu = i;
+				mutex_lock(&kvm->lock);
+				/*Remeber to release it.*/
+				if (kvm->last_boosted_vcpu != NULL)
+					kvm_vcpu_put(kvm->last_boosted_vcpu);
+				kvm->last_boosted_vcpu = vcpu;
+				mutex_unlock(&kvm->lock);
 				yielded = 1;
 				break;
 			}
+			kvm_vcpu_put(vcpu);
 			put_task_struct(task);
+			rcu_read_lock();
 		}
+		rcu_read_unlock();
 	}
+
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_on_spin);
 
@@ -1620,11 +1647,18 @@ static int kvm_vcpu_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
+/*Can not block*/
+static void kvm_vcpu_zap(struct rcu_head *rcu)
+{
+	struct kvm_vcpu *vcpu = container_of(rcu, struct kvm_vcpu, head);
+	schedule_work(&vcpu->zap_work);
+}
+
 static int kvm_vcpu_release(struct inode *inode, struct file *filp)
 {
 	struct kvm_vcpu *vcpu = filp->private_data;
-
-	kvm_put_kvm(vcpu->kvm);
+	filp->private_data = NULL;
+	kvm_vcpu_put(vcpu);
 	return 0;
 }
 
@@ -1646,6 +1680,43 @@ static int create_vcpu_fd(struct kvm_vcpu *vcpu)
 	return anon_inode_getfd("kvm-vcpu", &kvm_vcpu_fops, vcpu, O_RDWR);
 }
 
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
+		list_del_rcu(&vcpu->list);
+		atomic_dec(&kvm->online_vcpus);
+		if (kvm->last_boosted_vcpu == vcpu)
+			kvm->last_boosted_vcpu = NULL;
+		mutex_unlock(&kvm->lock);
+
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
+	atomic_set(&vcpu->refcount, 1);
+	INIT_LIST_HEAD(&vcpu->list);
+	INIT_WORK(&vcpu->zap_work, kvm_arch_vcpu_zap);
+	return vcpu;
+}
+
 /*
  * Creates some virtual cpus.  Good luck creating more than one.
  */
@@ -1654,7 +1725,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	int r;
 	struct kvm_vcpu *vcpu, *v;
 
-	vcpu = kvm_arch_vcpu_create(kvm, id);
+	vcpu = kvm_vcpu_create(kvm, id);
 	if (IS_ERR(vcpu))
 		return PTR_ERR(vcpu);
 
@@ -1670,13 +1741,14 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 		goto unlock_vcpu_destroy;
 	}
 
-	kvm_for_each_vcpu(r, v, kvm)
+	rcu_read_lock();
+	kvm_for_each_vcpu(v, kvm) {
 		if (v->vcpu_id == id) {
 			r = -EEXIST;
 			goto unlock_vcpu_destroy;
 		}
-
-	BUG_ON(kvm->vcpus[atomic_read(&kvm->online_vcpus)]);
+	}
+	rcu_read_unlock();
 
 	/* Now it's all set up, let userspace reach it */
 	kvm_get_kvm(kvm);
@@ -1686,13 +1758,15 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 		goto unlock_vcpu_destroy;
 	}
 
-	kvm->vcpus[atomic_read(&kvm->online_vcpus)] = vcpu;
+	/*Protected by kvm->lock*/
+	list_add_rcu(&vcpu->list, &kvm->vcpus);
+
 	smp_wmb();
 	atomic_inc(&kvm->online_vcpus);
 
 #ifdef CONFIG_KVM_APIC_ARCHITECTURE
 	if (kvm->bsp_vcpu_id == id)
-		kvm->bsp_vcpu = vcpu;
+		kvm->bsp_vcpu = kvm_vcpu_get(vcpu);
 #endif
 	mutex_unlock(&kvm->lock);
 	return r;
@@ -2593,13 +2667,15 @@ static int vcpu_stat_get(void *_offset, u64 *val)
 	unsigned offset = (long)_offset;
 	struct kvm *kvm;
 	struct kvm_vcpu *vcpu;
-	int i;
 
 	*val = 0;
 	raw_spin_lock(&kvm_lock);
-	list_for_each_entry(kvm, &vm_list, vm_list)
-		kvm_for_each_vcpu(i, vcpu, kvm)
+	list_for_each_entry(kvm, &vm_list, vm_list) {
+		rcu_read_lock();
+		kvm_for_each_vcpu(vcpu, kvm)
 			*val += *(u32 *)((void *)vcpu + offset);
+		rcu_read_unlock();
+	}
 
 	raw_spin_unlock(&kvm_lock);
 	return 0;
@@ -2765,7 +2841,6 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	kvm_preempt_ops.sched_out = kvm_sched_out;
 
 	kvm_init_debug();
-
 	return 0;
 
 out_unreg:
-- 
1.7.4.4

