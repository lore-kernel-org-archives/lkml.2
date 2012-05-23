Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965094Ab2EWGdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:33:10 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37933 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933559Ab2EWGdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:33:05 -0400
From: Liu Ping Fan <kernelfans@gmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, qemu-devel@nongnu.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>
Subject: [PATCH] kvm: collect vcpus' numa info for guest's scheduler
Date: Wed, 23 May 2012 14:32:30 +0800
Message-Id: <1337754751-9018-4-git-send-email-kernelfans@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1337754751-9018-1-git-send-email-kernelfans@gmail.com>
References: <1337754751-9018-1-git-send-email-kernelfans@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>

The guest's scheduler can not see the numa info on the host and
this will result to the following scene:
  Supposing vcpu-a on nodeA, vcpu-b on nodeB, when load balance,
  the tasks' pull and push between these vcpus will cost more. But
  unfortunately, currently, the guest is just blind to this.

This patch want to collect vm's vcpus' numa info.

--todo:
  consider about vcpu's initial and hotplug event

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c       |   33 +++++++++++++++++++++++++++++++++
 include/linux/kvm.h      |    6 ++++++
 include/linux/kvm_host.h |    4 ++++
 virt/kvm/kvm_main.c      |   10 ++++++++++
 4 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 185a2b8..d907504 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4918,6 +4918,39 @@ void kvm_arch_exit(void)
 	kvm_mmu_module_exit();
 }
 
+#ifdef CONFIG_VIRT_SD_SUPPORTD
+int kvm_arch_guest_numa_update(struct kvm *kvm, void __user *to, int n)
+{
+	struct kvm_vcpu *vcpup;
+	s16 *apci_ids;
+	int idx, node;
+	int ret = 0;
+	unsigned int cpu;
+	struct pid *pid;
+	struct task_struct *tsk;
+	apci_ids = kmalloc(n, GFP_KERNEL);
+	if (apci_ids == NULL)
+		return -ENOMEM;
+	kvm_for_each_vcpu(idx, vcpup, kvm) {
+		rcu_read_lock();
+		pid = rcu_dereference(vcpup->pid);
+		tsk = get_pid_task(pid, PIDTYPE_PID);
+		rcu_read_unlock();
+		if (tsk) {
+			cpu = task_cpu(tsk);
+			put_task_struct(tsk);
+			node = cpu_to_node(cpu);
+		} else
+			node = NUMA_NO_NODE;
+		apci_ids[vcpup->vcpu_id] = node;
+	}
+	if (copy_to_user(to, apci_ids, n))
+		ret = -EFAULT;
+	kfree(apci_ids);
+	return ret;
+}
+#endif
+
 int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.halt_exits;
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 6c322a9..da4c0bc 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -732,6 +732,7 @@ struct kvm_one_reg {
 					struct kvm_userspace_memory_region)
 #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
 #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
+#define KVM_SET_GUEST_NUMA             _IOW(KVMIO,  0x49, struct kvm_virt_sd)
 
 /* enable ucontrol for s390 */
 struct kvm_s390_ucas_mapping {
@@ -909,5 +910,10 @@ struct kvm_assigned_msix_entry {
 	__u16 entry; /* The index of entry in the MSI-X table */
 	__u16 padding[3];
 };
+#define VIRT_SD_SUPPORTD
+struct kvm_virt_sd {
+	__u64 *vapic_map;
+	__u64 sz;
+};
 
 #endif /* __LINUX_KVM_H */
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 72cbf08..328aa0c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -526,6 +526,10 @@ void kvm_arch_destroy_vm(struct kvm *kvm);
 void kvm_free_all_assigned_devices(struct kvm *kvm);
 void kvm_arch_sync_events(struct kvm *kvm);
 
+#ifdef CONFIG_VIRT_SD_SUPPORTD
+int kvm_arch_guest_numa_update(struct kvm *kvm, void __user *to, int n);
+#endif
+
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9739b53..46292bd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2029,6 +2029,16 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = kvm_ioeventfd(kvm, &data);
 		break;
 	}
+#ifdef CONFIG_VIRT_SD_SUPPORTD
+	case KVM_SET_GUEST_NUMA: {
+		struct kvm_virt_sd sd;
+		r = -EFAULT;
+		if (copy_from_user(&sd, argp, sizeof sd))
+			goto out;
+		r = kvm_arch_guest_numa_update(kvm, sd.vapic_map, sd.sz);
+		break;
+	}
+#endif
 #ifdef CONFIG_KVM_APIC_ARCHITECTURE
 	case KVM_SET_BOOT_CPU_ID:
 		r = 0;
-- 
1.7.4.4

