Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423959Ab2LFPnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:43:46 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47839 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423945Ab2LFPnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:43:42 -0500
Message-ID: <50C0BD26.2010408@gmail.com>
Date: Thu, 06 Dec 2012 23:43:34 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
CC: kexec@lists.infradead.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 2/2] KVM-INTEL: provide the vmclear function and a
 bitmap to support VMCLEAR in kdump
References: <50C0BB90.1080804@gmail.com>
In-Reply-To: <50C0BB90.1080804@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

The vmclear function will be assigned to the callback function pointer
when loading kvm-intel module. And the bitmap indicates whether we
should do VMCLEAR operation in kdump. The bits in the bitmap are
set/unset according to different conditions.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 arch/x86/kvm/vmx.c |   67 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 94833e2..1a30fd5 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -42,6 +42,7 @@
 #include <asm/i387.h>
 #include <asm/xcr.h>
 #include <asm/perf_event.h>
+#include <asm/kexec.h>
 
 #include "trace.h"
 
@@ -987,6 +988,46 @@ static void vmcs_load(struct vmcs *vmcs)
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
+
+static void crash_vmclear_local_loaded_vmcss(void)
+{
+	int cpu = raw_smp_processor_id();
+	struct loaded_vmcs *v;
+
+	if (!crash_local_vmclear_enabled(cpu))
+		return;
+
+	list_for_each_entry(v, &per_cpu(loaded_vmcss_on_cpu, cpu),
+			    loaded_vmcss_on_cpu_link)
+		vmcs_clear(v->vmcs);
+}
+#else
+static inline void crash_enable_local_vmclear(int cpu) { }
+static inline void crash_disable_local_vmclear(int cpu) { }
+#endif /* CONFIG_KEXEC */
+
 static void __loaded_vmcs_clear(void *arg)
 {
 	struct loaded_vmcs *loaded_vmcs = arg;
@@ -996,6 +1037,7 @@ static void __loaded_vmcs_clear(void *arg)
 		return; /* vcpu migration can race with cpu offline */
 	if (per_cpu(current_vmcs, cpu) == loaded_vmcs->vmcs)
 		per_cpu(current_vmcs, cpu) = NULL;
+	crash_disable_local_vmclear(cpu);
 	list_del(&loaded_vmcs->loaded_vmcss_on_cpu_link);
 
 	/*
@@ -1007,6 +1049,7 @@ static void __loaded_vmcs_clear(void *arg)
 	smp_wmb();
 
 	loaded_vmcs_init(loaded_vmcs);
+	crash_enable_local_vmclear(cpu);
 }
 
 static void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs)
@@ -1530,6 +1573,7 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
 		local_irq_disable();
+		crash_disable_local_vmclear(cpu);
 
 		/*
 		 * Read loaded_vmcs->cpu should be before fetching
@@ -1540,6 +1584,7 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 		list_add(&vmx->loaded_vmcs->loaded_vmcss_on_cpu_link,
 			 &per_cpu(loaded_vmcss_on_cpu, cpu));
+		crash_enable_local_vmclear(cpu);
 		local_irq_enable();
 
 		/*
@@ -2353,6 +2398,18 @@ static int hardware_enable(void *garbage)
 		return -EBUSY;
 
 	INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
+
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
+
 	rdmsrl(MSR_IA32_FEATURE_CONTROL, old);
 
 	test_bits = FEATURE_CONTROL_LOCKED;
@@ -7383,6 +7440,11 @@ static int __init vmx_init(void)
 	if (r)
 		goto out3;
 
+#ifdef CONFIG_KEXEC
+	rcu_assign_pointer(crash_vmclear_loaded_vmcss,
+			   crash_vmclear_local_loaded_vmcss);
+#endif
+
 	vmx_disable_intercept_for_msr(MSR_FS_BASE, false);
 	vmx_disable_intercept_for_msr(MSR_GS_BASE, false);
 	vmx_disable_intercept_for_msr(MSR_KERNEL_GS_BASE, true);
@@ -7420,6 +7482,11 @@ static void __exit vmx_exit(void)
 	free_page((unsigned long)vmx_io_bitmap_b);
 	free_page((unsigned long)vmx_io_bitmap_a);
 
+#ifdef CONFIG_KEXEC
+	rcu_assign_pointer(crash_vmclear_loaded_vmcss, NULL);
+	synchronize_rcu();
+#endif
+
 	kvm_exit();
 }
 
-- 
1.7.1

