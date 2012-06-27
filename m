Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab2F0I5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 04:57:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:3399 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab2F0I5d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 04:57:33 -0400
X-IronPort-AV: E=Sophos;i="4.77,483,1336320000"; 
   d="scan'208";a="5273733"
Message-ID: <4FEACA37.5060905@cn.fujitsu.com>
Date: Wed, 27 Jun 2012 16:54:15 +0800
From: Yanfei Zhang <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com
CC: ebiederm@xmission.com, luto@mit.edu, Joerg Roedel <joerg.roedel@amd.com>,
        dzickus@redhat.com, paul.gortmaker@windriver.com,
        ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH v3 3/5] KVM-INTEL: Add new module vmcsinfo-intel to fill VMCSINFO
References: <4FEAC945.50700@cn.fujitsu.com>
In-Reply-To: <4FEAC945.50700@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/27 16:57:40,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/27 16:57:43
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a new module named vmcsinfo-intel. The
module fills VMCSINFO with the VMCS revision identifier,
and offsets of VMCS fields.

Note, offsets of fields below will not be filled into VMCSINFO:
1. fields defined in Intel specification (Intel® 64 and
   IA-32 Architectures Software Developer’s Manual, Volume
   3C) but not defined in *vmcs_field*.
2. fields unsupported.

Signed-off-by: zhangyanfei <zhangyanfei@cn.fujitsu.com>
---
 arch/x86/kvm/Kconfig    |   11 +++
 arch/x86/kvm/Makefile   |    3 +
 arch/x86/kvm/vmcsinfo.c |  198 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 212 insertions(+), 0 deletions(-)
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
index 0000000..7b1873c
--- /dev/null
+++ b/arch/x86/kvm/vmcsinfo.c
@@ -0,0 +1,198 @@
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
+#include <linux/swab.h>
+
+#include <asm/vmx.h>
+#include <asm/vmcsinfo.h>
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
+	if (vmcsinfo_is_filled())
+		return 0;
+
+	vmcs = alloc_vmcs();
+	if (!vmcs) {
+		return -ENOMEM;
+	}
+
+	r = hardware_enable_all();
+	if (r)
+		goto out_err;
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
+	vmcsinfo_filled();
+
+	update_vmcsinfo_note();
+
+out_clear:
+	vmcs_clear(vmcs);
+	put_cpu();
+
+out_err:
+	free_vmcs(vmcs);
+	return r;
+}
+
+static void __exit alloc_vmcsinfo_exit(void)
+{
+	hardware_disable_all();
+}
+
+module_init(alloc_vmcsinfo_init);
+module_exit(alloc_vmcsinfo_exit);
-- 
1.7.1

