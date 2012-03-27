Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab2C0PnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 11:43:19 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:14327 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab2C0PnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 11:43:16 -0400
Message-ID: <4F71E012.7050907@tilera.com>
Date: Tue, 27 Mar 2012 11:43:14 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Gilad Ben-Yossef <gilad@benyossef.com>
CC: Christoph Lameter <cl@linux.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        <linaro-sched-sig@lists.linaro.org>,
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
Subject: Re: [PATCH 11/32] nohz/cpuset: Don't turn off the tick if rcu needs
 it
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com> <1332338318-5958-13-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.1203210953220.20482@router.home> <CAOtvUMdkU92t0nj9OXsnzCenuOyjb12x6s11xR_GGJu1aJJ7GA@mail.gmail.com> <4F6B5ED1.1080300@tilera.com> <CAOtvUMdtprdVxG3d5B-W6Y98SNg1kZms=Q+tmamqN9YkWsiWBg@mail.gmail.com>
In-Reply-To: <CAOtvUMdtprdVxG3d5B-W6Y98SNg1kZms=Q+tmamqN9YkWsiWBg@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/27/2012 11:31 AM, Gilad Ben-Yossef wrote:
> On Thu, Mar 22, 2012 at 7:18 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
>> On 3/22/2012 3:38 AM, Gilad Ben-Yossef wrote:
>>> On Wed, Mar 21, 2012 at 4:54 PM, Christoph Lameter <cl@linux.com> wrote:
>>>> On Wed, 21 Mar 2012, Frederic Weisbecker wrote:
>>>>
>>>>> If RCU is waiting for the current CPU to complete a grace
>>>>> period, don't turn off the tick. Unlike dynctik-idle, we
>>>>> are not necessarily going to enter into rcu extended quiescent
>>>>> state, so we may need to keep the tick to note current CPU's
>>>>> quiescent states.
>>>> Is there any way for userspace to know that the tick is not off yet due to
>>>> this? It would make sense for us to have busy loop in user space that
>>>> waits until the OS has completed all processing if that avoids future
>>>> latencies for the application.
>>>>
>>> I previously suggested having the user register to receive a signal
>>> when the tick
>>> is turned off. Since the tick is always turned off the user task is
>>> the current task
>>> by design, *I think* you can simply mark the signal pending when you
>>> turn the tick off.
>>>
>>> The user would register a signal handler to set a flag when it is
>>> called and then busy
>>> loop waiting for a flag to clear.
>> This sounds plausible, but the kernel would have to know that the tick not
>> only was stopped currently, but also would still be stopped when the signal
>> handler's sigreturn syscall was performed.
> Well, I'd say send a signal when the tick is turned off and another
> signal when it's
> turned on again.

The thing is, what our customers seem to want is to be able to tell the
kernel to go away and not bother them again, ever, as long as their
application is running correctly.  Obviously if it crashes, or if some
intervention is required, or whatever, they want the kernel to step in, but
otherwise the proposed signal mechanisms don't seem to help the case that
they're interested in.  I don't think we've seen a customer application
where the signal mechanism would be helpful (unfortunately, since it does
seem like a cool idea).

Basically if the kernel interrupts a nohz application core, that's a fail. 
It's interesting to know that such a fail has happened, but sending a
signal just makes it an even worse fail: more overhead.  One thing I could
imagine that might be useful would be to register a region of user memory
that the kernel could put statistics of some kind into, obviously the
"bool" flag that says whether you're running tickless, but also things like
a count of the number of interrupts (e.g. ticks, but really anything) the
kernel had to deliver, the time of the last interrupt that was delivered,
maybe some breakdown by type of interrupt, etc.  Then if the application
detects an interruption, or perhaps just periodically, it can inspect that
state area and report on any bad developments: and these would be basically
kernel bugs from failing to protect the nohz core the way it had asked, or
else application bugs from accidentally requesting a kernel service
unintentionally.

>> The problem we've seen is that
>> it's sometimes somewhat nondeterministic when the kernel might decide it
>> needed some more ticking, once you let kernel code start to run.  For
>> example, for RCU ops the kernel can choose to ignore the nohz cpuset cores
>> when they're running userspace code only, but as soon as they get back into
>> the kernel for any reason, you may need to schedule a grace period, and so
>> just returning from the "you have no more ticks!" signal handler ends up
>> causing ticks to be scheduled.
> There is no real difference from the user stand point between the
> return signal sys call
> doing something that causes the tick to be turned on and an IPI or
> timer that turns on
> the tick a nano second after the signal return system call returned.
>
> The return signal syscall setting the tick on is just a private,
> though annoying, case of the
> tick getting turned on by something.

Yes, but see above: the claim I'm making is that we can arrange for a
well-behaved application to *expect* not to get kernel interrupts, so if
they happen, something has gone wrong.

>> The approach we took for the Tilera dataplane mode was to have a syscall
>> that would hold the task in the kernel until any ticks were done, and only
>> then return to userspace.  (This is the same set_dataplane() syscall that
>> also offers some flags to control and debug the dataplane stuff in general;
>> in fact the "hold in kernel" support is a mode we set for all syscalls, to
>> keep things deterministic.)  This way the "busy loop" is done in the
>> kernel, but in fact we explicitly go into idle until the next tick, so it's
>> lower-power.
>>
> Yes, I saw that. My gripe with it is that puts the policy of what to do
> while we wait for the tick to go away in the kernel. I usually hate the
> kernel to take decisions on what to do. I want it to give mechanisms
> and let the programmer set the policy.- e.g. have a led blink while
> you're waiting for the
> and the tick to go away so that the poor end user will know we are
> still waiting for
> the starts to align just right...

This is a fair point.  On the other hand, the way we implemented it is
basically just a mode flag that is checked on all returns from the kernel,
that allow userspace to invoke kernel functions "synchronously", but
slowly, and not get hammered later by unexpected interrupts.  So from that
point of view, we don't expect userspace to have anything useful to do on
return from syscalls or page faults other than wait in the kernel anyway. 
But if the application did want to do something fancy for those few
hundredths of a second while the ticks settle, you could imagine not using
this "wait in kernel" mode, and instead spinning on the proposed data
structure described above.

> I'm not sure that is so big a deal, but that is why I thought of a
> signal handler.
>
>> An alternative approach, not so good for power but at least avoiding the
>> "use the kernel to avoid the kernel" aspect of signals, would be to
>> register a location in userspace that the kernel would write to when it
>> disabled the tick, and userspace could then just spin reading memory.
>>
> That's cool for letting you know when the tick goes away but not for alarming
> you when it suddenly came back... :-)

Yes, and in fact delivering a signal is not a bad way to let the
application know that either it, or the kernel, just screwed up.  Currently
our dataplane code just handles this case with console backtraces (for the
"debug" mode) or by shooting down the application with SIGKILL (in "strict"
mode when it's said it wasn't going to use the kernel any more).

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

