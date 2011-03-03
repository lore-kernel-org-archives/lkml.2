Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab1CCO3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 09:29:08 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:65323 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab1CCO3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 09:29:05 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHs0b01AaMHG/2dsb2JhbACmZXSjC5wghWEEhRqHEoNC
X-IronPort-AV: E=Sophos;i="4.62,258,1297036800"; 
   d="scan'208";a="268832285"
Message-ID: <4D6FA5C0.80405@cisco.com>
Date: Thu, 03 Mar 2011 07:29:20 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
CC: linux-perf-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        acme@ghostprotocols.net, Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 3/6] perf record: add time-of-day option
References: <1298865151-23656-1-git-send-email-daahern@cisco.com> <1298865151-23656-4-git-send-email-daahern@cisco.com> <alpine.LFD.2.00.1103012359460.2701@localhost6.localdomain6> <4D6E5413.6060500@cisco.com> <alpine.LFD.2.00.1103021821080.2701@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103021821080.2701@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/02/2011 10:28 AM, Thomas Gleixner wrote:
> Further I made a suggestion to add trace points to the time keeping
> code instead, which

Ok, so let's say we have a tracepoint in do_settimeofday, another in
whatever function is needed to get ntp updates to the timekeeper
parameters. I still don't see how the initial sample is grabbed. I
definitely do not want a tracepoint in any of the gettimeofday
functions. Furthermore, seems like timekeeping code now needs to be
replicated within perf to some degree.

How about a simpler alternative? Adding the time-of-day stamp to the
samples. --tod is an optional parameter, and if desired a warning can be
added to the usage about the additional overhead of reading gettimeofday
for each sample. Users can decided if the overhead is acceptable (this
is still much lighterweight than strace which has a time-of-day option).

This is the kernel side change; userspace changes are much simpler as well.

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 8ceb5a6..3297394 100644
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
@@ -989,6 +990,7 @@ struct perf_sample_data {
 		u32	cpu;
 		u32	reserved;
 	}				cpu_entry;
+	u64				realtime;
 	u64				period;
 	struct perf_callchain_entry	*callchain;
 	struct perf_raw_record		*raw;
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 64a018e..0711cc9 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -908,6 +908,9 @@ static void perf_event__id_header_size(struct
perf_event *event)
 	if (sample_type & PERF_SAMPLE_CPU)
 		size += sizeof(data->cpu_entry);

+	if (sample_type & PERF_SAMPLE_REALTIME)
+		size += sizeof(data->realtime);
+
 	event->id_header_size = size;
 }

@@ -4010,6 +4013,9 @@ static void __perf_event_header__init_id(struct
perf_event_header *header,
 	if (sample_type & PERF_SAMPLE_TIME)
 		data->time = perf_clock();

+	if (sample_type & PERF_SAMPLE_REALTIME)
+		data->realtime = ktime_to_ns(ktime_get_real());
+
 	if (sample_type & PERF_SAMPLE_ID)
 		data->id = primary_event_id(event);

@@ -4049,6 +4055,9 @@ static void __perf_event__output_id_sample(struct
perf_output_handle *handle,

 	if (sample_type & PERF_SAMPLE_CPU)
 		perf_output_put(handle, data->cpu_entry);
+
+	if (sample_type & PERF_SAMPLE_REALTIME)
+		perf_output_put(handle, data->realtime);
 }

 static void perf_event__output_id_sample(struct perf_event *event,
@@ -4293,6 +4302,9 @@ void perf_output_sample(struct perf_output_handle
*handle,
 	if (sample_type & PERF_SAMPLE_CPU)
 		perf_output_put(handle, data->cpu_entry);

+	if (sample_type & PERF_SAMPLE_REALTIME)
+		perf_output_put(handle, data->realtime);
+
 	if (sample_type & PERF_SAMPLE_PERIOD)
 		perf_output_put(handle, data->period);
