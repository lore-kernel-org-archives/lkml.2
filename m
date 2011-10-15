Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab1JOSgZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 14:36:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42120 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab1JOSgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 14:36:23 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/3] perf tools: Fix leaked account of hist period on collapsing
Date: Sat, 15 Oct 2011 20:36:13 +0200
Message-Id: <1318703773-6846-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1318703773-6846-1-git-send-email-fweisbec@gmail.com>
References: <1318703773-6846-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we collapse the hists, we forget to account the part that
is collapsed into the other. This messes up the stats everytime
we sort by at least by comm.

Fix this by acccounting the collapsed side.

Before:

	perf report -s comm --stdio

	# Events: 26K cycles
	#
	# Overhead  Command
	# ........  .......
	#
	   46388.16%     perf

After:
	perf report -s comm --stdio

	# Events: 26K cycles
	#
	# Overhead  Command
	# ........  .......
	#
	   100.00%     perf

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/hist.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index cef40d8..57d6e78 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -297,6 +297,8 @@ static bool hists__collapse_insert_entry(struct hists *hists,
 
 		if (!cmp) {
 			iter->period += he->period;
+			if (!iter->filtered)
+				hists->stats.total_period += he->period;
 			iter->nr_events += he->nr_events;
 			if (symbol_conf.use_callchain) {
 				callchain_cursor_reset(&hists->callchain_cursor);
-- 
1.7.5.4

