Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480Ab2EYTR4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 15:17:56 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:34395 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932656Ab2EYTRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 15:17:55 -0400
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
        Taras Glek <tgek@mozilla.com>, Mike Hommey <mh@glandium.org>
Subject: [PATCH 0/4] [RFC] Fallocate Volatile Ranges
Date: Fri, 25 May 2012 12:17:32 -0700
Message-Id: <1337973456-19533-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052519-6148-0000-0000-000006276E33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So here's the first pass at re-implementing the volatile range
idea using the fallocate interface, as suggested by Dave Chinner.

The range tree code is mostly unchanged.

The volatile range management code has been somewhat abstracted
out as helper functions that allow filesystems to get the same
logic but leaving it to the filesystem to handle the page purging.

Finally there is the tmpfs enablement for FALLOC_FL_MARK_VOLATILE.

This is all done on top of Hugh/Cong's tmpfs FALLOC_FL_PUNCH_HOLE
enablement.

I've only managed to do minimal testing at this point, but I wanted
to get this out before the long-weekend holiday in the US.

Few of the things still on my todo list:
* Move the volatile mapping hash to be per volatile_fs_head
* Kill the extra hash locking
* Keep track of unpurged pages in volatile_fs_head, to avoid
running through the lru at shrink time.

Your thoughts and feedback will be appreciated!

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


Hugh Dickins (1):
  tmpfs: support fallocate FALLOC_FL_PUNCH_HOLE

John Stultz (3):
  [RFC] Range tree implementation
  [RFC] Add volatile range management code
  [RFC] tmpfs: Add FALLOC_FL_MARK_VOLATILE/UNMARK_VOLATILE handlers

 fs/open.c                 |    3 +-
 include/linux/falloc.h    |    7 +-
 include/linux/rangetree.h |   53 +++++
 include/linux/volatile.h  |   43 ++++
 lib/Makefile              |    2 +-
 lib/rangetree.c           |  107 ++++++++++
 mm/Makefile               |    2 +-
 mm/shmem.c                |  175 +++++++++++++++-
 mm/volatile.c             |  493 +++++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 868 insertions(+), 17 deletions(-)
 create mode 100644 include/linux/rangetree.h
 create mode 100644 include/linux/volatile.h
 create mode 100644 lib/rangetree.c
 create mode 100644 mm/volatile.c

-- 
1.7.3.2.146.gca209

