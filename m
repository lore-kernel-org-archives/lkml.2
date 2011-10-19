Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab1JSTu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 15:50:56 -0400
Received: from smtp-out.google.com ([74.125.121.67]:8192 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab1JSTux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 15:50:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	message-id:user-agent:mime-version:content-type:x-system-of-record;
	b=Pmry2m4ks/+vuPEDlFQkNuIL+0rpnpygLpxUYDspzf/dsDJwXzNnHvP4pAUjTdRxP
	siTjKGa6BTrMmRufNCAPw==
Date: Wed, 19 Oct 2011 12:50:35 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Pawel Sikora <pluto@agmk.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Justin Piszcz <jpiszcz@lucidpixels.com>, arekm@pid-linux.org,
        Anders Ossowicki <aowi@novozymes.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH] mm: fix race between mremap and removing migration entry
Message-ID: <alpine.LSU.2.00.1110191243300.6980@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't usually pay much attention to the stale "? " addresses in
stack backtraces, but this lucky report from Pawel Sikora hints that
mremap's move_ptes() has inadequate locking against page migration.

 3.0 BUG_ON(!PageLocked(p)) in migration_entry_to_page():
 kernel BUG at include/linux/swapops.h:105!
 RIP: 0010:[<ffffffff81127b76>]  [<ffffffff81127b76>]
                       migration_entry_wait+0x156/0x160
  [<ffffffff811016a1>] handle_pte_fault+0xae1/0xaf0
  [<ffffffff810feee2>] ? __pte_alloc+0x42/0x120
  [<ffffffff8112c26b>] ? do_huge_pmd_anonymous_page+0xab/0x310
  [<ffffffff81102a31>] handle_mm_fault+0x181/0x310
  [<ffffffff81106097>] ? vma_adjust+0x537/0x570
  [<ffffffff81424bed>] do_page_fault+0x11d/0x4e0
  [<ffffffff81109a05>] ? do_mremap+0x2d5/0x570
  [<ffffffff81421d5f>] page_fault+0x1f/0x30

mremap's down_write of mmap_sem, together with i_mmap_mutex or lock,
and pagetable locks, were good enough before page migration (with its
requirement that every migration entry be found) came in, and enough
while migration always held mmap_sem; but not enough nowadays, when
there's memory hotremove and compaction.

The danger is that move_ptes() lets a migration entry dodge around
behind remove_migration_pte()'s back, so it's in the old location when
looking at the new, then in the new location when looking at the old.

Either mremap's move_ptes() must additionally take anon_vma lock(), or
migration's remove_migration_pte() must stop peeking for is_swap_entry()
before it takes pagetable lock.

Consensus chooses the latter: we prefer to add overhead to migration
than to mremapping, which gets used by JVMs and by exec stack setup.

Reported-by: Pawel Sikora <pluto@agmk.net>
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: stable@vger.kernel.org
---

 mm/migrate.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- 3.1-rc10/mm/migrate.c	2011-07-21 19:17:23.000000000 -0700
+++ linux/mm/migrate.c	2011-10-19 11:48:51.243961016 -0700
@@ -120,10 +120,10 @@ static int remove_migration_pte(struct p
 
 		ptep = pte_offset_map(pmd, addr);
 
-		if (!is_swap_pte(*ptep)) {
-			pte_unmap(ptep);
-			goto out;
-		}
+		/*
+		 * Peek to check is_swap_pte() before taking ptlock?  No, we
+		 * can race mremap's move_ptes(), which skips anon_vma lock.
+		 */
 
 		ptl = pte_lockptr(mm, pmd);
 	}
