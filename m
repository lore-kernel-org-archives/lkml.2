Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab2A0EqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 23:46:19 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:39150 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab2A0EqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 23:46:18 -0500
Message-ID: <4F222C08.3020005@linux.vnet.ibm.com>
Date: Fri, 27 Jan 2012 10:16:00 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@infradead.org, robert.richter@amd.com, ming.m.lin@intel.com,
        andi@firstfloor.org, asharma@fb.com, ravitillo@lbl.gov,
        vweaver1@eecs.utk.edu
Subject: Re: [PATCH 01/13] perf_events: add generic taken branch sampling
 support (v3)
References: <1326127761-2723-1-git-send-email-eranian@google.com> <1326127761-2723-2-git-send-email-eranian@google.com>
In-Reply-To: <1326127761-2723-2-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12012618-5490-0000-0000-000000A0077E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 January 2012 10:19 PM, Stephane Eranian wrote:
> This patch adds the ability to sample taken branches to the
> perf_event interface.
> 
> The ability to capture taken branches is very useful for all
> sorts of analysis. For instance, basic block profiling, call
> counts, statistical call graph.
> 
> This new capability requires hardware assist and as such may
> not be available on all HW platforms. On Intel X86, it is
> implemented on top of the Last Branch Record (LBR) facility.
> 
> To enable taken branches sampling, the PERF_SAMPLE_BRANCH_STACK
> bit must be set in attr->sample_type.
> 
> Sampled taken branches may be filtered by type and/or priv
> levels.
> 
> The patch adds a new field, called branch_sample_type, to the
> perf_event_attr structure. It contains a bitmask of filters
> to apply to the sampled taken branches.
> 
> Filters may be implemented in HW. If the HW filter does not exist
> or is not good enough, some arch may also implement a SW filter.
> 
> The following generic filters are currently defined:
> - PERF_SAMPLE_USER
>   only branches whose targets are at the user level
> 
> - PERF_SAMPLE_KERNEL
>   only branches whose targets are at the kernel level
> 
> - PERF_SAMPLE_ANY
>   any type of branches (subject to priv levels filters)
> 
> - PERF_SAMPLE_ANY_CALL
>   any call branches (may incl. syscall on some arch)
> 
> - PERF_SAMPLE_ANY_RET
>   any return branches (may incl. syscall returns on some arch)
> 
> - PERF_SAMPLE_IND_CALL
>   indirect call branches
> 
> Obviously filter may be combined. The priv level bits are optional.
> If not provided, the priv level of the associated event are used. It
> is possible to collect branches at a priv level different from the
> associated event.
> 
> The number of taken branch records present in each sample may vary based
> on HW, the type of sampled branches, the executed code. Therefore
> each sample contains the number of taken branches it contains.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
  Reviewed by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_lbr.c |   21 +++++---
>  include/linux/perf_event.h                 |   66 ++++++++++++++++++++++++++--
>  kernel/events/core.c                       |   58 ++++++++++++++++++++++++
>  3 files changed, 133 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> index 3fab3de..c3f8100 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> @@ -144,9 +144,11 @@ static void intel_pmu_lbr_read_32(struct cpu_hw_events *cpuc)
> 
>  		rdmsrl(x86_pmu.lbr_from + lbr_idx, msr_lastbranch.lbr);
> 
> -		cpuc->lbr_entries[i].from  = msr_lastbranch.from;
> -		cpuc->lbr_entries[i].to    = msr_lastbranch.to;
> -		cpuc->lbr_entries[i].flags = 0;
> +		cpuc->lbr_entries[i].from	= msr_lastbranch.from;
> +		cpuc->lbr_entries[i].to		= msr_lastbranch.to;
> +		cpuc->lbr_entries[i].mispred	= 0;
> +		cpuc->lbr_entries[i].predicted	= 0;
> +		cpuc->lbr_entries[i].reserved	= 0;
>  	}
>  	cpuc->lbr_stack.nr = i;
>  }
> @@ -167,19 +169,22 @@ static void intel_pmu_lbr_read_64(struct cpu_hw_events *cpuc)
> 
>  	for (i = 0; i < x86_pmu.lbr_nr; i++) {
>  		unsigned long lbr_idx = (tos - i) & mask;
> -		u64 from, to, flags = 0;
> +		u64 from, to, mis = 0, pred = 0;
> 
>  		rdmsrl(x86_pmu.lbr_from + lbr_idx, from);
>  		rdmsrl(x86_pmu.lbr_to   + lbr_idx, to);
> 
>  		if (lbr_format == LBR_FORMAT_EIP_FLAGS) {
> -			flags = !!(from & LBR_FROM_FLAG_MISPRED);
> +			mis = !!(from & LBR_FROM_FLAG_MISPRED);
> +			pred = !mis;
>  			from = (u64)((((s64)from) << 1) >> 1);
>  		}
> 
> -		cpuc->lbr_entries[i].from  = from;
> -		cpuc->lbr_entries[i].to    = to;
> -		cpuc->lbr_entries[i].flags = flags;
> +		cpuc->lbr_entries[i].from	= from;
> +		cpuc->lbr_entries[i].to		= to;
> +		cpuc->lbr_entries[i].mispred	= mis;
> +		cpuc->lbr_entries[i].predicted	= pred;
> +		cpuc->lbr_entries[i].reserved	= 0;
>  	}
>  	cpuc->lbr_stack.nr = i;
>  }
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 0b91db2..17751b1 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -129,11 +129,38 @@ enum perf_event_sample_format {
>  	PERF_SAMPLE_PERIOD			= 1U << 8,
>  	PERF_SAMPLE_STREAM_ID			= 1U << 9,
>  	PERF_SAMPLE_RAW				= 1U << 10,
> +	PERF_SAMPLE_BRANCH_STACK		= 1U << 11,
> 
> -	PERF_SAMPLE_MAX = 1U << 11,		/* non-ABI */
> +	PERF_SAMPLE_MAX = 1U << 12,		/* non-ABI */
>  };
> 
>  /*
> + * values to program into branch_sample_type when PERF_SAMPLE_BRANCH is set
> + *
> + * If the user does not pass priv level information via branch_sample_type,
> + * the kernel uses the event's priv level. Branch and event priv levels do
> + * not have to match. Branch priv level is checked for permissions.
> + *
> + * The branch types can be combined, however BRANCH_ANY covers all types
> + * of branches and therefore it supersedes all the other types.
> + */
> +enum perf_branch_sample_type {
> +	PERF_SAMPLE_BRANCH_USER		= 1U << 0, /* user level branches */
> +	PERF_SAMPLE_BRANCH_KERNEL	= 1U << 1, /* kernel level branches */
> +
> +	PERF_SAMPLE_BRANCH_ANY		= 1U << 2, /* any branch types */
> +	PERF_SAMPLE_BRANCH_ANY_CALL	= 1U << 3, /* any call branch */
> +	PERF_SAMPLE_BRANCH_ANY_RETURN	= 1U << 4, /* any return branch */
> +	PERF_SAMPLE_BRANCH_IND_CALL	= 1U << 5, /* indirect calls */
> +
> +	PERF_SAMPLE_BRANCH_MAX		= 1U << 6,/* non-ABI */
> +};
> +
> +#define PERF_SAMPLE_BRANCH_PLM_ALL \
> +	(PERF_SAMPLE_BRANCH_USER|\
> +	 PERF_SAMPLE_BRANCH_KERNEL)
> +
> +/*
>   * The format of the data returned by read() on a perf event fd,
>   * as specified by attr.read_format:
>   *
> @@ -240,6 +267,7 @@ struct perf_event_attr {
>  		__u64		bp_len;
>  		__u64		config2; /* extension of config1 */
>  	};
> +	__u64	branch_sample_type; /* enum branch_sample_type */
>  };
> 
>  /*
> @@ -458,6 +486,8 @@ enum perf_event_type {
>  	 *
>  	 *	{ u32			size;
>  	 *	  char                  data[size];}&& PERF_SAMPLE_RAW
> +	 *
> +	 *	{ u64 from, to, flags } lbr[nr];} && PERF_SAMPLE_BRANCH_STACK
>  	 * };
>  	 */
>  	PERF_RECORD_SAMPLE			= 9,
> @@ -530,12 +560,31 @@ struct perf_raw_record {
>  	void				*data;
>  };
> 
> +/*
> + * single taken branch record layout:
> + *
> + *      from: source instruction (may not always be a branch insn)
> + *        to: branch target
> + *   mispred: branch target was mispredicted
> + * predicted: branch target was predicted
> + *
> + * support for mispred, predicted is optional. In case it
> + * is not supported mispred = predicted = 0.
> + */
So the user level perf tools would check for ((mispred = 0) && (predicted = 0))
in a sample and report that its not supported by the HW PMU ? Point here is
that if its not supported we should say  "No HW support" rather than displaying
mispred = 0 and predicted = 0 (As this could be misleading)
>  struct perf_branch_entry {
> -	__u64				from;
> -	__u64				to;
> -	__u64				flags;
> +	__u64	from;
> +	__u64	to;
> +	__u64	mispred:1,  /* target mispredicted */
> +		predicted:1,/* target predicted */
> +		reserved:62;
>  };
> 
> +/*
> + * branch stack layout:
> + *  nr: number of taken branches stored in entries[]
> + *
> + * Note that nr can vary from sample to sample
> + */
>  struct perf_branch_stack {
>  	__u64				nr;
>  	struct perf_branch_entry	entries[0];
> @@ -566,7 +615,9 @@ struct hw_perf_event {
>  			unsigned long	event_base;
>  			int		idx;
>  			int		last_cpu;
> +
>  			struct hw_perf_event_extra extra_reg;
> +			struct hw_perf_event_extra branch_reg;
>  		};
>  		struct { /* software */
>  			struct hrtimer	hrtimer;
> @@ -1003,12 +1054,14 @@ struct perf_sample_data {
>  	u64				period;
>  	struct perf_callchain_entry	*callchain;
>  	struct perf_raw_record		*raw;
> +	struct perf_branch_stack	*br_stack;
>  };
> 
>  static inline void perf_sample_data_init(struct perf_sample_data *data, u64 addr)
>  {
>  	data->addr = addr;
>  	data->raw  = NULL;
> +	data->br_stack = NULL;
>  }
> 
>  extern void perf_output_sample(struct perf_output_handle *handle,
> @@ -1147,6 +1200,11 @@ extern void perf_bp_event(struct perf_event *event, void *data);
>  # define perf_instruction_pointer(regs)	instruction_pointer(regs)
>  #endif
> 
> +static inline bool has_branch_stack(struct perf_event *event)
> +{
> +	return event->attr.sample_type & PERF_SAMPLE_BRANCH_STACK;
> +}
> +
>  extern int perf_output_begin(struct perf_output_handle *handle,
>  			     struct perf_event *event, unsigned int size);
>  extern void perf_output_end(struct perf_output_handle *handle);
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 91fb68a..ed39225 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3877,6 +3877,24 @@ void perf_output_sample(struct perf_output_handle *handle,
>  			}
>  		}
>  	}
> +
> +	if (sample_type & PERF_SAMPLE_BRANCH_STACK) {
> +		if (data->br_stack) {
> +			size_t size;
> +
> +			size = data->br_stack->nr
> +			     * sizeof(struct perf_branch_entry);
> +
> +			perf_output_put(handle, data->br_stack->nr);
> +			perf_output_copy(handle, data->br_stack->entries, size);
> +		} else {
> +			/*
> +			 * we always store at least the value of nr
> +			 */
> +			u64 nr = 0;
> +			perf_output_put(handle, nr);
> +		}
> +	}
>  }
> 
>  void perf_prepare_sample(struct perf_event_header *header,
> @@ -3919,6 +3937,15 @@ void perf_prepare_sample(struct perf_event_header *header,
>  		WARN_ON_ONCE(size & (sizeof(u64)-1));
>  		header->size += size;
>  	}
> +
> +	if (sample_type & PERF_SAMPLE_BRANCH_STACK) {
> +		int size = sizeof(u64); /* nr */
> +		if (data->br_stack) {
> +			size += data->br_stack->nr
> +			      * sizeof(struct perf_branch_entry);
> +		}
> +		header->size += size;
> +	}
>  }
> 
>  static void perf_event_output(struct perf_event *event,
> @@ -5898,6 +5925,37 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
>  	if (attr->read_format & ~(PERF_FORMAT_MAX-1))
>  		return -EINVAL;
> 
> +	if (attr->sample_type & PERF_SAMPLE_BRANCH_STACK) {
> +		u64 mask = attr->branch_sample_type;
> +
> +		/* only using defined bits */
> +		if (mask & ~(PERF_SAMPLE_BRANCH_MAX-1))
> +			return -EINVAL;
> +
> +		/* at least one branch bit must be set */
> +		if (!(mask & ~PERF_SAMPLE_BRANCH_PLM_ALL))
> +			return -EINVAL;
> +
> +		/* kernel level capture */
> +		if ((mask & PERF_SAMPLE_BRANCH_KERNEL)
> +		    && perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
> +			return -EACCES;
> +
> +		/* propagate priv level, when not set for branch */
> +		if (!(mask & PERF_SAMPLE_BRANCH_PLM_ALL)) {
> +
> +			/* exclude_kernel checked on syscall entry */
> +			if (!attr->exclude_kernel)
> +				mask |= PERF_SAMPLE_BRANCH_KERNEL;
> +
> +			if (!attr->exclude_user)
> +				mask |= PERF_SAMPLE_BRANCH_USER;
Why we are not taking care for attr->exclude_hv ? Should not we define
PERF_SAMPLE_BRANCH_HV for hyper-visor level branches ?
> +			/*
> +			 * adjust user setting (for HW filter setup)
> +			 */
> +			attr->branch_sample_type = mask;
> +		}
> +	}
>  out:
>  	return ret;
> 


-- 
Linux Technology Centre
IBM Systems and Technology Group
Bangalore India

