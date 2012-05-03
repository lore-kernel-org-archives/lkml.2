Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab2ECMIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:08:37 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:51867 "HELO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752228Ab2ECMIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:08:36 -0400
From: Yilu Mao <ylmao@marvell.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, Baohua.Song@csr.com, santosh.shilimkar@ti.com,
        robherring2@gmail.com, catalin.marinas@arm.com,
        linux-arm-kernel@lists.infradead.org, Yilu Mao <ylmao@marvell.com>
Subject: [PATCH v5] ARM: cache-l2x0.c: save the final aux ctrl value for resuming
Date: Thu,  3 May 2012 20:07:37 +0800
Message-Id: <1336046857-24133-1-git-send-email-ylmao@marvell.com>
X-Mailer: git-send-email 1.7.5.4
X-OriginalArrivalTime: 03 May 2012 12:07:45.0658 (UTC) FILETIME=[598D65A0:01CD2925]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a bug if l2x0 controller has been enabled when calling
l2x0_init, the aux ctrl register will not be saved in l2x0_saved_regs.
Therefore we will use uninitialized l2x0_saved_regs.aux_ctrl for
resuming later.

In this patch, the aux ctrl value is read and saved after it is
initialized. So we have the real value being set for resuming.

Signed-off-by: Yilu Mao <ylmao@marvell.com>
---
 arch/arm/mm/cache-l2x0.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index a53fd2a..670ad48 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -364,14 +364,18 @@ void __init l2x0_init(void __iomem *base, u32 aux_val, u32 aux_mask)
 		/* l2x0 controller is disabled */
 		writel_relaxed(aux, l2x0_base + L2X0_AUX_CTRL);
 
-		l2x0_saved_regs.aux_ctrl = aux;
-
 		l2x0_inv_all();
 
 		/* enable L2X0 */
 		writel_relaxed(1, l2x0_base + L2X0_CTRL);
 	}
 
+	/* Re-read it in case some bits are reserved. */
+	aux = readl_relaxed(l2x0_base + L2X0_AUX_CTRL);
+
+	/* Save the value for resuming. */
+	l2x0_saved_regs.aux_ctrl = aux;
+
 	outer_cache.inv_range = l2x0_inv_range;
 	outer_cache.clean_range = l2x0_clean_range;
 	outer_cache.flush_range = l2x0_flush_range;
-- 
1.7.5.4

