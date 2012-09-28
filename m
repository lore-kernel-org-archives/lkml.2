Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030914Ab2I1TLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:11:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45270 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030747Ab2I1TG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:06:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joerg.roedel@amd.com>,
        "Cho, Yu-Chen" <acho@suse.com>
Subject: [ 247/262] irq_remap: disable IRQ remapping if any IOAPIC lacks an IOMMU
Date: Fri, 28 Sep 2012 11:52:56 -0700
Message-Id: <20120928183027.632835572@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seth Forshee <seth.forshee@canonical.com>

commit 32ab31e01e2def6f48294d872d9bb42573aae00f upstream.

The ACPI tables in the Macbook Air 5,1 define a single IOAPIC with id 2,
but the only remapping unit described in the DMAR table matches id 0.
Interrupt remapping fails as a result, and the kernel panics with the
message "timer doesn't work through Interrupt-remapped IO-APIC."

To fix this, check each IOAPIC for a corresponding IOMMU. If an IOMMU is
not found, do not allow IRQ remapping to be enabled.

v2: Move check to parse_ioapics_under_ir(), raise log level to KERN_ERR,
    and add FW_BUG to the log message
v3: Skip check if IOMMU doesn't support interrupt remapping and remove
    existing check that the IOMMU count equals the IOAPIC count

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Cho, Yu-Chen <acho@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel_irq_remapping.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -736,6 +736,7 @@ int __init parse_ioapics_under_ir(void)
 {
 	struct dmar_drhd_unit *drhd;
 	int ir_supported = 0;
+	int ioapic_idx;
 
 	for_each_drhd_unit(drhd) {
 		struct intel_iommu *iommu = drhd->iommu;
@@ -748,13 +749,20 @@ int __init parse_ioapics_under_ir(void)
 		}
 	}
 
-	if (ir_supported && ir_ioapic_num != nr_ioapics) {
-		printk(KERN_WARNING
-		       "Not all IO-APIC's listed under remapping hardware\n");
-		return -1;
+	if (!ir_supported)
+		return 0;
+
+	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++) {
+		int ioapic_id = mpc_ioapic_id(ioapic_idx);
+		if (!map_ioapic_to_ir(ioapic_id)) {
+			pr_err(FW_BUG "ioapic %d has no mapping iommu, "
+			       "interrupt remapping will be disabled\n",
+			       ioapic_id);
+			return -1;
+		}
 	}
 
-	return ir_supported;
+	return 1;
 }
 
 int __init ir_dev_scope_init(void)


