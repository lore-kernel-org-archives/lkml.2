Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab2FMLvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:51:15 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26704 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab2FMLuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:50:54 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-81-4fd87e9dfd60
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
Subject: [PATCHv2 1/6] common: DMA-mapping: add DMA_ATTR_NO_KERNEL_MAPPING
 attribute
Date: Wed, 13 Jun 2012 13:50:13 +0200
Message-id: <1339588218-24398-2-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1339588218-24398-1-git-send-email-m.szyprowski@samsung.com>
References: <1339588218-24398-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t9jAd25dTf8DWZdU7To2PWVxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGUse3aLqWC6cMWSxRoNjDMEuhg5OSQETCRalz1mg7DF
	JC7cWw9kc3EICSxilJh4exs7SEJIoItJ4tKyGBCbTcBQouttF1iDiMAMRoldfWkgDcwC+1gk
	OjefYARJCAuESfzv6gBrZhFQlfgz+wgriM0r4CHxY/t9Joht8hJP7/eBDeIU8JT4/WwfE8Qy
	D4nf0w4zT2DkXcDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMj2PfPpHYwrmywOMQowMGo
	xMO7oeiGvxBrYllxZe4hRgkOZiUR3mfZQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8TdYX/IUE
	0hNLUrNTUwtSi2CyTBycUg2Mc7V+FDmqP1+S0eX35vrRGXFXVdTT8zt/7ps4R/6N++d1ptP1
	xPwW6bFdXNpz3il5hfGuLewpYeerCj/ETj0ztfVW2WS3FboJbdzVDJd8fzJ8V1U93+7w7X6S
	QXj4JjORuVtyitjnlWV9tbmwT/GeaLmxh9aKR0Endy0y3v6oVpX/vYfx7alflFiKMxINtZiL
	ihMBj4YenfkBAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DMA_ATTR_NO_KERNEL_MAPPING attribute which lets the
platform to avoid creating a kernel virtual mapping for the allocated
buffer. On some architectures creating such mapping is non-trivial task
and consumes very limited resources (like kernel virtual address space
or dma consistent address space). Buffers allocated with this attribute
can be only passed to user space by calling dma_mmap_attrs().

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DMA-attributes.txt |   18 ++++++++++++++++++
 include/linux/dma-attrs.h        |    1 +
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/Documentation/DMA-attributes.txt b/Documentation/DMA-attributes.txt
index 5c72eed..725580d 100644
--- a/Documentation/DMA-attributes.txt
+++ b/Documentation/DMA-attributes.txt
@@ -49,3 +49,21 @@ DMA_ATTR_NON_CONSISTENT lets the platform to choose to return either
 consistent or non-consistent memory as it sees fit.  By using this API,
 you are guaranteeing to the platform that you have all the correct and
 necessary sync points for this memory in the driver.
+
+DMA_ATTR_NO_KERNEL_MAPPING
+--------------------------
+
+DMA_ATTR_NO_KERNEL_MAPPING lets the platform to avoid creating a kernel
+virtual mapping for the allocated buffer. On some architectures creating
+such mapping is non-trivial task and consumes very limited resources
+(like kernel virtual address space or dma consistent address space).
+Buffers allocated with this attribute can be only passed to user space
+by calling dma_mmap_attrs(). By using this API, you are guaranteeing
+that you won't dereference the pointer returned by dma_alloc_attr(). You
+can threat it as a cookie that must be passed to dma_mmap_attrs() and
+dma_free_attrs(). Make sure that both of these also get this attribute
+set on each call.
+
+Since it is optional for platforms to implement
+DMA_ATTR_NO_KERNEL_MAPPING, those that do not will simply ignore the
+attribute and exhibit default behavior.
diff --git a/include/linux/dma-attrs.h b/include/linux/dma-attrs.h
index 547ab56..a37c10c 100644
--- a/include/linux/dma-attrs.h
+++ b/include/linux/dma-attrs.h
@@ -15,6 +15,7 @@ enum dma_attr {
 	DMA_ATTR_WEAK_ORDERING,
 	DMA_ATTR_WRITE_COMBINE,
 	DMA_ATTR_NON_CONSISTENT,
+	DMA_ATTR_NO_KERNEL_MAPPING,
 	DMA_ATTR_MAX,
 };
 
-- 
1.7.1.569.g6f426

