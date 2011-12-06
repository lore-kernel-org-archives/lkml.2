Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475Ab1LFO5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 09:57:46 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62186 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933389Ab1LFO5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 09:57:45 -0500
Message-ID: <4EDE2D62.9050802@gmail.com>
Date: Tue, 06 Dec 2011 07:57:38 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        asharma@fb.com, devel@openvz.org, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 3/7] perf: add ability to change event according to sample
 (v2)
References: <1322471015-107825-1-git-send-email-avagin@openvz.org> <1322471015-107825-4-git-send-email-avagin@openvz.org> <20111206141942.GE10709@infradead.org>
In-Reply-To: <20111206141942.GE10709@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/06/2011 07:19 AM, Arnaldo Carvalho de Melo wrote:
> Em Mon, Nov 28, 2011 at 12:03:31PM +0300, Andrew Vagin escreveu:
>> It's opposition of perf_session__parse_sample.
>>
>> v2: fixed mistakes which David Arhen found
> 
> Ok, I'm taking this one, David, can I added an 'Acked-by: you"? Or even
> "reviewed-by:" ?
> 
> I'm just changing 'data' to 'sample', data is way to vague, I kept it
> for a while in the past just to reduce patch size, but this is something
> completely new, so better use 'sample'.
> 
> - Arnaldo
>  
>> Signed-off-by: Andrew Vagin <avagin@openvz.org>
>> ---
>>  tools/perf/util/event.h   |    2 +
>>  tools/perf/util/evsel.c   |   74 +++++++++++++++++++++++++++++++++++++++++++++
>>  tools/perf/util/session.h |    9 +++++
>>  3 files changed, 85 insertions(+), 0 deletions(-)
>>
>> diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
>> index 357a85b..0493101 100644
>> --- a/tools/perf/util/event.h
>> +++ b/tools/perf/util/event.h
>> @@ -187,5 +187,7 @@ const char *perf_event__name(unsigned int id);
>>  int perf_event__parse_sample(const union perf_event *event, u64 type,
>>  			     int sample_size, bool sample_id_all,
>>  			     struct perf_sample *sample, bool swapped);
>> +int perf_event__change_sample(union perf_event *event, u64 type,
>> +			     const struct perf_sample *data, bool swapped);
>>  
>>  #endif /* __PERF_RECORD_H */
>> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
>> index e426264..d697568 100644
>> --- a/tools/perf/util/evsel.c
>> +++ b/tools/perf/util/evsel.c
>> @@ -494,3 +494,77 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
>>  
>>  	return 0;
>>  }
>> +
>> +int perf_event__change_sample(union perf_event *event, u64 type,
>> +			     const struct perf_sample *data, bool swapped)
>> +{
>> +	u64 *array;
>> +
>> +	/*
>> +	 * used for cross-endian analysis. See git commit 65014ab3
>> +	 * for why this goofiness is needed.
>> +	 */
>> +	union {
>> +		u64 val64;
>> +		u32 val32[2];
>> +	} u;
>> +
>> +	array = event->sample.array;
>> +
>> +	if (type & PERF_SAMPLE_IP) {
>> +		event->ip.ip = data->ip;
>> +		array++;
>> +	}
>> +
>> +	if (type & PERF_SAMPLE_TID) {
>> +		u.val32[0] = data->pid;
>> +		u.val32[1] = data->tid;
>> +		if (swapped) {
>> +			/* undo swap of u64, then swap on individual u32s */

Comment is from the parse sample code; this is the inverse of that code
so the comment needs to be updated here.

>> +			u.val32[0] = bswap_32(u.val32[0]);
>> +			u.val32[1] = bswap_32(u.val32[1]);
>> +			u.val64 = bswap_64(u.val64);
>> +		}
>> +
>> +		*array = u.val64;
>> +		array++;
>> +	}
>> +
>> +	if (type & PERF_SAMPLE_TIME) {
>> +		*array = data->time;
>> +		array++;
>> +	}
>> +
>> +	if (type & PERF_SAMPLE_ADDR) {
>> +		*array = data->addr;
>> +		array++;
>> +	}
>> +
>> +	if (type & PERF_SAMPLE_ID) {
>> +		*array = data->id;
>> +		array++;
>> +	}
>> +
>> +	if (type & PERF_SAMPLE_STREAM_ID) {
>> +		*array = data->stream_id;
>> +		array++;
>> +	}
>> +
>> +	if (type & PERF_SAMPLE_CPU) {
>> +		u.val32[0] = data->cpu;
>> +		if (swapped) {
>> +			/* undo swap of u64, then swap on individual u32s */

Ditto on that comment.

I did not test it, but the logic is in the inverse of parse_sample so it
should be correct.

Arnaldo: you could use remove the 2 comment lines on the commit since
there are no logic impacts.

Reviewed-by: David Ahern <dsahern@gmail.com>

David
