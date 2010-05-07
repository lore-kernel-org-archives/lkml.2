Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab0EGN1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 09:27:25 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60258 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752022Ab0EGN1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 09:27:22 -0400
Subject: [RFC PATCH] Update the cachetlb.txt file WRT flush_dcache_page and
 update_mmu_cache
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, Russell King <rmk@arm.linux.org.uk>
Date: Fri, 07 May 2010 14:24:18 +0100
Message-ID: <20100507132418.28009.6013.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-60-g0641
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 May 2010 13:24:19.0300 (UTC) FILETIME=[99434A40:01CAEDE8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has been discussed on a few occasions about issues with D-cache
aliasing and I-D cache coherency (on Harvard architectures) caused by
PIO drivers not flushing the caches:

http://thread.gmane.org/gmane.linux.usb.general/27072
http://thread.gmane.org/gmane.linux.kernel.cross-arch/5136

This patch modifies the cachetlb.txt recommendations for implementing
flush_dcache_page() and deferred cache flushing.

Basically, flush_dcache_page() is not usually called in PIO drivers for
new page cache pages after the data was written (recent driver fixes -
commits db8516f6 and 2d68b7fe). Proposing a new PIO API has been
suggested but this requires fixing too many drivers.

A solution adopted by IA-64 and PowerPC is to always consider newly
allocated page cache pages as dirty. The meaning of PG_arch_1 would
become "D-cache clean" (rather than "D-cache dirty" as on SPARC64). This
bit is checked in set_pte_at() and, if it isn't set, this function
flushes the cache. The advantage of this approach is that it is not
necessary to previously call flush_dcache_page() for a new page cache
page, as it is the case with most PIO drivers.

It is, however, necessary for set_pte_at() to always check this flag
even if deferred cache flushing is not implemented because of PIO
drivers not calling flush_dcache_page().

There are SMP configurations where the cache maintenance operations are
not automatically broadcast to the other CPUs. One of the solutions is
to add flush_dcache_page() calls to the required PIO drivers and perform
non-deferred cache flushing. Another solution is to implement
"read-for-ownership" tricks in the architecture cache flushing function
to force D-cache lines eviction.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>
---
 Documentation/cachetlb.txt |   34 +++++++++++++++++++++++-----------
 1 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/Documentation/cachetlb.txt b/Documentation/cachetlb.txt
index 2b5f823..af67140 100644
--- a/Documentation/cachetlb.txt
+++ b/Documentation/cachetlb.txt
@@ -100,6 +100,12 @@ changes occur:
 	translations for software managed TLB configurations.
 	The sparc64 port currently does this.
 
+	NOTE: On SMP systems with hardware TLB this function cannot be
+	      paired with flush_dcache_page() for deferring the cache
+	      flushing because a page table entry written by
+	      set_pte_at() may become visible to other CPUs before the
+	      cache flushing has taken place.
+
 6) void tlb_migrate_finish(struct mm_struct *mm)
 
 	This interface is called at the end of an explicit
@@ -278,7 +284,7 @@ maps this page at its virtual address.
 
   void flush_dcache_page(struct page *page)
 
-	Any time the kernel writes to a page cache page, _OR_
+	Any time the kernel modifies an existing page cache page, _OR_
 	the kernel is about to read from a page cache page and
 	user space shared/writable mappings of this page potentially
 	exist, this routine is called.
@@ -289,20 +295,26 @@ maps this page at its virtual address.
 	      handling vfs symlinks in the page cache need not call
 	      this interface at all.
 
+	      The kernel may not call this function on a newly allocated
+	      page cache page even though it stored data into the page.
+
 	The phrase "kernel writes to a page cache page" means,
 	specifically, that the kernel executes store instructions
 	that dirty data in that page at the page->virtual mapping
 	of that page.  It is important to flush here to handle
 	D-cache aliasing, to make sure these kernel stores are
-	visible to user space mappings of that page.
+	visible to user space mappings of that page. It is also
+	important to flush the cache on Harvard architectures where the
+	I and D caches are not coherent.
 
 	The corollary case is just as important, if there are users
 	which have shared+writable mappings of this file, we must make
 	sure that kernel reads of these pages will see the most recent
 	stores done by the user.
 
-	If D-cache aliasing is not an issue, this routine may
-	simply be defined as a nop on that architecture.
+	If D-cache aliasing is not an issue and the I and D caches are
+	unified, this routine may simply be defined as a nop on that
+	architecture.
 
         There is a bit set aside in page->flags (PG_arch_1) as
 	"architecture private".  The kernel guarantees that,
@@ -312,15 +324,15 @@ maps this page at its virtual address.
 	This allows these interfaces to be implemented much more
 	efficiently.  It allows one to "defer" (perhaps indefinitely)
 	the actual flush if there are currently no user processes
-	mapping this page.  See sparc64's flush_dcache_page and
-	update_mmu_cache implementations for an example of how to go
+	mapping this page.  See IA-64's flush_dcache_page and
+	set_pte_at implementations for an example of how to go
 	about doing this.
 
 	The idea is, first at flush_dcache_page() time, if
 	page->mapping->i_mmap is an empty tree and ->i_mmap_nonlinear
-	an empty list, just mark the architecture private page flag bit.
-	Later, in update_mmu_cache(), a check is made of this flag bit,
-	and if set the flush is done and the flag bit is cleared.
+	an empty list, just clear the architecture private page flag bit.
+	Later, in set_pte_at(), a check is made of this flag bit,
+	and if cleared, the flush is done and the flag bit is set.
 
 	IMPORTANT NOTE: It is often important, if you defer the flush,
 			that the actual flush occurs on the same CPU
@@ -375,8 +387,8 @@ maps this page at its virtual address.
 
   void flush_icache_page(struct vm_area_struct *vma, struct page *page)
 	All the functionality of flush_icache_page can be implemented in
-	flush_dcache_page and update_mmu_cache. In 2.7 the hope is to
-	remove this interface completely.
+	flush_dcache_page and set_pte_at. In 2.7 the hope is to remove
+	this interface completely.
 
 The final category of APIs is for I/O to deliberately aliased address
 ranges inside the kernel.  Such aliases are set up by use of the

