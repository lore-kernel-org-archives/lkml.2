Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab1GNVfD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:35:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:34093 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232Ab1GNVfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:35:00 -0400
Date: Thu, 14 Jul 2011 21:34:44 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-8d89ac808417e92a33fb5fa3c86352016643775a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        benh@kernel.crashing.org, yinghai@kernel.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, benh@kernel.crashing.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1310462166-31469-8-git-send-email-tj@kernel.org>
References: <1310462166-31469-8-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/memblock] x86: Replace memblock_x86_find_in_range_size() with for_each_free_mem_range()
Git-Commit-ID: 8d89ac808417e92a33fb5fa3c86352016643775a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Jul 2011 21:34:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d89ac808417e92a33fb5fa3c86352016643775a
Gitweb:     http://git.kernel.org/tip/8d89ac808417e92a33fb5fa3c86352016643775a
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 12 Jul 2011 11:16:00 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 14 Jul 2011 11:47:48 -0700

x86: Replace memblock_x86_find_in_range_size() with for_each_free_mem_range()

setup_bios_corruption_check() and memtest do_one_pass() open code
memblock free area iteration using memblock_x86_find_in_range_size().
Convert them to use for_each_free_mem_range() instead.

This leaves memblock_x86_find_in_range_size() and
memblock_x86_check_reserved_size() unused.  Kill them.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1310462166-31469-8-git-send-email-tj@kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/memblock.h |    3 --
 arch/x86/kernel/check.c         |   34 +++++++++------------
 arch/x86/mm/memblock.c          |   62 ---------------------------------------
 arch/x86/mm/memtest.c           |   31 ++++++++-----------
 4 files changed, 28 insertions(+), 102 deletions(-)

diff --git a/arch/x86/include/asm/memblock.h b/arch/x86/include/asm/memblock.h
index 1460db2..d2a5a59 100644
--- a/arch/x86/include/asm/memblock.h
+++ b/arch/x86/include/asm/memblock.h
@@ -3,8 +3,6 @@
 
 #define ARCH_DISCARD_MEMBLOCK
 
-u64 memblock_x86_find_in_range_size(u64 start, u64 *sizep, u64 align);
-
 void memblock_x86_reserve_range(u64 start, u64 end, char *name);
 void memblock_x86_free_range(u64 start, u64 end);
 struct range;
@@ -15,6 +13,5 @@ int get_free_all_memory_range(struct range **rangep, int nodeid);
 u64 memblock_x86_hole_size(u64 start, u64 end);
 u64 memblock_x86_free_memory_in_range(u64 addr, u64 limit);
 u64 memblock_x86_memory_in_range(u64 addr, u64 limit);
-bool memblock_x86_check_reserved_size(u64 *addrp, u64 *sizep, u64 align);
 
 #endif
diff --git a/arch/x86/kernel/check.c b/arch/x86/kernel/check.c
index 95680fc..621cd23 100644
--- a/arch/x86/kernel/check.c
+++ b/arch/x86/kernel/check.c
@@ -62,7 +62,8 @@ early_param("memory_corruption_check_size", set_corruption_check_size);
 
 void __init setup_bios_corruption_check(void)
 {
-	u64 addr = PAGE_SIZE;	/* assume first page is reserved anyway */
+	phys_addr_t start, end;
+	u64 i;
 
 	if (memory_corruption_check == -1) {
 		memory_corruption_check =
@@ -82,28 +83,23 @@ void __init setup_bios_corruption_check(void)
 
 	corruption_check_size = round_up(corruption_check_size, PAGE_SIZE);
 
-	while (addr < corruption_check_size && num_scan_areas < MAX_SCAN_AREAS) {
-		u64 size;
-		addr = memblock_x86_find_in_range_size(addr, &size, PAGE_SIZE);
+	for_each_free_mem_range(i, MAX_NUMNODES, &start, &end, NULL) {
+		start = clamp_t(phys_addr_t, round_up(start, PAGE_SIZE),
+				PAGE_SIZE, corruption_check_size);
+		end = clamp_t(phys_addr_t, round_down(end, PAGE_SIZE),
+			      PAGE_SIZE, corruption_check_size);
+		if (start >= end)
+			continue;
 
-		if (!addr)
-			break;
-
-		if (addr >= corruption_check_size)
-			break;
-
-		if ((addr + size) > corruption_check_size)
-			size = corruption_check_size - addr;
-
-		memblock_x86_reserve_range(addr, addr + size, "SCAN RAM");
-		scan_areas[num_scan_areas].addr = addr;
-		scan_areas[num_scan_areas].size = size;
-		num_scan_areas++;
+		memblock_x86_reserve_range(start, end, "SCAN RAM");
+		scan_areas[num_scan_areas].addr = start;
+		scan_areas[num_scan_areas].size = end - start;
 
 		/* Assume we've already mapped this early memory */
-		memset(__va(addr), 0, size);
+		memset(__va(start), 0, end - start);
 
-		addr += size;
+		if (++num_scan_areas >= MAX_SCAN_AREAS)
+			break;
 	}
 
 	if (num_scan_areas)
diff --git a/arch/x86/mm/memblock.c b/arch/x86/mm/memblock.c
index 97fbc39..648d47d 100644
--- a/arch/x86/mm/memblock.c
+++ b/arch/x86/mm/memblock.c
@@ -7,68 +7,6 @@
 #include <linux/mm.h>
 #include <linux/range.h>
 
-/* Check for already reserved areas */
-bool __init memblock_x86_check_reserved_size(u64 *addrp, u64 *sizep, u64 align)
-{
-	struct memblock_region *r;
-	u64 addr = *addrp, last;
-	u64 size = *sizep;
-	bool changed = false;
-
-again:
-	last = addr + size;
-	for_each_memblock(reserved, r) {
-		if (last > r->base && addr < r->base) {
-			size = r->base - addr;
-			changed = true;
-			goto again;
-		}
-		if (last > (r->base + r->size) && addr < (r->base + r->size)) {
-			addr = round_up(r->base + r->size, align);
-			size = last - addr;
-			changed = true;
-			goto again;
-		}
-		if (last <= (r->base + r->size) && addr >= r->base) {
-			*sizep = 0;
-			return false;
-		}
-	}
-	if (changed) {
-		*addrp = addr;
-		*sizep = size;
-	}
-	return changed;
-}
-
-/*
- * Find next free range after start, and size is returned in *sizep
- */
-u64 __init memblock_x86_find_in_range_size(u64 start, u64 *sizep, u64 align)
-{
-	struct memblock_region *r;
-
-	for_each_memblock(memory, r) {
-		u64 ei_start = r->base;
-		u64 ei_last = ei_start + r->size;
-		u64 addr;
-
-		addr = round_up(ei_start, align);
-		if (addr < start)
-			addr = round_up(start, align);
-		if (addr >= ei_last)
-			continue;
-		*sizep = ei_last - addr;
-		while (memblock_x86_check_reserved_size(&addr, sizep, align))
-			;
-
-		if (*sizep)
-			return addr;
-	}
-
-	return 0;
-}
-
 static __init struct range *find_range_array(int count)
 {
 	u64 end, size, mem;
diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index 92faf3a..46a5ff2 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -70,24 +70,19 @@ static void __init memtest(u64 pattern, u64 start_phys, u64 size)
 
 static void __init do_one_pass(u64 pattern, u64 start, u64 end)
 {
-	u64 size = 0;
-
-	while (start < end) {
-		start = memblock_x86_find_in_range_size(start, &size, 1);
-
-		/* done ? */
-		if (start >= end)
-			break;
-		if (start + size > end)
-			size = end - start;
-
-		printk(KERN_INFO "  %010llx - %010llx pattern %016llx\n",
-		       (unsigned long long) start,
-		       (unsigned long long) start + size,
-		       (unsigned long long) cpu_to_be64(pattern));
-		memtest(pattern, start, size);
-
-		start += size;
+	u64 i;
+	phys_addr_t this_start, this_end;
+
+	for_each_free_mem_range(i, MAX_NUMNODES, &this_start, &this_end, NULL) {
+		this_start = clamp_t(phys_addr_t, this_start, start, end);
+		this_end = clamp_t(phys_addr_t, this_end, start, end);
+		if (this_start < this_end) {
+			printk(KERN_INFO "  %010llx - %010llx pattern %016llx\n",
+			       (unsigned long long)this_start,
+			       (unsigned long long)this_end,
+			       (unsigned long long)cpu_to_be64(pattern));
+			memtest(pattern, this_start, this_end - this_start);
+		}
 	}
 }
 
