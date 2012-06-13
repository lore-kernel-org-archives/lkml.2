Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab2FMBMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 21:12:14 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:47409 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab2FMBLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 21:11:15 -0400
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
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: [PATCH 0/6] [RFC] Fallocate Volatile Ranges v4
Date: Tue, 12 Jun 2012 18:10:55 -0700
Message-Id: <1339549862-653-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061301-6148-0000-0000-000006A6A900
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So after sending out the v3 iteration of this patch set, I noticed
that the approach taken there of using writepage to trigger the
volatile range purging would not be functional, as writepage isn't
called on systems without swap.

Given this, for this iteration I've reverted the patch set back to
using a shrinker. I've also included a patch to convert ashmem to
use volatile ranges, which almost cuts the size of the ashmem
driver in half.

Now, I've also gotten feedback from Kosaki-san that the shrinker
interface along with tracking volatile ranges via an lru is a poor
choice, as it is not NUMA aware. I've spent some time trying to
learn more about the VM internals, and I've included two HACK
patches that try to propose a way to address these concerns.

The basic idea is to remove the the volatile range lru management.
Instead leveraging the VM's page lru management, by deactivating
the entire range when marking it volatile. Then in the writepage
code we check if a page is part of a volatile range, and if so
we purge it. This provides LRU-like behavior for purging volatile
ranges (so we purge old volatile ranges before new ones), while
allowing the kernel to free memory first on a numa node that is
under pressure.

Of course, the issue I had w/ the v3 patchset still applies.
We never call shmem_writepage on a system without swap! So to
address this, I've create a quite hackish patch that tries to
manage the anonymous active and inactive lrus slightly differently.

The idea with this is on systems without swap, there's not much use
to keeping inactive and active anonymous lrus separately, since we
can't swap out any of the anonymous memory (at least this is my
assumption, and I may be wrong). So when we don't have swap, keep
all anonymous pages active. Thus, only pages that are deactivated
will be moved to the inactive lru. Then we change shrink_lruvec()
to try to writeout inactive anonymous pages. Of course, writepage
won't write anything out if there's no swap, but it will now
check if the page is volatile and purge it if appropriate.

So... does that sound reasonable or terrible?

Are there other approaches I should be trying?

Maybe the original shrinker approach isn't so bad after all? :)

Many thanks again to Dave Hansen who's been fending off my
numerous questions on irc for the last few days.

thanks
-john


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


John Stultz (6):
  [RFC] Interval tree implementation
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
 include/linux/intervaltree.h     |   55 +++++
 include/linux/pagevec.h          |    5 +-
 include/linux/swap.h             |   23 ++-
 include/linux/volatile.h         |   40 ++++
 lib/Makefile                     |    2 +-
 lib/intervaltree.c               |  119 ++++++++++
 mm/Makefile                      |    2 +-
 mm/shmem.c                       |  102 +++++++++
 mm/swap.c                        |   13 +-
 mm/vmscan.c                      |    9 -
 mm/volatile.c                    |  467 ++++++++++++++++++++++++++++++++++++++
 14 files changed, 828 insertions(+), 350 deletions(-)
 create mode 100644 include/linux/intervaltree.h
 create mode 100644 include/linux/volatile.h
 create mode 100644 lib/intervaltree.c
 create mode 100644 mm/volatile.c

-- 
1.7.3.2.146.gca209

