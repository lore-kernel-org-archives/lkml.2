Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161116Ab2JXTBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:01:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60476 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934308Ab2JXTBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:01:46 -0400
Date: Wed, 24 Oct 2012 12:01:28 -0700
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-6ede1fd3cb404c0016de6ac529df46d561bd558b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, stable@vger.kernel.org, jacob.shin@amd.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, jacob.shin@amd.com, tglx@linutronix.de,
        stable@vger.kernel.org, hpa@linux.intel.com
In-Reply-To: <CAE9FiQVZirvaBMFYRfXMmWEcHbKSicQEHz4VAwUv0xFCk51ZNw@mail.gmail.com>
References: <CAE9FiQVZirvaBMFYRfXMmWEcHbKSicQEHz4VAwUv0xFCk51ZNw@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mm:
  Trim memory in memblock to be page aligned
Git-Commit-ID: 6ede1fd3cb404c0016de6ac529df46d561bd558b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 12:01:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6ede1fd3cb404c0016de6ac529df46d561bd558b
Gitweb:     http://git.kernel.org/tip/6ede1fd3cb404c0016de6ac529df46d561bd558b
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 22 Oct 2012 16:35:18 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 24 Oct 2012 11:52:21 -0700

x86, mm: Trim memory in memblock to be page aligned

We will not map partial pages, so need to make sure memblock
allocation will not allocate those bytes out.

Also we will use for_each_mem_pfn_range() to loop to map memory
range to keep them consistent.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/CAE9FiQVZirvaBMFYRfXMmWEcHbKSicQEHz4VAwUv0xFCk51ZNw@mail.gmail.com
Acked-by: Jacob Shin <jacob.shin@amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: <stable@vger.kernel.org>
---
 arch/x86/kernel/e820.c   |    3 +++
 include/linux/memblock.h |    1 +
 mm/memblock.c            |   24 ++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index ed858e9..df06ade 100644
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
index 569d67d..d452ee1 100644
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
index 931eef1..6259055 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -930,6 +930,30 @@ int __init_memblock memblock_is_region_reserved(phys_addr_t base, phys_addr_t si
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
