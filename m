Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172Ab2IFBiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 21:38:03 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:42504 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab2IFBiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 21:38:01 -0400
X-AuditID: 9c93016f-b7cc0ae000000e9f-32-5047fe76b5ef
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 14/17] perf header: Set tracepoint event name only if not set
References: <1346886537-11621-1-git-send-email-acme@infradead.org>
	<1346886537-11621-15-git-send-email-acme@infradead.org>
	<5047E7CC.6040408@gmail.com>
Date: Thu, 06 Sep 2012 10:30:37 +0900
In-Reply-To: <5047E7CC.6040408@gmail.com> (David Ahern's message of "Wed, 05
	Sep 2012 18:01:16 -0600")
Message-ID: <87oblkc4zm.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Sep 2012 18:01:16 -0600, David Ahern wrote:
> On 9/5/12 5:08 PM, Arnaldo Carvalho de Melo wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>>
>> The event name can be set already by processing a event_desc data.
>>
>> So check it before setting to prevent possible leak.
>>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Link: http://lkml.kernel.org/r/1346821373-31621-3-git-send-email-namhyung@kernel.org
>> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>> ---
>>   tools/perf/util/header.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
>> index a124b93..05c9310 100644
>> --- a/tools/perf/util/header.c
>> +++ b/tools/perf/util/header.c
>> @@ -2314,7 +2314,7 @@ static int perf_evlist__set_tracepoint_names(struct perf_evlist *evlist,
>>   	struct perf_evsel *pos;
>>
>>   	list_for_each_entry(pos, &evlist->entries, node) {
>> -		if (pos->attr.type == PERF_TYPE_TRACEPOINT &&
>> +		if (pos->attr.type == PERF_TYPE_TRACEPOINT && !pos->name &&
>>   		    perf_evsel__set_tracepoint_name(pos, pevent))
>>   			return -1;
>>   	}
>>
>
> I'm getting a segfault running perf-script due to this patch. Most
> likely this is exposing another problem. Back trace is:

Hmm.  It's because evsel->tp_format being not set, not sure why I didn't
detect this during tests.  Will find out a solution.

Thanks,
Namhyung


>
> #0  0x000000000049f4f2 in pevent_event_info (s=0x7fffffffdab0,
> event=0x0, record=0x7fffffffda70)
>     at tools/lib/traceevent/event-parse.c:4183
> #1  0x000000000046cd52 in event_format__print (event=0x0,
> cpu=<optimized out>, data=<optimized out>, size=<optimized out>)
>     at util/trace-event-parse.c:182
> #2  0x000000000042d41b in process_event (event=0x7fffef9d1e60,
> sample=0x7fffffffdc90, evsel=0x90d870, machine=0x906f80,
>     al=<optimized out>) at builtin-script.c:415
> #3  0x000000000042c4e1 in process_sample_event (tool=<optimized out>,
> event=0x7fffef9d1e60, sample=0x7fffffffdc90, evsel=
>     0x90d870, machine=0x906f80) at builtin-script.c:515
> #4  0x000000000046864d in perf_session_deliver_event
> (session=<optimized out>, event=0x7fffef9d1e60, sample=0x7fffffffdc90,
>     tool=0x79d020, file_offset=<optimized out>) at util/session.c:1065
> #5  0x0000000000468c5a in flush_sample_queue (s=0x906f20,
> tool=0x79d020) at util/session.c:719
> #6  0x0000000000468d46 in process_finished_round (tool=<optimized
> out>, event=<optimized out>, session=0x906f20)
>     at util/session.c:790
> #7  0x0000000000469055 in perf_session__process_user_event
> (file_offset=541768, tool=0x79d020, event=0x7fffefa2b448,
>     session=0x906f20) at util/session.c:1129
> #8  perf_session__process_event (session=0x906f20,
> event=0x7fffefa2b448, tool=0x79d020, file_offset=541768)
>     at util/session.c:1161
> #9  0x000000000046a851 in __perf_session__process_events
> (session=0x906f20, data_offset=<optimized out>,
>     data_size=<optimized out>, file_size=2564784, tool=0x79d020) at
> util/session.c:1429
> #10 0x000000000042ebdc in __cmd_script (session=0x906f20) at
> builtin-script.c:548
