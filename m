Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163117Ab1FAI1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:27:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:45206 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162224Ab1FAI1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:27:49 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:12:17 2011
Message-Id: <20110601081216.693900933@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:11:53 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hughd@google.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [143/165] tmpfs: fix race between truncate and writepage
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1738
Lines: 46

From: Hugh Dickins <hughd@google.com>

commit 826267cf1e6c6899eda1325a19f1b1d15c558b20 upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1101,8 +1101,8 @@ static int shmem_writepage(struct page *
 		delete_from_page_cache(page);
 		shmem_swp_set(info, entry, swap.val);
 		shmem_swp_unmap(entry);
-		spin_unlock(&info->lock);
 		swap_shmem_alloc(swap);
+		spin_unlock(&info->lock);
 		BUG_ON(page_mapped(page));
 		swap_writepage(page, wbc);
 		return 0;


