Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab1FGOiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:38:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55700 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab1FGOix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:38:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZAGsIsTtcevV/Sj4P75HHSZSmS2dVnrq3vUkJdjeRNGb/OFELELa+JepKXaCkWPwts
         y8xuNVPhhTb1iLUQufb1+hxcXKtFDEBNR16Ev8MA5pe+Iny58MJa/YCgtpOR2RxQ5SPB
         tlMWYcSya5cwgpHoMlheoP23eS+cZI6p231bg=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH v3 00/10] Prevent LRU churning
Date: Tue,  7 Jun 2011 23:38:13 +0900
Message-Id: <cover.1307455422.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog since V2
 o Remove ISOLATE_BOTH - suggested by Johannes Weiner
 o change description slightly
 o Clean up unman_and_move
 o Add Reviewed-by and Acked-by

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

You can see test script and all-at-once patch in following URL.
http://www.kernel.org/pub/linux/kernel/people/minchan/inorder_putback/v3/

Minchan Kim (10):
  [1/10] compaction: trivial clean up acct_isolated
  [2/10 Change isolate mode from int type to enum type
  [3/10] Add additional isolation mode
  [4/10] compaction: make isolate_lru_page with filter aware
  [5/10] vmscan: make isolate_lru_page with filter aware
  [6/10] In order putback lru core
  [7/10] migration: clean up unmap_and_move
  [8/10] migration: make in-order-putback aware
  [9/10] compaction: make compaction use in-order putback
  [10/10] add inorder-lru tracepoints for just measurement

 include/linux/memcontrol.h             |    5 +-
 include/linux/migrate.h                |   40 +++++
 include/linux/mm_types.h               |   16 ++-
 include/linux/swap.h                   |   15 ++-
 include/trace/events/inorder_putback.h |   79 ++++++++++
 include/trace/events/vmscan.h          |    8 +-
 mm/compaction.c                        |   47 +++---
 mm/internal.h                          |    2 +
 mm/memcontrol.c                        |    5 +-
 mm/migrate.c                           |  255 ++++++++++++++++++++++++++++----
 mm/swap.c                              |    2 +-
 mm/vmscan.c                            |  133 ++++++++++++++---
 12 files changed, 517 insertions(+), 90 deletions(-)
 create mode 100644 include/trace/events/inorder_putback.h

