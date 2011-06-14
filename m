Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab1FNKoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 06:44:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52259 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062Ab1FNKoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 06:44:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=xF/MUsRumagwsINVKSIGeiLY8mmbGiMn5+pyDoI115eothYHXpeIHS24qYD5+xmKCQ
         NlSvq8Wt+oUHyGQ9M6Tw==
Date: Tue, 14 Jun 2011 03:43:47 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 2/12] mm: let swap use exceptional entries
In-Reply-To: <alpine.LSU.2.00.1106140327550.29206@sister.anvils>
Message-ID: <alpine.LSU.2.00.1106140342330.29206@sister.anvils>
References: <alpine.LSU.2.00.1106140327550.29206@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If swap entries are to be stored along with struct page pointers in
a radix tree, they need to be distinguished as exceptional entries.

Most of the handling of swap entries in radix tree will be contained
in shmem.c, but a few functions in filemap.c's common code need to
check for their appearance: find_get_page(), find_lock_page(),
find_get_pages() and find_get_pages_contig().

So as not to slow their fast paths, tuck those checks inside the
existing checks for unlikely radix_tree_deref_slot(); except for
find_lock_page(), where it is an added test.  And make it a BUG
in find_get_pages_tag(), which is not applied to tmpfs files.

A part of the reason for eliminating shmem_readpage() earlier,
was to minimize the places where common code would need to allow
for swap entries.

The swp_entry_t known to swapfile.c must be massaged into a
slightly different form when stored in the radix tree, just
as it gets massaged into a pte_t when stored in page tables.

In an i386 kernel this limits its information (type and page offset)
to 30 bits: given 32 "types" of swapfile and 4kB pagesize, that's
a maximum swapfile size of 128GB.  Which is less than the 512GB we
previously allowed with X86_PAE (where the swap entry can occupy the
entire upper 32 bits of a pte_t), but not a new limitation on 32-bit
without PAE; and there's not a new limitation on 64-bit (where swap
filesize is already limited to 16TB by a 32-bit page offset).  Thirty
areas of 128GB is probably still enough swap for a 64GB 32-bit machine.

Provide swp_to_radix_entry() and radix_to_swp_entry() conversions,
and enforce filesize limit in read_swap_header(), just as for ptes.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 include/linux/swapops.h |   23 +++++++++++++++++
 mm/filemap.c            |   49 ++++++++++++++++++++++++--------------
 mm/swapfile.c           |   20 +++++++++------
 3 files changed, 66 insertions(+), 26 deletions(-)

--- linux.orig/include/linux/swapops.h	2011-06-13 13:26:07.506101039 -0700
+++ linux/include/linux/swapops.h	2011-06-13 13:27:34.522532530 -0700
@@ -1,3 +1,8 @@
+#ifndef _LINUX_SWAPOPS_H
+#define _LINUX_SWAPOPS_H
+
+#include <linux/radix-tree.h>
+
 /*
  * swapcache pages are stored in the swapper_space radix tree.  We want to
  * get good packing density in that tree, so the index should be dense in
@@ -76,6 +81,22 @@ static inline pte_t swp_entry_to_pte(swp
 	return __swp_entry_to_pte(arch_entry);
 }
 
+static inline swp_entry_t radix_to_swp_entry(void *arg)
+{
+	swp_entry_t entry;
+
+	entry.val = (unsigned long)arg >> RADIX_TREE_EXCEPTIONAL_SHIFT;
+	return entry;
+}
+
+static inline void *swp_to_radix_entry(swp_entry_t entry)
+{
+	unsigned long value;
+
+	value = entry.val << RADIX_TREE_EXCEPTIONAL_SHIFT;
+	return (void *)(value | RADIX_TREE_EXCEPTIONAL_ENTRY);
+}
+
 #ifdef CONFIG_MIGRATION
 static inline swp_entry_t make_migration_entry(struct page *page, int write)
 {
@@ -169,3 +190,5 @@ static inline int non_swap_entry(swp_ent
 	return 0;
 }
 #endif
+
+#endif /* _LINUX_SWAPOPS_H */
--- linux.orig/mm/filemap.c	2011-06-13 13:26:44.430284135 -0700
+++ linux/mm/filemap.c	2011-06-13 13:27:34.526532556 -0700
@@ -717,9 +717,12 @@ repeat:
 		page = radix_tree_deref_slot(pagep);
 		if (unlikely(!page))
 			goto out;
-		if (radix_tree_deref_retry(page))
+		if (radix_tree_exception(page)) {
+			if (radix_tree_exceptional_entry(page))
+				goto out;
+			/* radix_tree_deref_retry(page) */
 			goto repeat;
-
+		}
 		if (!page_cache_get_speculative(page))
 			goto repeat;
 
@@ -756,7 +759,7 @@ struct page *find_lock_page(struct addre
 
 repeat:
 	page = find_get_page(mapping, offset);
-	if (page) {
+	if (page && !radix_tree_exception(page)) {
 		lock_page(page);
 		/* Has the page been truncated? */
 		if (unlikely(page->mapping != mapping)) {
@@ -852,11 +855,14 @@ repeat:
 		if (unlikely(!page))
 			continue;
 
-		/*
-		 * This can only trigger when the entry at index 0 moves out
-		 * of or back to the root: none yet gotten, safe to restart.
-		 */
-		if (radix_tree_deref_retry(page)) {
+		if (radix_tree_exception(page)) {
+			if (radix_tree_exceptional_entry(page))
+				continue;
+			/*
+			 * radix_tree_deref_retry(page):
+			 * can only trigger when entry at index 0 moves out of
+			 * or back to root: none yet gotten, safe to restart.
+			 */
 			WARN_ON(start | i);
 			goto restart;
 		}
@@ -915,12 +921,16 @@ repeat:
 		if (unlikely(!page))
 			continue;
 
-		/*
-		 * This can only trigger when the entry at index 0 moves out
-		 * of or back to the root: none yet gotten, safe to restart.
-		 */
-		if (radix_tree_deref_retry(page))
+		if (radix_tree_exception(page)) {
+			if (radix_tree_exceptional_entry(page))
+				break;
+			/*
+			 * radix_tree_deref_retry(page):
+			 * can only trigger when entry at index 0 moves out of
+			 * or back to root: none yet gotten, safe to restart.
+			 */
 			goto restart;
+		}
 
 		if (!page_cache_get_speculative(page))
 			goto repeat;
@@ -980,12 +990,15 @@ repeat:
 		if (unlikely(!page))
 			continue;
 
-		/*
-		 * This can only trigger when the entry at index 0 moves out
-		 * of or back to the root: none yet gotten, safe to restart.
-		 */
-		if (radix_tree_deref_retry(page))
+		if (radix_tree_exception(page)) {
+			BUG_ON(radix_tree_exceptional_entry(page));
+			/*
+			 * radix_tree_deref_retry(page):
+			 * can only trigger when entry at index 0 moves out of
+			 * or back to root: none yet gotten, safe to restart.
+			 */
 			goto restart;
+		}
 
 		if (!page_cache_get_speculative(page))
 			goto repeat;
--- linux.orig/mm/swapfile.c	2011-06-13 13:26:07.506101039 -0700
+++ linux/mm/swapfile.c	2011-06-13 13:27:34.526532556 -0700
@@ -1937,20 +1937,24 @@ static unsigned long read_swap_header(st
 
 	/*
 	 * Find out how many pages are allowed for a single swap
-	 * device. There are two limiting factors: 1) the number of
-	 * bits for the swap offset in the swp_entry_t type and
-	 * 2) the number of bits in the a swap pte as defined by
-	 * the different architectures. In order to find the
-	 * largest possible bit mask a swap entry with swap type 0
+	 * device. There are three limiting factors: 1) the number
+	 * of bits for the swap offset in the swp_entry_t type, and
+	 * 2) the number of bits in the swap pte as defined by the
+	 * the different architectures, and 3) the number of free bits
+	 * in an exceptional radix_tree entry. In order to find the
+	 * largest possible bit mask, a swap entry with swap type 0
 	 * and swap offset ~0UL is created, encoded to a swap pte,
-	 * decoded to a swp_entry_t again and finally the swap
+	 * decoded to a swp_entry_t again, and finally the swap
 	 * offset is extracted. This will mask all the bits from
 	 * the initial ~0UL mask that can't be encoded in either
 	 * the swp_entry_t or the architecture definition of a
-	 * swap pte.
+	 * swap pte.  Then the same is done for a radix_tree entry.
 	 */
 	maxpages = swp_offset(pte_to_swp_entry(
-			swp_entry_to_pte(swp_entry(0, ~0UL)))) + 1;
+			swp_entry_to_pte(swp_entry(0, ~0UL))));
+	maxpages = swp_offset(radix_to_swp_entry(
+			swp_to_radix_entry(swp_entry(0, maxpages)))) + 1;
+
 	if (maxpages > swap_header->info.last_page) {
 		maxpages = swap_header->info.last_page + 1;
 		/* p->max is an unsigned int: don't overflow it */
