Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab0FDDqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 23:46:04 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:34265 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757261Ab0FDDqB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 23:46:01 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1006031856420.8175@i5.linux-foundation.org>
References: <20100603193045.GA7188@elte.hu>
	<20100603231153.GA11302@elte.hu>
	<20100603232302.GA16184@elte.hu>
	<alpine.LFD.2.00.1006031630300.8175@i5.linux-foundation.org>
	<20100603234634.GA21831@elte.hu>
	<alpine.LFD.2.00.1006031856420.8175@i5.linux-foundation.org>
Date: Thu, 3 Jun 2010 20:45:59 -0700
Message-ID: <AANLkTinVAhy_PtGfmD4yZByaloFGjpw-lgBL7k11sqi6@mail.gmail.com>
Subject: Re: suspend blockers & Android integration
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, tytso@mit.edu,
       Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 7:16 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Fri, 4 Jun 2010, Ingo Molnar wrote:
>>
>> What you say is absolutely true, hence this would be driven via sched_tick() +
>> TIF notifiers - i.e. only ever treat user-mode tasks as 'idle-able'. This can
>> be done with no overhead to the regular fastpaths.
>>
>> The TIF notifier would be the one scheduling to idle - and would thus do it
>> only to user-mode tasks.
>
> The thing is, unless there is some _really_ deep other reason to do
> something like this, I still think it's total overdesign to push any
> knowledge/choices like this into the scheduler. I'd rather keep things way
> more independent, less tied to each other and to deep kernel subsystems.
>
> IOW, my personal opinion is that somethng like a suspend (blocker or not)
> decision simply shouldn't be important enough to be tied into the
> scheduler. Especially not if it could just be its own layer.
>
> That said, as far as I know, the Android people have mostly been looking
> at the suspend angle from a single-core standpoint. And I'm not at all
> convinced that they should hijack the existing "/sys/power/state" thing
> which is what I think they do now.
>

While it is true that we have not used this code on a multi core
system yet, I'm not sure why multiple cores codes would affect it. We
annotate that works needs to be done before it is safe to suspend, but
we don't care which core does the work (or if multiple cores do pieces
of it).

> And those two things go together. The /sys/power/state thing is a global
> suspend - which I don't think is appropriate for a opportunistic thing in
> the first place, especially for multi-core.
>
> A well-designed opportunistic suspend should be a two-phase thing: an
> opportunistc CPU hotunplug (shutting down cores one by one as the system
> is idle), and not a "global" event in the first place. And only when
> you've reached single-core state should you then say "do I suspend the
> system too".
>

This seems to fit better into the cpuidle and/or frequency scaling framework.

> So I've tried to look a bit at the patches, and my admittedly rough
> comments so far is
>
>  - I really do prefer the "off to the side" approach that the current
>   google opportunistic suspend patches have. As mentioned, I don't think
>   this should be deep in the scheduler. Not at all.
>
>  - I do think there are possibly races and CPU idle issues there, but I
>   think they are mainly for the multi-core thing. And I think that's a
>   totally separate issue. Or it _should_ be.
>

I'm not aware of any races with multi-core systems unless there are
existing problems in suspend. We check if any suspend blockers are
active after disable_nonboot_cpus() has returned.

>  - once you're single-core (whether because you never had more cores to
>   begin with, or because the "opportunistic CPU offlining" has taken down
>   the other cores), I think the suspend-blocker is fine as a concept, and
>   certainly shouldn't need any deep scheduler hooks.
>
> so I'd like to see the opportunistc suspend thing think about CPU
> offlining,

I see this as a separate problem. We ignore a single busy CPU for
opportunistic suspend, so why should the number of online CPUs matter?

> and I'd like to see it disconnect from the existing
> /sys/power/state.

The entry point is not important to us. The current interface is what
Rafael wanted instead of the /sys/power/request-state interface which
is what we changed it to last year.

> And I'd really not like to involved deep internal kernel
> hooks into it.
>
> But I'll also admit that maybe I'm not seeing some problems. I've frankly
> tried to avoid the whole discussion until Andrew pulled me in yesterday.
>
>                        Linus
>



-- 
Arve Hjønnevåg
