Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964787Ab2EOBLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 21:11:22 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18274 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab2EOBLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 21:11:20 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6711"; a="190923263"
X-IronPort-AV: E=Sophos;i="4.75,589,1330934400"; 
   d="scan'208";a="120902461"
Message-ID: <4FB1AD38.7000503@quicinc.com>
Date: Mon, 14 May 2012 18:11:20 -0700
From: Stephen Boyd <sboyd@quicinc.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: memblock_is_region_memory() vs. memblock_is_region_reserved()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was looking at memblock and noticed that memblock_is_region_memory()
is implemented differently than memblock_is_region_reserved().

memblock_is_region_memory() returns true only if the region you are
testing is fully contained within the bounds of a memory block. If the
region is half in and half out of a memory region (i.e. overlaps memory
and a hole) it is not memory and returns false.

memblock_is_region_reserved() is the opposite. If the region are you are
testing is half in and half out of a reserved region (i.e. overlaps
reserved memory) it returns true, otherwise it returns false.

These functions sound like they do the same thing by testing to see if
what you specify is either memory or reserved memory, but the semantics
are a bit different in that the former doesn't allow overlap, and the
latter accepts overlap. Should we rename memblock_is_region_reserved()
to memblock_overlaps_reserved() to make it clearer what the intention
is? Or perhaps rename memblock_is_region_memory() to
memblock_is_region_within_memory()?

If anything, perhaps this patch will help clarify things?

diff --git a/mm/memblock.c b/mm/memblock.c
index a44eab3..f097e79 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -855,6 +855,16 @@ int __init_memblock memblock_is_memory(phys_addr_t addr)
 	return memblock_search(&memblock.memory, addr) != -1;
 }
 
+/**
+ * memblock_is_region_memory - check if a region is a subset of memory
+ * @base: base of region to check
+ * @size: size of region to check
+ *
+ * Check if the region [@base, @base+@size) is a subset of a memory block.
+ *
+ * RETURNS:
+ * 0 if false, non-zero if true
+ */
 int __init_memblock memblock_is_region_memory(phys_addr_t base, phys_addr_t size)
 {
 	int idx = memblock_search(&memblock.memory, base);
@@ -867,6 +877,16 @@ int __init_memblock memblock_is_region_memory(phys_addr_t base, phys_addr_t size
 		 memblock.memory.regions[idx].size) >= end;
 }
 
+/**
+ * memblock_is_region_reserved - check if a region intersects reserved memory
+ * @base: base of region to check
+ * @size: size of region to check
+ *
+ * Check if the region [@base, @base+@size) intersects a reserved memory block.
+ *
+ * RETURNS:
+ * 0 if false, non-zero if true
+ */
 int __init_memblock memblock_is_region_reserved(phys_addr_t base, phys_addr_t size)
 {
 	memblock_cap_size(base, &size);

