Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab1EZJoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 05:44:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:43115 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498Ab1EZJoQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 05:44:16 -0400
Subject: Re: [PATCH 2/3] introduce intel_rapl driver
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Zhang Rui <rui.zhang@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>, mingo@elte.hu,
        acme@redhat.com, ming.m.lin@intel.com, "Brown, Len" <lenb@kernel.org>,
        Matt Fleming <matt@console-pimps.org>
In-Reply-To: <1306398857.2207.157.camel@rui>
References: <1306398857.2207.157.camel@rui>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 26 May 2011 11:43:23 +0200
Message-ID: <1306403003.1200.41.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 16:34 +0800, Zhang Rui wrote:
> Introduce Intel RAPL driver.
> 
> RAPL (running average power limit) is a new feature which provides mechanisms
> to enforce power consumption limit, on some new processors.
> 
> RAPL provides MSRs reporting the total amount of energy consumed
> by the package/core/uncore/dram.
> Further more, by using RAPL, OS can set a power bugdet in a certain time window,
> and let Hardware to throttle the processor P/T-state to meet this enery limitation.
> 
> Currently, we don't have the plan to support the RAPL power control,
> but we do want to export the package/core/uncore/dram power consumption
> information via perf tool first.

Do note that perf is not the right API for those control bits. If you
never plan to expose those, that's fine. If you do, you'll likely need a
parallel API (your own device) for accessing that. Please consider if
using separate APIs for reading/writing this resource is what you want
and mention these considerations in your future changelog.

> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  drivers/platform/x86/Kconfig      |    8 
>  drivers/platform/x86/Makefile     |    1 
>  drivers/platform/x86/intel_rapl.c |  368 ++++++++++++++++++++++++++++++++++++++
>  include/linux/perf_event.h        |    4 
>  4 files changed, 381 insertions(+)
> 
> Index: linux-2.6/drivers/platform/x86/Kconfig
> ===================================================================
> --- linux-2.6.orig/drivers/platform/x86/Kconfig
> +++ linux-2.6/drivers/platform/x86/Kconfig
> @@ -753,4 +753,12 @@ config SAMSUNG_LAPTOP
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called samsung-laptop.
>  
> +config INTEL_RAPL
> +	tristate "Intel RAPL Support"
> +	depends on X86

Also very much depends on perf being there.

> +	default y
> +	---help---
> +	  RAPL, AKA, Running Average Power Limit provides mechanisms to enforce
> +	  power consumption limit.

The enforce part seems dubious, perf is purely about observing state it
doesn't enforce anything. Also this help text could do with expanding in
general.

>  endif # X86_PLATFORM_DEVICES
> Index: linux-2.6/drivers/platform/x86/Makefile
> ===================================================================
> --- linux-2.6.orig/drivers/platform/x86/Makefile
> +++ linux-2.6/drivers/platform/x86/Makefile
> @@ -42,3 +42,4 @@ obj-$(CONFIG_XO15_EBOOK)	+= xo15-ebook.o
>  obj-$(CONFIG_IBM_RTL)		+= ibm_rtl.o
>  obj-$(CONFIG_SAMSUNG_LAPTOP)	+= samsung-laptop.o
>  obj-$(CONFIG_INTEL_MFLD_THERMAL)	+= intel_mid_thermal.o
> +obj-$(CONFIG_INTEL_RAPL)	+= intel_rapl.o
> Index: linux-2.6/include/linux/perf_event.h
> ===================================================================
> --- linux-2.6.orig/include/linux/perf_event.h
> +++ linux-2.6/include/linux/perf_event.h
> @@ -107,6 +107,10 @@ enum perf_sw_ids {
>  	PERF_COUNT_SW_PAGE_FAULTS_MAJ		= 6,
>  	PERF_COUNT_SW_ALIGNMENT_FAULTS		= 7,
>  	PERF_COUNT_SW_EMULATION_FAULTS		= 8,
> +	PERF_COUNT_SW_PKG_ENERGY		= 9,
> +	PERF_COUNT_SW_CORE_ENERGY		= 10,
> +	PERF_COUNT_SW_UNCORE_ENERGY		= 11,
> +	PERF_COUNT_SW_DRAM_ENERGY		= 12,

Not going to happen, RAPL registers its own pmu (wrongly, see below),
with that it (should) get its own perf_event_attr::type and thus should
have its own ::config space, you do not get to pollute the
PERF_TYPE_SOFTWARE config space.

Currently there isn't a way to expose the events in sysfs, but we do
want that, its mostly a matter of getting all involved parties to agree
on a format and implementing it.

>  	PERF_COUNT_SW_MAX,			/* non-ABI */
>  };
> Index: linux-2.6/drivers/platform/x86/intel_rapl.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/drivers/platform/x86/intel_rapl.c

> +#define MSR_RAPL_POWER_UNIT		0x606
> +
> +/*
> + * Platform specific RAPL Domains.
> + * Note that PP1 RAPL Domain is supported on 062A only
> + * And DRAM RAPL Domain is supported on 062D only
> + */

0x62[AD] is useless, please use proper names.

> +/* Package RAPL Domain */
> +#define MSR_PKG_RAPL_POWER_LIMIT	0x610
> +#define MSR_PKG_ENERGY_STATUS		0x611
> +#define MSR_PKG_PERF_STATUS		0x613
> +#define MSR_PKG_POWER_INFO		0x614
> +
> +/* PP0 RAPL Domain */
> +#define MSR_PP0_POWER_LIMIT		0x638
> +#define MSR_PP0_ENERGY_STATUS		0x639
> +#define MSR_PP0_POLICY			0x63A
> +#define MSR_PP0_PERF_STATUS		0x63B
> +
> +/* PP1 RAPL Domain, may reflect to uncore devices */
> +#define MSR_PP1_POWER_LIMIT		0x640
> +#define MSR_PP1_ENERGY_STATUS		0x641
> +#define MSR_PP1_POLICY			0x642
> +
> +/* DRAM RAPL Domain */
> +#define MSR_DRAM_POWER_LIMIT		0x618
> +#define MSR_DRAM_ENERGY_STATUS		0x619
> +#define MSR_DRAM_PERF_STATUS		0x61B
> +#define MSR_DRAM_POWER_INFO		0x61C
> +
> +/* RAPL UNIT BITMASK */
> +#define POWER_UNIT_OFFSET	0
> +#define POWER_UNIT_MASK		0x0F
> +
> +#define ENERGY_UNIT_OFFSET	0x08
> +#define ENERGY_UNIT_MASK	0x1F00
> +
> +#define TIME_UNIT_OFFSET	0x10
> +#define TIME_UNIT_MASK		0xF000

Are you sure? (x & TIME_UNIT_MASK) >> TIME_UNIT_OFFSET == 0.
You either want a mask of 0xF0000, or an offset of 0x0c.

> +static int rapl_pmu_pkg_event_init(struct perf_event *event);
> +static int rapl_pmu_core_event_init(struct perf_event *event);
> +static int rapl_pmu_uncore_event_init(struct perf_event *event);
> +static int rapl_pmu_dram_event_init(struct perf_event *event);
> +static void rapl_event_start(struct perf_event *event, int flags);
> +static void rapl_event_stop(struct perf_event *event, int flags);
> +static int rapl_event_add(struct perf_event *event, int flags);
> +static void rapl_event_del(struct perf_event *event, int flags);
> +static void rapl_event_read(struct perf_event *event);
> +
> +enum rapl_domain_id {
> +	RAPL_DOMAIN_PKG,
> +	RAPL_DOMAIN_PP0,
> +	RAPL_DOMAIN_PP1,
> +	RAPL_DOMAIN_DRAM,
> +	RAPL_DOMAIN_MAX
> +};
> +
> +struct rapl_domain_msr {
> +	int	limit;
> +	int	status;
> +};
> +
> +struct rapl_domain {
> +	enum rapl_domain_id domain_id;
> +	struct rapl_domain_msr msrs;
> +	struct pmu pmu;
> +	enum perf_sw_ids event_id;
> +	int valid;
> +};

You could use the rapl_domain_id as your ::config space.


> +static unsigned int power_unit_divisor;
> +static unsigned int energy_unit_divisor;
> +static unsigned int time_unit_divisor;
> +
> +enum unit_type {
> +	POWER_UNIT,
> +	ENERGY_UNIT,
> +	TIME_UNIT
> +};
> +static u64 rapl_unit_xlate(enum unit_type type, u64 value, int action)
> +{
> +	u64 divisor;
> +
> +	switch (type) {
> +	case POWER_UNIT:
> +		divisor = power_unit_divisor;
> +		break;
> +	case ENERGY_UNIT:
> +		divisor = energy_unit_divisor;
> +		break;
> +	case TIME_UNIT:
> +		divisor = time_unit_divisor;
> +		break;
> +	default:
> +		return 0;
> +	};
> +
> +	if (action)
> +		return value * divisor; /* value is from users */
> +	else
> +		return div64_u64(value, divisor); /* value is from MSR */
> +}

Please see the comment down by rapl_check_unit(), this is just too wrong
to live.

> +/* show the energy status, in Jelous */
> +static int rapl_read_energy(struct rapl_domain *domain)
> +{
> +	u64 value;
> +	u32 msr = domain->msrs.status;
> +
> +	rdmsrl(msr, value);
> +	return rapl_unit_xlate(ENERGY_UNIT, value, 0);
> +}
> +
> +static void rapl_event_update(struct perf_event *event)
> +{
> +	s64 prev;
> +	u64 now;
> +	struct rapl_domain *domain = to_rapl_domain(event->pmu);
> +
> +	now = rapl_read_energy(domain);

So I had to get the Intel SDM because your driver lacks all useful
information, and I learned that the RAPL status MSRs contain 32 bits.

So you get those 32 bits, divide them by some number,

> +	prev = local64_xchg(&event->hw.prev_count, now);
> +	local64_add(now - prev, &event->count);

And then expect that to work?

I don't think so..

> +}
> +
> +static void rapl_event_start(struct perf_event *event, int flags)
> +{
> +	struct rapl_domain *domain = to_rapl_domain(event->pmu);
> +
> +	local64_set(&event->hw.prev_count, rapl_read_energy(domain));
> +	perf_swevent_start_hrtimer(event);
> +}
> +
> +static void rapl_event_stop(struct perf_event *event, int flags)
> +{
> +	perf_swevent_cancel_hrtimer(event);
> +	rapl_event_update(event);
> +}

> +static int rapl_pmu_event_init(struct perf_event *event,
> +			       enum rapl_domain_id id)
> +{
> +	struct rapl_domain *domain = &(rapl_domains[id]);
> +
> +	if (event->attr.type != PERF_TYPE_SOFTWARE)
> +		return -ENOENT;
> +
> +	if (event->attr.config != domain->event_id)
> +		return -ENOENT;
> +
> +	/* Do periodecal update every second */
> +	event->attr.freq = 1;
> +	event->attr.sample_period = 1;
> +
> +	perf_swevent_init_hrtimer(event);
> +
> +	return 0;
> +}

That's just wrong.. the reason you're wanting to have this timer is to
avoid the RAPL MSRs from overflowing and you loosing offsets, right?

But the above is actually forcing the event to create samples on a
totally unrelated time base.

RAPL should fail to create a sampling event since it doesn't have the
capability to trigger overflow interrupts based on its events.

If you want a timer, add one, but don't do this.

If you expect you actually want to sample, use this event as part of a
group and add a sampling event in there and use PERF_FORMAT_GROUP, Matt
was working on patches to make perf-record capable of this.

> +static int rapl_check_unit(void)

Shouldn't that be called: rapl_init_unit()? You're not actually
verifying anything, you're setting-up state.

> +{
> +	u64 output;
> +	u32 value;
> +
> +	rdmsrl(MSR_RAPL_POWER_UNIT, output);
> +
> +	/* energy unit: 1/enery_unit_divisor Joules */
> +	value = (output & ENERGY_UNIT_MASK) >> ENERGY_UNIT_OFFSET;
> +	energy_unit_divisor = 1 << value;
> +
> +	/* power unit: 1/power_unit_divisor Watts */
> +	value = (output & POWER_UNIT_MASK) >> POWER_UNIT_OFFSET;
> +	power_unit_divisor = 1 << value;
> +
> +	/* time unit: 1/time_unit_divisor Seconds */
> +	value =(output & TIME_UNIT_MASK) >> TIME_UNIT_OFFSET;
> +	time_unit_divisor = 1 << value;

So you're saying these factors are powers-of-two, please look at
rapl_unit_xlate and try again.

+
> +	return 0;
> +}
> +
> +static int __init intel_rapl_init(void)
> +{
> +	enum rapl_domain_id id;
> +
> +	/*
> +	 * RAPL features are only supported on processors have a CPUID
> +	 * signature with DisplayFamily_DisplayModel of 06_2AH, 06_2DH
> +	 */
> +	if (boot_cpu_data.x86 != 0x06)
> +		return -ENODEV;
> +
> +	if (boot_cpu_data.x86_model == 0x2A)
> +		rapl_domains[RAPL_DOMAIN_PP1].valid = 1;
> +	else if (boot_cpu_data.x86_model == 0x2D)
> +		rapl_domains[RAPL_DOMAIN_DRAM].valid = 1;
> +	else
> +		return -ENODEV;

Names please, again 06_2[AD] is useless we could have surmised that by
reading the code, nobody knows which part that is.

  a += 4; /* increment by 4 */

quality comments here.

> +	if (rapl_check_unit())
> +		return -ENODEV;
> +
> +	for(id = 0; id < RAPL_DOMAIN_MAX; id++)
> +		if (rapl_domains[id].valid)
> +			perf_pmu_register(&(rapl_domains[id].pmu), rapl_domains[id].pmu.name, PERF_TYPE_SOFTWARE);

Uhm, hell no!, you get to use type = -1.

> +	return 0;
> +}
> +
