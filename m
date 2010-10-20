Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220Ab0JTGhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:37:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46270 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787Ab0JTGhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 02:37:23 -0400
Date: Wed, 20 Oct 2010 08:37:19 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vasiliy Kulikov <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: imx-dma: fix signedness bug
Message-ID: <20101020063719.GE28242@pengutronix.de>
References: <1287327110-9158-1-git-send-email-segooon@gmail.com> <AANLkTik15Z2_wyDRDOHOnpKKPgb+PHWs477esndgWmex@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik15Z2_wyDRDOHOnpKKPgb+PHWs477esndgWmex@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:35:45 up 108 days, 21:46, 21 users,  load average: 0.75, 0.89,
	0.85
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mxdmac->channel was unsigned, so check (imxdmac->channel < 0) for
failed imx_dma_request_by_prio() made no sence.  Explicitly check
signed values.
Also, fix uninitialzed use of ret.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---

Here's an updated patch fixing both issues.

 drivers/dma/imx-dma.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 346be62..f629e49 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -335,8 +335,10 @@ static int __init imxdma_probe(struct platform_device *pdev)
 
 		imxdmac->imxdma_channel = imx_dma_request_by_prio("dmaengine",
 				DMA_PRIO_MEDIUM);
-		if (imxdmac->channel < 0)
+		if ((int)imxdmac->channel < 0) {
+			ret = -ENODEV;
 			goto err_init;
+		}
 
 		imx_dma_setup_handlers(imxdmac->imxdma_channel,
 		       imxdma_irq_handler, imxdma_err_handler, imxdmac);
-- 
1.7.2.3

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
