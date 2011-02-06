Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab1BFKs7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 05:48:59 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35628 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1BFKs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 05:48:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Gtn02ACTHdsMgQsvMl9tWkyBhFdXWeW72N522sRRogAFPPRV7KPgvgTlHJanBzWogE
         FVH/KmRvdWwmNAuksLYeI1Xq3wrcZwyM/EeCmpaczHNd1IMt+kgBMDMWy7/CHkAx2Co4
         cDypJUNYVCCAdtlrvAyoat90AxJZs6teOoWL4=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH v4 0/6] Change page reference handling semantic of page cache
Date: Sun,  6 Feb 2011 19:47:59 +0900
Message-Id: <cover.1296987110.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we increase page reference on add_to_page_cache but don't decrease it
in remove_from_page_cache. Such asymmetric rule makes confusing about
page reference so that caller should notice it and comment why they
release page reference. It's not good API.

Long time ago, Hugh tried it[1] but gave up of reason which
reiser4's drop_page had to unlock the page between removing it from
page cache and doing the page_cache_release. But now the situation is
changed. I think at least things in current mainline doesn't have any
obstacles. The problem is fs or somethings out of mainline.
If it has done such thing like reiser4, this patch could be a problem but
they found it when compile time since we remove remove_from_page_cache.

[1] http://lkml.org/lkml/2004/10/24/140

The series configuration is following as. 

[1/6] : This patch introduces new API delete_from_page_cache.
[2,3,4/6] : Change remove_from_page_cache with delete_from_page_cache.
Intentionally I divide patch per file since someone might have a concern 
about releasing page reference of delete_from_page_cache in 
somecase (ex, truncate.c)
[5/6] : Remove old API so out of fs can meet compile error when build time
and can notice it.
[6/6] : Change __remove_from_page_cache with __delete_from_page_cache, too.
In this time, I made all-in-one patch because it doesn't change old behavior
so it has no concern. Just clean up patch.

This patch series pass LTP test on mm and fs.

from v3
 - Add Acked-by
 - rebase on mmotm-02-04
 - remove the patch about fuse

from v2
 - Add Acked-by
 - rebase on mmotm-01-06
 - change title of some patch

from v1
 - Add Acked-by
 - rebase on mmotm-12-23

Minchan Kim (6):
  [1/6] Introduce delete_from_page_cache
  [2/6] hugetlbfs: Change remove_from_page_cache
  [3/6] shmem: Change remove_from_page_cache
  [4/6] truncate: Change remove_from_page_cache
  [5/6] Good bye remove_from_page_cache
  [6/6] Change __remove_from_page_cache

 fs/hugetlbfs/inode.c    |    3 +--
 include/linux/pagemap.h |    4 ++--
 mm/filemap.c            |   22 ++++++++++++++++------
 mm/memory-failure.c     |    2 +-
 mm/shmem.c              |    3 +--
 mm/truncate.c           |    7 +++----
 mm/vmscan.c             |    2 +-
 7 files changed, 25 insertions(+), 18 deletions(-)

