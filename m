Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab0FOHft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 03:35:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755846Ab0FOHe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 03:34:59 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: avi@redhat.com, mtosatti@redhat.com, glommer@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>
Subject: [PATCH 15/17] Fix AMD C1 TSC desynchronization
Date: Mon, 14 Jun 2010 21:34:17 -1000
Message-Id: <1276587259-32319-16-git-send-email-zamsden@redhat.com>
In-Reply-To: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some AMD based machines can have TSC drift when in C1 HLT state because
despite attempting to scale the TSC increment when dividing down the
P-state, the processor may return to full P-state to service cache
probes.  The TSC of halted CPUs can advance faster than that of running
CPUs as a result, causing unpredictable TSC drift.

We implement a recommended workaround, which is disabling C1 clock ramping.
---
 arch/x86/kvm/x86.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ef847ee..8e836e9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -56,6 +56,11 @@
 #include <asm/i387.h>
 #include <asm/xcr.h>
 
+#ifdef CONFIG_K8_NB
+#include <linux/pci.h>
+#include <asm/k8.h>
+#endif
+
 #define MAX_IO_MSRS 256
 #define CR0_RESERVED_BITS						\
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -4287,10 +4292,43 @@ static struct notifier_block kvmclock_cpu_notifier_block = {
 	.priority = -INT_MAX
 };
 
+static u8 disabled_c1_ramp = 0;
+
 static void kvm_timer_init(void)
 {
 	int cpu;
 
+	/*
+	 * AMD processors can de-synchronize TSC on halt in C1 state, because
+	 * processors in lower P state will have TSC scaled properly during
+	 * normal operation, but will have TSC scaled improperly while
+	 * servicing cache probes.  Because there is no way to determine how
+	 * TSC was adjusted during cache probes, there are two solutions:
+	 * resynchronize after halt, or disable C1-clock ramping.
+	 *
+	 * We implemenent solution 2.
+	 */
+#ifdef CONFIG_K8_NB
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
+	    boot_cpu_data.x86 == 0x0f &&
+	    !boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
+		struct pci_dev *nb;
+		int i;
+		cache_k8_northbridges();
+		for (i = 0; i < num_k8_northbridges; i++) {
+			u8 byte;
+			nb = k8_northbridges[i];
+			pci_read_config_byte(nb, 0x87, &byte);
+			if (byte & 1) {
+				printk(KERN_INFO "%s: AMD C1 clock ramping detected, performing workaround\n", __func__);
+				disabled_c1_ramp = byte;
+				pci_write_config_byte(nb, 0x87, byte & 0xFC);
+
+			}
+		}
+	}
+#endif
+
 	register_hotcpu_notifier(&kvmclock_cpu_notifier_block);
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
 		cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
@@ -4402,6 +4440,13 @@ void kvm_arch_exit(void)
 	unregister_hotcpu_notifier(&kvmclock_cpu_notifier_block);
 	kvm_x86_ops = NULL;
 	kvm_mmu_module_exit();
+#ifdef CONFIG_K8_NB
+	if (disabled_c1_ramp) {
+		struct pci_dev **nb;
+		for (nb = k8_northbridges; *nb; nb++)
+			pci_write_config_byte(*nb, 0x87, disabled_c1_ramp);
+	}
+#endif
 }
 
 int kvm_emulate_halt(struct kvm_vcpu *vcpu)
-- 
1.7.1

