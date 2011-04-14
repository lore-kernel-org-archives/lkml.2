Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369Ab1DNSqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:46:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35753 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019Ab1DNSp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 14:45:58 -0400
Date: Thu, 14 Apr 2011 20:45:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, Lin Ming <ming.m.lin@intel.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf, x86: fix unknown NMIs on a Pentium4 box
Message-ID: <20110414184540.GC16064@elte.hu>
References: <4DA70950.3060102@openvz.org>
 <20110414174327.GA8863@elte.hu>
 <20110414183231.GN16939@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110414183231.GN16939@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> On Thu, Apr 14, 2011 at 07:43:27PM +0200, Ingo Molnar wrote:
> > 
> > * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > 
> > > --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event.c
> > > +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
> > > @@ -1370,9 +1370,16 @@ perf_event_nmi_handler(struct notifier_b
> > >  		return NOTIFY_DONE;
> > >  	}
> > > 
> > > -	apic_write(APIC_LVTPC, APIC_DM_NMI);
> > > 
> > >  	handled = x86_pmu.handle_irq(args->regs);
> > > +
> > > +	/*
> > > +	 * Note the unmasking of LVTPC entry must be
> > > +	 * done *after* counter oveflow flag is cleared
> > > +	 * otherwise it might lead to double NMIs generation.
> > > +	 */
> > > +	apic_write(APIC_LVTPC, APIC_DM_NMI);
> > > +
> > >  	if (!handled)
> > >  		return NOTIFY_DONE;
> > > 
> > 
> > This breaks 'perf top' on Intel Nehalem and probably other CPUs. The NMI gets 
> > stuck fast on all CPUs:
> > 
> >   NMI: 16 6 3 3 3 3 3 3 3 3 3 3 3 3 4 5 Non-maskable interrupts
> 
> Damn it, I was working on getting there.  First I did P4s, now I was working 
> on acme's core2 issues.  Nehalem was next on my list, I swear! :-)))))
> 
> So this sucks.  I'll grab a Nehalem and see what went wrong.  It's probably 
> because of the other 'this seems to work' hacks I put in that handler.  I bet 
> if I clean those up, this problem will be fixed.
> 
> I will note that using my patch on a core2quad system, lowered the number of 
> back-to-back NMIs I was seeing when running a couple of perf records and a 
> make -j8 (still generates unknown NMIs though :-( ).

Here's the cpuinfo:

processor	: 15
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Xeon(R) CPU           X55600 @ 2.80GHz
stepping	: 5
cpu MHz		: 2794.000
cache size	: 8192 KB
physical id	: 1
siblings	: 8
core id		: 3
cpu cores	: 4
apicid		: 23
initial apicid	: 23
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm ida dts tpr_shadow vnmi flexpriority ept vpid
bogomips	: 5599.19
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

just in case you have trouble reproducing the problem.

Thanks,

	Ingo
