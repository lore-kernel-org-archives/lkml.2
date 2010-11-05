Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab0KEXSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 19:18:39 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:40920 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab0KEXSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 19:18:36 -0400
Message-ID: <4CD490C1.7000306@cs.columbia.edu>
Date: Fri, 05 Nov 2010 19:18:25 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Gene Cooperman <gene@ccs.neu.edu>, Kapil Arya <kapil@ccs.neu.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu> <4CD08419.5050803@kernel.org> <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com> <4CD26948.7050009@kernel.org> <20101104164401.GC10656@sundance.ccs.neu.edu> <4CD3CE29.2010105@kernel.org>
In-Reply-To: <4CD3CE29.2010105@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/05/2010 05:28 AM, Tejun Heo wrote:
> Hello,
>
> On 11/04/2010 05:44 PM, Gene Cooperman wrote:
>>>> In our personal view, a key difference between in-kernel and userland
>>>> approaches is the issue of security.
>>>
>>> That's an interesting point but I don't think it's a dealbreaker.
>>> ... but it's not like CR is gonna be deployed on
>>> majority of desktops and servers (if so, let's talk about it then).
>>
>> This is a good point to clarify some issues.  C/R has several good
>> targets.  For example, BLCR has targeted HPC batch facilities, and
>> does it well.
>>
>> DMTCP started life on the desktop, and it's still a primary focus of
>> DMTCP.  We worked to support screen on this release precisely so
>> that advanced desktop users have the option of putting their whole
>> screen session under checkpoint control.  It complements the core
>> goal of screen: If you walk away from a terminal, you can get back
>> the session elsewhere.  If your session crashes, you can get back
>> the session elsewhere (depending on where you save the checkpoint
>> files, of course :-) ).
>
> Call me skeptical but I still don't see, yet, it being a mainstream
> thing (for average sysadmin John and proverbial aunt Tilly).  It
> definitely is useful for many different use cases tho.  Hey, but let's
> see.
>
>> These are also some excellent points for discussion!  The manager thread
>> is visible.  For example, if you run a gdb session under checkpoint
>> control (only available in our unstable branch, currently), then
>> the gdb session will indeed see the checkpoint manager thread.
>
> I don't think gdb seeing it is a big deal as long as it's hidden from
> the application itself.
>
>> We try to hid the reserved signal (SIGUSR2 by default, but the user
>> can configure it to anything else).  We put wrappers around system
>> calls that might see our signal handler, but I'm sure there are
>> cases where we might not succeed --- and so a skilled user would
>> have to configure to use a different signal handler.  And of course,
>> there is the rare application that repeatedly resets _every_ signal.
>> We encountered this in an earlier version of Maple, and the Maple
>> developers worked with us to open up a hole so that we could
>> checkpoint Maple in future versions.
>>
>>>    [while] all programs should be ready to handle -EINTR failure from system
>>>    calls, it's something which is very difficult to verify and test and
>>>    could lead to once-in-a-blue-moon head scratchy kind of failures.
>>
>> Exactly right!  Excellent point.  Perhaps this gets down to
>> philosophy, and what is the nature of a bug.  :-) In some cases, we
>> have encountered this issue.  Our solution was either to refuse to
>> checkpoint within certain system calls, or to check the return value
>> and if there was an -EINTR, then we would re-execute the system
>> call.  This works again, because we are using wrappers around many
>> (but not all) of the system calls.
>
> I'm probably missing something but can't you stop the application
> using PTRACE_ATTACH?  You wouldn't need to hijack a signal or worry
> about -EINTR failures (there are some exceptions but nothing really to
> worry about).  Also, unless the manager thread needs to be always
> online, you can inject manager thread by manipulating the target
> process states while taking a snapshot.

This is an excellent example to demonstrate several points:

* To freeze the processes, you can use (quote) "hairy" signal
overload mechanism, or even more hairy ptrace; both by the way
have their performance problem with many processes/threads.
Or you can use the in-kernel freezer-cgroup, and forget about 
workarounds, like linux-cr does. And ~200 lines in said diff
are dedicated exactly to that.

* Then, because both the workaround and the entire philosophy
of MTCP c/r engine is that affected processes _participate_ in
the checkpoint, their syscalls _must_ be interrupted. Contrastly,
linux-cr kernel approach allows not only to checkpoint processes
without collaboration, but also builds on the native signal
handling kernel code to restart the system calls (both after
unfreeze, and after restart), such that the original process
does not observe -EINTR.

>> But since you ask :-), there is one thing on our wish list.  We
>> handle address space randomization, vdso, vsyscall, and so on quite
>> well.  We do not turn off address space randomization (although on
>> restart, we map user segments back to their original addresses).
>> Probably the randomized value of brk (end-of-data or end of heap) is
>> the thing that gave us the most troubles and that's where the code
>> is the most hairy.
>
> Can you please elaborate a bit?  What do you want to see changed?

Aha ... another great example: yet another piece of the suspect
diff in question is dedicated to allow a restarting process to
request a specific location for the vdso.

BTW, a real security expert (and I'm not one...) may argue that
this operation should only be allowed to privileged users. In fact,
if your code gets around the linux ASLR mechanisms, then someone
should fix the kernel ASLR code :)

>> The implementation is reasonably modularized.  In the rush to
>> address bugs or feature requirements of users, we sometimes cut
>> corners.  We intend to go back and fix those things.  Roughly, the
>> architecture of DMTCP is to do things in two layers: MTCP handles a
>> single multi-threaded process.  There is a separate library mtcp.so.
>> The higher layer (redundantly again called DMTCP) is implemented in
>> dmtcphijack.so.  In a _very_ rough kind of way, MTCP does a lot of
>> what would be done within kernel C/R.  But the higher DMTCP layer
>> takes on some of those responsibilities in places.  For example,
>> DMTCP does part of analyzing the pseudo-ttys, since it's not always
>> easy to ensure that it's the controlling terminal of some process
>> that can checkpoint things in the MTCP layer.
>>
>> Beyond that, the wrappers around system calls are essentially
>> perfectly modular.  Some system calls go together to support a
>> single kernel feature, and those wrappers are kept in a common file.
>
> I see.  I just thought that it would be helpful to have the core part
> - which does per-process checkpointing and restoring and corresponds
> to the features implemented by in-kernel CR - as a separate thing.  It
> already sounds like that is mostly the case.

FWIW, the restart portion of linux-cr is designed with this in
mind - it is flexible enough to accommodate for smart userspace
tools and wrappers that wish to mock with the processes and
their resource post-restart (but before the processes resume
execution). For example, a distributed checkpoint tool could,
at restart time, reestablish the necessary network connections
(which is much different than live migration of connections,
and clearly not a kernel task). This way, it is trivial to migrate
a distributed application from one set of hosts to another, on
different networks, with very little effort.

>
> I don't have much idea about the scope of the whole thing, so please
> feel free to hammer senses into me if I go off track.  From what I
> read, it seems like once the target process is stopped, dmtcp is able
> to get most information necessary from kernel via /proc and other
> methods but the paper says that it needs to intercept socket related
> calls to gather enough information to recreate them later.  I'm
> curious what's missing from the current /proc.  You can map socket to
> inode from /proc/*/fd which can be matched to an entry in
> /proc/*/net/PROTO to find out the addresses and most socket options
> should be readable via getsockopt.  Am I missing something?

So you'll need mechanisms not only to read the data at checkpoint
time but also to reinstate the data at restart time. By the time
you are done, the kernel all the c/r code (the suspect diff in
question _and_ the rest of the logic) in the form of new interfaces
and ABIs to usersapce...; the userspace code will grow some more
hair; and there will be zero maintainability gain. And at the same
you won't be able to leverage optimizations only possible in the
kernel.

>
> I think this is why userland CR implementation makes much more sense.
> Most of states visible to a userland process are rather rigidly
> defined by standards and, ultimately, ABI and the kernel exports most
> of those information to userland one way or the other.  Given the
> right set of needed features, most of which are probabaly already
> implemented, a userland implementation should have access to most
> information necessary to checkpoint without resorting to too messy
> methods and then there inevitably needs to be some workarounds to make
> CR'd processes behave properly w.r.t. other states on the system, so
> userland workarounds are inevitable anyway unless it resorts to

To be precise, there are three types of userland workarounds:

1) userland workarounds to make a restarted application work when
peer processrs aren't saved - e.g, in distributed checkpoint you
need a workaround to rebuild the socket to the peer; or in his
example with the 'ncsd' daemon from earlier in the thread.

These are needed regardless of the c/r engine of choice. In many
cases they can be avoided if applications are run in containers.
(which can be as simple as running a program using 'nohup')

2) userland workarounds to duplicate virtualization logic already
done by the kernel - like the userspace pid-namespace and the
complex logic and hacks needed to make it work. This is completely
unnecessary when you do kernel c/r.

3) userland workarounds to compensate for the fact that userspace
can't get or set some state during checkpoint or restart. For
example, in the kernel it's trivial to track shared files. How
would you say, from userspace, if fd[0] of parent A and child B is
the same file opened and then inherited, or the same filename
opened twice individually ?  For files, it is possible to figure
this out in user space, e.g. by intercepting and tracking all forks
and all file operations (including passing fd's via afunix sockets).
There are other hairy ways to do it, but not quite so for other
resources.

As another example, consider SIDs and PGIDs. With proper algorithms
you can ensure that your processes get the right SID at fork time.
But in the general case, you can't reproduce PGIDs accurately
without replaying what the processes (including those that had died
already) behaved.

And to track zombies at checkpoint, you'd need to actually collect
them, so you must do it in a hairy wrapper, and keep the secret
until the application calls wait(). But then, there may be some
side effects due to collecting zombies, e.g. the pid may be reused
against the application's expectation.

Some of these have workarounds, some not. Do you really think that
re-reimplementing linux and namespaces in userspace is the way to go ?

Then, you can add to the kernel endless amount of interfaces to
export all of this - both data, and the functionality to re-instate
this data at checkpoint. But ... wait -- isn't that what linux-cr
already does ?

> preemtive separation using namespaces and containers, which I frankly
> think isn't much of value already and more so going forward.

That is one opinion. Then there are people using VPSs in commercial
and private environments, for example.

VMs are wonderful (re)invention. Regardless of any one single
person's about VMs vs containers, both are here to stay, and both
have their use-cases and users. IMHO, it is wrong to ignore the
need for c/r and migration capabilities for containers, whether
they run full desktop environments, multiple applications or single
processes.

Oren.
