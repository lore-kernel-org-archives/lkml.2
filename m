Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab1JWGgG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 02:36:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871Ab1JWGeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 02:34:18 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Sun Oct 23 08:25:40 2011
Message-Id: <20111023062540.855550059@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Sun, 23 Oct 2011 08:24:51 +0200
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>
Subject: [23/27] mm: fix race between mremap and removing migration entry
In-Reply-To: <20111023062833.GA8126@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hughd@google.com>

commit 486cf46f3f9be5f2a966016c1a8fe01e32cde09e upstream.

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

Reported-and-tested-by: Paweł Sikora <pluto@agmk.net>
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/migrate.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
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


