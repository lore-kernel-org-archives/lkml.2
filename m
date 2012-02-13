Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab2BMH1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 02:27:54 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61926 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2BMH1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 02:27:53 -0500
X-AuditID: 9c930197-b7cdbae000001518-ff-4f38bb773616
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCHSET] perf: Fix cpu/thread map and group event handling
Date: Mon, 13 Feb 2012 16:44:08 +0900
Message-Id: <1329119048-9615-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329118064-9412-2-git-send-email-namhyung.kim@lge.com>
References: <1329118064-9412-2-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend as it was not sent to LKML due to my cccmd problem.

=====================
Hello,

When I was playing with event group, I found a bug that didn't count
such events properly. After looking at the code, it seemed there were
few more bugs, so I decided to refactor the code during fixing them.

The first one I found was that 'perf stat --group' doesn't count any
event but the first. It was a bug on setting attr->disabled and
attr->enable_on_exec to a member of a group event. And it was related
to the code which decides the target task/cpu that those events are
attached to. They did same things, but were separated to each file.

To clean it up, I've made a new struct and used it for record, stat,
top and test. During the cleanup I found some combinations of PID/TID,
UID and CPU weren't allowed and had implicit behaviors. For example,
'perf record -- sleep 1' will create multiple events as much as number
of online cpus on the system. I don't think it's intended. So they
should be fixed and warned to user explicitly, if needed.

I think we have following prorities and implications:

 * If -p option is given, -t option should be ignored.
 * If -p or -t option is given, -u, -C and/or -a options should be ignored.
 * If -u option is given, -C and/or -a option should be ignored.

And if only -C option is given, it should be treated as a system-wide
mode. Also if *NO* option is given (i.e. fork a child for command line
argument), it should be treated as a task mode, not a system-wide mode.

These patches are based on latest tip/perf/core: f8d98f109521 ("x86:
Fix to decode grouped AVX with VEX pp bits").

Any comments are welcome.
Thanks.

Namhyung Kim (11):
  perf tools: Introduce struct perf_maps_opts
  perf stat: Convert to perf_maps_opts
  perf top: Convert to perf_maps_opts
  perf tools: Introduce check_target_maps() helper
  perf tools: Make perf_evlist__create_maps() take struct perf_maps_opts
  perf tools: Check more combinations of PID/TID, UID and CPU switches
  perf tools: Fix creation of cpu map
  perf tools: Consolidate target task/cpu checking
  perf stat: Use perf_evlist__create_maps
  perf stat: Fix event grouping on forked task
  perf record: Fix event grouping on forked task

 tools/perf/builtin-record.c |   42 ++++++++++++++----------------
 tools/perf/builtin-stat.c   |   56 ++++++++++++++++------------------------
 tools/perf/builtin-test.c   |   12 +++++---
 tools/perf/builtin-top.c    |   41 ++++++++++++-----------------
 tools/perf/perf.h           |   11 ++++++--
 tools/perf/util/evlist.c    |   20 ++++++++------
 tools/perf/util/evlist.h    |    7 +++--
 tools/perf/util/evsel.c     |   11 ++++---
 tools/perf/util/evsel.h     |    3 +-
 tools/perf/util/top.c       |   15 ++++++-----
 tools/perf/util/top.h       |    4 +--
 tools/perf/util/usage.c     |   59 +++++++++++++++++++++++++++++++++++++------
 tools/perf/util/util.h      |    7 ++++-
 13 files changed, 163 insertions(+), 125 deletions(-)

-- 
1.7.9

