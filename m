Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483Ab2CUEQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 00:16:30 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:46460 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab2CUEQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 00:16:25 -0400
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
Subject: [PATCH 0/2] [RFC] fadivse volatile & range tree (v5)
Date: Tue, 20 Mar 2012 21:15:49 -0700
Message-Id: <1332303351-16372-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032104-7408-0000-0000-000003991434
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just another quick iteration here trying to address some of the comments
made on my last patchset.

I've merged most of the easy fixes and feedback in. Also I've improved
the volatile range coalescing/removing code to avoid re-starting lookups
every time from the root node. We also avoid coalescing with neighboring
ranges that have been purged. Although since we coalesce overlapping
purged ranges, there are still some semantics to work out there (ie:
do we immediately zap the newly volatile range if we coalesce w/ a 
purged range? or break it into smaller un-purged sub-ranges?).

I haven't yet been able to really digest the prio_tree code, that Dmitry
suggested, but it seem like it might be applicable here. One issue there
is that the start,last tuples are longs, so changes there might be
necessary to handle 64bit file ranges. We'll see.

Also, I still want to try implementing DaveC's suggested radix tree
tag method. It would be significantly different from this, so I wanted
to get all the feedback for this "branch" of investigation merged and
published, so I can come back to it if the radix tree tag idea doesn't
pan out.

Thanks again for all the great feedback!
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
 include/linux/rangetree.h |   56 ++++++++
 include/linux/volatile.h  |   14 ++
 lib/Makefile              |    2 +-
 lib/rangetree.c           |  124 ++++++++++++++++
 mm/Makefile               |    2 +-
 mm/fadvise.c              |   16 ++-
 mm/volatile.c             |  342 +++++++++++++++++++++++++++++++++++++++++++++
 10 files changed, 564 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/rangetree.h
 create mode 100644 include/linux/volatile.h
 create mode 100644 lib/rangetree.c
 create mode 100644 mm/volatile.c

-- 
1.7.3.2.146.gca209

