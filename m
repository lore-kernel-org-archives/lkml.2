Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab1FCKgc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 06:36:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:45175 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab1FCKgb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 06:36:31 -0400
Subject: Re: [tip:sched/urgent] sched: Fix cross-cpu clock sync on remote
 wakeups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Milton Miller <miltonm@bga.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>, Borislav Petkov <bp@amd64.org>,
        Borislav Petkov <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "markus@trippelsdorf.de" <markus@trippelsdorf.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
In-Reply-To: <schedulerIPIirqEnter@mdm.bga.com>
References: <1307029711.2497.717.camel@laptop>
	 <1306835745.2353.3.camel@twins>
	 <tip-f01114cb59d670e9b4f2c335930dd57db96e9360@git.kernel.org>
	 <20110531125621.GA24439@gere.osrc.amd.com> <1306847516.2353.80.camel@twins>
	 <20110601070547.GB3368@liondog.tnic> <1306924612.2353.176.camel@twins>
	 <20110601155017.GD24028@aftab>
	 <BANLkTikT6OT-HDi-DR+_ZWEhfp_CYWJ3Hg@mail.gmail.com>
	 <1307019866.2497.675.camel@laptop> <20110602142340.GA3356@zhy>
	 <schedulerIPIirqEnter@mdm.bga.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Jun 2011 12:36:00 +0200
Message-ID: <1307097360.2353.3071.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-03 at 04:57 -0500, Milton Miller wrote:

> [me looks closely at patch and finds early return]

Yeah, in case there's nothing to do, all the old conditions hold and
irq_enter isn't strictly required.

> > 
> > We could of course add it in sched.c since the logic recurses just
> > fine.. its not pretty though.. :/
> > 
> > Thoughts?
> 
> 
> Many architectures already have an irq_enter becuase they have a single
> interrupt to the cpu for all external causes including software; they
> do the irq_enter before reading from the irq controller to know the
> reason for the interrupt.  A quick glance at irq_enter and irq_exit
> shows they will do several things twice when nested, even if that
> is safe.

Agreed, and its a worry I had. The flip side is that doing it in the
arch code means I have to audit all the archs again (not that I mind too
much, but it takes a wee bit longer), also I'll have to look at all the
code using this IPI for the old purpose.

> Are there really that many calls with the empty list that it makes
> sense to avoid and optimize this on x86 while penalizing the several
> architectures with a nested irq_enter and exit?

I _think_ the now predominant case is this remote wakeup, so adding
irq_enter() to all arch paths isn't too big of a problem, but I need to
make sure.

>   When it also duplicates
> sched_ttwu_pending (because it can't be common with the additional tests)?

yeah, sad that.

> We said the perf mon callback (now irq_work) had to be under irq_enter.

Correct, anything that actually does something in the handler needs
irq_enter, the problem with the resched ipi was that it never actually
did anything and the idle loop exit took care of the no_hz funnies.

> Can we get some numbers for how often the two cases occur on some
> various workloads?

Sure, let me stick some counters in.
