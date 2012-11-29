Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab2K2GjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:39:05 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:42981 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab2K2Gix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:38:53 -0500
X-AuditID: 9c93016f-b7b86ae000003a75-e7-50b702f706d3
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 00/18] perf report: Add support for event group view (v6)
Date: Thu, 29 Nov 2012 15:38:28 +0900
Message-Id: <1354171126-14387-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
References: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is my 6th iteration of event group view patchset.
For basic idea and usage example, please see my original post [1].

The largest change in this version is using 'pairs' list of hist_entry
instead of allocating group_stats for all group members.  But I needed
to allocate temporary arrays for internal purpose anyway.  If you have
a better solution please let me know.

Jiri, sorry for the delay, I had to hunt down some nasty bugs in my
patches.  And I saw you submitted the multiplu diff series which will
conflict my changes.  I'll have a look at it soon, and I'd be glad if
you take a look at my changes too. :)

You can get this series via my tree at:

git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git  perf/group-v6

Any comments are welcome, thanks,
Namhyung


v5 -> v6:
 * set ->leader alse for leader evsel (Arnaldo)
 * use hists__{match,link} (Arnaldo)

v4 -> v5:
 * rebase onto acme/perf/core

v3 -> v4:
 * patch 1-9 in previous post are merged.
 * add Jiri's Acked-by
 * add report.group config option

v2 -> v3:
 * drop patch 1 since it's merged into acme/perf/core
 * cherry-pick Jiri's hpp changes
 * add missing bswap_32 on reading nr_groups (Jiri)
 * remove perf_evlist__recalc_nr_groups() in favor of list_is_last (Jiri)

v1 -> v2:
 * save group relation to header (Jiri)

[1] https://lkml.org/lkml/2012/7/24/81


Namhyung Kim (18):
  perf evsel: Set leader evsel's ->leader to itself
  perf evsel: Convert to _is_group_leader method
  perf tools: Keep group information
  perf header: Add HEADER_GROUP_DESC feature
  perf tools: Fix typo on hist__entry_add_pair
  perf hists: Link hist entry pairs to leader
  perf hists: Exchange order of comparing items when collapsing hists
  perf hists: Add hists__{match,link}_collapsed
  perf symbol: Introduce symbol_conf.event_group
  perf report: Make another loop for linking group hists
  perf hists: Resort hist entries using group members for output
  perf ui/hist: Add support for event group view
  perf hist browser: Add support for event group view
  perf gtk/browser: Add support for event group view
  perf report: Bypass non-leader events when event group is enabled
  perf report: Show group description when event group is enabled
  perf report: Add --group option
  perf report: Add report.group config option

 tools/perf/Documentation/perf-report.txt |   3 +
 tools/perf/builtin-record.c              |   3 +
 tools/perf/builtin-report.c              |  47 +++-
 tools/perf/builtin-stat.c                |   2 +-
 tools/perf/tests/parse-events.c          |  20 +-
 tools/perf/ui/browsers/hists.c           | 237 ++++++++++++++++---
 tools/perf/ui/gtk/browser.c              |  99 ++++++--
 tools/perf/ui/hist.c                     | 375 ++++++++++++++++---------------
 tools/perf/ui/stdio/hist.c               |   2 +
 tools/perf/util/evlist.c                 |  12 +-
 tools/perf/util/evlist.h                 |   1 +
 tools/perf/util/evsel.c                  |  32 ++-
 tools/perf/util/evsel.h                  |  20 +-
 tools/perf/util/header.c                 | 153 +++++++++++++
 tools/perf/util/header.h                 |   2 +
 tools/perf/util/hist.c                   | 182 +++++++++++++--
 tools/perf/util/hist.h                   |   2 +
 tools/perf/util/parse-events.c           |   1 +
 tools/perf/util/parse-events.h           |   1 +
 tools/perf/util/parse-events.y           |  10 +
 tools/perf/util/sort.h                   |   2 +-
 tools/perf/util/symbol.c                 |   4 +
 tools/perf/util/symbol.h                 |   3 +-
 23 files changed, 934 insertions(+), 279 deletions(-)

-- 
1.7.11.7

