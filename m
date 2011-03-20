Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab1CTSyt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 14:54:49 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:62543 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab1CTSyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 14:54:46 -0400
X-IronPort-AV: E=Sophos;i="4.63,215,1299456000"; 
   d="scan'208";a="349369478"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <daahern@cisco.com>
Subject: [PATCH 2/5] perf events: userspace plumbing for realtime sample attribute
Date: Sun, 20 Mar 2011 12:54:34 -0600
Message-Id: <1300647277-8431-3-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1300647277-8431-1-git-send-email-daahern@cisco.com>
References: <1300647277-8431-1-git-send-email-daahern@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Ahern <daahern@cisco.com>
---
 tools/perf/util/event.c   |    1 +
 tools/perf/util/event.h   |    1 +
 tools/perf/util/evsel.c   |   10 ++++++++++
 tools/perf/util/session.c |    6 ++++++
 4 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 2b15c36..8abd33a 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -39,6 +39,7 @@ static struct perf_sample synth_sample = {
 	.pid	   = -1,
 	.tid	   = -1,
 	.time	   = -1,
+	.realtime  = -1,
 	.stream_id = -1,
 	.cpu	   = -1,
 	.period	   = 1,
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 9c35170..0c8dc11 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -65,6 +65,7 @@ struct perf_sample {
 	u64 ip;
 	u32 pid, tid;
 	u64 time;
+	u64 realtime;
 	u64 addr;
 	u64 id;
 	u64 stream_id;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 662596a..8768ea9 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -286,6 +286,11 @@ static int perf_event__parse_id_sample(const union perf_event *event, u64 type,
 	array += ((event->header.size -
 		   sizeof(event->header)) / sizeof(u64)) - 1;
 
+	if (type & PERF_SAMPLE_REALTIME) {
+		sample->realtime = *array;
+		array--;
+	}
+
 	if (type & PERF_SAMPLE_CPU) {
 		u32 *p = (u32 *)array;
 		sample->cpu = *p;
@@ -371,6 +376,11 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 		array++;
 	}
 
+	if (type & PERF_SAMPLE_REALTIME) {
+		data->realtime = *array;
+		array++;
+	}
+
 	if (type & PERF_SAMPLE_PERIOD) {
 		data->period = *array;
 		array++;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index c68cf40..b220c93 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -90,6 +90,9 @@ static void perf_session__id_header_size(struct perf_session *session)
 
        if (sample_type & PERF_SAMPLE_CPU)
                size += sizeof(data->cpu) * 2;
+
+       if (sample_type & PERF_SAMPLE_REALTIME)
+               size += sizeof(data->realtime);
 out:
        session->id_hdr_size = size;
 }
@@ -658,6 +661,9 @@ static void perf_session__print_tstamp(struct perf_session *session,
 
 	if (session->sample_type & PERF_SAMPLE_TIME)
 		printf("%" PRIu64 " ", sample->time);
+
+	if (session->sample_type & PERF_SAMPLE_REALTIME)
+		printf("%" PRIu64 " ", sample->realtime);
 }
 
 static void dump_event(struct perf_session *session, union perf_event *event,
-- 
1.7.4

