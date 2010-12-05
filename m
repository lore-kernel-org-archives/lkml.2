Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab0LEKTR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 05:19:17 -0500
Received: from home.kolivas.org ([59.167.196.135]:59390 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062Ab0LEKTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 05:19:15 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Colin Walters <walters@verbum.org>
Subject: Re: [PATCH v4] sched: automated per session task groups
Date: Sun, 5 Dec 2010 21:18:43 +1100
User-Agent: KMail/1.13.5 (Linux/2.6.35.7-ck1; KDE/4.4.5; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org
References: <1289783580.495.58.camel@maggy.simson.net> <201 <AANLkTikrc+_r1KE477c-NeD-9PWDOXx1ExHGm08Lm6wM@mail.gmail.com>
In-Reply-To: <AANLkTikrc+_r1KE477c-NeD-9PWDOXx1ExHGm08Lm6wM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012052118.43843.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greets.

I applaud your efforts to continue addressing interactivity and responsiveness 
but, I know I'm going to regret this, I feel strongly enough to speak up about 
this change.

On Sun, 5 Dec 2010 10:43:44 Colin Walters wrote:
> On Sat, Dec 4, 2010 at 5:39 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > What's your point again? It's a heuristic.
> 
> So if it's a heuristic the OS can get wrong,

This is precisely what I see as the flaw in this approach. The whole reason 
you have CFS now is that we had a scheduler which was pretty good for all the 
other things in the O(1) scheduler, but needed heuristics to get interactivity 
right. I put them there. Then I spent the next few years trying to find a way 
to get rid of them. The reason is precisely what Colin says above. Heuristics 
get it wrong sometimes. So no matter how smart you think your heuristics are, 
it is impossible to get it right 100% of the time. If the heuristics make it 
better 99% of the time, and introduce disastrous corner cases, regressions and 
exploits 1% of the time, that's unforgivable. That's precisely what we had 
with the old O(1) scheduler and that's what you got rid of when you put CFS 
into mainline. The whole reason CFS was better was it was mostly fair and 
concentrated on ensuring decent latency rather than trying to guess what would 
be right, so it was predictable and reliable.

So if you introduce heuristics once again into the scheduler to try and 
improve the desktop by unfairly distributing CPU, you will go back to where 
you once were. Mostly better but sometimes really badly wrong. No matter how 
smart you think you can be with heuristics they cannot be right all the time. 
And there are regressions with these tty followed by per session group 
patches. Search forums where desktop users go and you'll see that people are 
afraid to speak up on lkml but some users are having mplayer and amarok 
skipping under light load when trying them. You want to program more 
intelligence in to work around these regressions, you'll just get yourself 
deeper and deeper into the same quagmire. The 'quick fix' you seek now is not 
something you should be defending so vehemently. The "I have a solution now" 
just doesn't make sense in this light. I for one do not welcome our new 
heuristic overlords.

If you're serious about really improving the desktop from within the kernel, 
as you seem to be with this latest change, then make a change that's 
predictable and gets it right ALL the time and is robust for the future. Stop 
working within all the old fashioned concepts and allow userspace to tell the 
kernel what it wants, and give the user the power to choose. If you think this 
is too hard and not doable, or that the user is too uninformed or want to 
modify things themselves, then allow me to propose a relatively simple change 
that can expedite this.

There are two aspects to getting good desktop behaviour, enough CPU and low 
latency. 'nice' by your own admission is too crude and doesn't really describe 
how either of these should really be modified. Furthermore there are 40 levels 
of it and only about 4 or 5 are ever used. We also know that users don't even 
bother using it. 

What I propose is a new syscall latnice for "latency nice". It only need have 
4 levels, 1 for default, 0 for latency insensitive, 2 for relatively latency 
sensitive gui apps, and 3 for exquisitely latency sensitive uses such as 
audio. These should not require extra privileges to use and thus should also 
not be usable for "exploiting" extra CPU by default. It's simply a matter of 
working with lower latencies yet shorter quota (or timeslices) which would 
mean throughput on these apps is sacrificed due to cache trashing but then 
that's not what latency sensitive applications need. These can then be 
encouraged to be included within the applications themselves, making this a 
more long term change. 'Firefox' could set itself 2, 'Amarok' and 'mplayer' 3, 
and 'make' - bless its soul - 0, and so on. Keeping the range simple and 
defined will make it easy for userspace developers to cope with, and users to 
fiddle with.

But that would only be the first step. The second step is to take the plunge 
and accept that we DO want selective unfairness on the desktop, but where WE 
want it, not where the kernel thinks we might want it. It's not an exploit if 
my full screen HD video continues to consume 80% of the CPU while make is 
running - on a desktop. Take a leaf out of other desktop OSs and allow the 
user to choose say levels 0, 1, or 2 for desktop interactivity with a simple 
/proc/sys/kernel/interactive tunable, a bit like the "optimise for foreground 
applications" seen elsewhere. This could then be used to decide whether to use 
the scheduling hints from latnice to either just ensure low latency but keep 
the same CPU usage  - 0, or actually give progressively more CPU for latniced 
tasks as the interactive tunable is increased. Then distros can set this on 
installation and make it part of the many funky GUIs to choose between the 
different levels. This then takes the user out of the picture almost entirely, 
yet gives them the power to change it if they so desire.

The actual scheduler changes required to implement this are absurdly simple 
and doable now, and will not cost in overhead the way cgroups do. It also 
should cause no regressions when interactive mode is disabled and would have 
no effect till changes are made elsewhere, or the users use the latnice 
utility.

Move away from the fragile heuristic tweaks and find a longer term robust 
solution.

Regards,
Con

-- 
-ck

P.S. I'm very happy for someone else to do it. Alternatively you could include 
BFS and I'd code it up for that in my spare time.

