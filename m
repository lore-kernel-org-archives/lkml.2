Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030974Ab2LGVaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 16:30:52 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:48103 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030947Ab2LGVau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 16:30:50 -0500
Subject: [RFCv2][PATCH 2/3] fix kvm's use of __pa() on percpu areas
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Gleb Natapov <gleb@redhat.com>,
        Avi Kivity <avi@redhat.com>, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 07 Dec 2012 16:30:24 -0500
References: <20121207213023.AA3AFF11@kernel.stglabs.ibm.com>
In-Reply-To: <20121207213023.AA3AFF11@kernel.stglabs.ibm.com>
Message-Id: <20121207213024.105B3C00@kernel.stglabs.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120721-7606-0000-0000-0000063F63E9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In short, it is illegal to call __pa() on an address holding
a percpu variable.  The times when this actually matters are
pretty obscure (certain 32-bit NUMA systems), but it _does_
happen.  It is important to keep KVM guests working on these
systems because the real hardware is getting harder and
harder to find.

This bug manifested first by me seeing a plain hang at boot
after this message:

	CPU 0 irqstacks, hard=f3018000 soft=f301a000

or, sometimes, it would actually make it out to the console:

[    0.000000] BUG: unable to handle kernel paging request at ffffffff

I eventually traced it down to the KVM async pagefault code.
This can be worked around by disabling that code either at
compile-time, or on the kernel command-line.

The kvm async pagefault code was injecting page faults in
to the guest which the guest misinterpreted because its
"reason" was not being properly sent from the host.

The guest passes a physical address of an per-cpu async page
fault structure via an MSR to the host.  Since __pa() is
broken on percpu data, the physical address it sent was
bascially bogus and the host went scribbling on random data.
The guest never saw the real reason for the page fault (it
was injected by the host), assumed that the kernel had taken
a _real_ page fault, and panic()'d.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/x86/kernel/kvm.c      |    9 +++++----
 linux-2.6.git-dave/arch/x86/kernel/kvmclock.c |    4 ++--
 2 files changed, 7 insertions(+), 6 deletions(-)

diff -puN arch/x86/kernel/kvm.c~fix-kvm-__pa-use-on-percpu-areas arch/x86/kernel/kvm.c
--- linux-2.6.git/arch/x86/kernel/kvm.c~fix-kvm-__pa-use-on-percpu-areas	2012-11-30 16:09:03.562055643 -0500
+++ linux-2.6.git-dave/arch/x86/kernel/kvm.c	2012-11-30 16:09:03.586055841 -0500
@@ -284,9 +284,9 @@ static void kvm_register_steal_time(void
 
 	memset(st, 0, sizeof(*st));
 
-	wrmsrl(MSR_KVM_STEAL_TIME, (__pa(st) | KVM_MSR_ENABLED));
+	wrmsrl(MSR_KVM_STEAL_TIME, (slow_virt_to_phys(st) | KVM_MSR_ENABLED));
 	printk(KERN_INFO "kvm-stealtime: cpu %d, msr %lx\n",
-		cpu, __pa(st));
+		cpu, slow_virt_to_phys(st));
 }
 
 static DEFINE_PER_CPU(unsigned long, kvm_apic_eoi) = KVM_PV_EOI_DISABLED;
@@ -311,7 +311,7 @@ void __cpuinit kvm_guest_cpu_init(void)
 		return;
 
 	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF) && kvmapf) {
-		u64 pa = __pa(&__get_cpu_var(apf_reason));
+		u64 pa = slow_virt_to_phys(&__get_cpu_var(apf_reason));
 
 #ifdef CONFIG_PREEMPT
 		pa |= KVM_ASYNC_PF_SEND_ALWAYS;
@@ -327,7 +327,8 @@ void __cpuinit kvm_guest_cpu_init(void)
 		/* Size alignment is implied but just to make it explicit. */
 		BUILD_BUG_ON(__alignof__(kvm_apic_eoi) < 4);
 		__get_cpu_var(kvm_apic_eoi) = 0;
-		pa = __pa(&__get_cpu_var(kvm_apic_eoi)) | KVM_MSR_ENABLED;
+		pa = slow_virt_to_phys(&__get_cpu_var(kvm_apic_eoi))
+			| KVM_MSR_ENABLED;
 		wrmsrl(MSR_KVM_PV_EOI_EN, pa);
 	}
 
diff -puN arch/x86/kernel/kvmclock.c~fix-kvm-__pa-use-on-percpu-areas arch/x86/kernel/kvmclock.c
--- linux-2.6.git/arch/x86/kernel/kvmclock.c~fix-kvm-__pa-use-on-percpu-areas	2012-11-30 16:09:03.562055643 -0500
+++ linux-2.6.git-dave/arch/x86/kernel/kvmclock.c	2012-11-30 16:09:03.586055841 -0500
@@ -142,8 +142,8 @@ int kvm_register_clock(char *txt)
 	int cpu = smp_processor_id();
 	int low, high, ret;
 
-	low = (int)__pa(&per_cpu(hv_clock, cpu)) | 1;
-	high = ((u64)__pa(&per_cpu(hv_clock, cpu)) >> 32);
+	low = (int)slow_virt_to_phys(&per_cpu(hv_clock, cpu)) | 1;
+	high = ((u64)slow_virt_to_phys(&per_cpu(hv_clock, cpu)) >> 32);
 	ret = native_write_msr_safe(msr_kvm_system_time, low, high);
 	printk(KERN_INFO "kvm-clock: cpu %d, msr %x:%x, %s\n",
 	       cpu, high, low, txt);
diff -puN include/linux/percpu-defs.h~fix-kvm-__pa-use-on-percpu-areas include/linux/percpu-defs.h
diff -puN mm/percpu-vm.c~fix-kvm-__pa-use-on-percpu-areas mm/percpu-vm.c
diff -puN mm/percpu.c~fix-kvm-__pa-use-on-percpu-areas mm/percpu.c
diff -puN include/linux/percpu.h~fix-kvm-__pa-use-on-percpu-areas include/linux/percpu.h
diff -puN include/asm-generic/percpu.h~fix-kvm-__pa-use-on-percpu-areas include/asm-generic/percpu.h
diff -puN arch/x86/include/asm/segment.h~fix-kvm-__pa-use-on-percpu-areas arch/x86/include/asm/segment.h
diff -puN arch/x86/kernel/entry_32.S~fix-kvm-__pa-use-on-percpu-areas arch/x86/kernel/entry_32.S
diff -puN drivers/base/cpu.c~fix-kvm-__pa-use-on-percpu-areas drivers/base/cpu.c
_

