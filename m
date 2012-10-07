Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab2JGXeg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:34:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38498 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754322Ab2JGXWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:49 -0400
Message-Id: <20121007225843.274569775@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:36 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Seth Forshee <seth.forshee@canonical.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [ 062/108] irq_remap: disable IRQ remapping if any IOAPIC lacks an IOMMU
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/iommu/intr_remapping.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/iommu/intr_remapping.c
+++ b/drivers/iommu/intr_remapping.c
@@ -752,6 +752,7 @@ int __init parse_ioapics_under_ir(void)
 {
 	struct dmar_drhd_unit *drhd;
 	int ir_supported = 0;
+	int ioapic_idx;
 
 	for_each_drhd_unit(drhd) {
 		struct intel_iommu *iommu = drhd->iommu;
@@ -764,13 +765,20 @@ int __init parse_ioapics_under_ir(void)
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


