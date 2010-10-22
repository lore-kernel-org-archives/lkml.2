Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab0JVSiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:38:23 -0400
Received: from kroah.org ([198.145.64.141]:45621 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813Ab0JVSiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:38:21 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:35:57 2010
Message-Id: <20101022183557.397556693@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:34:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [13/66] x86/amd-iommu: Set iommu configuration flags in enable-loop
In-Reply-To: <20101022183711.GA23214@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit e9bf51971157e367aabfc111a8219db010f69cd4 upstream.

This patch moves the setting of the configuration and
feature flags out out the acpi table parsing path and moves
it into the iommu-enable path. This is needed to reliably
fix resume-from-s3.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/amd_iommu_types.h |    3 ++
 arch/x86/kernel/amd_iommu_init.c       |   49 ++++++++++++++++++---------------
 2 files changed, 30 insertions(+), 22 deletions(-)

--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -305,6 +305,9 @@ struct amd_iommu {
 	/* capabilities of that IOMMU read from ACPI */
 	u32 cap;
 
+	/* flags read from acpi table */
+	u8 acpi_flags;
+
 	/*
 	 * Capability pointer. There could be more than one IOMMU per PCI
 	 * device function if there are more than one AMD IOMMU capability
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -639,29 +639,9 @@ static void __init init_iommu_from_acpi(
 	struct ivhd_entry *e;
 
 	/*
-	 * First set the recommended feature enable bits from ACPI
-	 * into the IOMMU control registers
+	 * First save the recommended feature enable bits from ACPI
 	 */
-	h->flags & IVHD_FLAG_HT_TUN_EN_MASK ?
-		iommu_feature_enable(iommu, CONTROL_HT_TUN_EN) :
-		iommu_feature_disable(iommu, CONTROL_HT_TUN_EN);
-
-	h->flags & IVHD_FLAG_PASSPW_EN_MASK ?
-		iommu_feature_enable(iommu, CONTROL_PASSPW_EN) :
-		iommu_feature_disable(iommu, CONTROL_PASSPW_EN);
-
-	h->flags & IVHD_FLAG_RESPASSPW_EN_MASK ?
-		iommu_feature_enable(iommu, CONTROL_RESPASSPW_EN) :
-		iommu_feature_disable(iommu, CONTROL_RESPASSPW_EN);
-
-	h->flags & IVHD_FLAG_ISOC_EN_MASK ?
-		iommu_feature_enable(iommu, CONTROL_ISOC_EN) :
-		iommu_feature_disable(iommu, CONTROL_ISOC_EN);
-
-	/*
-	 * make IOMMU memory accesses cache coherent
-	 */
-	iommu_feature_enable(iommu, CONTROL_COHERENT_EN);
+	iommu->acpi_flags = h->flags;
 
 	/*
 	 * Done. Now parse the device entries
@@ -1089,6 +1069,30 @@ static void init_device_table(void)
 	}
 }
 
+static void iommu_init_flags(struct amd_iommu *iommu)
+{
+	iommu->acpi_flags & IVHD_FLAG_HT_TUN_EN_MASK ?
+		iommu_feature_enable(iommu, CONTROL_HT_TUN_EN) :
+		iommu_feature_disable(iommu, CONTROL_HT_TUN_EN);
+
+	iommu->acpi_flags & IVHD_FLAG_PASSPW_EN_MASK ?
+		iommu_feature_enable(iommu, CONTROL_PASSPW_EN) :
+		iommu_feature_disable(iommu, CONTROL_PASSPW_EN);
+
+	iommu->acpi_flags & IVHD_FLAG_RESPASSPW_EN_MASK ?
+		iommu_feature_enable(iommu, CONTROL_RESPASSPW_EN) :
+		iommu_feature_disable(iommu, CONTROL_RESPASSPW_EN);
+
+	iommu->acpi_flags & IVHD_FLAG_ISOC_EN_MASK ?
+		iommu_feature_enable(iommu, CONTROL_ISOC_EN) :
+		iommu_feature_disable(iommu, CONTROL_ISOC_EN);
+
+	/*
+	 * make IOMMU memory accesses cache coherent
+	 */
+	iommu_feature_enable(iommu, CONTROL_COHERENT_EN);
+}
+
 /*
  * This function finally enables all IOMMUs found in the system after
  * they have been initialized
@@ -1099,6 +1103,7 @@ static void enable_iommus(void)
 
 	for_each_iommu(iommu) {
 		iommu_disable(iommu);
+		iommu_init_flags(iommu);
 		iommu_set_device_table(iommu);
 		iommu_enable_command_buffer(iommu);
 		iommu_enable_event_buffer(iommu);


