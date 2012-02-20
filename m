Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab2BTB31 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 20:29:27 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:58391 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab2BTB30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 20:29:26 -0500
X-AuditID: 9c93016f-b7c04ae000000eac-e9-4f41a1f2797b
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 1/2] perf evlist: Return first evsel for non-sample event on old kernel
Date: Mon, 20 Feb 2012 10:47:26 +0900
Message-Id: <1329702447-25045-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
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
index 5c61dc57d7c7..f8da9fada002 100644
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
1.7.9

