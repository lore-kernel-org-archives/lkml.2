Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab0HXUjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 16:39:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43382 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436Ab0HXUji convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 16:39:38 -0400
Subject: Re: [PATCH 0/4] Finer granularity and task/cgroup irq time
 accounting
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: balbir@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Menage <menage@google.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>,
        ikael Starvik <starvik@axis.com>, dhowells <dhowells@redhat.com>
In-Reply-To: <AANLkTi=QuD7v1PP9PaJt_Dz1N-JKC1e6km1TE_YE6iJk@mail.gmail.com>
References: <1279583835-22854-1-git-send-email-venki@google.com>
	 <20100720095546.2f899e04@mschwide.boeblingen.de.ibm.com>
	 <AANLkTiktBNr3pVOHwxX3piwagtkGxHpp5TepBFS3UGhb@mail.gmail.com>
	 <20100722131239.208d9501@mschwide.boeblingen.de.ibm.com>
	 <AANLkTim==2J3Fo8Axz0yLvpfWf1bq_e0c0EYWi6y3xRe@mail.gmail.com>
	 <1282636286.2605.2307.camel@laptop>
	 <20100824080515.GK4684@balbir.in.ibm.com>
	 <1282640953.2605.2428.camel@laptop>
	 <20100824113801.GO4684@balbir.in.ibm.com>
	 <1282650835.2605.2629.camel@laptop>
	 <AANLkTi=QuD7v1PP9PaJt_Dz1N-JKC1e6km1TE_YE6iJk@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 24 Aug 2010 22:39:17 +0200
Message-ID: <1282682357.2605.3219.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-24 at 12:20 -0700, Venkatesh Pallipadi wrote:

> (long email alert)
> I have two different answers for why we ended up with this madness.
> 
> My personal take on why we need this and the actual flow why I ended
> up with this patchset.
> 
> - Current /proc/stat hardirq and softirq time reporting is broken for
> most archs as it does tick sampling. Hardirq time specifically is
> further broken due to interrupts being disabled during irq -
> http://kerneltrap.org/mailarchive/linux-kernel/2010/5/25/4574864

Yeah, architectures without a decent clock are a pain (x86 is still on
that list although nhm/wsm don't suck too bad), but it might be
worthwhile to look at what arch/$foo are strictly tick based.

A quick look suggests:

 alpha
 arm (some)
 avr32
 cris (it could remove its implementation, its identical
       to the weak function provided by kernel/sched_clock.c)
 frv  (idem)
 h8300
 m32r
 m68k* (except nommu-coldfire)
 mips (except cavium-octeon)
 parisc
 score
 sh
 xtensa

which seems to mean too damn many, I bet we can't simply move those to
staging? :-)

> OK. Lets fix /proc/stat. But, that doesn't seem enough. We should also
> not account this time to tasks themselves.

Right

> - I started looking as not accounting this time to tasks themselves.
> This was really tricky as things are tightly tied to scheduler
> vruntime to get it right. 

I'm not exactly sure where that would get complicated, simply treat
interrupts the same as preemptions by other tasks and things should
basically work out rather straight forward from that.

> I am not even sure I got it totally right
> :(, but I did play with the patch a bit. And noticed there were
> multiple issues. 1) A silly case as in of two tasks on one CPU, one
> task totally CPU bound and another task doing network recv. This is
> how task and softirq time looks like for this (10s samples)
> (loop)  (nc)
> 503 9   502 301
> 502 8   502 303
> 502 9   501 302
> 502 8   502 302
> 503 9   501 302
> Now, when I did "not account si time to task", the loop task ended up
> getting a lot less CPU time and doing less work as nc task doing rcv
> got more CPU share, which was not right thing to do. IIRC, I had
> something like <300 centiseconds for loop after the change (with si
> activity increasing due to higher runtime of nc task).

Well, that actually makes sense and I wouldn't call it wrong.

> 2) Also, a minor problem of breaking current userspace API for
> tasks/cgroup stats assume that irq times are included.

Is that actually specified or simply assumed because our implementation
always had that bug? I would really call not accounting irq time to
tasks a bug-fix.

> So, even though it seems accounting irq time as "system time" seems
> the right thing to do, it can break scheduling in many ways. May be
> hardirq can be accounted as system time. But, dealing with softirq is
> tricky as they can be related to the task.

I haven't yet seen any scheduler breakage here, it will divide time
differently, but not in a broken way, if the system consumes 1/3rd of
the time, there's only 2/3rd left to fairly distribute between tasks, so
something like, 1/3-loop 1/3-nc 1/3-softirq makes perfect sense.

You'd get exactly the same kind of thing if you replace (soft)irq with a
FIFO task.

The whole schizo softirq infrastructure (hardirq tails and tasks) is a
pain though, I would really love to rid the kernel of it, but I've got
no idea how to do something like that given that things like the whole
network subsystem are tightly woven into it.

> Figuring out si time and accouting to the right task is a non-starter.
> There are so many different ways in which si will come into picture.
> finding and accounting it to right task will be almost impossible.

Agreed, hence:

> So, why not do the simple things first. Do not disturb any existing
> scheduling decisions, account accurate hi and si times system wide,
> per task, per cgroup (with as less overhead as possible). Give this
> info to users and admin programs and they may make a higher level
> sense of this. 
> 
> Having looked at both the options, I feel having these export is an
> immediate first step. 

This is where I strongly disagree, providing an interface that cannot
possibly be implemented correctly just so you can fudge something (still
not sure what from userspace) seems a very bad idea indeed.


