Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406Ab0HSGGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 02:06:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:26634 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab0HSGGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 02:06:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,231,1280732400"; 
   d="scan'208";a="829623619"
Subject: Re: [PATCH -tip] perf, x86: P4 PMU - check for INSTR_COMPLETED
 being supported by cpu
From: Lin Ming <ming.m.lin@intel.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100818185445.GA11949@lenovo>
References: <20100818185445.GA11949@lenovo>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 14:07:09 +0800
Message-ID: <1282198029.11858.107.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 02:54 +0800, Cyrill Gorcunov wrote:
> INSTR_COMPLETED is supported on particular cpu models of Netburst family,
> add a check for that.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Lin Ming <ming.m.lin@intel.com>
> CC: Stephane Eranian <eranian@google.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Frédéric Weisbecker <fweisbec@gmail.com>
> CC: Arnaldo Carvalho de Melo <acme@redhat.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> ---
> 
> Hi Ming, please review this patch, and if you happened to have this
> cpu models give it a try please (if you manage to find some spare time
> of course). To test it we need RAW event P4_EVENT_INSTR_COMPLETED passed
> on any model not mentioned in p4_event_match_cpu_model, and reverse ;)

I have model 2 and 6.

int main(int argc, char *argv[])
{
        u64 config = ((((P4_EVENT_INSTR_COMPLETED) << 25)   |
                        ((1ULL) << 9)) << 32)                      |
                        (0); /* no CCCR needed */

	printf("%llx\n", config);
}

Use above code to get the raw config value 5a00020000000000.

1. Test on model 2 p4, it falls into the check correctly.

# perf top -e r5a00020000000000

  Error: perfcounter syscall returned with -1 (Invalid argument)

  Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?

#dmesg
P4 PMU: Unsupported event: INSTR_COMPLETED

2. Test on model 6 p4,

PerfTop:       0 irqs/sec  kernel: nan%  exact:  nan% [1000Hz raw
0x5a00020000000000],  (all, 16 CPUs)

It has problem, no data is collected.

I will check this.

Lin Ming

> 
>  arch/x86/kernel/cpu/perf_event_p4.c |   30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
> +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> @@ -350,6 +350,11 @@ static __initconst const u64 p4_hw_cache
>   },
>  };
>  
> +/*
> + * If general events will ever have a reference to the
> + * P4_EVENT_INSTR_COMPLETED we would ought to check for
> + * cpu model match (see how it's done for RAW events)
> + */
>  static u64 p4_general_events[PERF_COUNT_HW_MAX] = {
>    /* non-halted CPU clocks */
>    [PERF_COUNT_HW_CPU_CYCLES] =
> @@ -428,6 +433,27 @@ static u64 p4_pmu_event_map(int hw_event
>  	return config;
>  }
>  
> +/* check cpu model specifics */
> +static bool p4_event_match_cpu_model(unsigned int event_idx)
> +{
> +	/* INSTR_COMPLETED event only exist for model 3, 4, 6 (Prescott) */
> +	if (event_idx == P4_EVENT_INSTR_COMPLETED) {
> +		if (boot_cpu_data.x86_model	!= 3 &&
> +			boot_cpu_data.x86_model	!= 4 &&
> +			boot_cpu_data.x86_model	!= 6) {
> +			pr_warning("P4 PMU: Unsupported event: INSTR_COMPLETED\n");
> +			return false;
> +		}
> +	}
> +
> +	/*
> +	 * note the IQ_ESCR0, IQ_ESCR1 are available on models 1 and 2
> +	 * only but since we don't use them at moment -- no check
> +	 */
> +
> +	return true;
> +}
> +
>  static int p4_validate_raw_event(struct perf_event *event)
>  {
>  	unsigned int v;
> @@ -439,6 +465,10 @@ static int p4_validate_raw_event(struct 
>  		return -EINVAL;
>  	}
>  
> +	/* it may be unsupported */
> +	if (!p4_event_match_cpu_model(v))
> +		return -EINVAL;
> +
>  	/*
>  	 * it may have some screwed PEBS bits
>  	 */


