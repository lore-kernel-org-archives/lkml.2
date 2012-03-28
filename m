Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab2C1Igm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 04:36:42 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49401 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab2C1Igi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 04:36:38 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <4F71E012.7050907@tilera.com>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
	<1332338318-5958-13-git-send-email-fweisbec@gmail.com>
	<alpine.DEB.2.00.1203210953220.20482@router.home>
	<CAOtvUMdkU92t0nj9OXsnzCenuOyjb12x6s11xR_GGJu1aJJ7GA@mail.gmail.com>
	<4F6B5ED1.1080300@tilera.com>
	<CAOtvUMdtprdVxG3d5B-W6Y98SNg1kZms=Q+tmamqN9YkWsiWBg@mail.gmail.com>
	<4F71E012.7050907@tilera.com>
Date: Wed, 28 Mar 2012 10:36:37 +0200
Message-ID: <CAOtvUMe+3mQjw9LQRnxocGHMrMmrQtY3G+XGw91HVr1BtP9UxQ@mail.gmail.com>
Subject: Re: [PATCH 11/32] nohz/cpuset: Don't turn off the tick if rcu needs it
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
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

On Tue, Mar 27, 2012 at 5:43 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:

> The thing is, what our customers seem to want is to be able to tell the
> kernel to go away and not bother them again, ever, as long as their
> application is running correctly.  Obviously if it crashes, or if some
> intervention is required, or whatever, they want the kernel to step in, but
> otherwise the proposed signal mechanisms don't seem to help the case that
> they're interested in.  I don't think we've seen a customer application
> where the signal mechanism would be helpful (unfortunately, since it does
> seem like a cool idea).

I understand. I think the key phrase here is "our customers". Which is fine -
we're all doing this to scratch a personal (or corporate...) itch. But
the question
is: are there other possible users? can we build a mechanism that serves both
"our customers" and the other guys? I think we can.

A case in point, consider high performance computing people. They take their
4096 way SGI machine, carve off a few "system" CPUs and run a dedicated
process of each of the remaining cores doing Fourier transforms, or whatever
it is HPC people do, with the result spilling in to shared memory.

It's a 100% cpu bound single task pinned to a single core. The
scheduler tick and all
other kernel activity is a nuisance to them as it is for your customers.  But if
the kernel happens to start the tick for 10 seconds during their 37
hours long run
they certainly don't want to have that process killed!  Logging the
incident can
be useful for later analysis, though.

This is why I believe the signal mechanism is useful - your customers can have
code like this (add memory barriers as needed, of course):

tick goes away signal handler:

nohz = 1;

tick comes back signal handler:

if (!app_started)
   nohz = 0;
else
   abort();

The main function will have something like this:

while(!nohz);
app_started = 1;
...


The HPC people on the other hand can put code in the signal handler to just
record time stamp in a log into shared memory

Same mechanism, two use cases.

>
> Basically if the kernel interrupts a nohz application core, that's a fail.
> It's interesting to know that such a fail has happened, but sending a
> signal just makes it an even worse fail: more overhead.

So in the lab register a handler to abort() the app to debug it.
In production install a SIG_IGN signal handler and hope for the best :-)

> One thing I could
> imagine that might be useful would be to register a region of user memory
> that the kernel could put statistics of some kind into, obviously the
> "bool" flag that says whether you're running tickless, but also things like
> a count of the number of interrupts (e.g. ticks, but really anything) the
> kernel had to deliver, the time of the last interrupt that was delivered,
> maybe some breakdown by type of interrupt, etc.  Then if the application
> detects an interruption, or perhaps just periodically, it can inspect that
> state area and report on any bad developments: and these would be basically
> kernel bugs from failing to protect the nohz core the way it had asked, or
> else application bugs from accidentally requesting a kernel service
> unintentionally.

I think you've re-invented  /proc/interruptsand and maybe a couple of
debugfs/tracing
entries :-)
>
>>> The problem we've seen is that
>>> it's sometimes somewhat nondeterministic when the kernel might decide it
>>> needed some more ticking, once you let kernel code start to run.  For
>>> example, for RCU ops the kernel can choose to ignore the nohz cpuset cores
>>> when they're running userspace code only, but as soon as they get back into
>>> the kernel for any reason, you may need to schedule a grace period, and so
>>> just returning from the "you have no more ticks!" signal handler ends up
>>> causing ticks to be scheduled.
>> There is no real difference from the user stand point between the
>> return signal sys call
>> doing something that causes the tick to be turned on and an IPI or
>> timer that turns on
>> the tick a nano second after the signal return system call returned.
>>
>> The return signal syscall setting the tick on is just a private,
>> though annoying, case of the
>> tick getting turned on by something.
>
> Yes, but see above: the claim I'm making is that we can arrange for a
> well-behaved application to *expect* not to get kernel interrupts, so if
> they happen, something has gone wrong.
>

If that is your usage scenario, arrange things to never get an interrupt and
install a signal handler that aborts the app when the first
signal arrives after the app has started, at least in the lab.

Personally, I would probably use exactly this in the lab but put a SIG_IGN
in production. If the kernel delivers a single tick once every 398 days, and I
didn't manage to catch it in the lab, I probably would not want it to abort in
the field, but that's just me

For example, if I understood the code you posted correctly, if I run an app
on a non isolated core of Tilera ZOL that allocates slightly too much
memory, the page allocator will IPI all cores, including the isolated ones
to get them to spill their per-cpu pages back tot he page allocator.

Do you want to abort the app when that happens in production? some people
will say yes, some people will say no - I just want to log that. I can certainly
see the value in both points of view.

So - let's provide a mechanism to let these two guys get what they want.

>>> The approach we took for the Tilera dataplane mode was to have a syscall
>>> that would hold the task in the kernel until any ticks were done, and only
>>> then return to userspace.  (This is the same set_dataplane() syscall that
>>> also offers some flags to control and debug the dataplane stuff in general;
>>> in fact the "hold in kernel" support is a mode we set for all syscalls, to
>>> keep things deterministic.)  This way the "busy loop" is done in the
>>> kernel, but in fact we explicitly go into idle until the next tick, so it's
>>> lower-power.
>>>
>> Yes, I saw that. My gripe with it is that puts the policy of what to do
>> while we wait for the tick to go away in the kernel. I usually hate the
>> kernel to take decisions on what to do. I want it to give mechanisms
>> and let the programmer set the policy.- e.g. have a led blink while
>> you're waiting for the
>> and the tick to go away so that the poor end user will know we are
>> still waiting for
>> the starts to align just right...
>
> This is a fair point.  On the other hand, the way we implemented it is
> basically just a mode flag that is checked on all returns from the kernel,
> that allow userspace to invoke kernel functions "synchronously", but
> slowly, and not get hammered later by unexpected interrupts.  So from that
> point of view, we don't expect userspace to have anything useful to do on
> return from syscalls or page faults other than wait in the kernel anyway.
> But if the application did want to do something fancy for those few
> hundredths of a second while the ticks settle, you could imagine not using
> this "wait in kernel" mode, and instead spinning on the proposed data
> structure described above.
>
>> I'm not sure that is so big a deal, but that is why I thought of a
>> signal handler.
>>
>>> An alternative approach, not so good for power but at least avoiding the
>>> "use the kernel to avoid the kernel" aspect of signals, would be to
>>> register a location in userspace that the kernel would write to when it
>>> disabled the tick, and userspace could then just spin reading memory.
>>>
>> That's cool for letting you know when the tick goes away but not for alarming
>> you when it suddenly came back... :-)
>
> Yes, and in fact delivering a signal is not a bad way to let the
> application know that either it, or the kernel, just screwed up.  Currently
> our dataplane code just handles this case with console backtraces (for the
> "debug" mode) or by shooting down the application with SIGKILL (in "strict"
> mode when it's said it wasn't going to use the kernel any more).
>

I didn't think about doing system calls later after starting. You can
certainly re-use
the signal handler approach there (app_started =0, do the  syscall and
then wait again)
but I admit that this is more involved then just issuing the system
call and letting the kernel
sort itself.

I guess we can always support a callback function to let you run code
when a nohz tasks
returns from kernel to user space - then you can do whatever you want...

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
