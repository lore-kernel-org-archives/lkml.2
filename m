Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab2FMLvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:51:24 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26853 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952Ab2FMLvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:51:21 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-e0-4fd87eb8268d
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
Subject: [PATCHv2 5/6] common: DMA-mapping: add DMA_ATTR_SKIP_CPU_SYNC attribute
Date: Wed, 13 Jun 2012 13:50:17 +0200
Message-id: <1339588218-24398-6-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1339588218-24398-1-git-send-email-m.szyprowski@samsung.com>
References: <1339588218-24398-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJMWRmVeSWpSXmKPExsVy+t9jAd0ddTf8DeZs0LPo2PWVxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGXMn85eMEWu4vOrLrYGxtWSXYycHBICJhJtH6cwQdhi
	EhfurWfrYuTiEBJYxCgx+3UfK4TTxSSxc+d9dpAqNgFDia63XWwgtojADEaJXX1pIEXMAvtY
	JDo3n2AESQgLBEhcutUCVsQioCpx6OlWsDivgIfE5WkbWCHWyUs8vd8HVsMp4Cnx+9k+sDOE
	gGp+TzvMPIGRdwEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2MYO8/k9rBuLLB4hCjAAej
	Eg/vhqIb/kKsiWXFlbmHGCU4mJVEeJ9lA4V4UxIrq1KL8uOLSnNSiw8xSnOwKInzNllf8BcS
	SE8sSc1OTS1ILYLJMnFwSjUwXuLPtl4Re5iL/zBjU9wdHYXunuWpSo/Ut01hOKedbDjPVJX9
	nvnq/WVrp+/l3nbtwTwGvkUvV89XmS+3OiDVKfjJyYYlbx5lrj6WtFX5u/lHj9Yf+rvkxd/3
	99+dO0fS5e2/5nBLYUOX+vjHxyTvXv+fJKY+S2Or4cTWtqPxxS6nVxju/35ioRJLcUaioRZz
	UXEiAKK+fVv6AQAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DMA_ATTR_SKIP_CPU_SYNC attribute to the DMA-mapping
subsystem.

By default dma_map_{single,page,sg} functions family transfer a given
buffer from CPU domain to device domain. Some advanced use cases might
require sharing a buffer between more than one device. This requires
having a mapping created separately for each device and is usually
performed by calling dma_map_{single,page,sg} function more than once
for the given buffer with device pointer to each device taking part in
the buffer sharing. The first call transfers a buffer from 'CPU' domain
to 'device' domain, what synchronizes CPU caches for the given region
(usually it means that the cache has been flushed or invalidated
depending on the dma direction). However, next calls to
dma_map_{single,page,sg}() for other devices will perform exactly the
same sychronization operation on the CPU cache. CPU cache sychronization
might be a time consuming operation, especially if the buffers are
large, so it is highly recommended to avoid it if possible.
DMA_ATTR_SKIP_CPU_SYNC allows platform code to skip synchronization of
the CPU cache for the given buffer assuming that it has been already
transferred to 'device' domain. This attribute can be also used for
dma_unmap_{single,page,sg} functions family to force buffer to stay in
device domain after releasing a mapping for it. Use this attribute with
care!

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DMA-attributes.txt |   24 ++++++++++++++++++++++++
 include/linux/dma-attrs.h        |    1 +
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/Documentation/DMA-attributes.txt b/Documentation/DMA-attributes.txt
index 725580d..f503090 100644
--- a/Documentation/DMA-attributes.txt
+++ b/Documentation/DMA-attributes.txt
@@ -67,3 +67,27 @@ set on each call.
 Since it is optional for platforms to implement
 DMA_ATTR_NO_KERNEL_MAPPING, those that do not will simply ignore the
 attribute and exhibit default behavior.
+
+DMA_ATTR_SKIP_CPU_SYNC
+----------------------
+
+By default dma_map_{single,page,sg} functions family transfer a given
+buffer from CPU domain to device domain. Some advanced use cases might
+require sharing a buffer between more than one device. This requires
+having a mapping created separately for each device and is usually
+performed by calling dma_map_{single,page,sg} function more than once
+for the given buffer with device pointer to each device taking part in
+the buffer sharing. The first call transfers a buffer from 'CPU' domain
+to 'device' domain, what synchronizes CPU caches for the given region
+(usually it means that the cache has been flushed or invalidated
+depending on the dma direction). However, next calls to
+dma_map_{single,page,sg}() for other devices will perform exactly the
+same sychronization operation on the CPU cache. CPU cache sychronization
+might be a time consuming operation, especially if the buffers are
+large, so it is highly recommended to avoid it if possible.
+DMA_ATTR_SKIP_CPU_SYNC allows platform code to skip synchronization of
+the CPU cache for the given buffer assuming that it has been already
+transferred to 'device' domain. This attribute can be also used for
+dma_unmap_{single,page,sg} functions family to force buffer to stay in
+device domain after releasing a mapping for it. Use this attribute with
+care!
diff --git a/include/linux/dma-attrs.h b/include/linux/dma-attrs.h
index a37c10c..f83f793 100644
--- a/include/linux/dma-attrs.h
+++ b/include/linux/dma-attrs.h
@@ -16,6 +16,7 @@ enum dma_attr {
 	DMA_ATTR_WRITE_COMBINE,
 	DMA_ATTR_NON_CONSISTENT,
 	DMA_ATTR_NO_KERNEL_MAPPING,
+	DMA_ATTR_SKIP_CPU_SYNC,
 	DMA_ATTR_MAX,
 };
 
-- 
1.7.1.569.g6f426

