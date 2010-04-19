Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab0DSFd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 01:33:29 -0400
Received: from mga05.intel.com ([192.55.52.89]:27062 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751813Ab0DSFdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 01:33:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,234,1270450800"; 
   d="scan'208";a="559193567"
Subject: [PATCH V5 2/3] perf & kvm: Enhance perf to collect KVM guest os
 statistics from host side
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Avi Kivity <avi@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com, Arnaldo Carvalho de Melo <acme@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 19 Apr 2010 13:32:45 +0800
Message-Id: <1271655165.2078.604.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below patch implements the perf_guest_info_callbacks on kvm.

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

---

diff -Nraup linux-2.6_tip0417/arch/x86/kvm/vmx.c linux-2.6_tip0417_perfkvm/arch/x86/kvm/vmx.c
--- linux-2.6_tip0417/arch/x86/kvm/vmx.c	2010-04-19 09:51:47.908673911 +0800
+++ linux-2.6_tip0417_perfkvm/arch/x86/kvm/vmx.c	2010-04-19 09:53:59.690399987 +0800
@@ -3654,8 +3654,11 @@ static void vmx_complete_interrupts(stru
 
 	/* We need to handle NMIs before interrupts are enabled */
 	if ((exit_intr_info & INTR_INFO_INTR_TYPE_MASK) == INTR_TYPE_NMI_INTR &&
-	    (exit_intr_info & INTR_INFO_VALID_MASK))
+	    (exit_intr_info & INTR_INFO_VALID_MASK)) {
+		kvm_before_handle_nmi(&vmx->vcpu);
 		asm("int $2");
+		kvm_after_handle_nmi(&vmx->vcpu);
+	}
 
 	idtv_info_valid = idt_vectoring_info & VECTORING_INFO_VALID_MASK;
 
diff -Nraup linux-2.6_tip0417/arch/x86/kvm/x86.c linux-2.6_tip0417_perfkvm/arch/x86/kvm/x86.c
--- linux-2.6_tip0417/arch/x86/kvm/x86.c	2010-04-19 09:51:47.892676413 +0800
+++ linux-2.6_tip0417_perfkvm/arch/x86/kvm/x86.c	2010-04-19 09:53:59.691378953 +0800
@@ -40,6 +40,7 @@
 #include <linux/user-return-notifier.h>
 #include <linux/srcu.h>
 #include <linux/slab.h>
+#include <linux/perf_event.h>
 #include <trace/events/kvm.h>
 #undef TRACE_INCLUDE_FILE
 #define CREATE_TRACE_POINTS
@@ -3765,6 +3766,47 @@ static void kvm_timer_init(void)
 	}
 }
 
+static DEFINE_PER_CPU(struct kvm_vcpu *, current_vcpu);
+
+static int kvm_is_in_guest(void)
+{
+	return percpu_read(current_vcpu) != NULL;
+}
+
+static int kvm_is_user_mode(void)
+{
+	int user_mode = 3;
+	if (percpu_read(current_vcpu))
+		user_mode = kvm_x86_ops->get_cpl(percpu_read(current_vcpu));
+	return user_mode != 0;
+}
+
+static unsigned long kvm_get_guest_ip(void)
+{
+	unsigned long ip = 0;
+	if (percpu_read(current_vcpu))
+		ip = kvm_rip_read(percpu_read(current_vcpu));
+	return ip;
+}
+
+static struct perf_guest_info_callbacks kvm_guest_cbs = {
+	.is_in_guest		= kvm_is_in_guest,
+	.is_user_mode		= kvm_is_user_mode,
+	.get_guest_ip		= kvm_get_guest_ip,
+};
+
+void kvm_before_handle_nmi(struct kvm_vcpu *vcpu)
+{
+	percpu_write(current_vcpu, vcpu);
+}
+EXPORT_SYMBOL_GPL(kvm_before_handle_nmi);
+
+void kvm_after_handle_nmi(struct kvm_vcpu *vcpu)
+{
+	percpu_write(current_vcpu, NULL);
+}
+EXPORT_SYMBOL_GPL(kvm_after_handle_nmi);
+
 int kvm_arch_init(void *opaque)
 {
 	int r;
@@ -3801,6 +3843,8 @@ int kvm_arch_init(void *opaque)
 
 	kvm_timer_init();
 
+	perf_register_guest_info_callbacks(&kvm_guest_cbs);
+
 	return 0;
 
 out:
@@ -3809,6 +3853,8 @@ out:
 
 void kvm_arch_exit(void)
 {
+	perf_unregister_guest_info_callbacks(&kvm_guest_cbs);
+
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
 		cpufreq_unregister_notifier(&kvmclock_cpufreq_notifier_block,
 					    CPUFREQ_TRANSITION_NOTIFIER);
diff -Nraup linux-2.6_tip0417/arch/x86/kvm/x86.h linux-2.6_tip0417_perfkvm/arch/x86/kvm/x86.h
--- linux-2.6_tip0417/arch/x86/kvm/x86.h	2010-04-19 09:51:47.884709050 +0800
+++ linux-2.6_tip0417_perfkvm/arch/x86/kvm/x86.h	2010-04-19 09:53:59.691378953 +0800
@@ -65,4 +65,7 @@ static inline int is_paging(struct kvm_v
 	return kvm_read_cr0_bits(vcpu, X86_CR0_PG);
 }
 
+void kvm_before_handle_nmi(struct kvm_vcpu *vcpu);
+void kvm_after_handle_nmi(struct kvm_vcpu *vcpu);
+
 #endif


