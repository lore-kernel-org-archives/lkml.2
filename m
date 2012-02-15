Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab2BOW5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 17:57:10 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56730 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075Ab2BOW5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 17:57:08 -0500
Subject: [PATCH RFC 00/15] mm: memory book keeping and lru_lock splitting
To: linux-mm@kvack.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 16 Feb 2012 02:57:04 +0400
Message-ID: <20120215224221.22050.80605.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no logic changes in this patchset, this is only tossing bits around.
[ This patchset is on top some memcg cleanup/rework patches,
  which I sent to linux-mm@ today/yesterday ]

Most of things in this patchset are self-descriptive, so here brief plan:

* Transmute struct lruvec into struct book. Like real book this struct will
  store set of pages for one zone. It will be working unit for reclaimer code.
[ If memcg is disabled in config there will only one book embedded into struct zone ]

* move page-lru counters to struct book
[ this adds extra overhead in add_page_to_lru_list()/del_page_from_lru_list() for
  non-memcg case, but I believe it will be invisible, only one non-atomic add/sub
  in the same cacheline with lru list ]

* unify inactive_list_is_low_global() and cleanup reclaimer code
* replace struct mem_cgroup_zone with single pointer to struct book
* optimize page to book translations, move it upper in the call stack,
  replace some struct zone arguments with struct book pointer.

page -> book dereference become main operation, page (even free) will always
points to one book in its zone. so page->flags bits may contains direct reference to book.
Maybe we can replace page_zone(page) with book_zone(page_book(page)), without mem cgroups
book -> zone dereference will be simple container_of().

Finally, there appears some new locking primitives for decorating lru_lock splitting logic.
Final patch actually splits zone->lru_lock into small per-book pieces.
All this code currently *completely untested*, but seems like it already can work.


After that, there two options how manage struct book on mem-cgroup create/destroy:
a) [ currently implemented ] allocate and release by rcu.
   Thus lock_page_book() will be protected with rcu_read_lock().
b) allocate and never release struct book, reuse them after rcu grace period.
   It allows to avoid some rcu_read_lock()/rcu_read_unlock() calls on hot paths.


Motivation:
I wrote the similar memory controller for our rhel6-based openvz/virtuozzo kernel,
including splitted lru-locks and some other [patented LOL] cool stuff.
[ common descrioption without techical details: http://wiki.openvz.org/VSwap ]
That kernel already in production and rather stable for a long time.

---

Konstantin Khlebnikov (15):
      mm: rename struct lruvec into struct book
      mm: memory bookkeeping core
      mm: add book->pages_count
      mm: unify inactive_list_is_low()
      mm: add book->reclaim_stat
      mm: kill struct mem_cgroup_zone
      mm: move page-to-book translation upper
      mm: introduce book locking primitives
      mm: handle book relocks on lumpy reclaim
      mm: handle book relocks in compaction
      mm: handle book relock in memory controller
      mm: optimize books in update_page_reclaim_stat()
      mm: optimize books in pagevec_lru_move_fn()
      mm: optimize putback for 0-order reclaim
      mm: split zone->lru_lock


 include/linux/memcontrol.h |   52 -------
 include/linux/mm_inline.h  |  222 ++++++++++++++++++++++++++++-
 include/linux/mmzone.h     |   26 ++-
 include/linux/swap.h       |    2 
 init/Kconfig               |    4 +
 mm/compaction.c            |   35 +++--
 mm/huge_memory.c           |   10 +
 mm/memcontrol.c            |  238 ++++++++++---------------------
 mm/page_alloc.c            |   20 ++-
 mm/swap.c                  |  128 ++++++-----------
 mm/vmscan.c                |  334 +++++++++++++++++++-------------------------
 11 files changed, 554 insertions(+), 517 deletions(-)

-- 
Signature
