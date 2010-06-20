Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab0FTV0P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 17:26:15 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:60627 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753762Ab0FTV0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 17:26:11 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Jonas Aaberg <jonas.aberg@stericsson.com>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 11/19] DMAENGINE: ste_dma40: no premature stop
Date: Sun, 20 Jun 2010 23:26:01 +0200
Message-ID: <1277069161-31141-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Correct bug that could cause paused channels to stop.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index aa098a6..8c46bb8 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -508,6 +508,7 @@ static int d40_channel_execute_command(struct d40_chan *d40c,
 	void __iomem *active_reg;
 	int ret = 0;
 	unsigned long flags;
+	u32 wmask;
 
 	spin_lock_irqsave(&d40c->base->execmd_lock, flags);
 
@@ -525,7 +526,9 @@ static int d40_channel_execute_command(struct d40_chan *d40c,
 			goto done;
 	}
 
-	writel(command << D40_CHAN_POS(d40c->phy_chan->num), active_reg);
+	wmask = 0xffffffff & ~(D40_CHAN_POS_MASK(d40c->phy_chan->num));
+	writel(wmask | (command << D40_CHAN_POS(d40c->phy_chan->num)),
+	       active_reg);
 
 	if (command == D40_DMA_SUSPEND_REQ) {
 
-- 
1.6.3.3

