Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab1IERVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 13:21:44 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:44312 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab1IERVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 13:21:37 -0400
Message-ID: <744dea57ff4cf2cc5a694b743e83e158.squirrel@webmail.greenhost.nl>
In-Reply-To: <1315231572.1888.35.camel@dhcp-25-63.brq.redhat.com>
References: <201109042311.18793.vda.linux@googlemail.com>
    <d1aa7eeee449fe4402a999ab686ed921.squirrel@webmail.greenhost.nl>
    <201109051124.09775.vda.linux@googlemail.com>
    <bb2c259961b62bb8759df7d1f9ebc8f7.squirrel@webmail.greenhost.nl>
    <1315231572.1888.35.camel@dhcp-25-63.brq.redhat.com>
Date: Mon, 5 Sep 2011 19:21:10 +0200
Subject: Re: RFC: PTRACE_SEIZE needs API cleanup?
From: "Indan Zupancic" <indan@nul.nu>
To: "Denys Vlasenko" <dvlasenk@redhat.com>
Cc: "Denys Vlasenko" <vda.linux@googlemail.com>,
        "Oleg Nesterov" <oleg@redhat.com>, "Tejun Heo" <tj@kernel.org>,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: bb0bf777761052205bd1aa6536360f60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, September 5, 2011 16:06, Denys Vlasenko wrote:
> On Mon, 2011-09-05 at 15:08 +0200, Indan Zupancic wrote:
>> >> > (b) without any options, make SEIZE just do "ATTACH sans SIGSTOP" thing,
>> >> >     nothing more.
>> >> > (c) make the following new PTRACE_O_foo options:
>> >> >    (1) "flag stops with PTRACE_EVENT_STOP event value in waitpid status"
>> >>
>> >> Why would anyone use that flag?
>> >
>> > Well, it's nice to not require GETSIGINFO in order to know whether this stop
>> > is group-stop.
>>
>> Yes, but that's theory. But in practice..? Try to take a step back and
>> look at the big picture.
>>
>> Most ptrace users aren't interested in group stops and just treat the two
>> events the same (because they don't expect the SIGSTOP notification when
>> WUNTRACED isn't set).
>
> Which users? strace? gdb? Something else?

Anyone using ptrace for whatever reason, including strace and gdb, until
they got "fixed" to know about this detail.

>> And group stop doesn't work on traced tasks
>
> Group-stop works, as in "ptraced task does stop on SIGSTOP".
> The problem is that we couldn't make it wait for SIGCONT without making
> it run.

Okay, group start and stop doesn't work then. Same thing, stopping something
while not being able to know when to continue it is not useful.

>
>> group stop isn't interesting (as it's
>> broken),
>
> Why do you think so?

For the reason you give above. It doesn't currently work, having it
half-working is not useful, so it's not that useful to know if a SIGSTOP
is a notification or a ptrace SIGSTOP event. In either case the task has
to be continued, or else it would be stuck forever. At best you can use
it to inform users in more detail what happens, in the case of strace
and gdb. It becomes slightly more interesting when group start and stop
both work, I agree.

>
>>  so why do a GETSIGINFO either? I totally agree that if you do
>> a GETSIGINFO now, this new option makes it easier,
>
> It is not a new behavior.
>
>
>>  but I'm trying to
>> say that almost no user will do the GETSIGINFO either.
>
> strace does. I don't know about gdb.

But how long does it do it, and how long did it work fine not doing it?
Strace 4.5.16 only uses it to print out signal address and pc if possible,
it doesn't use it for SIGSTOP. I haven't checked newer strace source,
that's the newest version on my hd.

>
>> The ptrace users who do want group stop to work usually don't want to
>> interfere with it, they just want to know about it.
>
> The point is, they can't "not interfere" with it. __WALL
> implicitly reports group-stops.

That can be changed. That is not documented behaviour of __WALL,
__WALL is supposed to tell for which tasks to give notifications,
not what kind. At least that's the impression after reading the
manpage.

If people want group-stop reports, they set WUNTRACED/WSTOPPED.
If they don't want it, they don't set it: But this choice is taken
away when ptracing.

>
>>  PTRACE_EVENT_STOP
>> makes the knowing slightly easier, but it doesn't fix group stop.
>
> Correct. PTRACE_LISTEN fixes it.

In a very convoluted way. It fixes the symptomps, but it doesn't fix
the problem, it works around it.

>
>> >> >    (2) "enable PTRACE_INTERRUPT. It either causes PTRACE_EVENT_STOP with
>> sig=SIGTRAP
>> >> >         if (1) is enabled, or creates a group-stop with sig=SIGTRAP otherwise"
>> >> >        [if the second part is too weird to implement, make (2) require (1)]
>> >>
>> >> I don't understand the need for PTRACE_INTERRUPT: Sending some signal, trapping,
>> >> and PTRACE_CONT with zero "data" should have the same effect.
>> >
>> > Except that sending a signal will race with someone else sendng the same signal.
>> > It's nicer when this can be avoided.
>>
>> That race is not important, because the signal you send you will block (data=0),
>> so the tracee will only see one signal.
>
> Signals don't queue. If you send SIGSTOP, and someone else sends SIGSTOP
> too at the same time, only one SIGSTOP will be delivered.
> If you suppress it, you lose that second SIGSTOP.

Ah, yes, didn't think about that. Then use a queuing rt signal instead.

>
>> >> Or do you mean that
>> >> instead of SIGSTOP, SIGTRAP should be sent? If so, yes, that would be much saner.
>> >
>> > Yes, that's how it works in 3.1 already.
>>
>> But don't existing programs depend on current ptrace behavior?
>
> Existing programs don't use PTRACE_INTERRUPT.

So it's only for PTRACE_INTERRUPT, not also for new childs?
Did PTRACE_INTERRUPT make it into the standard kernel already?
Damn, I thought the API changes would wait.

>> >> >    (3) "enable PTRACE_LISTEN. Works on group-stops even without any other
>> options"
>> >>
>> >> This is a symptom of the complexity I whined about above.
>> >>
>> >> If ptrace has no influence on group stops then PTRACE_LISTEN is not needed at all.
>> >> The problem seems to be that SIGSTOP state is the same as ptrace trapped state, or
>> >> something like that. Group stops and ptrace stops should be totally orthogonal.
>> >> Then crazy things like PTRACE_LISTEN are not needed.
>> >>
>> >> Why not just untangle the two concepts? (Via PTRACE_O_SANE.)
>> >
>> > You are a bit late to the party. Thre was a LONG discussion how to implement
>> > proper group-stop handling. You need to write a much more detailed proposal
>> > than this vague suggestion "let's add one flag which makes everythng better".
>> > How EXACTLY this flag will change ptrace bhavior?
>>
>> I know! I'm fully aware of this. But I was too late for that long discussion,
>> and after that I couldn't keep up with all patchsets sent out. It makes little
>> sense to give detailed feedback when things might have totally changed again.
>> To be convincing at all I'd probably need to write patches too, so show the
>> advantages. But I never got to it. And at the time it was less clear to me
>> what the real behaviour regarding group stop is, as you guys kindly explained
>> to me.
>>
>> ----------------------------
>>
>> To summarize, the flag would make ptrace have no effect on group stop state,
>
> Wait a second. How and when would you set this new flag?

Well, preferably with the new nifty PTRACE_SEIZE, or via PTRACE_SETOPTIONS.

But now you mention it, it would be very nice if PTRACE_TRACEME would also
accept options, just like PTRACE_SEIZE. (Or PTRACE_SEIZE with 0 pid would
work as PTRACE_TRACEME with options, but that's probably too confusing.)

>
>> making SIGSTOP behaviour like any other signal behaves with ptrace. To get
>> there, when PTRACE_O_SANE is set, the user space behaviour changes seen are
>> as follows:
>>
>> - In cases that ptrace sends a SIGSTOP, SIGTRAP is sent instead.
>>
>>   (Your 4th proposal). So that ptrace never changes the group stop state of a task.
>
> Problem. Now we interfere with SIGSTRAPs. Yes, there are users who want
> to be able to see real SIGTRAPs they send to the program,
> or ones generated by, say, int3 instruction on x86.

But SIGTRAP is ours, ptrace already sends SIGTRAPS at execve. Only change is
that it also sends one for new childs instead of SIGSTOP.

In this case we don't interfere because the tracer can know if it is a ptrace
trap by checking the extra bits. Except for the signal race and SIGTRAP not
queueing...

In any case, this is not a new problem. Changing SIGSTOP removes the group
stop interference, and increases the SIGTRAP interference in case of races.
But in the normal case non-ptrace traps aren't seen by tracees, if the tracer
takes some care (if it doesn't, then current program don't get their SIGTRAP
either).

>
>
>> - waitid() honours the absence of the WUNTRACED flag.
>
> (WUNTRACED is a horrible name. I prefer to use its alias WSTOPPED)
>
> "honours the absence of the WUNTRACED flag" per-tracee?
> Or do you want to set ptrace flag *on the tracer*? That would be new.

Err, maybe, that seems the most obvious way of doing it. But you can also
do it per tracer, it doesn't really matter. There must be ptrace specific
logic in waitid() ignoring WSTOPPED for tracees. Instead of blindly checking
that, it could also check this new flag.

In practice the effect is the same because tracers set the same options
on all tasks they trace, and tasks can be only traced by one tracer. If
all flags are moved to the tracer, it would be easy to implement multiple
tracers on the same task.

> How will strace or gdb show that process has stopped, if it doesn't know
> it? With SIGSTOP it's not really important (user can infer that), but
> what about SIGTSTP? If strace says "SIGTSTP was delivered", is process
> stopped now, or is it looping in the SIGTSTP handler?

Never heard of SIGTSTP, I don't know TTY black magic.

Tracers that want to get group stop notifications will set WSTOPPED and get
that information that way. But as ptrace won't generate any SIGSTOPs, they
don't have to use GETSIGINFO to know if it came from ptrace or not: It never
does.

>
>
>>   This prevents duplicate SIGSTOP events and the need to distinguish them
>>   from each other. No need for C.1 (PTRACE_EVENT_STOP). But if you still
>>   want it, it should be enabled by PTRACE_O_SANE too.
>
> I'm confused now. Does PTRACE_O_SANE disable or enable group-stop
> notifications?

Neither, it makes waitid() honour the presence and absence of the WSTOPPED
flag. It gives that choice back to the tracer.

>
>> - PTRACE_CONT does not continue a stopped task.
>
> You just said we will not get group-stops. How we can PTRACE_CONT from
> group-stop if we don't get group-stop?

Why would you want to do that? I think I don't understand you.

> In case you meant that "if we request group-stop notifications by using
> __WALL | WSTOPPED, and we get group-stop notification, and we do
> PTRACE_CONT, then task does not run (it sits in group-stop until SIGCONT
> or death)",

Exactly.

A group-stop notification is not really a ptrace event (maybe it is now),
so PTRACE_CONT wouldn't be needed. It's just a group stop notification,
not a freeze, report and wait event, like signals. But this is in my
mind, reality might be different.

> then we have a problem: gdb can't use this interface, it
> needs to be able to restart the thread (only one thread, not all of
> them, so sending SIGCONT is not ok!) from the group-stop. Yes, it's
> weird, but it's the real requirement from gdb users.

Is that true? Isn't a SIGCONT sent to the TID only for that thread instead
of the whole group? That's slightly inconvenient indeed. Perhaps this
limitation can be fixed? Might be troublesome for the main thread.

But this is for a group stop initiated by gdb, I suppose? In that case gdb
can just let the threads hang in the signal delivery path, and continue them
one by one, like it does now. Any group signal would work for this, doesn't
have to be SIGSTOP. E.g. a queueing rt signal that is blocked and never seen
by the tracee.

Would that work?

Because IMHO ptrace isn't the proper way of handling normal group stops,
signals are.

>
>>   Tracer does not need to keep track of group stop state anymore, SIGSTOP and
>>   SIGCONT just work for traced tasks.
>
> But if it *wants to*?

Then it still can, by setting WSTOPPED.

>
>>  No need for PTRACE_LISTEN. Tracer has
>>   still full control over stopped state of tracee because it can block SIGSTOP
>>   and SIGCONT signals, and send them itself.
>
> SIGCONT's side effect of waking up from group-stop can't be blocked.
> SIGCONT always wakes up all threads in thread group.
> Using SIGCONT to control tracee will race with SIGCONTs from other
> sources.
>
> This makes SIGCONT a too coarse instrument for the job.

No kidding. Perhaps the solution is to not use group stops for this in
the first place.

But PTRACE_CONT results in one traced task running while the rest is still
stopped, that could be called an often unwanted side effect too.

>
>> >> > Re PTRACE_INTERRUPT: "old-style" check for group-stop,
>> >> > namely, "if ptrace(PTRACE_GETSIGINFO) fails, then it's group-stop",
>> >>
>> >> BTW, no one is going to use and know this, except perhaps ten people in the
>> >> whole world.
>> >
>> > It is documented behavior. Latest released strace already uses it.
>>
>> Where is it documented? Keep in mind that a wrong description of what's
>> happening was in the manpage for years and years, when %99 of all current
>> ptrace using code was written.
>>
>> And it's in strace because one of you added it, I guess. But strace has
>> no use for it, it already knows that a task is stopped when the tracee
>> gets a SIGSTOP.
>
> No, it does not know it for the other three stopping signals,
> since they can have non-default handlers.
>
>> Or in other words, strace doesn't want to use it,
>
> I think it should show group-stops. It's useful information.

Then let it do so, there is no reason it can't with my proposal.

>>  but it
>> has to because it gets multiple events for one SIGSTOP. And strace would
>> much prefer it if a SIGCONT on the tracee would continue it again.
>
> Yes. But gdb prefers otherwise. That's why we need PTRACE_LISTEN for
> strace, and PTRACE_CONT for gdb.

Or gdb can stop using group stops to achieve what it wants. Gdb is the
strange use case, strace-like ptrace usage is the more common one. So
make the more common case simpler instead of complicating everything
for a corner gdb use case (however important it is).

Gdb can't want to have both transparent group stop behaviour, and also
hijack group stops for thread running control. Letting it hang in ptrace
is fine for gdb, that's what it does now. Let it keep doing it, it can
even let it hang in SIGSTOP delivery path, it doesn't really matter.
Only change is that tasks are in trapped state instead of actually
stopped. That is an improvement, because then unrelated SIGCONT's can't
interfere with gdb's debugging. But with PTRACE_CONT not continuing group
stopped tasks it gives gdb the ability to transparently debug externally
stopped and started tasks. It still can stop all tasks and continue them
one by one as it does now.

>> You can't do anything much with the extra info,
>
> strace can print it, a-la:
>
> --- stopped by SIGTTIN ---

True. That stays true though.

>
>> >> > ...and here we decide to use either PTRACE_SYSCALL or PTRACE_LISTEN,
>> >> > _based on the value of "stopped" variable_. Here we PTRACE_LISTEN only if
>> >> > use_seize is true, but we use that flag only as indicator "this is a new kernel".
>> >> > It's easy to see that there are no intrisic reasons
>> >> > why it can't also work on newer kernels, but after using old-style ATTACH.
>> >>
>> >> So you're emulating normal group stop behaviour in the tracer, adding band-aids
>> >> that make that possible, instead of avoiding these problems by making ptrace
>> >> totally transparent for group stop state? Wouldn't it all be much simpler if
>> >> ptrace didn't mess with group stop state?
>> >
>> > As I said, gdb already depends on current ptrace behavior. We can't break it.
>>
>> Then it won't use all those new flags either, and adding anything new makes
>> no sense.
>
> Yes... until gdb will want to give user a choice after SIGSTOP: continue
> to sit in group-stop until SIGCONT (wasn't possible until
> PTRACE_LISTEN), or continue executing (gdb's current behavior if user
> uses "continue" command). Therefore, gdb needs a way to do both.

But are users expected to send SIGSTOPs manually when debugging, instead
of hitting ctlr+z or whatever?

Anyway, gdb can give this choice when it receives the SIGSTOP:
If users want it to go into group stop, gdb does PTRACE_CONT.
If users want to selectively continue running, gdb continues
select threads while blocking the SIGSTOP delivery.

Would this work for gdb, or is there some problem with this solution?

>
>> The behaviour you're defending is generally subtle and unexpected behaviour
>> that most ptrace users don't expect.
>
> What behavior do I defend? That we get both signal-stops and
> group-stops? I don't "defend" it, it's just what we _already have_. We
> need to do minimal amount of changes.

The group stop interference behaviour. I don't think that adding
PTRACE_INTERRUPT, PTRACE_LISTEN and all those new options is the
minimal amount of change, especially not when including the user
space changes needed to make use of this.

> In short, you propose to make it possible to switch off group-stop
> notification.

That is just part of the proposal, the main this is to not let PTRACE_CONT
continue a stopped task. Switching off group-stop notifications makes it
only easier to use ptrace when not specifically interested in group stops.

> This makes it necessary to decide whether you want to
> continue or to stop on SIGSTOP *beforehand*, when you enter waitpid().

No, only if you want to get the group notification. That would be true
if PTRACE_CONT continues a task, but if that's not true, then it's pure
a choice whether to get those notifications or not.

At waitpid() time you can do whatever you want, including the old behaviour.

> My points are:
> (1) in strace, this would deprive us of a useful bit of information
> about the process.

It's a choice, if you want group notifications, then ask for them.
Current ptrace takes that choice away, that's all.

> (2) in gdb case, this may be too constraining for us: we want to be able
> to decide what to do on group-stop *after* group-stop has happened!

See above, that should be still possible. Or am I missing something?

Greetings,

Indan


