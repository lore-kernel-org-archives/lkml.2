Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760620Ab2FHMVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 08:21:21 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46322 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092Ab2FHMVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 08:21:19 -0400
From: Dmitry Antipov <dmitry.antipov@linaro.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Dmitry Antipov <dmitry.antipov@linaro.org>
Subject: [PATCH] perf report: fix event name reporting
Date: Fri,  8 Jun 2012 16:23:27 +0400
Message-Id: <1339158207-20575-1-git-send-email-dmitry.antipov@linaro.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use trace_find_event to find event name before looking through
/sys files. This helps 'perf report' to show real event names
instead of 'unknown:unknown' when processing perf.data recorded
on another machine.

Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>
---
 tools/perf/builtin-report.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8c767c6..a6fd309 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -24,6 +24,7 @@
 #include "util/evlist.h"
 #include "util/evsel.h"
 #include "util/header.h"
+#include "util/trace-event.h"
 #include "util/session.h"
 #include "util/tool.h"
 
@@ -314,7 +315,8 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
 
 	list_for_each_entry(pos, &evlist->entries, node) {
 		struct hists *hists = &pos->hists;
-		const char *evname = event_name(pos);
+		struct event_format *event = trace_find_event(pos->attr.config);
+		const char *evname = event ? event->name : event_name(pos);
 
 		hists__fprintf_nr_sample_events(hists, evname, stdout);
 		hists__fprintf(hists, NULL, false, true, 0, 0, stdout);
-- 
1.7.7.6

