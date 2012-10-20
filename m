Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab2JTOgO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 10:36:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674Ab2JTOdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 10:33:42 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 00/11] perf tool: Add PERF_SAMPLE_READ sample read support
Date: Sat, 20 Oct 2012 16:33:08 +0200
Message-Id: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding support to read sample values through the PERF_SAMPLE_READ
sample type. It's now possible to specify 'S' modifier for an event
and get its sample value by PERF_SAMPLE_READ.

For group the 'S' modifier will enable sampling only for the leader
and read all the group member by PERF_SAMPLE_READ smple type with
PERF_FORMAT_GROUP read format.

This patchset is based on group report patches by Namhyung Kim:
http://lwn.net/Articles/518569/

Example:
(making sample on cycles, reading both cycles and cache-misses
 by PERF_SAMPLE_READ/PERF_FORMAT_GROUP)

  # ./perf record -e '{cycles,cache-misses}:S' ls
  ...

  # ./perf report --group --show-total-period --stdio
  # ========
  # captured on: Sat Oct 20 16:53:39 2012
  ...
  # group: {cycles,cache-misses}
  # ========
  #
  # Samples: 86  of event 'anon group { cycles, cache-misses }'
  # Event count (approx.): 34863674
  #
  #         Overhead                    Period  Command      Shared Object                            Symbol
  # ................  ........................  .......  .................  ................................
  #
      16.56%  19.47%       5773450         475       ls  [kernel.kallsyms]  [k] native_sched_clock          
      10.87%   0.74%       3789088          18       ls  [kernel.kallsyms]  [k] rtl8169_interrupt           
       9.82%  15.86%       3423364         387       ls  [kernel.kallsyms]  [k] mark_lock                   
       8.43%  17.75%       2938384         433       ls  ld-2.14.90.so      [.] do_lookup_x                 
       6.79%  20.86%       2365622         509       ls  ls                 [.] calculate_columns           
       6.36%   0.61%       2216808          15       ls  [kernel.kallsyms]  [k] lock_release                
  ...


Attached patches:
  01/11 perf: Add PERF_EVENT_IOC_ID ioctl to return event ID
  02/11 perf: Do not get values from disabled counters in group format read
  03/11 perf tool: Use PERF_EVENT_IOC_ID perf ioctl to read event id
  04/11 perf tool: Add support for parsing PERF_SAMPLE_READ sample type
  05/11 perf tool: Fix event ID retrieval for group format read case
  06/11 perf tool: Add perf_evlist__id2sid function to get event ID related data
  07/11 perf tool: Add PERF_SAMPLE_READ sample related processing
  08/11 perf tool: Add 'S' event/group modifier to read sample value
  09/11 perf test: Add parse events tests for leader sampling
  10/11 perf tool: Display period values for all group members
  11/11 perf record: Fix mmap error output condition


wbr,
jirka

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 include/linux/perf_event.h             |   1 +
 kernel/events/core.c                   |  27 ++++++++++++++++++---
 tools/perf/Documentation/perf-list.txt |   1 +
 tools/perf/builtin-record.c            |   3 ++-
 tools/perf/ui/hist.c                   |  46 +++++++++++++++++++++++++++++++----
 tools/perf/util/event.h                |  18 ++++++++++++++
 tools/perf/util/evlist.c               |  82 ++++++++++++++++++++++++++++++++++++++++++++++++++------------
 tools/perf/util/evlist.h               |   4 ++++
 tools/perf/util/evsel.c                |  54 +++++++++++++++++++++++++++++++++++++++--
 tools/perf/util/evsel.h                |   4 ++++
 tools/perf/util/parse-events-test.c    | 117 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/parse-events.c         |   6 +++++
 tools/perf/util/parse-events.l         |   2 +-
 tools/perf/util/session.c              | 110 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 14 files changed, 448 insertions(+), 27 deletions(-)
