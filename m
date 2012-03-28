Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab2C1M5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 08:57:47 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56012 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab2C1M5p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 08:57:45 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <20120328123912.GE17189@somewhere.redhat.com>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
	<1332338318-5958-13-git-send-email-fweisbec@gmail.com>
	<alpine.DEB.2.00.1203210953220.20482@router.home>
	<CAOtvUMdkU92t0nj9OXsnzCenuOyjb12x6s11xR_GGJu1aJJ7GA@mail.gmail.com>
	<alpine.DEB.2.00.1203221117100.25011@router.home>
	<CAOtvUMeMhA_scQyJwDpfNZ7BipAKfLTqODqkn342mcxS_yL9OQ@mail.gmail.com>
	<20120328123912.GE17189@somewhere.redhat.com>
Date: Wed, 28 Mar 2012 14:57:44 +0200
Message-ID: <CAOtvUMfJyuLXqa7oOcYcxov9JEkqnxwTnv-bRG-_5Whq6N7uMw@mail.gmail.com>
Subject: Re: [PATCH 11/32] nohz/cpuset: Don't turn off the tick if rcu needs it
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 2:39 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Tue, Mar 27, 2012 at 05:21:34PM +0200, Gilad Ben-Yossef wrote:
>> On Thu, Mar 22, 2012 at 6:18 PM, Christoph Lameter <cl@linux.com> wrote:
>> > On Thu, 22 Mar 2012, Gilad Ben-Yossef wrote:
>> >
>> >> > Is there any way for userspace to know that the tick is not off yet due to
>> >> > this? It would make sense for us to have busy loop in user space that
>> >> > waits until the OS has completed all processing if that avoids future
>> >> > latencies for the application.
>> >> >
>> >>
>> >> I previously suggested having the user register to receive a signal
>> >> when the tick
>> >> is turned off. Since the tick is always turned off the user task is
>> >> the current task
>> >> by design, *I think* you can simply mark the signal pending when you
>> >> turn the tick off.
>> >
>> > Ok that sounds good. You would define a new signal for this?
>> >
>>
>> My gut instinct is to let the process register with a specific signal
>> (properly the RT range)
>> it wants to receive when the tick goes off and/or on.
>
> Note the signal itself could trigger an event that could restart the tick.
> Calling call_rcu() is sufficient for that. We can probably optimize that
> one day by assigning another CPU to handle the callbacks of a tickless
> CPU but for now...
>



>>
>> > So we would startup the application. App will do all prep work (memory
>> > allocation, device setup etc etc) and then wait for the signal to be
>> > received. After that it would enter the low latency processing phase.
>> >
>> > Could we also get a signal if something disrupts the peace and switches
>> > the timer interrupt on again?
>> >
>>
>> I think you'll have to since once you have the tick turned off there
>> is no guarantee that
>> it wont get turned on by a timer scheduling an task or an IPI.
>
> The problem with this scheme is that if the task is running with the
> guarantee that nothing is going to disturb it (it assumes so when it
> is notified that the timer is stopped), can it seriously recover from
> the fact the timer has been restarted once it gets notified about it?

Recovery in this context involves a programmer/system architect looking
into what made the tick start and making sure that wont happen the next
time around.

I know it's not quite what you had in mind, but it works :-)

>
> I have a hard time to imagine that. It's like an RT task running a
> critical part that suddenly receives a notification from the kernel that
> says "what's up dude? hey by the way you're not real time anymore" :)
> How are we recovering from that?

The point is that it is the difference between a QA report that says:

"Performance dropped below acceptable level for 10 ms some when
during the test run"

and

"We got an indication that the kernel resumed the tick on us, so the test
was stopped and here is the stack trace for all the tasks running,
plus the logs".


> May be instead of focusing on these notifications, we should try hard to
> shut down the tick before we reach userspace: delegate RCU work
> to another CPU, avoid needless IPIs, avoid needless timer list timers, etc...
> Fix those things one by one such that we can configure things to the point we
> get closer to a guarantee of CPU isolation.
>
> Does that sound reasonable?

It does to me :-)

Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
