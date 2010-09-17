Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab0IQIzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 04:55:17 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:18622
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751556Ab0IQIzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 04:55:14 -0400
X-SpamScore: -17
X-BigFish: VPS-17(zzbb2cK936eK1432N98dNzz1202hzz8275dhz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L8VV9R-02-004-02
X-M-MSG: 
Date: Fri, 17 Sep 2010 10:51:24 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "eranian@google.com" <eranian@google.com>
Subject: Re: [PATCH] perf, x86: catch spurious interrupts after disabling
 counters
Message-ID: <20100917085124.GK13563@erda.amd.com>
References: <20100910144634.GA1060@elte.hu>
 <20100910155659.GD13563@erda.amd.com>
 <20100911094157.GA11521@elte.hu>
 <20100911114404.GE13563@erda.amd.com>
 <20100911124537.GA22850@elte.hu>
 <20100912095202.GF13563@erda.amd.com>
 <20100913143713.GK13563@erda.amd.com>
 <20100914174132.GN13563@erda.amd.com>
 <20100915162034.GO13563@erda.amd.com>
 <1284658480.2275.589.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1284658480.2275.589.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.09.10 13:34:40, Peter Zijlstra wrote:
> On Wed, 2010-09-15 at 18:20 +0200, Robert Richter wrote:
> > Some cpus still deliver spurious interrupts after disabling a counter.
> > This caused 'undelivered NMI' messages. This patch fixes this.
> > 
> I tried the below and that also seems to work.. So yeah, looks like
> we're getting late NMIs.

I would rather prefer the fix I sent. This patch does a rdmsrl() with
each nmi on every inactive counter. It also changes the counter value
of all inactive counters, thus restarting a counter by only setting
the enable bit may start with an unexpected counter value (didn't look
at current implementation if this could be a problem).

It is also not possible to detect with hardware, which counter fired
the interrupt. We cannot assume a counter overflowed by just reading
the upper bit of the counter value. We must track this in software.

-Robert

> 
> ---
>  arch/x86/kernel/cpu/perf_event.c |   21 ++++++++++++++++++++-
>  1 files changed, 20 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 0fb1705..9a261ac 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1145,6 +1145,22 @@ static void x86_pmu_del(struct perf_event *event, int flags)
>  	perf_event_update_userpage(event);
>  }
>  
> +static int fixup_overflow(int idx)
> +{
> +	u64 val;
> +
> +	rdmsrl(x86_pmu.perfctr + idx, val);
> +	if (!(val & (1ULL << (x86_pmu.cntval_bits - 1)))) {
> +		val = (u64)(-x86_pmu.max_period);
> +		val &= x86_pmu.cntval_mask;
> +		wrmsrl(x86_pmu.perfctr + idx, val);
> +
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
>  static int x86_pmu_handle_irq(struct pt_regs *regs)
>  {
>  	struct perf_sample_data data;
> @@ -1159,8 +1175,11 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
>  	cpuc = &__get_cpu_var(cpu_hw_events);
>  
>  	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
> -		if (!test_bit(idx, cpuc->active_mask))
> +		if (!test_bit(idx, cpuc->active_mask)) {
> +	       		if (fixup_overflow(idx))
> +				handled++;
>  			continue;
> +		}
>  
>  		event = cpuc->events[idx];
>  		hwc = &event->hw;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

