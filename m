Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741Ab0FJUJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 16:09:47 -0400
Received: from havoc.gtf.org ([69.61.125.42]:54932 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759662Ab0FJUJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 16:09:45 -0400
Date: Thu, 10 Jun 2010 16:09:44 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20100610200944.GA31500@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Two sata_sil24 fixes...

1) Add some memory barriers.  Gets ARM working.

2) Fix a longstanding but ultimately harmless over-memset.


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/sata_sil24.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

Catalin Marinas (1):
      sata_sil24: Use memory barriers before issuing commands

Dan Carpenter (1):
      sata_sil24: memset() overflow

diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 70b58fe..be7726d 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -622,6 +622,11 @@ static int sil24_exec_polled_cmd(struct ata_port *ap, int pmp,
 	irq_enabled = readl(port + PORT_IRQ_ENABLE_SET);
 	writel(PORT_IRQ_COMPLETE | PORT_IRQ_ERROR, port + PORT_IRQ_ENABLE_CLR);
 
+	/*
+	 * The barrier is required to ensure that writes to cmd_block reach
+	 * the memory before the write to PORT_CMD_ACTIVATE.
+	 */
+	wmb();
 	writel((u32)paddr, port + PORT_CMD_ACTIVATE);
 	writel((u64)paddr >> 32, port + PORT_CMD_ACTIVATE + 4);
 
@@ -865,7 +870,7 @@ static void sil24_qc_prep(struct ata_queued_cmd *qc)
 	} else {
 		prb = &cb->atapi.prb;
 		sge = cb->atapi.sge;
-		memset(cb->atapi.cdb, 0, 32);
+		memset(cb->atapi.cdb, 0, sizeof(cb->atapi.cdb));
 		memcpy(cb->atapi.cdb, qc->cdb, qc->dev->cdb_len);
 
 		if (ata_is_data(qc->tf.protocol)) {
@@ -895,6 +900,11 @@ static unsigned int sil24_qc_issue(struct ata_queued_cmd *qc)
 	paddr = pp->cmd_block_dma + tag * sizeof(*pp->cmd_block);
 	activate = port + PORT_CMD_ACTIVATE + tag * 8;
 
+	/*
+	 * The barrier is required to ensure that writes to cmd_block reach
+	 * the memory before the write to PORT_CMD_ACTIVATE.
+	 */
+	wmb();
 	writel((u32)paddr, activate);
 	writel((u64)paddr >> 32, activate + 4);
 
