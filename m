Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab1E2SOF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 14:14:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51348 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab1E2SOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 14:14:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BwN1C83UYUxaCplsqrZS09GUoUfniMQvvm6nRYuF4CkCfSgyZ5cKNPSDf1+g+/VHbU
         zCux5bid5vbMJKtD2DGfy78CWANTb9GW+qlSF68X+zBjSHEyl6pQjeefIwxWvy/JTyPd
         EtU43OT+iOQo68x1MBNRMFDwRN2bnhCivQKT0=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH v2 00/10] Prevent LRU churning
Date: Mon, 30 May 2011 03:13:39 +0900
Message-Id: <cover.1306689214.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog since V1
 o Rebase on 2.6.39
 o change description slightly

There are some places to isolate and putback pages.
For example, compaction does it for getting contiguous page.
The problem is that if we isolate page in the middle of LRU and putback it
we lose LRU history as putback_lru_page inserts the page into head of LRU list. 

LRU history is important parameter to select victim page in curre page reclaim
when memory pressure is heavy. Unfortunately, if someone want to allocate high-order page
and memory pressure is heavy, it would trigger compaction and we end up lost LRU history.
It means we can evict working set pages and system latency would be high.

This patch is for solving the problem with two methods.

 * Anti-churning
   when we isolate page on LRU list, let's not isolate page we can't handle
 * De-churning
   when we putback page on LRU list in migration, let's insert new page into old page's lru position.

[1,2,3/10] is just clean up.
[4,5,6/10] is related to Anti-churning. 
[7,8,9/10] is related to De-churning. 
[10/10] is adding to new tracepoints which is never for merge but just show the effect.

I test and pass this series all[yes|no|mod|def]config.
And in my machine(1G DRAM, Intel Core 2 Duo), test scenario is following as. 

1) Boot up
2) qemu ubuntu start up (1G mem)
3) Run many applications and switch attached script(which is made by Wu)

I think this is worst-case scenario since there are many contiguous pages when machine boots up.
It means system memory isn't aging so that many pages are contiguous-LRU order. It could make 
bad effect on inorder-lru but I solved the problem. Please see description of [7/10].

Test result is following as. 
For compaction, it isolated about 20000 pages. Only 10 pages are put backed with
out-of-order(ie, head of LRU) Others, about 19990 pages are put-backed with in-order
(ie, position of old page while migration happens). It is eactly what I want.

Welcome to any comment.

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

 include/linux/memcontrol.h             |    5 +-
 include/linux/migrate.h                |   40 ++++
 include/linux/mm_types.h               |   16 ++-
 include/linux/swap.h                   |   18 ++-
 include/trace/events/inorder_putback.h |   79 +++++++
 include/trace/events/vmscan.h          |    8 +-
 mm/compaction.c                        |   47 ++--
 mm/internal.h                          |    2 +
 mm/memcontrol.c                        |    3 +-
 mm/migrate.c                           |  393 +++++++++++++++++++++++++++++++-
 mm/swap.c                              |    2 +-
 mm/vmscan.c                            |  115 ++++++++--
 12 files changed, 673 insertions(+), 55 deletions(-)
 create mode 100644 include/trace/events/inorder_putback.h

