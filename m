Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935550Ab0KQWdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 17:33:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45205 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935047Ab0KQWdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 17:33:45 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=UqmpqEpIoFQA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=WfulkdPnAAAA:8 a=7d_E57ReAAAA:8 a=07d9gI8wAAAA:8 a=WgtFgCoSZ-5Ah-RiLGMA:9 a=I-F-_DSiiSnGRCHggXIA:7 a=E-58kCmErwTYO_oTuQVThAwTIVMA:4 a=CjuIK1q_8ugA:10 a=l29vjEC0CZ8A:10 a=D6-X0JM3zdQA:10 a=_1x-x7IA_2d56rGX:21 a=nXJlGERx7XmegKQH:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Wed, 17 Nov 2010 17:33:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Andre@firstfloor.org, ltt-dev@lists.casi.polymtl.ca,
        linux-kernel@vger.kernel.org, pierre-marc.fournier@polymtl.ca
Subject: Re: [ANNOUNCE] New tools: lttngtrace and lttngreport
Message-ID: <20101117223337.GA14525@home.goodmis.org>
References: <20101115134243.GA2772@Krystal>
 <20101115160745.GA7203@Krystal>
 <87y68sqiyb.fsf@basil.nowhere.org>
 <20101117173124.GB13717@Krystal>
 <alpine.LFD.2.00.1011172146340.2900@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011172146340.2900@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, I was somehow cut from the Cc list?

On Wed, Nov 17, 2010 at 10:44:23PM +0100, Thomas Gleixner wrote:
> On Wed, 17 Nov 2010, Mathieu Desnoyers wrote:
> 
> > * Andi Kleen (andi@firstfloor.org) wrote:
> > > Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:
> > > >
> > > >         --> Blocked in RUNNING, SYSCALL 142 [sys_select+0x0/0xc0], ([...], dur: 0.029567)
> > > >         |    --> Blocked in RUNNING, SYSCALL 168 [sys_poll+0x0/0xc0], ([...], dur: 1.187935)
> > > >         |    --- Woken up by an IRQ: IRQ 0 [timer]
> > > >         --- Woken up in context of 7401 [gnome-power-man] in high-level state RUNNING
> > > 
> > > Very nice! Now how can we get that with an unpatched kernel tree?
> > 
> > Well, I'm afraid the collection approach "trace" is currently taking won't allow
> > this kind of dependency wakeup chain tracking, because they focus on tracing
> > operations happening on a thread and its children, but the reality is that the
> > wakeup chains often spread outside of this scope.
> 
> You are completely missing the point. There is no need to point out
> that 'trace' does not do that. It is tracking a process (group)
> context (though it can do system wide with the right permissions as
> well).
> 
> And it's completely irrelevant for a user space programmer where the
> kernel spends its time. What's not irrelevant is the information what
> caused the kernel to spend time, i.e. which access to which data
> resulted in a page fault or IO and how long did it take to come back.
> 
> It's completely irrelevant for him whether the kernel ran in circles
> or not. If he sees a repeating pattern that a PF recovery or a
> read/write to some file takes ages, he'll poke the sysadmin or the
> kernel dude, which then will drill down into the gory details.
> 
> http://lwn.net/Articles/415760/
> 
>  "... Indeed I've been wishing for a tool which would easily tell me
>  what pages I'm faulting in (and in what order) out of a 5GB mmaped
>  file, in order to help debug performance issues with disk seeks when
>  the file is totally paged out."
> 
> That's what relevant to user space developers, not the gory details
> why the kernel took time X to retrieve that data from disk. Simply
> because you can improve performance when you have such information by
> rearranging your code and access patterns. The same applies for other
> things like cache misses, which can be easily integrated into 'trace'.

Yes, I think the point that is missing here is the focus of the user.

As Linus grinded into my head, he does not care about what the kernel is
doing when he is working on git. He wants to know if he can make his app
work better. Perhaps, localize data or such, which can help. Cache
missies would also be good feedback.

If the user sees that a syscall or pagefault is totally wacked, they can
then (as Thomas said) poke a kernel developer or admin to fix it. They
wont understand the internals of the kernel to get anything useful out
of it.


> 
> > This is why lttngtrace gathers a system-wide trace even though we're mostly
> > intested in the wait/wakeups of a specific PID.
> 
> Which results in a permission problem which you are completely
> ignoring. Not a surprise though - I'm used to the academic way of
> defining preliminaries and ignoring side effects just to get the paper
> written.

Yes, we do not want average Joe to be able to look at anything that they
can't already see (to a point). Sure, let them see when their pages are
being mapped in, or when they take a cache hit, or they block on IO, and
for how long. But I would not want them to be able to see how other
tasks that they do not own are affecting the system. Allowing that would
be a rootkit developer's dream. If they know of some vulnerablility that
takes some timing to trigger, they can then monitor that sshd or
whatever, and see inject an attack at just the right moment to steal a
password, or gain access to something else that they should not have.

But for admins, this is fine, since they have that ability anyway.

Thus, LTTng is a great tool for admins who want to analyze how their
system is running. But it is not something for the average Joe on a
general system. They wont know what all this information means anyway.

-- Steve

