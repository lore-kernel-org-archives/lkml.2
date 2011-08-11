Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab1HKMTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 08:19:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36260 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab1HKMTK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 08:19:10 -0400
Subject: Re: [PATCH -tip v3 2/5] perf: change perf_event_header.misc to
 PERF_RECORD_MISC_USER for BTS
From: Peter Zijlstra <peterz@infradead.org>
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Paul Mackerras <paulus@samba.org>
Date: Thu, 11 Aug 2011 14:18:46 +0200
In-Reply-To: <20110811120620.5900.50427.stgit@linux3>
References: <20110811120555.5900.23642.stgit@linux3>
	 <20110811120620.5900.50427.stgit@linux3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313065126.7144.6.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 21:06 +0900, Akihiro Nagai wrote:
> Change perf_event_headder.misc to PERF_RECORD_MISC_USER for
> BTS records, because BTS traces both kernel and user spaces
> nevertheless perf specifies to trace only kernel or user space.

Now I'm confused..

If BTS traces both kernel and user, the MISC bit should reflect the
right state per-sample, on x86 that's easy enough to do by the address.


> ---
> 
>  arch/x86/kernel/cpu/perf_event_intel_ds.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> index 1b1ef3a..323f3f0 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -340,6 +340,14 @@ static int intel_pmu_drain_bts_buffer(void)
>  	 */
>  	perf_prepare_sample(&header, &data, event, &regs);
>  
> +	/*
> +	 * Since BTS can not trace kernel and user space separately, set

Uhm, IA32_DEBUGCTL_MSR.BTS_OFF_{OS,USR} seem to suggest it can?!

> +	 * PERF_RECORD_MISC_USER in header.misc to resolve both kernel and
> +	 * user DSOs and symbols.
> +	 */
> +	header.misc &= ~PERF_RECORD_MISC_CPUMODE_MASK;
> +	header.misc |= PERF_RECORD_MISC_USER;


So what's wrong with something like:

	header.misc |= is_kernel_address(at->from) ?
			PERF_RECORD_MISC_KERNEL :
			PERF_RECORD_MISC_USER;

>  	if (perf_output_begin(&handle, event, header.size * (top - at)))
>  		return 1;
>  
> 

