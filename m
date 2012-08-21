Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab2HUIAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 04:00:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:5715 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab2HUIA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 04:00:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,801,1336374000"; 
   d="scan'208";a="183311781"
Message-ID: <50334019.6040803@intel.com>
Date: Tue, 21 Aug 2012 16:00:25 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        andi@firstfloor.org
Subject: Re: [PATCH] perf/x86: fix SNB-EP CBO and PCU uncore PMU filter management
References: <20120820162237.GA9295@quad>
In-Reply-To: <20120820162237.GA9295@quad>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2012 12:22 AM, Stephane Eranian wrote:
> The existing code had a bug whereby it would refuse to
> measure two events in a group for either CBO or PCU PMUs,
> if one of the events was using a filter. This was due to
> the fact that the kernel assumed all CBO and PCU events
> were using filters, and thus would detect false positive
> conflicts between attr->config1 values.
>     
> This patch fixes the problem by introducing the extra_reg
> event mapping tables for both CBO and PCU PMUs. Those
> tables associate an event code+umask with extra (filter)
> register. We used the same approach for the offcore_response
> core PMU event.
>     
> With this patch applied, it is possible to measure, for
> instance, CBO unc_c_tor_inserts:opcode:pcirdcur with
> unc_c_clockticks in the same group.

Thank you for fixing this.

> 
> The filter for both CBO and PCU are more complex than what the
> current code support. Each filter is sub-divided into event
> specific filters. For now, we consider the filter as one single
> MSR value. We lose a bit of flexibility and force multiplexing
> when this is not really necessary in HW. We could later create
> the notion of virtual filters that would be aggregated at the
> last step (wrmsrl). But I think this is good enough for now.
> 

Actually there are codes that handle similar case properly. See how
the ZDP_CTL_FVC register is handled in nhmex_mbox_get/put_shared_reg().
Do you like to update this patch or I will update it later.

Acked-by: Yan, Zheng <zheng.z.yan@intel.com>

Regards
Yan, Zheng

> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> index 0a55710..cd2c930 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> @@ -224,29 +224,86 @@ static void snbep_uncore_msr_init_box(struct intel_uncore_box *box)
>  		wrmsrl(msr, SNBEP_PMON_BOX_CTL_INT);
>  }
>  
> -static int snbep_uncore_hw_config(struct intel_uncore_box *box, struct perf_event *event)
> +static int uncore_pmu_extra_regs(struct intel_uncore_box *box,
> +				 struct perf_event *event)
> +{
> +	struct hw_perf_event_extra *reg;
> +	struct extra_reg *er = box->pmu->type->extra_regs;
> +
> +	if (!er)
> +		return 0;
> +
> +	reg = &event->hw.extra_reg;
> +
> +	for (; er->msr; er++) {
> +		if (er->event != (event->attr.config & er->config_mask))
> +			continue;
> +
> +		if (event->attr.config1 & ~er->valid_mask)
> +			return -EINVAL;
> +
> +		reg->idx = er->idx;
> +		reg->config = event->attr.config1;
> +		reg->reg = er->msr;
> +		break;
> +	}
> +	return 0;
> +}
> +
> +
> +static int snbep_cbo_extra_regs(struct intel_uncore_box *box,
> +				struct perf_event *event)
>  {
> +#define SNBEP_CBO_TIDEN_MASK		(1ULL<< 19)
> +#define SNBEP_CBO_FILT_CIDTID_MASK	0xfULL
> +
>  	struct hw_perf_event *hwc = &event->hw;
> -	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
> +	struct hw_perf_event_extra *reg = &hwc->extra_reg;
> +	u64 config1 = event->attr.config1;
>  
> -	if (box->pmu->type == &snbep_uncore_cbox) {
> -		reg1->reg = SNBEP_C0_MSR_PMON_BOX_FILTER +
> -			SNBEP_CBO_MSR_OFFSET * box->pmu->pmu_idx;
> -		reg1->config = event->attr.config1 &
> -			SNBEP_CB0_MSR_PMON_BOX_FILTER_MASK;
> -	} else {
> -		if (box->pmu->type == &snbep_uncore_pcu) {
> -			reg1->reg = SNBEP_PCU_MSR_PMON_BOX_FILTER;
> -			reg1->config = event->attr.config1 & SNBEP_PCU_MSR_PMON_BOX_FILTER_MASK;
> -		} else {
> -			return 0;
> -		}
> +	/*
> +	 * if extra_reg not set via the snbep_uncore_cbo_extra_regs[]
> +	 * then we need to check whether or not the tid_en bit is set
> +	 * in the config. If so, then we do need to enable the cbo filter
> +	 */
> +	if (reg->idx == EXTRA_REG_NONE
> +	    && (event->attr.config & SNBEP_CBO_TIDEN_MASK)) {
> +		/*
> +		 * validate that only the core-id/thread-id
> +		 * bits are set, otherwise we must go through
> +		 * the snbep_uncore_cbo_extra_regs[] table
> +		 */
> +		if (config1 & ~SNBEP_CBO_FILT_CIDTID_MASK)
> +			return -EINVAL;
> +
> +		reg->idx = 0;
> +		reg->config = config1 & SNBEP_CBO_FILT_CIDTID_MASK;
> +		reg->reg = SNBEP_C0_MSR_PMON_BOX_FILTER;
>  	}
> -	reg1->idx = 0;
> +	/*
> +	 * adjust the cbo index
> +	 */
> +	if (reg->idx != EXTRA_REG_NONE)
> +		reg->reg += SNBEP_CBO_MSR_OFFSET * box->pmu->pmu_idx;
>  
>  	return 0;
>  }
>  
> +static int snbep_uncore_hw_config(struct intel_uncore_box *box, struct perf_event *event)
> +{
> +	struct intel_uncore_type *type = box->pmu->type;
> +	int ret;
> +
> +	ret = uncore_pmu_extra_regs(box, event);
> +	if (ret)
> +		return ret;
> +
> +	if (type == &snbep_uncore_cbox)
> +		ret = snbep_cbo_extra_regs(box, event);
> +
> +	return ret;
> +}
> +
>  static struct attribute *snbep_uncore_formats_attr[] = {
>  	&format_attr_event.attr,
>  	&format_attr_umask.attr,
> @@ -444,6 +501,41 @@ static struct intel_uncore_type snbep_uncore_ubox = {
>  	.format_group	= &snbep_uncore_ubox_format_group,
>  };
>  
> +#define CBO_EVENT_EXTRA_REG(a) \
> +	UNC_EXTRA_REG(a, \
> +		      SNBEP_C0_MSR_PMON_BOX_FILTER, \
> +		      ARCH_PERFMON_EVENTSEL_EVENT, \
> +		      SNBEP_CB0_MSR_PMON_BOX_FILTER_MASK, \
> +		      0)
> +
> +#define CBO_EVTUM_EXTRA_REG(a) \
> +	UNC_EXTRA_REG(a, \
> +		      SNBEP_C0_MSR_PMON_BOX_FILTER, \
> +		      INTEL_ARCH_EVENT_MASK, \
> +		      SNBEP_CB0_MSR_PMON_BOX_FILTER_MASK, \
> +		      0)
> +
> +static struct extra_reg snbep_uncore_cbo_extra_regs[] __read_mostly =
> +{
> +	CBO_EVENT_EXTRA_REG(0x0034), /* LLC_LOOKUP */
> +	CBO_EVTUM_EXTRA_REG(0x0135), /* TOR_INSERTS.OPCODE */
> +	CBO_EVTUM_EXTRA_REG(0x0335), /* TOR_INSERTS.MISS_OPCODE */
> +	CBO_EVTUM_EXTRA_REG(0x4135), /* TOR_INSERTS.NID_OPCODE */
> +	CBO_EVTUM_EXTRA_REG(0x4335), /* TOR_INSERTS.NID_MISS_OPCODE */
> +	CBO_EVTUM_EXTRA_REG(0x4435), /* TOR_INSERTS.NID_EVICTION */
> +	CBO_EVTUM_EXTRA_REG(0x4835), /* TOR_INSERTS.NID_ALL */
> +	CBO_EVTUM_EXTRA_REG(0x4a35), /* TOR_INSERTS.NID_MISS_ALL */
> +	CBO_EVTUM_EXTRA_REG(0x5035), /* TOR_INSERTS.NID_WB */
> +	CBO_EVTUM_EXTRA_REG(0x0136), /* TOR_OCCUPANCY.OPCODE */
> +	CBO_EVTUM_EXTRA_REG(0x0336), /* TOR_OCCUPANCY.MISS_OPCODE */
> +	CBO_EVTUM_EXTRA_REG(0x4136), /* TOR_OCCUPANCY.NID_OPCODE */
> +	CBO_EVTUM_EXTRA_REG(0x4336), /* TOR_OCCUPANCY.NID_MISS_OPCODE */
> +	CBO_EVTUM_EXTRA_REG(0x4436), /* TOR_OCCUPANCY.NID_EVICTION */
> +	CBO_EVTUM_EXTRA_REG(0x4836), /* TOR_OCCUPANCY.NID_ALL */
> +	CBO_EVTUM_EXTRA_REG(0x4a36), /* TOR_OCCUPANCY.NID_MISS_ALL */
> +	EVENT_EXTRA_END
> +};
> +
>  static struct intel_uncore_type snbep_uncore_cbox = {
>  	.name			= "cbox",
>  	.num_counters		= 4,
> @@ -458,6 +550,23 @@ static struct intel_uncore_type snbep_uncore_cbox = {
>  	.constraints		= snbep_uncore_cbox_constraints,
>  	.ops			= &snbep_uncore_msr_ops,
>  	.format_group		= &snbep_uncore_cbox_format_group,
> +	.extra_regs		= snbep_uncore_cbo_extra_regs,
> +};
> +
> +#define PCU_EVENT_EXTRA_REG(a) \
> +	UNC_EXTRA_REG(a, \
> +		      SNBEP_PCU_MSR_PMON_BOX_FILTER, \
> +		      ARCH_PERFMON_EVENTSEL_EVENT, \
> +		      0xffffffff, \
> +		      0)
> +
> +static struct extra_reg snbep_uncore_pcu_extra_regs[] __read_mostly =
> +{
> +	PCU_EVENT_EXTRA_REG(0xb), /* FREQ_BAND0_CYCLES */
> +	PCU_EVENT_EXTRA_REG(0xc), /* FREQ_BAND1_CYCLES */
> +	PCU_EVENT_EXTRA_REG(0xd), /* FREQ_BAND2_CYCLES */
> +	PCU_EVENT_EXTRA_REG(0xe), /* FREQ_BAND3_CYCLES */
> +	EVENT_EXTRA_END
>  };
>  
>  static struct intel_uncore_type snbep_uncore_pcu = {
> @@ -472,6 +581,7 @@ static struct intel_uncore_type snbep_uncore_pcu = {
>  	.num_shared_regs	= 1,
>  	.ops			= &snbep_uncore_msr_ops,
>  	.format_group		= &snbep_uncore_pcu_format_group,
> +	.extra_regs		= snbep_uncore_pcu_extra_regs,
>  };
>  
>  static struct intel_uncore_type *snbep_msr_uncores[] = {
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
> index 5b81c18..37d8732 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
> @@ -369,6 +369,7 @@ struct intel_uncore_type {
>  	struct intel_uncore_pmu *pmus;
>  	struct intel_uncore_ops *ops;
>  	struct uncore_event_desc *event_descs;
> +	struct extra_reg *extra_regs;
>  	const struct attribute_group *attr_groups[3];
>  };
>  
> @@ -428,6 +429,14 @@ struct uncore_event_desc {
>  	const char *config;
>  };
>  
> +#define UNC_EXTRA_REG(e, ms, m, vm, i) {\
> +	.event = (e),		\
> +	.msr = (ms),		\
> +	.config_mask = (m),	\
> +	.valid_mask = (vm),	\
> +	.idx = i\
> +	}
> +
>  #define INTEL_UNCORE_EVENT_DESC(_name, _config)			\
>  {								\
>  	.attr	= __ATTR(_name, 0444, uncore_event_show, NULL),	\
> 

