Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752Ab1JFRWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:22:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:44272 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758413Ab1JFRWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:22:47 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/15] perf tools: Fix broken number of samples for perf report -n
Date: Thu,  6 Oct 2011 14:22:33 -0300
Message-Id: <1317921758-4154-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317921758-4154-1-git-send-email-acme@infradead.org>
References: <1317921758-4154-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

The perf report -n option was broken because it was not reporting the
correct number of samples depending on the sorting mode. By default,
samples are sorted by comm,dso,sym. That means that samples for the same
command (binary) get collapsed.

The hists__collapse_insert_entry() had a bug whereby it was aggregating
the number of events observed (periods) but not the number of samples.
Consequently, the number of samples reported could be below reality. The
percentage remained correct because based on the periods.

This patch fixes the problem by also aggregating the number of samples.
Here is an example:

$ perf report -n --stdio
    12.38%        842     pong  [kernel.kallsyms]     [k] __lock_acquire

Here pong (a ctxsw stress test), is the only program running
and thus it is the only one responsible for the lock_acquire samples.

If we change the sorting mode:

$ perf report -n --stdio --sort=sym
    12.38%       1732  [k] __lock_acquire

The actual number of samples is shown.

With the fix:

$ perf report -n --stdio
    12.38%       1732     pong  [kernel.kallsyms]     [k] __lock_acquire

Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20111003093815.GA6393@quad
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 82138a2..c83e458 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -279,6 +279,7 @@ static bool hists__collapse_insert_entry(struct hists *hists,
 
 		if (!cmp) {
 			iter->period += he->period;
+			iter->nr_events += he->nr_events;
 			if (symbol_conf.use_callchain) {
 				callchain_cursor_reset(&hists->callchain_cursor);
 				callchain_merge(&hists->callchain_cursor, iter->callchain,
-- 
1.6.2.5

