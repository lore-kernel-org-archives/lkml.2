Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab1AaBhF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 20:37:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:7152 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab1AaBgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 20:36:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,402,1291622400"; 
   d="scan'208";a="652683602"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Zhang Yanmin <yanmin.zhang@intel.com>
Subject: [PATCH 2/2] ACPI, APEI, Add PCIe AER error information printing support
Date: Mon, 31 Jan 2011 09:36:14 +0800
Message-Id: <1296437774-7375-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AER error information printing support is implemented in
drivers/pci/pcie/aer/aer_print.c.  So some string constants, functions
and macros definitions can be re-used without being exported.

The original PCIe AER error information printing function is not
re-used directly because the overall format is quite different.  And
changing the original printing format may make some original users'
scripts broken.

Signed-off-by: Huang Ying <ying.huang@intel.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Zhang Yanmin <yanmin.zhang@intel.com>
---
 Documentation/acpi/apei/output_format.txt |   25 ++++++++++++
 drivers/acpi/apei/Kconfig                 |    7 +++
 drivers/acpi/apei/cper.c                  |   18 +++++++--
 drivers/pci/pcie/aer/aerdrv.h             |    9 ----
 drivers/pci/pcie/aer/aerdrv_errprint.c    |   59 ++++++++++++++++++++++++++++++
 include/linux/aer.h                       |   24 ++++++++++++
 include/linux/cper.h                      |    2 +
 7 files changed, 132 insertions(+), 12 deletions(-)

--- a/Documentation/acpi/apei/output_format.txt
+++ b/Documentation/acpi/apei/output_format.txt
@@ -92,6 +92,11 @@ vendor_id: <integer>, device_id: <intege
 class_code: <integer>]
 [serial number: <integer>, <integer>]
 [bridge: secondary_status: <integer>, control: <integer>]
+[aer_status: <integer>, aer_mask: <integer>
+<aer status string>
+[aer_uncor_severity: <integer>]
+aer_layer=<aer layer string>, aer_agent=<aer agent string>
+aer_tlp_header: <integer> <integer> <integer> <integer>]
 
 <pcie port type string>* := PCIe end point | legacy PCI end point | \
 unknown | unknown | root port | upstream switch port | \
@@ -99,6 +104,26 @@ downstream switch port | PCIe to PCI/PCI
 PCI/PCI-X to PCIe bridge | root complex integrated endpoint device | \
 root complex event collector
 
+if section severity is fatal or recoverable
+<aer status string># :=
+unknown | unknown | unknown | unknown | Data Link Protocol | \
+unknown | unknown | unknown | unknown | unknown | unknown | unknown | \
+Poisoned TLP | Flow Control Protocol | Completion Timeout | \
+Completer Abort | Unexpected Completion | Receiver Overflow | \
+Malformed TLP | ECRC | Unsupported Request
+else
+<aer status string># :=
+Receiver Error | unknown | unknown | unknown | unknown | unknown | \
+Bad TLP | Bad DLLP | RELAY_NUM Rollover | unknown | unknown | unknown | \
+Replay Timer Timeout | Advisory Non-Fatal
+fi
+
+<aer layer string> :=
+Physical Layer | Data Link Layer | Transaction Layer
+
+<aer agent string> :=
+Receiver ID | Requester ID | Completer ID | Transmitter ID
+
 Where, [] designate corresponding content is optional
 
 All <field string> description with * has the following format:
--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -21,6 +21,13 @@ config ACPI_APEI_GHES
 	  by firmware to produce more valuable hardware error
 	  information for Linux.
 
+config ACPI_APEI_PCIEAER
+	bool "APEI PCIe AER logging/recovering support"
+	depends on ACPI_APEI && PCIEAER
+	help
+	  PCIe AER errors may be reported via APEI firmware first mode.
+	  Turn on this option to enable the corresponding support.
+
 config ACPI_APEI_EINJ
 	tristate "APEI Error INJection (EINJ)"
 	depends on ACPI_APEI && DEBUG_FS
--- a/drivers/acpi/apei/cper.c
+++ b/drivers/acpi/apei/cper.c
@@ -29,6 +29,7 @@
 #include <linux/time.h>
 #include <linux/cper.h>
 #include <linux/acpi.h>
+#include <linux/aer.h>
 
 /*
  * CPER record ID need to be unique even after reboot, because record
@@ -70,8 +71,8 @@ static const char *cper_severity_str(uns
  * If the output length is longer than 80, multiple line will be
  * printed, with @pfx is printed at the beginning of each line.
  */
-static void cper_print_bits(const char *pfx, unsigned int bits,
-			    const char *strs[], unsigned int strs_size)
+void cper_print_bits(const char *pfx, unsigned int bits,
+		     const char *strs[], unsigned int strs_size)
 {
 	int i, len = 0;
 	const char *str;
@@ -81,6 +82,8 @@ static void cper_print_bits(const char *
 		if (!(bits & (1U << i)))
 			continue;
 		str = strs[i];
+		if (!str)
+			continue;
 		if (len && len + strlen(str) + 2 > 80) {
 			printk("%s\n", buf);
 			len = 0;
@@ -243,7 +246,8 @@ static const char *cper_pcie_port_type_s
 	"root complex event collector",
 };
 
-static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie)
+static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
+			    const struct acpi_hest_generic_data *gdata)
 {
 	if (pcie->validation_bits & CPER_PCIE_VALID_PORT_TYPE)
 		printk("%s""port_type: %d, %s\n", pfx, pcie->port_type,
@@ -276,6 +280,12 @@ static void cper_print_pcie(const char *
 		printk(
 	"%s""bridge: secondary_status: 0x%04x, control: 0x%04x\n",
 	pfx, pcie->bridge.secondary_status, pcie->bridge.control);
+#ifdef CONFIG_ACPI_APEI_PCIEAER
+	if (pcie->validation_bits & CPER_PCIE_VALID_AER_INFO) {
+		struct aer_capability_regs *aer_regs = (void *)pcie->aer_info;
+		cper_print_aer(pfx, gdata->error_severity, aer_regs);
+	}
+#endif
 }
 
 static const char *apei_estatus_section_flag_strs[] = {
@@ -322,7 +332,7 @@ static void apei_estatus_print_section(
 		struct cper_sec_pcie *pcie = (void *)(gdata + 1);
 		printk("%s""section_type: PCIe error\n", pfx);
 		if (gdata->error_data_length >= sizeof(*pcie))
-			cper_print_pcie(pfx, pcie);
+			cper_print_pcie(pfx, pcie, gdata);
 		else
 			goto err_section_too_small;
 	} else
--- a/drivers/pci/pcie/aer/aerdrv.h
+++ b/drivers/pci/pcie/aer/aerdrv.h
@@ -35,13 +35,6 @@
 					PCI_ERR_UNC_UNX_COMP|		\
 					PCI_ERR_UNC_MALF_TLP)
 
-struct header_log_regs {
-	unsigned int dw0;
-	unsigned int dw1;
-	unsigned int dw2;
-	unsigned int dw3;
-};
-
 #define AER_MAX_MULTI_ERR_DEVICES	5	/* Not likely to have more */
 struct aer_err_info {
 	struct pci_dev *dev[AER_MAX_MULTI_ERR_DEVICES];
@@ -59,7 +52,7 @@ struct aer_err_info {
 
 	unsigned int status;		/* COR/UNCOR Error Status */
 	unsigned int mask;		/* COR/UNCOR Error Mask */
-	struct header_log_regs tlp;	/* TLP Header */
+	struct aer_header_log_regs tlp;	/* TLP Header */
 };
 
 struct aer_err_source {
--- a/drivers/pci/pcie/aer/aerdrv_errprint.c
+++ b/drivers/pci/pcie/aer/aerdrv_errprint.c
@@ -19,6 +19,7 @@
 #include <linux/errno.h>
 #include <linux/pm.h>
 #include <linux/suspend.h>
+#include <linux/cper.h>
 
 #include "aerdrv.h"
 
@@ -201,3 +202,61 @@ void aer_print_port_info(struct pci_dev
 		info->multi_error_valid ? "Multiple " : "",
 		aer_error_severity_string[info->severity], info->id);
 }
+
+#ifdef CONFIG_ACPI_APEI_PCIEAER
+static int cper_severity_to_aer(int cper_severity)
+{
+	switch (cper_severity) {
+	case CPER_SEV_RECOVERABLE:
+		return AER_NONFATAL;
+	case CPER_SEV_FATAL:
+		return AER_FATAL;
+	default:
+		return AER_CORRECTABLE;
+	}
+}
+
+void cper_print_aer(const char *prefix, int cper_severity,
+		    struct aer_capability_regs *aer)
+{
+	int aer_severity, layer, agent, status_strs_size, tlp_header_valid = 0;
+	u32 status, mask;
+	const char **status_strs;
+
+	aer_severity = cper_severity_to_aer(cper_severity);
+	if (aer_severity == AER_CORRECTABLE) {
+		status = aer->cor_status;
+		mask = aer->cor_mask;
+		status_strs = aer_correctable_error_string;
+		status_strs_size = ARRAY_SIZE(aer_correctable_error_string);
+	} else {
+		status = aer->uncor_status;
+		mask = aer->uncor_mask;
+		status_strs = aer_uncorrectable_error_string;
+		status_strs_size = ARRAY_SIZE(aer_uncorrectable_error_string);
+		tlp_header_valid = status & AER_LOG_TLP_MASKS;
+	}
+	layer = AER_GET_LAYER_ERROR(aer_severity, status);
+	agent = AER_GET_AGENT(aer_severity, status);
+	printk("%s""aer_status: 0x%08x, aer_mask: 0x%08x\n",
+	       prefix, status, mask);
+	cper_print_bits(prefix, status, status_strs, status_strs_size);
+	printk("%s""aer_layer=%s, aer_agent=%s\n", prefix,
+	       aer_error_layer[layer], aer_agent_string[agent]);
+	if (aer_severity != AER_CORRECTABLE)
+		printk("%s""aer_uncor_severity: 0x%08x\n",
+		       prefix, aer->uncor_severity);
+	if (tlp_header_valid) {
+		const unsigned char *tlp;
+		tlp = (const unsigned char *)&aer->header_log;
+		printk("%s""aer_tlp_header:"
+			" %02x%02x%02x%02x %02x%02x%02x%02x"
+			" %02x%02x%02x%02x %02x%02x%02x%02x\n",
+			prefix, *(tlp + 3), *(tlp + 2), *(tlp + 1), *tlp,
+			*(tlp + 7), *(tlp + 6), *(tlp + 5), *(tlp + 4),
+			*(tlp + 11), *(tlp + 10), *(tlp + 9),
+			*(tlp + 8), *(tlp + 15), *(tlp + 14),
+			*(tlp + 13), *(tlp + 12));
+	}
+}
+#endif
--- a/include/linux/aer.h
+++ b/include/linux/aer.h
@@ -7,6 +7,28 @@
 #ifndef _AER_H_
 #define _AER_H_
 
+struct aer_header_log_regs {
+	unsigned int dw0;
+	unsigned int dw1;
+	unsigned int dw2;
+	unsigned int dw3;
+};
+
+struct aer_capability_regs {
+	u32 header;
+	u32 uncor_status;
+	u32 uncor_mask;
+	u32 uncor_severity;
+	u32 cor_status;
+	u32 cor_mask;
+	u32 cap_control;
+	struct aer_header_log_regs header_log;
+	u32 root_command;
+	u32 root_status;
+	u16 cor_err_source;
+	u16 uncor_err_source;
+};
+
 #if defined(CONFIG_PCIEAER)
 /* pci-e port driver needs this function to enable aer */
 extern int pci_enable_pcie_error_reporting(struct pci_dev *dev);
@@ -27,5 +49,7 @@ static inline int pci_cleanup_aer_uncorr
 }
 #endif
 
+extern void cper_print_aer(const char *prefix, int cper_severity,
+			   struct aer_capability_regs *aer);
 #endif //_AER_H_
 
--- a/include/linux/cper.h
+++ b/include/linux/cper.h
@@ -388,5 +388,7 @@ struct cper_sec_pcie {
 #pragma pack()
 
 u64 cper_next_record_id(void);
+void cper_print_bits(const char *prefix, unsigned int bits,
+		     const char *strs[], unsigned int strs_size);
 
 #endif
