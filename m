Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab1L0OQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 09:16:27 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53677 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754360Ab1L0OQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 09:16:19 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jingoo Han <jg1.han@samsung.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/6] video: s3c-fb: Use s3c_fb_enable() to enable the framebuffer
Date: Tue, 27 Dec 2011 14:16:08 +0000
Message-Id: <1324995372-3410-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1324995372-3410-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20111227141550.GA3331@opensource.wolfsonmicro.com>
 <1324995372-3410-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The s3c-fb driver has a function called s3c_fb_enable() which turns on
and off the physical output. However it is only actually used in paths
which disable the screen, the enabling just writes to the register. Make
the code less confusing by ensuring that the enable also goes through
the same path.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/s3c-fb.c |   55 ++++++++++++++++++++++++-----------------------
 1 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/video/s3c-fb.c b/drivers/video/s3c-fb.c
index b1a75a0..be4c218 100644
--- a/drivers/video/s3c-fb.c
+++ b/drivers/video/s3c-fb.c
@@ -441,6 +441,32 @@ static void shadow_protect_win(struct s3c_fb_win *win, bool protect)
 }
 
 /**
+ * s3c_fb_enable() - Set the state of the main LCD output
+ * @sfb: The main framebuffer state.
+ * @enable: The state to set.
+ */
+static void s3c_fb_enable(struct s3c_fb *sfb, int enable)
+{
+	u32 vidcon0 = readl(sfb->regs + VIDCON0);
+
+	if (enable)
+		vidcon0 |= VIDCON0_ENVID | VIDCON0_ENVID_F;
+	else {
+		/* see the note in the framebuffer datasheet about
+		 * why you cannot take both of these bits down at the
+		 * same time. */
+
+		if (!(vidcon0 & VIDCON0_ENVID))
+			return;
+
+		vidcon0 |= VIDCON0_ENVID;
+		vidcon0 &= ~VIDCON0_ENVID_F;
+	}
+
+	writel(vidcon0, sfb->regs + VIDCON0);
+}
+
+/**
  * s3c_fb_set_par() - framebuffer request to set new framebuffer state.
  * @info: The framebuffer to change.
  *
@@ -510,9 +536,10 @@ static int s3c_fb_set_par(struct fb_info *info)
 		if (sfb->variant.is_2443)
 			data |= (1 << 5);
 
-		data |= VIDCON0_ENVID | VIDCON0_ENVID_F;
 		writel(data, regs + VIDCON0);
 
+		s3c_fb_enable(sfb, 1);
+
 		data = VIDTCON0_VBPD(var->upper_margin - 1) |
 		       VIDTCON0_VFPD(var->lower_margin - 1) |
 		       VIDTCON0_VSPW(var->vsync_len - 1);
@@ -761,32 +788,6 @@ static int s3c_fb_setcolreg(unsigned regno,
 }
 
 /**
- * s3c_fb_enable() - Set the state of the main LCD output
- * @sfb: The main framebuffer state.
- * @enable: The state to set.
- */
-static void s3c_fb_enable(struct s3c_fb *sfb, int enable)
-{
-	u32 vidcon0 = readl(sfb->regs + VIDCON0);
-
-	if (enable)
-		vidcon0 |= VIDCON0_ENVID | VIDCON0_ENVID_F;
-	else {
-		/* see the note in the framebuffer datasheet about
-		 * why you cannot take both of these bits down at the
-		 * same time. */
-
-		if (!(vidcon0 & VIDCON0_ENVID))
-			return;
-
-		vidcon0 |= VIDCON0_ENVID;
-		vidcon0 &= ~VIDCON0_ENVID_F;
-	}
-
-	writel(vidcon0, sfb->regs + VIDCON0);
-}
-
-/**
  * s3c_fb_blank() - blank or unblank the given window
  * @blank_mode: The blank state from FB_BLANK_*
  * @info: The framebuffer to blank.
-- 
1.7.7.3

