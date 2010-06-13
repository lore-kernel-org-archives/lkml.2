Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab0FMByM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 21:54:12 -0400
Received: from mga14.intel.com ([143.182.124.37]:47582 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab0FMByL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 21:54:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,409,1272870000"; 
   d="scan'208";a="288238572"
Subject: Re: [RFC 1/3] Unified NMI delayed call mechanism
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100612102558.GA4000@elte.hu>
References: <1276334896-7075-1-git-send-email-ying.huang@intel.com>
	 <20100612102558.GA4000@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Jun 2010 09:54:08 +0800
Message-ID: <1276394048.3004.82.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-06-12 at 18:25 +0800, Ingo Molnar wrote:
> * Huang Ying <ying.huang@intel.com> wrote:
> 
> > NMI can be triggered even when IRQ is masked. So it is not safe for NMI 
> > handler to call some functions. One solution is to delay the call via self 
> > interrupt, so that the delayed call can be done once the interrupt is 
> > enabled again. This has been implemented in MCE and perf event. This patch 
> > provides a unified version and make it easier for other NMI semantic handler 
> > to take use of the delayed call.
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > ---
> >  arch/x86/include/asm/entry_arch.h  |    1 
> >  arch/x86/include/asm/hw_irq.h      |    1 
> >  arch/x86/include/asm/irq_vectors.h |    5 +
> >  arch/x86/include/asm/nmi.h         |    7 ++
> >  arch/x86/kernel/entry_64.S         |    3 +
> >  arch/x86/kernel/irqinit.c          |    3 +
> >  arch/x86/kernel/traps.c            |  104 +++++++++++++++++++++++++++++++++++++
> >  7 files changed, 124 insertions(+)
> 
> Instead of introducing this extra intermediate facility please use the same 
> approach the unified NMI watchdog is using (see latest -tip): a perf event 
> callback gives all the extra functionality needed.

Sorry, if my understanding is correct, the perf event overflow callback
should be run in NMI context instead of a delayed context (such as IRQ,
soft_irq, process context). That is, the backtrace of
watchdog_overflow_callback should be something as follow:

x86_pmu_handle_irq
  perf_event_overflow
    __perf_event_overflow
      watchdog_overflow_callback

I do not find the delayed mechanism here.

> The MCE code needs to be updated to use that - and then it will be integrated
> into the events framework.

MCE is NMI-like, and there are other NMI users too. I think some of them
will need some kind of delayed call mechanism. In fact, perf itself uses
self-made NMI delayed call mechanism too, I just want to generalize it
for other users too.

Best Regards,
Huang Ying


