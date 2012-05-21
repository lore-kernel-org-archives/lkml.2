Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab2EUNTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 09:19:40 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55418 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487Ab2EUNTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 09:19:39 -0400
Date: Mon, 21 May 2012 15:19:32 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, eranian@google.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com
Subject: Re: [PATCH 04/17] perf: Add ability to attach user stack dump to
 sample
Message-ID: <20120521131930.GC23687@somewhere>
References: <1335958638-5160-1-git-send-email-jolsa@redhat.com>
 <1335958638-5160-5-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335958638-5160-5-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 01:37:05PM +0200, Jiri Olsa wrote:
> Introducing new sample_type bit PERF_SAMPLE_STACK. Once set,
> the sample_stack value determines the stack which is going
> to be attached.
> 
> Currently only user level stack is supported, specified by
> PERF_SAMPLE_STACK_USER bit in sample_stack value. When set,
> the sample_stack_user value determines the size of the
> stack dump.
> 
> Beeing able to dump parts of the user stack, starting from the
> stack pointer, will be useful to make a post mortem dwarf CFI
> based stack unwinding.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  include/linux/perf_event.h |   20 ++++++++-
>  kernel/events/core.c       |  103 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 122 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index dcda0f16..2e5f486 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -131,8 +131,9 @@ enum perf_event_sample_format {
>  	PERF_SAMPLE_RAW				= 1U << 10,
>  	PERF_SAMPLE_BRANCH_STACK		= 1U << 11,
>  	PERF_SAMPLE_REGS			= 1U << 12,
> +	PERF_SAMPLE_STACK			= 1U << 13,
>  
> -	PERF_SAMPLE_MAX = 1U << 13,		/* non-ABI */
> +	PERF_SAMPLE_MAX = 1U << 14,		/* non-ABI */
>  };
>  
>  /*
> @@ -173,6 +174,15 @@ enum perf_sample_regs {
>  };
>  
>  /*
> + * Values for sample_stack when PERF_SAMPLE_STACK is set.
> + * Defines stack dump to be attached to the sample.
> + */
> +enum perf_sample_stack {
> +	PERF_SAMPLE_STACK_USER	= 1U << 0, /* user stack */
> +	PERF_SAMPLE_STACK_MAX	= 1U << 1, /* non-ABI */

Same problem than with regs, this doesn't allow several stack dumps types
in a single sample.

> +};
> +
> +/*
>   * The format of the data returned by read() on a perf event fd,
>   * as specified by attr.read_format:
>   *
> @@ -291,6 +301,14 @@ struct perf_event_attr {
>  	 * See asm/perf_regs.h for details.
>  	 */
>  	__u64	sample_regs_user;
> +
> +	__u64	sample_stack; /* enum perf_sample_stack */
> +
> +	/*
> +	 * Defines size of the user stack to dump on samples,
> +	 * for sample_stack PERF_SAMPLE_STACK_USER settings.
> +	 */
> +	__u64	sample_stack_user;

Do we need PERF_SAMPLE_STACK when we can already set 0 in sample_stack_user?
