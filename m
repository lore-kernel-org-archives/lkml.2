Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab2ENNJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:09:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48420 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336Ab2ENNJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:09:55 -0400
Message-ID: <4FB1041C.1050903@gmail.com>
Date: Mon, 14 May 2012 07:09:48 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung.kim@lge.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf-record: Create events initially disabled -- again
References: <1336968088-11531-1-git-send-email-dsahern@gmail.com> <87sjf31a8c.fsf@sejong.aot.lge.com>
In-Reply-To: <87sjf31a8c.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/14/12 1:40 AM, Namhyung Kim wrote:
> Hi,
>
> On Sun, 13 May 2012 22:01:28 -0600, David Ahern wrote:
>> 764e16a changed perf-record to create events disabled by default and
>> enable them once perf initializations are done. This setting was dropped
>> by 0f82ebc. Now perf events are once again generated during perf's
>> initialization phase (e.g., generating maps).
>>
>> As an example, perf opens a lot of files at startup. Unpatched:
>>
>> perf record -e syscalls:sys_enter_open -ga -fo /tmp/perf.data -- sleep 1
>> [ perf record: Woken up 1 times to write data ]
>> [ perf record: Captured and wrote 0.087 MB /tmp/perf.data (~3798 samples) ]
>>
>> Using perf-script to look at the samples shows the perf command generating
>> 563 of the 566 total events.
>>
>> Patched:
>>
>> perf record -e syscalls:sys_enter_open -ga -fo /tmp/perf.data -- sleep 1
>> [ perf record: Woken up 1 times to write data ]
>> [ perf record: Captured and wrote 0.028 MB /tmp/perf.data (~1206 samples) ]
>>
>> Using perf-script to look at the samples does not show perf command.
>>
>> Signed-off-by: David Ahern<dsahern@gmail.com>
>> ---
>>   tools/perf/util/evsel.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
>> index 21eaab2..6710cfe 100644
>> --- a/tools/perf/util/evsel.c
>> +++ b/tools/perf/util/evsel.c
>> @@ -70,6 +70,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
>>   	struct perf_event_attr *attr =&evsel->attr;
>>   	int track = !evsel->idx; /* only the first counter needs these */
>>
>> +	attr->disabled = 1;
>>   	attr->sample_id_all = opts->sample_id_all_missing ? 0 : 1;
>>   	attr->inherit	    = !opts->no_inherit;
>>   	attr->read_format   = PERF_FORMAT_TOTAL_TIME_ENABLED |
>> @@ -138,7 +139,6 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
>>
>>   	if (perf_target__none(&opts->target)&&
>>   	(!opts->group || evsel == first)) {
>> -		attr->disabled = 1;
>>   		attr->enable_on_exec = 1;
>>   	}
>>   }
>
> A problem I see is that it'll break group handling again:
>
> $ ./perf stat -g sleep 1
>
>   Performance counter stats for 'sleep 1':
>
>       <not counted>  task-clock
>       <not counted>  context-switches
>       <not counted>  CPU-migrations
>       <not counted>  page-faults
>       <not counted>  cycles
>       <not counted>  stalled-cycles-frontend
>       <not counted>  stalled-cycles-backend
>       <not counted>  instructions
>       <not counted>  branches
>       <not counted>  branch-misses
>
>         1.000868932 seconds time elapsed
>
> So I suggest changing perf_target__none() check to a proper one
> (perf_target__no_cpu? - the name might be changed soon) for your
> purpose.
>
> Thanks,
> Namhyung

Something else is wrong then. I tested that command (saw your patch in 
the history) and it worked for me. Also, this code path does not affect 
perf-stat -- it touches perf-record and perf-test only.

David
