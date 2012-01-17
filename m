Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab2AQM2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:28:40 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:56487 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab2AQMWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:22:14 -0500
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 26/50] ACPI, APEI, GHES: Add PCIe AER recovery support
Date: Tue, 17 Jan 2012 07:21:18 -0500
Message-id: <a654e5ee4f2213844d23361eda4955fe9efaf35f.1326802230.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.9.rc1
In-reply-to: <1326802902-21583-1-git-send-email-lenb@kernel.org>
References: <1326802902-21583-1-git-send-email-lenb@kernel.org>
In-reply-to: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
References: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

aer_recover_queue() is called when recoverable PCIe AER errors are
notified by firmware to do the recovery work.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/apei/ghes.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index b8e08cb..511b971 100644
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
@@ -476,6 +478,27 @@ static void ghes_do_proc(const struct acpi_hest_generic_status *estatus)
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
 
-- 
1.7.9.rc1

