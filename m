Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab2DNBIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 21:08:20 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:40894 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab2DNBIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 21:08:17 -0400
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
Subject: [PATCH 0/2][RFC] Volatile Ranges (v7)
Date: Fri, 13 Apr 2012 18:07:59 -0700
Message-Id: <1334365681-21586-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041401-7282-0000-0000-0000082D1615
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another volatile range patch iteration.

So I think this is starting to shape up, and given the muted response
to the last few iterations, next time I may need to drop the RFC to
scare folks into taking a serious look at this.

This round tries to address the outstanding lockdep issue of calling
vmtruncate_range form a shrinker. My solution here is to call
shmem_truncate_range directly, which results in this functionality
being a tmpfs only feature for now. I know there was some concern
over using a generic fadvise interface for a tmpfs only feature,
and while I'd like this to be more generic, it may really only make
sense for tmpfs files. Also the MADV_REMOVE interface provides
similar effective tmpfs only (well, nilfs2 supports it too) precedent.
Thoughts here about what would be the most appropriate interface
would be appreciated (does madvise make more sense for tmpfs only?).

Also I reworked the code so the volatile ranges won't persist if
all the fds have been closed. I think this avoids possible
surprising effects of volatile pages if they were allowed to
persist across multiple non-concurrent opens.

Finally Dmitry Adamushko pointed out a race and some other minor
fixes that I corrected.

As always, your feedback is greatly appreciated.

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


John Stultz (2):
  [RFC] Range tree implementation
  [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and _NONVOLATILE flags

 fs/file_table.c           |    4 +
 include/linux/fadvise.h   |    5 +
 include/linux/rangetree.h |   56 ++++++
 include/linux/volatile.h  |   12 ++
 lib/Makefile              |    2 +-
 lib/rangetree.c           |  128 +++++++++++++
 mm/Makefile               |    2 +-
 mm/fadvise.c              |   16 ++-
 mm/volatile.c             |  457 +++++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 679 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/rangetree.h
 create mode 100644 include/linux/volatile.h
 create mode 100644 lib/rangetree.c
 create mode 100644 mm/volatile.c

-- 
1.7.3.2.146.gca209

