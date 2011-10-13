Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab1JMXJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 19:09:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:28707 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755962Ab1JMXI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 19:08:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,343,1315206000"; 
   d="scan'208";a="26560764"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>, David Airlie <airlied@linux.ie>,
        benh@kernel.crashing.org
Subject: [PATCH 05/12] FB_ATY: Move register accesses out of line
Date: Thu, 13 Oct 2011 16:08:45 -0700
Message-Id: <1318547332-23155-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1318547332-23155-1-git-send-email-andi@firstfloor.org>
References: <1318547332-23155-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This fixes size regressions like

radeon_set_suspend                          1724    7873   +6149
radeon_reinitialize_M10                     3974    9285   +5311
radeon_pm_disable_dynamic_mode               868    6125   +5257
radeon_pm_enable_dynamic_mode                985    6065   +5080
radeon_pm_start_mclk_sclk                      -    4614   +4614
radeon_write_mode                           1252    5377   +4125

among others compared to a non force inline kernel.

Cc: David Airlie <airlied@linux.ie>
Cc: benh@kernel.crashing.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/video/aty/radeon_accel.c |   88 ++++++++++++++++++++++++++++++++++
 drivers/video/aty/radeonfb.h     |   96 +++-----------------------------------
 2 files changed, 95 insertions(+), 89 deletions(-)

diff --git a/drivers/video/aty/radeon_accel.c b/drivers/video/aty/radeon_accel.c
index a469a3d..0f1e367 100644
--- a/drivers/video/aty/radeon_accel.c
+++ b/drivers/video/aty/radeon_accel.c
@@ -326,3 +326,91 @@ void radeonfb_engine_init (struct radeonfb_info *rinfo)
 
 	radeon_engine_idle ();
 }
+
+
+void _OUTREGP(struct radeonfb_info *rinfo, u32 addr, u32 val, u32 mask)
+{
+	unsigned long flags;
+	unsigned int tmp;
+
+	spin_lock_irqsave(&rinfo->reg_lock, flags);
+	tmp = INREG(addr);
+	tmp &= (mask);
+	tmp |= (val);
+	OUTREG(addr, tmp);
+	spin_unlock_irqrestore(&rinfo->reg_lock, flags);
+}
+
+
+/*
+ * Note about PLL register accesses:
+ *
+ * I have removed the spinlock on them on purpose. The driver now
+ * expects that it will only manipulate the PLL registers in normal
+ * task environment, where radeon_msleep() will be called, protected
+ * by a semaphore (currently the console semaphore) so that no conflict
+ * will happen on the PLL register index.
+ *
+ * With the latest changes to the VT layer, this is guaranteed for all
+ * calls except the actual drawing/blits which aren't supposed to use
+ * the PLL registers anyway
+ *
+ * This is very important for the workarounds to work properly. The only
+ * possible exception to this rule is the call to unblank(), which may
+ * be done at irq time if an oops is in progress.
+ */
+void radeon_pll_errata_after_index(struct radeonfb_info *rinfo)
+{
+	if (!(rinfo->errata & CHIP_ERRATA_PLL_DUMMYREADS))
+		return;
+
+	(void)INREG(CLOCK_CNTL_DATA);
+	(void)INREG(CRTC_GEN_CNTL);
+}
+
+void radeon_pll_errata_after_data(struct radeonfb_info *rinfo)
+{
+	if (rinfo->errata & CHIP_ERRATA_PLL_DELAY) {
+		/* we can't deal with posted writes here ... */
+		_radeon_msleep(rinfo, 5);
+	}
+	if (rinfo->errata & CHIP_ERRATA_R300_CG) {
+		u32 save, tmp;
+		save = INREG(CLOCK_CNTL_INDEX);
+		tmp = save & ~(0x3f | PLL_WR_EN);
+		OUTREG(CLOCK_CNTL_INDEX, tmp);
+		tmp = INREG(CLOCK_CNTL_DATA);
+		OUTREG(CLOCK_CNTL_INDEX, save);
+	}
+}
+
+u32 __INPLL(struct radeonfb_info *rinfo, u32 addr)
+{
+	u32 data;
+
+	OUTREG8(CLOCK_CNTL_INDEX, addr & 0x0000003f);
+	radeon_pll_errata_after_index(rinfo);
+	data = INREG(CLOCK_CNTL_DATA);
+	radeon_pll_errata_after_data(rinfo);
+	return data;
+}
+
+void __OUTPLL(struct radeonfb_info *rinfo, unsigned int index, u32 val)
+{
+
+	OUTREG8(CLOCK_CNTL_INDEX, (index & 0x0000003f) | 0x00000080);
+	radeon_pll_errata_after_index(rinfo);
+	OUTREG(CLOCK_CNTL_DATA, val);
+	radeon_pll_errata_after_data(rinfo);
+}
+
+void __OUTPLLP(struct radeonfb_info *rinfo, unsigned int index, u32 val, u32 mask)
+{
+	unsigned int tmp;
+
+	tmp  = __INPLL(rinfo, index);
+	tmp &= (mask);
+	tmp |= (val);
+	__OUTPLL(rinfo, index, tmp);
+}
+
diff --git a/drivers/video/aty/radeonfb.h b/drivers/video/aty/radeonfb.h
index 7351e66..cde9c2e 100644
--- a/drivers/video/aty/radeonfb.h
+++ b/drivers/video/aty/radeonfb.h
@@ -393,98 +393,16 @@ static inline void _radeon_msleep(struct radeonfb_info *rinfo, unsigned long ms)
 #define INREG(addr)		readl((rinfo->mmio_base)+addr)
 #define OUTREG(addr,val)	writel(val, (rinfo->mmio_base)+addr)
 
-static inline void _OUTREGP(struct radeonfb_info *rinfo, u32 addr,
-		       u32 val, u32 mask)
-{
-	unsigned long flags;
-	unsigned int tmp;
-
-	spin_lock_irqsave(&rinfo->reg_lock, flags);
-	tmp = INREG(addr);
-	tmp &= (mask);
-	tmp |= (val);
-	OUTREG(addr, tmp);
-	spin_unlock_irqrestore(&rinfo->reg_lock, flags);
-}
+void _OUTREGP(struct radeonfb_info *rinfo, u32 addr, u32 val, u32 mask);
+void __OUTPLLP(struct radeonfb_info *rinfo, unsigned int index,
+			     u32 val, u32 mask);
+void __OUTPLL(struct radeonfb_info *rinfo, unsigned int index, u32 val);
+u32 __INPLL(struct radeonfb_info *rinfo, u32 addr);
+void radeon_pll_errata_after_data(struct radeonfb_info *rinfo);
+void radeon_pll_errata_after_index(struct radeonfb_info *rinfo);
 
 #define OUTREGP(addr,val,mask)	_OUTREGP(rinfo, addr, val,mask)
 
-/*
- * Note about PLL register accesses:
- *
- * I have removed the spinlock on them on purpose. The driver now
- * expects that it will only manipulate the PLL registers in normal
- * task environment, where radeon_msleep() will be called, protected
- * by a semaphore (currently the console semaphore) so that no conflict
- * will happen on the PLL register index.
- *
- * With the latest changes to the VT layer, this is guaranteed for all
- * calls except the actual drawing/blits which aren't supposed to use
- * the PLL registers anyway
- *
- * This is very important for the workarounds to work properly. The only
- * possible exception to this rule is the call to unblank(), which may
- * be done at irq time if an oops is in progress.
- */
-static inline void radeon_pll_errata_after_index(struct radeonfb_info *rinfo)
-{
-	if (!(rinfo->errata & CHIP_ERRATA_PLL_DUMMYREADS))
-		return;
-
-	(void)INREG(CLOCK_CNTL_DATA);
-	(void)INREG(CRTC_GEN_CNTL);
-}
-
-static inline void radeon_pll_errata_after_data(struct radeonfb_info *rinfo)
-{
-	if (rinfo->errata & CHIP_ERRATA_PLL_DELAY) {
-		/* we can't deal with posted writes here ... */
-		_radeon_msleep(rinfo, 5);
-	}
-	if (rinfo->errata & CHIP_ERRATA_R300_CG) {
-		u32 save, tmp;
-		save = INREG(CLOCK_CNTL_INDEX);
-		tmp = save & ~(0x3f | PLL_WR_EN);
-		OUTREG(CLOCK_CNTL_INDEX, tmp);
-		tmp = INREG(CLOCK_CNTL_DATA);
-		OUTREG(CLOCK_CNTL_INDEX, save);
-	}
-}
-
-static inline u32 __INPLL(struct radeonfb_info *rinfo, u32 addr)
-{
-	u32 data;
-
-	OUTREG8(CLOCK_CNTL_INDEX, addr & 0x0000003f);
-	radeon_pll_errata_after_index(rinfo);
-	data = INREG(CLOCK_CNTL_DATA);
-	radeon_pll_errata_after_data(rinfo);
-	return data;
-}
-
-static inline void __OUTPLL(struct radeonfb_info *rinfo, unsigned int index,
-			    u32 val)
-{
-
-	OUTREG8(CLOCK_CNTL_INDEX, (index & 0x0000003f) | 0x00000080);
-	radeon_pll_errata_after_index(rinfo);
-	OUTREG(CLOCK_CNTL_DATA, val);
-	radeon_pll_errata_after_data(rinfo);
-}
-
-
-static inline void __OUTPLLP(struct radeonfb_info *rinfo, unsigned int index,
-			     u32 val, u32 mask)
-{
-	unsigned int tmp;
-
-	tmp  = __INPLL(rinfo, index);
-	tmp &= (mask);
-	tmp |= (val);
-	__OUTPLL(rinfo, index, tmp);
-}
-
-
 #define INPLL(addr)			__INPLL(rinfo, addr)
 #define OUTPLL(index, val)		__OUTPLL(rinfo, index, val)
 #define OUTPLLP(index, val, mask)	__OUTPLLP(rinfo, index, val, mask)
-- 
1.7.4.4

