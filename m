Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab1FELB4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 07:01:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50307 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655Ab1FELBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 07:01:55 -0400
Date: Sun, 5 Jun 2011 13:01:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arne Jansen <lists@die-jansens.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/locking] sched: Add p->pi_lock to task_rq_lock()
Message-ID: <20110605110132.GB23463@elte.hu>
References: <1306953870.2497.627.camel@laptop>
 <4DE6936F.7090700@die-jansens.de>
 <BANLkTimXXR1mJDtdCsbXF410sd3irFSitQ@mail.gmail.com>
 <1307092535.2353.2973.camel@twins>
 <4DE8B13D.9020302@die-jansens.de>
 <1307097052.2353.3061.camel@twins>
 <20110605081747.GA17920@elte.hu>
 <4DEB4FA7.3050400@die-jansens.de>
 <20110605095555.GA22058@elte.hu>
 <4DEB58D8.4000805@die-jansens.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEB58D8.4000805@die-jansens.de>
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


* Arne Jansen <lists@die-jansens.de> wrote:

> On 05.06.2011 11:55, Ingo Molnar wrote:
> >
> >* Arne Jansen<lists@die-jansens.de>  wrote:
> >
> >>>( Arne, please also double check on a working bootup that the NMI
> >>>   watchdog is actually ticking, by checking the NMI counts in
> >>>   /proc/interrupts go up slowly but surely on all CPUs. )
> >>
> >>It does, but _very_ slowly. Some CPUs do not count up for tens of
> >>minutes if the machine is idle. If I generate some load like 'make
> >>tags', the counters go up quite quickly.
> >>After 4 minutes and one 'make cscope' it looks like this:
> >>NMI:          8         13         43          5          2
> >>3        22          1   Non-maskable interrupts
> >>
> >>But I never see a single tick on console or in dmesg, even when I
> >>replace the early_printk with a printk.
> >
> >hm, that might be because the NMI watchdog uses halted cycles to
> >tick.
> >
> >That's not a problem (the kernel cannot lock up while there are no
> >cycles ticking) but nevertheless could you work this around please
> >by starting 8 infinite shell loops:
> >
> >    for ((i=0; i<8; i++)); do while : ; do : ; done&  done
> >
> >?
> >
> >This will saturate all cores and makes sure the NMI watchdog is
> >ticking everywhere.
> >
> >Hopefully this wont make the bug go away :-)
> >
> 
> OK, now we get going. I get the ticks, the bug is still there, and
> all CPUs still tick after the lockup. I also added an early_printk
> inside the lockup-if, and it reports hard lockups. At first for only
> one or 2 CPUs, and after some time all CPUs are locked up.

Very good!

If you add a dump_stack() do you get a stacktrace, or do the NMI 
watchdog ticks stop?

If the ticks stop this suggests a lockup within the printk code. If 
you get a stack dump then we'll have good debug data.

Thanks,

	Ingo
