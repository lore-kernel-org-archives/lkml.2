Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933817Ab2GDKET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 06:04:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:43022 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933123Ab2GDKEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 06:04:15 -0400
X-IronPort-AV: E=Sophos;i="4.77,522,1336320000"; 
   d="scan'208";a="5328186"
Message-ID: <4FF4145D.6090202@cn.fujitsu.com>
Date: Wed, 04 Jul 2012 18:01:01 +0800
From: Yanfei Zhang <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com
CC: ebiederm@xmission.com, luto@mit.edu, Joerg Roedel <joerg.roedel@amd.com>,
        dzickus@redhat.com, paul.gortmaker@windriver.com,
        ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH v4 1/3] KVM: Export symbols for module vmcsinfo-intel
References: <4FF413D2.4030006@cn.fujitsu.com>
In-Reply-To: <4FF413D2.4030006@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/04 18:04:11,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/04 18:04:15,
	Serialize complete at 2012/07/04 18:04:15
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
 arch/x86/include/asm/vmx.h |   73 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx.c         |   81 +++++++-------------------------------------
 include/linux/kvm_host.h   |    3 ++
 virt/kvm/kvm_main.c        |    8 ++--
 4 files changed, 93 insertions(+), 72 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 31f180c..1044e2e 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -26,6 +26,7 @@
  */
 
 #include <linux/types.h>
+#include <linux/kvm_host.h>
 
 /*
  * Definitions of Primary Processor-Based VM-Execution Controls.
@@ -481,4 +482,76 @@ enum vm_instruction_error_number {
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
+DECLARE_PER_CPU(struct vmcs *, current_vmcs);
+
+enum vmcs_field_type {
+	VMCS_FIELD_TYPE_U16 = 0,
+	VMCS_FIELD_TYPE_U64 = 1,
+	VMCS_FIELD_TYPE_U32 = 2,
+	VMCS_FIELD_TYPE_NATURAL_WIDTH = 3
+};
+
+static inline int vmcs_field_type(unsigned long field)
+{
+	if (0x1 & field)	/* the *_HIGH fields are all 32 bit */
+		return VMCS_FIELD_TYPE_U32;
+	return (field >> 13) & 0x3 ;
+}
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
+struct vmcs *alloc_vmcs(void);
+void vmcs_load(struct vmcs *);
+void vmcs_clear(struct vmcs *);
+void free_vmcs(struct vmcs *);
+
 #endif
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 32eb588..43ceae7 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -20,7 +20,6 @@
 #include "mmu.h"
 #include "cpuid.h"
 
-#include <linux/kvm_host.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
@@ -45,10 +44,6 @@
 
 #include "trace.h"
 
-#define __ex(x) __kvm_handle_fault_on_reboot(x)
-#define __ex_clear(x, reg) \
-	____kvm_handle_fault_on_reboot(x, "xor " reg " , " reg)
-
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
@@ -127,12 +122,6 @@ module_param(ple_window, int, S_IRUGO);
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
@@ -617,7 +606,9 @@ static void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3);
 static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr);
 
 static DEFINE_PER_CPU(struct vmcs *, vmxarea);
-static DEFINE_PER_CPU(struct vmcs *, current_vmcs);
+DEFINE_PER_CPU(struct vmcs *, current_vmcs);
+EXPORT_SYMBOL_GPL(current_vmcs);
+
 /*
  * We maintain a per-CPU linked-list of VMCS loaded on that CPU. This is needed
  * when a CPU is brought down, and we need to VMCLEAR all VMCSs loaded on it.
@@ -636,16 +627,8 @@ static bool cpu_has_load_perf_global_ctrl;
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
@@ -940,7 +923,7 @@ static struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr)
 	return NULL;
 }
 
-static void vmcs_clear(struct vmcs *vmcs)
+void vmcs_clear(struct vmcs *vmcs)
 {
 	u64 phys_addr = __pa(vmcs);
 	u8 error;
@@ -952,6 +935,7 @@ static void vmcs_clear(struct vmcs *vmcs)
 		printk(KERN_ERR "kvm: vmclear fail: %p/%llx\n",
 		       vmcs, phys_addr);
 }
+EXPORT_SYMBOL_GPL(vmcs_clear);
 
 static inline void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs)
 {
@@ -960,7 +944,7 @@ static inline void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs)
 	loaded_vmcs->launched = 0;
 }
 
-static void vmcs_load(struct vmcs *vmcs)
+void vmcs_load(struct vmcs *vmcs)
 {
 	u64 phys_addr = __pa(vmcs);
 	u8 error;
@@ -972,6 +956,7 @@ static void vmcs_load(struct vmcs *vmcs)
 		printk(KERN_ERR "kvm: vmptrld %p/%llx failed\n",
 		       vmcs, phys_addr);
 }
+EXPORT_SYMBOL_GPL(vmcs_load);
 
 static void __loaded_vmcs_clear(void *arg)
 {
@@ -1043,34 +1028,6 @@ static inline void ept_sync_individual_addr(u64 eptp, gpa_t gpa)
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
@@ -2580,15 +2537,17 @@ static struct vmcs *alloc_vmcs_cpu(int cpu)
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
@@ -5314,20 +5273,6 @@ static int handle_vmresume(struct kvm_vcpu *vcpu)
 	return nested_vmx_run(vcpu, false);
 }
 
-enum vmcs_field_type {
-	VMCS_FIELD_TYPE_U16 = 0,
-	VMCS_FIELD_TYPE_U64 = 1,
-	VMCS_FIELD_TYPE_U32 = 2,
-	VMCS_FIELD_TYPE_NATURAL_WIDTH = 3
-};
-
-static inline int vmcs_field_type(unsigned long field)
-{
-	if (0x1 & field)	/* the *_HIGH fields are all 32 bit */
-		return VMCS_FIELD_TYPE_U32;
-	return (field >> 13) & 0x3 ;
-}
-
 static inline int vmcs_field_readonly(unsigned long field)
 {
 	return (((field >> 10) & 0x3) == 1);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c446435..0930fd9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -95,6 +95,9 @@ enum kvm_bus {
 	KVM_NR_BUSES
 };
 
+int hardware_enable_all(void);
+void hardware_disable_all(void);
+
 int kvm_io_bus_write(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 		     int len, const void *val);
 int kvm_io_bus_read(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr, int len,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7e14068..26fd04d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -90,8 +90,6 @@ static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
 static long kvm_vcpu_compat_ioctl(struct file *file, unsigned int ioctl,
 				  unsigned long arg);
 #endif
-static int hardware_enable_all(void);
-static void hardware_disable_all(void);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 
@@ -2330,14 +2328,15 @@ static void hardware_disable_all_nolock(void)
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
 
@@ -2358,6 +2357,7 @@ static int hardware_enable_all(void)
 
 	return r;
 }
+EXPORT_SYMBOL_GPL(hardware_enable_all);
 
 static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
 			   void *v)
-- 
1.7.1
