Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab2IQIOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:14:18 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38060 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab2IQION (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:14:13 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: mporter@kernel.crashing.org
Cc: alexandre.bounine@idt.com, akpm@linux-foundation.org, chul.kim@idt.com,
        jiang.liu@huawei.com, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH] drivers/rapidio/devices/tsi721.c: fix error return code
Date: Mon, 17 Sep 2012 10:14:04 +0200
Message-Id: <1347869644-2569-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

Convert a nonnegative error return code to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/rapidio/devices/tsi721.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/rapidio/devices/tsi721.c b/drivers/rapidio/devices/tsi721.c
index 1974359..78dff6f 100644
--- a/drivers/rapidio/devices/tsi721.c
+++ b/drivers/rapidio/devices/tsi721.c
@@ -2316,7 +2316,8 @@ static int __devinit tsi721_probe(struct pci_dev *pdev,
 
 	/* Configure DMA attributes. */
 	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
-		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
+		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		if (err) {
 			dev_info(&pdev->dev, "Unable to set DMA mask\n");
 			goto err_unmap_bars;
 		}
-- 
1.7.11.4

