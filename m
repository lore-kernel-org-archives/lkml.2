Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab1HQCTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 22:19:55 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51594 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab1HQCTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 22:19:53 -0400
X-AuditID: b753bd60-9ea82ba000000655-d4-4e4b2546ade0
X-AuditID: b753bd60-9ea82ba000000655-d4-4e4b2546ade0
Message-ID: <4E4B253B.4000703@hitachi.com>
Date: Wed, 17 Aug 2011 11:19:39 +0900
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v3 2/5] perf: change perf_event_header.misc to PERF_RECORD_MISC_USER
 for BTS
References: <20110811120555.5900.23642.stgit@linux3>  <20110811120620.5900.50427.stgit@linux3> <1313065126.7144.6.camel@twins>
In-Reply-To: <1313065126.7144.6.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/08/11 21:18), Peter Zijlstra wrote:
> On Thu, 2011-08-11 at 21:06 +0900, Akihiro Nagai wrote:
>> Change perf_event_headder.misc to PERF_RECORD_MISC_USER for
>> BTS records, because BTS traces both kernel and user spaces
>> nevertheless perf specifies to trace only kernel or user space.
>
> Now I'm confused..
>
> If BTS traces both kernel and user, the MISC bit should reflect the
> right state per-sample, on x86 that's easy enough to do by the address.
Yes.
However, PERF_RECORD_MISC_KERNEL can be specified only when
both from_addr and to_addr are kernel-space. Since current perf always enables
IA32_DEBUGCTL_MSR.BTS_OFF_OS flag when it uses BTS, such BTS records are not
output. So, it's enough to specify only PERF_RECORD_MISC_USER.

>
>
>> ---
>>
>>   arch/x86/kernel/cpu/perf_event_intel_ds.c |    8 ++++++++
>>   1 files changed, 8 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
>> index 1b1ef3a..323f3f0 100644
>> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
>> @@ -340,6 +340,14 @@ static int intel_pmu_drain_bts_buffer(void)
>>   	 */
>>   	perf_prepare_sample(&header,&data, event,&regs);
>>
>> +	/*
>> +	 * Since BTS can not trace kernel and user space separately, set
>
> Uhm, IA32_DEBUGCTL_MSR.BTS_OFF_{OS,USR} seem to suggest it can?!
Current perf always enables IA32_DEBUGCTL_MSR.BTS_OFF_OS when traces with BTS.
However, BTS records branches which jump from kernel(irq_return) to user, because
the msr is to stop tracing in Ring0. It's different with kernel-space in the
strict sense.

>
>> +	 * PERF_RECORD_MISC_USER in header.misc to resolve both kernel and
>> +	 * user DSOs and symbols.
>> +	 */
>> +	header.misc&= ~PERF_RECORD_MISC_CPUMODE_MASK;
>> +	header.misc |= PERF_RECORD_MISC_USER;
>
>
> So what's wrong with something like:
>
> 	header.misc |= is_kernel_address(at->from) ?
> 			PERF_RECORD_MISC_KERNEL :
> 			PERF_RECORD_MISC_USER;
>
It looks good.
However, current perf doesn't output "kernel to kernel" BTS records.
So, it is unnecessary yet.

Thank you.

>>   	if (perf_output_begin(&handle, event, header.size * (top - at)))
>>   		return 1;
>>
>>
>
>

