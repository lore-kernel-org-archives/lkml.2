Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab0JAJbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 05:31:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801Ab0JAJbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 05:31:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] MN10300: Fix flush_icache_range()
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Date: Fri, 01 Oct 2010 10:31:03 +0100
Message-ID: <20101001093103.10891.25807.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flush_icache_range() is given virtual addresses to describe the region.  It
deals with these by attempting to translate them through the current set of
page tables.

This is fine for userspace memory and vmalloc()'d areas as they are governed by
page tables.  However, since the regions above 0x80000000 aren't translated
through the page tables by the MMU, the kernel doesn't bother to set up page
tables for them (see paging_init()).

This means flush_icache_range() as it stands cannot be used to flush regions of
the VM area between 0x80000000 and 0x9fffffff where the kernel resides if the
data cache is operating in WriteBack mode.

To fix this, make flush_icache_range() first check for addresses in the upper
half of VM space and deal with them appropriately, before dealing with any
range in the page table mapped area.

Ordinarily, this is not a problem, but it has the capacity to make kprobes and
kgdb malfunction.  It should not affect gdbstub, signal frame setup or module
loading as gdb has its own flush functions, and the others take place in the
page table mapped area only.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
---

 arch/mn10300/mm/cache.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)


diff --git a/arch/mn10300/mm/cache.c b/arch/mn10300/mm/cache.c
index 1b76719..9261217 100644
--- a/arch/mn10300/mm/cache.c
+++ b/arch/mn10300/mm/cache.c
@@ -54,13 +54,30 @@ EXPORT_SYMBOL(flush_icache_page);
 void flush_icache_range(unsigned long start, unsigned long end)
 {
 #ifdef CONFIG_MN10300_CACHE_WBACK
-	unsigned long addr, size, off;
+	unsigned long addr, size, base, off;
 	struct page *page;
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *ppte, pte;
 
+	if (end > 0x80000000UL) {
+		/* addresses above 0xa0000000 do not go through the cache */
+		if (end > 0xa0000000UL) {
+			end = 0xa0000000UL;
+			if (start >= end)
+				return;
+		}
+
+		/* kernel addresses between 0x80000000 and 0x9fffffff do not
+		 * require page tables, so we just map such addresses directly */
+		base = (start >= 0x80000000UL) ? start : 0x80000000UL;
+		mn10300_dcache_flush_range(base, end);
+		if (base == start)
+			goto invalidate;
+		end = base;
+	}
+
 	for (; start < end; start += size) {
 		/* work out how much of the page to flush */
 		off = start & (PAGE_SIZE - 1);
@@ -104,6 +121,7 @@ void flush_icache_range(unsigned long start, unsigned long end)
 	}
 #endif
 
+invalidate:
 	mn10300_icache_inv();
 }
 EXPORT_SYMBOL(flush_icache_range);

