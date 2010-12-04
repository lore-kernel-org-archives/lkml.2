Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab0LDSdj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 13:33:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753176Ab0LDSdi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 13:33:38 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTinz12n9OKkCV8XRF8n1vKytO_aj26i-ytcAhFgN@mail.gmail.com>
References: <1289783580.495.58.camel@maggy.simson.net> <1289811438.2109.474.camel@laptop>
 <1289820766.16406.45.camel@maggy.simson.net> <1289821590.16406.47.camel@maggy.simson.net>
 <20101115125716.GA22422@redhat.com> <1289856350.14719.135.camel@maggy.simson.net>
 <20101116130413.GA29368@redhat.com> <1289917109.5169.131.camel@maggy.simson.net>
 <20101116150319.GA3475@redhat.com> <1289922108.5169.185.camel@maggy.simson.net>
 <20101116172804.GA9930@elte.hu> <1290281700.28711.9.camel@maggy.simson.net> <AANLkTinz12n9OKkCV8XRF8n1vKytO_aj26i-ytcAhFgN@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 4 Dec 2010 10:33:15 -0800
Message-ID: <AANLkTinWQkiadp7NCVt401bFiATJeqTK1g81RcP2awCv@mail.gmail.com>
Subject: Re: [PATCH v4] sched: automated per session task groups
To: Colin Walters <walters@verbum.org>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 4, 2010 at 9:39 AM, Colin Walters <walters@verbum.org> wrote:
>
> Why doesn't "nice" work for this?  On my Fedora 14 system, "ps alxf"
> shows almost everything in my session is running at the default nice
> 0.  The only exceptions are "/usr/libexec/tracker-miner-fs" at 19, and
> pulseaudio at -11.

"nice" doesn't work. It never has. Nobody ever uses it, and that has
always been true.

As you note, you can find occasional cases of it being used, but they
are either for things that are _so_ unimportant (and know they are)
and annoying cpu hogs that they wouldn't be allowed to live unless
they were niced down maximally (your tracker-miner example), or they
use nice not because they really want to, but because it is an
approximation for what they really do want (ie pulseaudio wants low
latencies, and is set up by the distro, so you'll find it niced up).

But the fundamental issue is that 'nice' is broken. It's very much
broken at a conceptual and technical design angle (absolute priority
levels, no fairness), but it's broken also from a psychological and
practical angle (ie expecting people to manually do extra work is
ridiculous and totally unrealistic).

> I don't know What would happen if say the scheduler effectively
> group-scheduled each nice value?

Why would you want to do that? If you are willing to do group
scheduling, do it on something sane and meaningful, and something that
doesn't need user interaction or decisions. And do it on something
that has more than 20 levels.

You could, for example, decide to do it per session.

> Then, what we tell people to do is
> run "nice make".  Which in fact, has been documented as a thing to do
> for decades.

Nobody but morons ever "documented" that. Sure, you can find people
saying it, but you won't be finding people actually _doing_ it. Look
around.

Seriously. Nobody _ever_ does "nice make", unless they are seriously
repressed beta-males (eg MIS people who get shouted at when they do
system maintenance unless they hide in dark corners and don't get
discovered). It just doesn't happen.

But more fundamentally, it's still the wrong thing to do. What nice
level should you use?

And btw, it's not just "make". One of the things that originally
caused me to want something like this is that you can enable some
pretty aggressive threading with "git diff". If you use the
"core.preloadindex" setting, git will fire up 20 threads just to do
"lstat()" system calls as quickly as it humanly can. Or "git grep"
will happily use lots of threads and really mess with your system,
except it limits the threads to a smallish number just to not be
asocial.

Do you want to do "nice git" too? Especially as the reason the
threaded lstat was implemented was that over NFS, you actually want
the threads not because you're using lots of CPU, but because you want
to fire up lots of concurrent network traffic - and you actually want
low latency. So you do NOT want to mark these threads as
"unimportant". They're not.

But what you do want is a basic and automatic fairness. When I do "git
grep", I want the full resources of the machine to do the grep for me,
so that I can get the answer in half a second (which is about the
limit at which point I start getting impatient). That's an _important_
job for me. It should get all the resources it can, there is
absolutely no excuse for nicing it down.

But at the same time, if I just happen to have sound or something
going on at the same time, I would definitely like some amount of
fairness. Just because git is smart and can use lots of threads to do
its work quickly, it shouldn't be _unfair_. It should hod the machine
- but only up to a point of some fairness.

That is something that "nice" can never give you. It's not what nice
was designed for, it's not how nice works. And if you ask people to
say "this work isn't important", you shouldn't expect them to actually
do it. If something isn't important, I certainly won't then spend
extra effort on it, for chrissake!

Now, I'm not saying that cgroups are necessarily the answer either.
But using sessions as input to group scheduling is certainly _one_
answer. And it's a hell of a better answer than 'nice' has ever been,
or will ever be.

                             Linus
