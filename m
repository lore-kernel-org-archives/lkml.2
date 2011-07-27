Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab1G0WDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:03:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:12903 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755570Ab1G0Vsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="33043665"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: joerg.roedel@amd.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [47/99] x86/amd-iommu: Fix 3 possible endless loops
Message-Id: <20110727214846.2B1742403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Joerg Roedel <joerg.roedel@amd.com>

commit 0de66d5b35ee148455e268b2782873204ffdef4b upstream.

The driver contains several loops counting on an u16 value
where the exit-condition is checked against variables that
can have values up to 0xffff. In this case the loops will
never exit. This patch fixed 3 such loops.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/amd_iommu_init.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.35.y/arch/x86/kernel/amd_iommu_init.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/amd_iommu_init.c
+++ linux-2.6.35.y/arch/x86/kernel/amd_iommu_init.c
@@ -650,8 +650,8 @@ static void __init init_iommu_from_acpi(
 {
 	u8 *p = (u8 *)h;
 	u8 *end = p, flags = 0;
-	u16 dev_i, devid = 0, devid_start = 0, devid_to = 0;
-	u32 ext_flags = 0;
+	u16 devid = 0, devid_start = 0, devid_to = 0;
+	u32 dev_i, ext_flags = 0;
 	bool alias = false;
 	struct ivhd_entry *e;
 
@@ -806,7 +806,7 @@ static void __init init_iommu_from_acpi(
 /* Initializes the device->iommu mapping for the driver */
 static int __init init_iommu_devices(struct amd_iommu *iommu)
 {
-	u16 i;
+	u32 i;
 
 	for (i = iommu->first_device; i <= iommu->last_device; ++i)
 		set_iommu_for_device(iommu, i);
@@ -1095,7 +1095,7 @@ static int __init init_memory_definition
  */
 static void init_device_table(void)
 {
-	u16 devid;
+	u32 devid;
 
 	for (devid = 0; devid <= amd_iommu_last_bdf; ++devid) {
 		set_dev_entry_bit(devid, DEV_ENTRY_VALID);
