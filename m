Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab2KTGeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 01:34:09 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:40124 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab2KTGeF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 01:34:05 -0500
From: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] AER-KVM: Integration of KVM with AER for PCI pass-thru
 devices
Thread-Topic: [PATCH 3/4] AER-KVM: Integration of KVM with AER for PCI
 pass-thru devices
Thread-Index: AQHNxujP2hLlhlnAGESF8Fj383jnug==
Date: Tue, 20 Nov 2012 06:32:28 +0000
Message-ID: <F9E001219150CB45BEDC82A650F360C90146FCF8@G4W3208.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.201.58.14]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


    - Register a notifier function to be called whenever a PCIe error is
    detected by the AER subsystem.

    - The notifier function bumps up a global count to keep track of the
    error notifications.

    - Before guest entry, each vcpu checks if there has been any new
    notifications since last check. If any, check if the device impacted
    is assigned to the guest. If impacted, return to qemu requesting that
    the guest be brought down. If no device assigned to the guest is impacted,
    sync up the per guest notified count to the global value.

    - At guest start time, check if any of the PCI devices assigned to the
    guest is faulty and if so, fail the guest startup.

Signed-off-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 44 +++++++++++++++++++++++++++++++++++++++++
 include/linux/kvm_host.h        |  4 ++++
 include/uapi/linux/kvm.h        |  1 +
 virt/kvm/assigned-dev.c         | 34 +++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c             | 34 +++++++++++++++++++++++++++++++
 6 files changed, 118 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b2e11f4..481ad94 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -951,6 +951,7 @@ enum {
  */
 asmlinkage void kvm_spurious_fault(void);
 extern bool kvm_rebooting;
+extern unsigned long kvm_aer_notified_cnt;
 
 #define ____kvm_handle_fault_on_reboot(insn, cleanup_insn)	\
 	"666: " insn "\n\t" \
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4f76417..87e3c3e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5235,6 +5235,32 @@ static void process_nmi(struct kvm_vcpu *vcpu)
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 }
 
+/*
+ * This function checks if KVM has been notified of any PCI error since last
+ * checked by this guest. If so, it checks if any PCI device assigned to this
+ * guest has got the error. If not, adjust the per guest notified_cnt to match
+ * the global kvm notified_cnt
+ */
+static inline int kvm_aer_exit(struct kvm *kvm)
+{
+	if (kvm_aer_notified_cnt == kvm->aer_notified_cnt)
+		return 0;
+
+	/*
+	 * These errors are expected to be very rare. In the case
+	 * of an error notification, multiple vcpu threads could reach
+	 * here and do the device check below. However, functionally
+	 * it shouldn't cause a problem.
+	 */
+	if (kvm_find_assigned_dev_err(kvm)) {
+		return 1;
+	} else {
+		spin_lock(&kvm->aer_lock);
+		kvm->aer_notified_cnt = kvm_aer_notified_cnt;
+		spin_unlock(&kvm->aer_lock);
+		return 0;
+	}
+}
 static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 {
 	int r;
@@ -5334,6 +5360,24 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		goto cancel_injection;
 	}
 
+	/*
+	 * If any of the PCI devices assigned to a guest is reported to have
+	 * uncorrected error, do not allow guest code to execute, instead
+	 * bring down the guest to contain the error. Note that there is a
+	 * small window here where a new error notification could come in while
+	 * while the check is being done or right after the check before the cpu
+	 * enters the guest mode. Not sure if this check needs to be after
+	 * kvm_guest_enter() ?
+	 */
+	if (kvm_aer_exit(vcpu->kvm)) {
+		vcpu->mode = OUTSIDE_GUEST_MODE;
+		smp_wmb();
+		local_irq_enable();
+		preempt_enable();
+		r = 0;
+		vcpu->run->exit_reason = KVM_EXIT_AER_SHUTDOWN;
+		goto cancel_injection;
+	}
 	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
 
 	if (req_immediate_exit)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ecc5543..b3c2730 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -364,6 +364,8 @@ struct kvm {
 	long mmu_notifier_count;
 #endif
 	long tlbs_dirty;
+	spinlock_t aer_lock;
+	unsigned long aer_notified_cnt;
 };
 
 #define kvm_err(fmt, ...) \
@@ -933,6 +935,8 @@ static inline long kvm_vm_ioctl_assigned_device(struct kvm *kvm, unsigned ioctl,
 
 #endif
 
+int kvm_find_assigned_dev_err(struct kvm *kvm);
+
 static inline void kvm_make_request(int req, struct kvm_vcpu *vcpu)
 {
 	set_bit(req, &vcpu->requests);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0a6d6ba..6263c21 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -167,6 +167,7 @@ struct kvm_pit_config {
 #define KVM_EXIT_OSI              18
 #define KVM_EXIT_PAPR_HCALL	  19
 #define KVM_EXIT_S390_UCONTROL	  20
+#define KVM_EXIT_AER_SHUTDOWN     21
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 #define KVM_INTERNAL_ERROR_EMULATION 1
diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index 23a41a9..702cecd 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -682,6 +682,16 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 		r = -EPERM;
 		goto out_put;
 	}
+	/*
+	 * Don't allow any tainted devices to be assigned
+	 */
+	if (dev->dev_flags & PCI_DEV_FLAGS_ERR_DETECTED) {
+		pr_info("%s: Faulty PCI device %s\n",
+				__func__,  dev_name(&dev->dev));
+		r = -EINVAL;
+		goto out_put;
+	}
+
 
 	r = probe_sysfs_permissions(dev);
 	if (r)
@@ -1034,3 +1044,27 @@ long kvm_vm_ioctl_assigned_device(struct kvm *kvm, unsigned ioctl,
 out:
 	return r;
 }
+
+/*
+ * Check if any of the PCI device directly assigned to a guest has any error
+ * reported. The AER module sets the PCI_DEV_FLAGS_ERR_DETECTED when an
+ * error is reported on the device by the hardware.
+ */
+int kvm_find_assigned_dev_err(struct kvm *kvm)
+{
+	struct list_head *ptr;
+	struct list_head *head = &kvm->arch.assigned_dev_head;
+	struct kvm_assigned_dev_kernel *entry;
+
+	mutex_lock(&kvm->lock);
+	list_for_each(ptr, head) {
+		entry = list_entry(ptr, struct kvm_assigned_dev_kernel, list);
+		if (entry->dev->dev_flags & PCI_DEV_FLAGS_ERR_DETECTED) {
+			mutex_unlock(&kvm->lock);
+			return 1;
+		}
+	}
+	mutex_unlock(&kvm->lock);
+	return 0;
+}
+
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index be70035..7e764cb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -49,6 +49,7 @@
 #include <linux/slab.h>
 #include <linux/sort.h>
 #include <linux/bsearch.h>
+#include <linux/aer.h>
 
 #include <asm/processor.h>
 #include <asm/io.h>
@@ -98,6 +99,16 @@ static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 bool kvm_rebooting;
 EXPORT_SYMBOL_GPL(kvm_rebooting);
 
+/*
+ * Whenever a PCI error is detected on any device, KVM is notified through a
+ * callback in the AER handling code. In the callback, kvm_aer_notified_cnt is
+ * bumped up. Each guest also has an aer_notified_cnt which is synched up to
+ * this global count at guest enrty time after taking appropriate action if
+ * needed
+ */
+unsigned long kvm_aer_notified_cnt;
+EXPORT_SYMBOL_GPL(kvm_aer_notified_cnt);
+
 static bool largepages_enabled = true;
 
 bool kvm_is_mmio_pfn(pfn_t pfn)
@@ -491,6 +502,8 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	mutex_init(&kvm->irq_lock);
 	mutex_init(&kvm->slots_lock);
 	atomic_set(&kvm->users_count, 1);
+	spin_lock_init(&kvm->aer_lock);
+	kvm->aer_notified_cnt = kvm_aer_notified_cnt;
 
 	r = kvm_init_mmu_notifier(kvm);
 	if (r)
@@ -2573,6 +2586,24 @@ static struct notifier_block kvm_reboot_notifier = {
 	.priority = 0,
 };
 
+/*
+ * This is the callback function invoked when a PCIe error is detected
+ * Multiple notifications can happen at the same time and the count incremented
+ * at the same time. An atomic increment is not needed since it is unimportant
+ * by how much it is different from the guest specific count. As long as it is
+ * different, guest takes action.
+ */
+static int kvm_aer_notify(struct notifier_block *notifier, unsigned long val,
+		      void *v)
+{
+	kvm_aer_notified_cnt++;
+	return NOTIFY_OK;
+}
+static struct notifier_block kvm_aer_notifier_block = {
+	.notifier_call = kvm_aer_notify,
+};
+
+
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus)
 {
 	int i;
@@ -2899,6 +2930,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	if (r)
 		goto out_free_2;
 	register_reboot_notifier(&kvm_reboot_notifier);
+	aer_notifier_register(&kvm_aer_notifier_block);
 
 	/* A kmem cache lets us meet the alignment requirements of fx_save. */
 	if (!vcpu_align)
@@ -2944,6 +2976,7 @@ out_unreg:
 out_free:
 	kmem_cache_destroy(kvm_vcpu_cache);
 out_free_3:
+	aer_notifier_unregister(&kvm_aer_notifier_block);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	unregister_cpu_notifier(&kvm_cpu_notifier);
 out_free_2:
@@ -2965,6 +2998,7 @@ void kvm_exit(void)
 	kmem_cache_destroy(kvm_vcpu_cache);
 	kvm_async_pf_deinit();
 	unregister_syscore_ops(&kvm_syscore_ops);
+	aer_notifier_unregister(&kvm_aer_notifier_block);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	unregister_cpu_notifier(&kvm_cpu_notifier);
 	on_each_cpu(hardware_disable_nolock, NULL, 1);
-- 
1.7.11.3

