Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab0KDJnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 05:43:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:38964 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab0KDJn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 05:43:29 -0400
Message-ID: <4CD28033.1000700@kernel.org>
Date: Thu, 04 Nov 2010 10:43:15 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Oren Laadan <orenl@cs.columbia.edu>
CC: ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu> <4CD08419.5050803@kernel.org> <4CD23087.30900@cs.columbia.edu>
In-Reply-To: <4CD23087.30900@cs.columbia.edu>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Nov 2010 09:43:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oren.

On 11/04/2010 05:03 AM, Oren Laadan wrote:
> (disclaimer: you may want to grab a cup of your favorite coffee)

Alright, going to get my morning cup of coffee now.  :-)

> On 11/02/2010 05:35 PM, Tejun Heo wrote:
>> The patch size itself isn't too big but I still think it's one scary
>> patch mostly because the breadth of the code checkpointing needs to
>> modify and I suspect that probably is the biggest concern regarding
>> checkpoint-restart from implementation point of view.
> 
> I agree, it *looks* scary. But that's mostly because it's a dumb
> diff out of context, rather than a  standard "patch" as set of
> logical incremental changes. So posting this diff is probably the
> worst way to present the impact on existing code. It merely gives
> a ballpark of that.
> 
> However, please keep in mind that this diff is really an aggregate
> of multiple unrelated, structured, small changes, including:
> - cleanups (e.g. x86 ptrace)
> - refactoring (e.g. ipc, eventpoll, user-ns)
> - new features/enhancements (e,g. splice, freezer, mm)
> 
> I'm confident that each of these will make more sense when presented
> in the proper context.

Yeah, could be so but I wasn't really referring to the scariness of
the patch per-se but rather how many subsystems CR needs to interact
with.

>> FWIW, I'm not quite convinced checkpoint-restart can be something
> 
> In the ksummit presentation I gave an extensive list of real
> use-cases (existing and future). The slides are here:
>     http://www.cs.columbia.edu/~orenl/talks/ksummit-2010.pdf
> For more technical details there is also the OLS-2010 paper here:
>     http://www.cs.columbia.edu/~orenl/papers/ols2010-linuxcr.pdf
> presentation slide from there are here:
>     http://www.cs.columbia.edu/~orenl/talks/ols2010-linuxcr.pdf

Alright, reading...

> I'm unsure which states you have in mind that will not be well defined.
> 
> It is a difficult problem, and C/R has limitations, but I think we've
> got it pretty right this time :)
> 
> * we save and restores *all* *execution* state of the applications
>  (except for well-defined unsupported features; hardware devices
>  are one such example).
> 
> * we don't save FS state (use filesystem snapshots for that); but
>  we do save runtime FS state (e.g. open files, etc).
> 
> * we don't save state of peers (applications/systems) over network;
>  but we do save network connections for proper live-migration.

If you think only about target processes, yeah sure, you can cover
most of the stuff but that's not the impossible part.  What's not
defined is interaction with the rest of the system and userland.
Userland ecosystem is crazy complex.  You simply cannot stop, say,
banshee or even pidgin, let it mingle with the rest of the system and
restore it later in any safe way.

> (Of course, there is a supporting userspace ecosystem, like utilities
> to do the checkpoint/restart, to freeze/thaw the application, to
> snapshot the filesystem etc).
> 
> So unless the applications uses unsupported resource - it will be
> possible to checkpoint that application and restart successfully.

I'm afraid I can't agree with that.  You can store and restore the
states which kernel is aware of but that's a very small fraction of
the whole picture.

>> As such, I have difficult time believing it can be something generally
>> useful.  IOW, I think talking about its usage in complex environments
>> like common desktops is mostly handwaving.  What about X sessions,
>> network connections, states established in other applications via dbus
>> or whatnot?  Which files need to be snapshotted together?  What about
>> shared mmaps?  These questions are not difficult to answer in generic
>> way, they are impossible.
> 
> I have a cool demo (and I gave one today!) that shows how I run one
> desktop session and restart an older desktop session that then runs
> in parallel to my existing session, in another windows -> so I have
> both current and older session running side by side. (it's an version
> of C/R as kernel module for older kernel, we're not yet there with
> linux-cr). Hand-waving ?  maybe, but a pretty convincing one ;)
> 
> To be clear, C/R is more generic than save/restore a single process:
> rather, it works on process hierarchies (and complete containers).
> So a checkpoint will typically capture the state of e.g. a VNC server
> (X session) and the applications (xterm, win-manager etc), and the
> dbus daemon, and all their open files, and sockets etc.

Sure, you can freeze whole tree of related processes and move them
around, but if you think about it, it's an already broken scenario.
For example, dbus (or rather agents listening to it) doesn't only
carry states specific to the set of applications being snapshotted.
It also carries whole bunch of system-wide states or states for other
applications.  As soon as the system goes on executing after
checkpointing, the checkpointed image of dbus and its agents become
inconsistent and useless.  You can't restore it later.  You don't know
what happened to other parts of the system inbetween.

And this problem doesn't stem from technical details of the
implementation.  It's fundamental.  CR tries to snapshot subset of a
big state machine and then use the snapshot later or elsewhere.  It
doesn't and can't have full visibility into how the subset of states
have and are going to interact with the rest of the states.  As soon
as the whole state machine makes progress, there is no guarantee of
consistency.

Without explicit provisions for specific applications, it just can't
work in generic manner.  Can I move my banshee or gwibber to my next
machine transparently with in-kernel CR or even restore it later?  In
many cases, even I (the user) can't define what the desired states
are.

> (BTW, if you were to live-migrate that X session to another host,
> we'd save the TCP state as well; otherwise, we save the sockets in
> CLOSED state - analogous to what happens when your applications run
> again after the laptop was suspended for a long time).
> 
> Likewise, in my demo, files are not snapshotted independently. Instead,
> the entire file system is snapshotted at once.
> 
> Bottom line - it's simpler than what it sounds. Let's compare this to
> the save/restore of an entire VM: in VM you bundle all the state inside
> as a single big package (and this makes life much easier). Likewise, in
> C/R, we bundle all the necessary processes, e.g. an entire container,
> in a single big package - we pack all the data necessary to make the
> checkpoint self-sufficient.

So, that's why it comes down to containers and namespaces.  You need
to preemptively put the target applications in separate boxes so that
they don't have much to do with the rest of the system.  So that the
states aren't intermixed and can be safely snapshotted without
worrying about the rest of the system.

I'm afraid that's not general or transparent at all.  It's extremely
invasive to how a system is setup and used.  It basically is poor
man's virtualization or rather partitioning without hardware support
and at this point I find it very difficult to justify the added
complexity.  Let's just make virtualization better.

>> So, although checkpoint-restart can be very useful for certain
>> circumstances, I don't believe there can be a general implementation.
>> It inevitably needs to put somewhat strict restrictions on what the
>> applications being checkpointed are allowed to do.  And after my
> 
> Let me try to rephrase: there are restrictions to what applications
> do if they are to be successfully checkpointed. Examples:
>  * tasks that use hardware devices (e.g. sound card),
>  * tasks that use unsupported sockets (e.g. netlink),
>  * tasks that use yet-unsupported feature (e.g. ptraced tasks)
> 
> That said, I'm quite confident that the set of features we support
> (now or within easy reach) already cover a wide range of real
> applications and use-cases.

I think my points are clear now.  I'm not really talking about kernel
resources the hierarchy of checkpointed processes are using.  I'm
talking about interaction with the rest of the system and how that
can't be solved in general manner.

> In contrast, the kernel C/R is:
> 
> * much more complete and feature-rich,
> * entirely transparent to applications (does not need their cooperation,
>  can even do debugged tasks)
> * can be highly optimized and do incremental c/r
> * can do live migration
> * is easier to maintain in the long run (because you don't need to cheat
>  applications by intercepting their kernel calls from userspace!)
> * flexible to allow smart userspace to also be c/r aware, if they so wish
> * can provide a guarantee that a checkpoint is self-contained and can
>  be later restarted
> 
> In fact, DMTCP will be much more useful if it builds on linux-cr
> as its chekcpoint-restart engine ;)

Yeah, it would definitely be interesting to think about how userland
CR can be improved with some kernel support.  That said, I don't think
the differences listed above are that large given the common use
cases.

>> useful, it would need userland framework or set of workarounds which
>> are aware of and can manipulate userland states anyway.  For workloads
> 
> What user space "state" needs to be worked-around and manipulated ?
> 
> If you are referring to the file system - then a snapshot is necessary
> in either method, userspace or kernel. If other, then please elaborate.

I think dmtcp paper lists some of them.  The message Kapil wrote in
this thread also talks about handling vim.  They're inevitable if you
want to checkpoint subset of processes from a live system.  The only
reason those haven't come up with in-kernel CR yet is because they are
hidden behind containers and namespaces.

>> for which checkpointing would be most beneficial (HPC for example), I
>> think something like the above would do just fine and it would make
>> much more sense to add small features to make userland checkpointing
>> work better than doing the whole thing in the kernel.
> 
> Actually, because of the huge optimization potential that exists only
> in kernel based C/R, the HPC applications are likely to benefit
> tremendously too from it. Think about things like incremental
> checkpoint, pre-copy to minimize downtime (like live-migration),
> using COW to defer disk IO until after the application can resume
> execution, and more.  None of these is possible with userspace C/R.
> 
> I know of several places that do not use C/R because they can't
> stop their long running processes for longer than a few milliseconds.
> I know how to solve their problems with linux-cr. I doubt if any
> userspace mechanism can get there.

I'm sure there will be some benefits to in-kernel implementation but
the added complexity is crazy in comparison.  I don't think it would
be wise to include this invasive amount of code for several places
which can't CR because they can't afford a few millisecs.

>> I think in-kernel checkpointing is in awkward place in terms of
>> tradeoff between its benefits and the added complexities to implement
>> it.  If you give up coverage slightly, userland checkpointing is
>> there.  If you need reliable coverage, proper virtualization isn't too
>> far away.  As such, FWIW, I fail to see enough justification for the
>> added complexity.  I'll be happy to be proven wrong tho.  :-)
> 
> There is a huge gap between what you can (and want) to do with
> checkpoint-restart between userspace and kernel implementations.
> Linux can profit from this feature along multiple axes, in terms
> of the HPC market, VPS solutions, desktop mobility, and much more.
>
> I think the added complexity is more than manageable. If you take
> a look at the patch-set (http://www.linux-cr.org/git) you'll see
> for that most of the code is straightforward, just full of details,
> and definitely tangent to the existing kernel code. The changes
> seen in this "naked" diff make more sense when they appear orderly
> in the context of that logic.
> 
> We have shown that the mission is at reach and C/R can be more than
> a toy implementation. To reduce the complexity of *reviwing*, it's
> time to post the patch-set in small pieces that one can digest ...

I'm sorry to be in this position but the trade off just seems way off.
As I wrote earlier, the transparent part of in-kernel CR basically
boils down to implementing pseudo virtualization without hardware
support and given the not-too-glorious history of that and the much
higher focus on proper virtualization these days, I just don't think
it makes much sense.  It's an extremely niche solution for niche use
cases.  If it were a self contained feature, sure, but it's reaching
into a lot of core subsystems.  Sorry, no.

Thank you.

-- 
tejun
