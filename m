Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab2A2I4G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 03:56:06 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59349 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab2A2I4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 03:56:04 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] perf top: Use active evsel for non-sample events on old kernel
Date: Sun, 29 Jan 2012 17:55:52 +0900
Message-Id: <1327827356-8786-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If multiple events are specified on old kernel,
perf_evlist__id2evsel() returns NULL for non-sampling events
since the sample.id doesn't contain valid value, and it triggers
assert below. If only one event is given, the function returns
the evsel regardless of sample.id, this is why most case cause
no problem on old kernel.

Fix it by using active evsel.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/builtin-top.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e8b033c074f9..f68fba52c8d8 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -771,6 +771,14 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
 		}
 
 		evsel = perf_evlist__id2evsel(session->evlist, sample.id);
+		if (evsel == NULL && !session->sample_id_all &&
+		    event->header.type != PERF_RECORD_SAMPLE) {
+			/*
+			 * Old kernel, no sample_id_all field.
+			 * Just use active evsel.
+			 */
+			evsel = top->sym_evsel;
+		}
 		assert(evsel != NULL);
 
 		origin = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-- 
1.7.8.2

