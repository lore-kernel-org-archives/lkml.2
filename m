Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab1H2Vzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 17:55:33 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36971 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab1H2Vzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 17:55:32 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com, paulus@samba.org,
        tglx@linutronix.de, anton@samba.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf tool: fix endianness handling of u32 data in samples
Date: Mon, 29 Aug 2011 15:55:24 -0600
Message-Id: <1314654924-13071-1-git-send-email-dsahern@gmail.com>
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

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-test.c |    2 +-
 tools/perf/util/event.h   |    2 +-
 tools/perf/util/evsel.c   |   43 +++++++++++++++++++++++++++++++++++++------
 tools/perf/util/session.h |    3 ++-
 4 files changed, 41 insertions(+), 9 deletions(-)

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
index a03a36b..1c8ecd1 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -7,6 +7,7 @@
  * Released under the GPL v2. (and only v2, not any later version)
  */
 
+#include <byteswap.h>
 #include "evsel.h"
 #include "evlist.h"
 #include "util.h"
@@ -342,7 +343,7 @@ static bool sample_overlap(const union perf_event *event,
 
 int perf_event__parse_sample(const union perf_event *event, u64 type,
 			     int sample_size, bool sample_id_all,
-			     struct perf_sample *data)
+			     struct perf_sample *data, bool swapped)
 {
 	const u64 *array;
 
@@ -366,7 +367,15 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 	}
 
 	if (type & PERF_SAMPLE_TID) {
-		u32 *p = (u32 *)array;
+		u64 a = *array;
+		u32 *p = (u32 *)&a;
+
+		if (swapped) {
+			a = bswap_64(a);
+			p[0] = bswap_32(p[0]);
+			p[1] = bswap_32(p[1]);
+		}
+
 		data->pid = p[0];
 		data->tid = p[1];
 		array++;
@@ -395,8 +404,16 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 	}
 
 	if (type & PERF_SAMPLE_CPU) {
-		u32 *p = (u32 *)array;
-		data->cpu = *p;
+		u64 a = *array;
+		u32 *p = (u32 *)&a, cpu;
+
+		if (swapped) {
+			a = bswap_64(a);
+			cpu = bswap_32(*p);
+		} else
+			cpu = *p;
+
+		data->cpu = cpu;
 		array++;
 	}
 
@@ -423,12 +440,26 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 	}
 
 	if (type & PERF_SAMPLE_RAW) {
-		u32 *p = (u32 *)array;
+		u64 a = *array;
+		u32 *p = (u32 *)&a;
+
+		if (swapped) {
+			static bool show_warn = true;
+
+			a = bswap_64(a);
+			p[0] = bswap_32(p[0]);
+			p[1] = bswap_32(p[1]);
+
+			if (show_warn) {
+				pr_warning("Endianness of raw data not corrected!\n");
+				show_warn = false;
+			}
+		}
 
 		if (sample_overlap(event, array, sizeof(u32)))
 			return -EFAULT;
 
-		data->raw_size = *p;
+		data->raw_size = p[0];
 		p++;
 
 		if (sample_overlap(event, p, data->raw_size))
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

