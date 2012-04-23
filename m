Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab2DWHoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 03:44:25 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:41123 "HELO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751690Ab2DWHoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 03:44:24 -0400
From: Yilu Mao <ylmao@marvell.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, Baohua.Song@csr.com, santosh.shilimkar@ti.com,
        robherring2@gmail.com, catalin.marinas@arm.com,
        linux-arm-kernel@lists.infradead.org, Yilu Mao <ylmao@marvell.com>
Subject: [PATCH] ARM: cache-l2x0.c: save aux ctrl for resume in case that l2x0 is enabled before init
Date: Mon, 23 Apr 2012 15:43:21 +0800
Message-Id: <1335167001-28031-1-git-send-email-ylmao@marvell.com>
X-Mailer: git-send-email 1.7.5.4
X-OriginalArrivalTime: 23 Apr 2012 07:44:09.0926 (UTC) FILETIME=[DE82B660:01CD2124]
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
 arch/arm/mm/cache-l2x0.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index 8936595..3b6428b 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -362,6 +362,11 @@ void __init l2x0_init(void __iomem *base, u32 aux_val, u32 aux_mask)
 	l2x0_cache_id = readl_relaxed(l2x0_base + L2X0_CACHE_ID);
 	aux = readl_relaxed(l2x0_base + L2X0_AUX_CTRL);
 
+	/* In case l2x controller is enabled, the aux ctrl register
+	 * can't be set. So the original value should be stored in
+	 * the l2x0_saved_regs for restoring when resume. */
+	l2x0_saved_regs.aux_ctrl = aux;
+
 	aux &= aux_mask;
 	aux |= aux_val;
 
-- 
1.7.0.4

