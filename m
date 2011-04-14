Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab1DNIFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:05:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36114 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756421Ab1DNIFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:05:25 -0400
Date: Thu, 14 Apr 2011 10:05:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, maciej.rutecki@gmail.com,
        Shaun Ruffell <sruffell@digium.com>, Don Zickus <dzickus@redhat.com>,
        linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>
Subject: Re: [regression 2.6.39-rc2][bisected] "perf, x86: P4 PMU - Read
 proper MSR register to catch" and NMIs
Message-ID: <20110414080506.GA23965@elte.hu>
References: <20110406223036.GA15721@digium.com>
 <201104132133.51958.maciej.rutecki@gmail.com>
 <4DA6011F.7070405@openvz.org>
 <20110414064737.GB15535@elte.hu>
 <BANLkTinC18PetP=dzCsfOL_v_1hGv0jUag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinC18PetP=dzCsfOL_v_1hGv0jUag@mail.gmail.com>
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


* Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> On Thu, Apr 14, 2011 at 10:47 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> >
> >> -     apic_write(APIC_LVTPC, APIC_DM_NMI);
> >>
> >>       handled = x86_pmu.handle_irq(args->regs);
> >>       if (!handled)
> >>               return NOTIFY_DONE;
> >>
> >> +     /*
> >> +      * Unmasking should be done after IRQ handled, otherwise
> >> +      * there is a race between clearing of counter overflow
> >> +      * flag and LTV entry unmasking (which might lead to double
> >> +      * NMIs generation).
> >> +      */
> >> +     apic_write(APIC_LVTPC, APIC_DM_NMI);
> >
> > Here we could leak a masked IRQ through the !handled path. If we got a LVTPC
> > irq we better handle it and unmask the LVTPC unconditionally - regardless of
> > whether we consider it 'handled' or not from the kernel POV ...
> >
> > Thanks,
> >
> >        Ingo
> 
> If there is no counters overflowed I believe we should not poke LVTPC until 
> we sure NMI comes from it (and counter overflow is the only sign that NMI 
> came from LVTPC as far as I may say, and I see also a possibility for race if 
> counter signal reaches LVTPC and it is being processed inside apic chip 
> {which might take some time too before real NMI signal appears in cpu} and as 
> result hard to tell what we get in output -- double nmi again or something 
> else).

Well, we unmasked unconditionally before. If we unmask conditionally now, we 
risk not unmasking. We risk a completely stuck PMU (there wont ever come *any* 
NMI from it if we ever forget to unmask) versus spurious NMIs.

Maybe we can do it - but it will need a lot of testing on a lot of CPU types to 
make sure there's no other CPU quirks in this area ...

So unless the conditional unmasking fixes a real bug (in kgdb or elsewhere) 
lets unmask unconditionally now to fix the P4 regression in .39 - and queue up 
a *separate* patch that moves it even further down and makes it conditional - 
but queue that up for .40.

Thanks,

	Ingo
