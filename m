Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab1FGNQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 09:16:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39792 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab1FGNQp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 09:16:45 -0400
Subject: Re: [tip:sched/urgent] sched: Fix cross-cpu clock sync on remote
 wakeups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Borislav Petkov <bp@amd64.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>, Borislav Petkov <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "markus@trippelsdorf.de" <markus@trippelsdorf.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
In-Reply-To: <20110607131216.GC27813@aftab>
References: <tip-f01114cb59d670e9b4f2c335930dd57db96e9360@git.kernel.org>
	 <20110531125621.GA24439@gere.osrc.amd.com> <1306847516.2353.80.camel@twins>
	 <20110601070547.GB3368@liondog.tnic> <1306924612.2353.176.camel@twins>
	 <20110601155017.GD24028@aftab>
	 <BANLkTikT6OT-HDi-DR+_ZWEhfp_CYWJ3Hg@mail.gmail.com>
	 <1307019866.2497.675.camel@laptop> <20110602142340.GA3356@zhy>
	 <1307029711.2497.717.camel@laptop>  <20110607131216.GC27813@aftab>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 07 Jun 2011 15:16:20 +0200
Message-ID: <1307452580.2322.252.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 15:12 +0200, Borislav Petkov wrote:
> On Thu, Jun 02, 2011 at 11:48:31AM -0400, Peter Zijlstra wrote:
> > Crap.. you're right. And I bet other archs don't do that either. With
> > NO_HZ you really need irq_enter() for pretty much all interrupts so I
> > was assuming the resched IPI had it, but its been special and never
> > really needed it. If it would wake an idle cpu the idle loop exit would
> > deal with it, if it interrupted userspace the thing was running and
> > NO_HZ wasn't relevant.
> > 
> > Damn. 
> > 
> > And yes, the only reason I didn't see this on my dev box was because we
> > do indeed set that sched_clock_stable thing on wsm. And I never noticed
> > on my desktop because firefox/X/etc. consuming heaps of CPU isn't weird
> > at all.
> > 
> > Adding it to all resched int handlers is of course a possibility but
> > would slow down the thing, although with the new code, most users are
> > now indeed wakeups (excepting weird and wonderful users like KVM).
> 
> FWIW, we could set the sched_clock_stable on AMD too - at least on F10h
> and later. This will take care of the problem at hand and defer the
> issue of slowing down the resched ipi handlers.
> 
> I dunno, however, whether we still would need the proper ->tick_gtod
> update for correct ttwu accounting regardless of sched_clock_stable on
> K8 (unstable TSCs) and maybe even other arches.

Yeah, I think I'm going to commit this extra irq_enter() thing for now,
and then slowly go through all the arches again and remove this one here
once all archs are sorted.


