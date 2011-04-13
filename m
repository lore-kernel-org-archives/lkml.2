Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609Ab1DMUfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 16:35:20 -0400
Received: from mail.digium.com ([216.207.245.2]:37140 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757636Ab1DMUfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 16:35:14 -0400
Date: Wed, 13 Apr 2011 15:35:01 -0500
From: Shaun Ruffell <sruffell@digium.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: maciej.rutecki@gmail.com, Don Zickus <dzickus@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>
Subject: Re: [regression 2.6.39-rc2][bisected] "perf, x86: P4 PMU - Read
	proper MSR register to catch" and NMIs
Message-ID: <20110413203501.GA10744@digium.com>
References: <20110406223036.GA15721@digium.com> <201104132133.51958.maciej.rutecki@gmail.com> <4DA6011F.7070405@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA6011F.7070405@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 12:01:35AM +0400, Cyrill Gorcunov wrote:
> On 04/13/2011 11:33 PM, Maciej Rutecki wrote:
>> I created a Bugzilla entry at 
>> https://bugzilla.kernel.org/show_bug.cgi?id=33252
>> for your bug report, please add your address to the CC list in there, thanks!
> 
> Here is a patch flying around which I tuned a bit, when all reporters confirm it
> works for them we could close the bug. Thanks.
> 
>  Cyrill
> -- 
> From: Don Zickus <dzickus@redhat.com>
> Subject: [PATCH] perf, x86: fix unknown NMIs on a Pentium4 box v2
> 
> When using perf on a Pentium4 box, lots of unknown NMIs would be generated.
> This is the result of a P4 quirk that is subtle.  The P4 generates an NMI
> when the counter overflow and unlike other arches where the NMI is a one time
> event, the P4 continues to assert its NMI until clear by the OS.
> 
> As a side effect to this quirk, the NMI on the apic is masked off to prevent
> a stream of NMIs until the overflow flag is cleared.  During the perf
> re-design, this subtle-ness was overlooked and the apic was unmasked _before_
> the overflow flag was cleared.  As a result, this generated an extra NMI on
> the P4 mchines.
> 
> The fix is trivial, wait until the NMI is properly handled before un-masking
> the apic.
> 
> Sadly, in the old nmi watchdog there was a note that explained this exact
> behaviour.
> 
> v2: Unmask LVT entry iif IRQ being handled by perf subsystem and add a comment.
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
> 
> Don, Shaun, Ming, I've tested it on my non-HT machine, so if you have a chance
> to test it on HT machine -- this would be a great thing!
> 
> Don, note the version v2 changes, thanks. I've tuned the former a bit
> but left your From field untouched, are you OK with that?
> 
>  arch/x86/kernel/cpu/perf_event.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event.c
> +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
> @@ -1370,12 +1370,19 @@ perf_event_nmi_handler(struct notifier_b
>  		return NOTIFY_DONE;
>  	}
> 
> -	apic_write(APIC_LVTPC, APIC_DM_NMI);
> 
>  	handled = x86_pmu.handle_irq(args->regs);
>  	if (!handled)
>  		return NOTIFY_DONE;
> 
> +	/*
> +	 * Unmasking should be done after IRQ handled, otherwise
> +	 * there is a race between clearing of counter overflow
> +	 * flag and LTV entry unmasking (which might lead to double
> +	 * NMIs generation).
> +	 */
> +	apic_write(APIC_LVTPC, APIC_DM_NMI);
> +
>  	this_nmi = percpu_read(irq_stat.__nmi_count);
>  	if ((handled > 1) ||
>  		/* the next nmi could be a back-to-back nmi */

I had the first version of the patch running the test builds all night without
any NMIs. I installed this one and ran it through the case where I would
reliably get early NMIs and it still no NMIs.

So for v2:
Tested-by: Shaun Ruffell <sruffell@digium.com>

Thanks!
