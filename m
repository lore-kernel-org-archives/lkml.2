Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750977Ab0KDEH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 00:07:59 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:43524 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab0KDEH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 00:07:57 -0400
Message-ID: <4CD23087.30900@cs.columbia.edu>
Date: Thu, 04 Nov 2010 00:03:19 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Lightning/1.0b1 Thunderbird/3.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu> <4CD08419.5050803@kernel.org>
In-Reply-To: <4CD08419.5050803@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(disclaimer: you may want to grab a cup of your favorite coffee)

On 11/02/2010 05:35 PM, Tejun Heo wrote:
> (cc'ing lkml too)
> Hello,
> 
> On 11/02/2010 08:30 PM, Oren Laadan wrote:
>> Following the discussion yesterday, here is a linux-cr diff that
>> that is limited to changes to existing code.
>>
>> The diff doesn't include the eclone() patches. I also tried to strip
>> off the new c/r code (either code in new files, or new code within
>> #ifdef CONFIG_CHECKPOINT in existing files).
>>
>> I left a few such snippets in, e.g. c/r syscalls templates and 
>> declaration of c/r specific methods in, e.g. file_operations.
>>
>> The remaining changes in this patch include new freezer state
>> ("CHECKPOINTING"), mostly refactoring of exsiting code, and a bit
>> of new helpers.
>>
>> Disclaimer: don't try to compile (or apply) - this is only intended
>> to give a ballpark of how the c/r patches change existing code.
> 
> The patch size itself isn't too big but I still think it's one scary
> patch mostly because the breadth of the code checkpointing needs to
> modify and I suspect that probably is the biggest concern regarding
> checkpoint-restart from implementation point of view.

I agree, it *looks* scary. But that's mostly because it's a dumb
diff out of context, rather than a  standard "patch" as set of
logical incremental changes. So posting this diff is probably the
worst way to present the impact on existing code. It merely gives
a ballpark of that.

However, please keep in mind that this diff is really an aggregate
of multiple unrelated, structured, small changes, including:
- cleanups (e.g. x86 ptrace)
- refactoring (e.g. ipc, eventpoll, user-ns)
- new features/enhancements (e,g. splice, freezer, mm)

I'm confident that each of these will make more sense when presented
in the proper context.

> 
> FWIW, I'm not quite convinced checkpoint-restart can be something

In the ksummit presentation I gave an extensive list of real
use-cases (existing and future). The slides are here:
    http://www.cs.columbia.edu/~orenl/talks/ksummit-2010.pdf

For more technical details there is also the OLS-2010 paper here:
    http://www.cs.columbia.edu/~orenl/papers/ols2010-linuxcr.pdf
presentation slide from there are here:
    http://www.cs.columbia.edu/~orenl/talks/ols2010-linuxcr.pdf

> which can be generally useful.  In controlled environments where the
> target application behavior can be relatively well defined and
> contained (including actions necessary to rollback in case something
> goes bonkers), it would work and can be quite useful, but I'm afraid
> the states which need to be saved and restored aren't defined well
> enough to be generally applicable.  Not only is it a difficult
> problem, it actually is impossible to define common set of states to
> be saved and restored - it depends on each application.

I'm unsure which states you have in mind that will not be well defined.

It is a difficult problem, and C/R has limitations, but I think we've
got it pretty right this time :)

* we save and restores *all* *execution* state of the applications
 (except for well-defined unsupported features; hardware devices
 are one such example).

* we don't save FS state (use filesystem snapshots for that); but
 we do save runtime FS state (e.g. open files, etc).

* we don't save state of peers (applications/systems) over network;
 but we do save network connections for proper live-migration.

(Of course, there is a supporting userspace ecosystem, like utilities
to do the checkpoint/restart, to freeze/thaw the application, to
snapshot the filesystem etc).

So unless the applications uses unsupported resource - it will be
possible to checkpoint that application and restart successfully.

> 
> As such, I have difficult time believing it can be something generally
> useful.  IOW, I think talking about its usage in complex environments
> like common desktops is mostly handwaving.  What about X sessions,
> network connections, states established in other applications via dbus
> or whatnot?  Which files need to be snapshotted together?  What about
> shared mmaps?  These questions are not difficult to answer in generic
> way, they are impossible.

I have a cool demo (and I gave one today!) that shows how I run one
desktop session and restart an older desktop session that then runs
in parallel to my existing session, in another windows -> so I have
both current and older session running side by side. (it's an version
of C/R as kernel module for older kernel, we're not yet there with
linux-cr). Hand-waving ?  maybe, but a pretty convincing one ;)

To be clear, C/R is more generic than save/restore a single process:
rather, it works on process hierarchies (and complete containers).
So a checkpoint will typically capture the state of e.g. a VNC server
(X session) and the applications (xterm, win-manager etc), and the
dbus daemon, and all their open files, and sockets etc.

(BTW, if you were to live-migrate that X session to another host,
we'd save the TCP state as well; otherwise, we save the sockets in
CLOSED state - analogous to what happens when your applications run
again after the laptop was suspended for a long time).

Likewise, in my demo, files are not snapshotted independently. Instead,
the entire file system is snapshotted at once.

Bottom line - it's simpler than what it sounds. Let's compare this to
the save/restore of an entire VM: in VM you bundle all the state inside
as a single big package (and this makes life much easier). Likewise, in
C/R, we bundle all the necessary processes, e.g. an entire container,
in a single big package - we pack all the data necessary to make the
checkpoint self-sufficient.

> 
> There is a very distinctive difference between system wide
> suspend/hibernation and process checkpointing.  Most programs are
> already written with the conditions in mind which can be caused by
> system level suspend/hibernation.  Most programs don't expect to be
> scheduled and run in any definite amount of time.  There usually
> are provisions for loss or failure of resources which are out of the
> local system.  There are corner cases which are affected and those
> programs contain code to respond to suspend/hibernation.  Please note
> that this is about userland application behavior but not
> implementation detail in the kernel.  It is a much more fundamental
> property.

Exactly. This means that the same applications would not be upset
after they are checkpointed/restarted, for the exact same reason -
they know how to "recover" from that. For instance, firefox will
re-establish a network connection to the web server, for instance.

C/R is as *transparent* as suspend/hibernation. Applications will
normally not be able to tell the difference between just having
experienced a suspend/hibernation or a checkpoint/restart.

> So, although checkpoint-restart can be very useful for certain
> circumstances, I don't believe there can be a general implementation.
> It inevitably needs to put somewhat strict restrictions on what the
> applications being checkpointed are allowed to do.  And after my

Let me try to rephrase: there are restrictions to what applications
do if they are to be successfully checkpointed. Examples:
 * tasks that use hardware devices (e.g. sound card),
 * tasks that use unsupported sockets (e.g. netlink),
 * tasks that use yet-unsupported feature (e.g. ptraced tasks)

That said, I'm quite confident that the set of features we support
(now or within easy reach) already cover a wide range of real
applications and use-cases.

> train of thought reaches there, I fail to see what the advantages of
> in-kernel implementation would be compared to something like the
> following.
> 
>   http://dmtcp.sourceforge.net/
> 
> Sure, in-kernel implementation would be able to fake it better, but I
> don't think it's anything major.  The coverage would be slightly
> better but breaking the illusion wouldn't take much.  Just push it a
> bit further and it will break all the same.  In addition, to be

I beg to differ.

DMTCP is indeed a very cool project. It's based on MTCP, a userspace
C/R tool, and as such, is restricted like all userspace implementations.
That is not to say that it isn't useful, but it is limited in what it
can do.

It is not my intention to bash their great work, but it's important to
understand its limitations, so just a few examples:

* Transparency: their papers says that it's required to link against
 their library, or modify the binary; they overload some signals (so
 the application can't use them)
* Completeness: many real resources are not supported, e.g. eventpoll,
 ipc, pending signals, etc.
* Complexity: they technically implement a virtual pid-namespace in
 userspace by intercepting calls to clone(). I wonder if they consider
 e.g. pid's saved on file owners or in afunix creds ?  I'll just say
 it's nearly impossible with their 20K lines of code - I know because
 I did it in a kernel module ...
* Efficiency: from userspace it can't tell which mapped pages are dirty
 and which aren't, not to mention doing incremental checkpoints.
* Usefulness: can they live-migrate mysql server between two hosts
 prior to a kernel upgrade ?  can they checkpoint stopped processes
 which cannot cooperate ?  can they checkpoint/restart postgresql ?

In contrast, the kernel C/R is:

* much more complete and feature-rich,
* entirely transparent to applications (does not need their cooperation,
 can even do debugged tasks)
* can be highly optimized and do incremental c/r
* can do live migration
* is easier to maintain in the long run (because you don't need to cheat
 applications by intercepting their kernel calls from userspace!)
* flexible to allow smart userspace to also be c/r aware, if they so wish
* can provide a guarantee that a checkpoint is self-contained and can
 be later restarted

In fact, DMTCP will be much more useful if it builds on linux-cr
as its chekcpoint-restart engine ;)

> useful, it would need userland framework or set of workarounds which
> are aware of and can manipulate userland states anyway.  For workloads

What user space "state" needs to be worked-around and manipulated ?

If you are referring to the file system - then a snapshot is necessary
in either method, userspace or kernel. If other, then please elaborate.

> for which checkpointing would be most beneficial (HPC for example), I
> think something like the above would do just fine and it would make
> much more sense to add small features to make userland checkpointing
> work better than doing the whole thing in the kernel.

Actually, because of the huge optimization potential that exists only
in kernel based C/R, the HPC applications are likely to benefit
tremendously too from it. Think about things like incremental
checkpoint, pre-copy to minimize downtime (like live-migration),
using COW to defer disk IO until after the application can resume
execution, and more.  None of these is possible with userspace C/R.

I know of several places that do not use C/R because they can't
stop their long running processes for longer than a few milliseconds.
I know how to solve their problems with linux-cr. I doubt if any
userspace mechanism can get there.

> I think in-kernel checkpointing is in awkward place in terms of
> tradeoff between its benefits and the added complexities to implement
> it.  If you give up coverage slightly, userland checkpointing is
> there.  If you need reliable coverage, proper virtualization isn't too
> far away.  As such, FWIW, I fail to see enough justification for the
> added complexity.  I'll be happy to be proven wrong tho.  :-)

There is a huge gap between what you can (and want) to do with
checkpoint-restart between userspace and kernel implementations.
Linux can profit from this feature along multiple axes, in terms
of the HPC market, VPS solutions, desktop mobility, and much more.

I think the added complexity is more than manageable. If you take
a look at the patch-set (http://www.linux-cr.org/git) you'll see
for that most of the code is straightforward, just full of details,
and definitely tangent to the existing kernel code. The changes
seen in this "naked" diff make more sense when they appear orderly
in the context of that logic.

We have shown that the mission is at reach and C/R can be more than
a toy implementation. To reduce the complexity of *reviwing*, it's
time to post the patch-set in small pieces that one can digest ...

Thanks,

Oren.
