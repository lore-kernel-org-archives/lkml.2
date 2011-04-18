Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab1DRNqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 09:46:46 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:15922
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754238Ab1DRNp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 09:45:59 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bh8275dhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJUOWE-02-4YB-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 1/4] x86, gart: Don't enforce GART aperture lower-bound by alignment
Date: Mon, 18 Apr 2011 15:45:43 +0200
Message-ID: <1303134346-5805-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1303134346-5805-1-git-send-email-joerg.roedel@amd.com>
References: <1303134346-5805-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the allocation of the GART aperture to
enforce only natural alignment instead of aligning it on
512MB. This big alignment was used to force the GART
aperture to be over 512MB. This is enforced by using 512MB
as the lower-bound address in the allocation range.

Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/aperture_64.c |   34 +++++++++++++++++++---------------
 1 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 86d1ad4..5c66a2f 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -30,6 +30,22 @@
 #include <asm/amd_nb.h>
 #include <asm/x86_init.h>
 
+/*
+ * Using 512M as goal, in case kexec will load kernel_big
+ * that will do the on-position decompress, and could overlap with
+ * with the gart aperture that is used.
+ * Sequence:
+ * kernel_small
+ * ==> kexec (with kdump trigger path or gart still enabled)
+ * ==> kernel_small (gart area become e820_reserved)
+ * ==> kexec (with kdump trigger path or gart still enabled)
+ * ==> kerne_big (uncompressed size will be big than 64M or 128M)
+ * So don't use 512M below as gart iommu, leave the space for kernel
+ * code for safe.
+ */
+#define GART_MIN_ADDR	(512ULL << 20)
+#define GART_MAX_ADDR	(1ULL   << 32)
+
 int gart_iommu_aperture;
 int gart_iommu_aperture_disabled __initdata;
 int gart_iommu_aperture_allowed __initdata;
@@ -70,21 +86,9 @@ static u32 __init allocate_aperture(void)
 	 * memory. Unfortunately we cannot move it up because that would
 	 * make the IOMMU useless.
 	 */
-	/*
-	 * using 512M as goal, in case kexec will load kernel_big
-	 * that will do the on position decompress, and  could overlap with
-	 * that position with gart that is used.
-	 * sequende:
-	 * kernel_small
-	 * ==> kexec (with kdump trigger path or previous doesn't shutdown gart)
-	 * ==> kernel_small(gart area become e820_reserved)
-	 * ==> kexec (with kdump trigger path or previous doesn't shutdown gart)
-	 * ==> kerne_big (uncompressed size will be big than 64M or 128M)
-	 * so don't use 512M below as gart iommu, leave the space for kernel
-	 * code for safe
-	 */
-	addr = memblock_find_in_range(0, 1ULL<<32, aper_size, 512ULL<<20);
-	if (addr == MEMBLOCK_ERROR || addr + aper_size > 0xffffffff) {
+	addr = memblock_find_in_range(GART_MIN_ADDR, GART_MAX_ADDR,
+				      aper_size, aper_size);
+	if (addr == MEMBLOCK_ERROR || addr + aper_size > GART_MAX_ADDR) {
 		printk(KERN_ERR
 			"Cannot allocate aperture memory hole (%lx,%uK)\n",
 				addr, aper_size>>10);
-- 
1.7.1


