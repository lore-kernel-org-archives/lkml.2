Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab2BURIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 12:08:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab2BURIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 12:08:02 -0500
Date: Tue, 21 Feb 2012 15:07:54 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, eric.dumazet@gmail.com
Subject: Re: [PATCH] perf tools: fix broken perf record -a mode
Message-ID: <20120221170753.GB4186@infradead.org>
References: <20120221145424.GA6757@quad> <4F43B8EC.30400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F43B8EC.30400@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Feb 21, 2012 at 08:31:56AM -0700, David Ahern escreveu:
> On 2/21/12 7:54 AM, Stephane Eranian wrote:
>>
>> The following commit:
>> b52956c perf tools: Allow multiple threads or processes in record, stat, top
>>
>> introduced a bug in the thread_map code which caused
>> perf record -a to not setup system-wide monitoring properly.
>>
>> $ taskset -c 1 noploop 1000&
>> $ perf record -a -C 1 sleep 10
>> $ perf report -D | tail -20
>> cycles stats:
>>             TOTAL events:       4413
>>              MMAP events:       4025
>>              COMM events:        340
>>            SAMPLE events:         48
>>
>> Here I was expecting about 10,000 samples and not 48.
>>
>> In system-wide mode, the PID passed to perf_event_open()
>> must be -1 and it was 0. That caused the kernel to setup
>> a per-process event on PID:0. Consequently, the number
>> of samples captured does not correspond to the requested
>> measurement.
>>
>> The following one-liner fixes the problem for me with or
>> without -C.

>> I would also suggest to change the malloc() to something
>> that matches the struct definition. thread_map->map[] is
>> declared as int map[] and not pid_t map[]. If map[] can
>> only contain pids, then change the struct definition.

Stephane,

	Feel free to submit a patch :-)

>> Signed-off-by: Stephane Eranian<eranian@google.com>
>>
>> diff --git a/tools/perf/util/thread_map.c b/tools/perf/util/thread_map.c
>> index e15983c..84d9bd78 100644
>> --- a/tools/perf/util/thread_map.c
>> +++ b/tools/perf/util/thread_map.c
>> @@ -229,7 +229,7 @@ static struct thread_map *thread_map__new_by_tid_str(const char *tid_str)
>>   	if (!tid_str) {
>>   		threads = malloc(sizeof(*threads) + sizeof(pid_t));
>>   		if (threads != NULL) {
>> -			threads->map[1] = -1;
>> +			threads->map[0] = -1;
>>   			threads->nr	= 1;
>>   		}
>>   		return threads;
>
> Damn. Hope you did not spend much time chasing it down.

> Acked-by: David Ahern <dsahern@gmail.com>

Yeah, this one slip thru my visual inspection :-\

Now I'll pay for this sin by adding an entry in 'perf test' to check
that :-)

- Arnaldo
