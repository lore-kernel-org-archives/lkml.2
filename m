Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab0LELgk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 06:36:40 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:46356 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754777Ab0LELgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 06:36:39 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18S7NtJ89QS+GQI8OsxPBjeVZB8oEMFPaucro9IMy
	iFHkHYa+Zdi5B8
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Colin Walters <walters@verbum.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <201012052118.43843.kernel@kolivas.org>
References: <1289783580.495.58.camel@maggy.simson.net>
	 <201 <AANLkTikrc+_r1KE477c-NeD-9PWDOXx1ExHGm08Lm6wM@mail.gmail.com>
	 <201012052118.43843.kernel@kolivas.org>
Content-Type: text/plain
Date: Sun, 05 Dec 2010 12:36:33 +0100
Message-Id: <1291548993.7581.65.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-12-05 at 21:18 +1100, Con Kolivas wrote:
> Greets.
> 
> I applaud your efforts to continue addressing interactivity and responsiveness 
> but, I know I'm going to regret this, I feel strongly enough to speak up about 
> this change.
> 
> On Sun, 5 Dec 2010 10:43:44 Colin Walters wrote:
> > On Sat, Dec 4, 2010 at 5:39 PM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > > What's your point again? It's a heuristic.
> > 
> > So if it's a heuristic the OS can get wrong,
> 
> This is precisely what I see as the flaw in this approach. The whole reason 
> you have CFS now is that we had a scheduler which was pretty good for all the 
> other things in the O(1) scheduler, but needed heuristics to get interactivity 
> right. I put them there.

Actually, Linus laid the foundation with sleeper fairness, Ingo expanded
it to requeue "interactive" tasks in the active array, and you tweaked
the result.

>  Then I spent the next few years trying to find a way 
> to get rid of them. The reason is precisely what Colin says above. Heuristics 
> get it wrong sometimes. So no matter how smart you think your heuristics are, 
> it is impossible to get it right 100% of the time. If the heuristics make it 
> better 99% of the time, and introduce disastrous corner cases, regressions and 
> exploits 1% of the time, that's unforgivable. That's precisely what we had 
> with the old O(1) scheduler and that's what you got rid of when you put CFS 
> into mainline. The whole reason CFS was better was it was mostly fair and 
> concentrated on ensuring decent latency rather than trying to guess what would 
> be right, so it was predictable and reliable.

And it still is Con.  I didn't rewrite the thing, I just added an
automated task grouping.  Session to session fairness is just as holy as
any sacred cow definition of fair you care to trot out.

> So if you introduce heuristics once again into the scheduler to try and 
> improve the desktop by unfairly distributing CPU, you will go back to where 
> you once were. Mostly better but sometimes really badly wrong. No matter how 
> smart you think you can be with heuristics they cannot be right all the time. 
> And there are regressions with these tty followed by per session group 
> patches. Search forums where desktop users go and you'll see that people are 
> afraid to speak up on lkml but some users are having mplayer and amarok 
> skipping under light load when trying them.

Shrug. I can't debug what isn't reported.

>  You want to program more 
> intelligence in to work around these regressions, you'll just get yourself 
> deeper and deeper into the same quagmire. The 'quick fix' you seek now is not 
> something you should be defending so vehemently. The "I have a solution now" 
> just doesn't make sense in this light. I for one do not welcome our new 
> heuristic overlords.

I for one don't welcome childish name calling.

> If you're serious about really improving the desktop from within the kernel, 
> as you seem to be with this latest change, then make a change that's 
> predictable and gets it right ALL the time and is robust for the future. Stop 
> working within all the old fashioned concepts and allow userspace to tell the 
> kernel what it wants, and give the user the power to choose. If you think this 
> is too hard and not doable, or that the user is too uninformed or want to 
> modify things themselves, then allow me to propose a relatively simple change 
> that can expedite this.
> 
> There are two aspects to getting good desktop behaviour, enough CPU and low 
> latency. 'nice' by your own admission is too crude and doesn't really describe 
> how either of these should really be modified. Furthermore there are 40 levels 
> of it and only about 4 or 5 are ever used. We also know that users don't even 
> bother using it. 
> 
> What I propose is a new syscall latnice for "latency nice". It only need have 
> 4 levels, 1 for default, 0 for latency insensitive, 2 for relatively latency 
> sensitive gui apps, and 3 for exquisitely latency sensitive uses such as 
> audio. These should not require extra privileges to use and thus should also 
> not be usable for "exploiting" extra CPU by default. It's simply a matter of 
> working with lower latencies yet shorter quota (or timeslices) which would 
> mean throughput on these apps is sacrificed due to cache trashing but then 
> that's not what latency sensitive applications need. These can then be 
> encouraged to be included within the applications themselves, making this a 
> more long term change. 'Firefox' could set itself 2, 'Amarok' and 'mplayer' 3, 
> and 'make' - bless its soul - 0, and so on. Keeping the range simple and 
> defined will make it easy for userspace developers to cope with, and users to 
> fiddle with.

An automated per session task group is an evil heuristic, so we should
use kinda sorta sensitive, really REALLY sensitive, don't give a damn,
or no frickin' clue... to make 100% accurate non-heuristic scheduling
decisions instead?  Did I get that right?

Goodbye.

	-Mike

