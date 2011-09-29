Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab1I2DH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 23:07:28 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:46064 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab1I2DH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 23:07:26 -0400
Subject: Re: [PATCH 0/6] [RFC] Proposal for optimistic suspend idea.
From: John Stultz <john.stultz@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, markgross@thegnar.org,
        Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org,
        farrowg@sg.ibm.com, "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1317197973.5781.28.camel@twins>
References: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
	 <1317068164.1763.39.camel@twins> <1317076065.3112.539.camel@work-vm>
	 <1317119870.15383.29.camel@twins> <1317164216.3112.711.camel@work-vm>
	 <1317197973.5781.28.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Sep 2011 20:07:16 -0700
Message-ID: <1317265636.3112.779.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 10:19 +0200, Peter Zijlstra wrote:
> On Tue, 2011-09-27 at 15:56 -0700, John Stultz wrote:
> > But I think once you get away from some theoretical system, containing
> > only properly behaving apps, having some tools in the kernel to enforce
> > a certain type of behavior (and having the kernel's ability to handle
> > more complex cases like importance inheritance) might be helpful. 
> 
> So you want to add something that sends a SIGBUS or similar to an
> application if it gets a wakeup when its not supposed to? That's what
> happens with memory protection, you get killed.

Although that is more reactive then what I'm thinking.

I'm thinking more enforcement on the front end, where instead of
bunching timers around time intervals, we bunch timers around the events
of "important" processes.

So its not applications get wakeups when they aren't supposed to, its
that we don't schedule timer interrupts for their timers, and we don't
schedule them unless the system is "active" running an "important" task
(allowing them to exploit the small idle cycles of the "important" task,
which are likely too short to allow for any deep-idle state to trigger).

Basically we want the system to be in as deep an idle as possible for as
long as possible. Bunching both timers and task execution allows this.
But instead of pushing things out maybe a second, can we stall tasks
for minutes or hours? If we start doing that, we're going to need some
way for tasks to communicate that: "now is a really bad time for you to
freeze me".

So I'm trying to come up with an API that we can use for that issue as
well (since it starts to approximates the suspend case as those forced
idle times grow).

I'll see if I can't start playing with some patches to try to
demonstrate the idea in a non-suspend context.

> And yes, when Arjan did his powertop thing people did go fix up
> everything that made the top.

Yea, the really terrible offenders did improve and I think that was
great! But now how do we deal with the hundreds of normal applications,
that when combined still cause quite a bit of wakeup noise? How do we
really get to minutes of deep idle on a "normal" system?

> It really isn't that hard to fix most of these apps. But the problem
> with Android is that the battery usage thing it has is utterly useless.
> It mostly just tells you wireless or whatnot is sucking power, not what
> app is causing that. (And of course the fact that its all fucking Java
> crap, which I'll refuse to touch anyway).
> 
> This results in people (me) uninstalling everything they installed since
> last it worked well and then cursing this crappy shit for wasting their
> time.

Sure Android has issues, no argument there.

But realize that while part of my motivation is to try to mend the
Android fork, another part is that the need for extreme power efficiency
is not just about phones. I'm trying to find a solution that works for
both on servers with classic linux distros as well as the Android
environment (or better, is demonstratively superior to the wakelocks
solution - fixing all your complaints about your phones battery life!).

So arguments about how Android userland sucks aren't really relevant.

> I really think Android is a pile of privacy violating shit, I can't say
> I actually enjoy using the phone. I'm at a point where I can call with
> it (without it telling google whoem all I know and where I'm at) and
> browse the interwebs and have decided to screw apps, they don't work
> anyway.

I'm sorry my patch doesn't address the privacy concerns of using an
Android (or really any) cell phone. :)

thanks
-john


