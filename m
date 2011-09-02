Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab1IBTmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 15:42:01 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47917 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab1IBTl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 15:41:58 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com, paulus@samba.org,
        tglx@linutronix.de, anton@samba.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf tool: fix endianness handling of u32 data in samples
Date: Fri,  2 Sep 2011 13:41:51 -0600
Message-Id: <1314992511-1235-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, analyzing PPC data files on x86 the cpu field is always 0 and
the tid and pid are backwards. For example, analyzing a PPC file on PPC
the pid/tid fields show:
        rsyslogd  1210/1212

and analyzing the same PPC file using an x86 perf binary shows:
        rsyslogd  1212/1210

The problem is that the swap_op method for samples is
perf_event__all64_swap which assumes all elements in the sample_data
struct are u64s. cpu, tid and pid are u32s and need to be handled
individually. Given that the swap is done before the sample is parsed,
the simplest solution is to undo the 64-bit swap of those elements when
the sample is parsed and do the proper swap.

The RAW data field is generic and perf cannot have programmatic knowledge
of how to treat that data. Instead a warning is given to the user.

Thanks to Anton Blanchard for providing a data file for a mult-CPU
PPC system so I could verify the fix for the CPU fields.

v2 -> v3:
- used WARN_ONCE for message regarding raw data
- removed struct wrapper around union
- fixed whitespace issues

v1 -> v2:
- added a union for undoing the byte-swap on u64 and redoing swap on
  u32's to address compiler errors (see git commit 65014ab3)

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-test.c |    2 +-
 tools/perf/util/event.h   |    2 +-
 tools/perf/util/evsel.c   |   55 ++++++++++++++++++++++++++++++++++++---------
 tools/perf/util/session.h |    3 +-
 4 files changed, 48 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 55f4c76..efe696f 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -561,7 +561,7 @@ static int test__basic_mmap(void)
 		}
 
 		err = perf_event__parse_sample(event, attr.sample_type, sample_size,
-					       false, &sample);
+					       false, &sample, false);
 		if (err) {
 			pr_err("Can't parse sample, err = %d\n", err);
 			goto out_munmap;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 1d7f664..357a85b 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -186,6 +186,6 @@ const char *perf_event__name(unsigned int id);
 
 int perf_event__parse_sample(const union perf_event *event, u64 type,
 			     int sample_size, bool sample_id_all,
-			     struct perf_sample *sample);
+			     struct perf_sample *sample, bool swapped);
 
 #endif /* __PERF_RECORD_H */
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index a03a36b..bbc39bd 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -7,6 +7,8 @@
  * Released under the GPL v2. (and only v2, not any later version)
  */
 
+#include <byteswap.h>
+#include "asm/bug.h"
 #include "evsel.h"
 #include "evlist.h"
 #include "util.h"
@@ -342,10 +344,20 @@ static bool sample_overlap(const union perf_event *event,
 
 int perf_event__parse_sample(const union perf_event *event, u64 type,
 			     int sample_size, bool sample_id_all,
-			     struct perf_sample *data)
+			     struct perf_sample *data, bool swapped)
 {
 	const u64 *array;
 
+	/*
+	 * used for cross-endian analysis. See git commit 65014ab3
+	 * for why this goofiness is needed.
+	 */
+	union {
+		u64 val64;
+		u32 val32[2];
+	} u;
+
+
 	data->cpu = data->pid = data->tid = -1;
 	data->stream_id = data->id = data->time = -1ULL;
 
@@ -366,9 +378,16 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 	}
 
 	if (type & PERF_SAMPLE_TID) {
-		u32 *p = (u32 *)array;
-		data->pid = p[0];
-		data->tid = p[1];
+		u.val64 = *array;
+		if (swapped) {
+			/* undo swap of u64, then swap on individual u32s */
+			u.val64 = bswap_64(u.val64);
+			u.val32[0] = bswap_32(u.val32[0]);
+			u.val32[1] = bswap_32(u.val32[1]);
+		}
+
+		data->pid = u.val32[0];
+		data->tid = u.val32[1];
 		array++;
 	}
 
@@ -395,8 +414,15 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 	}
 
 	if (type & PERF_SAMPLE_CPU) {
-		u32 *p = (u32 *)array;
-		data->cpu = *p;
+
+		u.val64 = *array;
+		if (swapped) {
+			/* undo swap of u64, then swap on individual u32s */
+			u.val64 = bswap_64(u.val64);
+			u.val32[0] = bswap_32(u.val32[0]);
+		}
+
+		data->cpu = u.val32[0];
 		array++;
 	}
 
@@ -423,18 +449,25 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 	}
 
 	if (type & PERF_SAMPLE_RAW) {
-		u32 *p = (u32 *)array;
+		u.val64 = *array;
+		if (swapped) {
+			/* undo swap of u64, then swap on individual u32s */
+			u.val64 = bswap_64(u.val64);
+			u.val32[0] = bswap_32(u.val32[0]);
+			u.val32[1] = bswap_32(u.val32[1]);
+
+			WARN_ONCE(swapped, "Endianness of raw data not corrected!\n");
+		}
 
 		if (sample_overlap(event, array, sizeof(u32)))
 			return -EFAULT;
 
-		data->raw_size = *p;
-		p++;
+		data->raw_size = u.val32[0];
 
-		if (sample_overlap(event, p, data->raw_size))
+		if (sample_overlap(event, &u.val32[1], data->raw_size))
 			return -EFAULT;
 
-		data->raw_data = p;
+		data->raw_data = &u.val32[1];
 	}
 
 	return 0;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 170601e..974d0cb 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -162,7 +162,8 @@ static inline int perf_session__parse_sample(struct perf_session *session,
 {
 	return perf_event__parse_sample(event, session->sample_type,
 					session->sample_size,
-					session->sample_id_all, sample);
+					session->sample_id_all, sample,
+					session->header.needs_swap);
 }
 
 struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
-- 
1.7.6

