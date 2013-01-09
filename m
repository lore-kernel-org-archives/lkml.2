Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab3AIS7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 13:59:12 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:33070 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932118Ab3AIS7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 13:59:11 -0500
Subject: [RFCv3][PATCH 2/3] fix kvm's use of __pa() on percpu areas
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Gleb Natapov <gleb@redhat.com>,
        Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 09 Jan 2013 13:59:05 -0500
References: <20130109185904.DD641DCE@kernel.stglabs.ibm.com>
In-Reply-To: <20130109185904.DD641DCE@kernel.stglabs.ibm.com>
Message-Id: <20130109185905.0DCFC236@kernel.stglabs.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010918-5806-0000-0000-00001E053094
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
--- linux-2.6.git/arch/x86/kernel/kvm.c~fix-kvm-__pa-use-on-percpu-areas	2013-01-09 13:55:44.218672043 -0500
+++ linux-2.6.git-dave/arch/x86/kernel/kvm.c	2013-01-09 13:55:44.222672079 -0500
@@ -289,9 +289,9 @@ static void kvm_register_steal_time(void
 
 	memset(st, 0, sizeof(*st));
 
-	wrmsrl(MSR_KVM_STEAL_TIME, (__pa(st) | KVM_MSR_ENABLED));
+	wrmsrl(MSR_KVM_STEAL_TIME, (slow_virt_to_phys(st) | KVM_MSR_ENABLED));
 	printk(KERN_INFO "kvm-stealtime: cpu %d, msr %lx\n",
-		cpu, __pa(st));
+		cpu, slow_virt_to_phys(st));
 }
 
 static DEFINE_PER_CPU(unsigned long, kvm_apic_eoi) = KVM_PV_EOI_DISABLED;
@@ -316,7 +316,7 @@ void __cpuinit kvm_guest_cpu_init(void)
 		return;
 
 	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF) && kvmapf) {
-		u64 pa = __pa(&__get_cpu_var(apf_reason));
+		u64 pa = slow_virt_to_phys(&__get_cpu_var(apf_reason));
 
 #ifdef CONFIG_PREEMPT
 		pa |= KVM_ASYNC_PF_SEND_ALWAYS;
@@ -332,7 +332,8 @@ void __cpuinit kvm_guest_cpu_init(void)
 		/* Size alignment is implied but just to make it explicit. */
 		BUILD_BUG_ON(__alignof__(kvm_apic_eoi) < 4);
 		__get_cpu_var(kvm_apic_eoi) = 0;
-		pa = __pa(&__get_cpu_var(kvm_apic_eoi)) | KVM_MSR_ENABLED;
+		pa = slow_virt_to_phys(&__get_cpu_var(kvm_apic_eoi))
+			| KVM_MSR_ENABLED;
 		wrmsrl(MSR_KVM_PV_EOI_EN, pa);
 	}
 
diff -puN arch/x86/kernel/kvmclock.c~fix-kvm-__pa-use-on-percpu-areas arch/x86/kernel/kvmclock.c
--- linux-2.6.git/arch/x86/kernel/kvmclock.c~fix-kvm-__pa-use-on-percpu-areas	2013-01-09 13:55:44.218672043 -0500
+++ linux-2.6.git-dave/arch/x86/kernel/kvmclock.c	2013-01-09 13:55:44.222672079 -0500
@@ -162,8 +162,8 @@ int kvm_register_clock(char *txt)
 	int low, high, ret;
 	struct pvclock_vcpu_time_info *src = &hv_clock[cpu].pvti;
 
-	low = (int)__pa(src) | 1;
-	high = ((u64)__pa(src) >> 32);
+	low = (int)slow_virt_to_phys(src) | 1;
+	high = ((u64)slow_virt_to_phys(src) >> 32);
 	ret = native_write_msr_safe(msr_kvm_system_time, low, high);
 	printk(KERN_INFO "kvm-clock: cpu %d, msr %x:%x, %s\n",
 	       cpu, high, low, txt);
_

