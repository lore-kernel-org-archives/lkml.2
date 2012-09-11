Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658Ab2IKPWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 11:22:21 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:49886 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384Ab2IKPWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 11:22:20 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <vinod.koul@linux.intel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>, <ludovic.desroches@atmel.com>,
        <nicolas.ferre@atmel.com>
Subject: [PATCH 2/2] dmaengine: at_hdmac: check that each sg data length is non-null
Date: Tue, 11 Sep 2012 17:21:45 +0200
Message-ID: <4dd23d54172aedff69d4bb9be950cea18be9b848.1347375975.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <77b1e7252fbc9a31e1ed8806e017f8bd8a4605e0.1347375975.git.nicolas.ferre@atmel.com>
References: <77b1e7252fbc9a31e1ed8806e017f8bd8a4605e0.1347375975.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid the construction of a malformed DMA request sent to
the DMA controller.
Log message is for debug only because this condition is unlikely to
append and may only trigger at driver development time.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Stable <stable@vger.kernel.org> [2.6.31+]
---
 drivers/dma/at_hdmac.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 6c09e18..7ab6e26 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -689,6 +689,11 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 
 			mem = sg_dma_address(sg);
 			len = sg_dma_len(sg);
+			if (unlikely(!len)) {
+				dev_dbg(chan2dev(chan),
+					"prep_slave_sg: sg(%d) data length is zero\n", i);
+				goto err;
+			}
 			mem_width = 2;
 			if (unlikely(mem & 3 || len & 3))
 				mem_width = 0;
@@ -724,6 +729,11 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 
 			mem = sg_dma_address(sg);
 			len = sg_dma_len(sg);
+			if (unlikely(!len)) {
+				dev_dbg(chan2dev(chan),
+					"prep_slave_sg: sg(%d) data length is zero\n", i);
+				goto err;
+			}
 			mem_width = 2;
 			if (unlikely(mem & 3 || len & 3))
 				mem_width = 0;
@@ -757,6 +767,7 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 
 err_desc_get:
 	dev_err(chan2dev(chan), "not enough descriptors available\n");
+err:
 	atc_desc_put(atchan, first);
 	return NULL;
 }
-- 
1.7.10

