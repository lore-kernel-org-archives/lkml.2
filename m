Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab3AAVLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 16:11:24 -0500
Received: from mail.ispras.ru ([83.149.199.43]:56524 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab3AAVLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 16:11:22 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] p54pci: don't return zero on failure path in p54p_probe()
Date: Wed,  2 Jan 2013 01:11:01 +0400
Message-Id: <1357074661-15784-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If pci_set_dma_mask() or pci_set_consistent_dma_mask() fails in p54p_probe(),
it breaks off initialization, deallocates all resources, but returns zero.

The patch implements proper error code propagation.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/net/wireless/p54/p54pci.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
index 933e5d9..fef69ea 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -568,8 +568,10 @@ static int p54p_probe(struct pci_dev *pdev,
 		goto err_disable_dev;
 	}
 
-	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) ||
-	    pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	if (!err)
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+	if (err) {
 		dev_err(&pdev->dev, "No suitable DMA available\n");
 		goto err_free_reg;
 	}
-- 
1.7.9.5

