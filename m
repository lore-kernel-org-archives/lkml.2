Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab2K3Vin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 16:38:43 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:8029 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab2K3Vij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 16:38:39 -0500
From: Lance Ortiz <lance.ortiz@hp.com>
Subject: [PATCH v3 2/3] aerdrv: Enhanced AER logging
To: bhelgaas@google.com, lance_ortiz@hotmail.com, jiang.liu@huawei.com,
        tony.luck@intel.com, bp@alien8.de, rostedt@goodmis.org,
        mchehab@redhat.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2012 14:33:37 -0700
Message-ID: <20121130213337.7649.6709.stgit@grignak.americas.hpqcorp.net>
In-Reply-To: <20121130213330.7649.51101.stgit@grignak.americas.hpqcorp.net>
References: <20121130213330.7649.51101.stgit@grignak.americas.hpqcorp.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch will provide a more reliable and easy way for user-space
applications to have access to AER logs rather than reading them from the
message buffer. It also provides a way to notify user-space when an AER
event occurs.

The aer driver is updated to generate a trace event of function 'aer_event'
when an AER occurs.  The trace event was added to both the interrupt
based aer path and the firmware first path

v1-v2 fix compile errors in ifdefs.
v2-v3 Update to new location of trace header. Update print to remove
warning.

Signed-off-by: Lance Ortiz <lance.ortiz@hp.com>
---

 drivers/acpi/apei/cper.c               |   17 +++++++++++++++--
 drivers/pci/pcie/aer/aerdrv_errprint.c |   10 +++++++++-
 include/linux/aer.h                    |    2 +-
 3 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
index e6defd8..e9d6062 100644
--- a/drivers/acpi/apei/cper.c
+++ b/drivers/acpi/apei/cper.c
@@ -29,6 +29,7 @@
 #include <linux/time.h>
 #include <linux/cper.h>
 #include <linux/acpi.h>
+#include <linux/pci.h>
 #include <linux/aer.h>
 
 /*
@@ -249,6 +250,10 @@ static const char *cper_pcie_port_type_strs[] = {
 static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
 			    const struct acpi_hest_generic_data *gdata)
 {
+#ifdef CONFIG_ACPI_APEI_PCIEAER
+	struct pci_dev *dev;
+#endif
+
 	if (pcie->validation_bits & CPER_PCIE_VALID_PORT_TYPE)
 		printk("%s""port_type: %d, %s\n", pfx, pcie->port_type,
 		       pcie->port_type < ARRAY_SIZE(cper_pcie_port_type_strs) ?
@@ -281,9 +286,17 @@ static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
 	"%s""bridge: secondary_status: 0x%04x, control: 0x%04x\n",
 	pfx, pcie->bridge.secondary_status, pcie->bridge.control);
 #ifdef CONFIG_ACPI_APEI_PCIEAER
-	if (pcie->validation_bits & CPER_PCIE_VALID_AER_INFO) {
+	dev = pci_get_domain_bus_and_slot(pcie->device_id.segment,
+			pcie->device_id.bus, pcie->device_id.function);
+	if (!dev)
+		pr_info("PCI AER Cannot get PCI device %04x:%02x:%02x.%d\n",
+			pcie->device_id.segment, pcie->device_id.bus,
+			pcie->device_id.slot, pcie->device_id.function);
+
+	if (pcie->validation_bits & CPER_PCIE_VALID_AER_INFO && dev) {
 		struct aer_capability_regs *aer_regs = (void *)pcie->aer_info;
-		cper_print_aer(pfx, gdata->error_severity, aer_regs);
+		cper_print_aer(dev, gdata->error_severity, aer_regs);
+		pci_dev_put(dev);
 	}
 #endif
 }
diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c b/drivers/pci/pcie/aer/aerdrv_errprint.c
index 3ea5173..34d96e4 100644
--- a/drivers/pci/pcie/aer/aerdrv_errprint.c
+++ b/drivers/pci/pcie/aer/aerdrv_errprint.c
@@ -23,6 +23,9 @@
 
 #include "aerdrv.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/ras.h>
+
 #define AER_AGENT_RECEIVER		0
 #define AER_AGENT_REQUESTER		1
 #define AER_AGENT_COMPLETER		2
@@ -194,6 +197,8 @@ void aer_print_error(struct pci_dev *dev, struct aer_err_info *info)
 	if (info->id && info->error_dev_num > 1 && info->id == id)
 		printk("%s""  Error of this Agent(%04x) is reported first\n",
 			prefix, id);
+	trace_aer_event(dev_name(&dev->dev), (info->status & ~info->mask),
+			info->severity);
 }
 
 void aer_print_port_info(struct pci_dev *dev, struct aer_err_info *info)
@@ -217,12 +222,13 @@ int cper_severity_to_aer(int cper_severity)
 }
 EXPORT_SYMBOL_GPL(cper_severity_to_aer);
 
-void cper_print_aer(const char *prefix, int cper_severity,
+void cper_print_aer(struct pci_dev *dev, int cper_severity,
 		    struct aer_capability_regs *aer)
 {
 	int aer_severity, layer, agent, status_strs_size, tlp_header_valid = 0;
 	u32 status, mask;
 	const char **status_strs;
+	char *prefix = NULL;
 
 	aer_severity = cper_severity_to_aer(cper_severity);
 	if (aer_severity == AER_CORRECTABLE) {
@@ -259,5 +265,7 @@ void cper_print_aer(const char *prefix, int cper_severity,
 			*(tlp + 8), *(tlp + 15), *(tlp + 14),
 			*(tlp + 13), *(tlp + 12));
 	}
+	trace_aer_event(dev_name(&dev->dev), (status & ~mask),
+			aer_severity);
 }
 #endif
diff --git a/include/linux/aer.h b/include/linux/aer.h
index 544abdb..7b86dc6 100644
--- a/include/linux/aer.h
+++ b/include/linux/aer.h
@@ -49,7 +49,7 @@ static inline int pci_cleanup_aer_uncorrect_error_status(struct pci_dev *dev)
 }
 #endif
 
-extern void cper_print_aer(const char *prefix, int cper_severity,
+extern void cper_print_aer(struct pci_dev *dev, int cper_severity,
 			   struct aer_capability_regs *aer);
 extern int cper_severity_to_aer(int cper_severity);
 extern void aer_recover_queue(int domain, unsigned int bus, unsigned int devfn,

