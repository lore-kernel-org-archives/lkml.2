Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045Ab2GDKWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 06:22:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50868 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754966Ab2GDKWK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 06:22:10 -0400
X-IronPort-AV: E=Sophos;i="4.77,522,1336320000"; 
   d="scan'208";a="5328240"
Message-ID: <4FF4155F.6070508@cn.fujitsu.com>
Date: Wed, 04 Jul 2012 18:05:19 +0800
From: Yanfei Zhang <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com
CC: ebiederm@xmission.com, luto@mit.edu, Joerg Roedel <joerg.roedel@amd.com>,
        dzickus@redhat.com, paul.gortmaker@windriver.com,
        ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH v4 2/3] KVM-INTEL: Add new module vmcsinfo-intel to fill VMCSINFO
References: <4FF413D2.4030006@cn.fujitsu.com>
In-Reply-To: <4FF413D2.4030006@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/04 18:08:29,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/04 18:22:09
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a new module named vmcsinfo-intel. The
module fills VMCSINFO with the VMCS revision identifier,
and offsets of VMCS fields.

Note, offsets of fields that defined in Intel specification
(Intel® 64 and IA-32 Architectures Software Developer’s Manual,
Volume 3C) but not defined in *vmcs_field* will not be filled in
VMCSINFO. And, some fields may be unsupported in some machines,
in these machines, corresponding offsets will be zero.

Besides, this patch also exports vmcs revision identifier via
/sys/devices/system/cpu/vmcs_id and offsets of fields via
/sys/devices/system/cpu/vmcs/.
Individual offsets are contained in subfiles named by the filed's
encoding, e.g.: /sys/devices/cpu/vmcs/0800

Signed-off-by: zhangyanfei <zhangyanfei@cn.fujitsu.com>
---
 arch/x86/kvm/Kconfig    |   11 +
 arch/x86/kvm/Makefile   |    3 +
 arch/x86/kvm/vmcsinfo.c |  586 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 600 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kvm/vmcsinfo.c

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index a28f338..1dd64b1 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -63,6 +63,17 @@ config KVM_INTEL
 	  To compile this as a module, choose M here: the module
 	  will be called kvm-intel.
 
+config VMCSINFO_INTEL
+	tristate "Export VMCSINFO for Intel processors"
+	depends on KVM_INTEL
+	---help---
+	  Provides support for exporting VMCSINFO on Intel processors equipped
+	  with the VT extensions. The VMCSINFO contains a VMCS revision
+	  identifier and offsets of VMCS fields.
+
+	  To compile this as a module, choose M here: the module
+	  will be called vmcsinfo-intel.
+
 config KVM_AMD
 	tristate "KVM for AMD processors support"
 	depends on KVM
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 4f579e8..12a1ef6 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -4,6 +4,7 @@ ccflags-y += -Ivirt/kvm -Iarch/x86/kvm
 CFLAGS_x86.o := -I.
 CFLAGS_svm.o := -I.
 CFLAGS_vmx.o := -I.
+CFLAGS_vmcsinfo.o := -I.
 
 kvm-y			+= $(addprefix ../../../virt/kvm/, kvm_main.o ioapic.o \
 				coalesced_mmio.o irq_comm.o eventfd.o \
@@ -15,7 +16,9 @@ kvm-y			+= x86.o mmu.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o timer.o cpuid.o pmu.o
 kvm-intel-y		+= vmx.o
 kvm-amd-y		+= svm.o
+vmcsinfo-intel-y	+= vmcsinfo.o
 
 obj-$(CONFIG_KVM)	+= kvm.o
 obj-$(CONFIG_KVM_INTEL)	+= kvm-intel.o
 obj-$(CONFIG_KVM_AMD)	+= kvm-amd.o
+obj-$(CONFIG_VMCSINFO_INTEL)	+= vmcsinfo-intel.o
diff --git a/arch/x86/kvm/vmcsinfo.c b/arch/x86/kvm/vmcsinfo.c
new file mode 100644
index 0000000..bff6a1e
--- /dev/null
+++ b/arch/x86/kvm/vmcsinfo.c
@@ -0,0 +1,586 @@
+/*
+ * Kernel-based Virtual Machine driver for Linux
+ *
+ * This module enables machines with Intel VT-x extensions to export
+ * offsets of VMCS fields for guest debugging.
+ *
+ * Copyright (C) 2012 Fujitsu, Inc.
+ *
+ * Authors:
+ *   Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/mod_devicetable.h>
+#include <linux/device.h>
+#include <linux/swab.h>
+#include <linux/cpu.h>
+
+#include <asm/vmx.h>
+
+MODULE_AUTHOR("Fujitsu");
+MODULE_LICENSE("GPL");
+
+static const struct x86_cpu_id vmcsinfo_cpu_id[] = {
+	X86_FEATURE_MATCH(X86_FEATURE_VMX),
+	{}
+};
+MODULE_DEVICE_TABLE(x86cpu, vmcsinfo_cpu_id);
+
+/*
+ * vmcs field offsets.
+ */
+static struct vmcsinfo {
+	u32 vmcs_revision_id;
+	u16 vmcs_field_to_offset_table[HOST_RIP + 1];
+} vmcsinfo;
+
+#define VMCSINFO_MAX_FIELD \
+	ARRAY_SIZE(vmcsinfo.vmcs_field_to_offset_table)
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
+static inline short get_vmcs_field_offset(unsigned long field)
+{
+	if (field >= VMCSINFO_MAX_FIELD ||
+	    vmcsinfo.vmcs_field_to_offset_table[field] == 0)
+		return -1;
+	return vmcsinfo.vmcs_field_to_offset_table[field];
+}
+
+const char vmcs_group_name[] = "vmcs";
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
+
+static ssize_t vmcs_id_show(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	return sprintf(buf, "%d\n", vmcsinfo.vmcs_revision_id);
+}
+
+static DEVICE_ATTR(vmcs_id, 0444, vmcs_id_show, NULL);
+
+int vmcs_id_sysfs_add(struct device *dev)
+{
+	return device_create_file(dev, &dev_attr_vmcs_id);
+}
+
+void vmcs_id_sysfs_remove(struct device *dev)
+{
+	device_remove_file(dev, &dev_attr_vmcs_id);
+}
+
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
+ * DECODING_OFFSET: decode the index of this kind into real offset.
+ */
+#define OFFSET_HIGH_SHIFT (7)
+#define OFFSET_LOW_MASK   ((1 << OFFSET_HIGH_SHIFT) - 1) /* 0x7f */
+#define OFFSET_HIGH_MASK  (OFFSET_LOW_MASK << OFFSET_HIGH_SHIFT) /* 0x3f80 */
+#define ENCODING_OFFSET(offset)                                     \
+	((((offset) & OFFSET_LOW_MASK) << 1) +                      \
+	((((offset) & OFFSET_HIGH_MASK) << 2) | 0x100))
+/*
+ * index here should be always read in little endian mode.
+ */
+#define DECODING_OFFSET_LE(index)                                   \
+	((((index) >> 1) & OFFSET_LOW_MASK) +                       \
+	(((index) >> 2) & OFFSET_HIGH_MASK))
+/*
+ * n indicates the bits of index. We first check if index
+ * is read in big endian mode.
+ */
+#define DECODING_OFFSET(index, n)                                   \
+	((index & 1) ? (DECODING_OFFSET_LE(__swab##n(index))) :     \
+	(DECODING_OFFSET_LE(index)))
+
+#define FIELD_OFFSET16(field, offset)                               \
+	vmcsinfo_field(field, DECODING_OFFSET(offset, 16))
+#define FIELD_OFFSET64(field, offset)                               \
+	vmcsinfo_field(field, DECODING_OFFSET(offset, 64))
+#define FIELD_OFFSET32(field, offset)                               \
+	vmcsinfo_field(field, DECODING_OFFSET(offset, 32))
+#define FIELD_OFFSETNW(field, offset)                               \
+do {                                                                \
+	if (sizeof(offset) == 8)                                    \
+		vmcsinfo_field(field, DECODING_OFFSET(offset, 64)); \
+	else                                                        \
+		vmcsinfo_field(field, DECODING_OFFSET(offset, 32)); \
+} while (0)
+
+#define VMCS_FIELD_CHECK(field, offset, type)                       \
+do {                                                                \
+	if (vmcs_read32(VM_INSTRUCTION_ERROR) !=                    \
+		VMXERR_UNSUPPORTED_VMCS_COMPONENT)                  \
+		FIELD_OFFSET##type(field, offset);                  \
+} while (0)
+
+static inline void vmcs_read_checking(unsigned long field)
+{
+	u16 offset16;
+	u64 offset64;
+	u32 offset32;
+	unsigned long offsetnw;
+
+	switch (vmcs_field_type(field)) {
+	case VMCS_FIELD_TYPE_U16:
+		offset16 = vmcs_read16(field);
+		VMCS_FIELD_CHECK(field, offset16, 16);
+		break;
+	case VMCS_FIELD_TYPE_U64:
+		offset64 = vmcs_read64(field);
+		VMCS_FIELD_CHECK(field, offset64, 64);
+		break;
+	case VMCS_FIELD_TYPE_U32:
+		offset32 = vmcs_read32(field);
+		VMCS_FIELD_CHECK(field, offset32, 32);
+		break;
+	case VMCS_FIELD_TYPE_NATURAL_WIDTH:
+		offsetnw = vmcs_readl(field);
+		VMCS_FIELD_CHECK(field, offsetnw, NW);
+		break;
+	}
+}
+
+/*
+ * Note, offsets of fields below will not be filled into
+ * VMCSINFO:
+ * 1. fields defined in Intel specification (Intel® 64 and
+ *    IA-32 Architectures Software Developer’s Manual, Volume
+ *    3C) but not defined in *vmcs_field*.
+ * 2. fields unsupported.
+ */
+static int __init alloc_vmcsinfo_init(void)
+{
+/*
+ * The first 8 bytes in vmcs region are for
+ *   VMCS revision identifier
+ *   VMX-abort indicator
+ */
+#define FIELD_START (8)
+
+	int r, offset;
+	struct vmcs *vmcs;
+	int cpu;
+	unsigned long field;
+
+	vmcs = alloc_vmcs();
+	if (!vmcs) {
+		return -ENOMEM;
+	}
+
+	r = hardware_enable_all();
+	if (r)
+		goto out;
+
+	/*
+	 * Write encoded offsets into VMCS data for later vmcs_read.
+	 */
+	for (offset = FIELD_START; offset < vmcs_config.size;
+	     offset += sizeof(u16))
+		*(u16 *)((char *)vmcs + offset) = ENCODING_OFFSET(offset);
+
+	cpu = get_cpu();
+	vmcs_clear(vmcs);
+	per_cpu(current_vmcs, cpu) = vmcs;
+	vmcs_load(vmcs);
+
+	vmcsinfo_revision_id(vmcs->revision_id);
+	vmcs_read_checking(VM_INSTRUCTION_ERROR);
+	offset = get_vmcs_field_offset(VM_INSTRUCTION_ERROR);
+	if (offset == -1)
+		goto out_clear;
+
+	for (field = 0; field < VMCSINFO_MAX_FIELD; ++field) {
+		if (field == VM_INSTRUCTION_ERROR)
+			continue;
+		/*
+		 * Before each reading, zeroed field VM_INSTRUCTION_ERROR
+		 */
+		*(u32 *)((char *)vmcs + offset) = 0;
+		vmcs_read_checking(field);
+	}
+
+	r = vmcs_id_sysfs_add(cpu_subsys.dev_root);
+	if (r)
+		goto out_clear;
+	r = vmcs_sysfs_add(cpu_subsys.dev_root);
+	if (r)
+		vmcs_id_sysfs_remove(cpu_subsys.dev_root);
+
+out_clear:
+	vmcs_clear(vmcs);
+	put_cpu();
+	hardware_disable_all();
+out:
+	free_vmcs(vmcs);
+	return r;
+}
+
+static void __exit alloc_vmcsinfo_exit(void)
+{
+	vmcs_sysfs_remove(cpu_subsys.dev_root);
+	vmcs_id_sysfs_remove(cpu_subsys.dev_root);
+}
+
+module_init(alloc_vmcsinfo_init);
+module_exit(alloc_vmcsinfo_exit);
-- 
1.7.1
