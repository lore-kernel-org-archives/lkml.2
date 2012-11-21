Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab2KUC2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:28:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:40599 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753845Ab2KUC20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 21:28:26 -0500
X-IronPort-AV: E=Sophos;i="4.83,290,1352044800"; 
   d="scan'208";a="6242751"
Message-ID: <50AC3BDB.5070007@cn.fujitsu.com>
Date: Wed, 21 Nov 2012 10:26:35 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [PATCH v5 2/2] KVM-INTEL: add a notifier and a bitmap to support
 VMCLEAR in kdump
References: <50AC3AA9.7080004@cn.fujitsu.com>
In-Reply-To: <50AC3AA9.7080004@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/21 10:28:09,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/21 10:28:09,
	Serialize complete at 2012/11/21 10:28:09
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The notifier will be registered in crash_notifier_list when loading
kvm-intel module. And the bitmap indicates whether we should do
VMCLEAR operation in kdump. The bits in the bitmap are set/unset
according to different conditions.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 arch/x86/kvm/vmx.c |   85 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 4ff0ab9..3bbdd75 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -41,6 +41,7 @@
 #include <asm/i387.h>
 #include <asm/xcr.h>
 #include <asm/perf_event.h>
+#include <asm/kexec.h>
 
 #include "trace.h"
 
@@ -963,6 +964,30 @@ static void vmcs_load(struct vmcs *vmcs)
 		       vmcs, phys_addr);
 }
 
+#ifdef CONFIG_KEXEC
+/*
+ * This bitmap is used to indicate whether the vmclear
+ * operation is enabled on all cpus. All disabled by
+ * default.
+ */
+static cpumask_t crash_vmclear_enabled_bitmap = CPU_MASK_NONE;
+
+static inline void crash_enable_local_vmclear(int cpu)
+{
+	cpumask_set_cpu(cpu, &crash_vmclear_enabled_bitmap);
+}
+
+static inline void crash_disable_local_vmclear(int cpu)
+{
+	cpumask_clear_cpu(cpu, &crash_vmclear_enabled_bitmap);
+}
+
+static inline int crash_local_vmclear_enabled(int cpu)
+{
+	return cpumask_test_cpu(cpu, &crash_vmclear_enabled_bitmap);
+}
+#endif
+
 static void __loaded_vmcs_clear(void *arg)
 {
 	struct loaded_vmcs *loaded_vmcs = arg;
@@ -972,8 +997,14 @@ static void __loaded_vmcs_clear(void *arg)
 		return; /* vcpu migration can race with cpu offline */
 	if (per_cpu(current_vmcs, cpu) == loaded_vmcs->vmcs)
 		per_cpu(current_vmcs, cpu) = NULL;
+#ifdef CONFIG_KEXEC
+	crash_disable_local_vmclear(cpu);
+#endif
 	list_del(&loaded_vmcs->loaded_vmcss_on_cpu_link);
 	loaded_vmcs_init(loaded_vmcs);
+#ifdef CONFIG_KEXEC
+	crash_enable_local_vmclear(cpu);
+#endif
 }
 
 static void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs)
@@ -1491,8 +1522,14 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
 		local_irq_disable();
+#ifdef CONFIG_KEXEC
+		crash_disable_local_vmclear(cpu);
+#endif
 		list_add(&vmx->loaded_vmcs->loaded_vmcss_on_cpu_link,
 			 &per_cpu(loaded_vmcss_on_cpu, cpu));
+#ifdef CONFIG_KEXEC
+		crash_enable_local_vmclear(cpu);
+#endif
 		local_irq_enable();
 
 		/*
@@ -2302,6 +2339,20 @@ static int hardware_enable(void *garbage)
 		return -EBUSY;
 
 	INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
+
+#ifdef CONFIG_KEXEC
+	/*
+	 * Now we can enable the vmclear operation in kdump
+	 * since the loaded_vmcss_on_cpu list on this cpu
+	 * has been initialized.
+	 *
+	 * Though the cpu is not in VMX operation now, there
+	 * is no problem to enable the vmclear operation
+	 * for the loaded_vmcss_on_cpu list is empty!
+	 */
+	crash_enable_local_vmclear(cpu);
+#endif
+
 	rdmsrl(MSR_IA32_FEATURE_CONTROL, old);
 
 	test_bits = FEATURE_CONTROL_LOCKED;
@@ -2335,6 +2386,22 @@ static void vmclear_local_loaded_vmcss(void)
 		__loaded_vmcs_clear(v);
 }
 
+#ifdef CONFIG_KEXEC
+static int crash_vmclear_local_loaded_vmcss(struct notifier_block *this,
+					    unsigned long val, void *ptr)
+{
+	int cpu = raw_smp_processor_id();
+
+	if (crash_local_vmclear_enabled(cpu))
+		vmclear_local_loaded_vmcss();
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block crash_vmclear_notifier = {
+	.notifier_call = crash_vmclear_local_loaded_vmcss,
+};
+#endif
 
 /* Just like cpu_vmxoff(), but with the __kvm_handle_fault_on_reboot()
  * tricks.
@@ -2348,6 +2415,14 @@ static void hardware_disable(void *garbage)
 {
 	if (vmm_exclusive) {
 		vmclear_local_loaded_vmcss();
+#ifdef CONFIG_KEXEC
+		/*
+		 * vmclear operation in kdump should be disabled here
+		 * because the cpu is going to exit VMX operation
+		 * and the loaded_vmcss_on_cpu list may not be empty!
+		 */
+		crash_disable_local_vmclear(raw_smp_processor_id());
+#endif
 		kvm_cpu_vmxoff();
 	}
 	write_cr4(read_cr4() & ~X86_CR4_VMXE);
@@ -7230,6 +7305,11 @@ static int __init vmx_init(void)
 	if (r)
 		goto out3;
 
+#ifdef CONFIG_KEXEC
+	atomic_notifier_chain_register(&crash_notifier_list,
+				       &crash_vmclear_notifier);
+#endif
+
 	vmx_disable_intercept_for_msr(MSR_FS_BASE, false);
 	vmx_disable_intercept_for_msr(MSR_GS_BASE, false);
 	vmx_disable_intercept_for_msr(MSR_KERNEL_GS_BASE, true);
@@ -7265,6 +7345,11 @@ static void __exit vmx_exit(void)
 	free_page((unsigned long)vmx_io_bitmap_b);
 	free_page((unsigned long)vmx_io_bitmap_a);
 
+#ifdef CONFIG_KEXEC
+	atomic_notifier_chain_unregister(&crash_notifier_list,
+					 &crash_vmclear_notifier);
+#endif
+
 	kvm_exit();
 }
 
-- 
1.7.1

