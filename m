Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab0KEJb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 05:31:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:60586 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307Ab0KEJb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 05:31:26 -0400
Message-ID: <4CD3CE29.2010105@kernel.org>
Date: Fri, 05 Nov 2010 10:28:09 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Gene Cooperman <gene@ccs.neu.edu>
CC: Kapil Arya <kapil@ccs.neu.edu>, Oren Laadan <orenl@cs.columbia.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu> <4CD08419.5050803@kernel.org> <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com> <4CD26948.7050009@kernel.org> <20101104164401.GC10656@sundance.ccs.neu.edu>
In-Reply-To: <20101104164401.GC10656@sundance.ccs.neu.edu>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Nov 2010 09:28:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/04/2010 05:44 PM, Gene Cooperman wrote:
>>> In our personal view, a key difference between in-kernel and userland
>>> approaches is the issue of security.
>>
>> That's an interesting point but I don't think it's a dealbreaker.
>> ... but it's not like CR is gonna be deployed on
>> majority of desktops and servers (if so, let's talk about it then).
>
> This is a good point to clarify some issues.  C/R has several good
> targets.  For example, BLCR has targeted HPC batch facilities, and
> does it well.
>
> DMTCP started life on the desktop, and it's still a primary focus of
> DMTCP.  We worked to support screen on this release precisely so
> that advanced desktop users have the option of putting their whole
> screen session under checkpoint control.  It complements the core
> goal of screen: If you walk away from a terminal, you can get back
> the session elsewhere.  If your session crashes, you can get back
> the session elsewhere (depending on where you save the checkpoint
> files, of course :-) ).

Call me skeptical but I still don't see, yet, it being a mainstream
thing (for average sysadmin John and proverbial aunt Tilly).  It
definitely is useful for many different use cases tho.  Hey, but let's
see.

> These are also some excellent points for discussion!  The manager thread
> is visible.  For example, if you run a gdb session under checkpoint
> control (only available in our unstable branch, currently), then
> the gdb session will indeed see the checkpoint manager thread.

I don't think gdb seeing it is a big deal as long as it's hidden from
the application itself.

> We try to hid the reserved signal (SIGUSR2 by default, but the user
> can configure it to anything else).  We put wrappers around system
> calls that might see our signal handler, but I'm sure there are
> cases where we might not succeed --- and so a skilled user would
> have to configure to use a different signal handler.  And of course,
> there is the rare application that repeatedly resets _every_ signal.
> We encountered this in an earlier version of Maple, and the Maple
> developers worked with us to open up a hole so that we could
> checkpoint Maple in future versions.
>
>>   [while] all programs should be ready to handle -EINTR failure from system
>>   calls, it's something which is very difficult to verify and test and
>>   could lead to once-in-a-blue-moon head scratchy kind of failures.
>
> Exactly right!  Excellent point.  Perhaps this gets down to
> philosophy, and what is the nature of a bug.  :-) In some cases, we
> have encountered this issue.  Our solution was either to refuse to
> checkpoint within certain system calls, or to check the return value
> and if there was an -EINTR, then we would re-execute the system
> call.  This works again, because we are using wrappers around many
> (but not all) of the system calls.

I'm probably missing something but can't you stop the application
using PTRACE_ATTACH?  You wouldn't need to hijack a signal or worry
about -EINTR failures (there are some exceptions but nothing really to
worry about).  Also, unless the manager thread needs to be always
online, you can inject manager thread by manipulating the target
process states while taking a snapshot.

> But since you ask :-), there is one thing on our wish list.  We
> handle address space randomization, vdso, vsyscall, and so on quite
> well.  We do not turn off address space randomization (although on
> restart, we map user segments back to their original addresses).
> Probably the randomized value of brk (end-of-data or end of heap) is
> the thing that gave us the most troubles and that's where the code
> is the most hairy.

Can you please elaborate a bit?  What do you want to see changed?

> The implementation is reasonably modularized.  In the rush to
> address bugs or feature requirements of users, we sometimes cut
> corners.  We intend to go back and fix those things.  Roughly, the
> architecture of DMTCP is to do things in two layers: MTCP handles a
> single multi-threaded process.  There is a separate library mtcp.so.
> The higher layer (redundantly again called DMTCP) is implemented in
> dmtcphijack.so.  In a _very_ rough kind of way, MTCP does a lot of
> what would be done within kernel C/R.  But the higher DMTCP layer
> takes on some of those responsibilities in places.  For example,
> DMTCP does part of analyzing the pseudo-ttys, since it's not always
> easy to ensure that it's the controlling terminal of some process
> that can checkpoint things in the MTCP layer.
>
> Beyond that, the wrappers around system calls are essentially
> perfectly modular.  Some system calls go together to support a
> single kernel feature, and those wrappers are kept in a common file.

I see.  I just thought that it would be helpful to have the core part
- which does per-process checkpointing and restoring and corresponds
to the features implemented by in-kernel CR - as a separate thing.  It
already sounds like that is mostly the case.

I don't have much idea about the scope of the whole thing, so please
feel free to hammer senses into me if I go off track.  From what I
read, it seems like once the target process is stopped, dmtcp is able
to get most information necessary from kernel via /proc and other
methods but the paper says that it needs to intercept socket related
calls to gather enough information to recreate them later.  I'm
curious what's missing from the current /proc.  You can map socket to
inode from /proc/*/fd which can be matched to an entry in
/proc/*/net/PROTO to find out the addresses and most socket options
should be readable via getsockopt.  Am I missing something?

I think this is why userland CR implementation makes much more sense.
Most of states visible to a userland process are rather rigidly
defined by standards and, ultimately, ABI and the kernel exports most
of those information to userland one way or the other.  Given the
right set of needed features, most of which are probabaly already
implemented, a userland implementation should have access to most
information necessary to checkpoint without resorting to too messy
methods and then there inevitably needs to be some workarounds to make
CR'd processes behave properly w.r.t. other states on the system, so
userland workarounds are inevitable anyway unless it resorts to
preemtive separation using namespaces and containers, which I frankly
think isn't much of value already and more so going forward.

Thanks.

-- 
tejun
