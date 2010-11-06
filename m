Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab0KFKRB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 06:17:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:47548 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707Ab0KFKRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 06:17:00 -0400
Message-ID: <4CD52A37.7050509@kernel.org>
Date: Sat, 06 Nov 2010 11:13:11 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Oren Laadan <orenl@cs.columbia.edu>
CC: Gene Cooperman <gene@ccs.neu.edu>, Kapil Arya <kapil@ccs.neu.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu> <4CD08419.5050803@kernel.org> <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com> <4CD26948.7050009@kernel.org> <20101104164401.GC10656@sundance.ccs.neu.edu> <4CD3CE29.2010105@kernel.org> <4CD490C1.7000306@cs.columbia.edu>
In-Reply-To: <4CD490C1.7000306@cs.columbia.edu>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 06 Nov 2010 10:13:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/06/2010 12:18 AM, Oren Laadan wrote:
>> I'm probably missing something but can't you stop the application
>> using PTRACE_ATTACH?  You wouldn't need to hijack a signal or worry
>> about -EINTR failures (there are some exceptions but nothing really to
>> worry about).  Also, unless the manager thread needs to be always
>> online, you can inject manager thread by manipulating the target
>> process states while taking a snapshot.
> 
> This is an excellent example to demonstrate several points:
> 
> * To freeze the processes, you can use (quote) "hairy" signal
> overload mechanism, or even more hairy ptrace; both by the way have
> their performance problem with many processes/threads.  Or you can
> use the in-kernel freezer-cgroup, and forget about workarounds, like
> linux-cr does. And ~200 lines in said diff are dedicated exactly to
> that.
> 
> * Then, because both the workaround and the entire philosophy
> of MTCP c/r engine is that affected processes _participate_ in
> the checkpoint, their syscalls _must_ be interrupted. Contrastly,
> linux-cr kernel approach allows not only to checkpoint processes
> without collaboration, but also builds on the native signal
> handling kernel code to restart the system calls (both after
> unfreeze, and after restart), such that the original process
> does not observe -EINTR.

The above problems can be solved for userland C/R with small
self-contained modification to a small part of the kernel.  You're
insisting that because currently some obscure corner cases aren't
handled, the whole thing should be shoved in the kernel and the kernel
should be serializing and deserializing its internal data structures
for everything visible in the userland.  That's silly at best.  Note
the "visible in the userland" part.  Most of those parts are already
discoverable without further modifications to kernel.  The only sane
approach would be add missing pieces which would not only benefit CR
but other applications too.

Also, you said the patches didn't have to change much because the data
structures facing userland didn't change much over different kernel
versions, which of course is true as it's so close to the userland
visible ABI.  That is _NOT_ a selling point for kernel CR.  That's a
BIG GLOWING SIGN telling you that you're on the frigging wrong side of
the wall.

> BTW, a real security expert (and I'm not one...) may argue that
> this operation should only be allowed to privileged users. In fact,
> if your code gets around the linux ASLR mechanisms, then someone
> should fix the kernel ASLR code :)

ASLR is to protect a program from itself not from outside.  If you can
ptrace a process, ASLR doesn't mean a thing.

>> I see.  I just thought that it would be helpful to have the core part
>> - which does per-process checkpointing and restoring and corresponds
>> to the features implemented by in-kernel CR - as a separate thing.  It
>> already sounds like that is mostly the case.
> 
> FWIW, the restart portion of linux-cr is designed with this in
> mind - it is flexible enough to accommodate for smart userspace
> tools and wrappers that wish to mock with the processes and
> their resource post-restart (but before the processes resume
> execution). For example, a distributed checkpoint tool could,
> at restart time, reestablish the necessary network connections
> (which is much different than live migration of connections,
> and clearly not a kernel task). This way, it is trivial to migrate
> a distributed application from one set of hosts to another, on
> different networks, with very little effort.

Yeap, that was the reason why I asked how modularized that part of
dmtcp was as it would directly compare with the in-kernel
implementation.  If they can be well separated, I think it would even
be possible to switch between the two while keeping the upper set of
workarounds the same.

>> I don't have much idea about the scope of the whole thing, so please
>> feel free to hammer senses into me if I go off track.  From what I
>> read, it seems like once the target process is stopped, dmtcp is able
>> to get most information necessary from kernel via /proc and other
>> methods but the paper says that it needs to intercept socket related
>> calls to gather enough information to recreate them later.  I'm
>> curious what's missing from the current /proc.  You can map socket to
>> inode from /proc/*/fd which can be matched to an entry in
>> /proc/*/net/PROTO to find out the addresses and most socket options
>> should be readable via getsockopt.  Am I missing something?
> 
> So you'll need mechanisms not only to read the data at checkpoint
> time but also to reinstate the data at restart time. By the time
> you are done, the kernel all the c/r code (the suspect diff in
> question _and_ the rest of the logic) in the form of new interfaces
> and ABIs to usersapce...; the userspace code will grow some more
> hair; and there will be zero maintainability gain. And at the same
> you won't be able to leverage optimizations only possible in the
> kernel.

Unfortunately, for most things which matter, everything is already in
place and if you just concentrate on the core part the hackiness seems
quite manageable and I think it wouldn't be too difficult to reduce it
further.  I don't see why userland implementation wouldn't be able to
snapshot any random process without LD_PRELOADs or whatever
cooperation from it.  And, if the COW thing is so important, we can
collect the information and export it to userland via proc or
ringbuffer.  That's what qemu-kvm would need anyway, right?  I don't
think kvm guys would be so crazy as putting the whole snapshotter into
the kernel.

> To be precise, there are three types of userland workarounds:
> 
> 1) userland workarounds to make a restarted application work when
> peer processrs aren't saved - e.g, in distributed checkpoint you
> need a workaround to rebuild the socket to the peer; or in his
> example with the 'ncsd' daemon from earlier in the thread.
> 
> These are needed regardless of the c/r engine of choice. In many
> cases they can be avoided if applications are run in containers.
> (which can be as simple as running a program using 'nohup')
>
> 2) userland workarounds to duplicate virtualization logic already
> done by the kernel - like the userspace pid-namespace and the
> complex logic and hacks needed to make it work. This is completely
> unnecessary when you do kernel c/r.

No, that's primarily not the feature of kerne CR.  It's of namespaces
and containers.

> 3) userland workarounds to compensate for the fact that userspace
> can't get or set some state during checkpoint or restart. For
> example, in the kernel it's trivial to track shared files. How
> would you say, from userspace, if fd[0] of parent A and child B is
> the same file opened and then inherited, or the same filename
> opened twice individually?  For files, it is possible to figure
> this out in user space, e.g. by intercepting and tracking all forks
> and all file operations (including passing fd's via afunix sockets).

Or, if it's a regular file, lseek() and see whether the offsets change
together, or, even better, just toggle O_NDELAY with fcntl.

> There are other hairy ways to do it, but not quite so for other
> resources.

If you think toggling O_NDELAY is hairy, let's add a noop flag bit or
export whatever via /proc/*/fdinfo.  We already have all that stuff
for a reason.

> As another example, consider SIDs and PGIDs. With proper algorithms
> you can ensure that your processes get the right SID at fork time.
> But in the general case, you can't reproduce PGIDs accurately
> without replaying what the processes (including those that had died
> already) behaved.
> 
> And to track zombies at checkpoint, you'd need to actually collect
> them, so you must do it in a hairy wrapper, and keep the secret
> until the application calls wait(). But then, there may be some
> side effects due to collecting zombies, e.g. the pid may be reused
> against the application's expectation.
> 
> Some of these have workarounds, some not. Do you really think that
> re-reimplementing linux and namespaces in userspace is the way to go ?

No, I think you're blowing corner cases, which are in Syberia cold
paths, way out of proportion.  None of the above justifies putting the
whole thing in the kernel.  Solve each problem with local solutions.
You're basically doing the same thing with in-kernel implementation,
the only difference being you side stepping ABI issues by saying that
kernel CR format would stay _mostly_ stable and what changes would be
dealt with from userland tools.  Everything visible from usual
userland applications should be (and is for the most part) defined by
ABI.  And if every state worthy of saving is well defined and visible
from userland, there's no reason to do it from kernel.

> Then, you can add to the kernel endless amount of interfaces to
> export all of this - both data, and the functionality to re-instate
> this data at checkpoint. But ... wait -- isn't that what linux-cr
> already does ?

I hope that's what linux-cr did.  It unfortunately serializes and
de-serializes in-kernel data structures which are already mostly
visible from userland instead of hunting down and improving missing
pieces.

>> preemtive separation using namespaces and containers, which I frankly
>> think isn't much of value already and more so going forward.
> 
> That is one opinion. Then there are people using VPSs in commercial
> and private environments, for example.
> 
> VMs are wonderful (re)invention. Regardless of any one single
> person's about VMs vs containers, both are here to stay, and both
> have their use-cases and users. IMHO, it is wrong to ignore the
> need for c/r and migration capabilities for containers, whether
> they run full desktop environments, multiple applications or single
> processes.

Sure, I'm not ignoring them.  I'm just saying in-kernel CR doesn't
make a good trade off with its limited benefits and extensive
complexity all across the kernel, and the reason why its benefits are
limited is because it's sandwiched pretty tightly between userland CR
and proper virtualization.  Moreover, the space in-kernel CR tries
occupy is getting smaller day by day.  It just can't justify its
complexity.

Thanks.

-- 
tejun
