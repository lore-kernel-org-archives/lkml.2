Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760956Ab2C3Omz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 10:42:55 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33114 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759174Ab2C3Oms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 10:42:48 -0400
Date: Fri, 30 Mar 2012 16:42:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, eranian@google.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, rostedt@goodmis.org,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/15] perf: Add ability to dump user regs
Message-ID: <20120330144237.GG13022@somewhere.redhat.com>
References: <1332938158-5244-1-git-send-email-jolsa@redhat.com>
 <1332938158-5244-5-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332938158-5244-5-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 02:35:47PM +0200, Jiri Olsa wrote:
> Add new attr->user_regs bitmap that lets a user choose a set
> of user registers to dump to the sample. The layout of this
> bitmap is described in asm/perf_regs.h for archs that
> support CONFIG_HAVE_PERF_REGS_DEFS, otherwise the perf
> syscall will fail if attr->user_regs is non zero.
> 
> The register value here are those of the user space context as
> it was before the user entered the kernel for whatever reason
> (syscall, irq, exception, or a PMI happening in userspace).
> 
> This is going to be useful to bring Dwarf CFI based stack unwinding
> on top of samples.
> 
> FIXME: the issue of compat regs has yet to be solved. I think we
> need to split the regs bitmap in:
> 
> 	attr->user_regs32
> 	attr->user_regs64
> 
> So that userspace doesn't need to care about beeing a compat task or
> not, running on a 32 bits kernel or not, it can provide both bitmaps
> and let the kernel handle that, ignore user_regs64 if it is a 32 bits
> kernel, handle it otherwise and also user_regs32 for compat tasks,
> etc...
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  include/linux/perf_event.h |   26 ++++++++++++++++++
>  kernel/events/core.c       |   61 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 87 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index ddbb6a9..9f3df6e 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -272,6 +272,12 @@ struct perf_event_attr {
>  		__u64		config2; /* extension of config1 */
>  	};
>  	__u64	branch_sample_type; /* enum branch_sample_type */
> +
> +	/*
> +	 * Arch specific mask that defines a set of user regs to dump on
> +	 * samples. See asm/perf_regs.h for details.
> +	 */
> +	__u64			user_regs;
>  };
>  
>  /*
> @@ -1079,6 +1085,25 @@ struct perf_output_handle {
>  
>  #ifdef CONFIG_PERF_EVENTS
>  
> +#ifdef CONFIG_HAVE_PERF_REGS_DEFS
> +#include <asm/perf_regs.h>
> +#else
> +static inline int perf_reg_value(struct pt_regs *regs, int idx)
> +{
> +	return 0;
> +}
> +
> +static inline int perf_reg_version(void)
> +{
> +	return -EINVAL;
> +}
> +
> +static inline int perf_reg_validate(u64 mask)
> +{
> +	return -ENOSYS;
> +}
> +#endif /*CONFIG_HAVE_PERF_REGS_DUMP */
> +
>  extern int perf_pmu_register(struct pmu *pmu, char *name, int type);
>  extern void perf_pmu_unregister(struct pmu *pmu);
>  
> @@ -1130,6 +1155,7 @@ struct perf_sample_data {
>  	struct perf_callchain_entry	*callchain;
>  	struct perf_raw_record		*raw;
>  	struct perf_branch_stack	*br_stack;
> +	struct pt_regs			*uregs;
>  };
>  
>  static inline void perf_sample_data_init(struct perf_sample_data *data, u64 addr)
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index a6a9ec4..57f63fe 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3751,6 +3751,37 @@ int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
>  }
>  EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);
>  
> +static void
> +perf_output_sample_regs(struct perf_output_handle *handle,
> +			struct pt_regs *regs, u64 mask)
> +{
> +	int i = 0;
> +
> +	do {
> +		u64 val;
> +
> +		if (mask & 1) {
> +			val = perf_reg_value(regs, i);
> +			perf_output_put(handle, val);
> +		}
> +
> +		mask >>= 1;
> +		i++;
> +	} while (mask);
> +}
> +
> +static struct pt_regs *perf_sample_uregs(struct pt_regs *regs)
> +{
> +	if (!user_mode(regs)) {
> +		if (current->mm)
> +			regs = task_pt_regs(current);
> +		else
> +			regs = NULL;
> +	}
> +
> +	return regs;
> +}
> +
>  static void __perf_event_header__init_id(struct perf_event_header *header,
>  					 struct perf_sample_data *data,
>  					 struct perf_event *event)
> @@ -4011,6 +4042,22 @@ void perf_output_sample(struct perf_output_handle *handle,
>  			perf_output_put(handle, nr);
>  		}
>  	}
> +
> +	if (event->attr.user_regs) {
> +		u64 id;
> +
> +		/* If there is no regs to dump, notice it through a 0 version */
> +		if (!data->uregs) {
> +			id = 0;
> +			perf_output_put(handle, id);
> +		} else {
> +
> +			id = perf_reg_version();
> +			perf_output_put(handle, id);

I have the feeling we don't need this arch version thing.
Depending on the current task, whether it is a 32, compat or 64,
let the arch return the right reg value requested.

Then let the perf tools look at the elf headers of the dsos to find out the
architecture (32 - 64) of a task. On top of that we can know what we are dealing
with.
