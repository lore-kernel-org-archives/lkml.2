Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab0HSGTE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 02:19:04 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49353 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab0HSGTB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 02:19:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xPm2Br/UPf3tmamYeFfbhXOUE077zf/z/QQhZ/s+FkQhZbBArXc3LFFV5lP9NP6njR
         /9AgEzfLurgW5aTub3ba/uXTYSLeD0stg0erTIz4krIV58RGj+k1xiw5qofzzwxajpnB
         lkW7Sms2Tz9Y+9W6gkLiER9r02ZLudG4oqr0g=
MIME-Version: 1.0
In-Reply-To: <1282198029.11858.107.camel@minggr.sh.intel.com>
References: <20100818185445.GA11949@lenovo>
	<1282198029.11858.107.camel@minggr.sh.intel.com>
Date: Thu, 19 Aug 2010 10:19:00 +0400
X-Google-Sender-Auth: tvmfdrsyhrnYPxFLsSf4qDLq118
Message-ID: <AANLkTinsLXW5yUOCT0NURhat0X=hABAetKGxNmVvsbdC@mail.gmail.com>
Subject: Re: [PATCH -tip] perf, x86: P4 PMU - check for INSTR_COMPLETED being
 supported by cpu
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/19/10, Lin Ming <ming.m.lin@intel.com> wrote:
> On Thu, 2010-08-19 at 02:54 +0800, Cyrill Gorcunov wrote:
>> INSTR_COMPLETED is supported on particular cpu models of Netburst family,
>> add a check for that.
>>
>> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
>> CC: Lin Ming <ming.m.lin@intel.com>
>> CC: Stephane Eranian <eranian@google.com>
>> CC: Ingo Molnar <mingo@elte.hu>
>> CC: Frédéric Weisbecker <fweisbec@gmail.com>
>> CC: Arnaldo Carvalho de Melo <acme@redhat.com>
>> CC: Peter Zijlstra <peterz@infradead.org>
>> ---
>>
>> Hi Ming, please review this patch, and if you happened to have this
>> cpu models give it a try please (if you manage to find some spare time
>> of course). To test it we need RAW event P4_EVENT_INSTR_COMPLETED passed
>> on any model not mentioned in p4_event_match_cpu_model, and reverse ;)
>
> I have model 2 and 6.
>
> int main(int argc, char *argv[])
> {
>         u64 config = ((((P4_EVENT_INSTR_COMPLETED) << 25)   |
>                         ((1ULL) << 9)) << 32)                      |
>                         (0); /* no CCCR needed */
>
> 	printf("%llx\n", config);
> }
>
> Use above code to get the raw config value 5a00020000000000.
>
> 1. Test on model 2 p4, it falls into the check correctly.
>
> # perf top -e r5a00020000000000
>
>   Error: perfcounter syscall returned with -1 (Invalid argument)
>
>   Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?
>
> #dmesg
> P4 PMU: Unsupported event: INSTR_COMPLETED
>
> 2. Test on model 6 p4,
>
> PerfTop:       0 irqs/sec  kernel: nan%  exact:  nan% [1000Hz raw
> 0x5a00020000000000],  (all, 16 CPUs)
>
> It has problem, no data is collected.
>
> I will check this.
>

Thanks Ming, try to set both bogus and bogus bits in event mask
> Lin Ming
>
>>
>>  arch/x86/kernel/cpu/perf_event_p4.c |   30 ++++++++++++++++++++++++++++++
>>  1 file changed, 30 insertions(+)
>>
>> Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
>> =====================================================================
>> --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
>> +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
>> @@ -350,6 +350,11 @@ static __initconst const u64 p4_hw_cache
>>   },
>>  };
>>
>> +/*
>> + * If general events will ever have a reference to the
>> + * P4_EVENT_INSTR_COMPLETED we would ought to check for
>> + * cpu model match (see how it's done for RAW events)
>> + */
>>  static u64 p4_general_events[PERF_COUNT_HW_MAX] = {
>>    /* non-halted CPU clocks */
>>    [PERF_COUNT_HW_CPU_CYCLES] =
>> @@ -428,6 +433,27 @@ static u64 p4_pmu_event_map(int hw_event
>>  	return config;
>>  }
>>
>> +/* check cpu model specifics */
>> +static bool p4_event_match_cpu_model(unsigned int event_idx)
>> +{
>> +	/* INSTR_COMPLETED event only exist for model 3, 4, 6 (Prescott) */
>> +	if (event_idx == P4_EVENT_INSTR_COMPLETED) {
>> +		if (boot_cpu_data.x86_model	!= 3 &&
>> +			boot_cpu_data.x86_model	!= 4 &&
>> +			boot_cpu_data.x86_model	!= 6) {
>> +			pr_warning("P4 PMU: Unsupported event: INSTR_COMPLETED\n");
>> +			return false;
>> +		}
>> +	}
>> +
>> +	/*
>> +	 * note the IQ_ESCR0, IQ_ESCR1 are available on models 1 and 2
>> +	 * only but since we don't use them at moment -- no check
>> +	 */
>> +
>> +	return true;
>> +}
>> +
>>  static int p4_validate_raw_event(struct perf_event *event)
>>  {
>>  	unsigned int v;
>> @@ -439,6 +465,10 @@ static int p4_validate_raw_event(struct
>>  		return -EINVAL;
>>  	}
>>
>> +	/* it may be unsupported */
>> +	if (!p4_event_match_cpu_model(v))
>> +		return -EINVAL;
>> +
>>  	/*
>>  	 * it may have some screwed PEBS bits
>>  	 */
>
>
>
