Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab2EGFKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 01:10:32 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64230 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab2EGFKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 01:10:30 -0400
X-AuditID: 9c930197-b7badae000000cfd-aa-4fa75942385b
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/7] perf tools: Fix cpu/thread map handling v3
Date: Mon,  7 May 2012 14:08:57 +0900
Message-Id: <1336367344-28071-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Arnaldo

This is my third iteration on the series and some patches in the previous set
got merged to your tree. You can see the discussion on the previous spin at
links below: [1], [2]

The current behaviour of perf tools dealing with PID/TID, UID and CPU has
some implications and I think there're a few bugs - For example,
'perf record sleep 1' will create multiple events as many as number of online
cpus on the system. I don't think it's intended. This indeed makes perf test
fails on validation of PERF_RECORD_* event and perf_sample fields on my 6-core
(12-thread) system like this:

  namhyung@sejong:perf$ ./perf test -v 7
   7: Validate PERF_RECORD_* events & perf_sample fields:
  --- start ---
  perf_evlist__mmap: Operation not permitted
  ---- end ----
  Validate PERF_RECORD_* events & perf_sample fields: FAILED!

It's because perf_evlist__create_maps() created 12 cpu maps when no target PID,
TID, UID and CPU list is given (it's same as 'perf record sleep 1'), and then
perf_evlist__mmap() tried to mmap 256 pages for each cpu map so it hit a mlock
limit for a process. After this patch set was applied, the problem was gone.

During the cleanup I found some combinations of PID/TID, UID and CPU are not
allowed and have some implications. They need to be fixed and warned to user
explicitly IMHO, if needed. I think we have following implicit rules:

 * If -p option is given, -t option would be ignored.
 * If -p or -t option is given, -u, -C and/or -a options would be ignored.
 * If -u option is given (w/o -p or -t), -C and/or -a options would be ignored.

A subtle case is when -C option is given without -a option. I think it should
be treated as a system-wide mode as if -a option is given. Also if *NO* option
is given (like above examples) it should be treated as a task mode, not a
system-wide mode.

To make libperf more generic library, perf_target code use its own error code
and perf_target__strerror() as Arnaldo suggested. Once it's settled down,
perf_evlist__create_maps() and its related functions can be converted to use
perf_target_errno incrementally IMHO.

This series is based on latest acme/perf/core: 9389a46043c8 ("perf session:
Fail on processing event with unknown size").

 * Changes from v2
  - perf target errno uses negative number not to clash with standard errno.
    (thanks to Arnaldo)
  - Make return value of success 0.
  - Fix perf top not to break with this change.
  - Add Reviewed-by's from David Ahern.

 * Changes from v1
  - Drop group handling patches since it's mainlined independently.
  - Rename 'struct perf_maps_ops' to 'struct perf_target' as Arnaldo suggested.
  - Introduce perf_target_strerror() for better error handling as Arnaldo
    suggested.
  - Add perf_target__parse_uid() function to replace parse_target_uid().
  - Not break python/twatch.py any more :).

Any comments are welcome, thanks.
Namhyung

[1] https://lkml.org/lkml/2012/2/13/57
[2] https://lkml.org/lkml/2012/4/26/6


Namhyung Kim (7):
  perf top: Defaults to system_wide target
  perf evlist: Fix creation of cpu map
  perf target: Introduce perf_target_errno
  perf target: Introduce perf_target__parse_uid()
  perf tools: Introduce perf_target__strerror()
  perf target: Consolidate target task/cpu checking
  perf stat: Use perf_evlist__create_maps

 tools/perf/builtin-record.c |   24 ++++++---
 tools/perf/builtin-stat.c   |   34 +++++--------
 tools/perf/builtin-top.c    |   25 +++++++--
 tools/perf/util/debug.c     |    1 +
 tools/perf/util/evlist.c    |    9 ++--
 tools/perf/util/evsel.c     |    8 +--
 tools/perf/util/target.c    |  119 +++++++++++++++++++++++++++++++++++++++----
 tools/perf/util/target.h    |   48 ++++++++++++++++-
 tools/perf/util/usage.c     |   31 -----------
 tools/perf/util/util.h      |    3 --
 10 files changed, 215 insertions(+), 87 deletions(-)

-- 
1.7.10.1

