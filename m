Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab2LEIIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 03:08:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:20204 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab2LEIIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 03:08:12 -0500
X-IronPort-AV: E=Sophos;i="4.83,376,1352044800"; 
   d="scan'208";a="6337526"
Message-ID: <50BF0076.10205@cn.fujitsu.com>
Date: Wed, 05 Dec 2012 16:06:14 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
CC: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v10 2/2] KVM-INTEL: provide the vmclear function and a
 bitmap to support VMCLEAR in kdump
References: <50BEFEBA.6070602@cn.fujitsu.com>
In-Reply-To: <50BEFEBA.6070602@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/05 16:07:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/05 16:07:32,
	Serialize complete at 2012/12/05 16:07:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vmclear function will be assigned to the callback function pointer
when loading kvm-intel module. And the bitmap indicates whether we
should do VMCLEAR operation in kdump. The bits in the bitmap are
set/unset according to different conditions.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 arch/x86/kvm/vmx.c |   67 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f858159..2d5226a 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -42,6 +42,7 @@
 #include <asm/i387.h>
 #include <asm/xcr.h>
 #include <asm/perf_event.h>
+#include <asm/kexec.h>
 
 #include "trace.h"
 
@@ -992,6 +993,46 @@ static void vmcs_load(struct vmcs *vmcs)
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
@@ -1001,8 +1042,10 @@ static void __loaded_vmcs_clear(void *arg)
 		return; /* vcpu migration can race with cpu offline */
 	if (per_cpu(current_vmcs, cpu) == loaded_vmcs->vmcs)
 		per_cpu(current_vmcs, cpu) = NULL;
+	crash_disable_local_vmclear(cpu);
 	list_del(&loaded_vmcs->loaded_vmcss_on_cpu_link);
 	loaded_vmcs_init(loaded_vmcs);
+	crash_enable_local_vmclear(cpu);
 }
 
 static void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs)
@@ -1535,8 +1578,10 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
 		local_irq_disable();
+		crash_disable_local_vmclear(cpu);
 		list_add(&vmx->loaded_vmcs->loaded_vmcss_on_cpu_link,
 			 &per_cpu(loaded_vmcss_on_cpu, cpu));
+		crash_enable_local_vmclear(cpu);
 		local_irq_enable();
 
 		/*
@@ -2341,6 +2386,18 @@ static int hardware_enable(void *garbage)
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
@@ -7367,6 +7424,11 @@ static int __init vmx_init(void)
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
@@ -7404,6 +7466,11 @@ static void __exit vmx_exit(void)
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

