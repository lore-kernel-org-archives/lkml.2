Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab2IUKq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 06:46:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47249 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449Ab2IUKq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 06:46:28 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Davies <richard@arachsys.com>, Shaohua Li <shli@kernel.org>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        QEMU-devel <qemu-devel@nongnu.org>, KVM <kvm@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 0/9] Reduce compaction scanning and lock contention
Date: Fri, 21 Sep 2012 11:46:14 +0100
Message-Id: <1348224383-1499-1-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Richard Davies and Shaohua Li have both reported lock contention
problems in compaction on the zone and LRU locks as well as
significant amounts of time being spent in compaction. This series
aims to reduce lock contention and scanning rates to reduce that CPU
usage. Richard reported at https://lkml.org/lkml/2012/9/21/91 that
this series made a big different to a problem he reported in August
(http://marc.info/?l=kvm&m=134511507015614&w=2).

Patches 1-3 reverts existing patches in Andrew's tree that get replaced
	later in the series.

Patch 4 is a fix for c67fe375 (mm: compaction: Abort async compaction if
	locks are contended or taking too long) to properly abort in all
	cases when contention is detected.

Patch 5 defers acquiring the zone->lru_lock as long as possible.

Patch 6 defers acquiring the zone->lock as lock as possible.

Patch 7 reverts Rik's "skip-free" patches as the core concept gets
	reimplemented later and the remaining patches are easier to
	understand if this is reverted first.

Patch 8 adds a pageblock-skip bit to the pageblock flags to cache what
	pageblocks should be skipped by the migrate and free scanners.
	This drastically reduces the amount of scanning compaction has
	to do.

Patch 9 reimplements something similar to Rik's idea except it uses the
	pageblock-skip information to decide where the scanners should
	restart from and does not need to wrap around.

I tested this on 3.6-rc6 + linux-next/akpm. Kernels tested were

akpm-20120920	3.6-rc6 + linux-next/akpm as of Septeber 20th, 2012
lesslock	Patches 1-6
revert		Patches 1-7
cachefail	Patches 1-8
skipuseless	Patches 1-9

Stress high-order allocation tests looked ok. Success rates are more or
less the same with the full series applied but there is an expectation that
there is less opportunity to race with other allocation requests if there is
less scanning. The time to complete the tests did not vary that much and are
uninteresting as were the vmstat statistics so I will not present them here.

Using ftrace I recorded how much scanning was done by compaction and got this

                            3.6.0-rc6     3.6.0-rc6   3.6.0-rc6  3.6.0-rc6 3.6.0-rc6
                            akpm-20120920 lockless  revert-v2r2  cachefail skipuseless

Total   free    scanned         360753976  515414028  565479007   17103281   18916589 
Total   free    isolated          2852429    3597369    4048601     670493     727840 
Total   free    efficiency        0.0079%    0.0070%    0.0072%    0.0392%    0.0385% 
Total   migrate scanned         247728664  822729112 1004645830   17946827   14118903 
Total   migrate isolated          2555324    3245937    3437501     616359     658616 
Total   migrate efficiency        0.0103%    0.0039%    0.0034%    0.0343%    0.0466% 

The efficiency is worthless because of the nature of the test and the
number of failures.  The really interesting point as far as this patch
series is concerned is the number of pages scanned. Note that reverting
Rik's patches massively increases the number of pages scanned indicating
that those patches really did make a difference to CPU usage.

However, caching what pageblocks should be skipped has a much higher
impact. With patches 1-8 applied, free page and migrate page scanning are
both reduced by 95% in comparison to the akpm kernel.  If the basic concept
of Rik's patches are implemened on top then scanning then the free scanner
barely changed but migrate scanning was further reduced. That said, tests
on 3.6-rc5 indicated that the last patch had greater impact than what was
measured here so it is a bit variable.

One way or the other, this series has a large impact on the amount of
scanning compaction does when there is a storm of THP allocations.

 include/linux/mmzone.h          |    5 +-
 include/linux/pageblock-flags.h |   19 +-
 mm/compaction.c                 |  397 +++++++++++++++++++++++++--------------
 mm/internal.h                   |   11 +-
 mm/page_alloc.c                 |    6 +-
 5 files changed, 280 insertions(+), 158 deletions(-)

-- 
1.7.9.2

