Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab2IMKXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:23:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:42392 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648Ab2IMKXR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:23:17 -0400
Message-ID: <1347531789.15764.124.camel@twins>
Subject: Re: [RFC][PATCH] perf, intel: Don't touch MSR_IA32_DEBUGCTLMSR from
 NMI context
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, mingo@kernel.org
Date: Thu, 13 Sep 2012 12:23:09 +0200
In-Reply-To: <1347466967.15764.63.camel@twins>
References: <1347466967.15764.63.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 18:22 +0200, Peter Zijlstra wrote:
> Oleg and Sebastian found that touching MSR_IA32_DEBUGCTLMSR from NMI
> context is problematic since the only way to change the various
> unrelated bits in there is:
> 
>   debugctl = get_debugctlmsr()
>   /* frob flags in debugctl */
>   update_debugctlmsr(debugctl);
> 
> Which is entirely unsafe if we prod at the MSR from NMI context.
> 
> In particular the path that is responsible is:
> 
>   x86_pmu_handle_irq() (NMI handler)
>     x86_pmu_stop()
>       x86_pmu.disable -> intel_pmu_disable_event()
>         intel_pmu_lbr_disable()
>           __intel_pmu_lbr_disable()
>             wrmsrl(MSR_IA32_DEBUGCTLMSR,... );
> 
> So remove intel_pmu_lbr_{en,dis}able() from
> intel_pmu_{en,dis}able_event() and stick them in
> intel_{get,put}_event_constraints() which are only ever called from
> regular contexts.
> 
> We combine intel_pmu_needs_lbr_smpl(), which tells us if the events
> wants LBR data, with event->hw.branch_reg.alloc, which given
> intel_shared_regs_constraints() is set if our event got the shared
> resource, to give us a correctly balanced condition in
> {get,put}_event_constraints() for intel_pmu_lbr_{en,dis}able().
> 
> Also change core_pmu to only use x86_get_event_constraints since it
> doesn't support any of the fancy DS (BTS,PEBS), LBR and OFFCORE features
> that make up intel_{get,put}_event_constraints. 

OK, so with the added stipulation that touching the MSR from the NMI
isn't a problem as long as we ensure we leave the MSR in the same state
that we found it in, and the above is the only path found so far that
could cause this to be violated, the patch is fine?

In particular we could note that both LBR and BTS use the DEBUGCTL MSR,
but BTS doesn't throttle, so the LBR code is the only thing needing
attention as per the above description.


