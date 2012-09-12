Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab2ILRmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:42:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:57314 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab2ILRl7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:41:59 -0400
Message-ID: <1347471714.15764.71.camel@twins>
Subject: Re: [RFC][PATCH] perf, intel: Don't touch MSR_IA32_DEBUGCTLMSR from
 NMI context
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Stephane Eranian <eranian@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, mingo@kernel.org
Date: Wed, 12 Sep 2012 19:41:54 +0200
In-Reply-To: <20120912173624.GA8902@redhat.com>
References: <1347466967.15764.63.camel@twins>
	 <20120912173624.GA8902@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 19:36 +0200, Oleg Nesterov wrote:
> On 09/12, Peter Zijlstra wrote:
> >
> > Oleg and Sebastian found that touching MSR_IA32_DEBUGCTLMSR from NMI
> > context is problematic since the only way to change the various
> > unrelated bits in there is:
> >
> >   debugctl = get_debugctlmsr()
> >   /* frob flags in debugctl */
> >   update_debugctlmsr(debugctl);
> >
> > Which is entirely unsafe if we prod at the MSR from NMI context.
> >
> > In particular the path that is responsible is:
> >
> >   x86_pmu_handle_irq() (NMI handler)
> >     x86_pmu_stop()
> >       x86_pmu.disable -> intel_pmu_disable_event()
> >         intel_pmu_lbr_disable()
> >           __intel_pmu_lbr_disable()
> >             wrmsrl(MSR_IA32_DEBUGCTLMSR,... );
> 
> Not only.
> 
> x86_pmu_handle_irq() does intel_pmu_disable_all() and intel_pmu_enable_all(),
> this leads to intel_pmu_enable_bts() and intel_pmu_disable_bts().
> 
> And those intel_pmu_*_bts() are also called by intel_pmu_disable_event()
> and intel_pmu_enable_event(), the latter is probably fine.

As written in the email to Stephane just now, the {dis,en}able_all()
things are symmetric and don't change the visible MSR state. But you're
right, I missed that BTS frobbed that MSR as well. 

I'll have to see if there's a DS programming that effectively disables
the BTS nonsense.

