Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102Ab0KQKtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 05:49:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:59171 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756218Ab0KQKtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 05:49:03 -0500
Message-ID: <4CE3B23D.6040603@kernel.org>
Date: Wed, 17 Nov 2010 11:45:17 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Kapil Arya <kapil@ccs.neu.edu>
CC: Gene Cooperman <gene@ccs.neu.edu>, Oren Laadan <orenl@cs.columbia.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu> <4CD08419.5050803@kernel.org> <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com> <4CD26948.7050009@kernel.org> <20101104164401.GC10656@sundance.ccs.neu.edu> <4CD3CE29.2010105@kernel.org> <AANLkTimDXKsBCxbsEOfgkYV2R8FK=bhFdmx9UQow5hqp@mail.gmail.com>
In-Reply-To: <AANLkTimDXKsBCxbsEOfgkYV2R8FK=bhFdmx9UQow5hqp@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Nov 2010 10:45:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, sorry about the long delay.  Was lost in something else.

On 11/06/2010 01:36 AM, Kapil Arya wrote:
>> I'm probably missing something but can't you stop the application
>> using PTRACE_ATTACH?  You wouldn't need to hijack a signal or worry
>> about -EINTR failures (there are some exceptions but nothing really to
>> worry about).  Also, unless the manager thread needs to be always
>> online, you can inject manager thread by manipulating the target
>> process states while taking a snapshot.
>
> In fact CryoPid uses exactly the same approach and has been around
> for around 5 years. Not as much development effort has gone into
> CryoPid as DMTCP and so its application coverage is not as
> broad. But the larger issue for using PTRACE is that you can not
> have two superiors tracing the same inferior process. So if you want
> to checkpoint a gdb session or valgrind or tmux or strace, then you
> can not directly control and quiesce the inferior process being
> traced.

I've been thinking about this.  We can easily introduce a new ptrace
call which allows neseting.  AFAICS, ptrace already exports most of
information necessary to restart the task - where it's stopped and
why.  The only missing thing seems to be the wait state (including for
group stop) which can be added without too much difficulty.  I'll try
to write up a RFC patch.  Things like that would useful for other
things too - say, you would be able to attach gdb to a strace'd
process which would come handy in some cases.

> Beyond that, we also have a vision (not yet implemented) of process
> virtualization by which one can change the behavior of a
> program. For example, if a distributed computation runs over
> infiniband, can we migrate to a TCP/IP cluster. For this, one needs
> the flexibility of wrappers around system calls.  This vision of
> process virtualization also motivates why our own research project
> has steered away from in-kernel C/R.

Yeah, definitely, for the higher level workarounds, there's no way
around it but I think it would still be worthwhile to be able to
provide a baseline implementation which can checkpoint and restart a
single process in a reliable and well-defined way.

>>> But since you ask :-), there is one thing on our wish list.  We
>>> handle address space randomization, vdso, vsyscall, and so on quite
>>> well.  We do not turn off address space randomization (although on
>>> restart, we map user segments back to their original addresses).
>>> Probably the randomized value of brk (end-of-data or end of heap) is
>>> the thing that gave us the most troubles and that's where the code
>>> is the most hairy.
>>
>> Can you please elaborate a bit?  What do you want to see changed?
> 
> Yes, we would love to elaborate :-). We began DMTCP with Linux
> kernel 2.6.3.  When Address Space Layout Randomization was added, we
> were forced to add some hacks concerning VDSO location and
> end-of-data. end-of-data is the uglier part.  On restart, we
> directly map each memory segment into the original address at
> checkpoint time. The issue comes in mapping heap back to its
> original location.  We call sbrk() to reset the end-of-data to the
> end of the original heap. This fails if the randomized
> beginning-of-data/end-of-data given to us by the kernel for the
> restarted process is too far away from where we want to remap the
> heap.  To get around this, we play games with legacy layout, other
> personality parameters, and RLIMIT_STACK (since the kernel uses
> RLIMIT_STACK in choosing the appropriate memory layout).
>
> For our wish list, we would like a way of telling the kernel, where
> to set beginning-of-data/end-of-data. Curiously enough, at the time
> at which Linux started randomizing address space, there was
> discussion of offering exactly this facility for the sake of legacy
> programs, but it turned out not to be needed.

I see.  Yeah, I completely forgot that kernel keeps track of brk.

> Similarly, it would be nice to tell the kernel where we want the
> VDSO page.  Currently, we get around this by keeping two VDSO pages,
> the old one which we restore and the new one specified to us by the
> kernel when the restart process is created. This works well for, and
> so controlling the address of the VDSO page is less important for
> us.

I haven't really looked at the VDSO generation but symbol offsets
inside VDSO page can differ depending on kernel version,
configuration, toolchains used, etc... right?  You would need an extra
layer of indirection no matter what in that case.

> Since /proc/*/net provides a simpler design for sockets, we started
> wondering what other simplifications may be possible. Here is one
> possibility, in the case of shared file descriptors, DMTCP goes
> through two barriers in order to decide which process will be
> responsible for checkpointing which shared-file descriptor. It works
> and the overhead is reasonable, but if you have additional
> suggestion for this case, we would be very interested.

I wrote in another mail but you can find out which fd's are shared by
flipping O_NONBLOCK and looking at the flags field of
/proc/*/fdinfo/*.  Or are you talking about something else?

> We really enjoyed this discussion. If you are interested, we would
> be happy to talk further by phone in order to take advantage of the
> higher bandwidth.

As a few others have already pointed out, I think it's better to keep
technical discussions on-line.  Different people think at different
paces and the schedules don't always match.  Plus, other people can
jump in and look up things later.  It may take a bit more effort at
the beginning but I think it gets easier in time.

Thank you.

-- 
tejun
