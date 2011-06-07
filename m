Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757693Ab1FGXzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:55:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61209 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283Ab1FGXzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:55:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=B4hjirEi1Z7GAQQwvO+z1iBZ1TJ9xcR3nsRQU5ScqOZ6jt0mHyWKXuH/DKAXITR59G
         5BbAn4B8GojJgI9mWRcwJT0zD7vIBxx3NdR2Uw4je2nQE9xXqmyDeCQzJfGZUv8Q1TPR
         XmCCWDR9NRs0LVg067F+QC1oUbLWyVxQ/BTZM=
From: David Ahern <dsahern@gmail.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 3/6] perf: add reference time event
Date: Tue,  7 Jun 2011 17:55:46 -0600
Message-Id: <1307490946-24673-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1307490806-24548-1-git-send-email-dsahern@gmail.com>
References: <1307490806-24548-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For initial perf_clock to time-of-day correlation.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/event.c   |    1 +
 tools/perf/util/event.h   |    8 ++++++++
 tools/perf/util/session.c |    4 ++++
 tools/perf/util/session.h |    3 ++-
 4 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 3c1b8a6..1a89a04 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -24,6 +24,7 @@ static const char *perf_event__names[] = {
 	[PERF_RECORD_HEADER_TRACING_DATA]	= "TRACING_DATA",
 	[PERF_RECORD_HEADER_BUILD_ID]		= "BUILD_ID",
 	[PERF_RECORD_FINISHED_ROUND]		= "FINISHED_ROUND",
+	[PERF_RECORD_REFTIME]			= "REF_TIME",
 };
 
 const char *perf_event__name(unsigned int id)
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 1d7f664..f481f90 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -98,6 +98,7 @@ enum perf_user_event_type { /* above any possible kernel type */
 	PERF_RECORD_HEADER_TRACING_DATA		= 66,
 	PERF_RECORD_HEADER_BUILD_ID		= 67,
 	PERF_RECORD_FINISHED_ROUND		= 68,
+	PERF_RECORD_REFTIME			= 69,
 	PERF_RECORD_HEADER_MAX
 };
 
@@ -124,6 +125,12 @@ struct tracing_data_event {
 	u32 size;
 };
 
+struct reftime_event {
+	struct perf_event_header header;
+	struct timeval tv;
+	u64 nsec;
+};
+
 union perf_event {
 	struct perf_event_header	header;
 	struct ip_event			ip;
@@ -137,6 +144,7 @@ union perf_event {
 	struct event_type_event		event_type;
 	struct tracing_data_event	tracing_data;
 	struct build_id_event		build_id;
+	struct reftime_event		reftime;
 };
 
 void perf_event__print_totals(void);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index b723f21..322632c 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -792,6 +792,10 @@ static int perf_session__process_user_event(struct perf_session *session, union
 		return ops->build_id(event, session);
 	case PERF_RECORD_FINISHED_ROUND:
 		return ops->finished_round(event, session, ops);
+	case PERF_RECORD_REFTIME:
+		if (ops->reftime)
+			return ops->reftime(event, session);
+		return -EINVAL;
 	default:
 		return -EINVAL;
 	}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index de4178d..9728701 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -81,7 +81,8 @@ struct perf_event_ops {
 	event_synth_op	attr,
 			event_type,
 			tracing_data,
-			build_id;
+			build_id,
+			reftime;
 	event_op2	finished_round;
 	bool		ordered_samples;
 	bool		ordering_requires_timestamps;
-- 
1.7.5.2

