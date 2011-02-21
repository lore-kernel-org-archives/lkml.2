Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab1BUVCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 16:02:37 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:56272 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab1BUVCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 16:02:35 -0500
X-IronPort-AV: E=Sophos;i="4.62,202,1297036800"; 
   d="scan'208";a="663558089"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <daahern@cisco.com>
Subject: [PATCH 0/4] perf events: Add realtime clock event and timehist option -v2
Date: Mon, 21 Feb 2011 14:02:26 -0700
Message-Id: <1298322150-15505-1-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1 -> v2:
- removed change to WARN_ON_ONCE in perf_event.c
- fixed init of realtime_clock event (needed call to perf_swevent_init_hrtimer)
- changed userspace event name to clock-realtime with the alias clkr as the 
  raw events code sucks up all options that start with 'r' followed by a hex
  character
- remove RAW sample hack for pushing realtime clock event data to userspace
- plumbed PERF_SAMPLE_READ to enable retrieving event data during sample
  generation
- add patch to perf-stat to recognize realtime-clock as a nsec counter
- implementation of tiemhist in perf-record was revamped significantly
  -- to use event data,
  -- to better handle fallback to synthesized event,
  -- added feature to force a sample to be generated at startup (to output
     wall-clock times we need a sample immediately; after that realtime-clock
     samples are generated periodically)
  -- change counter creation to be done only on first cpu; we do not need a
     counter for each cpu 

A request was made to modify perf-trace and perf-script. From what I can see
perf-trace does not exist yet and perf-script requires raw data which means
it does not work for the primary use case that motivated this feature
(perf record -e cs -1 -ag).


CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Paul Mackerras <paulus@samba.org>
CC: Thomas Gleixner <tglx@linutronix.de>

David Ahern (4):
  perf events: Introduce realtime clock event
  perf events: plumbing for PERF_SAMPLE_READ and read_format
  perf events: add timehist option to record and report
  perf stat: treat realtime-clock as nsec counter

 include/linux/perf_event.h               |    2 +
 kernel/perf_event.c                      |   85 ++++++++++++
 tools/perf/Documentation/perf-record.txt |    4 +
 tools/perf/Documentation/perf-report.txt |    6 +
 tools/perf/builtin-record.c              |  113 ++++++++++++++++-
 tools/perf/builtin-report.c              |  208 +++++++++++++++++++++++++++++-
 tools/perf/builtin-stat.c                |    5 +-
 tools/perf/builtin-test.c                |    3 +-
 tools/perf/util/event.c                  |    1 +
 tools/perf/util/event.h                  |   18 +++-
 tools/perf/util/evlist.c                 |    2 +-
 tools/perf/util/evlist.h                 |    2 +
 tools/perf/util/evsel.c                  |   24 +++-
 tools/perf/util/header.c                 |   18 +++
 tools/perf/util/header.h                 |    1 +
 tools/perf/util/parse-events.c           |    2 +
 tools/perf/util/python.c                 |    3 +-
 tools/perf/util/session.c                |   16 +++
 tools/perf/util/session.h                |    9 +-
 19 files changed, 507 insertions(+), 15 deletions(-)

-- 
1.7.3.4

