Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929Ab2BJWo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:44:29 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35084 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932926Ab2BJWoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:44:24 -0500
MIME-Version: 1.0
Message-Id: <20120210223441.979560646@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:33:23 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Herbert van den Bergh <herbert.van.den.bergh@oracle.com>,
        Mel Gorman <mgorman@suse.de>, Michal Nazarewicz <mina86@mina86.com>
Subject: [patch 19/55] mm: compaction: check pfn_valid when entering a new MAX_ORDER_NR_PAGES block during isolation for migration
In-Reply-To: <20120210223500.GA24178@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit 0bf380bc70ecba68cb4d74dc656cc2fa8c4d801a upstream.

When isolating for migration, migration starts at the start of a zone
which is not necessarily pageblock aligned.  Further, it stops isolating
when COMPACT_CLUSTER_MAX pages are isolated so migrate_pfn is generally
not aligned.  This allows isolate_migratepages() to call pfn_to_page() on
an invalid PFN which can result in a crash.  This was originally reported
against a 3.0-based kernel with the following trace in a crash dump.

PID: 9902   TASK: d47aecd0  CPU: 0   COMMAND: "memcg_process_s"
 #0 [d72d3ad0] crash_kexec at c028cfdb
 #1 [d72d3b24] oops_end at c05c5322
 #2 [d72d3b38] __bad_area_nosemaphore at c0227e60
 #3 [d72d3bec] bad_area at c0227fb6
 #4 [d72d3c00] do_page_fault at c05c72ec
 #5 [d72d3c80] error_code (via page_fault) at c05c47a4
    EAX: 00000000  EBX: 000c0000  ECX: 00000001  EDX: 00000807  EBP: 000c0000
    DS:  007b      ESI: 00000001  ES:  007b      EDI: f3000a80  GS:  6f50
    CS:  0060      EIP: c030b15a  ERR: ffffffff  EFLAGS: 00010002
 #6 [d72d3cb4] isolate_migratepages at c030b15a
 #7 [d72d3d14] zone_watermark_ok at c02d26cb
 #8 [d72d3d2c] compact_zone at c030b8de
 #9 [d72d3d68] compact_zone_order at c030bba1
#10 [d72d3db4] try_to_compact_pages at c030bc84
#11 [d72d3ddc] __alloc_pages_direct_compact at c02d61e7
#12 [d72d3e08] __alloc_pages_slowpath at c02d66c7
#13 [d72d3e78] __alloc_pages_nodemask at c02d6a97
#14 [d72d3eb8] alloc_pages_vma at c030a845
#15 [d72d3ed4] do_huge_pmd_anonymous_page at c03178eb
#16 [d72d3f00] handle_mm_fault at c02f36c6
#17 [d72d3f30] do_page_fault at c05c70ed
#18 [d72d3fb0] error_code (via page_fault) at c05c47a4
    EAX: b71ff000  EBX: 00000001  ECX: 00001600  EDX: 00000431
    DS:  007b      ESI: 08048950  ES:  007b      EDI: bfaa3788
    SS:  007b      ESP: bfaa36e0  EBP: bfaa3828  GS:  6f50
    CS:  0073      EIP: 080487c8  ERR: ffffffff  EFLAGS: 00010202

It was also reported by Herbert van den Bergh against 3.1-based kernel
with the following snippet from the console log.

BUG: unable to handle kernel paging request at 01c00008
IP: [<c0522399>] isolate_migratepages+0x119/0x390
*pdpt = 000000002f7ce001 *pde = 0000000000000000

It is expected that it also affects 3.2.x and current mainline.

The problem is that pfn_valid is only called on the first PFN being
checked and that PFN is not necessarily aligned.  Lets say we have a case
like this

H = MAX_ORDER_NR_PAGES boundary
| = pageblock boundary
m = cc->migrate_pfn
f = cc->free_pfn
o = memory hole

H------|------H------|----m-Hoooooo|ooooooH-f----|------H

The migrate_pfn is just below a memory hole and the free scanner is beyond
the hole.  When isolate_migratepages started, it scans from migrate_pfn to
migrate_pfn+pageblock_nr_pages which is now in a memory hole.  It checks
pfn_valid() on the first PFN but then scans into the hole where there are
not necessarily valid struct pages.

This patch ensures that isolate_migratepages calls pfn_valid when
necessary.

Reported-by: Herbert van den Bergh <herbert.van.den.bergh@oracle.com>
Tested-by: Herbert van den Bergh <herbert.van.den.bergh@oracle.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/compaction.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -320,6 +320,19 @@ static isolate_migrate_t isolate_migrate
 		} else if (!locked)
 			spin_lock_irq(&zone->lru_lock);
 
+		/*
+		 * migrate_pfn does not necessarily start aligned to a
+		 * pageblock. Ensure that pfn_valid is called when moving
+		 * into a new MAX_ORDER_NR_PAGES range in case of large
+		 * memory holes within the zone
+		 */
+		if ((low_pfn & (MAX_ORDER_NR_PAGES - 1)) == 0) {
+			if (!pfn_valid(low_pfn)) {
+				low_pfn += MAX_ORDER_NR_PAGES - 1;
+				continue;
+			}
+		}
+
 		if (!pfn_valid_within(low_pfn))
 			continue;
 		nr_scanned++;


