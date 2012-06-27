Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490Ab2F0Hvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 03:51:52 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61190 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab2F0Hvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 03:51:51 -0400
X-AuditID: 9c930197-b7b43ae00000668c-c0-4feabb940848
From: Minchan Kim <minchan@kernel.org>
To: akpm@linux-foundation.org
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Aaditya Kumar <aaditya.kumar.30@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 0/2 v2] fix livelock because of kswapd stop
Date: Wed, 27 Jun 2012 16:51:52 +0900
Message-Id: <1340783514-8150-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When hotplug offlining happens on zone A, it starts to mark freed page
as MIGRATE_ISOLATE type in buddy for preventing further allocation.
(MIGRATE_ISOLATE is very irony type because it's apparently on buddy
but we can't allocate them).
When the memory shortage happens during hotplug offlining,
current task starts to reclaim, then wake up kswapd.
Kswapd checks watermark, then go sleep because current zone_watermark_ok_safe
doesn't consider MIGRATE_ISOLATE freed page count.
Current task continue to reclaim in direct reclaim path without kswapd's helping.
The problem is that zone->all_unreclaimable is set by only kswapd
so that current task would be looping forever like below.

__alloc_pages_slowpath
restart:
	wake_all_kswapd
rebalance:
	__alloc_pages_direct_reclaim
		do_try_to_free_pages
			if global_reclaim && !all_unreclaimable
				return 1; /* It means we did did_some_progress */
	skip __alloc_pages_may_oom
	should_alloc_retry
		goto rebalance;

[1/2] factor out memory-isolation functions from page_alloc.c to mm/page_isolation.c
      This patch can be merged regardless of [2/2].

[2/2] fix this problem.
      Aaditya, Could you confirm this patch can solve your problem?

Minchan Kim (2):
  mm: Factor out memory isolate functions
  memory-hotplug: fix kswapd looping forever problem

 drivers/base/Kconfig           |    1 +
 include/linux/mmzone.h         |    8 ++++
 include/linux/page-isolation.h |    8 ++--
 mm/Kconfig                     |    5 ++
 mm/Makefile                    |    4 +-
 mm/page_alloc.c                |  102 ++++++++++++----------------------------
 mm/page_isolation.c            |   96 +++++++++++++++++++++++++++++++++++++
 7 files changed, 147 insertions(+), 77 deletions(-)

-- 
1.7.9.5

