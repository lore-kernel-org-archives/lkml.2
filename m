Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab2EGL3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 07:29:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756305Ab2EGL3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 07:29:43 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, dsahern@gmail.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 4/5] perf, tool: Fix 32 bit values endianity swap for sample_id_all header
Date: Mon,  7 May 2012 13:29:08 +0200
Message-Id: <1336390149-2970-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1336390149-2970-1-git-send-email-jolsa@redhat.com>
References: <1336390149-2970-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We swap the sample_id_all header by u64 pointers. Some members
of the header happen to be 32 bit values. We need to handle them
separatelly.

Note, running following to test perf endianity handling:
  - origin system:
    # perf record -a -- sleep 10 (any perf record will do)
    # perf report > report.origin
    # perf archive perf.data

  - copy the perf.data, report.origin and perf.data.tar.bz2
    to a target system and run:
    # tar xjvf perf.data.tar.bz2 -C ~/.debug
    # perf report > report.target
    # diff -u report.origin report.target

  - the diff should produce no output
    (besides some white space stuff and possibly different
     date/TZ output)

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/evsel.c |   32 +++++++++++++++++++++++++-------
 1 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 8c13dbc..ea053b7 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -403,16 +403,27 @@ int perf_evsel__open_per_thread(struct perf_evsel *evsel,
 }
 
 static int perf_event__parse_id_sample(const union perf_event *event, u64 type,
-				       struct perf_sample *sample)
+				       struct perf_sample *sample,
+				       bool swapped)
 {
 	const u64 *array = event->sample.array;
+	union {
+		u64 val64;
+		u32 val32[2];
+	} u;
 
 	array += ((event->header.size -
 		   sizeof(event->header)) / sizeof(u64)) - 1;
 
 	if (type & PERF_SAMPLE_CPU) {
-		u32 *p = (u32 *)array;
-		sample->cpu = *p;
+		u.val64 = *array;
+		if (swapped) {
+			/* undo swap of u64, then swap on individual u32s */
+			u.val64 = bswap_64(u.val64);
+			u.val32[0] = bswap_32(u.val32[0]);
+		}
+
+		sample->cpu = u.val32[0];
 		array--;
 	}
 
@@ -432,9 +443,16 @@ static int perf_event__parse_id_sample(const union perf_event *event, u64 type,
 	}
 
 	if (type & PERF_SAMPLE_TID) {
-		u32 *p = (u32 *)array;
-		sample->pid = p[0];
-		sample->tid = p[1];
+		u.val64 = *array;
+		if (swapped) {
+			/* undo swap of u64, then swap on individual u32s */
+			u.val64 = bswap_64(u.val64);
+			u.val32[0] = bswap_32(u.val32[0]);
+			u.val32[1] = bswap_32(u.val32[1]);
+		}
+
+		sample->pid = u.val32[0];
+		sample->tid = u.val32[1];
 	}
 
 	return 0;
@@ -474,7 +492,7 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 	if (event->header.type != PERF_RECORD_SAMPLE) {
 		if (!sample_id_all)
 			return 0;
-		return perf_event__parse_id_sample(event, type, data);
+		return perf_event__parse_id_sample(event, type, data, swapped);
 	}
 
 	array = event->sample.array;
-- 
1.7.7.6

