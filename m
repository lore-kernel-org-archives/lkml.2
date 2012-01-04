Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab2ADRYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 12:24:40 -0500
Received: from smtp.nokia.com ([147.243.1.48]:23502 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756540Ab2ADRYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 12:24:34 -0500
From: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: cesarb@cesarb.net, kamezawa.hiroyu@jp.fujitsu.com, emunson@mgebm.net,
        penberg@kernel.org, aarcange@redhat.com, riel@redhat.com,
        mel@csn.ul.ie, rientjes@google.com, dima@android.com, gregkh@suse.de,
        rebecca@android.com, san@google.com, akpm@linux-foundation.org,
        vesa.jaaskelainen@nokia.com
Subject: [PATCH 3.2.0-rc1 0/3] Used Memory Meter pseudo-device and related changes in MM
Date: Wed,  4 Jan 2012 19:21:53 +0200
Message-Id: <cover.1325696593.git.leonid.moiseichuk@nokia.com>
X-Mailer: git-send-email 1.7.7.3
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main idea of Used Memory Meter (UMM) is to provide low-cost interface
for user-space to notify about memory consumption using similar approach /proc/meminfo
does but focusing only on "modified" pages which cannot be fogotten.

The calculation formula in terms of meminfo looks the following:
  UsedMemory = (MemTotal - MemFree - Buffers - Cached - SwapCached) +
                                               (SwapTotal - SwapFree)
It reflects well amount of system memory used in applications in heaps and shared pages.

Previously (n770..n900) we had lowmem.c [1] which used LSM and did a lot other things,
n9 implementation based on memcg [2] which has own problems, so the proposed variant
I hope is the best one for n9:
- Keeps connections from user space
- When amount of modified pages reaches crossed pointed value for particular connection
  makes POLLIN and allow user-space app to read it and react
- Economic as much as possible, so currently its operates if allocation higher than 487
  pages or last check happened 250 ms before
Of course if no allocation happened then no activities performed, use-time
must be not affected.

Testing results:
- Checkpatch produced 0 warning
- Sparse does not produce warnings
- One check costs ~20 us or less (could be checked with probe=1 insmod)
- One connection costs 20 bytes in kernel-space  (see observer structure) for 32-bit variant
- For 10K connections poll update in requested in ~10ms, but for practically device expected
  to will have about 10 connections (like n9 has now).

Known weak points which I do not know how to fix but will if you have a brillian idea:
- Having hook in MM is nasty but MM/shrinker cannot be used there and LSM even worse idea
- If I made 
	$cat /dev/used_memory
  it is produced lines in non-stop mode. Adding position check in umm_read seems doesn not help,
  so "head -1 /dev/used_memory" should be used if you need to quick check
- Format of output is USED_PAGES:AVAILABLE_PAGES, primitive but enough for tasks module does

Tested on ARM, x86-32 and x86-64 with and without CONFIG_SWAP. Seems works in all combinations.
Sorry for wide distributions but list of names were produced by scripts/get_maintainer.pl

References
[1] http://elinux.org/Accurate_Memory_Measurement
[2] http://maemo.gitorious.org/maemo-tools/libmemnotify

Leonid Moiseichuk (3):
  Making si_swapinfo exportable
  MM hook for page allocation and release
  Used Memory Meter pseudo-device module

 drivers/misc/Kconfig  |   12 ++
 drivers/misc/Makefile |    1 +
 drivers/misc/umm.c    |  452 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mm.h    |   15 ++
 include/linux/umm.h   |   42 +++++
 mm/Kconfig            |    8 +
 mm/page_alloc.c       |   31 ++++
 mm/swapfile.c         |    3 +
 8 files changed, 564 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/umm.c
 create mode 100644 include/linux/umm.h

-- 
1.7.7.3

