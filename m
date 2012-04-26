Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab2DZFQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 01:16:23 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50162 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab2DZFQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 01:16:20 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-10-4f98da22b45f
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [RFC PATCHSET 00/13] perf tools: Fix cpu/thread map handling v2
Date: Thu, 26 Apr 2012 14:15:14 +0900
Message-Id: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a second iteration of my previous series [1] but group event handling
part already got mainlined separately.

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
and perf_target__strerror() as Arnaldo suggested. Although I tried to address
all of concerns he raised, I'm not 100% sure this is in the shape he wanted
to see finally. Comments on this area would be appreciated especially :).

Once it's settled down, perf_evlist__create_maps() and its related functions
can be converted to use perf_target_errno incrementally IMHO.

This series is based on latest tip/perf/core: 3dbe927b1edd ("Merge tag
'v3.4-rc4' into perf/core").

 * Changes from v1
  - Drop group handling patches since it's mainlined independently.
  - Rename 'struct perf_maps_ops' to 'struct perf_target' as Arnaldo suggested.
  - Introduce perf_target_strerror() for better error handling as Arnaldo
    suggested.
  - Add perf_target__parse_uid() function to replace parse_target_uid().
  - Not break python/twatch.py any more :).

Any comments are welcome, thanks.
Namhyung

[1] https://lkml.org/lkml/2012/2/13/57 - sorry, it wasn't threaded properly :(


Namhyung Kim (13):
  perf tools: Introduce struct perf_target
  perf stat: Convert to struct perf_target
  perf top: Convert to struct perf_target
  perf tools: Introduce perf_target__validate() helper
  perf tools: Make perf_evlist__create_maps() take struct perf_target
  perf tools: Check more combinations of PID/TID, UID and CPU switches
  perf evlist: Fix creation of cpu map
  perf target: Split out perf_target handling code
  perf target: Introduce perf_target_errno
  perf target: Introduce perf_target__parse_uid()
  perf tools: Introduce perf_target__strerror()
  perf target: Consolidate target task/cpu checking
  perf stat: Use perf_evlist__create_maps

 tools/perf/Makefile         |    2 +
 tools/perf/builtin-record.c |   48 ++++++++-------
 tools/perf/builtin-stat.c   |   58 ++++++++----------
 tools/perf/builtin-test.c   |    6 +-
 tools/perf/builtin-top.c    |   46 +++++++-------
 tools/perf/perf.h           |    8 +--
 tools/perf/util/debug.c     |    1 +
 tools/perf/util/evlist.c    |   16 ++---
 tools/perf/util/evlist.h    |    4 +-
 tools/perf/util/evsel.c     |    9 +--
 tools/perf/util/target.c    |  140 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/target.h    |   58 ++++++++++++++++++
 tools/perf/util/top.c       |   19 +++---
 tools/perf/util/top.h       |    6 +-
 tools/perf/util/usage.c     |   38 ------------
 tools/perf/util/util.h      |    3 -
 16 files changed, 311 insertions(+), 151 deletions(-)
 create mode 100644 tools/perf/util/target.c
 create mode 100644 tools/perf/util/target.h

-- 
1.7.10

