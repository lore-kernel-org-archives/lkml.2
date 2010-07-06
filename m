Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab0GFWqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 18:46:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32508 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370Ab0GFWo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 18:44:29 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 33/49] memblock: Add memblock_find_in_range()
Date: Tue,  6 Jul 2010 15:39:26 -0700
Message-Id: <1278455982-24621-34-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1278455982-24621-1-git-send-email-yinghai@kernel.org>
References: <1278455982-24621-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C33B1A9.008C,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it is a wrapper for memblock_find_base

make it more easy for x86 to use memblock. ( rebase )
x86 early_res is using find/reserve pattern instead of alloc.

keep it in weak version, so later We can use x86 own version if needed.
also We need it in mm/memblock.c, so one caller mm/page_alloc.c could get compiled

-v2: Change name to memblock_find_in_range() according to Michael Ellerman
-v3: Add generic weak version __memblock_find_in_range()
     so keep the path for fallback to x86 version that handle from low
-v4: use 0 for failing path
-v5: use MEMBLOCK_ERROR again
-v6: remove __memblock_find_in_range()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/memblock.h |    2 ++
 mm/memblock.c            |    8 ++++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 9f544cd..7162b2f 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -48,6 +48,8 @@ extern struct memblock_region memblock_reserved_init_regions[];
 #define memblock_dbg(fmt, ...) \
 	if (memblock_debug) printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 
+u64 memblock_find_in_range(u64 start, u64 end, u64 size, u64 align);
+
 extern void __init memblock_init(void);
 extern void __init memblock_analyze(void);
 extern long memblock_add(phys_addr_t base, phys_addr_t size);
diff --git a/mm/memblock.c b/mm/memblock.c
index 81eaf90..58b646f 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -156,6 +156,14 @@ static phys_addr_t __init memblock_find_base(phys_addr_t size, phys_addr_t align
 	return MEMBLOCK_ERROR;
 }
 
+/*
+ * Find a free area with specified alignment in a specific range.
+ */
+u64 __init __weak memblock_find_in_range(u64 start, u64 end, u64 size, u64 align)
+{
+	return memblock_find_base(size, align, start, end);
+}
+
 static void __init_memblock memblock_remove_region(struct memblock_type *type, unsigned long r)
 {
 	unsigned long i;
-- 
1.6.4.2

