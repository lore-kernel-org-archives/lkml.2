Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab1CTSzq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 14:55:46 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:27121 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab1CTSyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 14:54:44 -0400
X-IronPort-AV: E=Sophos;i="4.63,215,1299456000"; 
   d="scan'208";a="278221354"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <daahern@cisco.com>
Subject: [PATCH 1/5] perf events: add support for realtime clock attribute
Date: Sun, 20 Mar 2011 12:54:33 -0600
Message-Id: <1300647277-8431-2-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1300647277-8431-1-git-send-email-daahern@cisco.com>
References: <1300647277-8431-1-git-send-email-daahern@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel side plumbing for PERF_SAMPLE_REALTIME.

Signed-off-by: David Ahern <daahern@cisco.com>
---
 include/linux/perf_event.h |    4 +++-
 kernel/perf_event.c        |   12 ++++++++++++
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index f495c01..d64f0fd 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -125,8 +125,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_PERIOD			= 1U << 8,
 	PERF_SAMPLE_STREAM_ID			= 1U << 9,
 	PERF_SAMPLE_RAW				= 1U << 10,
+	PERF_SAMPLE_REALTIME			= 1U << 11,
 
-	PERF_SAMPLE_MAX = 1U << 11,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 12,		/* non-ABI */
 };
 
 /*
@@ -998,6 +999,7 @@ struct perf_sample_data {
 		u32	cpu;
 		u32	reserved;
 	}				cpu_entry;
+	u64				realtime;
 	u64				period;
 	struct perf_callchain_entry	*callchain;
 	struct perf_raw_record		*raw;
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 3472bb1..977a07b 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -903,6 +903,9 @@ static void perf_event__id_header_size(struct perf_event *event)
 	if (sample_type & PERF_SAMPLE_CPU)
 		size += sizeof(data->cpu_entry);
 
+	if (sample_type & PERF_SAMPLE_REALTIME)
+		size += sizeof(data->realtime);
+
 	event->id_header_size = size;
 }
 
@@ -4016,6 +4019,9 @@ static void __perf_event_header__init_id(struct perf_event_header *header,
 		data->cpu_entry.cpu	 = raw_smp_processor_id();
 		data->cpu_entry.reserved = 0;
 	}
+
+	if (sample_type & PERF_SAMPLE_REALTIME)
+		data->realtime = ktime_to_ns(ktime_get_real());
 }
 
 static void perf_event_header__init_id(struct perf_event_header *header,
@@ -4045,6 +4051,9 @@ static void __perf_event__output_id_sample(struct perf_output_handle *handle,
 
 	if (sample_type & PERF_SAMPLE_CPU)
 		perf_output_put(handle, data->cpu_entry);
+
+	if (sample_type & PERF_SAMPLE_REALTIME)
+		perf_output_put(handle, data->realtime);
 }
 
 static void perf_event__output_id_sample(struct perf_event *event,
@@ -4289,6 +4298,9 @@ void perf_output_sample(struct perf_output_handle *handle,
 	if (sample_type & PERF_SAMPLE_CPU)
 		perf_output_put(handle, data->cpu_entry);
 
+	if (sample_type & PERF_SAMPLE_REALTIME)
+		perf_output_put(handle, data->realtime);
+
 	if (sample_type & PERF_SAMPLE_PERIOD)
 		perf_output_put(handle, data->period);
 
-- 
1.7.4

