Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454Ab2DGAJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 20:09:21 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50912 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758435Ab2DGAJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 20:09:16 -0400
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
Subject: [PATCH 0/2] [RFC] Volatile Ranges (v6)
Date: Fri,  6 Apr 2012 17:08:56 -0700
Message-Id: <1333757338-6854-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040700-1976-0000-0000-00000C239F5F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just wanted to send out another iteration of the volatile range code
for review and comment. 

This revision handles some improved coalescing logic, fixes some bugs
in the range tree management, and also utilizes a hash tabe to avoid
bloating the address_space structure with range_tree pointers.

Still looking for guidence on what a better interface for this might be
as well as thoughts on how to best drop the ranges under memory pressure
(vmtruncate_region is pretty close to what I want, but lockdep makes it
clear that its not really safe to call from a shrinker).

Another detail is that by hanging the volatile ranges off of the
address_space, the volatility for tmpfs files persists even when no one
has an open fd on the file. This could cause some surprises if application
A marked some pages volatile and died, then application B opened the file
and had pages dropped out underneith it while it was being used. I suspect
I need to clean up the volatility when all fds are dropped. But any extra
insight would be useful here.


Thanks for the continued advice and feedback!
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

 fs/inode.c                |    2 +
 include/linux/fadvise.h   |    5 +
 include/linux/rangetree.h |   56 ++++++
 include/linux/volatile.h  |   14 ++
 lib/Makefile              |    2 +-
 lib/rangetree.c           |  128 +++++++++++++
 mm/Makefile               |    2 +-
 mm/fadvise.c              |   16 ++-
 mm/volatile.c             |  440 +++++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 662 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/rangetree.h
 create mode 100644 include/linux/volatile.h
 create mode 100644 lib/rangetree.c
 create mode 100644 mm/volatile.c

-- 
1.7.3.2.146.gca209

