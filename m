Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab0HIMIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 08:08:54 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:36865 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756498Ab0HIMIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 08:08:52 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Jonas Aaberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 09/14] DMAENGINE: ste_dma40: corrected is_paused behavior
Date: Mon, 9 Aug 2010 14:08:41 +0200
Message-ID: <1281355721-13412-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

The handling of pause detection was slightly incorrect.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 7a4919b..2b209fa 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1521,16 +1521,22 @@ static bool d40_is_paused(struct d40_chan *d40c)
 	}
 
 	if (d40c->dma_cfg.dir == STEDMA40_MEM_TO_PERIPH ||
-	    d40c->dma_cfg.dir == STEDMA40_MEM_TO_MEM)
+	    d40c->dma_cfg.dir == STEDMA40_MEM_TO_MEM) {
 		event = D40_TYPE_TO_EVENT(d40c->dma_cfg.dst_dev_type);
-	else if (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM)
+		status = readl(d40c->base->virtbase + D40_DREG_PCBASE +
+			       d40c->phy_chan->num * D40_DREG_PCDELTA +
+			       D40_CHAN_REG_SDLNK);
+	} else if (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM) {
 		event = D40_TYPE_TO_EVENT(d40c->dma_cfg.src_dev_type);
-	else {
+		status = readl(d40c->base->virtbase + D40_DREG_PCBASE +
+			       d40c->phy_chan->num * D40_DREG_PCDELTA +
+			       D40_CHAN_REG_SSLNK);
+	} else {
 		dev_err(&d40c->chan.dev->device,
 			"[%s] Unknown direction\n", __func__);
 		goto _exit;
 	}
-	status = d40_chan_has_events(d40c);
+
 	status = (status & D40_EVENTLINE_MASK(event)) >>
 		D40_EVENTLINE_POS(event);
 
-- 
1.6.3.3

