Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996Ab2DKBur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 21:50:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:13027 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754009Ab2DKBup convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 21:50:45 -0400
X-IronPort-AV: E=Sophos;i="4.75,402,1330876800"; 
   d="scan'208";a="4725381"
Message-ID: <4F84E365.10201@cn.fujitsu.com>
Date: Wed, 11 Apr 2012 09:50:29 +0800
From: zhangyanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: avi@redhat.com, mtosatti@redhat.com
CC: ebiederm@xmission.com, luto@mit.edu, joerg.roedel@amd.com,
        dzickus@redhat.com, paul.gortmaker@windriver.com, gregkh@suse.de,
        ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org
Subject: [PATCH 2/4] KVM: VMX: Add functions to fill VMCSINFO
References: <4F84E0DF.8040206@cn.fujitsu.com>
In-Reply-To: <4F84E0DF.8040206@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/11 09:50:07,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/11 09:50:10
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to implement the feature that at initialization of
kvm_intel module, fills VMCSINFO with a VMCS revision identifier,
and encoded offsets of VMCS fields. The reason why we put the
VMCSINFO processing at the initialization of kvm_intel module
is that it's dangerous to rob VMX resources while kvm module is
loaded.

Note, offsets of fields below will not be filled into VMCSINFO:
1. fields defined in Intel specification (Intel® 64 and
   IA-32 Architectures Software Developer’s Manual, Volume
   3C) but not defined in *vmcs_field*.
2. fields don't exist because their corresponding control bits
   are not set.

Signed-off-by: zhangyanfei <zhangyanfei@cn.fujitsu.com>
---
 arch/x86/kvm/vmx.c |  350 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 350 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index ad85adf..e98fafa 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -41,6 +41,7 @@
 #include <asm/i387.h>
 #include <asm/xcr.h>
 #include <asm/perf_event.h>
+#include <asm/vmcsinfo.h>
 
 #include "trace.h"
 
@@ -2599,6 +2600,353 @@ static __init int alloc_kvm_area(void)
 	return 0;
 }
 
+/*
+ * For caculating offsets of fields in VMCS data, we index every 16-bit
+ * field by this kind of format:
+ *         | --------- 16 bits ---------- |
+ *         +-------------+-+------------+-+
+ *         | high 7 bits |1| low 7 bits |0|
+ *         +-------------+-+------------+-+
+ * In high byte, the lowest bit must be 1; In low byte, the lowest bit
+ * must be 0. The two bits are set like this in case indexes in VMCS
+ * data are read as big endian mode.
+ * The remaining 14 bits of the index indicate the real offset of the
+ * field. Because the size of a VMCS region is at most 4 KBytes, so
+ * 14 bits are enough to index the whole VMCS region.
+ *
+ * ENCODING_OFFSET: encode the offset into the index of this kind.
+ */
+#define OFFSET_HIGH_SHIFT (7)
+#define OFFSET_LOW_MASK   ((1 << OFFSET_HIGH_SHIFT) - 1) /* 0x7f */
+#define OFFSET_HIGH_MASK  (OFFSET_LOW_MASK << OFFSET_HIGH_SHIFT) /* 0x3f80 */
+#define ENCODING_OFFSET(offset) \
+	((((offset) & OFFSET_LOW_MASK) << 1) + \
+	((((offset) & OFFSET_HIGH_MASK) << 2) | 0x100))
+
+/*
+ * We separate these five control fields from other fields
+ * because some fields only exist on processors that support
+ * the 1-setting of control bits in the five control fields.
+ */
+static inline void append_control_field(void)
+{
+#define CONTROL_FIELD_OFFSET(field) \
+	VMCSINFO_FIELD32(field, vmcs_read32(field))
+
+	CONTROL_FIELD_OFFSET(PIN_BASED_VM_EXEC_CONTROL);
+	CONTROL_FIELD_OFFSET(CPU_BASED_VM_EXEC_CONTROL);
+	if (cpu_has_secondary_exec_ctrls()) {
+		CONTROL_FIELD_OFFSET(SECONDARY_VM_EXEC_CONTROL);
+	}
+	CONTROL_FIELD_OFFSET(VM_EXIT_CONTROLS);
+	CONTROL_FIELD_OFFSET(VM_ENTRY_CONTROLS);
+}
+
+static inline void append_field16(void)
+{
+#define FIELD_OFFSET16(field) \
+	VMCSINFO_FIELD16(field, vmcs_read16(field));
+
+	FIELD_OFFSET16(GUEST_ES_SELECTOR);
+	FIELD_OFFSET16(GUEST_CS_SELECTOR);
+	FIELD_OFFSET16(GUEST_SS_SELECTOR);
+	FIELD_OFFSET16(GUEST_DS_SELECTOR);
+	FIELD_OFFSET16(GUEST_FS_SELECTOR);
+	FIELD_OFFSET16(GUEST_GS_SELECTOR);
+	FIELD_OFFSET16(GUEST_LDTR_SELECTOR);
+	FIELD_OFFSET16(GUEST_TR_SELECTOR);
+	FIELD_OFFSET16(HOST_ES_SELECTOR);
+	FIELD_OFFSET16(HOST_CS_SELECTOR);
+	FIELD_OFFSET16(HOST_SS_SELECTOR);
+	FIELD_OFFSET16(HOST_DS_SELECTOR);
+	FIELD_OFFSET16(HOST_FS_SELECTOR);
+	FIELD_OFFSET16(HOST_GS_SELECTOR);
+	FIELD_OFFSET16(HOST_TR_SELECTOR);
+}
+
+static inline void append_field64(void)
+{
+#define FIELD_OFFSET64(field) \
+	VMCSINFO_FIELD64(field, vmcs_read64(field));
+
+	FIELD_OFFSET64(IO_BITMAP_A);
+	FIELD_OFFSET64(IO_BITMAP_A_HIGH);
+	FIELD_OFFSET64(IO_BITMAP_B);
+	FIELD_OFFSET64(IO_BITMAP_B_HIGH);
+	FIELD_OFFSET64(VM_EXIT_MSR_STORE_ADDR);
+	FIELD_OFFSET64(VM_EXIT_MSR_STORE_ADDR_HIGH);
+	FIELD_OFFSET64(VM_EXIT_MSR_LOAD_ADDR);
+	FIELD_OFFSET64(VM_EXIT_MSR_LOAD_ADDR_HIGH);
+	FIELD_OFFSET64(VM_ENTRY_MSR_LOAD_ADDR);
+	FIELD_OFFSET64(VM_ENTRY_MSR_LOAD_ADDR_HIGH);
+	FIELD_OFFSET64(TSC_OFFSET);
+	FIELD_OFFSET64(TSC_OFFSET_HIGH);
+	FIELD_OFFSET64(VMCS_LINK_POINTER);
+	FIELD_OFFSET64(VMCS_LINK_POINTER_HIGH);
+	FIELD_OFFSET64(GUEST_IA32_DEBUGCTL);
+	FIELD_OFFSET64(GUEST_IA32_DEBUGCTL_HIGH);
+
+	if (cpu_has_vmx_msr_bitmap()) {
+		FIELD_OFFSET64(MSR_BITMAP);
+		FIELD_OFFSET64(MSR_BITMAP_HIGH);
+	}
+
+	if (cpu_has_vmx_tpr_shadow()) {
+		FIELD_OFFSET64(VIRTUAL_APIC_PAGE_ADDR);
+		FIELD_OFFSET64(VIRTUAL_APIC_PAGE_ADDR_HIGH);
+	}
+
+	if (cpu_has_secondary_exec_ctrls()) {
+		if (vmcs_config.cpu_based_2nd_exec_ctrl &
+		    SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES) {
+			FIELD_OFFSET64(APIC_ACCESS_ADDR);
+			FIELD_OFFSET64(APIC_ACCESS_ADDR_HIGH);
+		}
+		if (cpu_has_vmx_ept()) {
+			FIELD_OFFSET64(EPT_POINTER);
+			FIELD_OFFSET64(EPT_POINTER_HIGH);
+			FIELD_OFFSET64(GUEST_PHYSICAL_ADDRESS);
+			FIELD_OFFSET64(GUEST_PHYSICAL_ADDRESS_HIGH);
+			FIELD_OFFSET64(GUEST_PDPTR0);
+			FIELD_OFFSET64(GUEST_PDPTR0_HIGH);
+			FIELD_OFFSET64(GUEST_PDPTR1);
+			FIELD_OFFSET64(GUEST_PDPTR1_HIGH);
+			FIELD_OFFSET64(GUEST_PDPTR2);
+			FIELD_OFFSET64(GUEST_PDPTR2_HIGH);
+			FIELD_OFFSET64(GUEST_PDPTR3);
+			FIELD_OFFSET64(GUEST_PDPTR3_HIGH);
+		}
+	}
+
+	if (vmcs_config.vmexit_ctrl & VM_EXIT_SAVE_IA32_PAT || \
+	    vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT) {
+		FIELD_OFFSET64(GUEST_IA32_PAT);
+		FIELD_OFFSET64(GUEST_IA32_PAT_HIGH);
+	}
+
+	if (vmcs_config.vmexit_ctrl & VM_EXIT_SAVE_IA32_EFER || \
+	    vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_EFER) {
+		FIELD_OFFSET64(GUEST_IA32_EFER);
+		FIELD_OFFSET64(GUEST_IA32_EFER_HIGH);
+	}
+
+	if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) {
+		FIELD_OFFSET64(GUEST_IA32_PERF_GLOBAL_CTRL);
+		FIELD_OFFSET64(GUEST_IA32_PERF_GLOBAL_CTRL_HIGH);
+	}
+
+	if (vmcs_config.vmexit_ctrl & VM_EXIT_LOAD_IA32_PAT) {
+		FIELD_OFFSET64(HOST_IA32_PAT);
+		FIELD_OFFSET64(HOST_IA32_PAT_HIGH);
+	}
+
+	if (vmcs_config.vmexit_ctrl & VM_EXIT_LOAD_IA32_EFER) {
+		FIELD_OFFSET64(HOST_IA32_EFER);
+		FIELD_OFFSET64(HOST_IA32_EFER_HIGH);
+	}
+
+	if (vmcs_config.vmexit_ctrl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL) {
+		FIELD_OFFSET64(HOST_IA32_PERF_GLOBAL_CTRL);
+		FIELD_OFFSET64(HOST_IA32_PERF_GLOBAL_CTRL_HIGH);
+	}
+}
+
+static inline void append_field32(void)
+{
+#define FIELD_OFFSET32(field) \
+	VMCSINFO_FIELD32(field, vmcs_read32(field));
+
+	FIELD_OFFSET32(EXCEPTION_BITMAP);
+	FIELD_OFFSET32(PAGE_FAULT_ERROR_CODE_MASK);
+	FIELD_OFFSET32(PAGE_FAULT_ERROR_CODE_MATCH);
+	FIELD_OFFSET32(CR3_TARGET_COUNT);
+	FIELD_OFFSET32(VM_EXIT_MSR_STORE_COUNT);
+	FIELD_OFFSET32(VM_EXIT_MSR_LOAD_COUNT);
+	FIELD_OFFSET32(VM_ENTRY_MSR_LOAD_COUNT);
+	FIELD_OFFSET32(VM_ENTRY_INTR_INFO_FIELD);
+	FIELD_OFFSET32(VM_ENTRY_EXCEPTION_ERROR_CODE);
+	FIELD_OFFSET32(VM_ENTRY_INSTRUCTION_LEN);
+	FIELD_OFFSET32(VM_INSTRUCTION_ERROR);
+	FIELD_OFFSET32(VM_EXIT_REASON);
+	FIELD_OFFSET32(VM_EXIT_INTR_INFO);
+	FIELD_OFFSET32(VM_EXIT_INTR_ERROR_CODE);
+	FIELD_OFFSET32(IDT_VECTORING_INFO_FIELD);
+	FIELD_OFFSET32(IDT_VECTORING_ERROR_CODE);
+	FIELD_OFFSET32(VM_EXIT_INSTRUCTION_LEN);
+	FIELD_OFFSET32(VMX_INSTRUCTION_INFO);
+	FIELD_OFFSET32(GUEST_ES_LIMIT);
+	FIELD_OFFSET32(GUEST_CS_LIMIT);
+	FIELD_OFFSET32(GUEST_SS_LIMIT);
+	FIELD_OFFSET32(GUEST_DS_LIMIT);
+	FIELD_OFFSET32(GUEST_FS_LIMIT);
+	FIELD_OFFSET32(GUEST_GS_LIMIT);
+	FIELD_OFFSET32(GUEST_LDTR_LIMIT);
+	FIELD_OFFSET32(GUEST_TR_LIMIT);
+	FIELD_OFFSET32(GUEST_GDTR_LIMIT);
+	FIELD_OFFSET32(GUEST_IDTR_LIMIT);
+	FIELD_OFFSET32(GUEST_ES_AR_BYTES);
+	FIELD_OFFSET32(GUEST_CS_AR_BYTES);
+	FIELD_OFFSET32(GUEST_SS_AR_BYTES);
+	FIELD_OFFSET32(GUEST_DS_AR_BYTES);
+	FIELD_OFFSET32(GUEST_FS_AR_BYTES);
+	FIELD_OFFSET32(GUEST_GS_AR_BYTES);
+	FIELD_OFFSET32(GUEST_LDTR_AR_BYTES);
+	FIELD_OFFSET32(GUEST_TR_AR_BYTES);
+	FIELD_OFFSET32(GUEST_INTERRUPTIBILITY_INFO);
+	FIELD_OFFSET32(GUEST_ACTIVITY_STATE);
+	FIELD_OFFSET32(GUEST_SYSENTER_CS);
+	FIELD_OFFSET32(HOST_IA32_SYSENTER_CS);
+
+	if (cpu_has_vmx_tpr_shadow()) {
+		FIELD_OFFSET32(TPR_THRESHOLD);
+	}
+	if (cpu_has_secondary_exec_ctrls()) {
+		if (cpu_has_vmx_ple()) {
+			FIELD_OFFSET32(PLE_GAP);
+			FIELD_OFFSET32(PLE_WINDOW);
+		}
+	}
+}
+
+static inline void append_field(void)
+{
+#define FIELD_OFFSET(field) \
+	VMCSINFO_FIELD(field, vmcs_readl(field));
+
+	FIELD_OFFSET(CR0_GUEST_HOST_MASK);
+	FIELD_OFFSET(CR4_GUEST_HOST_MASK);
+	FIELD_OFFSET(CR0_READ_SHADOW);
+	FIELD_OFFSET(CR4_READ_SHADOW);
+	FIELD_OFFSET(CR3_TARGET_VALUE0);
+	FIELD_OFFSET(CR3_TARGET_VALUE1);
+	FIELD_OFFSET(CR3_TARGET_VALUE2);
+	FIELD_OFFSET(CR3_TARGET_VALUE3);
+	FIELD_OFFSET(EXIT_QUALIFICATION);
+	FIELD_OFFSET(GUEST_LINEAR_ADDRESS);
+	FIELD_OFFSET(GUEST_CR0);
+	FIELD_OFFSET(GUEST_CR3);
+	FIELD_OFFSET(GUEST_CR4);
+	FIELD_OFFSET(GUEST_ES_BASE);
+	FIELD_OFFSET(GUEST_CS_BASE);
+	FIELD_OFFSET(GUEST_SS_BASE);
+	FIELD_OFFSET(GUEST_DS_BASE);
+	FIELD_OFFSET(GUEST_FS_BASE);
+	FIELD_OFFSET(GUEST_GS_BASE);
+	FIELD_OFFSET(GUEST_LDTR_BASE);
+	FIELD_OFFSET(GUEST_TR_BASE);
+	FIELD_OFFSET(GUEST_GDTR_BASE);
+	FIELD_OFFSET(GUEST_IDTR_BASE);
+	FIELD_OFFSET(GUEST_DR7);
+	FIELD_OFFSET(GUEST_RSP);
+	FIELD_OFFSET(GUEST_RIP);
+	FIELD_OFFSET(GUEST_RFLAGS);
+	FIELD_OFFSET(GUEST_PENDING_DBG_EXCEPTIONS);
+	FIELD_OFFSET(GUEST_SYSENTER_ESP);
+	FIELD_OFFSET(GUEST_SYSENTER_EIP);
+	FIELD_OFFSET(HOST_CR0);
+	FIELD_OFFSET(HOST_CR3);
+	FIELD_OFFSET(HOST_CR4);
+	FIELD_OFFSET(HOST_FS_BASE);
+	FIELD_OFFSET(HOST_GS_BASE);
+	FIELD_OFFSET(HOST_TR_BASE);
+	FIELD_OFFSET(HOST_GDTR_BASE);
+	FIELD_OFFSET(HOST_IDTR_BASE);
+	FIELD_OFFSET(HOST_IA32_SYSENTER_ESP);
+	FIELD_OFFSET(HOST_IA32_SYSENTER_EIP);
+	FIELD_OFFSET(HOST_RSP);
+	FIELD_OFFSET(HOST_RIP);
+}
+
+/*
+ * alloc_vmcsinfo will be called at the initialization of
+ * kvm_intel module to fill VMCSINFO. The VMCSINFO contains
+ * a VMCS revision identifier and encoded offsets of fields.
+ *
+ * Note, offsets of fields below will not be filled into
+ * VMCSINFO:
+ * 1. fields defined in Intel specification (Intel® 64 and
+ *    IA-32 Architectures Software Developer’s Manual, Volume
+ *    3C) but not defined in *vmcs_field*.
+ * 2. fields don't exist because their corresponding
+ *    control bits are not set.
+ */
+static __init void alloc_vmcsinfo(void)
+{
+/*
+ * The first 8 bytes in vmcs region are for
+ *   VMCS revision identifier
+ *   VMX-abort indicator
+ */
+#define FIELD_START (8)
+
+	int offset, flag;
+	struct vmcs *vmcs;
+	u64 old_msr, test_bits;
+
+	flag = 0;
+
+	if (vmcsinfo_size)
+		return;
+
+	vmcs = alloc_vmcs();
+	if (!vmcs) {
+		return;
+	}
+
+	rdmsrl(MSR_IA32_FEATURE_CONTROL, old_msr);
+
+	test_bits = FEATURE_CONTROL_LOCKED;
+	test_bits |= FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX;
+	if (tboot_enabled())
+		test_bits |= FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX;
+	if ((old_msr & test_bits) != test_bits)
+		wrmsrl(MSR_IA32_FEATURE_CONTROL, old_msr | test_bits);
+
+	flag = read_cr4() & X86_CR4_VMXE;
+	if (!flag)
+		write_cr4(read_cr4() | X86_CR4_VMXE);
+
+	kvm_cpu_vmxon(__pa(per_cpu(vmxarea, raw_smp_processor_id())));
+	vmcs_load(vmcs);
+
+	VMCSINFO_REVISION_ID(vmcs->revision_id);
+
+	/*
+	 * Write encoded offsets into VMCS data for later vmcs_read.
+	 */
+	for (offset = FIELD_START; offset < vmcs_config.size;
+	     offset += sizeof(u16))
+		*(u16 *)((char *)vmcs + offset) = ENCODING_OFFSET(offset);
+
+	append_control_field();
+
+	vmcs_write32(PIN_BASED_VM_EXEC_CONTROL,
+		     vmcs_config.pin_based_exec_ctrl);
+	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL,
+		     vmcs_config.cpu_based_exec_ctrl);
+	if (cpu_has_secondary_exec_ctrls()) {
+		vmcs_write32(SECONDARY_VM_EXEC_CONTROL,
+			     vmcs_config.cpu_based_2nd_exec_ctrl);
+	}
+	vmcs_write32(VM_EXIT_CONTROLS, vmcs_config.vmexit_ctrl);
+	vmcs_write32(VM_ENTRY_CONTROLS, vmcs_config.vmentry_ctrl);
+
+	append_field16();
+	append_field64();
+	append_field32();
+	append_field();
+
+	update_vmcsinfo_note();
+
+	vmcs_clear(vmcs);
+	kvm_cpu_vmxoff();
+	if (!flag)
+		write_cr4(read_cr4() & ~X86_CR4_VMXE);
+	wrmsrl(MSR_IA32_FEATURE_CONTROL, old_msr);
+
+	free_vmcs(vmcs);
+}
+
 static __init int hardware_setup(void)
 {
 	if (setup_vmcs_config(&vmcs_config) < 0)
@@ -7227,6 +7575,8 @@ static int __init vmx_init(void)
 	if (r)
 		goto out3;
 
+	alloc_vmcsinfo();
+
 	vmx_disable_intercept_for_msr(MSR_FS_BASE, false);
 	vmx_disable_intercept_for_msr(MSR_GS_BASE, false);
 	vmx_disable_intercept_for_msr(MSR_KERNEL_GS_BASE, true);
-- 
1.7.1
