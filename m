Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab2D3NRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 09:17:07 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:44301 "HELO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752266Ab2D3NRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 09:17:05 -0400
From: Yilu Mao <ylmao@marvell.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, Baohua.Song@csr.com, santosh.shilimkar@ti.com,
        robherring2@gmail.com, catalin.marinas@arm.com,
        linux-arm-kernel@lists.infradead.org, Yilu Mao <ylmao@marvell.com>
Subject: [PATCH v4] ARM: cache-l2x0.c: save aux ctrl for resume in case l2x0 is enabled before init
Date: Mon, 30 Apr 2012 21:16:26 +0800
Message-Id: <1335791786-32377-1-git-send-email-ylmao@marvell.com>
X-Mailer: git-send-email 1.7.5.4
X-OriginalArrivalTime: 30 Apr 2012 13:16:34.0060 (UTC) FILETIME=[77084CC0:01CD26D3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If l2x0 controller has been enabled when calling l2x0_init, the aux ctrl
register will not be saved in l2x0_saved_regs. Therefore we can not use
l2x0_saved_regs.aux_ctrl for resume later. This patch fixed the problem
by saving aux ctrl in l2x0_saved_regs just after it's being read from
the register.
And in case some bits of aux ctrl register are reserved, re-read and
save it properly after set it if l2x0 is disabled before init.

Change-Id: I54f3002274ffe9cdc667dba81e36e08f2e121467
Signed-off-by: Yilu Mao <ylmao@marvell.com>
---
 arch/arm/mm/cache-l2x0.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index a53fd2a..9893e58 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -320,6 +320,13 @@ void __init l2x0_init(void __iomem *base, u32 aux_val, u32 aux_mask)
 	cache_id = readl_relaxed(l2x0_base + L2X0_CACHE_ID);
 	aux = readl_relaxed(l2x0_base + L2X0_AUX_CTRL);
 
+	/*
+	 * In case l2x controller is enabled, the aux ctrl register
+	 * can't be set. So the original value should be stored in
+	 * the l2x0_saved_regs for restoring when resume.
+	 */
+	l2x0_saved_regs.aux_ctrl = aux;
+
 	aux &= aux_mask;
 	aux |= aux_val;
 
@@ -364,6 +371,8 @@ void __init l2x0_init(void __iomem *base, u32 aux_val, u32 aux_mask)
 		/* l2x0 controller is disabled */
 		writel_relaxed(aux, l2x0_base + L2X0_AUX_CTRL);
 
+		/* Re-read it in case some bits are reserved. */
+		aux = readl_relaxed(l2x0_base + L2X0_AUX_CTRL);
 		l2x0_saved_regs.aux_ctrl = aux;
 
 		l2x0_inv_all();
-- 
1.7.5.4

