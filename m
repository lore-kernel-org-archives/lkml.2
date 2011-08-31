Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288Ab1HaN5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 09:57:34 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34711 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1HaN5d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 09:57:33 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <20110830140648.GL9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	<CAOtvUMdgPoL_gnOTq8DwS9RxSFagQN_kAze3guD8O3xFHfnfHg@mail.gmail.com>
	<20110830140648.GL9748@somewhere.redhat.com>
Date: Wed, 31 Aug 2011 16:57:32 +0300
Message-ID: <CAOtvUMd19PD-+EzEcAKMq-12bWRjMFr8G-yBxhCjqMMbxdpaTA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/32] Nohz cpusets (was: Nohz Tasks)
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 5:06 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:

>
> >
> > To make double sure I have no task on my nohz cpuset CPU, I've booted
> > the system with the isolcpus command line isolating the same cpu I've
> > assigned to the nohz set. This shouldn't be needed of course, but just
> > in case.
>
> Ah I haven't tested with that isolcpus especially as it's headed toward
> removal.
>

I had the cpuisol option in the boot loader config but I did set up a
proper cpuset as well, so I believe it made no difference.

I added the cpuisol option after noticing how many tasks I was unable
to move from the root cpuset to the system cpuset due to them being
bound per CPU and hoped (for no good reason, I admit) that cpuisol
will somehow help with the task isolation I wanted to get to test the
nohz task.

That's a different obstacle to workload of the kind where nohz cpuset
would be useful, but should probably be discussed in another thread
:-)

>
> >
> > I then ran a silly program I've written that basically eats CPU cycles
> > (https://github.com/gby/cpueat) and assigned it to the nohz set and
> > monitored the number of interrupts using /proc/interrupts
> >
> > Now, for the things I've noticed -
> >
> > 1. Before I turn adaptive_nohz to 1, when no task is running on the
> > nohz cpuset cpu, the tick is indeed idle (regular nohz case) and very
> > few function call IPIs are seen. However, when I turn adaptive_nohz to
> > 1 (but still with no task running on the CPU), the tick remains idle,
> > but I get an IPI function call interrupt almost in the rate the tick
> > would have been.
>
> Yeah I believe this is due to RCU that tries to wake up our nohz CPU.
> I need to have a deeper look there.

I believe you are right with the reason for the IPI.

Before setting adaptive_nohz for the cpuset I did not get the IPI on
an idle CPU. After setting it  I started getting the IPI regularly
even when the CPU was idle.

> > 2. When I run my little cpueat program on the nohz CPU, the tick does
> > not actually goes off. Instead it ticks away as usual. I know it is
> > the only legible task to run, since as soon as I kill it  the tick
> > turns off (regular nohz mode again). I've tinkered around and found
> > out that what stops the tick going away is the check for rcu_pending()
> > in cpuset_nohz_can_stop_tick(). It seems to always be true. When I
> > removed that check experimentally and repeat the test, the tick indeed
> > stops with my cpueat task running. Of course, I don't suggest this is
> > the sane thing to do - I just wondered if that what stopped the tick
> > going away and it seems that it is.
>
> Are you sure the tick never goes off?

Yes, I put debug code in the cpuset_nohz_can_stop_tick(). Every time
the function was called for that CPU rcu_pending() returned 1.


> But yeah may be there is something that constantly requires RCU grace
> periods to complete in your system. I should drop the rcu_pending()
> check as long as we want to stop the tick from userspace because
> there we are off the RCU state machine.

I added debug code to rcu_pending() and noticed that the rcu_bh was
the one pending each time.

I found that odd - my VM didn't even have a netowrk interface
configured (except maybe for lo), let alone saw any network traffic. I
thought rcu_bh was mostly used for networking code (Paul?)


> > 3. My little cpueat program tries to fork a child process after 100k
> > iteration of some CPU bound loop. It usually takes a few seconds to
> > happen. The idea is to make sure that the tick resumes when nr_running
> > > 1. In my case, I got a kernel panic. Since it happened with some
> > debug code I added and with aforementioned experimental removal of
> > rcu_pending check, I'm assuming for now it's all my fault but will
> > look into verifying it further and will send panic logs if it proves
> > useful.
>
> I got some panic too but haven't seen any for some time. I made a
> lot of changes since then though so I thought the condition to trigger
> it just went away.
>
> IIRC, it was a locking inversion against the rq lock and some other lock.
> Very nice condition for a cool lockup ;)

It certainly sounds exciting :-)

Let me know if I an help test anything else.

Thanks,
Gilad


--
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com
"Dance like no one is watching, love like you'll never be hurt, sing
like no one is listening... but for BEEP sake you better code like
you're going to maintain it for years!"
