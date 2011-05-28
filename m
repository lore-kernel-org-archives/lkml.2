Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab1E1UOV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 16:14:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49846 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193Ab1E1UOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 16:14:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=bFgqFJ9TIETdkeez9GLbijFS40YkMmvd8UG3249D+FmyL1PSWcpqFgkeYR/BVkdVav
         VBrPPBItgBQ++12Hg/1w==
Date: Sat, 28 May 2011 13:14:09 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH] tmpfs: fix race between truncate and writepage
Message-ID: <alpine.LSU.2.00.1105281311150.13319@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While running fsx on tmpfs with a memhog then swapoff, swapoff was hanging
(interruptibly), repeatedly failing to locate the owner of a 0xff entry in
the swap_map.

Although shmem_writepage() does abandon when it sees incoming page index
is beyond eof, there was still a window in which shmem_truncate_range()
could come in between writepage's dropping lock and updating swap_map,
find the half-completed swap_map entry, and in trying to free it,
leave it in a state that swap_shmem_alloc() could not correct.

Arguably a bug in __swap_duplicate()'s and swap_entry_free()'s handling
of the different cases, but easiest to fix by moving swap_shmem_alloc()
under cover of the lock.

More interesting than the bug: it's been there since 2.6.33, why could
I not see it with earlier kernels?  The mmotm of two weeks ago seems to
have some magic for generating races, this is just one of three I found.

With yesterday's git I first saw this in mainline, bisected in search of
that magic, but the easy reproducibility evaporated.  Oh well, fix the bug.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: stable@kernel.org
---
 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux.orig/mm/shmem.c	2011-05-27 19:05:27.000000000 -0700
+++ linux/mm/shmem.c	2011-05-27 19:45:44.194813695 -0700
@@ -1114,8 +1114,8 @@ static int shmem_writepage(struct page *
 		delete_from_page_cache(page);
 		shmem_swp_set(info, entry, swap.val);
 		shmem_swp_unmap(entry);
-		spin_unlock(&info->lock);
 		swap_shmem_alloc(swap);
+		spin_unlock(&info->lock);
 		BUG_ON(page_mapped(page));
 		swap_writepage(page, wbc);
 		return 0;
