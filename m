Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab2LTJL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 04:11:26 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:44926 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab2LTJLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 04:11:18 -0500
From: chenggang <chenggang.qin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: chenggang <chenggang.qin@gmail.com>, David Ahern <dsahern@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chenggang Qin <chenggang.qcg@taobao.com>
Subject: [PATCH 0/5] perf top: Add the function that make the 'perf top -p $pid' can be aware of the new threads.
Date: Thu, 20 Dec 2012 17:04:04 +0800
Message-Id: <1355994245-13537-1-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set add the function that make the 'perf top -p $pid' could be aware
of the dynamic fork threads. The perf top{record} tools are not aware of the new
threads that forked by the target threads, while we use 'perf top{record} -p
$pid' model. Some critical structures, such as, thread_map, mmap, fd, pollfd,
id, are fixed in some arrays at the initialization phase. These structures
cannot be extended easily for the new threads. And, for some performance
reasons, the event inherit mechanism is forbidden in the '-p $pid' model.
So, these structures should be modified to a flexible form at low performance
penalty (especially the CPU utilization). Bitmap is a simple choice. A larger
thread_map->map[] can be allocate at the initialization phase, such as 32. When
the number of new threads is over 32, the size of this array can be extend
doubled by realloc. The bitmap is used to record which position in the map[] is
occupied by a thread, and which position can be used by the next new thread. I
insert a bitmap field in thread_map, and modified other related code in
thread_map.c, xyarray.c, evlist.c, evsel.c etc.
The fork and exit events (PERF_RECORD_FORK & PERF_RECORD_EXIT) can be caught
while we read events from the exist mmaps. Then, we can allocate resources, open
fd, record event id, and make a mmap for the new forked threads without
excessive cost. We can easily release related resources for the exited threads
also.
This function has been already implemented for 'perf top -p $pid' in the patch
[5/5] of this patch set. Next step, the 'perf record -p $pid' should be changed
use the interfaces in evlist & evsel modified by this patch set. Just like the
'perf top'.

Cc: David Ahern <dsahern@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Yanmin Zhang <yanmin.zhang@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>

chenggang (5):
  perf tools: Add some functions to bitops.h to support more bitmap operations.
  perf tools: Add xyarray__realloc function in xyarray.c to expend xyarray.
  perf tools: Add bitmap filed to thread_map to support new threads aware.
  perf tools: Change some interfaces of evlist & evsel to support thread's
	      creation and destroy with thread_map's bitmap.
  perf top: Add the function to make 'perf top -p $pid' could be aware of new
	    forked thread.

 tools/perf/builtin-record.c               |   25 ++-
 tools/perf/builtin-stat.c                 |    7 +-
 tools/perf/builtin-top.c                  |  149 +++++++++++++++++-
 tools/perf/tests/mmap-basic.c             |    4 +-
 tools/perf/tests/open-syscall-all-cpus.c  |    2 +-
 tools/perf/tests/open-syscall-tp-fields.c |    3 +-
 tools/perf/tests/open-syscall.c           |    3 +-
 tools/perf/tests/perf-record.c            |    2 +-
 tools/perf/util/evlist.c                  |  236 +++++++++++++++++++++++------
 tools/perf/util/evlist.h                  |   39 +++--
 tools/perf/util/evsel.c                   |  164 +++++++++++++++++---
 tools/perf/util/evsel.h                   |   38 +++--
 tools/perf/util/include/linux/bitops.h    |   85 +++++++++--
 tools/perf/util/python.c                  |    3 +-
 tools/perf/util/thread_map.c              |  171 +++++++++++----------
 tools/perf/util/thread_map.h              |    8 +
 tools/perf/util/xyarray.c                 |   26 ++++
 tools/perf/util/xyarray.h                 |    2 +
 18 files changed, 755 insertions(+), 212 deletions(-)

-- 
1.7.9.5

