Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751155Ab2IFL3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 07:29:42 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:59324 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab2IFL3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 07:29:39 -0400
X-AuditID: b753bd60-94360ba000007c38-d5-5048889e035e
X-AuditID: b753bd60-94360ba000007c38-d5-5048889e035e
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC v2 PATCH 00/21] KVM: x86: CPU isolation and direct interrupts
 delivery to guests
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Thu, 06 Sep 2012 20:27:18 +0900
Message-ID: <20120906112718.13320.8231.stgit@kvmdev>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This RFC patch series provides facility to dedicate CPUs to KVM guests
and enable the guests to handle interrupts from passed-through PCI devices
directly (without VM exit and relay by the host).

With this feature, we can improve throughput and response time of the device
and the host's CPU usage by reducing the overhead of interrupt handling.
This is good for the application using very high throughput/frequent
interrupt device (e.g. 10GbE NIC).
Real-time applicatoins also gets benefit from CPU isolation feature, which
reduces interfare from host kernel tasks and scheduling delay.

The overview of this patch series is presented in CloudOpen 2012.
The slides are available at:
http://events.linuxfoundation.org/images/stories/pdf/lcna_co2012_sekiyama.pdf

* Changes from v1 ( https://lkml.org/lkml/2012/6/28/30 )
 - SMP guest is supported
 - Direct EOI is added, that eliminate VM exit on EOI
 - Direct local APIC timer access from guests is added, which pass-through the
   physical timer of a dedicated CPU to the guest.
 - Rebased on v3.6-rc4

* How to test
 - Create a guest VM with 1 CPU and some PCI passthrough devices (which
   supports MSI/MSI-X).
   No VGA display will be better...
 - Apply the patch at the end of this mail to qemu-kvm.
   (This patch is just for simple testing, and dedicated CPU ID for the
    guest is hard-coded.)
 - Run the guest once to ensure the PCI passthrough works correctly.
 - Make the specified CPU offline.
     # echo 0 > /sys/devices/system/cpu/cpu3/online
 - Launch qemu-kvm with -no-kvm-pit option.
   The offlined CPU is booted as a slave CPU and guest is runs on that CPU.

* To-do
 - Enable slave CPUs to handle access fault
 - Support AMD SVM
 - Support non-Linux guests

---

Tomoki Sekiyama (21):
      x86: request TLB flush to slave CPU using NMI
      KVM: Pass-through local APIC timer of on slave CPUs to guest VM
      KVM: Enable direct EOI for directly routed interrupts to guests
      KVM: route assigned devices' MSI/MSI-X directly to guests on slave CPUs
      KVM: add kvm_arch_vcpu_prevent_run to prevent VM ENTER when NMI is received
      KVM: vmx: Add definitions PIN_BASED_PREEMPTION_TIMER
      KVM: add tracepoint on enabling/disabling direct interrupt delivery
      KVM: Directly handle interrupts by guests without VM EXIT on slave CPUs
      x86/apic: IRQ vector remapping on slave for slave CPUs
      x86/apic: Enable external interrupt routing to slave CPUs
      KVM: no exiting from guest when slave CPU halted
      KVM: proxy slab operations for slave CPUs on online CPUs
      KVM: Go back to online CPU on VM exit by external interrupt
      KVM: Add KVM_GET_SLAVE_CPU and KVM_SET_SLAVE_CPU to vCPU ioctl
      KVM: handle page faults of slave guests on online CPUs
      KVM: Add facility to run guests on slave CPUs
      KVM: Enable/Disable virtualization on slave CPUs are activated/dying
      x86: Avoid RCU warnings on slave CPUs
      x86: Support hrtimer on slave CPUs
      x86: Add a facility to use offlined CPUs as slave CPUs
      x86: Split memory hotplug function from cpu_up() as cpu_memory_up()


 arch/x86/Kconfig                      |   10 +
 arch/x86/include/asm/apic.h           |   10 +
 arch/x86/include/asm/irq.h            |   15 +
 arch/x86/include/asm/kvm_host.h       |   59 +++++
 arch/x86/include/asm/tlbflush.h       |    5 
 arch/x86/include/asm/vmx.h            |    3 
 arch/x86/kernel/apic/apic.c           |   11 +
 arch/x86/kernel/apic/io_apic.c        |  111 ++++++++-
 arch/x86/kernel/apic/x2apic_cluster.c |    8 -
 arch/x86/kernel/cpu/common.c          |    5 
 arch/x86/kernel/smp.c                 |    2 
 arch/x86/kernel/smpboot.c             |  264 ++++++++++++++++++++++-
 arch/x86/kvm/irq.c                    |  136 ++++++++++++
 arch/x86/kvm/lapic.c                  |   56 +++++
 arch/x86/kvm/lapic.h                  |    2 
 arch/x86/kvm/mmu.c                    |   63 ++++-
 arch/x86/kvm/mmu.h                    |    4 
 arch/x86/kvm/trace.h                  |   19 ++
 arch/x86/kvm/vmx.c                    |  180 +++++++++++++++
 arch/x86/kvm/x86.c                    |  387 +++++++++++++++++++++++++++++++--
 arch/x86/kvm/x86.h                    |    9 +
 arch/x86/mm/tlb.c                     |   94 ++++++++
 drivers/iommu/intel_irq_remapping.c   |   32 ++-
 include/linux/cpu.h                   |   36 +++
 include/linux/cpumask.h               |   26 ++
 include/linux/kvm.h                   |    4 
 include/linux/kvm_host.h              |    2 
 kernel/cpu.c                          |   83 +++++--
 kernel/hrtimer.c                      |   14 +
 kernel/irq/manage.c                   |    4 
 kernel/irq/migration.c                |    2 
 kernel/irq/proc.c                     |    2 
 kernel/rcutree.c                      |   14 +
 kernel/smp.c                          |    9 +
 virt/kvm/assigned-dev.c               |    8 +
 virt/kvm/async_pf.c                   |   17 +
 virt/kvm/kvm_main.c                   |   32 +++
 37 files changed, 1629 insertions(+), 109 deletions(-)



* Patch for qemu-kvm-1.0

diff -Narup a/qemu-kvm-1.0/linux-headers/linux/kvm.h b/qemu-kvm-1.0/linux-headers/linux/kvm.h
--- a/qemu-kvm-1.0/linux-headers/linux/kvm.h	2011-12-04 19:38:06.000000000 +0900
+++ b/qemu-kvm-1.0/linux-headers/linux/kvm.h	2012-08-22 14:20:50.080495725 +0900
@@ -558,6 +558,7 @@ struct kvm_ppc_pvinfo {
 #define KVM_CAP_PPC_PAPR 68
 #define KVM_CAP_SW_TLB 69
 #define KVM_CAP_ONE_REG 70
+#define KVM_CAP_SLAVE_CPU 81
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -811,6 +812,10 @@ struct kvm_one_reg {
 /* Available with KVM_CAP_ONE_REG */
 #define KVM_GET_ONE_REG		  _IOWR(KVMIO, 0xab, struct kvm_one_reg)
 #define KVM_SET_ONE_REG		  _IOW(KVMIO,  0xac, struct kvm_one_reg)
+/* Available with KVM_CAP_SLAVE_CPU */
+#define KVM_GET_SLAVE_CPU	  _IO(KVMIO,  0xae)
+#define KVM_SET_SLAVE_CPU	  _IO(KVMIO,  0xaf)
+
 
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 
diff -Narup a/qemu-kvm-1.0/qemu-kvm-x86.c b/qemu-kvm-1.0/qemu-kvm-x86.c
--- a/qemu-kvm-1.0/qemu-kvm-x86.c	2011-12-04 19:38:06.000000000 +0900
+++ b/qemu-kvm-1.0/qemu-kvm-x86.c	2012-09-06 20:19:44.828163734 +0900
@@ -139,12 +139,28 @@ static int kvm_enable_tpr_access_reporti
     return kvm_vcpu_ioctl(env, KVM_TPR_ACCESS_REPORTING, &tac);
 }
 
+static int kvm_set_slave_cpu(CPUState *env)
+{
+    int r, slave = env->cpu_index == 0 ? 2 : env->cpu_index == 1 ? 3 : -1;
+
+    r = kvm_ioctl(env->kvm_state, KVM_CHECK_EXTENSION, KVM_CAP_SLAVE_CPU);
+    if (r <= 0) {
+        return -ENOSYS;
+    }
+    r = kvm_vcpu_ioctl(env, KVM_SET_SLAVE_CPU, slave);
+    if (r < 0)
+        perror("kvm_set_slave_cpu");
+    return r;
+}
+
 static int _kvm_arch_init_vcpu(CPUState *env)
 {
     kvm_arch_reset_vcpu(env);
 
     kvm_enable_tpr_access_reporting(env);
 
+    kvm_set_slave_cpu(env);
+
     return kvm_update_ioport_access(env);
 }
 

