Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958Ab0HJUg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 16:36:27 -0400
Received: from khc.piap.pl ([195.187.100.11]:52393 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757843Ab0HJUgY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 16:36:24 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-arm-kernel@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>
Subject: ARM: 2.6.3[45] PCI regression (IXP4xx and PXA?)
Date: Tue, 10 Aug 2010 22:36:21 +0200
Message-ID: <m3sk2m433u.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Noticed this problem a bit late :-(

6fee48cd330c68332f9712bc968d934a1a84a32a broke
pci_set_consistent_dma_mask() on IXP4xx and most probably PXA. Affected
devices are e.g. IDE controller (CS5536-based: disk inaccessible) and
e1000 ethernet ("Detected Tx Unit Hang").

The attached patch makes it work again, though I'm not sure it's the
best solution.

Ideas?

Signed-off-by: Krzysztof Hałasa <khc@pm.waw.pl>

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index ca32ed7..bd2a7d3 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -129,6 +129,14 @@ static inline u64 dma_get_mask(struct device *dev)
 
 static inline int dma_set_coherent_mask(struct device *dev, u64 mask)
 {
+#ifdef CONFIG_DMABOUNCE
+	if (dev->archdata.dmabounce) {
+		if (mask >= ISA_DMA_THRESHOLD)
+			return 0;
+		else
+			return -EIO;
+	}
+#endif
 	if (!dma_supported(dev, mask))
 		return -EIO;
 	dev->coherent_dma_mask = mask;
