Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab2E2KaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 06:30:08 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:47392 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753139Ab2E2KaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 06:30:06 -0400
Date: Tue, 29 May 2012 12:30:02 +0200
From: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        vamos-dev@lists.cs.fau.de
Subject: [PATCH] ide: icside.c: Fix compile with CONFIG_BLK_DEV_IDEDMA_ICS=n
Message-ID: <20120529103002.GA13283@faui49q.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The icside driver can be configured without DMA support, but it
doesn't compile in this case, because DMA operations are referenced.

drivers/ide/icside.c:523: error: ‘icside_v6_port_ops’ undeclared
drivers/ide/icside.c:522: error: ‘icside_dma_init’ undeclared

Signed-off-by: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
---
 drivers/ide/icside.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

I attach the configuration, that exposes this compilation error. This patch was
*NOT* tested on real hardware. I don't if the fix really does solve the
problem, but at least it is a hint that there is a problem.

diff --git a/drivers/ide/icside.c b/drivers/ide/icside.c
index 8716066..62c59c1 100644
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -271,7 +271,7 @@ static void icside_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 
 	ide_set_drivedata(drive, (void *)cycle_time);
 
-	printk("%s: %s selected (peak %dMB/s)\n", drive->name,
+	printk("%s: %s selected (peak %ldMB/s)\n", drive->name,
 		ide_xfer_verbose(xfer_mode),
 		2000 / (unsigned long)ide_get_drivedata(drive));
 }
@@ -456,7 +456,9 @@ err_free:
 static const struct ide_port_info icside_v6_port_info __initdata = {
 	.init_dma		= icside_dma_off_init,
 	.port_ops		= &icside_v6_no_dma_port_ops,
+#ifdef CONFIG_BLK_DEV_IDEDMA_ICS
 	.dma_ops		= &icside_v6_dma_ops,
+#endif
 	.host_flags		= IDE_HFLAG_SERIALIZE | IDE_HFLAG_MMIO,
 	.mwdma_mask		= ATA_MWDMA2,
 	.swdma_mask		= ATA_SWDMA2,
@@ -518,10 +520,12 @@ icside_register_v6(struct icside_state *state, struct expansion_card *ec)
 
 	ecard_set_drvdata(ec, state);
 
+#ifdef CONFIG_BLK_DEV_IDEDMA_ICS
 	if (ec->dma != NO_DMA && !request_dma(ec->dma, DRV_NAME)) {
 		d.init_dma = icside_dma_init;
 		d.port_ops = &icside_v6_port_ops;
 	} else
+#endif
 		d.dma_ops = NULL;
 
 	ret = ide_host_register(host, &d, hws);
-- 
1.7.5.4

