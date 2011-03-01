Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab1CAPZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:25:06 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33016 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab1CAPZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:25:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=XqQkTLMgjYC9mLYE3Dp6lNAMybPpLlLKoT/+Fn+zj7p3uDTOyq36oc7pdaSe408B3j
         Hm2yfN3b7z1KJuqhTPRlZtoPQ7u171OaE9nAaPX3eXXYHNiP2JtCNzHIgu3cMQys6894
         JibgwbEosppe+cg3oBbdMn+o6us2th3FLMHtk=
Date: Tue, 1 Mar 2011 16:24:57 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: [RFC] Proposal for ptrace improvements
Message-ID: <20110301152457.GE26074@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current ptrace implementation has many issues on various aspects.
Some of them are outright bugs.  Some are ambiguously defined grey
areas and others are missing features.  Among these, the most
promienent is interactions with jctl (job control) where nothing is
really well defined and the current behaviors are broken to the point
where achieving transparency with userland work-arounds is impossible.

During the past couple of months, there have been some dicussions on
how to improve ptrace[1].  I'd like to summarize some of it and
describe what I think would be a good way to proceed.


IDENTIFIED ISSUES
-----------------

I1. TASK_STOPPED and TASK_TRACED

Currently, a tracee may stop in two different ways.  When stopping for
jctl, it stops inside do_signal_stop() and puts itself into
TASK_STOPPED.  For ptrace traps, it stops inside ptrace_stop() with
TASK_TRACED.

The biggest difference between the two stops is that when a tracee is
in TASK_STOPPED, it can be resumed by emission of SIGCONT (as Roland
pointed out, emission ends jctl stop, not reception), while only the
tracer and SIGKILL can resume from TASK_TRACED.

When a tracer issues a ptrace request to a TASK_STOPPED tracee, the
tracer silently changes the tracee's state from TASK_STOPPED to
TASK_TRACED.  This behavior is probably intended to enable some level
of job control transparency, so that a tracee can still be stopped and
resumed by jctl; unfortunately, this silent transition is problematic.

* Some architectures require tracees to take certain steps before
  being poked by tracers.  This is implemented as arch_ptrace_stop()
  callback in ptrace_stop().  The silent transition from TASK_STOPPED
  to TASK_TRACED skips this step and may result in presenting
  incorrect tracee states to tracers.

* Any ptrace request initiates the silent transition.  As tracers
  can't obtain a lot of information from wait(2), they usually have to
  issue one or more ptrace requests after notification, which forces
  tracees into TASK_TRACED making the whole transparency thing moot.

* The mixed use of jctl and ptrace stop is error-prone.  For example,
  wait(2) exit_code handling is different between TASK_STOPPED and
  TASK_TRACED.  Using jctl stop while ptraced makes it more
  complicated and fragile.

* If a tracee is continued by SIGCONT before its tracer issues a
  ptrace request, the ptrace request would fail with -ESRCH.  Due to
  the tracer behavior described above, the window is usually very
  small.  This necessiates a cold path which would be travelled
  seldomly and thus not tested very well.


I2. Loss of jctl notifications to real parent

When a task is ptraced, it gets "re-parented" to the tracer.  The
tracer becomes the parent and intercepts jctl notifications.  This
means, among other things, that when gdb(1) or strace(1) is attached
to a process which is run from an interactive shell, the usual jctl
mechanism via ^Z doesn't work.  The STOP signal is sent but the shell
is never notified that the child has stopped.


I3. Not well-defined job control behaviors while traced

In general, jctl behaviors while ptraced aren't well defined.  The
currently implemented behaviors are undeterministic and ambiguous on
many aspects; however, thanks to the previously described
shortcomings, jctl while traced is broken to the point where these
ambiguities don't matter all that much.


I4. SIGSTOP sent on PTRACE_ATTACH

PTRACE_ATTACH implies SIGSTOP.  This makes it impossible for the
tracer to be transparent with respect to jctl from the get-go.


BASELINE
--------

First, I'd like to lay out two existing rules of the current ptrace
implementation as they became points of contention.

* ptrace is by large task-centric.  When PTRACE_ATTACH happens, the
  reparenting separates the tracee from the task group (process) and
  most interactions are confined between the tracer and tracee.  In
  the current code, the only notable exception is the implied SIGSTOP
  on attach which affects the whole process.

* PTRACE_CONT and other requests which resume the tracee overrides, or
  rather works below, jctl stop.  If jctl stop takes place on the task
  group a tracee belongs to, the tracee will eventually participate in
  the group stop and its tracer will be notified; however, when
  PTRACE_CONT or other resuming request is made, the tracee will
  resume execution regardless of and without affecting the jctl stop.

I don't know whether these are by design or just happened as
by-products of the evolution of task group implementation in the
kernel, but regardless, in my opinion, both rules are sound and
useful.  They might not be immediately intuitive and the resulting
behavior might seem quirky but to me it seems to be one of those
things which looks awkward at first but is ultimately right in its
usefulness and relative simplicity.

More importantly, it doesn't matter what I or, for that matter, anyone
else thinks about them.  They're tightly ingrained into the
userland-visible behavior and actively exploited by the current users
- for example, dynamic evalution in tracee context in gdb(1).
Changing behaviors as fundamental as these would impact the current
applications and debugging behaviors expected by (human) users.

So, I don't think it's possible or even desirable to change these
basic rules even if it makes certain aspects of jctl and ptrace
interaction more elegant.

I don't believe every detail of kernel behavior should remain
completely static.  There are behavior changes which go unnoticed or
are even wildly welcome but changing these is way out of scope.  If
we're gonna make changes as fundamental as these, we really should be
looking at implementing a completely new API and planning for
deprecation of the current one.  Such API deprecation, in turn,
requires very strong supporting rationales, which I don't see here,
not when the existing one can be improved to be, far from perfect but,
useful and sane _enough_.

What we can and should do is much more gradual approach.  First, fix
the existing bugs, iron out ambiguities and so on.  In the process,
there will be minor behavior changes.  We'll be fixing user-visible
bugs too after all, but we actually have some latitude thanks to the
wild breakages.  Then, we can add small pieces to augment the existing
interface.


PROPOSAL
--------

P1. Always TASK_TRACED while ptraced

The silent transition from TASK_STOPPED to TASK_TRACED is outright
buggy.  If the tracer wants to transit the tracee into TASK_TRACED, it
should ask the tracee to wake up, execute the necessary steps and then
enter TASK_TRACED.

As described in I1, entering TASK_STOPPED while ptraced doesn't bring
a lot of benefits while giving rise to several issues.  I think it's
best to always enter TASK_TRACED while traced whether the stop is for
jctl or ptrace trap.  After all, it's not like jctl stops while traced
can be handled the same way as usual jctl stops.  They require special
ptrace specific handling.

This introduces two behavioral differences.  One is that the
TASK_STOPPED <-> TASK_RUNNING <-> TASK_TRACED transitions become
visible via /proc and other subtleties.  We can use different levels
of workarounds to mask these transitions.  In my opinion, it's enough
to mask the transition from the tracing task itself.  IOW, if the
tracer is multi-thread or process, the transitions could be visible to
other threads and processes but are always transparent to the ptracing
thread.

The second difference is that the tracee would now be in TASK_TRACED
immediately after it stops for jctl while ptraced.  As described above
this feature isn't really useful and the existing users can't and thus
don't take advantage of it.  They immediately follow wait(2)
notifications with PTRACE requests putting the tracee into
TASK_TRACED.  I highly doubt the change would be noticeable or missed.


P2. Fix notifications to the real parent

This pleasantly proved to be the least contentious change to make.
The usual group stop / continued notifications should be propagated to
the real parent whether the children are ptraced or not.  There isn't
much to be discussed about the wanted behavior.  Notifications which
would have been generated and delivered to the real parent in the
absense of ptrace should be generated and delivered to the real parent
the same.


P3. Keep ptrace resume separate from and beneath jctl stop

As written above, I think the current ptrace behavior, despite a lot
of rough edges, is in the right direction in that ptrace operates
beneath jctl.  Therefore, keep the basic operation principles but
clearly define how jctl and ptrace interacts, or rather, how they
don't.  The following two rules clearly separate jctl and ptrace.

* jctl stop initiates when one of the stop signals is received and
  completes when all the member tasks participate in the group stop,
  where participation preciesly means that a member task stops in
  do_signal_stop().  Any member task can only participate once in any
  given group stop.  ptrace does NOT make any difference in this
  regard.

* However, PTRACE_DETACH should maintain the integrity of group stop.
  After a tracee is detached, it should be in a state which is
  conformant to the current jctl state.  If jctl stop is in effect,
  the task should be put into TASK_STOPPED; otherwise, TASK_RUNNING.


P4. PTRACE_SEIZE

As the implied SIGSTOP is very visible from userland, solving I4
mandates a different way to attach to a tracee.  There is a proposal
from Roland[2], but I'd like to propose something slightly different.

Roland proposed two new ptrace requests - PTRACE_ATTACH_NOSTOP and
PTRACE_INTERRUPT.  As the name implies, PTRACE_ATTACH_NOSTOP attaches
to the specified task but doesn't do anything about its execution
state and PTRACE_INTERRUPT interrupts execution of a tracee without
affecting its jctl state.

I don't think it's a good idea to attach without putting the tracee
into TASK_TRACED.  The API becomes more complex because attaching
doesn't atomically establish a fixed state as shown by the necessity
for PTRACE_O_INHERIT and the ability to set other options on
PTRACE_ATTACH_NOSTOP.

I can't see much, if any, benefit in implementing ATTACH and INTERRUPT
separately.  They can be combined into one request, say, PTRACE_SEIZE.
If the target task isn't already attached, it attaches and puts the
tracee into TASK_TRACED.  If already attached, the tracee is forced
into TASK_TRACED.  In both cases, jctl state is unaffected.

Completion notification is delivered in the usual way via wait(2).  If
the task was in jctl stop, it would report the stop signal with the
matching siginfo.  If the task hits an existing ptrace trap condition,
the matching SIGTRAP will be reported; otherwise, SIGTRAP will be
reported with siginfo indicating PTRACE_SEIZE trap.

IOW, PTRACE_SEIZE guarantees that the tracee, whether new or existing,
enters TASK_TRACED.  If there is an existing stop condition, that will
be taken and reported; otherwise, PTRACE_SEIZE trap will be reported.


P5. "^Z" and "fg" for tracees

A ptracer, as it currently stands and proposed here, has full control
over the execution state of its tracee.  The tracer is notified
whenever the tracee stops and can always resume its execution;
however, there is one missing piece.

As proposed, when a tracee enters jctl stop, it enters TASK_TRACED
from which emission of SIGCONT can't resume the tracee.  This makes it
impossible for a tracer to become transparent with respect to jctl.
For example, after strace(1) is attached to a task, the task can be
^Z'd but then can't be fg'd.

One approach to this problem is somehow making it work implicitly from
the kernel - as in putting the tracee into TASK_STOPPED or somehow
handling TASK_TRACED for jctl stop differently; however, I think such
approach is cumbersome in both concept and implementation.  Instead of
being able to say "while ptraced, a tracee's execution is fully under
the control of its tracer", subtle and fragile exceptions need to be
introduced.

A better way to solve this is simply giving the tracer the capability
to listen for the end of jctl stop.  That way, the problem is solved
in a manner which is consistent, may not be to everyone's liking but
nonetheless consistent, with the rest of ptrace.  Execution state of
the tracee is always under the control of the tracer.  The only thing
which changes is that the tracer now can find out when jctl stop ends,
which also could be an additional useful debugging feature.

It would be most fitting to use wait(2) for delivery of this
notification.  WCONTINUED is the obvious candidate but I think it is
better to use STOPPED notification because the task is not really
resumed.  Only its mode of stop changes.  What state the tracee is in
can be determined by retriving siginfo using PTRACE_GETSIGINFO.

This also effectively makes the notification level-triggered instead
of edge-triggered, which is a big plus.  No matter which state the
tracee is in, a jctl stopped notification is guaranteed to happen
after the lastest event and the tracer can always find out the latest
state with PTRACE_GETSIGINFO.

Using stopped notification also makes the new addition harmless to the
existing users.  It's just another stopped notification.  Both
strace(1) and gdb(1) don't distinguish the signal delivery and jctl
stop notifications and react the same way by resuming the tracee
unconditionally.  One more stopped notification on SIGCONT emission
doesn't change much.

Of course, another way to add this is selectively enabling it when the
tracee was attached with PTRACE_SEIZE, but unless necessary, and given
that SIGCONT currently simply doesn't work while ptraced I think it's
unnecessary, it would be much better to avoid such implied subtle
behavior difference.


WAY FORWARD (yeah, I'm feeling some marketing vibe)
-----------

ptrace currently is in a pretty bad shape and I think one of the
biggest reasons is a lot of effort has been spent trying to come up
with something completely new instead of concentrating on improving
what's already there.  I think the existing principles are pretty
sound.  They just need some love and attention here and there.

I believe the proposed approach covers most of the raised issues in a
gradual and evolutionary manner.  If I missed something, scream it to
me but let's _please_ concentrate on gradual improvements.  What
someone would want if one could start from the scratch is interesting
but ultimately irrelevant.  We have what we have and that's where we
build from.  Like our eyes - the frigging wiring is in front of the
sensor array but still my pair have been working pretty well for me.

Once agreed upon, I think I'll be able to implement the proposed
changes in relatively short time, probably ready to be merged during
2.6.40-rc1.  So, let's move on.

Thank you.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1093410
[2] http://sourceware.org/ml/archer/2011-q1/msg00026.html
