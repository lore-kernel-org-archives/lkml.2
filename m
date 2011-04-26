Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab1DZQZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:25:40 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60952 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab1DZQZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:25:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=t1EILD9kAeStcPDpkf446I9M6SeVVQl8DPlOFrFEL5sU4oI5mDR3IkXIU93Um1Rh+y
         IQyqwsOAcKRrq1bAUMALYDqMPVVNa/0c3e1eyjHYLVAqSbMZgnT/5YPwm0tZ3yHdkqaw
         nxzo/CxD6ZrrunWBsBBSLWVxnLhsDbKs6RD/M=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [RFC 0/8] Prevent LRU churing
Date: Wed, 27 Apr 2011 01:25:17 +0900
Message-Id: <cover.1303833415.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some places to isolated and putback.
For example, compaction does it for getting contiguous page.
The problem is that if we isolate page in the middle of LRU and putback it, 
we lose LRU history as putback_lru_page inserts the page into head of LRU list. 
It means we can evict working set pages.
This problem is discussed at LSF/MM.

This patch is for solving the problem as two methods.

 * anti-churning
   when we isolate page on LRU list, let's not isolate page we can't handle
 * de-churning
   when we putback page on LRU list, let's insert isolate page into previous lru position.

[1,2,3/8] is related to anti-churing.
[4,5/8] is things I found during making this series and 
it's not dependent on this series so it could be merged. 
[6,7,8/8] is related to de-churing. 
[6/8] is core of in-order putback support but it has a problem on hugepage like
physicall contiguos page stream. It's pointed out by Rik. I have another idea to 
solve it. It is written down on description of [6/8]. Please look at it.

It's just RFC so I need more time to make code clearness and test and get data.
But before futher progress, I hope listen about approach, design, 
review the code(ex, locking, naming and so on) or anyting welcome. 

This patches are based on mmotm-2011-04-14-15-08 and my simple test is passed.

Thanks. 

Minchan Kim (8):
  [1/8] Only isolate page we can handle
  [2/8] compaction: make isolate_lru_page with filter aware
  [3/8] vmscan: make isolate_lru_page with filter aware
  [4/8] Make clear description of putback_lru_page
  [5/8] compaction: remove active list counting
  [6/8] In order putback lru core
  [7/8] migration: make in-order-putback aware
  [8/8] compaction: make compaction use in-order putback

 include/linux/migrate.h  |    6 ++-
 include/linux/mm_types.h |    7 +++
 include/linux/swap.h     |    5 ++-
 mm/compaction.c          |   27 ++++++---
 mm/internal.h            |    2 +
 mm/memcontrol.c          |    2 +-
 mm/memory-failure.c      |    2 +-
 mm/memory_hotplug.c      |    2 +-
 mm/mempolicy.c           |    4 +-
 mm/migrate.c             |  133 +++++++++++++++++++++++++++++++++++++---------
 mm/swap.c                |    2 +-
 mm/vmscan.c              |  110 ++++++++++++++++++++++++++++++++++----
 12 files changed, 247 insertions(+), 55 deletions(-)

