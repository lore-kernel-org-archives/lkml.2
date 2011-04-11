Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab1DKHKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 03:10:19 -0400
Received: from portal.weinmann.de ([62.8.140.122]:58694 "EHLO
	portal.weinmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab1DKHKR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 03:10:17 -0400
X-Greylist: delayed 968 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Apr 2011 03:10:17 EDT
From: "Voss, Nikolaus" <N.Voss@weinmann.de>
To: "'Linux Kernel'" <linux-kernel@vger.kernel.org>
CC: "'Nicolas Ferre'" <nicolas.ferre@atmel.com>
Date: Mon, 11 Apr 2011 08:53:59 +0200
Subject: [PATCH] drivers/spi/atmel_spi.c: prevent premature irqs
Thread-Topic: [PATCH] drivers/spi/atmel_spi.c: prevent premature irqs
Thread-Index: Acv4FTvHRZpzDbxUT3eSOlVby4qKqA==
Message-ID: <EF2E73589CA71846A15D0B2CDF79505D086F931361@wm021.weinmann.com>
Accept-Language: en-US, de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When restarting a kernel using kexec, filled rx buffers on SPI master
interface reliably crash the kernel. This patch disables rx interrupts
on startup to avoid this. Interrupts will be regulary enabled at start
of a new SPI master transfer.

Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
---
 drivers/spi/atmel_spi.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/atmel_spi.c
index 1a478bf..d17f14c 100644
--- a/drivers/spi/atmel_spi.c
+++ b/drivers/spi/atmel_spi.c
@@ -811,6 +811,9 @@ static int __init atmel_spi_probe(struct platform_device *pdev)
 	as->irq = irq;
 	as->clk = clk;
 
+	/* disable rx interrupts to avoid premature irq triggering */
+	spi_writel(as, IDR, SPI_BIT(RXBUFF) | SPI_BIT(ENDRX) | SPI_BIT(OVRES));
+
 	ret = request_irq(irq, atmel_spi_interrupt, 0,
 			dev_name(&pdev->dev), master);
 	if (ret)
-- 
1.5.4.3

