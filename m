Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933293Ab2J2Vzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:55:55 -0400
Received: from mail.kernel.org ([198.145.19.201]:48464 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761404Ab2J2VlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:41:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Yinghai Lu <yinghai@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 09/54] x86, mm: Trim memory in memblock to be page aligned
Date: Mon, 29 Oct 2012 14:40:10 -0700
Message-Id: <20121029213803.790620968@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213802.697479610@linuxfoundation.org>
References: <20121029213802.697479610@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit 6ede1fd3cb404c0016de6ac529df46d561bd558b upstream.

We will not map partial pages, so need to make sure memblock
allocation will not allocate those bytes out.

Also we will use for_each_mem_pfn_range() to loop to map memory
range to keep them consistent.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/CAE9FiQVZirvaBMFYRfXMmWEcHbKSicQEHz4VAwUv0xFCk51ZNw@mail.gmail.com
Acked-by: Jacob Shin <jacob.shin@amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/e820.c   |    3 +++
 include/linux/memblock.h |    1 +
 mm/memblock.c            |   24 ++++++++++++++++++++++++
 3 files changed, 28 insertions(+)

--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1076,6 +1076,9 @@ void __init memblock_x86_fill(void)
 		memblock_add(ei->addr, ei->size);
 	}
 
+	/* throw away partial pages */
+	memblock_trim_memory(PAGE_SIZE);
+
 	memblock_dump_all();
 }
 
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -57,6 +57,7 @@ int memblock_add(phys_addr_t base, phys_
 int memblock_remove(phys_addr_t base, phys_addr_t size);
 int memblock_free(phys_addr_t base, phys_addr_t size);
 int memblock_reserve(phys_addr_t base, phys_addr_t size);
+void memblock_trim_memory(phys_addr_t align);
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -908,6 +908,30 @@ int __init_memblock memblock_is_region_r
 	return memblock_overlaps_region(&memblock.reserved, base, size) >= 0;
 }
 
+void __init_memblock memblock_trim_memory(phys_addr_t align)
+{
+	int i;
+	phys_addr_t start, end, orig_start, orig_end;
+	struct memblock_type *mem = &memblock.memory;
+
+	for (i = 0; i < mem->cnt; i++) {
+		orig_start = mem->regions[i].base;
+		orig_end = mem->regions[i].base + mem->regions[i].size;
+		start = round_up(orig_start, align);
+		end = round_down(orig_end, align);
+
+		if (start == orig_start && end == orig_end)
+			continue;
+
+		if (start < end) {
+			mem->regions[i].base = start;
+			mem->regions[i].size = end - start;
+		} else {
+			memblock_remove_region(mem, i);
+			i--;
+		}
+	}
+}
 
 void __init_memblock memblock_set_current_limit(phys_addr_t limit)
 {


