Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab2DZFP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 01:15:57 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:35016 "HELO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751060Ab2DZFPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 01:15:55 -0400
From: Yilu Mao <ylmao@marvell.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, Baohua.Song@csr.com, santosh.shilimkar@ti.com,
        robherring2@gmail.com, catalin.marinas@arm.com,
        linux-arm-kernel@lists.infradead.org, Yilu Mao <ylmao@marvell.com>
Subject: [PATCH v3] ARM: cache-l2x0.c: save aux ctrl for resume in case that l2x0 is enabled before init
Date: Thu, 26 Apr 2012 13:08:57 +0800
Message-Id: <1335416937-24724-1-git-send-email-ylmao@marvell.com>
X-Mailer: git-send-email 1.7.5.4
X-OriginalArrivalTime: 26 Apr 2012 05:09:11.0061 (UTC) FILETIME=[B731C450:01CD236A]
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
 arch/arm/mm/cache-l2x0.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index a53fd2a..f273c7e 100644
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
 
-- 
1.7.5.4

