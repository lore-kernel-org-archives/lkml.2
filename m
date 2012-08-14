Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab2HNIzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:55:12 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:53530 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab2HNIzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:55:09 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-7b-502a126b3c69
From: Minchan Kim <minchan@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>
Subject: [RFC 0/2] Reduce alloc_contig_range latency
Date: Tue, 14 Aug 2012 17:57:05 +0900
Message-Id: <1344934627-8473-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I played with CMA's core function alloc_contig_range and
found it's very very slow so I suspect we can use it in
real practice.

I tested it with a bit tweak for working CMA in x86 on qemu.
Test environment is following as.

1. x86_64 machince, 2G RAM, 4 core, movable zone 40M with
   try alloc_contig_range(movable_zone->middle_pfn, movable_zone->middle_pfn + 10M)
   per 5sec until background stress test program is terminated.

2. There is background stress program which can make lots of clean cache page.
   It mimics movie player.

alloc_contig_range's latency unit: usec
before:
min 204000 max 8156000 mean 3109310.34482759 success count 58

after:
min 8000 max 112000 mean 45788.2352941177 success count 85

So this patch reduces 8 sec as worst case, 3 sec as mean case.
I'm off from now on until the day of tomorrow so please understand
if I can't reply instantly.

Minchan Kim (2):
  cma: remove __reclaim_pages
  cma: support MIGRATE_DISCARD

 include/linux/migrate_mode.h |   11 +++++--
 include/linux/mm.h           |    2 +-
 include/linux/mmzone.h       |    9 ------
 mm/compaction.c              |    2 +-
 mm/migrate.c                 |   50 +++++++++++++++++++++++------
 mm/page_alloc.c              |   73 +++++-------------------------------------
 6 files changed, 58 insertions(+), 89 deletions(-)

-- 
1.7.9.5

