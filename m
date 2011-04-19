Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab1DSBoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 21:44:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:33363 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab1DSBnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 21:43:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,236,1301900400"; 
   d="scan'208";a="421595198"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org
Subject: [RFC 4/4] ACPI, APEI, GHES: Add PCIe AER recovery support
Date: Tue, 19 Apr 2011 09:43:39 +0800
Message-Id: <1303177419-22466-4-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303177419-22466-1-git-send-email-ying.huang@intel.com>
References: <1303177419-22466-1-git-send-email-ying.huang@intel.com>
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
@@ -454,6 +456,27 @@ static void ghes_do_proc(const struct ac
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
 
