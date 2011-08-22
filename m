Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab1HVXrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 19:47:48 -0400
Received: from lunge.queued.net ([173.255.254.236]:35435 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab1HVXro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 19:47:44 -0400
Date: Mon, 22 Aug 2011 16:47:40 -0700
From: Andres Salomon <dilinger@queued.net>
To: Leo Yan <leoy@marvell.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <hzhuang1@marvell.com>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>
Subject: [PATCH] ARM: mmp: map sram as MT_MEMORY rather than MT_DEVICE
Message-ID: <20110822164740.5682541b@queued.net>
In-Reply-To: <1313377794-26721-2-git-send-email-leoy@marvell.com>
References: <1313377794-26721-1-git-send-email-leoy@marvell.com>
	<1313377794-26721-2-git-send-email-leoy@marvell.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sram code allocates memory with ioremap, which assumes MT_DEVICE
for memory protections.  This explodes when we map sram for power
management purposes and then attempt to execute it (jump_to_lp_sram)
on the OLPC XO-1.75.  Instead, we want to specify MT_MEMORY, which
doesn't set the L_PTE_XN bit.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/arm/mach-mmp/sram.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

Eric, this patch is against the devel branch of your pxa tree.

diff --git a/arch/arm/mach-mmp/sram.c b/arch/arm/mach-mmp/sram.c
index 4304f95..ca4d3c1 100644
--- a/arch/arm/mach-mmp/sram.c
+++ b/arch/arm/mach-mmp/sram.c
@@ -21,6 +21,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/genalloc.h>
+#include <asm/mach/map.h>
 
 #include <mach/sram.h>
 
@@ -87,7 +88,8 @@ static int __devinit sram_probe(struct platform_device *pdev)
 
 	info->sram_phys   = (phys_addr_t)res->start;
 	info->sram_size   = resource_size(res);
-	info->sram_virt   = ioremap(info->sram_phys, info->sram_size);
+	info->sram_virt   = __arm_ioremap(info->sram_phys, info->sram_size,
+					  MT_MEMORY);
 	info->pool_name	  = kstrdup(pdata->pool_name, GFP_KERNEL);
 	info->granularity = pdata->granularity;
 
-- 
1.7.2.5

