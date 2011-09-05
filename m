Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab1IENIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 09:08:47 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:33300 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab1IENIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 09:08:45 -0400
Message-ID: <bb2c259961b62bb8759df7d1f9ebc8f7.squirrel@webmail.greenhost.nl>
In-Reply-To: <201109051124.09775.vda.linux@googlemail.com>
References: <201109042311.18793.vda.linux@googlemail.com>
    <d1aa7eeee449fe4402a999ab686ed921.squirrel@webmail.greenhost.nl>
    <201109051124.09775.vda.linux@googlemail.com>
Date: Mon, 5 Sep 2011 15:08:41 +0200
Subject: Re: RFC: PTRACE_SEIZE needs API cleanup?
From: "Indan Zupancic" <indan@nul.nu>
To: "Denys Vlasenko" <vda.linux@googlemail.com>
Cc: "Oleg Nesterov" <oleg@redhat.com>, "Tejun Heo" <tj@kernel.org>,
        linux-kernel@vger.kernel.org, dvlasenk@redhat.com
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 1.0
X-Scan-Signature: 5a414de21e21bbd0d0187edd8a9585aa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, September 5, 2011 11:24, Denys Vlasenko wrote:
> On Monday 05 September 2011 03:15, Indan Zupancic wrote:
>> > So my proposal is:
>> > (a) make SEIZE take a parameter "immediately set these options on attach"
>>
>> I think that would be a great improvement.
>>
>> Better than making SEIZE an option itself, which I wanted to propose, but
>> never got to.
>
> Can't do. In pre-existing ptrace API, options can be set only after attach.
> Therefore, it's not possible to set an option which affects ATTACH behavior.

Your way is better anyway, so it's not important.

But what I meant is an option that does the actual attach, so it wouldn't
really be an option, more an action. Like I said, your way is better because
it makes much more sense, even though the behaviour is exactly the same.

>
>> > (b) without any options, make SEIZE just do "ATTACH sans SIGSTOP" thing,
>> >     nothing more.
>> > (c) make the following new PTRACE_O_foo options:
>> >    (1) "flag stops with PTRACE_EVENT_STOP event value in waitpid status"
>>
>> Why would anyone use that flag?
>
> Well, it's nice to not require GETSIGINFO in order to know whether this stop
> is group-stop.

Yes, but that's theory. But in practice..? Try to take a step back and
look at the big picture.

Most ptrace users aren't interested in group stops and just treat the two
events the same (because they don't expect the SIGSTOP notification when
WUNTRACED isn't set). And group stop doesn't work on traced tasks and
can't with the old behaviour, so group stop isn't interesting (as it's
broken), so why do a GETSIGINFO either? I totally agree that if you do
a GETSIGINFO now, this new option makes it easier, but I'm trying to
say that almost no user will do the GETSIGINFO either.

The ptrace users who do want group stop to work usually don't want to
interfere with it, they just want to know about it. PTRACE_EVENT_STOP
makes the knowing slightly easier, but it doesn't fix group stop.

>> Most users are unaware of the crazy subtle SIGSTOP notification madness.
>> It is totally unnecessary, just fix waitid()
>> to honour the absence of the WUNTRACED flag for traced processes.
>
> Can't do. Existing programs depend on current ptrace behavior.

But this whole thing is about changing current ptrace behaviour!
That's what the new options and PTRACE_SEIZE etc. are for.

Existing programs that depend on the current behaviour won't use them.
The ones that do use it know about the different behaviour and would
prefer a simpler and less quirky behaviour.

>> I can't
>> think of any useful scenario where calling waitid() with WUNTRACED set on
>> a traced task makes much sense, as the same information is received via
>> ptrace.
>
> Can't do. Existing programs depend on current ptrace behavior.

Existing programs won't use any option to change the current behaviour
if they depend on the current behaviour.

>
>> The other part of a simpler, less crazy ptrace is let PTRACE_CONT not
>> automatically continue a SIGSTOPped process.
>
> Can't do. gdb depends on current ptrace behavior that PTRACE_CONT
> restarts tracee after SIGSTOP.

That is a non-argument, see above. Either gdb uses the old behaviour and
doesn't set any new options, or it does and is aware of any behavioural
changes, including this.

If ptrace didn't interfere with group stop then gdb had no need to restart
the tracee with PTRACE_CONT. It wouldn't have to treat SIGSTOP any differently
than any other signals.

>
>> >    (2) "enable PTRACE_INTERRUPT. It either causes PTRACE_EVENT_STOP with sig=SIGTRAP
>> >         if (1) is enabled, or creates a group-stop with sig=SIGTRAP otherwise"
>> >        [if the second part is too weird to implement, make (2) require (1)]
>>
>> I don't understand the need for PTRACE_INTERRUPT: Sending some signal, trapping,
>> and PTRACE_CONT with zero "data" should have the same effect.
>
> Except that sending a signal will race with someone else sendng the same signal.
> It's nicer when this can be avoided.

That race is not important, because the signal you send you will block (data=0),
so the tracee will only see one signal. It doesn't matter which signal makes it
through, as they are indentical (I use SIGTERM) and the tracee only sees one.
Just don't use SIGIO or something like that.

>
>> Or do you mean that
>> instead of SIGSTOP, SIGTRAP should be sent? If so, yes, that would be much saner.
>
> Yes, that's how it works in 3.1 already.

But don't existing programs depend on current ptrace behavior?

See what I mean? Improving ptrace can be done.

>
>> >    (3) "enable PTRACE_LISTEN. Works on group-stops even without any other options"
>>
>> This is a symptom of the complexity I whined about above.
>>
>> If ptrace has no influence on group stops then PTRACE_LISTEN is not needed at all.
>> The problem seems to be that SIGSTOP state is the same as ptrace trapped state, or
>> something like that. Group stops and ptrace stops should be totally orthogonal.
>> Then crazy things like PTRACE_LISTEN are not needed.
>>
>> Why not just untangle the two concepts? (Via PTRACE_O_SANE.)
>
> You are a bit late to the party. Thre was a LONG discussion how to implement
> proper group-stop handling. You need to write a much more detailed proposal
> than this vague suggestion "let's add one flag which makes everythng better".
> How EXACTLY this flag will change ptrace bhavior?

I know! I'm fully aware of this. But I was too late for that long discussion,
and after that I couldn't keep up with all patchsets sent out. It makes little
sense to give detailed feedback when things might have totally changed again.
To be convincing at all I'd probably need to write patches too, so show the
advantages. But I never got to it. And at the time it was less clear to me
what the real behaviour regarding group stop is, as you guys kindly explained
to me.

----------------------------

To summarize, the flag would make ptrace have no effect on group stop state,
making SIGSTOP behaviour like any other signal behaves with ptrace. To get
there, when PTRACE_O_SANE is set, the user space behaviour changes seen are
as follows:

- In cases that ptrace sends a SIGSTOP, SIGTRAP is sent instead.

  (Your 4th proposal). So that ptrace never changes the group stop state of a task.

- waitid() honours the absence of the WUNTRACED flag.

  This prevents duplicate SIGSTOP events and the need to distinguish them
  from each other. No need for C.1 (PTRACE_EVENT_STOP). But if you still
  want it, it should be enabled by PTRACE_O_SANE too.

- PTRACE_CONT does not continue a stopped task.

  Tracer does not need to keep track of group stop state anymore, SIGSTOP and
  SIGCONT just work for traced tasks. No need for PTRACE_LISTEN. Tracer has
  still full control over stopped state of tracee because it can block SIGSTOP
  and SIGCONT signals, and send them itself.

- Unrelated, but to make things easier: Mark when a system call event is pre
  or post syscall.

----------------------------

I might have forgotten something, but I think this is pretty much all that's needed.
It would make everything simpler for everyone, IMHO. Can you think of any use case
that isn't solved by the above changes? All behavioural changes are group stop
related, something that is known to be broken, so not really anyone can much depend
on. And if they do, they don't have to enable any new option.

>
>> >    (5) "enable saner error codes"
>>
>> Why do you need a new option for this? Ptrace error codes are close to useless,
>> how can returning better error codes ever cause problems?
>
> Now ESRCH means "no such process, or process is not attached to us, or process
> is not stopped (it is running), or process has exited (it is a zombie now)".
> I'd like to make it into four different error codes.

That would make sense, yes. But assuming the program is bugfree, the only
case that can happen is "process has exited", and "no such process" for
ATTACH. Which one it is is clear from the context. To me it seems perfectly
save to change the error code for the two other cases, as that are program
bugs. I think you should just do it for those two cases and not bother with
a new option.

>
>> > In fact, I am unsure why the new ops (points 2 and 3 above) need enabling.
>> > Maybe they can be simply be always allowed? Let's see...
>>
>> My advise is to untangle all ptrace and group stop state from each other
>> with one PTRACE_O_SANE option. That would replace options 1 to 4. This
>> gives perhaps less choice, but considering how subtle it already is, I
>> don't think that simplifying everything is a bad thing.
>
> Again, please write a document how proposed PTRACE_O_SANE affects ptrace.
> *In details*.

See above. That's pretty much it, as far as user space behavioural changes.
Implementing it in the kernel is the tricky part, because ptrace is scattered
around between syscall entry/exit, signal handling and who knows where. (I
haven't pieced it all together yet.)

>
>> > Re PTRACE_INTERRUPT: "old-style" check for group-stop,
>> > namely, "if ptrace(PTRACE_GETSIGINFO) fails, then it's group-stop",
>>
>> BTW, no one is going to use and know this, except perhaps ten people in the
>> whole world.
>
> It is documented behavior. Latest released strace already uses it.

Where is it documented? Keep in mind that a wrong description of what's
happening was in the manpage for years and years, when %99 of all current
ptrace using code was written.

And it's in strace because one of you added it, I guess. But strace has
no use for it, it already knows that a task is stopped when the tracee
gets a SIGSTOP. Or in other words, strace doesn't want to use it, but it
has to because it gets multiple events for one SIGSTOP. And strace would
much prefer it if a SIGCONT on the tracee would continue it again. Now it
doesn't. To get there, strace code has to be made even more complicated
by using the PTRACE_LISTEN. That's not improving things.

You can't do anything much with the extra info, the only extra choice the
tracer has with it is to not call PTRACE_CONT on the SIGSTOP notification.
But then the tracee is forever stuck because it can't receive a SIGCONT
and strace doesn't know when it has to be continued. Ergo, why bother
distinguishing the two events?

>
>> Everyone else just thinks that ptrace doesn't pass on SIGSTOP,
>> as the manpage says, and that the double SIGSTOP event is just a quirk.
>
> We have an updated manpage. We are trying to push it into manpages git.
>
>
>> > 		if (!WIFSTOPPED(status)) ... /* error, should not happen */
>>
>> It may happen if you're tracing a child process and are getting a normal SIGCHLD?
>
> What?

Going into that if case. I think I've seen it happen once, but now I'm not sure.
I think I got confused with something else and it just can't happen.

>
>> > ...and here we decide to use either PTRACE_SYSCALL or PTRACE_LISTEN,
>> > _based on the value of "stopped" variable_. Here we PTRACE_LISTEN only if
>> > use_seize is true, but we use that flag only as indicator "this is a new kernel".
>> > It's easy to see that there are no intrisic reasons
>> > why it can't also work on newer kernels, but after using old-style ATTACH.
>>
>> So you're emulating normal group stop behaviour in the tracer, adding band-aids
>> that make that possible, instead of avoiding these problems by making ptrace
>> totally transparent for group stop state? Wouldn't it all be much simpler if
>> ptrace didn't mess with group stop state?
>
> As I said, gdb already depends on current ptrace behavior. We can't break it.

Then it won't use all those new flags either, and adding anything new makes
no sense.

The behaviour you're defending is generally subtle and unexpected behaviour
that most ptrace users don't expect. Gdb can't really work around it to make
SIGSTOP/SIGCONT work either, whatever it does, it's "broken" already. Giving
ptrace users a choice to pick simpler, more predicatble behaviour which solves
all group stop related problems looks like a good idea and I don't see why it
would break gdb.

All the workarounds for the current ptrace can just stay in place, but won't
be triggered or are harmless. To make group stop working gdb just has to do
exactly nothing special, when PTRACE_O_SANE is set. If it wants the double
SIGSTOP notification, it can set WUNTRACED. It already has to handle the new
SIGTRAP instead of SIGSTOP case, and you had no problem with that. Only thing
left is PTRACE_CONT not continuing a group stopped task. I don't know why gdb
would want to continue a task that someone else stopped with SIGSTOP, that's
interfering in the task's normal behaviour, something gdb usually doesn't want
to do. But if it wants, it can still do that by blocking/sending SIGSTOP/SIGCONT.

Best regards,

Indan


