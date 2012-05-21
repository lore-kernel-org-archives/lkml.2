Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab2EUNDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 09:03:52 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:61450 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247Ab2EUNDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 09:03:42 -0400
Date: Mon, 21 May 2012 15:03:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Cc: acme@redhat.com, mingo@kernel.org, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, eranian@google.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com
Subject: Re: [PATCH 02/17] perf: Add ability to attach registers dump to
 sample
Message-ID: <20120521130332.GB23687@somewhere>
References: <1335958638-5160-1-git-send-email-jolsa@redhat.com>
 <1335958638-5160-3-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335958638-5160-3-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 01:37:03PM +0200, Jiri Olsa wrote:
> Introducing new sample_type bit PERF_SAMPLE_REGS. Once set,
> the sample_regs value determines the kind of registers going
> to be attached to the sample.
> 
> Currently only user level registers are supported, specified by
> PERF_SAMPLE_REGS_USER sample_regs value. Meaning the register
> values of the user space context as it was before the user entered
> the kernel for whatever reason (syscall, irq, exception, or a PMI
> happening in userspace).
> 
> When PERF_SAMPLE_REGS and PERF_SAMPLE_REGS_USER are set, the
> sample_regs_user bitmap lets a user choose a set of registers
> to dump for the sample. The layout of this bitmap is described
> in asm/perf_regs.h for archs that support register dump.
> 
> This is going to be useful to bring Dwarf CFI based stack
> unwinding on top of samples.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  include/linux/perf_event.h |   25 ++++++++++-
>  kernel/events/core.c       |   98 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 121 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index ddbb6a9..6a8c974 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -130,8 +130,9 @@ enum perf_event_sample_format {
>  	PERF_SAMPLE_STREAM_ID			= 1U << 9,
>  	PERF_SAMPLE_RAW				= 1U << 10,
>  	PERF_SAMPLE_BRANCH_STACK		= 1U << 11,
> +	PERF_SAMPLE_REGS			= 1U << 12,

Given that we have to provide a reg mask anyway, is this sample type
necessary? Zeroed mask means we don't want to record regs.

>  
> -	PERF_SAMPLE_MAX = 1U << 12,		/* non-ABI */
> +	PERF_SAMPLE_MAX = 1U << 13,		/* non-ABI */
>  };
>  
>  /*
> @@ -163,6 +164,15 @@ enum perf_branch_sample_type {
>  	 PERF_SAMPLE_BRANCH_HV)
>  
>  /*
> + * Values for sample_regs when PERF_SAMPLE_REGS is set.
> + * Defines register set to be attached to the sample.
> + */
> +enum perf_sample_regs {
> +	PERF_SAMPLE_REGS_USER	= 1U << 0, /* user registers */
> +	PERF_SAMPLE_REGS_MAX	= 1U << 1, /* non-ABI */
> +};

If this is an enum, we won't be able to record multiple types of regs
(eg: user regs and event live regs) in a single sample.

> +
> +/*
>   * The format of the data returned by read() on a perf event fd,
>   * as specified by attr.read_format:
>   *
> @@ -271,7 +281,16 @@ struct perf_event_attr {
>  		__u64		bp_len;
>  		__u64		config2; /* extension of config1 */
>  	};
> -	__u64	branch_sample_type; /* enum branch_sample_type */
> +	__u64	branch_sample_type; /* enum perf_branch_sample_type */
> +
> +	__u64	sample_regs; /* enum perf_sample_regs */
> +
> +	/*
> +	 * Arch specific mask for PERF_SAMPLE_REGS_USER setup.
> +	 * Defines set of user regs to dump on samples.
> +	 * See asm/perf_regs.h for details.
> +	 */
> +	__u64	sample_regs_user;

We need to sort that out now. How do we handle normal/compat regs?
Do we want sample_regs_user_64 and sample_regs_user_32? Or can we
make it possible with a single field like above? Should we
expect more modes than just a simple native and compat? I don't
know much the world outside x86.

Would be nice to have the opinion of other people on this. Ingo, Peter, others?

Thanks.
