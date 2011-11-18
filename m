Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab1KRNrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 08:47:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757642Ab1KRNrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 08:47:08 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC,PATCH] perf tool: Refactoring IO data files code
Date: Fri, 18 Nov 2011 14:46:40 +0100
Message-Id: <1321624005-6889-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

based on following discussion:
http://marc.info/?l=linux-kernel&m=131731212425421&w=2
http://marc.info/?l=linux-kernel&m=131736842010972&w=2

I made some changes to have event memory mapping and input/output
data code in one place. The reason was to make the change for
multiple event data files at least possible ;)

This patchset is marked as RFC since it's quite big change
and I expect some better design might come up.

However, patches 1 and 2 are not big deal, since they are
just small (not so related) changes.

Patches 3-4 are the main change of the patchset.

1/5 perf tool: Fix session host_nachine retrieval
2/5 perf tool: Initialize events IDs in a single function
3/5 perf tool: Introducing perf_mmap object
4/5 perf tool: Introducing perf_data object
5/5 perf tool: Putting mmap support to perf_data object

I did some overall testing of all the changed command,
and so far so good. Just hit issue with 'diff' command,
but this one seems not to work even without my changes.

Also the current perf python binsing code is broken
wit missing dependencies so I could not test my
changes there.

thanks for comments,
jirka
---
 tools/perf/Makefile               |    4 +
 tools/perf/builtin-annotate.c     |    3 +-
 tools/perf/builtin-buildid-list.c |    4 +-
 tools/perf/builtin-diff.c         |    6 +-
 tools/perf/builtin-evlist.c       |    3 +-
 tools/perf/builtin-inject.c       |    9 +-
 tools/perf/builtin-kmem.c         |   18 +-
 tools/perf/builtin-lock.c         |    3 +-
 tools/perf/builtin-record.c       |  206 ++++++++-----------------
 tools/perf/builtin-report.c       |    7 +-
 tools/perf/builtin-sched.c        |    6 +-
 tools/perf/builtin-script.c       |    3 +-
 tools/perf/builtin-test.c         |   17 ++-
 tools/perf/builtin-timechart.c    |    7 +-
 tools/perf/builtin-top.c          |   52 ++++---
 tools/perf/perf.h                 |   26 ---
 tools/perf/util/data.c            |  303 +++++++++++++++++++++++++++++++++++++
 tools/perf/util/data.h            |   78 ++++++++++
 tools/perf/util/event.c           |   14 +-
 tools/perf/util/evlist.c          |  268 +++------------------------------
 tools/perf/util/evlist.h          |    8 +-
 tools/perf/util/evsel.h           |    4 +-
 tools/perf/util/header.c          |   35 +++--
 tools/perf/util/header.h          |    6 +-
 tools/perf/util/mmap.c            |  138 +++++++++++++++++
 tools/perf/util/mmap.h            |   48 ++++++
 tools/perf/util/python.c          |   23 ++-
 tools/perf/util/session.c         |  115 +++++---------
 tools/perf/util/session.h         |   38 ++++--
 29 files changed, 855 insertions(+), 597 deletions(-)
