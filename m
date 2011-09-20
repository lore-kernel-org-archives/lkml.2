Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab1ITQvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:51:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:41871 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab1ITQvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:51:47 -0400
Date: Tue, 20 Sep 2011 18:51:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Lameter <cl@gentwo.org>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [RFC][PATCH 2/5] mm: Switch mod_state() to __this_cpu_read()
In-Reply-To: <alpine.DEB.2.00.1109201059590.8056@router.home>
Message-ID: <alpine.LFD.2.02.1109201806220.2723@ionos>
References: <20110919212040.745370781@goodmis.org> <20110919212640.688732950@goodmis.org> <alpine.DEB.2.00.1109191657150.19059@router.home> <alpine.LFD.2.02.1109201334590.2723@ionos> <alpine.DEB.2.00.1109200947100.8056@router.home> <alpine.LFD.2.02.1109201703560.2723@ionos>
 <alpine.DEB.2.00.1109201059590.8056@router.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011, Christoph Lameter wrote:

> On Tue, 20 Sep 2011, Thomas Gleixner wrote:
> > I want to get rid of them alltogether. They are crap by design and
> > prone to be used wrong without a sensible way to detect that.
> 
> Counter increments have been done this way for a very long time. This is
> a pretty well established way of doing things in the kernel that was
> expanded and made better by avoid preempt disable/enable around these per
> cpu pointer increments.

This still can be done, when the functions are actually having
sensible names and annotations.

> > Right, and that's the main problem. We have no fricking way to debug
> > this, so they should have never been there in the first place. And you
> > simply CANNOT prevent people from getting this wrong w/o proper
> > debugging and annotation. Even YOU and Tejun made bogus conversion w/o
> > noticing, but you expect that others get it right?
> 
> Bogus conversions?

Is the list I posted not enough?

The usage of this_cpu_read() in functions which require to be called
with preemption or interrupts disabled is pointless and worse it
actually removed debug functionality in some places which used
smp_processor_id() before.

I do not care at all whether this_cpu_read() on x86 does not have the
preempt_enable/disable() pair, but I care a lot about the correctness
of the code and debugability.

> > So stop defending that trainwreck and help out with fixing the mess
> > you created in a proper and debugable way!
> 
> You want debugging to ensure that this_cpu ops always access the intended
> per cpu area? But the point of these operations is to be used in kernel
> locations where the use of any per cpu area is satisfactory.

The point is that the whole design assumes that people get it correct
and you spent not a split second to provide any means of debugability
for this. Now you argue in circles about your performance numbers and
let others deal with the fallout and refuse to think about a sensible
solution to the problem.

It does not matter at all what you intended and what people should do,
but it does matter very much what unintentional and undebugable
wreckage can be caused by it.

We spent huge efforts to make locks debugable and we still have people
getting it wrong and you expect that something as complex as the per
cpu stuff is just correct by definition.

And the problem of this_cpu & co starts with the naming convention.

this_cpu_*() is patently wrong. It should be: random_cpu_*() or
any_cpu_*(). This way you could have avoided confusion in the first
place and made it entirely clear what the interfaces are about.

Thanks,

	tglx
