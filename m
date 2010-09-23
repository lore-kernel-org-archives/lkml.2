Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab0IWOpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 10:45:22 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:3908 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab0IWOpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 10:45:20 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bh8275dhz32i2a8h87h43h)
X-FB-SS: 0,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L97FMA-01-70S-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>, <stable@kernel.org>
Subject: [PATCH 1/3] x86/amd-iommu: Set iommu configuration flags in enable-loop
Date: Thu, 23 Sep 2010 16:44:47 +0200
Message-ID: <1285253089-4570-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285253089-4570-1-git-send-email-joerg.roedel@amd.com>
References: <1285253089-4570-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the setting of the configuration and
feature flags out out the acpi table parsing path and moves
it into the iommu-enable path. This is needed to reliably
fix resume-from-s3.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    3 ++
 arch/x86/kernel/amd_iommu_init.c       |   49 +++++++++++++++++--------------
 2 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 7014e88..ef2d5cd 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -368,6 +368,9 @@ struct amd_iommu {
 	/* capabilities of that IOMMU read from ACPI */
 	u32 cap;
 
+	/* flags read from acpi table */
+	u8 acpi_flags;
+
 	/*
 	 * Capability pointer. There could be more than one IOMMU per PCI
 	 * device function if there are more than one AMD IOMMU capability
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 3cc63e2..85e9817 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -649,29 +649,9 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
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
@@ -1116,6 +1096,30 @@ static void init_device_table(void)
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
@@ -1126,6 +1130,7 @@ static void enable_iommus(void)
 
 	for_each_iommu(iommu) {
 		iommu_disable(iommu);
+		iommu_init_flags(iommu);
 		iommu_set_device_table(iommu);
 		iommu_enable_command_buffer(iommu);
 		iommu_enable_event_buffer(iommu);
-- 
1.7.0.4


