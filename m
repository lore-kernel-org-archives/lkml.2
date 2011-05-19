Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934792Ab1ESU6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:58:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46492 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933993Ab1ESU6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:58:42 -0400
Date: Thu, 19 May 2011 22:58:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/gart change for v2.6.40
Message-ID: <20110519205834.GA5644@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-gart-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-gart-for-linus

 Thanks,

	Ingo

------------------>
Joerg Roedel (1):
      x86, gart: Don't enforce GART aperture lower-bound by alignment


 arch/x86/kernel/aperture_64.c |   34 +++++++++++++++++++---------------
 1 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 73fb469..3d2661c 100644
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
