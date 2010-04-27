Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab0D0M0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:26:19 -0400
Received: from sh.osrg.net ([192.16.179.4]:37052 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab0D0M0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:26:13 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 6/6] dma-mapping: remove unnecessary sync_single_range_* in dma_map_ops
Date: Tue, 27 Apr 2010 21:25:40 +0900
Message-Id: <1272371140-6085-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1272371140-6085-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1272371140-6085-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 27 Apr 2010 21:26:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sync_single_range_for_cpu and sync_single_range_for_device hooks are
unnecessary because sync_single_for_cpu and sync_single_for_device can
be used instead.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/asm-generic/dma-mapping-common.h |   20 ++------------------
 include/linux/dma-mapping.h              |   10 ----------
 2 files changed, 2 insertions(+), 28 deletions(-)

diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-generic/dma-mapping-common.h
index 6920695..0c80bb3 100644
--- a/include/asm-generic/dma-mapping-common.h
+++ b/include/asm-generic/dma-mapping-common.h
@@ -123,15 +123,7 @@ static inline void dma_sync_single_range_for_cpu(struct device *dev,
 						 size_t size,
 						 enum dma_data_direction dir)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
-
-	BUG_ON(!valid_dma_direction(dir));
-	if (ops->sync_single_range_for_cpu) {
-		ops->sync_single_range_for_cpu(dev, addr, offset, size, dir);
-		debug_dma_sync_single_range_for_cpu(dev, addr, offset, size, dir);
-
-	} else
-		dma_sync_single_for_cpu(dev, addr + offset, size, dir);
+	dma_sync_single_for_cpu(dev, addr + offset, size, dir);
 }
 
 static inline void dma_sync_single_range_for_device(struct device *dev,
@@ -140,15 +132,7 @@ static inline void dma_sync_single_range_for_device(struct device *dev,
 						    size_t size,
 						    enum dma_data_direction dir)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
-
-	BUG_ON(!valid_dma_direction(dir));
-	if (ops->sync_single_range_for_device) {
-		ops->sync_single_range_for_device(dev, addr, offset, size, dir);
-		debug_dma_sync_single_range_for_device(dev, addr, offset, size, dir);
-
-	} else
-		dma_sync_single_for_device(dev, addr + offset, size, dir);
+	dma_sync_single_for_device(dev, addr + offset, size, dir);
 }
 
 static inline void
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index ca32ed7..2ea1494 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -40,16 +40,6 @@ struct dma_map_ops {
 	void (*sync_single_for_device)(struct device *dev,
 				       dma_addr_t dma_handle, size_t size,
 				       enum dma_data_direction dir);
-	void (*sync_single_range_for_cpu)(struct device *dev,
-					  dma_addr_t dma_handle,
-					  unsigned long offset,
-					  size_t size,
-					  enum dma_data_direction dir);
-	void (*sync_single_range_for_device)(struct device *dev,
-					     dma_addr_t dma_handle,
-					     unsigned long offset,
-					     size_t size,
-					     enum dma_data_direction dir);
 	void (*sync_sg_for_cpu)(struct device *dev,
 				struct scatterlist *sg, int nents,
 				enum dma_data_direction dir);
-- 
1.6.5

