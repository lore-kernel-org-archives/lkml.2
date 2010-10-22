Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab0JVX4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:56:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39325 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab0JVXyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:54:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OzLzrE7LYIJ2aL4r4H5BrZEJBiBBXovcwb+szr58DQ5hGmbZBaTYn/G+ziZHYDSEzx
         +KHDejhA3ENlT1LpQPJU/k7/hzdLkdvYJj3jq76tgIT2Cjn3a/2Yu1Z0qfACdHWqUlU2
         qKf7BldSmNiog3MJwBcyEMxvTM9w1qw+faHOU=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 22/29] memstick: jmb38x_ms: rework ISR
Date: Sat, 23 Oct 2010 01:53:50 +0200
Message-Id: <1287791637-10329-23-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
References: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New ISR is simplier.
Also it only services the hardware when we expect to
thus it workarounds the stuck write ready bit hw bug.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/host/jmb38x_ms.c |   90 +++++++++++++++++++++---------------
 1 files changed, 52 insertions(+), 38 deletions(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index d15118a..6b87e23 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -426,60 +426,74 @@ static irqreturn_t j38ms_isr(int irq, void *dev_id)
 {
 	struct memstick_host *msh = dev_id;
 	struct j38ms_host *host = memstick_priv(msh);
-	unsigned int irq_status;
+	u32 irq_status;
 
 	spin_lock(&host->lock);
-	irq_status = readl(host->addr + INT_STATUS);
-	dev_dbg(&host->chip->pdev->dev, "irq_status = %08x\n", irq_status);
+	irq_status = j38ms_read_reg(host, INT_STATUS);
+
 	if (irq_status == 0 || irq_status == (~0)) {
 		spin_unlock(&host->lock);
 		return IRQ_NONE;
 	}
 
-	if (host->req) {
-		if (irq_status & INT_STATUS_ANY_ERR) {
-			if (irq_status & INT_STATUS_CRC_ERR)
-				host->req->error = -EILSEQ;
-			else
-				host->req->error = -ETIME;
-		} else {
-			if (host->cmd_flags & DMA_DATA) {
-				if (irq_status & INT_STATUS_EOTRAN)
-					host->cmd_flags |= FIFO_READY;
-			} else {
-				if (irq_status & (INT_STATUS_FIFO_RRDY
-						  | INT_STATUS_FIFO_WRDY))
-					j38ms_transfer_pio(host);
-
-				if (irq_status & INT_STATUS_EOTRAN) {
-					j38ms_transfer_pio(host);
-					host->cmd_flags |= FIFO_READY;
-				}
-			}
-
-			if (irq_status & INT_STATUS_EOTPC) {
-				host->cmd_flags |= CMD_READY;
-				if (host->cmd_flags & REG_DATA) {
-					if (host->req->data_dir == READ)
-						j38ms_read_tpc_inline(host);
-					host->cmd_flags |= FIFO_READY;
-				}
-			}
+	dbg(host, "IRQ: status: %08x", irq_status);
+
+	if (irq_status & INT_STATUS_ANY_ERR)
+		dbg(host, "IRQ: error");
+
+	if (irq_status & INT_STATUS_FIFO_RRDY)
+		dbg(host, "IRQ: FIFO is now ready for reading");
+
+	if (irq_status & INT_STATUS_FIFO_WRDY)
+		dbg(host, "IRQ: FIFO is now ready for writing");
+
+	if (irq_status & INT_STATUS_EOTRAN)
+		dbg(host, "IRQ: FIFO IO tranfer done");
+
+	if (irq_status & INT_STATUS_EOTPC)
+		dbg(host, "IRQ: TPC complete");
+
+	if (!host->req)
+		goto out;
+
+	/* Errors */
+	if (irq_status & INT_STATUS_ANY_ERR) {
+		host->req->error =
+			(irq_status & INT_STATUS_CRC_ERR) ? -EILSEQ : -EIO;
+		goto out;
+	}
+
+	/* End of TPC interrupt */
+	if (irq_status & INT_STATUS_EOTPC) {
+		host->cmd_flags |= CMD_READY;
+
+		if (host->cmd_flags & REG_DATA) {
+			if (host->req->data_dir == READ)
+				j38ms_read_tpc_inline(host);
+			host->cmd_flags |= FIFO_READY;
 		}
 	}
 
+	/* Fifo handling */
+	if (irq_status & INT_STATUS_EOTRAN)
+		host->cmd_flags |= FIFO_READY;
+	else if (irq_status & (INT_STATUS_FIFO_RRDY | INT_STATUS_FIFO_WRDY))
+		if (host->cmd_flags & PIO_DATA)
+			j38ms_transfer_pio(host);
+
+out:
 	if (irq_status & (INT_STATUS_MEDIA_IN | INT_STATUS_MEDIA_OUT)) {
-		dev_dbg(&host->chip->pdev->dev, "media changed\n");
+		dbg(host, "IRQ: media changed");
 		memstick_detect_change(msh);
 	}
 
-	writel(irq_status, host->addr + INT_STATUS);
+	/* Yes, interrupt status is cleared by setting the bits as usual */
+	j38ms_write_reg(host, INT_STATUS, irq_status);
 
-	if (host->req
-	    && (((host->cmd_flags & CMD_READY)
-		 && (host->cmd_flags & FIFO_READY))
-		|| host->req->error))
+	if (host->req && (((host->cmd_flags & CMD_READY)
+		&& (host->cmd_flags & FIFO_READY)) || host->req->error)) {
 		j38ms_complete_tpc(msh, 0);
+	}
 
 	spin_unlock(&host->lock);
 	return IRQ_HANDLED;
-- 
1.7.1

