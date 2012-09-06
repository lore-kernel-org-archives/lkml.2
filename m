Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab2IFLeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 07:34:01 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:60058 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab2IFLd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 07:33:59 -0400
X-AuditID: b753bd60-969d8ba000000c4c-b7-504889025e1b
X-AuditID: b753bd60-969d8ba000000c4c-b7-504889025e1b
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC v2 PATCH 19/21] KVM: Enable direct EOI for directly routed
 interrupts to guests
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 06 Sep 2012 20:28:59 +0900
Message-ID: <20120906112858.13320.75400.stgit@kvmdev>
In-Reply-To: <20120906112718.13320.8231.stgit@kvmdev>
References: <20120906112718.13320.8231.stgit@kvmdev>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable direct access to EOI MSR of x2apic to accelerate guests.
This accelerate handling of interrupts delivered directly to guest from
passed-through PCI devices. When a virtual IRQ is injected, this feature
is disabled in order to route following EOI to virtual APIC. Then, it is
enabled again after every virtual IRQ is handled.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/kvm/vmx.c |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 39a4cb4..f93e08c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -636,6 +636,10 @@ static unsigned long *vmx_io_bitmap_a;
 static unsigned long *vmx_io_bitmap_b;
 static unsigned long *vmx_msr_bitmap_legacy;
 static unsigned long *vmx_msr_bitmap_longmode;
+#ifdef CONFIG_SLAVE_CPU
+static unsigned long *vmx_msr_bitmap_slave_legacy;
+static unsigned long *vmx_msr_bitmap_slave_longmode;
+#endif
 
 static bool cpu_has_load_ia32_efer;
 static bool cpu_has_load_perf_global_ctrl;
@@ -912,6 +916,11 @@ static void nested_vmx_entry_failure(struct kvm_vcpu *vcpu,
 			struct vmcs12 *vmcs12,
 			u32 reason, unsigned long qualification);
 
+static void vmx_disable_intercept_for_msr(u32 msr, bool longmode_only);
+#ifdef CONFIG_SLAVE_CPU
+static void vmx_disable_intercept_for_msr_slave(u32 msr, bool longmode_only);
+#endif
+
 static int __find_msr_index(struct vcpu_vmx *vmx, u32 msr)
 {
 	int i;
@@ -1716,13 +1725,28 @@ static void vmx_set_direct_interrupt(struct kvm_vcpu *vcpu, bool enabled)
 #ifdef CONFIG_SLAVE_CPU
 	void *msr_bitmap;
 
-	if (enabled)
+	if (enabled) {
 		vmcs_clear_bits(PIN_BASED_VM_EXEC_CONTROL,
 				PIN_BASED_EXT_INTR_MASK);
-	else
+
+		if (cpu_has_vmx_msr_bitmap()) {
+			msr_bitmap = is_long_mode(vcpu) ?
+				vmx_msr_bitmap_slave_longmode :
+				vmx_msr_bitmap_slave_legacy;
+			vmcs_write64(MSR_BITMAP, __pa(msr_bitmap));
+		}
+	} else {
 		vmcs_set_bits(PIN_BASED_VM_EXEC_CONTROL,
 			      PIN_BASED_EXT_INTR_MASK);
 
+		if (cpu_has_vmx_msr_bitmap()) {
+			msr_bitmap = is_long_mode(vcpu) ?
+				vmx_msr_bitmap_longmode :
+				vmx_msr_bitmap_legacy;
+			vmcs_write64(MSR_BITMAP, __pa(msr_bitmap));
+		}
+	}
+
 	trace_kvm_set_direct_interrupt(vcpu, enabled);
 #endif
 }
@@ -3771,6 +3795,16 @@ static void vmx_disable_intercept_for_msr(u32 msr, bool longmode_only)
 	__vmx_disable_intercept_for_msr(vmx_msr_bitmap_longmode, msr);
 }
 
+#ifdef CONFIG_SLAVE_CPU
+static void vmx_disable_intercept_for_msr_slave(u32 msr, bool longmode_only)
+{
+	if (!longmode_only)
+		__vmx_disable_intercept_for_msr(vmx_msr_bitmap_slave_legacy,
+					       msr);
+	__vmx_disable_intercept_for_msr(vmx_msr_bitmap_slave_longmode, msr);
+}
+#endif
+
 /*
  * Set up the vmcs's constant host-state fields, i.e., host-state fields that
  * will not change in the lifetime of the guest.
@@ -7474,6 +7508,22 @@ static int __init vmx_init(void)
 		goto out2;
 
 
+#ifdef CONFIG_SLAVE_CPU
+	vmx_msr_bitmap_slave_legacy =
+		(unsigned long *)__get_free_page(GFP_KERNEL);
+	if (!vmx_msr_bitmap_slave_legacy) {
+		r = -ENOMEM;
+		goto out1s;
+	}
+
+	vmx_msr_bitmap_slave_longmode =
+		(unsigned long *)__get_free_page(GFP_KERNEL);
+	if (!vmx_msr_bitmap_slave_longmode) {
+		r = -ENOMEM;
+		goto out2s;
+	}
+#endif
+
 	/*
 	 * Allow direct access to the PC debug port (it is often used for I/O
 	 * delays, but the vmexits simply slow things down).
@@ -7500,6 +7550,15 @@ static int __init vmx_init(void)
 	vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_ESP, false);
 	vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_EIP, false);
 
+#ifdef CONFIG_SLAVE_CPU
+	memcpy(vmx_msr_bitmap_slave_legacy,
+	       vmx_msr_bitmap_legacy, PAGE_SIZE);
+	memcpy(vmx_msr_bitmap_slave_longmode,
+	       vmx_msr_bitmap_longmode, PAGE_SIZE);
+	vmx_disable_intercept_for_msr_slave(
+		APIC_BASE_MSR + (APIC_EOI >> 4), false);
+#endif
+
 	if (enable_ept) {
 		kvm_mmu_set_mask_ptes(0ull,
 			(enable_ept_ad_bits) ? VMX_EPT_ACCESS_BIT : 0ull,
@@ -7513,6 +7572,12 @@ static int __init vmx_init(void)
 	return 0;
 
 out3:
+#ifdef CONFIG_SLAVE_CPU
+	free_page((unsigned long)vmx_msr_bitmap_slave_longmode);
+out2s:
+	free_page((unsigned long)vmx_msr_bitmap_slave_legacy);
+out1s:
+#endif
 	free_page((unsigned long)vmx_msr_bitmap_longmode);
 out2:
 	free_page((unsigned long)vmx_msr_bitmap_legacy);


