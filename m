Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab1FGKGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:06:49 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:28278 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab1FGKGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:06:47 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bh8275dhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMF038-01-H01-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>, <stable@kernel.org>
Subject: [PATCH 1/3] x86/amd-iommu: Fix 3 possible endless loops
Date: Tue, 7 Jun 2011 12:06:57 +0200
Message-ID: <1307441219-18202-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307441219-18202-1-git-send-email-joerg.roedel@amd.com>
References: <1307441219-18202-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver contains several loops counting on an u16 value
where the exit-condition is checked against variables that
can have values up to 0xffff. In this case the loops will
never exit. This patch fixed 3 such loops.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 9179c21..bfc8453 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -731,8 +731,8 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 {
 	u8 *p = (u8 *)h;
 	u8 *end = p, flags = 0;
-	u16 dev_i, devid = 0, devid_start = 0, devid_to = 0;
-	u32 ext_flags = 0;
+	u16 devid = 0, devid_start = 0, devid_to = 0;
+	u32 dev_i, ext_flags = 0;
 	bool alias = false;
 	struct ivhd_entry *e;
 
@@ -887,7 +887,7 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 /* Initializes the device->iommu mapping for the driver */
 static int __init init_iommu_devices(struct amd_iommu *iommu)
 {
-	u16 i;
+	u32 i;
 
 	for (i = iommu->first_device; i <= iommu->last_device; ++i)
 		set_iommu_for_device(iommu, i);
@@ -1177,7 +1177,7 @@ static int __init init_memory_definitions(struct acpi_table_header *table)
  */
 static void init_device_table(void)
 {
-	u16 devid;
+	u32 devid;
 
 	for (devid = 0; devid <= amd_iommu_last_bdf; ++devid) {
 		set_dev_entry_bit(devid, DEV_ENTRY_VALID);
-- 
1.7.4.1


