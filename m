Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab0HSR0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 13:26:16 -0400
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:46793 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751641Ab0HSR0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 13:26:10 -0400
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Aug 2010 13:26:09 EDT
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: linux-kernel@vger.kernel.org
Cc: Hagen Paul Pfeifer <hagen@jauu.net>
Subject: [PATCH 2/2] replace nested max/min macros with {max,min}3 macro
Date: Thu, 19 Aug 2010 19:18:19 +0200
Message-Id: <1282238299-28315-2-git-send-email-hagen@jauu.net>
X-Mailer: git-send-email 1.7.2.1.95.g3d045.dirty
In-Reply-To: <1282238299-28315-1-git-send-email-hagen@jauu.net>
References: <1282238299-28315-1-git-send-email-hagen@jauu.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new {max,min}3 macros to save some cycles and bytes on the
stack. This patch substitutes trivial nested macros with their
counterpart.

Signed-off-by: Hagen Paul Pfeifer <hagen@jauu.net>
---
 arch/arm/mach-ep93xx/clock.c              |    3 +--
 arch/powerpc/kernel/vio.c                 |    4 +---
 arch/x86/kernel/cpu/intel_cacheinfo.c     |    1 +
 drivers/crypto/hifn_795x.c                |    4 ++--
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    3 +--
 drivers/macintosh/windfarm_pm121.c        |    2 +-
 drivers/video/au1200fb.c                  |    2 +-
 mm/slab.c                                 |    2 +-
 8 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-ep93xx/clock.c b/arch/arm/mach-ep93xx/clock.c
index 8bf3cec..d2722c7 100644
--- a/arch/arm/mach-ep93xx/clock.c
+++ b/arch/arm/mach-ep93xx/clock.c
@@ -358,8 +358,7 @@ static int calc_clk_div(struct clk *clk, unsigned long rate,
 	int i, found = 0, __div = 0, __pdiv = 0;
 
 	/* Don't exceed the maximum rate */
-	max_rate = max(max(clk_pll1.rate / 4, clk_pll2.rate / 4),
-		       clk_xtali.rate / 4);
+	max_rate = max3(clk_pll1.rate / 4, clk_pll2.rate / 4, clk_xtali.rate / 4);
 	rate = min(rate, max_rate);
 
 	/*
diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index 00b9436..ccbf1bc 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -238,9 +238,7 @@ static inline void vio_cmo_dealloc(struct vio_dev *viodev, size_t size)
 	 * memory in this pool does not change.
 	 */
 	if (spare_needed && reserve_freed) {
-		tmp = min(spare_needed, min(reserve_freed,
-		                            (viodev->cmo.entitled -
-		                             VIO_CMO_MIN_ENT)));
+		tmp = min3(spare_needed, reserve_freed, (viodev->cmo.entitled - VIO_CMO_MIN_ENT));
 
 		vio_cmo.spare += tmp;
 		viodev->cmo.entitled -= tmp;
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 898c2f4..5ffc0f5 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -327,6 +327,7 @@ static void __cpuinit amd_calc_l3_indices(struct amd_l3_cache *l3)
 	l3->subcaches[3] = sc3 = !(val & BIT(12)) + !(val & BIT(13));
 
 	l3->indices = (max(max(max(sc0, sc1), sc2), sc3) << 10) - 1;
+	l3->indices = (max(max3(sc0, sc1, sc2), sc3) << 10) - 1;
 }
 
 static struct amd_l3_cache * __cpuinit amd_init_l3_cache(int node)
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index e449ac5..ce3039d 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -1467,7 +1467,7 @@ static int ablkcipher_add(unsigned int *drestp, struct scatterlist *dst,
 		return -EINVAL;
 
 	while (size) {
-		copy = min(drest, min(size, dst->length));
+		copy = min3(drest, size, dst->length);
 
 		size -= copy;
 		drest -= copy;
@@ -1729,7 +1729,7 @@ static int ablkcipher_get(void *saddr, unsigned int *srestp, unsigned int offset
 		return -EINVAL;
 
 	while (size) {
-		copy = min(srest, min(dst->length, size));
+		copy = min3(srest, dst->length, size);
 
 		daddr = kmap_atomic(sg_page(dst), KM_IRQ0);
 		memcpy(daddr + dst->offset + offset, saddr, copy);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index b4b2257..19c5d3b 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1409,8 +1409,7 @@ static int __init ipoib_init_module(void)
 
 	ipoib_sendq_size = roundup_pow_of_two(ipoib_sendq_size);
 	ipoib_sendq_size = min(ipoib_sendq_size, IPOIB_MAX_QUEUE_SIZE);
-	ipoib_sendq_size = max(ipoib_sendq_size, max(2 * MAX_SEND_CQE,
-						     IPOIB_MIN_QUEUE_SIZE));
+	ipoib_sendq_size = max3(ipoib_sendq_size, 2 * MAX_SEND_CQE, IPOIB_MIN_QUEUE_SIZE);
 #ifdef CONFIG_INFINIBAND_IPOIB_CM
 	ipoib_max_conn_qp = min(ipoib_max_conn_qp, IPOIB_CM_MAX_CONN_QP);
 #endif
diff --git a/drivers/macintosh/windfarm_pm121.c b/drivers/macintosh/windfarm_pm121.c
index 947d4af..30e6195 100644
--- a/drivers/macintosh/windfarm_pm121.c
+++ b/drivers/macintosh/windfarm_pm121.c
@@ -482,7 +482,7 @@ static s32 pm121_correct(s32 new_setpoint,
 	new_min += correction->offset;
 	new_min = (new_min >> 16) + min;
 
-	return max(new_setpoint, max(new_min, 0));
+	return max3(new_setpoint, new_min, 0);
 }
 
 static s32 pm121_connect(unsigned int control_id, s32 setpoint)
diff --git a/drivers/video/au1200fb.c b/drivers/video/au1200fb.c
index e77e8e4..4ea187d 100644
--- a/drivers/video/au1200fb.c
+++ b/drivers/video/au1200fb.c
@@ -1079,7 +1079,7 @@ static int au1200fb_fb_check_var(struct fb_var_screeninfo *var,
 	 * clock can only be obtain by dividing this value by an even integer.
 	 * Fallback to a slower pixel clock if necessary. */
 	pixclock = max((u32)(PICOS2KHZ(var->pixclock) * 1000), fbi->monspecs.dclkmin);
-	pixclock = min(pixclock, min(fbi->monspecs.dclkmax, (u32)AU1200_LCD_MAX_CLK/2));
+	pixclock = min3(pixclock, fbi->monspecs.dclkmax, (u32)AU1200_LCD_MAX_CLK/2);
 
 	if (AU1200_LCD_MAX_CLK % pixclock) {
 		int diff = AU1200_LCD_MAX_CLK % pixclock;
diff --git a/mm/slab.c b/mm/slab.c
index 88435fc..309cc2e 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -901,7 +901,7 @@ static int transfer_objects(struct array_cache *to,
 		struct array_cache *from, unsigned int max)
 {
 	/* Figure out how many entries to transfer */
-	int nr = min(min(from->avail, max), to->limit - to->avail);
+	int nr = min3(from->avail, max, to->limit - to->avail);
 
 	if (!nr)
 		return 0;
-- 
1.7.2.1.95.g3d045.dirty

