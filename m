Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032435Ab2CPWvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 18:51:35 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38481 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031562Ab2CPWvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 18:51:22 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 0/2] [RFC] Volatile ranges (v4)
Date: Fri, 16 Mar 2012 15:51:05 -0700
Message-Id: <1331938267-13583-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031622-9360-0000-0000-0000049DD83A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok. So here's another iteration of the fadvise volatile range code.

I realize this is still a way off from being ready, but I wanted to post
what I have to share with folks working on the various range/interval
management ideas as well as update folks who've provided feedback on the
volatile range code.

So just on the premise: Ideally, I want delayed reclaim based hole
punching.

Application has a possibly shared mmapped cache file, which it can mark
chunks of which volatile or nonvolatile as it uses it.  If the kernel
needs memory, it can zap any ranges that are currently marked volatile. 

Some examples would be rendering of images or web pages that are not
on-screen. This allows the application to volunteer memory for
reclaiming, and the kernel to grab it only when it needs. This differs
from some of the memory notification schemes, in that it allows the
kernel to immediately reclaim what it needs, rather then having to
request applications to give up memory (which may add further memory
load) until enough is free. However, unlike the notification scheme,
it does require applications to mark and unmark pages as volatile as
they use them.

Current use cases (ie: users of Android's ashmem) only use shmfs/tmpfs.
However, I don't see right off why it should be limited to shm. As long
as punching a hole in a file can be done w/ minimal memory overhead
this could be useful and have somewhat sane behavior. 

We could also only zap the page cache, not writing any dirty data out.
However, w/ non-shm files, discarding dirty data without hole punching
would obviously leave persistent files in a non-coherent state. This
may further re-inforce that the design should be shm only if we don't
do hole punching.

On the topic of hole punching, the kernel doesn't seem completely
unified in this as well. As I understand, there are two methods to do
hole punching: FALLOCATE_FL_PUNCH_HOLE vs MADV_REMOVE, and they don't
necessarily overlap in support. For the most part, it seems persistent
filesystems require FALLOCATE_FL_PUNCH, where as shmfs/tmpfs uses
MADV_REMOVE. But I may be misunderstanding the subtle difference here,
so if anyone wants to clarify this, it would be great.

One concern was that if the design is shm only, fadvise might not be
the right interface, as it should be generic. The
madvise(MADV_REMOVE,...) interface gives some precedence to shmfs/tmpfs
only calls, but I'd like to get some further feedback as to what folks
think of this. If we are shm/tmpfs only, I could rework this design to
use madvise instead of fadvise if folks would prefer.

Also, there's still the issue that lockdep doesn't like me calling
vmtruncate_range from the shrinker due to any allocations being done
while the i_mutex is taken could cause the shrinker to run and need the
i_mutex again.  I did try using invalidate_inode_pages2_range() but it
always returns EBUSY in this context, so I suspect I want something
else. I'm currently reading shmem_truncate_range() and zap_page_range()
to get a better idea of how to this might be best accomplished.

Regarding feedback suggesting dropping the LRU ranges, and instead
keeping the volatile/purged data in radix tags and to manage things at
writeout time. My concern there is having the LRU behavior on the
entire range from when it was marked volatile instead of the actual
last page access (you might have ranges that have frequent use areas
and non-frequent use).  Also sorting out how to evict the entire range
when one page is dropped might be funky.  However, I'll likely revisit
this soon, but for this iteration I didn't get to it.

I still also realize I have the issue of bloating the address_space
structure to handle, and I suspect if I continue w/ this approach
I'll use a separate hash table to store the range-tree roots in my
next revision.

Anyway, thanks for the continued advice and feedback!
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

John Stultz (2):
  [RFC] Range tree implementation
  [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and _NONVOLATILE flags

 fs/inode.c                |    4 +
 include/linux/fadvise.h   |    5 +
 include/linux/fs.h        |    2 +
 include/linux/rangetree.h |   53 ++++++++
 include/linux/volatile.h  |   14 ++
 lib/Makefile              |    2 +-
 lib/rangetree.c           |  105 +++++++++++++++
 mm/Makefile               |    2 +-
 mm/fadvise.c              |   16 ++-
 mm/volatile.c             |  313 +++++++++++++++++++++++++++++++++++++++++++++
 10 files changed, 513 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/rangetree.h
 create mode 100644 include/linux/volatile.h
 create mode 100644 lib/rangetree.c
 create mode 100644 mm/volatile.c

-- 
1.7.3.2.146.gca209

