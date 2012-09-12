Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab2ILHXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 03:23:20 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:33931 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708Ab2ILHXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 03:23:18 -0400
From: wzch <wzch@marvell.com>
To: Russell King <linux@arm.linux.org.uk>,
        Dave Martin <dave.martin@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Wenzeng Chen <wzch@marvell.com>
Subject: [PATCH] ARM: suspend: use flush range instead of flush all
Date: Wed, 12 Sep 2012 15:18:48 +0800
Message-Id: <1347434328-7207-1-git-send-email-wzch@marvell.com>
X-Mailer: git-send-email 1.7.1
X-OriginalArrivalTime: 12 Sep 2012 07:18:52.0653 (UTC) FILETIME=[DCCDB9D0:01CD90B6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wenzeng Chen <wzch@marvell.com>

In cpu suspend function __cpu_suspend_save(), we save cp15 registers,
resume function, sp and suspend_pgd, then flush the data to DDR, but
no need to flush all D cache, only need to flush range.

Change-Id: I591a1fde929f3f987c69306b601843ed975d3e41
Signed-off-by: Wenzeng Chen <wzch@marvell.com>
---
 arch/arm/kernel/suspend.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/suspend.c b/arch/arm/kernel/suspend.c
index 1794cc3..bb582d8 100644
--- a/arch/arm/kernel/suspend.c
+++ b/arch/arm/kernel/suspend.c
@@ -17,6 +17,7 @@ extern void cpu_resume_mmu(void);
  */
 void __cpu_suspend_save(u32 *ptr, u32 ptrsz, u32 sp, u32 *save_ptr)
 {
+	u32 *ptr_orig = ptr;
 	*save_ptr = virt_to_phys(ptr);
 
 	/* This must correspond to the LDM in cpu_resume() assembly */
@@ -26,7 +27,8 @@ void __cpu_suspend_save(u32 *ptr, u32 ptrsz, u32 sp, u32 *save_ptr)
 
 	cpu_do_suspend(ptr);
 
-	flush_cache_all();
+	__cpuc_flush_dcache_area((void *)ptr_orig, ptrsz);
+	__cpuc_flush_dcache_area((void *)save_ptr, sizeof(*save_ptr));
 	outer_clean_range(*save_ptr, *save_ptr + ptrsz);
 	outer_clean_range(virt_to_phys(save_ptr),
 			  virt_to_phys(save_ptr) + sizeof(*save_ptr));
-- 
1.7.1

