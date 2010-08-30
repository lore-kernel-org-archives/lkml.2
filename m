Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab0H3MNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 08:13:53 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:39359 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755532Ab0H3MNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 08:13:50 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Robert Richter <robert.richter@amd.com>,
        Lin Ming <ming.m.lin@intel.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [RFC][PATCH 2/5] perf: Turn the group counter values into delta values
Date: Mon, 30 Aug 2010 13:13:44 +0100
Message-Id: <1fe2a061e566c83668312ad64800768046f3ac07.1283123521.git.matt@console-pimps.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1283123521.git.matt@console-pimps.org>
References: <cover.1283123521.git.matt@console-pimps.org>
In-Reply-To: <cover.1283123521.git.matt@console-pimps.org>
References: <cover.1283123521.git.matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the semantics of the PERF_FORMAT_GROUP records and make them
delta values, i.e. the difference in value between consecutive reads of
the hardware counters. These delta values will be used in a subsequent
patch to calculate weighted values (by multiplying the deltas with the
time difference between reads of the counters). Calculating these deltas
is easiest to do in the kernel (as opposed to the userland tools)
because we can reset the counter whenever we read from it.

Note that even though this patch changes the semantics of
PERF_FORMAT_GROUP records there were no users of them anyway (the tools
didn't even understand them).

Signed-off-by: Matt Fleming <matt@console-pimps.org>
---
 kernel/perf_event.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 16b0476..2cda375 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3450,7 +3450,14 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 	if (leader != event)
 		leader->pmu->read(leader);
 
+	/*
+	 * Reset the counter value so that ->count contains a delta from
+	 * the previous value.
+	 */
 	values[n++] = perf_event_count(leader);
+	local64_set(&leader->count, 0);
+	atomic64_set(&leader->child_count, 0);
+
 	if (read_format & PERF_FORMAT_ID)
 		values[n++] = primary_event_id(leader);
 
@@ -3463,6 +3470,9 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 			sub->pmu->read(sub);
 
 		values[n++] = perf_event_count(sub);
+		local64_set(&sub->count, 0);
+		atomic64_set(&sub->child_count, 0);
+
 		if (read_format & PERF_FORMAT_ID)
 			values[n++] = primary_event_id(sub);
 
-- 
1.7.1

