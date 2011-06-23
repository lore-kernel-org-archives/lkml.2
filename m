Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567Ab1FWCCC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 22:02:02 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35252 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758877Ab1FWCAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 22:00:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DTpZnCIXNx5SBGdb458MWj1IOQ9lW9ReLAnR6jnx7vzP9srEiVvlur43Gy+3Q6aLrt
         dCO/LNQVEMTI74+v4s8B4ktyisRi7FRd5xTEB7SgtYECPyTn8nrCfv8+TnlEoZDmBBrk
         pihQV5oMkIrkS6EHb9f9WauJBjLm/BNybwLeg=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 08/11] spi-dw: Ensure fifo lenght is set.
Date: Wed, 22 Jun 2011 19:00:10 -0700
Message-Id: <1308794413-11069-9-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>
References: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Bug on fifo_len not being set.  The fifo sizing routine does not work
since the txfltr register can not be written while the controller is
enabled. The max value of txfltr can be larger than the fifo.  The
register allows values upto 0x3f (63) the fifo depth on the Intel
SOC's if 40

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 drivers/spi/spi-dw.c |   18 ++----------------
 1 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
index ad92826..cc38aa0 100644
--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -776,25 +776,11 @@ static int destroy_queue(struct spi_dw *dws)
 /* Restart the controller, disable all interrupts, clean rx fifo */
 static void spi_dw_hw_init(struct spi_dw *dws)
 {
+	BUG_ON(!dws->fifo_len);
+
 	spi_dw_disable(dws);
 	spi_dw_mask_intr(dws, 0xff);
 	spi_dw_enable(dws);
-
-	/*
-	 * Try to detect the FIFO depth if not set by interface driver,
-	 * the depth could be from 2 to 256 from HW spec
-	 */
-	if (!dws->fifo_len) {
-		u32 fifo;
-		for (fifo = 2; fifo <= 257; fifo++) {
-			dw_writew(dws, txfltr, fifo);
-			if (fifo != dw_readw(dws, txfltr))
-				break;
-		}
-
-		dws->fifo_len = (fifo == 257) ? 0 : fifo;
-		dw_writew(dws, txfltr, 0);
-	}
 }
 
 int __devinit spi_dw_add_host(struct spi_dw *dws)
-- 
1.7.3.4

