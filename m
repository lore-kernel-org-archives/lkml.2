Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934059Ab2KZR0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:26:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48145 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933876Ab2KZRO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:14:27 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 233/270] x86, mm: Trim memory in memblock to be page aligned
Date: Mon, 26 Nov 2012 14:58:43 -0200
Message-Id: <1353949160-26803-234-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/x86/kernel/e820.c   |    3 +++
 include/linux/memblock.h |    1 +
 mm/memblock.c            |   24 ++++++++++++++++++++++++
 3 files changed, 28 insertions(+)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 4185797..a42889d 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1077,6 +1077,9 @@ void __init memblock_x86_fill(void)
 		memblock_add(ei->addr, ei->size);
 	}
 
+	/* throw away partial pages */
+	memblock_trim_memory(PAGE_SIZE);
+
 	memblock_dump_all();
 }
 
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 19dc455..c948c44 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -57,6 +57,7 @@ int memblock_add(phys_addr_t base, phys_addr_t size);
 int memblock_remove(phys_addr_t base, phys_addr_t size);
 int memblock_free(phys_addr_t base, phys_addr_t size);
 int memblock_reserve(phys_addr_t base, phys_addr_t size);
+void memblock_trim_memory(phys_addr_t align);
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
diff --git a/mm/memblock.c b/mm/memblock.c
index 5cc6731..900a97d 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -928,6 +928,30 @@ int __init_memblock memblock_is_region_reserved(phys_addr_t base, phys_addr_t si
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
-- 
1.7.9.5

