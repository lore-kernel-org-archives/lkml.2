Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab2ENG5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 02:57:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62117 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab2ENG5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 02:57:50 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: linux-next: build failure in Linus' tree
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jean-Francois Dagenais <jeff.dagenais@gmail.com>
In-Reply-To: <20120514105025.0ba1b124f5e9c192fc11e132@canb.auug.org.au>
References: <20120514105025.0ba1b124f5e9c192fc11e132@canb.auug.org.au>
Date: Mon, 14 May 2012 00:57:47 -0600
Message-Id: <20120514065747.D73403E0532@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012 10:50:25 +1000, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Linus,
> 
> Building Linus' tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> ERROR: "handle_edge_irq" [drivers/gpio/gpio-pch.ko] undefined!
> ERROR: "irq_to_desc" [drivers/gpio/gpio-pch.ko] undefined!
> 
> This has been reported elsewhere by DaveM.
> 
> Caused by commit df9541a60af0 ("gpio: pch9: Use proper flow type handlers").
> 
> I have reverted that commit for today.

Gah, I tested that patch with CONFIG_GPIO_PCH=Y, but not as a module.
I see three options here; revert the patch now and fix it up in v3.4,
add exports for those two symbols, or disable building that code as a
module (patch below).  Personally I prefer the third option for the
immediate fix.

g.

>From 7fd0fcff9f0d65734415fed756271c1ae2267666 Mon Sep 17 00:00:00 2001
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 14 May 2012 00:52:49 -0600
Subject: [PATCH] gpio/pch: Fix build failure when selected as a module

x86_64 allmodconfig fails like this:

ERROR: "handle_edge_irq" [drivers/gpio/gpio-pch.ko] undefined!
ERROR: "irq_to_desc" [drivers/gpio/gpio-pch.ko] undefined!

This patch fixes the issue by not allowing gpio-pch.c to be built as a
module.  It can be reenabled when the core interrupt handling code
exports the missing symbols, but that change needs some review first.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/gpio/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index e03653d..db146d5 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -403,7 +403,7 @@ config GPIO_LANGWELL
	  Say Y here to support Intel Langwell/Penwell GPIO.
 
 config GPIO_PCH
-	tristate "Intel EG20T PCH/LAPIS Semiconductor IOH(ML7223/ML7831) GPIO"
+	bool "Intel EG20T PCH/LAPIS Semiconductor IOH(ML7223/ML7831) GPIO"
	depends on PCI && X86
	select GENERIC_IRQ_CHIP
	help
-- 
1.7.9.5



