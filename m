Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab2DXCuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 22:50:16 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:42582 "HELO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756267Ab2DXCuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 22:50:14 -0400
From: Yilu Mao <ylmao@marvell.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, Baohua.Song@csr.com, santosh.shilimkar@ti.com,
        robherring2@gmail.com, catalin.marinas@arm.com,
        linux-arm-kernel@lists.infradead.org, Yilu Mao <ylmao@marvell.com>
Subject: [PATCH] ARM: cache-l2x0.c: save aux ctrl for resume in case that l2x0 is enabled before init
Date: Tue, 24 Apr 2012 10:41:20 +0800
Message-Id: <1335235280-25148-1-git-send-email-ylmao@marvell.com>
X-Mailer: git-send-email 1.7.5.4
X-OriginalArrivalTime: 24 Apr 2012 02:41:39.0448 (UTC) FILETIME=[C6654F80:01CD21C3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If l2x0 controller has been enabled when calling l2x0_init, the aux ctrl
register will not be saved in l2x0_saved_regs. Therefore we can not use
l2x0_saved_regs.aux_ctrl for resume later. This patch fixed the problem
by saving aux ctrl in l2x0_saved_regs just after it's being read from
the register.

Signed-off-by: Yilu Mao <ylmao@marvell.com>
---
 arch/arm/mm/cache-l2x0.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index a53fd2a..3034b06 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -320,6 +320,12 @@ void __init l2x0_init(void __iomem *base, u32 aux_val, u32 aux_mask)
 	cache_id = readl_relaxed(l2x0_base + L2X0_CACHE_ID);
 	aux = readl_relaxed(l2x0_base + L2X0_AUX_CTRL);
 
+	/* In case l2x controller is enabled, the aux ctrl register
+	 * can't be set. So the original value should be stored in
+	 * the l2x0_saved_regs for restoring when resume.
+	 */
+	l2x0_saved_regs.aux_ctrl = aux;
+
 	aux &= aux_mask;
 	aux |= aux_val;
 
-- 
1.7.5.4

