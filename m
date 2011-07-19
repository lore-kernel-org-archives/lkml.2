Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab1GSW5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 18:57:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49846 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab1GSW5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 18:57:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=a93NwuXMXNcdj/csEtuob96bq09TLoTEm3Rlp+leC4+nBtPYn7KJTjyWpWqF36X8F
	d4f4I9Cqo0gKOQTZf4C5w==
Date: Tue, 19 Jul 2011 15:56:55 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 3/3] mm: clarify the radix_tree exceptional cases
In-Reply-To: <alpine.LSU.2.00.1107191549540.1593@sister.anvils>
Message-ID: <alpine.LSU.2.00.1107191554340.1593@sister.anvils>
References: <alpine.LSU.2.00.1107191549540.1593@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the radix_tree exceptional cases, mostly in filemap.c, clearer.

It's hard to devise a suitable snappy name that illuminates the use
by shmem/tmpfs for swap, while keeping filemap/pagecache/radix_tree
generality.  And akpm points out that /* radix_tree_deref_retry(page) */
comments look like calls that have been commented out for unknown reason.

Skirt the naming difficulty by rearranging these blocks to handle the
transient radix_tree_deref_retry(page) case first; then just explain
the remaining shmem/tmpfs swap case in a comment.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/filemap.c |   66 ++++++++++++++++++++++++++++++++-----------------
 mm/mincore.c |    1 
 mm/shmem.c   |   12 +++++---
 3 files changed, 53 insertions(+), 26 deletions(-)

--- mmotm.orig/mm/filemap.c	2011-07-08 18:57:15.142704312 -0700
+++ mmotm/mm/filemap.c	2011-07-19 11:13:31.945882037 -0700
@@ -703,10 +703,14 @@ repeat:
 		if (unlikely(!page))
 			goto out;
 		if (radix_tree_exception(page)) {
-			if (radix_tree_exceptional_entry(page))
-				goto out;
-			/* radix_tree_deref_retry(page) */
-			goto repeat;
+			if (radix_tree_deref_retry(page))
+				goto repeat;
+			/*
+			 * Otherwise, shmem/tmpfs must be storing a swap entry
+			 * here as an exceptional entry: so return it without
+			 * attempting to raise page count.
+			 */
+			goto out;
 		}
 		if (!page_cache_get_speculative(page))
 			goto repeat;
@@ -841,15 +845,21 @@ repeat:
 			continue;
 
 		if (radix_tree_exception(page)) {
-			if (radix_tree_exceptional_entry(page))
-				continue;
+			if (radix_tree_deref_retry(page)) {
+				/*
+				 * Transient condition which can only trigger
+				 * when entry at index 0 moves out of or back
+				 * to root: none yet gotten, safe to restart.
+				 */
+				WARN_ON(start | i);
+				goto restart;
+			}
 			/*
-			 * radix_tree_deref_retry(page):
-			 * can only trigger when entry at index 0 moves out of
-			 * or back to root: none yet gotten, safe to restart.
+			 * Otherwise, shmem/tmpfs must be storing a swap entry
+			 * here as an exceptional entry: so skip over it -
+			 * we only reach this from invalidate_mapping_pages().
 			 */
-			WARN_ON(start | i);
-			goto restart;
+			continue;
 		}
 
 		if (!page_cache_get_speculative(page))
@@ -907,14 +917,20 @@ repeat:
 			continue;
 
 		if (radix_tree_exception(page)) {
-			if (radix_tree_exceptional_entry(page))
-				break;
+			if (radix_tree_deref_retry(page)) {
+				/*
+				 * Transient condition which can only trigger
+				 * when entry at index 0 moves out of or back
+				 * to root: none yet gotten, safe to restart.
+				 */
+				goto restart;
+			}
 			/*
-			 * radix_tree_deref_retry(page):
-			 * can only trigger when entry at index 0 moves out of
-			 * or back to root: none yet gotten, safe to restart.
+			 * Otherwise, shmem/tmpfs must be storing a swap entry
+			 * here as an exceptional entry: so stop looking for
+			 * contiguous pages.
 			 */
-			goto restart;
+			break;
 		}
 
 		if (!page_cache_get_speculative(page))
@@ -976,13 +992,19 @@ repeat:
 			continue;
 
 		if (radix_tree_exception(page)) {
-			BUG_ON(radix_tree_exceptional_entry(page));
+			if (radix_tree_deref_retry(page)) {
+				/*
+				 * Transient condition which can only trigger
+				 * when entry at index 0 moves out of or back
+				 * to root: none yet gotten, safe to restart.
+				 */
+				goto restart;
+			}
 			/*
-			 * radix_tree_deref_retry(page):
-			 * can only trigger when entry at index 0 moves out of
-			 * or back to root: none yet gotten, safe to restart.
+			 * This function is never used on a shmem/tmpfs
+			 * mapping, so a swap entry won't be found here.
 			 */
-			goto restart;
+			BUG();
 		}
 
 		if (!page_cache_get_speculative(page))
--- mmotm.orig/mm/mincore.c	2011-07-08 18:57:15.174704475 -0700
+++ mmotm/mm/mincore.c	2011-07-19 11:13:31.949882063 -0700
@@ -72,6 +72,7 @@ static unsigned char mincore_page(struct
 	 */
 	page = find_get_page(mapping, pgoff);
 #ifdef CONFIG_SWAP
+	/* shmem/tmpfs may return swap: account for swapcache page too. */
 	if (radix_tree_exceptional_entry(page)) {
 		swp_entry_t swap = radix_to_swp_entry(page);
 		page = find_get_page(&swapper_space, swap.val);
--- mmotm.orig/mm/shmem.c	2011-07-19 11:11:33.709295729 -0700
+++ mmotm/mm/shmem.c	2011-07-19 11:13:31.953882076 -0700
@@ -332,10 +332,14 @@ repeat:
 		if (unlikely(!page))
 			continue;
 		if (radix_tree_exception(page)) {
-			if (radix_tree_exceptional_entry(page))
-				goto export;
-			/* radix_tree_deref_retry(page) */
-			goto restart;
+			if (radix_tree_deref_retry(page))
+				goto restart;
+			/*
+			 * Otherwise, we must be storing a swap entry
+			 * here as an exceptional entry: so return it
+			 * without attempting to raise page count.
+			 */
+			goto export;
 		}
 		if (!page_cache_get_speculative(page))
 			goto repeat;
