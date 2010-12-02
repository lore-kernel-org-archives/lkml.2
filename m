Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319Ab0LBIFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 03:05:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:47984 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385Ab0LBIFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 03:05:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,287,1288594800"; 
   d="scan'208";a="632307529"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -v3 3/4] ACPI, APEI, Add APEI generic error status printing support
Date: Thu,  2 Dec 2010 16:05:04 +0800
Message-Id: <1291277105-31758-4-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1291277105-31758-1-git-send-email-ying.huang@intel.com>
References: <1291277105-31758-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In APEI, Hardware error information reported by firmware to Linux
kernel is in the data structure of APEI generic error status (struct
acpi_hes_generic_status).  While now printk is used by Linux kernel to
report hardware error information to user space.

So, this patch adds printing support for the data structure, so that
the corresponding hardware error information can be reported to user
space via printk.

PCIe AER information printing is not implemented yet.  Will refactor the
original PCIe AER information printing code to avoid code duplicating.

The output format is as follow:

<error record> :=
APEI generic hardware error status
severity: <integer>, <severity string>
section: <integer>, severity: <integer>, <severity string>
flags: <integer>
<section flags strings>
fru_id: <uuid string>
fru_text: <string>
section_type: <section type string>
<section data>

<severity string>* := recoverable | fatal | corrected | info

<section flags strings># :=
[primary][, containment warning][, reset][, threshold exceeded]\
[, resource not accessible][, latent error]

<section type string> := generic processor error | memory error | \
PCIe error | unknown, <uuid string>

<section data> :=
<generic processor section data> | <memory section data> | \
<pcie section data> | <null>

<generic processor section data> :=
[processor_type: <integer>, <proc type string>]
[processor_isa: <integer>, <proc isa string>]
[error_type: <integer>
<proc error type strings>]
[operation: <integer>, <proc operation string>]
[flags: <integer>
<proc flags strings>]
[level: <integer>]
[version_info: <integer>]
[processor_id: <integer>]
[target_address: <integer>]
[requestor_id: <integer>]
[responder_id: <integer>]
[IP: <integer>]

<proc type string>* := IA32/X64 | IA64

<proc isa string>* := IA32 | IA64 | X64

<processor error type strings># :=
[cache error][, TLB error][, bus error][, micro-architectural error]

<proc operation string>* := unknown or generic | data read | data write | \
instruction execution

<proc flags strings># :=
[restartable][, precise IP][, overflow][, corrected]

<memory section data> :=
[error_status: <integer>]
[physical_address: <integer>]
[physical_address_mask: <integer>]
[node: <integer>]
[card: <integer>]
[module: <integer>]
[bank: <integer>]
[device: <integer>]
[row: <integer>]
[column: <integer>]
[bit_position: <integer>]
[requestor_id: <integer>]
[responder_id: <integer>]
[target_id: <integer>]
[error_type: <integer>, <mem error type string>]

<mem error type string>* :=
unknown | no error | single-bit ECC | multi-bit ECC | \
single-symbol chipkill ECC | multi-symbol chipkill ECC | master abort | \
target abort | parity error | watchdog timeout | invalid address | \
mirror Broken | memory sparing | scrub corrected error | \
scrub uncorrected error

<pcie section data> :=
[port_type: <integer>, <pcie port type string>]
[version: <integer>.<integer>]
[command: <integer>, status: <integer>]
[device_id: <integer>:<integer>:<integer>.<integer>
slot: <integer>
secondary_bus: <integer>
vendor_id: <integer>, device_id: <integer>
class_code: <integer>]
[serial number: <integer>, <integer>]
[bridge: secondary_status: <integer>, control: <integer>]

<pcie port type string>* := PCIe end point | legacy PCI end point | \
unknown | unknown | root port | upstream switch port | \
downstream switch port | PCIe to PCI/PCI-X bridge | \
PCI/PCI-X to PCIe bridge | root complex integrated endpoint device | \
root complex event collector

Where, [] designate corresponding content is optional

All <field string> description with * has the following format:

field: <integer>, <field string>

Where value of <integer> should be the position of "string" in <field
string> description. Otherwise, <field string> will be "unknown".

All <field strings> description with # has the following format:

field: <integer>
<field strings>

Where each string in <fields strings> corresponding to one set bit of
<integer>. The bit position is the position of "string" in <field
strings> description.

For more detailed explanation of every field, please refer to UEFI
specification version 2.3 or later, section Appendix N: Common
Platform Error Record.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 Documentation/acpi/apei/output_format.txt |  122 +++++++++++
 drivers/acpi/apei/apei-internal.h         |    2 
 drivers/acpi/apei/cper.c                  |  309 ++++++++++++++++++++++++++++++
 3 files changed, 433 insertions(+)
 create mode 100644 Documentation/acpi/apei/output_format.txt

--- /dev/null
+++ b/Documentation/acpi/apei/output_format.txt
@@ -0,0 +1,122 @@
+                     APEI output format
+                     ~~~~~~~~~~~~~~~~~~
+
+APEI uses printk as hardware error reporting interface, the output
+format is as follow.
+
+<error record> :=
+APEI generic hardware error status
+severity: <integer>, <severity string>
+section: <integer>, severity: <integer>, <severity string>
+flags: <integer>
+<section flags strings>
+fru_id: <uuid string>
+fru_text: <string>
+section_type: <section type string>
+<section data>
+
+<severity string>* := recoverable | fatal | corrected | info
+
+<section flags strings># :=
+[primary][, containment warning][, reset][, threshold exceeded]\
+[, resource not accessible][, latent error]
+
+<section type string> := generic processor error | memory error | \
+PCIe error | unknown, <uuid string>
+
+<section data> :=
+<generic processor section data> | <memory section data> | \
+<pcie section data> | <null>
+
+<generic processor section data> :=
+[processor_type: <integer>, <proc type string>]
+[processor_isa: <integer>, <proc isa string>]
+[error_type: <integer>
+<proc error type strings>]
+[operation: <integer>, <proc operation string>]
+[flags: <integer>
+<proc flags strings>]
+[level: <integer>]
+[version_info: <integer>]
+[processor_id: <integer>]
+[target_address: <integer>]
+[requestor_id: <integer>]
+[responder_id: <integer>]
+[IP: <integer>]
+
+<proc type string>* := IA32/X64 | IA64
+
+<proc isa string>* := IA32 | IA64 | X64
+
+<processor error type strings># :=
+[cache error][, TLB error][, bus error][, micro-architectural error]
+
+<proc operation string>* := unknown or generic | data read | data write | \
+instruction execution
+
+<proc flags strings># :=
+[restartable][, precise IP][, overflow][, corrected]
+
+<memory section data> :=
+[error_status: <integer>]
+[physical_address: <integer>]
+[physical_address_mask: <integer>]
+[node: <integer>]
+[card: <integer>]
+[module: <integer>]
+[bank: <integer>]
+[device: <integer>]
+[row: <integer>]
+[column: <integer>]
+[bit_position: <integer>]
+[requestor_id: <integer>]
+[responder_id: <integer>]
+[target_id: <integer>]
+[error_type: <integer>, <mem error type string>]
+
+<mem error type string>* :=
+unknown | no error | single-bit ECC | multi-bit ECC | \
+single-symbol chipkill ECC | multi-symbol chipkill ECC | master abort | \
+target abort | parity error | watchdog timeout | invalid address | \
+mirror Broken | memory sparing | scrub corrected error | \
+scrub uncorrected error
+
+<pcie section data> :=
+[port_type: <integer>, <pcie port type string>]
+[version: <integer>.<integer>]
+[command: <integer>, status: <integer>]
+[device_id: <integer>:<integer>:<integer>.<integer>
+slot: <integer>
+secondary_bus: <integer>
+vendor_id: <integer>, device_id: <integer>
+class_code: <integer>]
+[serial number: <integer>, <integer>]
+[bridge: secondary_status: <integer>, control: <integer>]
+
+<pcie port type string>* := PCIe end point | legacy PCI end point | \
+unknown | unknown | root port | upstream switch port | \
+downstream switch port | PCIe to PCI/PCI-X bridge | \
+PCI/PCI-X to PCIe bridge | root complex integrated endpoint device | \
+root complex event collector
+
+Where, [] designate corresponding content is optional
+
+All <field string> description with * has the following format:
+
+field: <integer>, <field string>
+
+Where value of <integer> should be the position of "string" in <field
+string> description. Otherwise, <field string> will be "unknown".
+
+All <field strings> description with # has the following format:
+
+field: <integer>
+<field strings>
+
+Where each string in <fields strings> corresponding to one set bit of
+<integer>. The bit position is the position of "string" in <field
+strings> description.
+
+For more detailed explanation of every field, please refer to UEFI
+specification version 2.3 or later, section Appendix N: Common
+Platform Error Record.
--- a/drivers/acpi/apei/apei-internal.h
+++ b/drivers/acpi/apei/apei-internal.h
@@ -109,6 +109,8 @@ static inline u32 apei_estatus_len(struc
 		return sizeof(*estatus) + estatus->data_length;
 }
 
+void apei_estatus_print(const char *pfx,
+			const struct acpi_hest_generic_status *estatus);
 int apei_estatus_check_header(const struct acpi_hest_generic_status *estatus);
 int apei_estatus_check(const struct acpi_hest_generic_status *estatus);
 #endif
--- a/drivers/acpi/apei/cper.c
+++ b/drivers/acpi/apei/cper.c
@@ -46,6 +46,315 @@ u64 cper_next_record_id(void)
 }
 EXPORT_SYMBOL_GPL(cper_next_record_id);
 
+static const char *cper_severity_strs[] = {
+	"recoverable",
+	"fatal",
+	"corrected",
+	"info",
+};
+
+static const char *cper_severity_str(unsigned int severity)
+{
+	return severity < ARRAY_SIZE(cper_severity_strs) ?
+		cper_severity_strs[severity] : "unknown";
+}
+
+/*
+ * cper_print_bits - print strings for set bits
+ * @pfx: prefix for each line, including log level and prefix string
+ * @bits: bit mask
+ * @strs: string array, indexed by bit position
+ * @strs_size: size of the string array: @strs
+ *
+ * For each set bit in @bits, print the corresponding string in @strs.
+ * If the output length is longer than 80, multiple line will be
+ * printed, with @pfx is printed at the beginning of each line.
+ */
+static void cper_print_bits(const char *pfx, unsigned int bits,
+			    const char *strs[], unsigned int strs_size)
+{
+	int i, len = 0;
+	const char *str;
+	char buf[84];
+
+	for (i = 0; i < strs_size; i++) {
+		if (!(bits & (1U << i)))
+			continue;
+		str = strs[i];
+		if (len && len + strlen(str) + 2 > 80) {
+			printk("%s\n", buf);
+			len = 0;
+		}
+		if (!len)
+			len = snprintf(buf, sizeof(buf), "%s%s", pfx, str);
+		else
+			len += snprintf(buf+len, sizeof(buf)-len, ", %s", str);
+	}
+	if (len)
+		printk("%s\n", buf);
+}
+
+static const char *cper_proc_type_strs[] = {
+	"IA32/X64",
+	"IA64",
+};
+
+static const char *cper_proc_isa_strs[] = {
+	"IA32",
+	"IA64",
+	"X64",
+};
+
+static const char *cper_proc_error_type_strs[] = {
+	"cache error",
+	"TLB error",
+	"bus error",
+	"micro-architectural error",
+};
+
+static const char *cper_proc_op_strs[] = {
+	"unknown or generic",
+	"data read",
+	"data write",
+	"instruction execution",
+};
+
+static const char *cper_proc_flag_strs[] = {
+	"restartable",
+	"precise IP",
+	"overflow",
+	"corrected",
+};
+
+static void cper_print_proc_generic(const char *pfx,
+				    const struct cper_sec_proc_generic *proc)
+{
+	if (proc->validation_bits & CPER_PROC_VALID_TYPE)
+		pr_pfx(pfx, "processor_type: %d, %s\n", proc->proc_type,
+			proc->proc_type < ARRAY_SIZE(cper_proc_type_strs) ?
+			cper_proc_type_strs[proc->proc_type] : "unknown");
+	if (proc->validation_bits & CPER_PROC_VALID_ISA)
+		pr_pfx(pfx, "processor_isa: %d, %s\n", proc->proc_isa,
+			proc->proc_isa < ARRAY_SIZE(cper_proc_isa_strs) ?
+			cper_proc_isa_strs[proc->proc_isa] : "unknown");
+	if (proc->validation_bits & CPER_PROC_VALID_ERROR_TYPE) {
+		pr_pfx(pfx, "error_type: 0x%02x\n", proc->proc_error_type);
+		cper_print_bits(pfx, proc->proc_error_type,
+				cper_proc_error_type_strs,
+				ARRAY_SIZE(cper_proc_error_type_strs));
+	}
+	if (proc->validation_bits & CPER_PROC_VALID_OPERATION)
+		pr_pfx(pfx, "operation: %d, %s\n", proc->operation,
+		       proc->operation < ARRAY_SIZE(cper_proc_op_strs) ?
+		       cper_proc_op_strs[proc->operation] : "unknown");
+	if (proc->validation_bits & CPER_PROC_VALID_FLAGS) {
+		pr_pfx(pfx, "flags: 0x%02x\n", proc->flags);
+		cper_print_bits(pfx, proc->flags, cper_proc_flag_strs,
+				ARRAY_SIZE(cper_proc_flag_strs));
+	}
+	if (proc->validation_bits & CPER_PROC_VALID_LEVEL)
+		pr_pfx(pfx, "level: %d\n", proc->level);
+	if (proc->validation_bits & CPER_PROC_VALID_VERSION)
+		pr_pfx(pfx, "version_info: 0x%016llx\n", proc->cpu_version);
+	if (proc->validation_bits & CPER_PROC_VALID_ID)
+		pr_pfx(pfx, "processor_id: 0x%016llx\n", proc->proc_id);
+	if (proc->validation_bits & CPER_PROC_VALID_TARGET_ADDRESS)
+		pr_pfx(pfx, "target_address: 0x%016llx\n",
+		       proc->target_addr);
+	if (proc->validation_bits & CPER_PROC_VALID_REQUESTOR_ID)
+		pr_pfx(pfx, "requestor_id: 0x%016llx\n", proc->requestor_id);
+	if (proc->validation_bits & CPER_PROC_VALID_RESPONDER_ID)
+		pr_pfx(pfx, "responder_id: 0x%016llx\n", proc->responder_id);
+	if (proc->validation_bits & CPER_PROC_VALID_IP)
+		pr_pfx(pfx, "IP: 0x%016llx\n", proc->ip);
+}
+
+static const char *cper_mem_err_type_strs[] = {
+	"unknown",
+	"no error",
+	"single-bit ECC",
+	"multi-bit ECC",
+	"single-symbol chipkill ECC",
+	"multi-symbol chipkill ECC",
+	"master abort",
+	"target abort",
+	"parity error",
+	"watchdog timeout",
+	"invalid address",
+	"mirror Broken",
+	"memory sparing",
+	"scrub corrected error",
+	"scrub uncorrected error",
+};
+
+static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err *mem)
+{
+	if (mem->validation_bits & CPER_MEM_VALID_ERROR_STATUS)
+		pr_pfx(pfx, "error_status: 0x%016llx\n", mem->error_status);
+	if (mem->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS)
+		pr_pfx(pfx, "physical_address: 0x%016llx\n",
+		       mem->physical_addr);
+	if (mem->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS_MASK)
+		pr_pfx(pfx, "physical_address_mask: 0x%016llx\n",
+		       mem->physical_addr_mask);
+	if (mem->validation_bits & CPER_MEM_VALID_NODE)
+		pr_pfx(pfx, "node: %d\n", mem->node);
+	if (mem->validation_bits & CPER_MEM_VALID_CARD)
+		pr_pfx(pfx, "card: %d\n", mem->card);
+	if (mem->validation_bits & CPER_MEM_VALID_MODULE)
+		pr_pfx(pfx, "module: %d\n", mem->module);
+	if (mem->validation_bits & CPER_MEM_VALID_BANK)
+		pr_pfx(pfx, "bank: %d\n", mem->bank);
+	if (mem->validation_bits & CPER_MEM_VALID_DEVICE)
+		pr_pfx(pfx, "device: %d\n", mem->device);
+	if (mem->validation_bits & CPER_MEM_VALID_ROW)
+		pr_pfx(pfx, "row: %d\n", mem->row);
+	if (mem->validation_bits & CPER_MEM_VALID_COLUMN)
+		pr_pfx(pfx, "column: %d\n", mem->column);
+	if (mem->validation_bits & CPER_MEM_VALID_BIT_POSITION)
+		pr_pfx(pfx, "bit_position: %d\n", mem->bit_pos);
+	if (mem->validation_bits & CPER_MEM_VALID_REQUESTOR_ID)
+		pr_pfx(pfx, "requestor_id: 0x%016llx\n", mem->requestor_id);
+	if (mem->validation_bits & CPER_MEM_VALID_RESPONDER_ID)
+		pr_pfx(pfx, "responder_id: 0x%016llx\n", mem->responder_id);
+	if (mem->validation_bits & CPER_MEM_VALID_TARGET_ID)
+		pr_pfx(pfx, "target_id: 0x%016llx\n", mem->target_id);
+	if (mem->validation_bits & CPER_MEM_VALID_ERROR_TYPE) {
+		u8 etype = mem->error_type;
+		pr_pfx(pfx, "error_type: %d, %s\n", etype,
+		       etype < ARRAY_SIZE(cper_mem_err_type_strs) ?
+		       cper_mem_err_type_strs[etype] : "unknown");
+	}
+}
+
+static const char *cper_pcie_port_type_strs[] = {
+	"PCIe end point",
+	"legacy PCI end point",
+	"unknown",
+	"unknown",
+	"root port",
+	"upstream switch port",
+	"downstream switch port",
+	"PCIe to PCI/PCI-X bridge",
+	"PCI/PCI-X to PCIe bridge",
+	"root complex integrated endpoint device",
+	"root complex event collector",
+};
+
+static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie)
+{
+	if (pcie->validation_bits & CPER_PCIE_VALID_PORT_TYPE)
+		pr_pfx(pfx, "port_type: %d, %s\n", pcie->port_type,
+		       pcie->port_type < ARRAY_SIZE(cper_pcie_port_type_strs) ?
+		       cper_pcie_port_type_strs[pcie->port_type] : "unknown");
+	if (pcie->validation_bits & CPER_PCIE_VALID_VERSION)
+		pr_pfx(pfx, "version: %d.%d\n",
+		       pcie->version.major, pcie->version.minor);
+	if (pcie->validation_bits & CPER_PCIE_VALID_COMMAND_STATUS)
+		pr_pfx(pfx, "command: 0x%04x, status: 0x%04x\n",
+		       pcie->command, pcie->status);
+	if (pcie->validation_bits & CPER_PCIE_VALID_DEVICE_ID) {
+		const __u8 *p;
+		pr_pfx(pfx, "device_id: %04x:%02x:%02x.%x\n",
+		       pcie->device_id.segment, pcie->device_id.bus,
+		       pcie->device_id.device, pcie->device_id.function);
+		pr_pfx(pfx, "slot: %d\n",
+		       pcie->device_id.slot >> CPER_PCIE_SLOT_SHIFT);
+		pr_pfx(pfx, "secondary_bus: 0x%02x\n",
+		       pcie->device_id.secondary_bus);
+		pr_pfx(pfx, "vendor_id: 0x%04x, device_id: 0x%04x\n",
+		       pcie->device_id.vendor_id, pcie->device_id.device_id);
+		p = pcie->device_id.class_code;
+		pr_pfx(pfx, "class_code: %02x%02x%02x\n", p[0], p[1], p[2]);
+	}
+	if (pcie->validation_bits & CPER_PCIE_VALID_SERIAL_NUMBER)
+		pr_pfx(pfx, "serial number: 0x%04x, 0x%04x\n",
+		       pcie->serial_number.lower, pcie->serial_number.upper);
+	if (pcie->validation_bits & CPER_PCIE_VALID_BRIDGE_CONTROL_STATUS)
+		pr_pfx(pfx,
+	"bridge: secondary_status: 0x%04x, control: 0x%04x\n",
+	pcie->bridge.secondary_status, pcie->bridge.control);
+}
+
+static const char *apei_estatus_section_flag_strs[] = {
+	"primary",
+	"containment warning",
+	"reset",
+	"threshold exceeded",
+	"resource not accessible",
+	"latent error",
+};
+
+static void apei_estatus_print_section(
+	const char *pfx, const struct acpi_hest_generic_data *gdata, int sec_no)
+{
+	uuid_le *sec_type = (uuid_le *)gdata->section_type;
+	__u16 severity;
+
+	severity = gdata->error_severity;
+	pr_pfx(pfx, "section: %d, severity: %d, %s\n", sec_no, severity,
+	       cper_severity_str(severity));
+	pr_pfx(pfx, "flags: 0x%02x\n", gdata->flags);
+	cper_print_bits(pfx, gdata->flags, apei_estatus_section_flag_strs,
+			ARRAY_SIZE(apei_estatus_section_flag_strs));
+	if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
+		pr_pfx(pfx, "fru_id: %pUl\n", (uuid_le *)gdata->fru_id);
+	if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
+		pr_pfx(pfx, "fru_text: %.20s\n", gdata->fru_text);
+
+	if (!uuid_le_cmp(*sec_type, CPER_SEC_PROC_GENERIC)) {
+		struct cper_sec_proc_generic *proc_err = (void *)(gdata + 1);
+		pr_pfx(pfx, "section_type: general processor error\n");
+		if (gdata->error_data_length >= sizeof(*proc_err))
+			cper_print_proc_generic(pfx, proc_err);
+		else
+			goto err_section_too_small;
+	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PLATFORM_MEM)) {
+		struct cper_sec_mem_err *mem_err = (void *)(gdata + 1);
+		pr_pfx(pfx, "section_type: memory error\n");
+		if (gdata->error_data_length >= sizeof(*mem_err))
+			cper_print_mem(pfx, mem_err);
+		else
+			goto err_section_too_small;
+	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PCIE)) {
+		struct cper_sec_pcie *pcie = (void *)(gdata + 1);
+		pr_pfx(pfx, "section_type: PCIe error\n");
+		if (gdata->error_data_length >= sizeof(*pcie))
+			cper_print_pcie(pfx, pcie);
+		else
+			goto err_section_too_small;
+	} else
+		pr_pfx(pfx, "section type: unknown, %pUl\n", sec_type);
+
+	return;
+
+err_section_too_small:
+	pr_err(FW_WARN "error section length is too small\n");
+}
+
+void apei_estatus_print(const char *pfx,
+			const struct acpi_hest_generic_status *estatus)
+{
+	struct acpi_hest_generic_data *gdata;
+	unsigned int data_len, gedata_len;
+	int sec_no = 0;
+	__u16 severity;
+
+	pr_pfx(pfx, "APEI generic hardware error status\n");
+	severity = estatus->error_severity;
+	pr_pfx(pfx, "severity: %d, %s\n", severity,
+	       cper_severity_str(severity));
+	data_len = estatus->data_length;
+	gdata = (struct acpi_hest_generic_data *)(estatus + 1);
+	while (data_len > sizeof(*gdata)) {
+		gedata_len = gdata->error_data_length;
+		apei_estatus_print_section(pfx, gdata, sec_no);
+		data_len -= gedata_len + sizeof(*gdata);
+		sec_no++;
+	}
+}
+EXPORT_SYMBOL_GPL(apei_estatus_print);
+
 int apei_estatus_check_header(const struct acpi_hest_generic_status *estatus)
 {
 	if (estatus->data_length &&
