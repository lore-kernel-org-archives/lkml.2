Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab2DFXaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 19:30:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:40535 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399Ab2DFXaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 19:30:07 -0400
Date: Sat, 7 Apr 2012 01:29:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Prarit Bhargava <prarit@redhat.com>
cc: John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
        Salman Qazi <sqazi@google.com>, stable@kernel.org
Subject: Re: [PATCH] clocksource, prevent overflow in clocksource_cyc2ns
In-Reply-To: <4F7D8FA1.1010107@redhat.com>
Message-ID: <alpine.LFD.2.02.1204070107370.2542@ionos>
References: <1333552260-1170-1-git-send-email-prarit@redhat.com> <4F7C8C3E.1020203@us.ibm.com> <4F7C9402.3090602@redhat.com> <4F7CF094.5020201@us.ibm.com> <4F7D8FA1.1010107@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2012, Prarit Bhargava wrote:

> > 
> > So what kernel version are you using?
> 
> I retested using top of the linux.git tree, running
> 
> echo 1 > /proc/sys/kernel/sysrq
> for i in `seq 10000`; do sleep 1000 & done
> echo t > /proc/sysrq-trigger
> 
> and I no longer see a problem.  However, if I increase the number of threads to
> 1000/cpu I get
> 
> Clocksource %s unstable (delta = -429565427)
> Clocksource switching to hpet

You are issuing a command which puts the kernel into a state where is
dumps data for several seconds with interrupts disabled. And you expect that
everything can cope with that?
 
> If I hack in (sorry for the cut-and-paste)
> ....
> +               cs_nsec = mult_frac(((csnow - cs->cs_last), cs->mult,
> +                                   1UL << cs->shift);
> 
> -               cs_nsec = clocksource_cyc2ns((csnow - cs->cs_last) &
> -                                            cs->mask, cs->mult, cs->shift);
> then I don't see unstable messages.

That does not make your approach more correct. The HPET wraparound
time is ~3 seconds, so you screwed everything already, when your dump
lasts longer than that. And there are clocksources which wrap way
faster.

No, you can't fix that by hacking the timer code. A wraparound CANNOT
be fixed by hacks.

So instead of fiddling in the victims, please fix the root cause,
i.e. that stupid sysrq-t code which should not need to have interrupts
disabled just to dump all that state. If that's not possible, send a
patch to the sysrq documentation and warn about the consequences.

But stay away from code which is correct already. You CANNOT fix a
problem which is caused by abnormal system state by hacking the code
which is exposing the problem.

All you do is making hot pathes more expensive with a very dubious
value. The time related calls are hotpath functions and optimized.

Aside of that you are breaking all architectures which do not have a
native 64/32 instruction.

This mult_frac stuff is not going to happen, period.

Thanks,

	tglx
