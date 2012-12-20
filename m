Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab2LTPmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 10:42:40 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:50379 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab2LTPm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 10:42:29 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v4 05/18] perf: add minimal support for PERF_SAMPLE_WEIGHT
Date: Thu, 20 Dec 2012 16:41:35 +0100
Message-Id: <1356018108-6081-6-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1356018108-6081-1-git-send-email-eranian@google.com>
References: <1356018108-6081-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure we grab the weight from  raw sample struct
and that we can dump it via perf report -D.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/event.h   |    1 +
 tools/perf/util/evsel.c   |    5 +++++
 tools/perf/util/session.c |    3 +++
 3 files changed, 9 insertions(+)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 0d573ff..cf52977 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -90,6 +90,7 @@ struct perf_sample {
 	u64 period;
 	u32 cpu;
 	u32 raw_size;
+	u64 weight;
 	void *raw_data;
 	struct ip_callchain *callchain;
 	struct branch_stack *branch_stack;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 1b16dd1..4374c07 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1058,6 +1058,11 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 		}
 	}
 
+	if (type & PERF_SAMPLE_WEIGHT) {
+		data->weight= *array;
+		array++;
+	}
+
 	return 0;
 }
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index ce6f511..117983e 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1006,6 +1006,9 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 
 	if (sample_type & PERF_SAMPLE_STACK_USER)
 		stack_user__printf(&sample->user_stack);
+
+	if (sample_type & PERF_SAMPLE_WEIGHT)
+		printf(" ... weight: %"PRIu64"\n", sample->weight);
 }
 
 static struct machine *
-- 
1.7.9.5

