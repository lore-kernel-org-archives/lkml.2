Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934059Ab2FEMXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 08:23:36 -0400
Received: from mailgate.zerties.org ([176.9.120.153]:33651 "EHLO
	gandalf.zerties.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025Ab2FEMXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 08:23:34 -0400
From: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
To: David Miller <davem@davemloft.net>
Cc: sshtylyov@mvista.com, christian.dietrich@informatik.uni-erlangen.de,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        vamos-dev@lists.cs.fau.de
Subject: Re: [PATCH] ide: icside.c: Fix compile with CONFIG_BLK_DEV_IDEDMA_ICS=n
References: <20120529103002.GA13283@faui49q.informatik.uni-erlangen.de>
	<4FC4C391.50700@mvista.com> <86lik87jgw.fsf@gandalf.zerties.org>
	<20120602.171210.1245211360510437081.davem@davemloft.net>
Date: Tue, 05 Jun 2012 14:23:20 +0200
In-Reply-To: <20120602.171210.1245211360510437081.davem@davemloft.net> (David
	Miller's message of "Sat, 02 Jun 2012 17:12:10 -0400 (EDT)")
Message-ID: <864nqq3q2v.fsf@gandalf.zerties.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The icside driver can be configured without DMA support, but it
doesn't compile then, because DMA operations are referenced.

drivers/ide/icside.c:523: error: 'icside_v6_port_ops' undeclared
drivers/ide/icside.c:522: error: 'icside_dma_init' undeclared

Signed-off-by: Christian Dietrich<christian.dietrich@informatik.uni-erlangen.de>
---
 drivers/ide/icside.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/ide/icside.c b/drivers/ide/icside.c
index 8716066..83e5100 100644
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -375,8 +375,6 @@ static const struct ide_dma_ops icside_v6_dma_ops = {
 	.dma_test_irq		= icside_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 };
-#else
-#define icside_v6_dma_ops NULL
 #endif
 
 static int icside_dma_off_init(ide_hwif_t *hwif, const struct ide_port_info *d)
@@ -456,7 +454,6 @@ err_free:
 static const struct ide_port_info icside_v6_port_info __initdata = {
 	.init_dma		= icside_dma_off_init,
 	.port_ops		= &icside_v6_no_dma_port_ops,
-	.dma_ops		= &icside_v6_dma_ops,
 	.host_flags		= IDE_HFLAG_SERIALIZE | IDE_HFLAG_MMIO,
 	.mwdma_mask		= ATA_MWDMA2,
 	.swdma_mask		= ATA_SWDMA2,
@@ -518,11 +515,13 @@ icside_register_v6(struct icside_state *state, struct expansion_card *ec)
 
 	ecard_set_drvdata(ec, state);
 
+#ifdef CONFIG_BLK_DEV_IDEDMA_ICS
 	if (ec->dma != NO_DMA && !request_dma(ec->dma, DRV_NAME)) {
 		d.init_dma = icside_dma_init;
 		d.port_ops = &icside_v6_port_ops;
-	} else
-		d.dma_ops = NULL;
+		d.dma_ops  = &icside_v6_dma_ops;
+	}
+#endif
 
 	ret = ide_host_register(host, &d, hws);
 	if (ret)
-- 
1.7.5.4

