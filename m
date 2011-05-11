Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab1EKRRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:17:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57441 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab1EKRRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:17:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=iPnX3/jYs0wilP3YcNKJ0iFP3qJhtYqoodXZNgk2RfkYkmeinltCV/9jOTJv0jN6d1
         6DYfxbLaSx4yraKf5cXQfqiK7kECVCsuIY73Df5tQi4ty6BU7VV6GrzHWxpNYkxDg8aX
         tLheo7P6ZKwR2y4FxAvRmhPb3bQnf+dqd6Z6w=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH v1 00/10] Prevent LRU churning
Date: Thu, 12 May 2011 02:16:39 +0900
Message-Id: <cover.1305132792.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some places to isolated and putback pages.
For example, compaction does it for getting contiguous page.
The problem is that if we isolate page in the middle of LRU and putback it, 
we lose LRU history as putback_lru_page inserts the page into head of LRU list. 
It means we can evict working set pages. This problem is discussed at LSF/MM.

This patch is for solving the problem as two methods.

 * Anti-churning
   when we isolate page on LRU list, let's not isolate page we can't handle
 * De-churning
   when we putback page on LRU list in migration, let's insert new page into old page's lru position.

[1,2,3/10] is just clean up.
[4,5,6/10] is related to Anti-churning. 
[7,8,9/10] is related to De-churning. 
[10/10] is adding to new tracepoints which is never for merge but just show the effect.

[7/10] is core of in-order putback support but it has a problem on hugepage like
physicall contiguos page stream in my previous RFC version. 
It was already pointed out by Rik. I have another idea to solve it.
Please see description of [7/10].

I test this series in my machine.(1G DRAM, Intel Core 2 Duo)
Test scenario is following as. 

1) Boot up
2) qemu ubuntu start up 
3) Run many applications and switch attached script(which is made by Wu)

I think this scenario is worst case since there are many contigous pages
when mahchine boots up by not aging(ie, not-fragment).

Test result is following as. 
For compaction, it isolated about 20000 pages. Only 10 pages are put backed with
out-of-order(ie, head of LRU)
Others, about 19990 pages are put backed with in-order(ie, position of old page while
migration happens)

Thanks. 

Minchan Kim (10):
  [1/10] Make clear description of isolate/putback functions
  [2/10] compaction: trivial clean up acct_isolated
  [3/10] Change int mode for isolate mode with enum ISOLATE_PAGE_MODE
  [4/10] Add additional isolation mode
  [5/10] compaction: make isolate_lru_page with filter aware
  [6/10] vmscan: make isolate_lru_page with filter aware
  [7/10] In order putback lru core
  [8/10] migration: make in-order-putback aware
  [9/10] compaction: make compaction use in-order putback
  [10/10] add tracepoints

 include/linux/memcontrol.h    |    5 +-
 include/linux/migrate.h       |   40 +++++
 include/linux/mm_types.h      |   16 ++-
 include/linux/swap.h          |   18 ++-
 include/trace/events/vmscan.h |    8 +-
 mm/compaction.c               |   47 +++---
 mm/internal.h                 |    2 +
 mm/memcontrol.c               |    3 +-
 mm/migrate.c                  |  389 ++++++++++++++++++++++++++++++++++++++++-
 mm/swap.c                     |    2 +-
 mm/vmscan.c                   |  115 ++++++++++--
 11 files changed, 590 insertions(+), 55 deletions(-)

