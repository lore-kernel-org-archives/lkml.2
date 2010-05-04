Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab0EDOAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 10:00:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59012 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186Ab0EDOA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 10:00:29 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Eric B Munson <ebmunson@us.ibm.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/3] perf: Fix performance issue with perf report
Date: Tue,  4 May 2010 11:00:07 -0300
Message-Id: <1272981607-28723-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1272981607-28723-1-git-send-email-acme@infradead.org>
References: <1272981607-28723-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

On a large machine we spend a lot of time in perf_header__find_attr when
running perf report.

If we are parsing a file without PERF_SAMPLE_ID then for each sample we call
perf_header__find_attr and loop through all counter IDs, never finding a match.
As the machine gets larger there are more per cpu counters and we spend an
awful lot of time in there.

The patch below initialises each sample id to -1ULL and checks for this in
perf_header__find_attr. We may need to do something more intelligent eventually
(eg a hash lookup from counter id to attr) but this at least fixes the most
common usage of perf report.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Eric B Munson <ebmunson@us.ibm.com>
Acked-by: Eric B Munson <ebmunson@us.ibm.com>
LKML-Reference: <20100504111915.GB14636@kryten>
Signed-off-by: Anton Blanchard <anton@samba.org>
--
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c  |    1 +
 tools/perf/util/header.c |    8 ++++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 1757b0f..2477270 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -713,6 +713,7 @@ int event__parse_sample(event_t *event, u64 type, struct sample_data *data)
 		array++;
 	}
 
+	data->id = -1ULL;
 	if (type & PERF_SAMPLE_ID) {
 		data->id = *array;
 		array++;
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 2b9f898..8847bec 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -922,6 +922,14 @@ perf_header__find_attr(u64 id, struct perf_header *header)
 {
 	int i;
 
+	/*
+	 * We set id to -1 if the data file doesn't contain sample
+	 * ids. Check for this and avoid walking through the entire
+	 * list of ids which may be large.
+	 */
+	if (id == -1ULL)
+		return NULL;
+
 	for (i = 0; i < header->attrs; i++) {
 		struct perf_header_attr *attr = header->attr[i];
 		int j;
-- 
1.6.2.5

