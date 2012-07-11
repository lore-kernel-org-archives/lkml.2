Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab2GKCXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 22:23:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38042 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab2GKCXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 22:23:15 -0400
Message-ID: <4FFCE1EF.7000602@gmail.com>
Date: Tue, 10 Jul 2012 20:16:15 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: acme@ghostprotocols.net, mingo@kernel.org, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4/4] perf kvm: fix bug resolving guest kernel syms
References: <1341956894-69284-1-git-send-email-dsahern@gmail.com> <1341956894-69284-5-git-send-email-dsahern@gmail.com> <874npf86dp.fsf@sejong.aot.lge.com>
In-Reply-To: <874npf86dp.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/10/12 6:54 PM, Namhyung Kim wrote:
> Hi, David
>
> On Tue, 10 Jul 2012 15:48:14 -0600, David Ahern wrote:
>> Guest kernel symbols are not resolved despite passing the information
>> needed to resolve them. e.g.,
>>
>> perf kvm --guest --guestmount=/tmp/guest-mount record -a -- sleep 1
>> perf kvm --guest --guestmount=/tmp/guest-mount report --stdio
>>
>>      36.55%  [guest/11399]  [unknown]         [g] 0xffffffff81600bc8
>>      33.19%  [guest/10474]  [unknown]         [g] 0x00000000c0116e00
>>      30.26%  [guest/11094]  [unknown]         [g] 0xffffffff8100a288
>>
>>      43.69%  [guest/10474]  [unknown]         [g] 0x00000000c0103d90
>>      37.38%  [guest/11399]  [unknown]         [g] 0xffffffff81600bc8
>>      12.24%  [guest/11094]  [unknown]         [g] 0xffffffff810aa91d
>>       6.69%  [guest/11094]  [unknown]         [u] 0x00007fa784d721c3
>>
>> which is just pathetic.
>>
>> After a maddening 2 days sifting through perf minutia I found it --
>> id_hdr_size is not initialized for guest machines. This shows up on the
>> report side as random garbage for the cpu and timestamp, e.g.,
>>
>> 29816 7310572949125804849 0x1ac0 [0x50]: PERF_RECORD_MMAP ...
>>
>> that messes up the sample sorting such that synthesized guest maps are
>> processed last.
>>
>> With this patch you get a much more helpful report:
>>
>>    12.11%  [guest/11399]  [guest.kernel.kallsyms.11399]  [g] irqtime_account_process_tick
>>    10.58%  [guest/11399]  [guest.kernel.kallsyms.11399]  [g] run_timer_softirq
>>     6.95%  [guest/11094]  [guest.kernel.kallsyms.11094]  [g] printk_needs_cpu
>>     6.50%  [guest/11094]  [guest.kernel.kallsyms.11094]  [g] do_timer
>>     6.45%  [guest/11399]  [guest.kernel.kallsyms.11399]  [g] idle_balance
>>     4.90%  [guest/11094]  [guest.kernel.kallsyms.11094]  [g] native_read_tsc
>> ...
>>
>> Signed-off-by: David Ahern <dsahern@gmail.com>
>> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Jiri Olsa <jolsa@redhat.com>
>> Cc: Namhyung Kim <namhyung@gmail.com>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> ---
>>   tools/perf/util/map.c     |   24 ++++++++++++++++++++++++
>>   tools/perf/util/map.h     |    1 +
>>   tools/perf/util/session.c |    1 +
>>   3 files changed, 26 insertions(+)
>>
>> diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
>> index 641377e..da3411b 100644
>> --- a/tools/perf/util/map.c
>> +++ b/tools/perf/util/map.c
>> @@ -730,3 +730,27 @@ char *machine__mmap_name(struct machine *self, char *bf, size_t size)
>>
>>   	return bf;
>>   }
>> +
>> +void machines__set_id_hdr_size(struct rb_root *self, u16 id_hdr_size)
>> +{
>> +	struct rb_node *p;
>> +	struct machine *machine;
>> +
>> +    p = self->rb_node;
>> +	while (p != NULL) {
>> +		machine = rb_entry(p, struct machine, rb_node);
>> +		machine->id_hdr_size = id_hdr_size;
>> +        p = rb_next(p);
>> +	}
>> +
>
> Looks like white-space damaged. :(

bleah, something on my dev server converted tabs to spaces. Will fix.

>
> The loop itself looks fine, or you might use this form:
>
> 	for (p = rb_first(self); p; p = rb_next(p))

Doesn't work - I still see machines not updated.
>
>
> Is there a something like rb_for_each_entry() ?

Didn't see one.

>
>
>> +    p = self->rb_node;
>> +    if (p)
>> +        p = rb_prev(p);
>> +	while (p != NULL) {
>> +		machine = rb_entry(p, struct machine, rb_node);
>> +		machine->id_hdr_size = id_hdr_size;
>> +        p = rb_prev(p);
>> +	}
>> +
>
> I don't see why this second loop is necessary?

To get the left half of the tree I believe. First loop walks the root 
and all of the leaves to the right; this loop walks all of the leaves to 
the left.

David
