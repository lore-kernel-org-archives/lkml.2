Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610Ab2EIGdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:33:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38663 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754562Ab2EIFwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:40 -0400
Message-Id: <20120509055030.451103266@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:50:35 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Paul Walmsley <paul@pwsan.com>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [ 006/167] [PATCH] ARM: OMAP1: DMTIMER: fix broken timer clock source selection
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Walmsley <paul@pwsan.com>

commit 6aaec67da1e41a0752a2b903b989e73b9f02e182 upstream.

DMTIMER source selection on OMAP1 is broken.  omap1_dm_timer_set_src()
tries to use __raw_{read,write}l() to read from and write to physical
addresses, but those functions take virtual addresses.

sparse caught this:

arch/arm/mach-omap1/timer.c:50:13: warning: incorrect type in argument 1 (different base types)
arch/arm/mach-omap1/timer.c:50:13:    expected void const volatile [noderef] <asn:2>*<noident>
arch/arm/mach-omap1/timer.c:50:13:    got unsigned int
arch/arm/mach-omap1/timer.c:52:9: warning: incorrect type in argument 1 (different base types)
arch/arm/mach-omap1/timer.c:52:9:    expected void const volatile [noderef] <asn:2>*<noident>
arch/arm/mach-omap1/timer.c:52:9:    got unsigned int

Fix by using omap_{read,writel}(), just like the other users of the
MOD_CONF_CTRL_1 register in the OMAP1 codebase.  Of course, in the long term,
removing omap_{read,write}l() is the appropriate thing to do; but
this will take some work to do this cleanly.

Looks like this was caused by 97933d6 (ARM: OMAP1: dmtimer: conversion
to platform devices) that dangerously moved code and changed it in
the same patch.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Tarun Kanti DebBarma <tarun.kanti@ti.com>
[tony@atomide.com: updated comments to include the breaking commit]
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mach-omap1/timer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap1/timer.c b/arch/arm/mach-omap1/timer.c
index 6e90665..fb202af 100644
--- a/arch/arm/mach-omap1/timer.c
+++ b/arch/arm/mach-omap1/timer.c
@@ -47,9 +47,9 @@ static int omap1_dm_timer_set_src(struct platform_device *pdev,
 	int n = (pdev->id - 1) << 1;
 	u32 l;
 
-	l = __raw_readl(MOD_CONF_CTRL_1) & ~(0x03 << n);
+	l = omap_readl(MOD_CONF_CTRL_1) & ~(0x03 << n);
 	l |= source << n;
-	__raw_writel(l, MOD_CONF_CTRL_1);
+	omap_writel(l, MOD_CONF_CTRL_1);
 
 	return 0;
 }
-- 
1.7.10



