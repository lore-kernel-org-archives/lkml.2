Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab0JPWbe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 18:31:34 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45069 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472Ab0JPWbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 18:31:33 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH] mtd/maps: gpio-addr-flash: fix warnings and make more portable
Date: Sat, 16 Oct 2010 18:31:14 -0400
Message-Id: <1287268274-9750-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As reported on lkml, building this module for HIMEM systems spews warnings
about mismatch in pointer types.  Further, we need to use ioremap() in order
to properly access the flash memory on most systems rather than just doing
it directly.

Reported-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/mtd/maps/gpio-addr-flash.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/maps/gpio-addr-flash.c b/drivers/mtd/maps/gpio-addr-flash.c
index 32e89d7..af5707a 100644
--- a/drivers/mtd/maps/gpio-addr-flash.c
+++ b/drivers/mtd/maps/gpio-addr-flash.c
@@ -208,10 +208,14 @@ static int __devinit gpio_flash_probe(struct platform_device *pdev)
 	if (!state)
 		return -ENOMEM;
 
+	/*
+	 * We cast start/end to known types in the boards file, so cast
+	 * away their pointer types here to the known types (gpios->xxx).
+	 */
 	state->gpio_count     = gpios->end;
-	state->gpio_addrs     = (void *)gpios->start;
+	state->gpio_addrs     = (void *)(unsigned long)gpios->start;
 	state->gpio_values    = (void *)(state + 1);
-	state->win_size       = memory->end - memory->start + 1;
+	state->win_size       = resource_size(memory);
 	memset(state->gpio_values, 0xff, arr_size);
 
 	state->map.name       = DRIVER_NAME;
@@ -221,7 +225,7 @@ static int __devinit gpio_flash_probe(struct platform_device *pdev)
 	state->map.copy_to    = gf_copy_to;
 	state->map.bankwidth  = pdata->width;
 	state->map.size       = state->win_size * (1 << state->gpio_count);
-	state->map.virt       = (void __iomem *)memory->start;
+	state->map.virt       = ioremap_nocache(memory->start, state->map.size);
 	state->map.phys       = NO_XIP;
 	state->map.map_priv_1 = (unsigned long)state;
 
-- 
1.7.3.1

