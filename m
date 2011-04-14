Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161Ab1DNSdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:33:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932844Ab1DNSc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 14:32:57 -0400
Date: Thu, 14 Apr 2011 14:32:31 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, Lin Ming <ming.m.lin@intel.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf, x86: fix unknown NMIs on a Pentium4 box
Message-ID: <20110414183231.GN16939@redhat.com>
References: <4DA70950.3060102@openvz.org>
 <20110414174327.GA8863@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110414174327.GA8863@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 07:43:27PM +0200, Ingo Molnar wrote:
> 
> * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
> > --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event.c
> > +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
> > @@ -1370,9 +1370,16 @@ perf_event_nmi_handler(struct notifier_b
> >  		return NOTIFY_DONE;
> >  	}
> > 
> > -	apic_write(APIC_LVTPC, APIC_DM_NMI);
> > 
> >  	handled = x86_pmu.handle_irq(args->regs);
> > +
> > +	/*
> > +	 * Note the unmasking of LVTPC entry must be
> > +	 * done *after* counter oveflow flag is cleared
> > +	 * otherwise it might lead to double NMIs generation.
> > +	 */
> > +	apic_write(APIC_LVTPC, APIC_DM_NMI);
> > +
> >  	if (!handled)
> >  		return NOTIFY_DONE;
> > 
> 
> This breaks 'perf top' on Intel Nehalem and probably other CPUs. The NMI gets 
> stuck fast on all CPUs:
> 
>   NMI: 16 6 3 3 3 3 3 3 3 3 3 3 3 3 4 5 Non-maskable interrupts

Damn it, I was working on getting there.  First I did P4s, now I was
working on acme's core2 issues.  Nehalem was next on my list, I swear! :-)))))

So this sucks.  I'll grab a Nehalem and see what went wrong.  It's
probably because of the other 'this seems to work' hacks I put in that
handler.  I bet if I clean those up, this problem will be fixed.

I will note that using my patch on a core2quad system, lowered the number
of back-to-back NMIs I was seeing when running a couple of perf records
and a make -j8 (still generates unknown NMIs though :-( ).

Cheers,
Don

