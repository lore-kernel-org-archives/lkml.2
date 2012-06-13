Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab2FMLws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:52:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26821 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab2FMLvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:51:16 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-11-4fd87eab7d48
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Subash Patel <subash.ramaswamy@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Abhinav Kochhar <abhinav.k@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv2 3/6] common: dma-mapping: introduce dma_get_sgtable() function
Date: Wed, 13 Jun 2012 13:50:15 +0200
Message-id: <1339588218-24398-4-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1339588218-24398-1-git-send-email-m.szyprowski@samsung.com>
References: <1339588218-24398-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJMWRmVeSWpSXmKPExsVy+t9jAd3VdTf8DV7d57To2PWVxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGW0rn7JVnBMrmLXkzWsDYzLJbsYOTkkBEwkzvVPY4Kw
	xSQu3FvP1sXIxSEksIhRYtGyPhYIp4tJ4tv+J2wgVWwChhJdb7vAbBGBGYwSu/rSQIqYBfax
	SHRuPsHYxcjBISwQINF0jhWkhkVAVWL1j99g9bwCHhLLP+1mh9gmL/H0fh9YnFPAU+L3s31g
	VwgB1fyedph5AiPvAkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjB3n8mvYNxVYPFIUYB
	DkYlHt4MYFAIsSaWFVfmHmKU4GBWEuF9lg0U4k1JrKxKLcqPLyrNSS0+xCjNwaIkzttkfcFf
	SCA9sSQ1OzW1ILUIJsvEwSnVwLhaXk+xsdxpS2XDrTDt5TO4TBunPm/s2XRY7078n7L83GXL
	jtrlWds9mthR8DxnYfv3C0knnh9Z/u+uiFRqlUFOnbuyc6X9kce7IpPWeV2uKFb7dNeEVfpo
	fHXdmbe/ZYqTVrxSnV5arRSzUmemyeLPUi2zdCuP3rIMbynNKNF/Lu8/uVRHWYmlOCPRUIu5
	qDgRAK4V3U76AQAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds dma_get_sgtable() function which is required to let
drivers to share the buffers allocated by DMA-mapping subsystem. Right
now the driver gets a dma address of the allocated buffer and the kernel
virtual mapping for it. If it wants to share it with other device (= map
into its dma address space) it usually hacks around kernel virtual
addresses to get pointers to pages or assumes that both devices share
the DMA address space. Both solutions are just hacks for the special
cases, which should be avoided in the final version of buffer sharing.

To solve this issue in a generic way, a new call to DMA mapping has been
introduced - dma_get_sgtable(). It allocates a scatter-list which
describes the allocated buffer and lets the driver(s) to use it with
other device(s) by calling dma_map_sg() on it.

This patch provides a generic implementation based on virt_to_page()
call. Architectures which require more sophisticated translation might
provide their own get_sgtable() methods.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/base/dma-mapping.c               |   18 ++++++++++++++++++
 include/asm-generic/dma-mapping-common.h |   18 ++++++++++++++++++
 include/linux/dma-mapping.h              |    3 +++
 3 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/drivers/base/dma-mapping.c b/drivers/base/dma-mapping.c
index 6f3676f..49785c1 100644
--- a/drivers/base/dma-mapping.c
+++ b/drivers/base/dma-mapping.c
@@ -217,4 +217,22 @@ void dmam_release_declared_memory(struct device *dev)
 }
 EXPORT_SYMBOL(dmam_release_declared_memory);
 
+/*
+ * Create scatter-list for the already allocated DMA buffer.
+ */
+int dma_common_get_sgtable(struct device *dev, struct sg_table *sgt,
+		 void *cpu_addr, dma_addr_t handle, size_t size)
+{
+	struct page *page = virt_to_page(cpu_addr);
+	int ret;
+
+	ret = sg_alloc_table(sgt, 1, GFP_KERNEL);
+	if (unlikely(ret))
+		return ret;
+
+	sg_set_page(sgt->sgl, page, PAGE_ALIGN(size), 0);
+	return 0;
+}
+EXPORT_SYMBOL(dma_common_get_sgtable);
+
 #endif
diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-generic/dma-mapping-common.h
index 2e248d8..34841c6 100644
--- a/include/asm-generic/dma-mapping-common.h
+++ b/include/asm-generic/dma-mapping-common.h
@@ -176,4 +176,22 @@ dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 #define dma_map_sg(d, s, n, r) dma_map_sg_attrs(d, s, n, r, NULL)
 #define dma_unmap_sg(d, s, n, r) dma_unmap_sg_attrs(d, s, n, r, NULL)
 
+int
+dma_common_get_sgtable(struct device *dev, struct sg_table *sgt,
+		       void *cpu_addr, dma_addr_t dma_addr, size_t size);
+
+static inline int
+dma_get_sgtable_attrs(struct device *dev, struct sg_table *sgt, void *cpu_addr,
+		      dma_addr_t dma_addr, size_t size, struct dma_attrs *attrs)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+	BUG_ON(!ops);
+	if (ops->get_sgtable)
+		return ops->get_sgtable(dev, sgt, cpu_addr, dma_addr, size,
+					attrs);
+	return dma_common_get_sgtable(dev, sgt, cpu_addr, dma_addr, size);
+}
+
+#define dma_get_sgtable(d, t, v, h, s) dma_get_sgtable_attrs(d, t, v, h, s, NULL)
+
 #endif
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index dfc099e..94af418 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -18,6 +18,9 @@ struct dma_map_ops {
 	int (*mmap)(struct device *, struct vm_area_struct *,
 			  void *, dma_addr_t, size_t, struct dma_attrs *attrs);
 
+	int (*get_sgtable)(struct device *dev, struct sg_table *sgt, void *,
+			   dma_addr_t, size_t, struct dma_attrs *attrs);
+
 	dma_addr_t (*map_page)(struct device *dev, struct page *page,
 			       unsigned long offset, size_t size,
 			       enum dma_data_direction dir,
-- 
1.7.1.569.g6f426

