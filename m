Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab1GWPvp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 11:51:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:36331 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab1GWPvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 11:51:40 -0400
Message-Id: <20110723154916.323967213@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 23 Jul 2011 15:51:37 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Yegor Yefremov <yegorslists@googlemail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [patch] ide: Fix irq flags madness
Content-Disposition: inline; filename=drivers-ide-fix-irq-flags-madness.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit ec1a123 (IDE: pass IRQ flags to the IDE core) introduced the
bogosity of passing unfiltered resource->flags to the irq_flags which
are used for request_irq. It results in random bits set (especially
IORESOURCE_IRQ which maps to IRQF_PER_CPU).

Filter the bits proper.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Yegor Yefremov <yegorslists@googlemail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/ide/ide_platform.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/ide/ide_platform.c
===================================================================
--- linux-2.6.orig/drivers/ide/ide_platform.c
+++ linux-2.6/drivers/ide/ide_platform.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/ata_platform.h>
 #include <linux/platform_device.h>
+#include <linux/interrupt.h>
 #include <linux/io.h>
 
 static void __devinit plat_ide_setup_ports(struct ide_hw *hw,
@@ -95,7 +96,10 @@ static int __devinit plat_ide_probe(stru
 	plat_ide_setup_ports(&hw, base, alt_base, pdata, res_irq->start);
 	hw.dev = &pdev->dev;
 
-	d.irq_flags = res_irq->flags;
+	d.irq_flags = res_irq->flags & IRQF_TRIGGER_MASK;
+	if (res_irq->flags & IORESOURCE_IRQ_SHAREABLE)
+		d.irq_flags |= IRQF_SHARED;
+
 	if (mmio)
 		d.host_flags |= IDE_HFLAG_MMIO;
 


