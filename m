Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab1KHCkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 21:40:39 -0500
Received: from mga14.intel.com ([143.182.124.37]:25706 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655Ab1KHCju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 21:39:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,473,1315206000"; 
   d="scan'208";a="34288633"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org
Subject: [PATCH 8/9] ACPI, APEI, GHES: Add PCIe AER recovery support
Date: Tue,  8 Nov 2011 10:39:33 +0800
Message-Id: <1320719974-3598-9-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1320719974-3598-1-git-send-email-ying.huang@intel.com>
References: <1320719974-3598-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aer_recover_queue() is called when recoverable PCIe AER errors are
notified by firmware to do the recovery work.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/ghes.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -45,6 +45,8 @@
 #include <linux/irq_work.h>
 #include <linux/llist.h>
 #include <linux/genalloc.h>
+#include <linux/pci.h>
+#include <linux/aer.h>
 #include <acpi/apei.h>
 #include <acpi/atomicio.h>
 #include <acpi/hed.h>
@@ -476,6 +478,27 @@ static void ghes_do_proc(const struct ac
 			}
 #endif
 		}
+#ifdef CONFIG_ACPI_APEI_PCIEAER
+		else if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
+				      CPER_SEC_PCIE)) {
+			struct cper_sec_pcie *pcie_err;
+			pcie_err = (struct cper_sec_pcie *)(gdata+1);
+			if (sev == GHES_SEV_RECOVERABLE &&
+			    sec_sev == GHES_SEV_RECOVERABLE &&
+			    pcie_err->validation_bits & CPER_PCIE_VALID_DEVICE_ID &&
+			    pcie_err->validation_bits & CPER_PCIE_VALID_AER_INFO) {
+				unsigned int devfn;
+				int aer_severity;
+				devfn = PCI_DEVFN(pcie_err->device_id.device,
+						  pcie_err->device_id.function);
+				aer_severity = cper_severity_to_aer(sev);
+				aer_recover_queue(pcie_err->device_id.segment,
+						  pcie_err->device_id.bus,
+						  devfn, aer_severity);
+			}
+
+		}
+#endif
 	}
 }
 
