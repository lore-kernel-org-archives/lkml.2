Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403Ab2F0ERt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 00:17:49 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60111 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708Ab2F0ERr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 00:17:47 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Taras Glek <tgek@mozilla.com>, Mike Hommey <mh@glandium.org>,
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 0/5][RFC] Fallocate Volatile Ranges v5
Date: Wed, 27 Jun 2012 00:17:10 -0400
Message-Id: <1340770635-9909-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062704-5112-0000-0000-00000980BF78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After sending out my last iteration, I got very little feedback, so
I wanted to try sending this out again for comment.

This patchset has two parts:

The first 3 patches add generic volatile range management code, as 
well as tmpfs support for FALLOC_FL_MARK_VOLATILE, which uses a
shrinker to purge ranges, and converts ashmem to use
FALLOC_FL_MARK_VOLATILE, almost reducing the driver in half.

Since Kosaki-san objected to using the shrinker, as its not numa aware,
and is only called after we shrink normal lru lists. The second half of
this patch set provides a different method that is not shrinker based.
In this method we deactivate the pages in the volatile range, and then
when writepage is called on a volatile page, we purge the entire range.
Due to my unfamiliar with the details of the VM, this second part is
less likely to be 100% correct or ideal, but seems to work properly in
my testing.

Since last sending this out, I was able to do some further performance
analysis on the extra costs of deactivating all of the pages in the
range when marking a range volatile, and the overhead is significant.
Hopefully folks have some suggestions on how to maybe reduce this.

Given that the shrinker approach is much faster, I've been also
looking at other alternatives: One idea I believe suggested by 
Minchan (although I may have misunderstood) was to provide a
separate list to purge volatile ranges before we do the lru
shrinking. So I've considered adding a "early_shrinker" list,
which callbacks can be registered against and these shrinkers are
called prior to lru shrinking. They still would be numa-unaware,
but would still allow for volatile ranges to be zapped before
we swap anything out. I realize this isn't what Minchan recently
proposed (basically adding a new per-zone ERECLAIM LRU list), but
my worry with the ERECLAIM list idea is we still have to touch the
pages individually when marking them volatile. If folks are curious
about this approach, I can post it as well, but I wanted to try to
get further review on my current approach before jumping off onto
another tangent.


What's new in this iteration:
* At Michel Lespinasse's and Dmitry Adamushko's earlier suggestion
  I dropped the generic interval tree implementation to use the
  prio_tree code which seems to function fine for my needs.
* I added some pagevec batching in the activating/deactivating
  paths which helped improve performance of non-shrinker method,
  but there's still a ways to go.
* Minor cleanups.


Thanks again for the feedback so far!

thanks
-john

(Also, given the number of revisions this patchset, and previous
attempts, have been through the CC list is getting crazy long,
so feel free to ping me privately and I'll drop you if you're
really not wanting to be flooded every week or so with these
patches as I iterate)

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Android Kernel Team <kernel-team@android.com>
CC: Robert Love <rlove@google.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Hugh Dickins <hughd@google.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Rik van Riel <riel@redhat.com>
CC: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Dave Chinner <david@fromorbit.com>
CC: Neil Brown <neilb@suse.de>
CC: Andrea Righi <andrea@betterlinux.com>
CC: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
CC: Taras Glek <tgek@mozilla.com>
CC: Mike Hommey <mh@glandium.org>
CC: Jan Kara <jack@suse.cz>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: Michel Lespinasse <walken@google.com>
CC: Minchan Kim <minchan@kernel.org>
CC: linux-mm@kvack.org <linux-mm@kvack.org>



John Stultz (5):
  [RFC] Add volatile range management code
  [RFC] tmpfs: Add FALLOC_FL_MARK_VOLATILE/UNMARK_VOLATILE handlers
  [RFC] ashmem: Convert ashmem to use volatile ranges
  [RFC][HACK] tmpfs: Purge volatile ranges on writepage instead of
    using shrinker
  [RFC][HACK] mm: Change memory management of anonymous pages on
    swapless systems

 drivers/staging/android/ashmem.c |  331 +--------------------------
 fs/open.c                        |    3 +-
 include/linux/falloc.h           |    7 +-
 include/linux/pagevec.h          |    5 +-
 include/linux/swap.h             |   23 +-
 include/linux/volatile.h         |   40 ++++
 mm/Makefile                      |    2 +-
 mm/shmem.c                       |  123 +++++++++-
 mm/swap.c                        |   13 +-
 mm/vmscan.c                      |    9 -
 mm/volatile.c                    |  467 ++++++++++++++++++++++++++++++++++++++
 11 files changed, 673 insertions(+), 350 deletions(-)
 create mode 100644 include/linux/volatile.h
 create mode 100644 mm/volatile.c

-- 
1.7.9.5

