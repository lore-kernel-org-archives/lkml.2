Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab2F0Izd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 04:55:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:20385 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab2F0Izb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 04:55:31 -0400
X-IronPort-AV: E=Sophos;i="4.77,483,1336320000"; 
   d="scan'208";a="5273695"
Message-ID: <4FEAC9AE.4090001@cn.fujitsu.com>
Date: Wed, 27 Jun 2012 16:51:58 +0800
From: Yanfei Zhang <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com
CC: ebiederm@xmission.com, luto@mit.edu, Joerg Roedel <joerg.roedel@amd.com>,
        dzickus@redhat.com, paul.gortmaker@windriver.com,
        ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH v3 1/5] x86: Add helper variables and functions to hold VMCSINFO
References: <4FEAC945.50700@cn.fujitsu.com>
In-Reply-To: <4FEAC945.50700@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/27 16:55:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/27 16:55:28,
	Serialize complete at 2012/06/27 16:55:28
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides a set of variables to hold the VMCSINFO and also
some helper functions to help fill the VMCSINFO.

Signed-off-by: zhangyanfei <zhangyanfei@cn.fujitsu.com>
---
 arch/x86/include/asm/vmcsinfo.h |  219 ++++++++++++++++++++++
 arch/x86/include/asm/vmx.h      |  158 +----------------
 arch/x86/kernel/Makefile        |    1 +
 arch/x86/kernel/vmcsinfo.c      |  381 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 603 insertions(+), 156 deletions(-)
 create mode 100644 arch/x86/include/asm/vmcsinfo.h
 create mode 100644 arch/x86/kernel/vmcsinfo.c

diff --git a/arch/x86/include/asm/vmcsinfo.h b/arch/x86/include/asm/vmcsinfo.h
new file mode 100644
index 0000000..4b9f56b
--- /dev/null
+++ b/arch/x86/include/asm/vmcsinfo.h
@@ -0,0 +1,219 @@
+#ifndef _ASM_X86_VMCSINFO_H
+#define _ASM_X86_VMCSINFO_H
+
+#ifndef __ASSEMBLY__
+#include <linux/types.h>
+#include <linux/elf.h>
+#include <linux/device.h>
+
+/* VMCS Encodings */
+enum vmcs_field {
+	VIRTUAL_PROCESSOR_ID            = 0x00000000,
+	GUEST_ES_SELECTOR               = 0x00000800,
+	GUEST_CS_SELECTOR               = 0x00000802,
+	GUEST_SS_SELECTOR               = 0x00000804,
+	GUEST_DS_SELECTOR               = 0x00000806,
+	GUEST_FS_SELECTOR               = 0x00000808,
+	GUEST_GS_SELECTOR               = 0x0000080a,
+	GUEST_LDTR_SELECTOR             = 0x0000080c,
+	GUEST_TR_SELECTOR               = 0x0000080e,
+	HOST_ES_SELECTOR                = 0x00000c00,
+	HOST_CS_SELECTOR                = 0x00000c02,
+	HOST_SS_SELECTOR                = 0x00000c04,
+	HOST_DS_SELECTOR                = 0x00000c06,
+	HOST_FS_SELECTOR                = 0x00000c08,
+	HOST_GS_SELECTOR                = 0x00000c0a,
+	HOST_TR_SELECTOR                = 0x00000c0c,
+	IO_BITMAP_A                     = 0x00002000,
+	IO_BITMAP_A_HIGH                = 0x00002001,
+	IO_BITMAP_B                     = 0x00002002,
+	IO_BITMAP_B_HIGH                = 0x00002003,
+	MSR_BITMAP                      = 0x00002004,
+	MSR_BITMAP_HIGH                 = 0x00002005,
+	VM_EXIT_MSR_STORE_ADDR          = 0x00002006,
+	VM_EXIT_MSR_STORE_ADDR_HIGH     = 0x00002007,
+	VM_EXIT_MSR_LOAD_ADDR           = 0x00002008,
+	VM_EXIT_MSR_LOAD_ADDR_HIGH      = 0x00002009,
+	VM_ENTRY_MSR_LOAD_ADDR          = 0x0000200a,
+	VM_ENTRY_MSR_LOAD_ADDR_HIGH     = 0x0000200b,
+	TSC_OFFSET                      = 0x00002010,
+	TSC_OFFSET_HIGH                 = 0x00002011,
+	VIRTUAL_APIC_PAGE_ADDR          = 0x00002012,
+	VIRTUAL_APIC_PAGE_ADDR_HIGH     = 0x00002013,
+	APIC_ACCESS_ADDR		= 0x00002014,
+	APIC_ACCESS_ADDR_HIGH		= 0x00002015,
+	EPT_POINTER                     = 0x0000201a,
+	EPT_POINTER_HIGH                = 0x0000201b,
+	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
+	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
+	VMCS_LINK_POINTER               = 0x00002800,
+	VMCS_LINK_POINTER_HIGH          = 0x00002801,
+	GUEST_IA32_DEBUGCTL             = 0x00002802,
+	GUEST_IA32_DEBUGCTL_HIGH        = 0x00002803,
+	GUEST_IA32_PAT			= 0x00002804,
+	GUEST_IA32_PAT_HIGH		= 0x00002805,
+	GUEST_IA32_EFER			= 0x00002806,
+	GUEST_IA32_EFER_HIGH		= 0x00002807,
+	GUEST_IA32_PERF_GLOBAL_CTRL	= 0x00002808,
+	GUEST_IA32_PERF_GLOBAL_CTRL_HIGH= 0x00002809,
+	GUEST_PDPTR0                    = 0x0000280a,
+	GUEST_PDPTR0_HIGH               = 0x0000280b,
+	GUEST_PDPTR1                    = 0x0000280c,
+	GUEST_PDPTR1_HIGH               = 0x0000280d,
+	GUEST_PDPTR2                    = 0x0000280e,
+	GUEST_PDPTR2_HIGH               = 0x0000280f,
+	GUEST_PDPTR3                    = 0x00002810,
+	GUEST_PDPTR3_HIGH               = 0x00002811,
+	HOST_IA32_PAT			= 0x00002c00,
+	HOST_IA32_PAT_HIGH		= 0x00002c01,
+	HOST_IA32_EFER			= 0x00002c02,
+	HOST_IA32_EFER_HIGH		= 0x00002c03,
+	HOST_IA32_PERF_GLOBAL_CTRL	= 0x00002c04,
+	HOST_IA32_PERF_GLOBAL_CTRL_HIGH	= 0x00002c05,
+	PIN_BASED_VM_EXEC_CONTROL       = 0x00004000,
+	CPU_BASED_VM_EXEC_CONTROL       = 0x00004002,
+	EXCEPTION_BITMAP                = 0x00004004,
+	PAGE_FAULT_ERROR_CODE_MASK      = 0x00004006,
+	PAGE_FAULT_ERROR_CODE_MATCH     = 0x00004008,
+	CR3_TARGET_COUNT                = 0x0000400a,
+	VM_EXIT_CONTROLS                = 0x0000400c,
+	VM_EXIT_MSR_STORE_COUNT         = 0x0000400e,
+	VM_EXIT_MSR_LOAD_COUNT          = 0x00004010,
+	VM_ENTRY_CONTROLS               = 0x00004012,
+	VM_ENTRY_MSR_LOAD_COUNT         = 0x00004014,
+	VM_ENTRY_INTR_INFO_FIELD        = 0x00004016,
+	VM_ENTRY_EXCEPTION_ERROR_CODE   = 0x00004018,
+	VM_ENTRY_INSTRUCTION_LEN        = 0x0000401a,
+	TPR_THRESHOLD                   = 0x0000401c,
+	SECONDARY_VM_EXEC_CONTROL       = 0x0000401e,
+	PLE_GAP                         = 0x00004020,
+	PLE_WINDOW                      = 0x00004022,
+	VM_INSTRUCTION_ERROR            = 0x00004400,
+	VM_EXIT_REASON                  = 0x00004402,
+	VM_EXIT_INTR_INFO               = 0x00004404,
+	VM_EXIT_INTR_ERROR_CODE         = 0x00004406,
+	IDT_VECTORING_INFO_FIELD        = 0x00004408,
+	IDT_VECTORING_ERROR_CODE        = 0x0000440a,
+	VM_EXIT_INSTRUCTION_LEN         = 0x0000440c,
+	VMX_INSTRUCTION_INFO            = 0x0000440e,
+	GUEST_ES_LIMIT                  = 0x00004800,
+	GUEST_CS_LIMIT                  = 0x00004802,
+	GUEST_SS_LIMIT                  = 0x00004804,
+	GUEST_DS_LIMIT                  = 0x00004806,
+	GUEST_FS_LIMIT                  = 0x00004808,
+	GUEST_GS_LIMIT                  = 0x0000480a,
+	GUEST_LDTR_LIMIT                = 0x0000480c,
+	GUEST_TR_LIMIT                  = 0x0000480e,
+	GUEST_GDTR_LIMIT                = 0x00004810,
+	GUEST_IDTR_LIMIT                = 0x00004812,
+	GUEST_ES_AR_BYTES               = 0x00004814,
+	GUEST_CS_AR_BYTES               = 0x00004816,
+	GUEST_SS_AR_BYTES               = 0x00004818,
+	GUEST_DS_AR_BYTES               = 0x0000481a,
+	GUEST_FS_AR_BYTES               = 0x0000481c,
+	GUEST_GS_AR_BYTES               = 0x0000481e,
+	GUEST_LDTR_AR_BYTES             = 0x00004820,
+	GUEST_TR_AR_BYTES               = 0x00004822,
+	GUEST_INTERRUPTIBILITY_INFO     = 0x00004824,
+	GUEST_ACTIVITY_STATE            = 0X00004826,
+	GUEST_SYSENTER_CS               = 0x0000482A,
+	HOST_IA32_SYSENTER_CS           = 0x00004c00,
+	CR0_GUEST_HOST_MASK             = 0x00006000,
+	CR4_GUEST_HOST_MASK             = 0x00006002,
+	CR0_READ_SHADOW                 = 0x00006004,
+	CR4_READ_SHADOW                 = 0x00006006,
+	CR3_TARGET_VALUE0               = 0x00006008,
+	CR3_TARGET_VALUE1               = 0x0000600a,
+	CR3_TARGET_VALUE2               = 0x0000600c,
+	CR3_TARGET_VALUE3               = 0x0000600e,
+	EXIT_QUALIFICATION              = 0x00006400,
+	GUEST_LINEAR_ADDRESS            = 0x0000640a,
+	GUEST_CR0                       = 0x00006800,
+	GUEST_CR3                       = 0x00006802,
+	GUEST_CR4                       = 0x00006804,
+	GUEST_ES_BASE                   = 0x00006806,
+	GUEST_CS_BASE                   = 0x00006808,
+	GUEST_SS_BASE                   = 0x0000680a,
+	GUEST_DS_BASE                   = 0x0000680c,
+	GUEST_FS_BASE                   = 0x0000680e,
+	GUEST_GS_BASE                   = 0x00006810,
+	GUEST_LDTR_BASE                 = 0x00006812,
+	GUEST_TR_BASE                   = 0x00006814,
+	GUEST_GDTR_BASE                 = 0x00006816,
+	GUEST_IDTR_BASE                 = 0x00006818,
+	GUEST_DR7                       = 0x0000681a,
+	GUEST_RSP                       = 0x0000681c,
+	GUEST_RIP                       = 0x0000681e,
+	GUEST_RFLAGS                    = 0x00006820,
+	GUEST_PENDING_DBG_EXCEPTIONS    = 0x00006822,
+	GUEST_SYSENTER_ESP              = 0x00006824,
+	GUEST_SYSENTER_EIP              = 0x00006826,
+	HOST_CR0                        = 0x00006c00,
+	HOST_CR3                        = 0x00006c02,
+	HOST_CR4                        = 0x00006c04,
+	HOST_FS_BASE                    = 0x00006c06,
+	HOST_GS_BASE                    = 0x00006c08,
+	HOST_TR_BASE                    = 0x00006c0a,
+	HOST_GDTR_BASE                  = 0x00006c0c,
+	HOST_IDTR_BASE                  = 0x00006c0e,
+	HOST_IA32_SYSENTER_ESP          = 0x00006c10,
+	HOST_IA32_SYSENTER_EIP          = 0x00006c12,
+	HOST_RSP                        = 0x00006c14,
+	HOST_RIP                        = 0x00006c16,
+};
+
+/*
+ * vmcs field offsets.
+ */
+struct vmcsinfo {
+	u32 vmcs_revision_id;
+	int filled;
+	u16 vmcs_field_to_offset_table[HOST_RIP + 1];
+};
+
+#define VMCSINFO_NOTE_NAME         "VMCSINFO"
+#define VMCSINFO_NOTE_NAME_BYTES   ALIGN(sizeof(VMCSINFO_NOTE_NAME), 4)
+#define VMCSINFO_NOTE_HEAD_BYTES   ALIGN(sizeof(struct elf_note), 4)
+#define VMCSINFO_NOTE_SIZE         (VMCSINFO_NOTE_HEAD_BYTES*2 \
+				    + sizeof(struct vmcsinfo) \
+				    + VMCSINFO_NOTE_NAME_BYTES)
+
+extern struct vmcsinfo vmcsinfo;
+#define VMCSINFO_MAX_FIELD \
+	ARRAY_SIZE(vmcsinfo.vmcs_field_to_offset_table)
+
+extern void update_vmcsinfo_note(void);
+extern int vmcs_sysfs_add(struct device *);
+extern void vmcs_sysfs_remove(struct device *);
+
+static inline void vmcsinfo_revision_id(u32 id)
+{
+	vmcsinfo.vmcs_revision_id = id;
+}
+
+static inline void vmcsinfo_field(unsigned long field, u16 offset)
+{
+	if (field < VMCSINFO_MAX_FIELD)
+		vmcsinfo.vmcs_field_to_offset_table[field] = offset;
+}
+
+static inline int vmcsinfo_is_filled(void)
+{
+	return vmcsinfo.filled;
+}
+
+static inline void vmcsinfo_filled(void)
+{
+	vmcsinfo.filled = 1;
+}
+
+static inline short get_vmcs_field_offset(unsigned long field)
+{
+	if (field >= VMCSINFO_MAX_FIELD ||
+	    vmcsinfo.vmcs_field_to_offset_table[field] == 0)
+		return -1;
+	return vmcsinfo.vmcs_field_to_offset_table[field];
+}
+
+#endif /* __ASSEMBLY__ */
+#endif /* _ASM_X86_VMCSINFO_H */
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 31f180c..c364219 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -27,6 +27,8 @@
 
 #include <linux/types.h>
 
+#include <asm/vmcsinfo.h>
+
 /*
  * Definitions of Primary Processor-Based VM-Execution Controls.
  */
@@ -84,162 +86,6 @@
 #define VM_ENTRY_LOAD_IA32_PAT			0x00004000
 #define VM_ENTRY_LOAD_IA32_EFER                 0x00008000
 
-/* VMCS Encodings */
-enum vmcs_field {
-	VIRTUAL_PROCESSOR_ID            = 0x00000000,
-	GUEST_ES_SELECTOR               = 0x00000800,
-	GUEST_CS_SELECTOR               = 0x00000802,
-	GUEST_SS_SELECTOR               = 0x00000804,
-	GUEST_DS_SELECTOR               = 0x00000806,
-	GUEST_FS_SELECTOR               = 0x00000808,
-	GUEST_GS_SELECTOR               = 0x0000080a,
-	GUEST_LDTR_SELECTOR             = 0x0000080c,
-	GUEST_TR_SELECTOR               = 0x0000080e,
-	HOST_ES_SELECTOR                = 0x00000c00,
-	HOST_CS_SELECTOR                = 0x00000c02,
-	HOST_SS_SELECTOR                = 0x00000c04,
-	HOST_DS_SELECTOR                = 0x00000c06,
-	HOST_FS_SELECTOR                = 0x00000c08,
-	HOST_GS_SELECTOR                = 0x00000c0a,
-	HOST_TR_SELECTOR                = 0x00000c0c,
-	IO_BITMAP_A                     = 0x00002000,
-	IO_BITMAP_A_HIGH                = 0x00002001,
-	IO_BITMAP_B                     = 0x00002002,
-	IO_BITMAP_B_HIGH                = 0x00002003,
-	MSR_BITMAP                      = 0x00002004,
-	MSR_BITMAP_HIGH                 = 0x00002005,
-	VM_EXIT_MSR_STORE_ADDR          = 0x00002006,
-	VM_EXIT_MSR_STORE_ADDR_HIGH     = 0x00002007,
-	VM_EXIT_MSR_LOAD_ADDR           = 0x00002008,
-	VM_EXIT_MSR_LOAD_ADDR_HIGH      = 0x00002009,
-	VM_ENTRY_MSR_LOAD_ADDR          = 0x0000200a,
-	VM_ENTRY_MSR_LOAD_ADDR_HIGH     = 0x0000200b,
-	TSC_OFFSET                      = 0x00002010,
-	TSC_OFFSET_HIGH                 = 0x00002011,
-	VIRTUAL_APIC_PAGE_ADDR          = 0x00002012,
-	VIRTUAL_APIC_PAGE_ADDR_HIGH     = 0x00002013,
-	APIC_ACCESS_ADDR		= 0x00002014,
-	APIC_ACCESS_ADDR_HIGH		= 0x00002015,
-	EPT_POINTER                     = 0x0000201a,
-	EPT_POINTER_HIGH                = 0x0000201b,
-	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
-	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
-	VMCS_LINK_POINTER               = 0x00002800,
-	VMCS_LINK_POINTER_HIGH          = 0x00002801,
-	GUEST_IA32_DEBUGCTL             = 0x00002802,
-	GUEST_IA32_DEBUGCTL_HIGH        = 0x00002803,
-	GUEST_IA32_PAT			= 0x00002804,
-	GUEST_IA32_PAT_HIGH		= 0x00002805,
-	GUEST_IA32_EFER			= 0x00002806,
-	GUEST_IA32_EFER_HIGH		= 0x00002807,
-	GUEST_IA32_PERF_GLOBAL_CTRL	= 0x00002808,
-	GUEST_IA32_PERF_GLOBAL_CTRL_HIGH= 0x00002809,
-	GUEST_PDPTR0                    = 0x0000280a,
-	GUEST_PDPTR0_HIGH               = 0x0000280b,
-	GUEST_PDPTR1                    = 0x0000280c,
-	GUEST_PDPTR1_HIGH               = 0x0000280d,
-	GUEST_PDPTR2                    = 0x0000280e,
-	GUEST_PDPTR2_HIGH               = 0x0000280f,
-	GUEST_PDPTR3                    = 0x00002810,
-	GUEST_PDPTR3_HIGH               = 0x00002811,
-	HOST_IA32_PAT			= 0x00002c00,
-	HOST_IA32_PAT_HIGH		= 0x00002c01,
-	HOST_IA32_EFER			= 0x00002c02,
-	HOST_IA32_EFER_HIGH		= 0x00002c03,
-	HOST_IA32_PERF_GLOBAL_CTRL	= 0x00002c04,
-	HOST_IA32_PERF_GLOBAL_CTRL_HIGH	= 0x00002c05,
-	PIN_BASED_VM_EXEC_CONTROL       = 0x00004000,
-	CPU_BASED_VM_EXEC_CONTROL       = 0x00004002,
-	EXCEPTION_BITMAP                = 0x00004004,
-	PAGE_FAULT_ERROR_CODE_MASK      = 0x00004006,
-	PAGE_FAULT_ERROR_CODE_MATCH     = 0x00004008,
-	CR3_TARGET_COUNT                = 0x0000400a,
-	VM_EXIT_CONTROLS                = 0x0000400c,
-	VM_EXIT_MSR_STORE_COUNT         = 0x0000400e,
-	VM_EXIT_MSR_LOAD_COUNT          = 0x00004010,
-	VM_ENTRY_CONTROLS               = 0x00004012,
-	VM_ENTRY_MSR_LOAD_COUNT         = 0x00004014,
-	VM_ENTRY_INTR_INFO_FIELD        = 0x00004016,
-	VM_ENTRY_EXCEPTION_ERROR_CODE   = 0x00004018,
-	VM_ENTRY_INSTRUCTION_LEN        = 0x0000401a,
-	TPR_THRESHOLD                   = 0x0000401c,
-	SECONDARY_VM_EXEC_CONTROL       = 0x0000401e,
-	PLE_GAP                         = 0x00004020,
-	PLE_WINDOW                      = 0x00004022,
-	VM_INSTRUCTION_ERROR            = 0x00004400,
-	VM_EXIT_REASON                  = 0x00004402,
-	VM_EXIT_INTR_INFO               = 0x00004404,
-	VM_EXIT_INTR_ERROR_CODE         = 0x00004406,
-	IDT_VECTORING_INFO_FIELD        = 0x00004408,
-	IDT_VECTORING_ERROR_CODE        = 0x0000440a,
-	VM_EXIT_INSTRUCTION_LEN         = 0x0000440c,
-	VMX_INSTRUCTION_INFO            = 0x0000440e,
-	GUEST_ES_LIMIT                  = 0x00004800,
-	GUEST_CS_LIMIT                  = 0x00004802,
-	GUEST_SS_LIMIT                  = 0x00004804,
-	GUEST_DS_LIMIT                  = 0x00004806,
-	GUEST_FS_LIMIT                  = 0x00004808,
-	GUEST_GS_LIMIT                  = 0x0000480a,
-	GUEST_LDTR_LIMIT                = 0x0000480c,
-	GUEST_TR_LIMIT                  = 0x0000480e,
-	GUEST_GDTR_LIMIT                = 0x00004810,
-	GUEST_IDTR_LIMIT                = 0x00004812,
-	GUEST_ES_AR_BYTES               = 0x00004814,
-	GUEST_CS_AR_BYTES               = 0x00004816,
-	GUEST_SS_AR_BYTES               = 0x00004818,
-	GUEST_DS_AR_BYTES               = 0x0000481a,
-	GUEST_FS_AR_BYTES               = 0x0000481c,
-	GUEST_GS_AR_BYTES               = 0x0000481e,
-	GUEST_LDTR_AR_BYTES             = 0x00004820,
-	GUEST_TR_AR_BYTES               = 0x00004822,
-	GUEST_INTERRUPTIBILITY_INFO     = 0x00004824,
-	GUEST_ACTIVITY_STATE            = 0X00004826,
-	GUEST_SYSENTER_CS               = 0x0000482A,
-	HOST_IA32_SYSENTER_CS           = 0x00004c00,
-	CR0_GUEST_HOST_MASK             = 0x00006000,
-	CR4_GUEST_HOST_MASK             = 0x00006002,
-	CR0_READ_SHADOW                 = 0x00006004,
-	CR4_READ_SHADOW                 = 0x00006006,
-	CR3_TARGET_VALUE0               = 0x00006008,
-	CR3_TARGET_VALUE1               = 0x0000600a,
-	CR3_TARGET_VALUE2               = 0x0000600c,
-	CR3_TARGET_VALUE3               = 0x0000600e,
-	EXIT_QUALIFICATION              = 0x00006400,
-	GUEST_LINEAR_ADDRESS            = 0x0000640a,
-	GUEST_CR0                       = 0x00006800,
-	GUEST_CR3                       = 0x00006802,
-	GUEST_CR4                       = 0x00006804,
-	GUEST_ES_BASE                   = 0x00006806,
-	GUEST_CS_BASE                   = 0x00006808,
-	GUEST_SS_BASE                   = 0x0000680a,
-	GUEST_DS_BASE                   = 0x0000680c,
-	GUEST_FS_BASE                   = 0x0000680e,
-	GUEST_GS_BASE                   = 0x00006810,
-	GUEST_LDTR_BASE                 = 0x00006812,
-	GUEST_TR_BASE                   = 0x00006814,
-	GUEST_GDTR_BASE                 = 0x00006816,
-	GUEST_IDTR_BASE                 = 0x00006818,
-	GUEST_DR7                       = 0x0000681a,
-	GUEST_RSP                       = 0x0000681c,
-	GUEST_RIP                       = 0x0000681e,
-	GUEST_RFLAGS                    = 0x00006820,
-	GUEST_PENDING_DBG_EXCEPTIONS    = 0x00006822,
-	GUEST_SYSENTER_ESP              = 0x00006824,
-	GUEST_SYSENTER_EIP              = 0x00006826,
-	HOST_CR0                        = 0x00006c00,
-	HOST_CR3                        = 0x00006c02,
-	HOST_CR4                        = 0x00006c04,
-	HOST_FS_BASE                    = 0x00006c06,
-	HOST_GS_BASE                    = 0x00006c08,
-	HOST_TR_BASE                    = 0x00006c0a,
-	HOST_GDTR_BASE                  = 0x00006c0c,
-	HOST_IDTR_BASE                  = 0x00006c0e,
-	HOST_IA32_SYSENTER_ESP          = 0x00006c10,
-	HOST_IA32_SYSENTER_EIP          = 0x00006c12,
-	HOST_RSP                        = 0x00006c14,
-	HOST_RIP                        = 0x00006c16,
-};
-
 #define VMX_EXIT_REASONS_FAILED_VMENTRY         0x80000000
 
 #define EXIT_REASON_EXCEPTION_NMI       0
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 8215e56..2c41f93 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -99,6 +99,7 @@ obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
 obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
 obj-$(CONFIG_OF)			+= devicetree.o
 obj-$(CONFIG_UPROBES)			+= uprobes.o
+obj-y					+= vmcsinfo.o
 
 ###
 # 64 bit specific files
diff --git a/arch/x86/kernel/vmcsinfo.c b/arch/x86/kernel/vmcsinfo.c
new file mode 100644
index 0000000..25218ca
--- /dev/null
+++ b/arch/x86/kernel/vmcsinfo.c
@@ -0,0 +1,381 @@
+/*
+ * Architecture specific (i386/x86_64) functions for storing vmcs
+ * field information.
+ *
+ * Created by: Zhang Yanfei (zhangyanfei@cn.fujitsu.com)
+ *
+ * Copyright (C) Fujitsu Corporation, 2012. All rights reserved.
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2.  See the file COPYING for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/elf.h>
+
+#include <asm/vmcsinfo.h>
+
+struct vmcsinfo vmcsinfo;
+EXPORT_SYMBOL_GPL(vmcsinfo);
+static u32 vmcsinfo_note[VMCSINFO_NOTE_SIZE/4];
+
+const char vmcs_group_name[] = "vmcs";
+
+void update_vmcsinfo_note(void)
+{
+	u32 *buf = vmcsinfo_note;
+	struct elf_note note;
+
+	if (!vmcsinfo_is_filled())
+		return;
+
+	note.n_namesz = strlen(VMCSINFO_NOTE_NAME) + 1;
+	note.n_descsz = sizeof(vmcsinfo);
+	note.n_type   = 0;
+	memcpy(buf, &note, sizeof(note));
+	buf += (sizeof(note) + 3)/4;
+	memcpy(buf, VMCSINFO_NOTE_NAME, note.n_namesz);
+	buf += (note.n_namesz + 3)/4;
+	memcpy(buf, &vmcsinfo, note.n_descsz);
+	buf += (note.n_descsz + 3)/4;
+
+	note.n_namesz = 0;
+	note.n_descsz = 0;
+	note.n_type   = 0;
+	memcpy(buf, &note, sizeof(note));
+}
+EXPORT_SYMBOL_GPL(update_vmcsinfo_note);
+
+#define BUILD_OFFSET_SHOW(field_code)                                         \
+static ssize_t _##field_code##_show(struct device *dev,                       \
+				    struct device_attribute *attr,            \
+				    char *buf)                                \
+{                                                                             \
+	return sprintf(buf, "%d\n",                                           \
+		       vmcsinfo.vmcs_field_to_offset_table[0x##field_code]);  \
+}                                                                             \
+static DEVICE_ATTR(field_code, 0444, _##field_code##_show, NULL);             \
+
+BUILD_OFFSET_SHOW(0000); /* VIRTUAL_PROCESSOR_ID             */
+BUILD_OFFSET_SHOW(0800); /* GUEST_ES_SELECTOR                */
+BUILD_OFFSET_SHOW(0802); /* GUEST_CS_SELECTOR                */
+BUILD_OFFSET_SHOW(0804); /* GUEST_SS_SELECTOR                */
+BUILD_OFFSET_SHOW(0806); /* GUEST_DS_SELECTOR                */
+BUILD_OFFSET_SHOW(0808); /* GUEST_FS_SELECTOR                */
+BUILD_OFFSET_SHOW(080a); /* GUEST_GS_SELECTOR                */
+BUILD_OFFSET_SHOW(080c); /* GUEST_LDTR_SELECTOR              */
+BUILD_OFFSET_SHOW(080e); /* GUEST_TR_SELECTOR                */
+BUILD_OFFSET_SHOW(0c00); /* HOST_ES_SELECTOR                 */
+BUILD_OFFSET_SHOW(0c02); /* HOST_CS_SELECTOR                 */
+BUILD_OFFSET_SHOW(0c04); /* HOST_SS_SELECTOR                 */
+BUILD_OFFSET_SHOW(0c06); /* HOST_DS_SELECTOR                 */
+BUILD_OFFSET_SHOW(0c08); /* HOST_FS_SELECTOR                 */
+BUILD_OFFSET_SHOW(0c0a); /* HOST_GS_SELECTOR                 */
+BUILD_OFFSET_SHOW(0c0c); /* HOST_TR_SELECTOR                 */
+BUILD_OFFSET_SHOW(2000); /* IO_BITMAP_A                      */
+BUILD_OFFSET_SHOW(2001); /* IO_BITMAP_A_HIGH                 */
+BUILD_OFFSET_SHOW(2002); /* IO_BITMAP_B                      */
+BUILD_OFFSET_SHOW(2003); /* IO_BITMAP_B_HIGH                 */
+BUILD_OFFSET_SHOW(2004); /* MSR_BITMAP                       */
+BUILD_OFFSET_SHOW(2005); /* MSR_BITMAP_HIGH                  */
+BUILD_OFFSET_SHOW(2006); /* VM_EXIT_MSR_STORE_ADDR           */
+BUILD_OFFSET_SHOW(2007); /* VM_EXIT_MSR_STORE_ADDR_HIGH      */
+BUILD_OFFSET_SHOW(2008); /* VM_EXIT_MSR_LOAD_ADDR            */
+BUILD_OFFSET_SHOW(2009); /* VM_EXIT_MSR_LOAD_ADDR_HIGH       */
+BUILD_OFFSET_SHOW(200a); /* VM_ENTRY_MSR_LOAD_ADDR           */
+BUILD_OFFSET_SHOW(200b); /* VM_ENTRY_MSR_LOAD_ADDR_HIGH      */
+BUILD_OFFSET_SHOW(2010); /* TSC_OFFSET                       */
+BUILD_OFFSET_SHOW(2011); /* TSC_OFFSET_HIGH                  */
+BUILD_OFFSET_SHOW(2012); /* VIRTUAL_APIC_PAGE_ADDR           */
+BUILD_OFFSET_SHOW(2013); /* VIRTUAL_APIC_PAGE_ADDR_HIGH      */
+BUILD_OFFSET_SHOW(2014); /* APIC_ACCESS_ADDR                 */
+BUILD_OFFSET_SHOW(2015); /* APIC_ACCESS_ADDR_HIGH            */
+BUILD_OFFSET_SHOW(201a); /* EPT_POINTER                      */
+BUILD_OFFSET_SHOW(201b); /* EPT_POINTER_HIGH                 */
+BUILD_OFFSET_SHOW(2400); /* GUEST_PHYSICAL_ADDRESS           */
+BUILD_OFFSET_SHOW(2401); /* GUEST_PHYSICAL_ADDRESS_HIGH      */
+BUILD_OFFSET_SHOW(2800); /* VMCS_LINK_POINTER                */
+BUILD_OFFSET_SHOW(2801); /* VMCS_LINK_POINTER_HIGH           */
+BUILD_OFFSET_SHOW(2802); /* GUEST_IA32_DEBUGCTL              */
+BUILD_OFFSET_SHOW(2803); /* GUEST_IA32_DEBUGCTL_HIGH         */
+BUILD_OFFSET_SHOW(2804); /* GUEST_IA32_PAT                   */
+BUILD_OFFSET_SHOW(2805); /* GUEST_IA32_PAT_HIGH              */
+BUILD_OFFSET_SHOW(2806); /* GUEST_IA32_EFER                  */
+BUILD_OFFSET_SHOW(2807); /* GUEST_IA32_EFER_HIGH             */
+BUILD_OFFSET_SHOW(2808); /* GUEST_IA32_PERF_GLOBAL_CTRL      */
+BUILD_OFFSET_SHOW(2809); /* GUEST_IA32_PERF_GLOBAL_CTRL_HIGH */
+BUILD_OFFSET_SHOW(280a); /* GUEST_PDPTR0                     */
+BUILD_OFFSET_SHOW(280b); /* GUEST_PDPTR0_HIGH                */
+BUILD_OFFSET_SHOW(280c); /* GUEST_PDPTR1                     */
+BUILD_OFFSET_SHOW(280d); /* GUEST_PDPTR1_HIGH                */
+BUILD_OFFSET_SHOW(280e); /* GUEST_PDPTR2                     */
+BUILD_OFFSET_SHOW(280f); /* GUEST_PDPTR2_HIGH                */
+BUILD_OFFSET_SHOW(2810); /* GUEST_PDPTR3                     */
+BUILD_OFFSET_SHOW(2811); /* GUEST_PDPTR3_HIGH                */
+BUILD_OFFSET_SHOW(2c00); /* HOST_IA32_PAT                    */
+BUILD_OFFSET_SHOW(2c01); /* HOST_IA32_PAT_HIGH               */
+BUILD_OFFSET_SHOW(2c02); /* HOST_IA32_EFER                   */
+BUILD_OFFSET_SHOW(2c03); /* HOST_IA32_EFER_HIGH              */
+BUILD_OFFSET_SHOW(2c04); /* HOST_IA32_PERF_GLOBAL_CTRL       */
+BUILD_OFFSET_SHOW(2c05); /* HOST_IA32_PERF_GLOBAL_CTRL_HIGH  */
+BUILD_OFFSET_SHOW(4000); /* PIN_BASED_VM_EXEC_CONTROL        */
+BUILD_OFFSET_SHOW(4002); /* CPU_BASED_VM_EXEC_CONTROL        */
+BUILD_OFFSET_SHOW(4004); /* EXCEPTION_BITMAP                 */
+BUILD_OFFSET_SHOW(4006); /* PAGE_FAULT_ERROR_CODE_MASK       */
+BUILD_OFFSET_SHOW(4008); /* PAGE_FAULT_ERROR_CODE_MATCH      */
+BUILD_OFFSET_SHOW(400a); /* CR3_TARGET_COUNT                 */
+BUILD_OFFSET_SHOW(400c); /* VM_EXIT_CONTROLS                 */
+BUILD_OFFSET_SHOW(400e); /* VM_EXIT_MSR_STORE_COUNT          */
+BUILD_OFFSET_SHOW(4010); /* VM_EXIT_MSR_LOAD_COUNT           */
+BUILD_OFFSET_SHOW(4012); /* VM_ENTRY_CONTROLS                */
+BUILD_OFFSET_SHOW(4014); /* VM_ENTRY_MSR_LOAD_COUNT          */
+BUILD_OFFSET_SHOW(4016); /* VM_ENTRY_INTR_INFO_FIELD         */
+BUILD_OFFSET_SHOW(4018); /* VM_ENTRY_EXCEPTION_ERROR_CODE    */
+BUILD_OFFSET_SHOW(401a); /* VM_ENTRY_INSTRUCTION_LEN         */
+BUILD_OFFSET_SHOW(401c); /* TPR_THRESHOLD                    */
+BUILD_OFFSET_SHOW(401e); /* SECONDARY_VM_EXEC_CONTROL        */
+BUILD_OFFSET_SHOW(4020); /* PLE_GAP                          */
+BUILD_OFFSET_SHOW(4022); /* PLE_WINDOW                       */
+BUILD_OFFSET_SHOW(4400); /* VM_INSTRUCTION_ERROR             */
+BUILD_OFFSET_SHOW(4402); /* VM_EXIT_REASON                   */
+BUILD_OFFSET_SHOW(4404); /* VM_EXIT_INTR_INFO                */
+BUILD_OFFSET_SHOW(4406); /* VM_EXIT_INTR_ERROR_CODE          */
+BUILD_OFFSET_SHOW(4408); /* IDT_VECTORING_INFO_FIELD         */
+BUILD_OFFSET_SHOW(440a); /* IDT_VECTORING_ERROR_CODE         */
+BUILD_OFFSET_SHOW(440c); /* VM_EXIT_INSTRUCTION_LEN          */
+BUILD_OFFSET_SHOW(440e); /* VMX_INSTRUCTION_INFO             */
+BUILD_OFFSET_SHOW(4800); /* GUEST_ES_LIMIT                   */
+BUILD_OFFSET_SHOW(4802); /* GUEST_CS_LIMIT                   */
+BUILD_OFFSET_SHOW(4804); /* GUEST_SS_LIMIT                   */
+BUILD_OFFSET_SHOW(4806); /* GUEST_DS_LIMIT                   */
+BUILD_OFFSET_SHOW(4808); /* GUEST_FS_LIMIT                   */
+BUILD_OFFSET_SHOW(480a); /* GUEST_GS_LIMIT                   */
+BUILD_OFFSET_SHOW(480c); /* GUEST_LDTR_LIMIT                 */
+BUILD_OFFSET_SHOW(480e); /* GUEST_TR_LIMIT                   */
+BUILD_OFFSET_SHOW(4810); /* GUEST_GDTR_LIMIT                 */
+BUILD_OFFSET_SHOW(4812); /* GUEST_IDTR_LIMIT                 */
+BUILD_OFFSET_SHOW(4814); /* GUEST_ES_AR_BYTES                */
+BUILD_OFFSET_SHOW(4816); /* GUEST_CS_AR_BYTES                */
+BUILD_OFFSET_SHOW(4818); /* GUEST_SS_AR_BYTES                */
+BUILD_OFFSET_SHOW(481a); /* GUEST_DS_AR_BYTES                */
+BUILD_OFFSET_SHOW(481c); /* GUEST_FS_AR_BYTES                */
+BUILD_OFFSET_SHOW(481e); /* GUEST_GS_AR_BYTES                */
+BUILD_OFFSET_SHOW(4820); /* GUEST_LDTR_AR_BYTES              */
+BUILD_OFFSET_SHOW(4822); /* GUEST_TR_AR_BYTES                */
+BUILD_OFFSET_SHOW(4824); /* GUEST_INTERRUPTIBILITY_INFO      */
+BUILD_OFFSET_SHOW(4826); /* GUEST_ACTIVITY_STATE             */
+BUILD_OFFSET_SHOW(482A); /* GUEST_SYSENTER_CS                */
+BUILD_OFFSET_SHOW(4c00); /* HOST_IA32_SYSENTER_CS            */
+BUILD_OFFSET_SHOW(6000); /* CR0_GUEST_HOST_MASK              */
+BUILD_OFFSET_SHOW(6002); /* CR4_GUEST_HOST_MASK              */
+BUILD_OFFSET_SHOW(6004); /* CR0_READ_SHADOW                  */
+BUILD_OFFSET_SHOW(6006); /* CR4_READ_SHADOW                  */
+BUILD_OFFSET_SHOW(6008); /* CR3_TARGET_VALUE0                */
+BUILD_OFFSET_SHOW(600a); /* CR3_TARGET_VALUE1                */
+BUILD_OFFSET_SHOW(600c); /* CR3_TARGET_VALUE2                */
+BUILD_OFFSET_SHOW(600e); /* CR3_TARGET_VALUE3                */
+BUILD_OFFSET_SHOW(6400); /* EXIT_QUALIFICATION               */
+BUILD_OFFSET_SHOW(640a); /* GUEST_LINEAR_ADDRESS             */
+BUILD_OFFSET_SHOW(6800); /* GUEST_CR0                        */
+BUILD_OFFSET_SHOW(6802); /* GUEST_CR3                        */
+BUILD_OFFSET_SHOW(6804); /* GUEST_CR4                        */
+BUILD_OFFSET_SHOW(6806); /* GUEST_ES_BASE                    */
+BUILD_OFFSET_SHOW(6808); /* GUEST_CS_BASE                    */
+BUILD_OFFSET_SHOW(680a); /* GUEST_SS_BASE                    */
+BUILD_OFFSET_SHOW(680c); /* GUEST_DS_BASE                    */
+BUILD_OFFSET_SHOW(680e); /* GUEST_FS_BASE                    */
+BUILD_OFFSET_SHOW(6810); /* GUEST_GS_BASE                    */
+BUILD_OFFSET_SHOW(6812); /* GUEST_LDTR_BASE                  */
+BUILD_OFFSET_SHOW(6814); /* GUEST_TR_BASE                    */
+BUILD_OFFSET_SHOW(6816); /* GUEST_GDTR_BASE                  */
+BUILD_OFFSET_SHOW(6818); /* GUEST_IDTR_BASE                  */
+BUILD_OFFSET_SHOW(681a); /* GUEST_DR7                        */
+BUILD_OFFSET_SHOW(681c); /* GUEST_RSP                        */
+BUILD_OFFSET_SHOW(681e); /* GUEST_RIP                        */
+BUILD_OFFSET_SHOW(6820); /* GUEST_RFLAGS                     */
+BUILD_OFFSET_SHOW(6822); /* GUEST_PENDING_DBG_EXCEPTIONS     */
+BUILD_OFFSET_SHOW(6824); /* GUEST_SYSENTER_ESP               */
+BUILD_OFFSET_SHOW(6826); /* GUEST_SYSENTER_EIP               */
+BUILD_OFFSET_SHOW(6c00); /* HOST_CR0                         */
+BUILD_OFFSET_SHOW(6c02); /* HOST_CR3                         */
+BUILD_OFFSET_SHOW(6c04); /* HOST_CR4                         */
+BUILD_OFFSET_SHOW(6c06); /* HOST_FS_BASE                     */
+BUILD_OFFSET_SHOW(6c08); /* HOST_GS_BASE                     */
+BUILD_OFFSET_SHOW(6c0a); /* HOST_TR_BASE                     */
+BUILD_OFFSET_SHOW(6c0c); /* HOST_GDTR_BASE                   */
+BUILD_OFFSET_SHOW(6c0e); /* HOST_IDTR_BASE                   */
+BUILD_OFFSET_SHOW(6c10); /* HOST_IA32_SYSENTER_ESP           */
+BUILD_OFFSET_SHOW(6c12); /* HOST_IA32_SYSENTER_EIP           */
+BUILD_OFFSET_SHOW(6c14); /* HOST_RSP                         */
+BUILD_OFFSET_SHOW(6c16); /* HOST_RIP                         */
+
+static struct attribute *vmcs_attrs[] = {
+	&dev_attr_0000.attr,
+	&dev_attr_0800.attr,
+	&dev_attr_0802.attr,
+	&dev_attr_0804.attr,
+	&dev_attr_0806.attr,
+	&dev_attr_0808.attr,
+	&dev_attr_080a.attr,
+	&dev_attr_080c.attr,
+	&dev_attr_080e.attr,
+	&dev_attr_0c00.attr,
+	&dev_attr_0c02.attr,
+	&dev_attr_0c04.attr,
+	&dev_attr_0c06.attr,
+	&dev_attr_0c08.attr,
+	&dev_attr_0c0a.attr,
+	&dev_attr_0c0c.attr,
+	&dev_attr_2000.attr,
+	&dev_attr_2001.attr,
+	&dev_attr_2002.attr,
+	&dev_attr_2003.attr,
+	&dev_attr_2004.attr,
+	&dev_attr_2005.attr,
+	&dev_attr_2006.attr,
+	&dev_attr_2007.attr,
+	&dev_attr_2008.attr,
+	&dev_attr_2009.attr,
+	&dev_attr_200a.attr,
+	&dev_attr_200b.attr,
+	&dev_attr_2010.attr,
+	&dev_attr_2011.attr,
+	&dev_attr_2012.attr,
+	&dev_attr_2013.attr,
+	&dev_attr_2014.attr,
+	&dev_attr_2015.attr,
+	&dev_attr_201a.attr,
+	&dev_attr_201b.attr,
+	&dev_attr_2400.attr,
+	&dev_attr_2401.attr,
+	&dev_attr_2800.attr,
+	&dev_attr_2801.attr,
+	&dev_attr_2802.attr,
+	&dev_attr_2803.attr,
+	&dev_attr_2804.attr,
+	&dev_attr_2805.attr,
+	&dev_attr_2806.attr,
+	&dev_attr_2807.attr,
+	&dev_attr_2808.attr,
+	&dev_attr_2809.attr,
+	&dev_attr_280a.attr,
+	&dev_attr_280b.attr,
+	&dev_attr_280c.attr,
+	&dev_attr_280d.attr,
+	&dev_attr_280e.attr,
+	&dev_attr_280f.attr,
+	&dev_attr_2810.attr,
+	&dev_attr_2811.attr,
+	&dev_attr_2c00.attr,
+	&dev_attr_2c01.attr,
+	&dev_attr_2c02.attr,
+	&dev_attr_2c03.attr,
+	&dev_attr_2c04.attr,
+	&dev_attr_2c05.attr,
+	&dev_attr_4000.attr,
+	&dev_attr_4002.attr,
+	&dev_attr_4004.attr,
+	&dev_attr_4006.attr,
+	&dev_attr_4008.attr,
+	&dev_attr_400a.attr,
+	&dev_attr_400c.attr,
+	&dev_attr_400e.attr,
+	&dev_attr_4010.attr,
+	&dev_attr_4012.attr,
+	&dev_attr_4014.attr,
+	&dev_attr_4016.attr,
+	&dev_attr_4018.attr,
+	&dev_attr_401a.attr,
+	&dev_attr_401c.attr,
+	&dev_attr_401e.attr,
+	&dev_attr_4020.attr,
+	&dev_attr_4022.attr,
+	&dev_attr_4400.attr,
+	&dev_attr_4402.attr,
+	&dev_attr_4404.attr,
+	&dev_attr_4406.attr,
+	&dev_attr_4408.attr,
+	&dev_attr_440a.attr,
+	&dev_attr_440c.attr,
+	&dev_attr_440e.attr,
+	&dev_attr_4800.attr,
+	&dev_attr_4802.attr,
+	&dev_attr_4804.attr,
+	&dev_attr_4806.attr,
+	&dev_attr_4808.attr,
+	&dev_attr_480a.attr,
+	&dev_attr_480c.attr,
+	&dev_attr_480e.attr,
+	&dev_attr_4810.attr,
+	&dev_attr_4812.attr,
+	&dev_attr_4814.attr,
+	&dev_attr_4816.attr,
+	&dev_attr_4818.attr,
+	&dev_attr_481a.attr,
+	&dev_attr_481c.attr,
+	&dev_attr_481e.attr,
+	&dev_attr_4820.attr,
+	&dev_attr_4822.attr,
+	&dev_attr_4824.attr,
+	&dev_attr_4826.attr,
+	&dev_attr_482A.attr,
+	&dev_attr_4c00.attr,
+	&dev_attr_6000.attr,
+	&dev_attr_6002.attr,
+	&dev_attr_6004.attr,
+	&dev_attr_6006.attr,
+	&dev_attr_6008.attr,
+	&dev_attr_600a.attr,
+	&dev_attr_600c.attr,
+	&dev_attr_600e.attr,
+	&dev_attr_6400.attr,
+	&dev_attr_640a.attr,
+	&dev_attr_6800.attr,
+	&dev_attr_6802.attr,
+	&dev_attr_6804.attr,
+	&dev_attr_6806.attr,
+	&dev_attr_6808.attr,
+	&dev_attr_680a.attr,
+	&dev_attr_680c.attr,
+	&dev_attr_680e.attr,
+	&dev_attr_6810.attr,
+	&dev_attr_6812.attr,
+	&dev_attr_6814.attr,
+	&dev_attr_6816.attr,
+	&dev_attr_6818.attr,
+	&dev_attr_681a.attr,
+	&dev_attr_681c.attr,
+	&dev_attr_681e.attr,
+	&dev_attr_6820.attr,
+	&dev_attr_6822.attr,
+	&dev_attr_6824.attr,
+	&dev_attr_6826.attr,
+	&dev_attr_6c00.attr,
+	&dev_attr_6c02.attr,
+	&dev_attr_6c04.attr,
+	&dev_attr_6c06.attr,
+	&dev_attr_6c08.attr,
+	&dev_attr_6c0a.attr,
+	&dev_attr_6c0c.attr,
+	&dev_attr_6c0e.attr,
+	&dev_attr_6c10.attr,
+	&dev_attr_6c12.attr,
+	&dev_attr_6c14.attr,
+	&dev_attr_6c16.attr,
+	NULL,
+};
+
+static struct attribute_group vmcs_attr_group = {
+	.name = vmcs_group_name,
+	.attrs = vmcs_attrs,
+};
+
+int vmcs_sysfs_add(struct device *dev)
+{
+	return sysfs_create_group(&dev->kobj, &vmcs_attr_group);
+}
+
+void vmcs_sysfs_remove(struct device *dev)
+{
+	sysfs_remove_group(&dev->kobj, &vmcs_attr_group);
+}
-- 
1.7.1
