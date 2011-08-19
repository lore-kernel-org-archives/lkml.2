Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab1HSHs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 03:48:57 -0400
Received: from smtp-out.google.com ([74.125.121.67]:44853 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab1HSHsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 03:48:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:date:message-id:x-mailer:x-system-of-record;
	b=FV+7B5NDuk+owwrUnhTcJjmP/riumci0TgVESjeROpdSbl7pOzwx6dgQ9KiN7Awzx
	oc4Jqam1DlmBVoaVyRiJg==
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Andrea Arcangeli <aarcange@redhat.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>
Subject: [PATCH 0/9] Use RCU to stabilize page counts
Date: Fri, 19 Aug 2011 00:48:22 -0700
Message-Id: <1313740111-27446-1-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/pagemap.h describes the protocol one should use to get pages
from page cache - one can't know if the reference they get will be on the
desired page, so newly allocated pages might see elevated reference counts,
but using RCU this effect can be limited in time to one RCU grace period.

For this protocol to work, every call site of get_page_unless_zero() has to
participate, and this was not previously enforced.

Patches 1-3 convert some get_page_unless_zero() call sites to use the proper
RCU protocol as described in pagemap.h

Patches 4-5 convert some get_page_unless_zero() call sites to just call
get_page()

Patch 6 asserts that every remaining get_page_unless_zero() call site should
participate in the RCU protocol. Well, not actually all of them -
__isolate_rcu_page() is exempted because it holds the zone LRU lock which
would prevent the given page from getting entirely freed, and a few others
related to hwpoison, memory hotplug and memory failure are exempted because
I haven't been able to figure out what to do.

Patch 7 is a placeholder for an RCU API extension we have been talking about
with Paul McKenney. The idea is to record an initial time as an opaque cookie,
and to be able to determine later on if an rcu grace period has elapsed since
that initial time.

Patch 8 adds wrapper functions to store an RCU cookie into compound pages.

Patch 9 makes use of new RCU API, as well as the prior fixes from patches 1-6,
to ensure tail page counts are stable while we split THP pages. This fixes a
(rather theorical, not actually been observed) race condition where THP page
splitting could result in incorrect page counts if THP page allocation and
splitting both occur while another thread tries to run get_page_unless_zero
on a single page that got re-allocated as THP tail page.


The patches have received only a limited amount of testing; however I
believe patches 1-6 to be sane and I would like them to get more
exposure, maybe as part of andrew's -mm tree.


Besides that, this proposal is also to sync up with Paul regarding the RCU
functionality :)


Michel Lespinasse (9):
  mm: rcu read lock for getting reference on pages in
    migration_entry_wait()
  mm: avoid calling get_page_unless_zero() when charging cgroups
  mm: rcu read lock when getting from tail to head page
  mm: use get_page in deactivate_page()
  kvm: use get_page instead of get_page_unless_zero
  mm: assert that get_page_unless_zero() callers hold the rcu lock
  rcu: rcu_get_gp_cookie() / rcu_gp_cookie_elapsed() stand-ins
  mm: add API for setting a grace period cookie on compound pages
  mm: make sure tail page counts are stable before splitting THP pages

 arch/x86/kvm/mmu.c       |    3 +--
 include/linux/mm.h       |   38 +++++++++++++++++++++++++++++++++++++-
 include/linux/mm_types.h |    6 +++++-
 include/linux/pagemap.h  |    1 +
 include/linux/rcupdate.h |   35 +++++++++++++++++++++++++++++++++++
 mm/huge_memory.c         |   33 +++++++++++++++++++++++++++++----
 mm/hwpoison-inject.c     |    2 +-
 mm/ksm.c                 |    4 ++++
 mm/memcontrol.c          |   20 ++++++++++----------
 mm/memory-failure.c      |    6 +++---
 mm/memory_hotplug.c      |    2 +-
 mm/migrate.c             |    3 +++
 mm/page_alloc.c          |    1 +
 mm/swap.c                |   22 ++++++++++++++--------
 mm/vmscan.c              |    7 ++++++-
 15 files changed, 151 insertions(+), 32 deletions(-)

-- 
1.7.3.1

