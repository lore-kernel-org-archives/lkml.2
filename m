Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab1EHTpA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 15:45:00 -0400
Received: from smtp-out.google.com ([216.239.44.51]:38066 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab1EHTo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 15:44:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=LE531z+pnXhv8DWrqhTZVYW1nb52J0puDjNy/9k+D0MDqhFxLetOicA+Vwkxx0bc2x
         iQgFZpCyouvKh4g/b6hQ==
Date: Sun, 8 May 2011 12:45:08 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] tmpfs: fix spurious ENOSPC when racing with unswap
In-Reply-To: <alpine.LSU.2.00.1105081238010.15963@sister.anvils>
Message-ID: <alpine.LSU.2.00.1105081243260.15963@sister.anvils>
References: <4DAFD0B1.9090603@parallels.com> <20110421064150.6431.84511.stgit@localhost6> <20110421124424.0a10ed0c.akpm@linux-foundation.org> <4DB0FE8F.9070407@parallels.com> <alpine.LSU.2.00.1105031223120.9845@sister.anvils> <4DC4D9A6.9070103@parallels.com>
 <alpine.LSU.2.00.1105071621330.3668@sister.anvils> <4DC691D0.6050104@parallels.com> <alpine.LSU.2.00.1105081238010.15963@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@kernel.org
---

 mm/shmem.c |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

--- tmpfs2/mm/shmem.c	2011-05-07 17:39:00.656959448 -0700
+++ tmpfs3/mm/shmem.c	2011-05-07 17:40:00.665256101 -0700
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
