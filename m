Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab2AaBCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 20:02:50 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43412 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab2AaBCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 20:02:49 -0500
X-AuditID: 9c93016f-b7c20ae000005067-48-4f273db61c7f
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] perf tools: Return first evsel for non-sample event on old kernel
Date: Tue, 31 Jan 2012 10:15:15 +0900
Message-Id: <1327972517-5055-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9.rc1.dirty
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On old kernels that don't support sample_id_all feature,
perf_evlist__id2evsel() returns NULL for non-sampling events.
This breaks perf top when multiple events are given on command
line. Fix it by using first evsel in the evlist. This will also
prevent getting the same (potential) problem in such new tool/
old kernel combo.

Suggested-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/util/evlist.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index a6d50e376257..3ffb3203f335 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -349,6 +349,10 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
 	hlist_for_each_entry(sid, pos, head, node)
 		if (sid->id == id)
 			return sid->evsel;
+
+	if (!perf_evlist__sample_id_all(evlist))
+		return list_entry(evlist->entries.next, struct perf_evsel, node);
+
 	return NULL;
 }
 
-- 
1.7.9.rc1.dirty

