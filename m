Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab1FGPHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 11:07:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55025 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182Ab1FGPHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 11:07:10 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Thomas Sattler <tsattler@gmx.de>,
        Ury Stankevich <urykhy@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] Fix compaction stalls due to accounting errors in isolated page accounting
Date: Tue,  7 Jun 2011 16:07:01 +0100
Message-Id: <1307459225-4481-1-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were some reports about processes getting stalled for very long
periods of time in compaction. The bulk of this problem turned out
to be due to an accounting error wherby the isolated count could go
negative but only noticed by UP builds.

This series is the useful patches (not all mine) that came out of
the related discussions that have not been merged to -mm already.
All these patches should be considered for -stable 2.6.38 and
2.6.39. Hence, Andrea's introduction of __page_count() is missing from
this series because while it's worth merging, it's not for -stable.

Patch 1 is the primary fix for a problem where the isolated count
	could go negative on one zone and remain elevated on another.

Patch 2 notes that the linear scanner in vmscan.c cannot safely
	use page_count because it could be scanning a tail page.

Patch 3 fixes memory failure accounting of isolated pages

Patch 4 fixes a problem whereby asynchronous callers to compaction
	can still stall in too_many_isolated when it should just fail
	the allocation.

Re-verification from testers that these patches really do fix their
problems would be appreciated. Even if hangs disappear, please confirm
that the values for nr_isolated_anon and nr_isolated_file in *both*
/proc/zoneinfo and /proc/vmstat are sensible (i.e. usually zero).

 mm/compaction.c     |   41 +++++++++++++++++++++++++++++++++++------
 mm/memory-failure.c |    4 +++-
 mm/vmscan.c         |   16 ++++++++++++++--
 3 files changed, 52 insertions(+), 9 deletions(-)

-- 
1.7.3.4

