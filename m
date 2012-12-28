Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab2L1T1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:27:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55631 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932396Ab2L1TTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:40 -0500
Message-Id: <20121228190337.057290720@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:04 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>
Subject: [ 034/173] mm: add kmap_to_page()
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

This is extracted from Mel Gorman's commit 5a178119b0fb ('mm: add
support for direct_IO to highmem pages') upstream.

Required to backport commit b9cdc88df8e6 ('virtio: 9p: correctly pass
physical address to userspace for high pages').

Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/highmem.h |    7 +++++++
 mm/highmem.c            |   12 ++++++++++++
 mm/page_io.c            |    3 ++-
 mm/swap.c               |    3 +--
 4 files changed, 22 insertions(+), 3 deletions(-)

--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -38,10 +38,17 @@ extern unsigned long totalhigh_pages;
 
 void kmap_flush_unused(void);
 
+struct page *kmap_to_page(void *addr);
+
 #else /* CONFIG_HIGHMEM */
 
 static inline unsigned int nr_free_highpages(void) { return 0; }
 
+static inline struct page *kmap_to_page(void *addr)
+{
+	return virt_to_page(addr);
+}
+
 #define totalhigh_pages 0UL
 
 #ifndef ARCH_HAS_KMAP
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -94,6 +94,18 @@ static DECLARE_WAIT_QUEUE_HEAD(pkmap_map
 		do { spin_unlock(&kmap_lock); (void)(flags); } while (0)
 #endif
 
+struct page *kmap_to_page(void *vaddr)
+{
+	unsigned long addr = (unsigned long)vaddr;
+
+	if (addr >= PKMAP_ADDR(0) && addr <= PKMAP_ADDR(LAST_PKMAP)) {
+		int i = (addr - PKMAP_ADDR(0)) >> PAGE_SHIFT;
+		return pte_page(pkmap_page_table[i]);
+	}
+
+	return virt_to_page(addr);
+}
+
 static void flush_all_zero_pkmaps(void)
 {
 	int i;


