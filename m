Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab2FFNTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 09:19:04 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45232 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab2FFNS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 09:18:59 -0400
X-AuditID: cbfee61b-b7f8f6d000005ca4-28-4fcf58c238f3
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
Subject: [PATCH 1/2] common: DMA-mapping: add DMA_ATTR_SKIP_CPU_SYNC attribute
Date: Wed, 06 Jun 2012 15:17:36 +0200
Message-id: <1338988657-20770-2-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1338988657-20770-1-git-send-email-m.szyprowski@samsung.com>
References: <1338988657-20770-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJMWRmVeSWpSXmKPExsVy+t9jAd1DEef9DSY80bLo2PWVxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGXcm9PHUnBHtuLjmkNMDYw/JLoYOTkkBEwkHs9azQZh
	i0lcuLceyObiEBJYxCjxs3kGO4TTxSTR+fAmK0gVm4ChRNfbLrAOEYEZjBK7+tJAipgF9rFI
	dG4+wQiSEBbwk1jY9Zyli5GDg0VAVWLafLB6XgEPiQ2z3zJCbJOXeHq/DyzOKeApMeXgfHYQ
	Wwio5taJXqYJjLwLGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgR7/5n0DsZVDRaHGAU4
	GJV4eN+GnfcXYk0sK67MPcQowcGsJMIb5wwU4k1JrKxKLcqPLyrNSS0+xCjNwaIkztt37Jy/
	kEB6YklqdmpqQWoRTJaJg1OqgXHzndZHjbMXbspZ4OApdEFDNs9qs+jRJ5sTd5xJE3D5luxY
	LTpD6+6zCXfc+ntWSSp8WPA8bcZVpe3SNXKzsm8biBYdzeD+975T1cjfr+Fdq8U7UabVB3e2
	38pp7vkzJ+Smmu0u78DDnWLe3zTTLvHEpF3Y421wdV6Is7Pbk7r4/5pN58PMW5RYijMSDbWY
	i4oTAVdlKpn6AQAA
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

