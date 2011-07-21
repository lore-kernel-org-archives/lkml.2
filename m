Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab1GUJg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 05:36:56 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:42478 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab1GUJgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 05:36:51 -0400
X-AuditID: b753bd60-a50b1ba0000019f4-fc-4e27f3319633
X-AuditID: b753bd60-a50b1ba0000019f4-fc-4e27f3319633
Message-ID: <4E27F32F.4020606@hitachi.com>
Date: Thu, 21 Jul 2011 18:36:47 +0900
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v2 3/6] perf script: resolve DSOs and symbols for
 user-space
References: <20110717093031.3447.52715.stgit@linux3> <20110717093057.3447.31077.stgit@linux3> <4E230BDA.5020305@gmail.com>
In-Reply-To: <4E230BDA.5020305@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/07/18 1:20), David Ahern wrote:
> On 07/17/2011 03:30 AM, Akihiro Nagai wrote:
>> Resolve user-space DSOs and symbols.
>> Latest perf-script can resolve DSOs and symbols for only kernel
>> and kernel modules. This patch resolves them for other
>> executable binaries.
>
> The description is a bit misleading. perf script does resolve symbols
> for userspace. e.g., the example in the bug fix I submitted in May:
> https://lkml.org/lkml/2011/5/30/223
>
> Do you look into why the cpumode setting is not working that you have to
> try specific settings?
Indeed, perf already can resolve user-space symbols and DSOs if cpumode has
the flag PERF_RECORD_MISC_USER. I found this change is incorrect.
To solve this, I'd like to set both flags PERF_RECORD_MISC_KERNEL and USER
to BTS records, because BTS traces both kernel and user space while it
generates interrupts.

And also, I think there is the probrem in thread__find_addr_map().
When this function is called with cpumode that is set (PERF_RECORD_MISC_KERNEL | USER),
this function processes only PERF_RECORD_MISC_KERNEL. So, I'd like to fix it too.

Thank you.
>
> David
>
>
>>
>> # perf script -f ip,addr,sym,dso
>> 3f03e016b0 ffffffff814675d2 irq_return ([kernel.kallsyms])
>> 3f03e016b0 ffffffff814675d2 irq_return ([kernel.kallsyms])
>> 3f03e04b80       3f03e016b3 _start (/lib64/ld-2.14.so)
>> 3f03e04b80 ffffffff814675d2 irq_return ([kernel.kallsyms])
>> 3f03e04ba6 ffffffff814675d2 irq_return ([kernel.kallsyms])
>> 3f03e04bad ffffffff814675d2 irq_return ([kernel.kallsyms])
>> 3f03e04c1d       3f03e04bfb _dl_start (/lib64/ld-2.14.so)
>> 3f03e04c00       3f03e04c21 _dl_start (/lib64/ld-2.14.so)
>> 3f03e04c00       3f03e04c21 _dl_start (/lib64/ld-2.14.so)
>> [snip]
>>
>> Signed-off-by: Akihiro Nagai<akihiro.nagai.hw@hitachi.com>
>> Cc: Peter Zijlstra<peterz@infradead.org>
>> Cc: Frederic Weisbecker<fweisbec@gmail.com>
>> Cc: Paul Mackerras<paulus@samba.org>
>> Cc: Ingo Molnar<mingo@elte.hu>
>> Cc: Arnaldo Carvalho de Melo<acme@infradead.org>
>> Cc: David Ahern<dsahern@gmail.com>
>> Cc: Masami Hiramatsu<masami.hiramatsu.pt@hitachi.com>
>> ---
>>
>>   tools/perf/builtin-script.c |    4 ++++
>>   tools/perf/util/event.c     |    5 +++++
>>   2 files changed, 9 insertions(+), 0 deletions(-)
>>
>> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
>> index b3e0951..2356198 100644
>> --- a/tools/perf/builtin-script.c
>> +++ b/tools/perf/builtin-script.c
>> @@ -328,6 +328,10 @@ static void print_sample_addr(union perf_event *event,
>>
>>   	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
>>   			      event->ip.pid, sample->addr,&al);
>> +	/* try to resolve for user space */
>> +	if (!al.map)
>> +		thread__find_addr_map(thread, session, PERF_RECORD_MISC_USER,
>> +			MAP__FUNCTION, event->ip.pid, sample->addr,&al);
>>   	if (!al.map)
>>   		thread__find_addr_map(thread, session, cpumode, MAP__VARIABLE,
>>   				      event->ip.pid, sample->addr,&al);
>> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
>> index 3c1b8a6..49a9315 100644
>> --- a/tools/perf/util/event.c
>> +++ b/tools/perf/util/event.c
>> @@ -771,6 +771,11 @@ int perf_event__preprocess_sample(const union perf_event *event,
>>
>>   	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
>>   			      event->ip.pid, event->ip.ip, al);
>> +	/* try to resolve for user space */
>> +	if (!al->map)
>> +		thread__find_addr_map(thread, session, PERF_RECORD_MISC_USER,
>> +				MAP__FUNCTION, event->ip.pid, event->ip.ip, al);
>> +
>>   	dump_printf(" ...... dso: %s\n",
>>   		    al->map ? al->map->dso->long_name :
>>   			al->level == 'H' ? "[hypervisor]" : "<not found>");
>>
