Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab2HGVkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 17:40:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58219 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab2HGVjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 17:39:43 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
Cc: Joerg Roedel <joro@8bytes.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Len Brown <lenb@kernel.org>, Joerg Roedel <joerg.roedel@amd.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2] irq_remap: disable IRQ remapping if any IOAPIC lacks an IOMMU
Date: Tue,  7 Aug 2012 16:39:33 -0500
Message-Id: <1344375573-16716-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20120807210408.GK1917@8bytes.org>
References: <20120807210408.GK1917@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACPI tables in the Macbook Air 5,1 define a single IOAPIC with id 2,
but the only remapping unit described in the DMAR table matches id 0.
Interrupt remapping fails as a result, and the kernel panics with the
message "timer doesn't work through Interrupt-remapped IO-APIC."

To fix this, check each IOAPIC for a corresponding IOMMU. If an IOMMU is
not found, do not allow IRQ remapping to be enabled.

v2: Move check to parse_ioapics_under_ir(), raise log level to KERN_ERR,
    and add FW_BUG to the log message

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/iommu/intel_irq_remapping.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index e0b18f3..84e5dc3 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -736,6 +736,7 @@ int __init parse_ioapics_under_ir(void)
 {
 	struct dmar_drhd_unit *drhd;
 	int ir_supported = 0;
+	int ioapic_idx;
 
 	for_each_drhd_unit(drhd) {
 		struct intel_iommu *iommu = drhd->iommu;
@@ -754,6 +755,16 @@ int __init parse_ioapics_under_ir(void)
 		return -1;
 	}
 
+	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++) {
+		int ioapic_id = mpc_ioapic_id(ioapic_idx);
+		if (!map_ioapic_to_ir(ioapic_id)) {
+			pr_err(FW_BUG "ioapic %d has no mapping iommu, "
+			       "interrupt remapping will be disabled\n",
+			       ioapic_id);
+			return -1;
+		}
+	}
+
 	return ir_supported;
 }
 
-- 
1.7.9.5

