Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab2JTOgM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 10:36:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655Ab2JTOdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 10:33:42 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 02/11] perf: Do not get values from disabled counters in group format read
Date: Sat, 20 Oct 2012 16:33:10 +0200
Message-Id: <1350743599-4805-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's possible some of the counters in the group could be
disabled when sampling member of the event group is reading
the rest via PERF_SAMPLE_READ sample type processing. Disabled
counters could then produce wrong numbers.

Fixing that by reading only enabled counters for PERF_SAMPLE_READ
sample type processing.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 kernel/events/core.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 32aec40..5220d01 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4012,12 +4012,24 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 	__output_copy(handle, values, n * sizeof(u64));
 
 	list_for_each_entry(sub, &leader->sibling_list, group_entry) {
+		u64 value = 0;
 		n = 0;
 
-		if (sub != event)
-			sub->pmu->read(sub);
+		/*
+		 * We are NOT interested in disabled counters,
+		 * giving us strange values and keeping us from
+		 * good night sleep!!!
+		 */
+		if (sub->state > PERF_EVENT_STATE_OFF) {
+
+			if (sub != event)
+				sub->pmu->read(sub);
+
+			value = perf_event_count(sub);
+		}
+
+		values[n++] = value;
 
-		values[n++] = perf_event_count(sub);
 		if (read_format & PERF_FORMAT_ID)
 			values[n++] = primary_event_id(sub);
 
-- 
1.7.11.4

