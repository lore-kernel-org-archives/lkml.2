Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934103Ab1ESSJK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:09:10 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39092 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934074Ab1ESSJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:09:03 -0400
X-Sasl-enc: LLy4oz6c6LqLe4SVAfZbere/VyQ22CAgeTyXx6ZxzTD3 1305828542
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:59 2011
Message-Id: <20110519180559.000998675@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:05:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hughd@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: [49/71] tmpfs: fix spurious ENOSPC when racing with unswap
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hughd@google.com>

commit 59a16ead572330deb38e5848151d30ed1af754bc upstream.

Testing the shmem_swaplist replacements for igrab() revealed another bug:
writes to /dev/loop0 on a tmpfs file which fills its filesystem were
sometimes failing with "Buffer I/O error"s.

These came from ENOSPC failures of shmem_getpage(), when racing with
swapoff: the same could happen when racing with another shmem_getpage(),
pulling the page in from swap in between our find_lock_page() and our
taking the info->lock (though not in the single-threaded loop case).

This is unacceptable, and surprising that I've not noticed it before:
it dates back many years, but (presumably) was made a lot easier to
reproduce in 2.6.36, which sited a page preallocation in the race window.

Fix it by rechecking the page cache before settling on an ENOSPC error.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/shmem.c |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1407,20 +1407,14 @@ repeat:
 		if (sbinfo->max_blocks) {
 			if (percpu_counter_compare(&sbinfo->used_blocks,
 						sbinfo->max_blocks) >= 0 ||
-			    shmem_acct_block(info->flags)) {
-				spin_unlock(&info->lock);
-				error = -ENOSPC;
-				goto failed;
-			}
+			    shmem_acct_block(info->flags))
+				goto nospace;
 			percpu_counter_inc(&sbinfo->used_blocks);
 			spin_lock(&inode->i_lock);
 			inode->i_blocks += BLOCKS_PER_PAGE;
 			spin_unlock(&inode->i_lock);
-		} else if (shmem_acct_block(info->flags)) {
-			spin_unlock(&info->lock);
-			error = -ENOSPC;
-			goto failed;
-		}
+		} else if (shmem_acct_block(info->flags))
+			goto nospace;
 
 		if (!filepage) {
 			int ret;
@@ -1500,6 +1494,24 @@ done:
 	error = 0;
 	goto out;
 
+nospace:
+	/*
+	 * Perhaps the page was brought in from swap between find_lock_page
+	 * and taking info->lock?  We allow for that at add_to_page_cache_lru,
+	 * but must also avoid reporting a spurious ENOSPC while working on a
+	 * full tmpfs.  (When filepage has been passed in to shmem_getpage, it
+	 * is already in page cache, which prevents this race from occurring.)
+	 */
+	if (!filepage) {
+		struct page *page = find_get_page(mapping, idx);
+		if (page) {
+			spin_unlock(&info->lock);
+			page_cache_release(page);
+			goto repeat;
+		}
+	}
+	spin_unlock(&info->lock);
+	error = -ENOSPC;
 failed:
 	if (*pagep != filepage) {
 		unlock_page(filepage);


