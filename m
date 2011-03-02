Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab1CBO2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 09:28:37 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:50835 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab1CBO2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 09:28:21 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAPribU2rR7H+/2dsb2JhbACmV3ShZpt2hWEEhReHD4NA
X-IronPort-AV: E=Sophos;i="4.62,253,1297036800"; 
   d="scan'208";a="665106789"
Message-ID: <4D6E5413.6060500@cisco.com>
Date: Wed, 02 Mar 2011 07:28:35 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-perf-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        acme@ghostprotocols.net, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 3/6] perf record: add time-of-day option
References: <1298865151-23656-1-git-send-email-daahern@cisco.com> <1298865151-23656-4-git-send-email-daahern@cisco.com> <alpine.LFD.2.00.1103012359460.2701@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103012359460.2701@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/02/2011 07:16 AM, Thomas Gleixner wrote:
> On Sun, 27 Feb 2011, David Ahern wrote:
> 
>> Enable data collection for generating time-of-day strings when
>> printing individual perf samples. This is done by sampling the
>> realtime clock event with the perf_clock time stamps.
>>
>> If the realtime-clock event is not available (e.g, older kernels)
>> fallback to a synthesized event. (I realize there is resistance
>> to new synthesized events, but it is a simple way to gain this
>> feature on older kernels without the need to modify the kernel
>> code).
> 
> ...
>   
>> +/* add a sample to the event stream based on user request */
>> +static int perf_event_generate_sample(struct perf_event *event)
>> +{
>> +	struct perf_sample_data data;
>> +	struct pt_regs regs;
>> +
>> +	perf_fetch_caller_regs(&regs);
>> +	event->pmu->read(event);
>> +	perf_sample_data_init(&data, 0);
>> +	data.period = event->hw.last_period;
>> +	perf_event_output(event, 0, &data, &regs);
>> +
>> +	return 0;
>> +}
> 
> Errm. This is a generic ioctl to inject random events from user space.
> 
> First of all this wants to be a separate patch and not burried into
> some 100 lines of changes to tools/perf.
> 
> Secondly adding such an ioctl needs a pretty good reason, and the use
> case at hand is not really one.

Peter has made it clear he objects to the ioctl.

> 
> Reading through the other patches, your goal is to correlate
> CLOCK_REALTIME based logs to CLOCK_PERF based events.
> 
> To achieve that you inject cyclic clock_realtime samples into the
> event stream and want to have this initial event inserted via the
> ioctl.

I still need a solution. There is no means for requesting a sample
immediately when a counter is opened, and there is a desire not to add
any more synthesized events. How then do I get the initial correlation
without scanning a potentially large file looking for a single event
type occurrence.

> 
> How does all that deal with CLOCK_REALTIME being affected by NTP and
> settimeofday? Not really, as far as I can tell. It somehow works, but
> that depends on the frequency of your event injection.

It is sampled at some periodic rate to get NTP changes. Right now it is
hardcoded at once an hour. The frequency option can be added to the
--tod parameter.

> 
> To be honest, that's just too much churn for a feature which is single
> purpose and questionable functionality.
> 
> It would be far more interesting to have trace points in the
> timekeeping code, which are useful for other things as well
> (e.g. precise monitoring of NTP) and provide always a correct
> association with the trace clock. That would cover everything from
> frequency adjustments, clock setting including the information about
> the relation to clock monotonic.

I'm not looking to track ntp changes. I want time-of-day strings on
sample dumps. That is not a questionable feature request; it is a
usability enhancement.

We are users of perf. Fantastic tool, but of limited functionality to
the engineers on the team if they cannot correlate event samples with
application logs.

David


> 
> Thanks,
> 
> 	tglx
