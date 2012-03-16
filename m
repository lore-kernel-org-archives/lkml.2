Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab2CPCWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 22:22:54 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:49384 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab2CPCWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 22:22:53 -0400
X-AuditID: b753bd60-a0885ba000000655-a9-4f62a3fa09cb
X-AuditID: b753bd60-a0885ba000000655-a9-4f62a3fa09cb
Message-ID: <4F62A3F5.2050400@hitachi.com>
Date: Fri, 16 Mar 2012 11:22:45 +0900
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v5 2/5] perf: set correct value to perf_event_header.misc
 for BTS
References: <20120130044242.2384.23076.stgit@linux3>   <20120130044303.2384.63515.stgit@linux3> <1327916138.2446.187.camel@twins>  <4F432E0B.5090608@hitachi.com> <1331055135.11248.325.camel@twins>
In-Reply-To: <1331055135.11248.325.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/03/07 2:32), Peter Zijlstra wrote:
> On Tue, 2012-02-21 at 14:39 +0900, Akihiro Nagai wrote:
>> (2012/01/30 18:35), Peter Zijlstra wrote:
>>> On Mon, 2012-01-30 at 13:43 +0900, Akihiro Nagai wrote:
>>>> @@ -330,6 +342,14 @@ int intel_pmu_drain_bts_buffer(void)
>>>>                   return 1;
>>>>
>>>>           for (; at<   top; at++) {
>>>> +               /*
>>>> +                * To resolve user space symbols and DSOs correctly, set
>>>> +                * PERF_RECORD_MISC_USER if from_addr or to_addr is user space.
>>>> +                */
>>>> +               if (!kernel_ip(data.ip) || !kernel_ip(data.addr)) {
>>>> +                       header.misc&= ~PERF_RECORD_MISC_CPUMODE_MASK;
>>>> +                       header.misc |= PERF_RECORD_MISC_USER;
>>>> +               }
>>>>                   data.ip         = at->from;
>>>>                   data.addr       = at->to;
>>>
>>> Why not key off of the from? If its a jump from userspace its a user
>>> event, its a jump from kernel space its a kernel event?
>>
>> Of course, originally, perf does that.
>
> I don't think it does.
>
>> And, in those cases,
>> BTS records the both addresses of kernel and user in one
>> perf_sample on branches from kernel to user.
>
> Sorry, I don't get this.
>
>> Current perf sets PERF_RECORD_MISC_KERNEL to all BTS events,
>
> It doesn't, it does something far more stupid.. it sets the state to
> wherever we were when the BTS overflow interrupt happens. If that was in
> kernel space, we mark all of them as in-kernel, if that was in
> user-space we mark all of then in-user.

Normally, perf does. However, BTS (intel_pmu_drain_bts_buffer) uses
local-defined and not-initialized pt_regs to decide PERF_RECORD_MISC_KERNEL or USER.
Accordingly, almost all BTS events are set PERF_RECORD_MISC_KERNEL.

BTW, I think it's a bug that uses not-initialized pt_regs.
So, it needs initialize:
-    struct pt_regs regs;
+    struct pt_regs regs = {0};

Or, intel_pmu_drain_bts_buffer() get pt_regs from a function argument.
- int intel_pmu_drain_bts_buffer(void)
+ int intel_pmu_drain_bts_buffer(struct pt_regs *regs)

>
>>   and
>> perf-script doesn't resolve symbols and DSOs about the
>> user-space address, because it is a kernel event.
>
> Well, that's a perf-script problem, not something you should change the
> kernel for.

Exactly. I'm going to fix perf-script.

>
> So how about something like this?
>
> ---
>   arch/x86/kernel/cpu/perf_event_intel_ds.c |    7 +++++++
>   1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> index d6bd49f..81e788c 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -333,6 +333,13 @@ int intel_pmu_drain_bts_buffer(void)
>   		data.ip		= at->from;
>   		data.addr	= at->to;
>
> +		/* XXX doesn't do virt muck properly */
> +		header.misc&= ~PERF_RECORD_MISC_CPUMODE_MASK;
> +		if (kernel_ip(at->from))
> +			header.misc |= PERF_RECORD_MISC_KERNEL;
> +		else
> +			header.misc |= PERF_RECORD_MISC_USER;
> +
>   		perf_output_sample(&handle,&header,&data, event);
>   	}

It looks good. I think it's correct semantically to set
PERF_RECORD_MISC_KERNEL or USER by the from-address.
However, this patch needs perf-script fix too.
I'm going to send next patches including this patch.

Thank you,
