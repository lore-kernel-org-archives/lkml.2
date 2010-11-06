Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab0KFWzo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 18:55:44 -0400
Received: from brinza.cc.columbia.edu ([128.59.29.8]:49773 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab0KFWzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 18:55:43 -0400
Message-ID: <4CD5DCE3.3000109@cs.columbia.edu>
Date: Sat, 06 Nov 2010 18:55:31 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Kapil Arya <kapil@ccs.neu.edu>
CC: Tejun Heo <tj@kernel.org>, Gene Cooperman <gene@ccs.neu.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu> <4CD08419.5050803@kernel.org> <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com> <4CD26948.7050009@kernel.org> <20101104164401.GC10656@sundance.ccs.neu.edu> <4CD3CE29.2010105@kernel.org> <AANLkTimDXKsBCxbsEOfgkYV2R8FK=bhFdmx9UQow5hqp@mail.gmail.com>
In-Reply-To: <AANLkTimDXKsBCxbsEOfgkYV2R8FK=bhFdmx9UQow5hqp@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/05/2010 08:36 PM, Kapil Arya wrote:
>> I'm probably missing something but can't you stop the application
>> using PTRACE_ATTACH?  You wouldn't need to hijack a signal or worry
>> about -EINTR failures (there are some exceptions but nothing really to
>> worry about).  Also, unless the manager thread needs to be always
>> online, you can inject manager thread by manipulating the target
>> process states while taking a snapshot.
> 
> In fact CryoPid uses exactly the same approach and has been around for around 5
> years. Not as much development effort has gone into CryoPid as DMTCP and so its
> application coverage is not as broad. But the larger issue for using PTRACE is
> that you can not have two superiors tracing the same inferior process. So if you
> want to checkpoint a gdb session or valgrind or tmux or strace, then you can not
> directly control and quiesce the inferior process being traced.
> 
> Beyond that, we also have a vision (not yet implemented) of process
> virtualization by which one can change the behavior of a program. For example,
> if a distributed computation runs over infiniband, can we migrate to a TCP/IP
> cluster. For this, one needs the flexibility of wrappers around system calls.
> This vision of process virtualization also motivates why our own research
> project has steered away from in-kernel C/R.

This is a very useful vision. However, it is unrelated to how you
do c/r, but rather to what you do after you restart and before you
let the application resume execution.

For example, in your example, you'd need to wrap the library calls
(e.g. of MPI implementation) and replaced them to use TCP/IP or
infiniband. Wrapping on system calls won't help you.

Or you could just replace the resource - e.g., make the restarted
application use s socket for stdout instead of the tty, so you can
redirect the output to where-ever.

Both methods are orthogonal to the c/r itself: linux-cr will allow
you to replace/modify resources if you so wish, and I suspect that
MTCP also can/will.

Interposing on library calls is possible with MTCP methods, or
using binary instrumentation, or PIN, or DynInst, or LD_PRELOAD.

The only two reasons to interpose on systems calls, as I noted
in earlier message (http://lkml.org/lkml/2010/11/5/262 - see
points "2)" and "3)" about userland-workarounds):

One - to virtualize in userspace reosurces (e.g. pids) that the
kernel already knows how to virtualize.

Two - to track state of resources during execution and lie about
their state when needed, because userspace can't cleanly save
and restore their state.

Virtualization through interposition is extremely tricky in and
out of the kernel. The examples given throughout this thread (by
either side) expose the tip of the iceberg. Interposition as a
technique  is full of security and other pitfalls, as discussed
by extensive literature in the area. (I cited in another email).

So I'll repeat the question I asked there: is re-reimplementing
chunks of kernel functionality and all namespaces in userspace
the way to go ?

> 
>>> But since you ask :-), there is one thing on our wish list.  We
>>> handle address space randomization, vdso, vsyscall, and so on quite
>>> well.  We do not turn off address space randomization (although on
>>> restart, we map user segments back to their original addresses).
>>> Probably the randomized value of brk (end-of-data or end of heap) is
>>> the thing that gave us the most troubles and that's where the code
>>> is the most hairy.
>>

[snip]

> The design of DMTCP was decided upon roughly during the period from Linux 2.6.3
> through Linux 2.6.18. At that time, /proc/*/net did not exist. You are right
> that this can provide much better design for DMTCP and eliminate some of our
> wrappers. Thanks very much for pointing this out. We are now egar to implement a
> new design based on /proc/*/net in the near future.
> 
> Since /proc/*/net provides a simpler design for sockets, we started wondering
> what other simplifications may be possible. Here is one possibility, in the case
> of shared file descriptors, DMTCP goes through two barriers in order to decide
> which process will be responsible for checkpointing which shared-file
> descriptor. It works and the overhead is reasonable, but if you have additional
> suggestion for this case, we would be very interested.

What is "reasonable" overhead ?
For which applications ?
What about a 'kernel make' ?
What about servers (db, web, etc) ?
What about VPSs/VDIs ?
Can we do better, including for HPC ?
...

> 
>> I think this is why userland CR implementation makes much more sense.
>> Most of states visible to a userland process are rather rigidly
>> defined by standards and, ultimately, ABI and the kernel exports most
>> of those information to userland one way or the other.  Given the
>> right set of needed features, most of which are probabaly already
>> implemented, a userland implementation should have access to most
>> information necessary to checkpoint without resorting to too messy
>> methods and then there inevitably needs to be some workarounds to make
>> CR'd processes behave properly w.r.t. other states on the system, so
>> userland workarounds are inevitable anyway unless it resorts to
>> preemtive separation using namespaces and containers, which I frankly
>> think isn't much of value already and more so going forward.
> 
> Its a very good point and we agree completely. Here are some examples where we
> believe, a userland component is inevitable even if one begins with in-kernel
> C/R:

Exactly !  Wrapping around apps to isolate them from the environment
is desirable, regardless of how you technically c/r the apps, when
you want to be able to c/r apps outside their native environment.

Generally, you can either include the environment in the checkpoint,
or provide wrappers to virtualize it after restart, or modify the app
so that it knows how to adapt to new environments after restart.

Either way, you need to technically c/r the app, no matter how much
userspace trickery you may choose to apply afterwards if needed. And
doing so in-kernel is more transparent (yes, transparent means that
it does not require LD_PRELOAD or collaboration of the application!
nor does it require userspace virtualizations of so many things
already provided by the kernel today), more generic, more flexible,
provides more guarantees, cover more types or states of resources,
and can perform significantly better.

And then, if you want to work with dmtcp's type of scenarios, you
could use the generic c/r and apply their wrappers on top of it !

[snip]

Thanks,

Oren.
