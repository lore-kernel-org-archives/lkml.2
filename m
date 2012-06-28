Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab2F1GHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 02:07:31 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:47602 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab2F1GH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 02:07:29 -0400
X-AuditID: b753bd60-9aaf3ba000000f6c-14-4febf49f7787
X-AuditID: b753bd60-9aaf3ba000000f6c-14-4febf49f7787
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC PATCH 00/18] KVM: x86: CPU isolation and direct interrupts
 handling by guests
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Thu, 28 Jun 2012 15:07:19 +0900
Message-ID: <20120628060719.19298.43879.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This RFC patch series provides facility to dedicate CPUs to KVM guests
and enable the guests to handle interrupts from passed-through PCI devices
directly (without VM exit and relay by the host).

With this feature, we can improve throughput and response time of the device
and the host's CPU usage by reducing the overhead of interrupt handling.
This is good for the application using very high throughput/frequent
interrupt device (e.g. 10GbE NIC).
CPU-intensive high performance applications and real-time applicatoins
also gets benefit from CPU isolation feature, which reduces VM exit and
scheduling delay.

Current implementation is still just PoC and have many limitations, but
submitted for RFC. Any comments are appreciated.

* Overview
Intel and AMD CPUs have a feature to handle interrupts by guests without
VM Exit. However, because it cannot switch VM Exit based on IRQ vectors,
interrupts to both the host and the guest will be routed to guests.

To avoid mixture of host and guest interrupts, in this patch, some of CPUs
are cut off from the host and dedicated to the guests. In addition, IRQ
affinity of the passed-through devices are set to the guest CPUs only.

For IPI from the host to the guest, we use NMIs, that is an only interrupts
having another VM Exit flag.

* Benefits
This feature provides benefits of virtualization to areas where high
performance and low latency are required, such as HPC and trading,
and so on. It also useful for consolidation in large scale systems with
many CPU cores and PCI devices passed-through or with SR-IOV.
For the future, it may be used to keep the guests running even if the host
is crashed (but that would need additional features like memory isolation).

* Limitations
Current implementation is experimental, unstable, and has a lot of limitations.
 - SMP guests don't work correctly
 - Only Linux guest is supported
 - Only Intel VT-x is supported
 - Only MSI and MSI-X pass-through; no ISA interrupts support
 - Non passed-through PCI devices (including virtio) are slower
 - Kernel space PIT emulation does not work
 - Needs a lot of cleanups

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

* Performance Example
Tested under Xeon W3520, and 10Gb NIC (ixgbe 82599EB) with SR-IOV to share
the device with the host and a guest. Using this NIC, we measured
communication performance (throughput, latency, CPU usage) between the host
and the guest.

             w/direct interrupts handling   w/o direct interrupts handling
Throughput(*1)         11.4 Gbits/sec               8.91 Gbits/sec
Latency   (*2)        0.054 ms                     0.069 ms

 *1) measured with `iperf -s' on the host and `iperf -c' on the guest.
 *2) average `ping' RTT from the host to the guest

CPU Usage (top output)
- w/direct interrupts handling
Tasks: 200 total,   1 running, 199 sleeping,   0 stopped,   0 zombie
Cpu0  :  0.0%us,  0.0%sy,  0.0%ni, 41.1%id,  0.0%wa,  0.0%hi, 58.9%si,  0.0%st
Cpu1  :  0.0%us, 55.3%sy,  0.0%ni, 44.7%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu2  :  0.0%us,  0.0%sy,  0.0%ni, 99.0%id,  0.7%wa,  0.3%hi,  0.0%si,  0.0%st
Mem:   6152492k total,  1921728k used,  4230764k free,    52544k buffers
Swap:  8159228k total,        0k used,  8159228k free,   890964k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
32307 root       0 -20  165m 1088  772 S 56.5  0.0   1:33.03 iperf
 1777 root      20   0     0    0    0 S  0.3  0.0   0:00.01 kworker/2:0
 2121 sekiyama  20   0 15260 1372 1008 R  0.3  0.0   0:00.12 top
28792 qemu      20   0  820m 532m 8808 S  0.3 8.9   0:06.10 qemu-kvm.custom
    1 root      20   0 37536 4684 2016 S  0.0  0.1   0:05.61 systemd

- w/o direct interrupts handling
Tasks: 193 total,   1 running, 192 sleeping,   0 stopped,   0 zombie
Cpu0  :  0.0%us,  0.7%sy,  0.0%ni, 22.2%id,  0.0%wa,  0.3%hi, 76.8%si,  0.0%st
Cpu1  :  0.0%us,  0.0%sy,  0.0%ni, 98.3%id,  0.0%wa,  1.7%hi,  0.0%si,  0.0%st
Cpu2  :  0.3%us, 74.7%sy,  0.0%ni, 23.0%id,  0.0%wa,  2.0%hi,  0.0%si,  0.0%st
Cpu3  : 94.7%us,  4.6%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.7%hi,  0.0%si,  0.0%st
Mem:   6152492k total,  1586520k used,  4565972k free,    47832k buffers
Swap:  8159228k total,        0k used,  8159228k free,   644460k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND 
 1747 qemu      20   0  844m 530m 8808 S 99.2  8.8   0:23.85 qemu-kvm.custom
 1929 root       0 -20  165m 1080  772 S 70.9  0.0   0:09.96 iperf
 1804 root     -51   0     0    0    0 S  3.0  0.0   0:00.45 irq/74-kvm:0000
 1803 root     -51   0     0    0    0 S  2.6  0.0   0:00.40 irq/73-kvm:0000
 1833 sekiyama  20   0 15260 1372 1004 R  0.3  0.0   0:00.13 top

With direct interrupt handling, Guest execution is not included in top
since the dedicated CPU is offlined from the host.
And CPU usage by interrupt relay kernel thread (irq/*-kvm:0000) is reduced.

* Patch to qemu-kvm for testing

diff -u -r qemu-kvm-0.15.1/qemu-kvm-x86.c qemu-kvm-0.15.1-test/qemu-kvm-x86.c
--- qemu-kvm-0.15.1/qemu-kvm-x86.c	2011-10-19 22:54:48.000000000 +0900
+++ qemu-kvm-0.15.1-test/qemu-kvm-x86.c	2012-06-25 21:21:15.141557256 +0900
@@ -139,12 +139,28 @@
     return kvm_vcpu_ioctl(env, KVM_TPR_ACCESS_REPORTING, &tac);
 }
+static int kvm_set_slave_cpu(CPUState *env)
+{
+    int r, slave = 3;
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

 
---

Tomoki Sekiyama (18):
      x86: request TLB flush to slave CPU using NMI
      KVM: route assigned devices' MSI/MSI-X directly to guests on slave CPUs
      KVM: add kvm_arch_vcpu_prevent_run to prevent VM ENTER when NMI is received
      KVM: vmx: Add definitions PIN_BASED_PREEMPTION_TIMER
      KVM: Directly handle interrupts by guests without VM EXIT on slave CPUs
      x86/apic: IRQ vector remapping on slave for slave CPUs
      x86/apic: Enable external interrupt routing to slave CPUs
      KVM: no exiting from guest when slave CPU halted
      KVM: proxy slab operations for slave CPUs on online CPUs
      KVM: Go back to online CPU on VM exit by external interrupt
      KVM: Add KVM_GET_SLAVE_CPU and KVM_SET_SLAVE_CPU to vCPU ioctl
      KVM: handle page faults occured in slave CPUs on online CPUs
      KVM: Add facility to run guests on slave CPUs
      KVM: Enable/Disable virtualization on slave CPUs are activated/dying
      KVM: Replace local_irq_disable/enable with local_irq_save/restore
      x86: Support hrtimer on slave CPUs
      x86: Add a facility to use offlined CPUs as slave CPUs
      x86: Split memory hotplug function from cpu_up() as cpu_memory_up()


 arch/x86/Kconfig                      |   10 +
 arch/x86/include/asm/apic.h           |    4 
 arch/x86/include/asm/cpu.h            |   14 +
 arch/x86/include/asm/irq.h            |   15 +
 arch/x86/include/asm/kvm_host.h       |   56 +++++
 arch/x86/include/asm/mmu.h            |    7 +
 arch/x86/include/asm/vmx.h            |    3 
 arch/x86/kernel/apic/apic_flat_64.c   |    2 
 arch/x86/kernel/apic/io_apic.c        |   89 ++++++-
 arch/x86/kernel/apic/x2apic_cluster.c |    6 
 arch/x86/kernel/apic/x2apic_phys.c    |    2 
 arch/x86/kernel/cpu/common.c          |    3 
 arch/x86/kernel/smp.c                 |    2 
 arch/x86/kernel/smpboot.c             |  188 +++++++++++++++
 arch/x86/kvm/irq.c                    |  136 +++++++++++
 arch/x86/kvm/lapic.c                  |    6 
 arch/x86/kvm/mmu.c                    |   83 +++++--
 arch/x86/kvm/mmu.h                    |    4 
 arch/x86/kvm/trace.h                  |    1 
 arch/x86/kvm/vmx.c                    |   74 ++++++
 arch/x86/kvm/x86.c                    |  407 +++++++++++++++++++++++++++++++--
 arch/x86/mm/gup.c                     |    7 -
 arch/x86/mm/tlb.c                     |   63 +++++
 drivers/iommu/intel_irq_remapping.c   |   10 +
 include/linux/cpu.h                   |    9 +
 include/linux/cpumask.h               |   26 ++
 include/linux/kvm.h                   |    4 
 include/linux/kvm_host.h              |    2 
 kernel/cpu.c                          |   83 +++++--
 kernel/hrtimer.c                      |   22 ++
 kernel/irq/manage.c                   |    4 
 kernel/irq/migration.c                |    2 
 kernel/irq/proc.c                     |    2 
 kernel/smp.c                          |    9 -
 virt/kvm/assigned-dev.c               |    8 +
 virt/kvm/async_pf.c                   |   17 +
 virt/kvm/kvm_main.c                   |   40 +++
 37 files changed, 1296 insertions(+), 124 deletions(-)


Thanks,
-- 
Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory

