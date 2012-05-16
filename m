Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627Ab2EPHza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:55:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:33293 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab2EPHz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:55:27 -0400
X-IronPort-AV: E=Sophos;i="4.75,602,1330876800"; 
   d="scan'208";a="4967682"
Message-ID: <4FB35D1F.8020703@cn.fujitsu.com>
Date: Wed, 16 May 2012 15:54:07 +0800
From: zhangyanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com
CC: ebiederm@xmission.com, luto@mit.edu, Joerg Roedel <joerg.roedel@amd.com>,
        dzickus@redhat.com, paul.gortmaker@windriver.com,
        ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH v2 2/5] KVM: Export symbols for module vmcsinfo-intel
References: <4FB35C48.30708@cn.fujitsu.com>
In-Reply-To: <4FB35C48.30708@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/16 15:54:10,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/16 15:54:14,
	Serialize complete at 2012/05/16 15:54:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new module named vmcsinfo-intel is used to fill VMCSINFO. And
this module depends on kvm-intel and kvm module. So we should
export some symbols of kvm-intel and kvm module that are needed
by vmcsinfo-intel.

Signed-off-by: zhangyanfei <zhangyanfei@cn.fujitsu.com>
---
 arch/x86/include/asm/vmx.h |  133 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx.c         |  151 +++++++-------------------------------------
 include/linux/kvm_host.h   |    3 +
 virt/kvm/kvm_main.c        |    8 +-
 4 files changed, 164 insertions(+), 131 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 31f180c..f5b7134 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -27,6 +27,8 @@
 
 #include <linux/types.h>
 
+#include <asm/kvm_host.h>
+
 /*
  * Definitions of Primary Processor-Based VM-Execution Controls.
  */
@@ -481,4 +483,135 @@ enum vm_instruction_error_number {
 	VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID = 28,
 };
 
+#define __ex(x) __kvm_handle_fault_on_reboot(x)
+#define __ex_clear(x, reg) \
+	____kvm_handle_fault_on_reboot(x, "xor " reg " , " reg)
+
+struct vmcs {
+	u32 revision_id;
+	u32 abort;
+	char data[0];
+};
+
+struct vmcs_config {
+	int size;
+	int order;
+	u32 revision_id;
+	u32 pin_based_exec_ctrl;
+	u32 cpu_based_exec_ctrl;
+	u32 cpu_based_2nd_exec_ctrl;
+	u32 vmexit_ctrl;
+	u32 vmentry_ctrl;
+};
+
+extern struct vmcs_config vmcs_config;
+
+DECLARE_PER_CPU(struct vmcs *, vmxarea);
+DECLARE_PER_CPU(struct vmcs *, current_vmcs);
+
+struct vmcs *alloc_vmcs(void);
+void kvm_cpu_vmxon(u64);
+void kvm_cpu_vmxoff(void);
+void vmcs_load(struct vmcs *);
+void vmcs_write_control_field(unsigned long, u32);
+void vmcs_clear(struct vmcs *);
+void free_vmcs(struct vmcs *);
+
+static __always_inline unsigned long vmcs_readl(unsigned long field)
+{
+	unsigned long value;
+
+	asm volatile (__ex_clear(ASM_VMX_VMREAD_RDX_RAX, "%0")
+		      : "=a"(value) : "d"(field) : "cc");
+	return value;
+}
+
+static __always_inline u16 vmcs_read16(unsigned long field)
+{
+	return vmcs_readl(field);
+}
+
+static __always_inline u32 vmcs_read32(unsigned long field)
+{
+	return vmcs_readl(field);
+}
+
+static __always_inline u64 vmcs_read64(unsigned long field)
+{
+#ifdef CONFIG_X86_64
+	return vmcs_readl(field);
+#else
+	return vmcs_readl(field) | ((u64)vmcs_readl(field+1) << 32);
+#endif
+}
+
+static inline bool cpu_has_vmx_msr_bitmap(void)
+{
+	return vmcs_config.cpu_based_exec_ctrl & CPU_BASED_USE_MSR_BITMAPS;
+}
+
+static inline bool cpu_has_vmx_tpr_shadow(void)
+{
+	return vmcs_config.cpu_based_exec_ctrl & CPU_BASED_TPR_SHADOW;
+}
+
+static inline bool cpu_has_secondary_exec_ctrls(void)
+{
+	return vmcs_config.cpu_based_exec_ctrl &
+		CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
+}
+
+static inline bool cpu_has_vmx_virtualize_apic_accesses(void)
+{
+	return vmcs_config.cpu_based_2nd_exec_ctrl &
+		SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
+}
+
+static inline bool cpu_has_vmx_flexpriority(void)
+{
+	return cpu_has_vmx_tpr_shadow() &&
+		cpu_has_vmx_virtualize_apic_accesses();
+}
+
+static inline bool cpu_has_vmx_ept(void)
+{
+	return vmcs_config.cpu_based_2nd_exec_ctrl &
+		SECONDARY_EXEC_ENABLE_EPT;
+}
+
+static inline bool cpu_has_vmx_unrestricted_guest(void)
+{
+	return vmcs_config.cpu_based_2nd_exec_ctrl &
+		SECONDARY_EXEC_UNRESTRICTED_GUEST;
+}
+
+static inline bool cpu_has_vmx_ple(void)
+{
+	return vmcs_config.cpu_based_2nd_exec_ctrl &
+		SECONDARY_EXEC_PAUSE_LOOP_EXITING;
+}
+
+static inline bool cpu_has_vmx_vpid(void)
+{
+	return vmcs_config.cpu_based_2nd_exec_ctrl &
+		SECONDARY_EXEC_ENABLE_VPID;
+}
+
+static inline bool cpu_has_vmx_rdtscp(void)
+{
+	return vmcs_config.cpu_based_2nd_exec_ctrl &
+		SECONDARY_EXEC_RDTSCP;
+}
+
+static inline bool cpu_has_virtual_nmis(void)
+{
+	return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS;
+}
+
+static inline bool cpu_has_vmx_wbinvd_exit(void)
+{
+	return vmcs_config.cpu_based_2nd_exec_ctrl &
+		SECONDARY_EXEC_WBINVD_EXITING;
+}
+
 #endif
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index ad85adf..3391c92 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -44,10 +44,6 @@
 
 #include "trace.h"
 
-#define __ex(x) __kvm_handle_fault_on_reboot(x)
-#define __ex_clear(x, reg) \
-	____kvm_handle_fault_on_reboot(x, "xor " reg " , " reg)
-
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
@@ -120,12 +116,6 @@ module_param(ple_window, int, S_IRUGO);
 #define NR_AUTOLOAD_MSRS 8
 #define VMCS02_POOL_SIZE 1
 
-struct vmcs {
-	u32 revision_id;
-	u32 abort;
-	char data[0];
-};
-
 /*
  * Track a VMCS that may be loaded on a certain CPU. If it is (cpu!=-1), also
  * remember whether it was VMLAUNCHed, and maintain a linked list of all VMCSs
@@ -601,13 +591,13 @@ static void nested_release_page_clean(struct page *page)
 }
 
 static u64 construct_eptp(unsigned long root_hpa);
-static void kvm_cpu_vmxon(u64 addr);
-static void kvm_cpu_vmxoff(void);
 static void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3);
 static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr);
 
-static DEFINE_PER_CPU(struct vmcs *, vmxarea);
-static DEFINE_PER_CPU(struct vmcs *, current_vmcs);
+DEFINE_PER_CPU(struct vmcs *, vmxarea);
+EXPORT_PER_CPU_SYMBOL_GPL(vmxarea);
+DEFINE_PER_CPU(struct vmcs *, current_vmcs);
+EXPORT_PER_CPU_SYMBOL_GPL(current_vmcs);
 /*
  * We maintain a per-CPU linked-list of VMCS loaded on that CPU. This is needed
  * when a CPU is brought down, and we need to VMCLEAR all VMCSs loaded on it.
@@ -626,16 +616,8 @@ static bool cpu_has_load_perf_global_ctrl;
 static DECLARE_BITMAP(vmx_vpid_bitmap, VMX_NR_VPIDS);
 static DEFINE_SPINLOCK(vmx_vpid_lock);
 
-static struct vmcs_config {
-	int size;
-	int order;
-	u32 revision_id;
-	u32 pin_based_exec_ctrl;
-	u32 cpu_based_exec_ctrl;
-	u32 cpu_based_2nd_exec_ctrl;
-	u32 vmexit_ctrl;
-	u32 vmentry_ctrl;
-} vmcs_config;
+struct vmcs_config vmcs_config;
+EXPORT_SYMBOL_GPL(vmcs_config);
 
 static struct vmx_capability {
 	u32 ept;
@@ -716,39 +698,11 @@ static inline bool is_machine_check(u32 intr_info)
 		(INTR_TYPE_HARD_EXCEPTION | MC_VECTOR | INTR_INFO_VALID_MASK);
 }
 
-static inline bool cpu_has_vmx_msr_bitmap(void)
-{
-	return vmcs_config.cpu_based_exec_ctrl & CPU_BASED_USE_MSR_BITMAPS;
-}
-
-static inline bool cpu_has_vmx_tpr_shadow(void)
-{
-	return vmcs_config.cpu_based_exec_ctrl & CPU_BASED_TPR_SHADOW;
-}
-
 static inline bool vm_need_tpr_shadow(struct kvm *kvm)
 {
 	return (cpu_has_vmx_tpr_shadow()) && (irqchip_in_kernel(kvm));
 }
 
-static inline bool cpu_has_secondary_exec_ctrls(void)
-{
-	return vmcs_config.cpu_based_exec_ctrl &
-		CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
-}
-
-static inline bool cpu_has_vmx_virtualize_apic_accesses(void)
-{
-	return vmcs_config.cpu_based_2nd_exec_ctrl &
-		SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
-}
-
-static inline bool cpu_has_vmx_flexpriority(void)
-{
-	return cpu_has_vmx_tpr_shadow() &&
-		cpu_has_vmx_virtualize_apic_accesses();
-}
-
 static inline bool cpu_has_vmx_ept_execute_only(void)
 {
 	return vmx_capability.ept & VMX_EPT_EXECUTE_ONLY_BIT;
@@ -804,52 +758,11 @@ static inline bool cpu_has_vmx_invvpid_global(void)
 	return vmx_capability.vpid & VMX_VPID_EXTENT_GLOBAL_CONTEXT_BIT;
 }
 
-static inline bool cpu_has_vmx_ept(void)
-{
-	return vmcs_config.cpu_based_2nd_exec_ctrl &
-		SECONDARY_EXEC_ENABLE_EPT;
-}
-
-static inline bool cpu_has_vmx_unrestricted_guest(void)
-{
-	return vmcs_config.cpu_based_2nd_exec_ctrl &
-		SECONDARY_EXEC_UNRESTRICTED_GUEST;
-}
-
-static inline bool cpu_has_vmx_ple(void)
-{
-	return vmcs_config.cpu_based_2nd_exec_ctrl &
-		SECONDARY_EXEC_PAUSE_LOOP_EXITING;
-}
-
 static inline bool vm_need_virtualize_apic_accesses(struct kvm *kvm)
 {
 	return flexpriority_enabled && irqchip_in_kernel(kvm);
 }
 
-static inline bool cpu_has_vmx_vpid(void)
-{
-	return vmcs_config.cpu_based_2nd_exec_ctrl &
-		SECONDARY_EXEC_ENABLE_VPID;
-}
-
-static inline bool cpu_has_vmx_rdtscp(void)
-{
-	return vmcs_config.cpu_based_2nd_exec_ctrl &
-		SECONDARY_EXEC_RDTSCP;
-}
-
-static inline bool cpu_has_virtual_nmis(void)
-{
-	return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS;
-}
-
-static inline bool cpu_has_vmx_wbinvd_exit(void)
-{
-	return vmcs_config.cpu_based_2nd_exec_ctrl &
-		SECONDARY_EXEC_WBINVD_EXITING;
-}
-
 static inline bool report_flexpriority(void)
 {
 	return flexpriority_enabled;
@@ -930,7 +843,7 @@ static struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr)
 	return NULL;
 }
 
-static void vmcs_clear(struct vmcs *vmcs)
+void vmcs_clear(struct vmcs *vmcs)
 {
 	u64 phys_addr = __pa(vmcs);
 	u8 error;
@@ -942,6 +855,7 @@ static void vmcs_clear(struct vmcs *vmcs)
 		printk(KERN_ERR "kvm: vmclear fail: %p/%llx\n",
 		       vmcs, phys_addr);
 }
+EXPORT_SYMBOL_GPL(vmcs_clear);
 
 static inline void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs)
 {
@@ -950,7 +864,7 @@ static inline void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs)
 	loaded_vmcs->launched = 0;
 }
 
-static void vmcs_load(struct vmcs *vmcs)
+void vmcs_load(struct vmcs *vmcs)
 {
 	u64 phys_addr = __pa(vmcs);
 	u8 error;
@@ -962,6 +876,7 @@ static void vmcs_load(struct vmcs *vmcs)
 		printk(KERN_ERR "kvm: vmptrld %p/%llx failed\n",
 		       vmcs, phys_addr);
 }
+EXPORT_SYMBOL_GPL(vmcs_load);
 
 static void __loaded_vmcs_clear(void *arg)
 {
@@ -1033,34 +948,6 @@ static inline void ept_sync_individual_addr(u64 eptp, gpa_t gpa)
 	}
 }
 
-static __always_inline unsigned long vmcs_readl(unsigned long field)
-{
-	unsigned long value;
-
-	asm volatile (__ex_clear(ASM_VMX_VMREAD_RDX_RAX, "%0")
-		      : "=a"(value) : "d"(field) : "cc");
-	return value;
-}
-
-static __always_inline u16 vmcs_read16(unsigned long field)
-{
-	return vmcs_readl(field);
-}
-
-static __always_inline u32 vmcs_read32(unsigned long field)
-{
-	return vmcs_readl(field);
-}
-
-static __always_inline u64 vmcs_read64(unsigned long field)
-{
-#ifdef CONFIG_X86_64
-	return vmcs_readl(field);
-#else
-	return vmcs_readl(field) | ((u64)vmcs_readl(field+1) << 32);
-#endif
-}
-
 static noinline void vmwrite_error(unsigned long field, unsigned long value)
 {
 	printk(KERN_ERR "vmwrite error: reg %lx value %lx (err %d)\n",
@@ -1097,6 +984,12 @@ static void vmcs_write64(unsigned long field, u64 value)
 #endif
 }
 
+void vmcs_write_control_field(unsigned long field, u32 value)
+{
+	vmcs_writel(field, value);
+}
+EXPORT_SYMBOL_GPL(vmcs_write_control_field);
+
 static void vmcs_clear_bits(unsigned long field, u32 mask)
 {
 	vmcs_writel(field, vmcs_readl(field) & ~mask);
@@ -2282,12 +2175,13 @@ static __init int vmx_disabled_by_bios(void)
 	return 0;
 }
 
-static void kvm_cpu_vmxon(u64 addr)
+void kvm_cpu_vmxon(u64 addr)
 {
 	asm volatile (ASM_VMX_VMXON_RAX
 			: : "a"(&addr), "m"(addr)
 			: "memory", "cc");
 }
+EXPORT_SYMBOL_GPL(kvm_cpu_vmxon);
 
 static int hardware_enable(void *garbage)
 {
@@ -2336,10 +2230,11 @@ static void vmclear_local_loaded_vmcss(void)
 /* Just like cpu_vmxoff(), but with the __kvm_handle_fault_on_reboot()
  * tricks.
  */
-static void kvm_cpu_vmxoff(void)
+void kvm_cpu_vmxoff(void)
 {
 	asm volatile (__ex(ASM_VMX_VMXOFF) : : : "cc");
 }
+EXPORT_SYMBOL_GPL(kvm_cpu_vmxoff);
 
 static void hardware_disable(void *garbage)
 {
@@ -2549,15 +2444,17 @@ static struct vmcs *alloc_vmcs_cpu(int cpu)
 	return vmcs;
 }
 
-static struct vmcs *alloc_vmcs(void)
+struct vmcs *alloc_vmcs(void)
 {
 	return alloc_vmcs_cpu(raw_smp_processor_id());
 }
+EXPORT_SYMBOL_GPL(alloc_vmcs);
 
-static void free_vmcs(struct vmcs *vmcs)
+void free_vmcs(struct vmcs *vmcs)
 {
 	free_pages((unsigned long)vmcs, vmcs_config.order);
 }
+EXPORT_SYMBOL_GPL(free_vmcs);
 
 /*
  * Free a VMCS, but before that VMCLEAR it on the CPU where it was last loaded
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 72cbf08..d76e2b0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -80,6 +80,9 @@ enum kvm_bus {
 	KVM_NR_BUSES
 };
 
+int hardware_enable_all(void);
+void hardware_disable_all(void);
+
 int kvm_io_bus_write(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 		     int len, const void *val);
 int kvm_io_bus_read(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr, int len,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9739b53..3130e76 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -90,8 +90,6 @@ static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
 static long kvm_vcpu_compat_ioctl(struct file *file, unsigned int ioctl,
 				  unsigned long arg);
 #endif
-static int hardware_enable_all(void);
-static void hardware_disable_all(void);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 
@@ -2286,14 +2284,15 @@ static void hardware_disable_all_nolock(void)
 		on_each_cpu(hardware_disable_nolock, NULL, 1);
 }
 
-static void hardware_disable_all(void)
+void hardware_disable_all(void)
 {
 	raw_spin_lock(&kvm_lock);
 	hardware_disable_all_nolock();
 	raw_spin_unlock(&kvm_lock);
 }
+EXPORT_SYMBOL_GPL(hardware_disable_all);
 
-static int hardware_enable_all(void)
+int hardware_enable_all(void)
 {
 	int r = 0;
 
@@ -2314,6 +2313,7 @@ static int hardware_enable_all(void)
 
 	return r;
 }
+EXPORT_SYMBOL_GPL(hardware_enable_all);
 
 static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
 			   void *v)
-- 
1.7.1
