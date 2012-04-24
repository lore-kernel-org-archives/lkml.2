Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab2DXWe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:34:26 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:49931 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932288Ab2DXWeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:34:21 -0400
Message-Id: <20120424223242.772599478@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:32:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Paul Walmsley <paul@pwsan.com>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [ 09/62] ARM: OMAP1: DMTIMER: fix broken timer clock source selection
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap1/timer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-omap1/timer.c
+++ b/arch/arm/mach-omap1/timer.c
@@ -47,9 +47,9 @@ static int omap1_dm_timer_set_src(struct
 	int n = (pdev->id - 1) << 1;
 	u32 l;
 
-	l = __raw_readl(MOD_CONF_CTRL_1) & ~(0x03 << n);
+	l = omap_readl(MOD_CONF_CTRL_1) & ~(0x03 << n);
 	l |= source << n;
-	__raw_writel(l, MOD_CONF_CTRL_1);
+	omap_writel(l, MOD_CONF_CTRL_1);
 
 	return 0;
 }


