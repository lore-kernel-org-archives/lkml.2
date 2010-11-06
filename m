Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab0KFFcJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 01:32:09 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:42815 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab0KFFcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 01:32:08 -0400
Date: Fri, 5 Nov 2010 22:32:04 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Gene Cooperman <gene@ccs.neu.edu>, Kapil Arya <kapil@ccs.neu.edu>,
        Oren Laadan <orenl@cs.columbia.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
Message-ID: <20101106053204.GB12449@count0.beaverton.ibm.com>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>
 <4CD08419.5050803@kernel.org>
 <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com>
 <4CD26948.7050009@kernel.org>
 <20101104164401.GC10656@sundance.ccs.neu.edu>
 <4CD3CE29.2010105@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD3CE29.2010105@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 10:28:09AM +0100, Tejun Heo wrote:
> Hello,
> 
> On 11/04/2010 05:44 PM, Gene Cooperman wrote:
> >>> In our personal view, a key difference between in-kernel and userland
> >>> approaches is the issue of security.
> >>
> >> That's an interesting point but I don't think it's a dealbreaker.
> >> ... but it's not like CR is gonna be deployed on
> >> majority of desktops and servers (if so, let's talk about it then).
> >
> > This is a good point to clarify some issues.  C/R has several good
> > targets.  For example, BLCR has targeted HPC batch facilities, and
> > does it well.
> >
> > DMTCP started life on the desktop, and it's still a primary focus of
> > DMTCP.  We worked to support screen on this release precisely so
> > that advanced desktop users have the option of putting their whole
> > screen session under checkpoint control.  It complements the core
> > goal of screen: If you walk away from a terminal, you can get back
> > the session elsewhere.  If your session crashes, you can get back
> > the session elsewhere (depending on where you save the checkpoint
> > files, of course :-) ).
> 
> Call me skeptical but I still don't see, yet, it being a mainstream
> thing (for average sysadmin John and proverbial aunt Tilly).  It
> definitely is useful for many different use cases tho.  Hey, but let's
> see.

Rightly so. It hasn't been widely proven as something that distros
would be willing to integrate into a normal desktop session. We've got
some demos of it working with VNC, twm, and vim. Oren has his own VNC,
twm, etc demos too. We haven't looked very closely at more advanced
desktop sessions like (in no particular order) KDE or Gnome. Nor have
we yet looked at working with any portions of X that were meant to provide
this but were never popular enough to do so (XSMP iirc).

Does DMTCP handle KDE/Gnome sessions? X too?

On the kernel side of things for the desktop, right now we think our
biggest obstacle is inotify. I've been working on kernel patches for
kernel-cr to do that and it seems fairly do-able. Does DMTCP handle
restarting inotify watches without dropping events that were present
during checkpoint?

The other problem for kernel c/r of X is likely to be DRM. Since the
different graphics chipsets vary so widely there's nothing we can do
to migrate DRM state of an NVIDIA chipset to DRM state of an ATI chipset
as far as I know. Perhaps if that would help hybrid graphics systems
then it's something that could be common between DRM and
checkpoint/restart but it's very much pie-in-the-sky at the moment.

kernel c/r of input devices might be alot easier. We just simulate
hot [un]plug of the devices and rely on X responding. We can even
checkpoint the events X would have missed and deliver them prior to hot
unplug.

Also, how does DMTCP handle unlinked files? They are important because
lots of process open a file in /tmp and then unlink it. And that's not
even the most difficult case to deal with. How does DMTCP handle:

link a to b
open a (stays open)
rm a
<checkpoint and restart>
open b
write to b
read from a (the write must appear)

?

> 
> > These are also some excellent points for discussion!  The manager thread
> > is visible.  For example, if you run a gdb session under checkpoint
> > control (only available in our unstable branch, currently), then
> > the gdb session will indeed see the checkpoint manager thread.
> 
> I don't think gdb seeing it is a big deal as long as it's hidden from
> the application itself.

Is the checkpoint control process hidden from the application? What
happens if it gets killed or dies in the middle of checkpoint? Can
a malicious task being checkpointed (perhaps for later analysis)
kill it? Or perhaps it runs as root or a user with special capabilities?

> 
> > We try to hid the reserved signal (SIGUSR2 by default, but the user

Mess.

> > can configure it to anything else).  We put wrappers around system
> > calls that might see our signal handler, but I'm sure there are
> > cases where we might not succeed --- and so a skilled user would
> > have to configure to use a different signal handler.  And of course,
> > there is the rare application that repeatedly resets _every_ signal.
> > We encountered this in an earlier version of Maple, and the Maple
> > developers worked with us to open up a hole so that we could
> > checkpoint Maple in future versions.
> >
> >>   [while] all programs should be ready to handle -EINTR failure from system
> >>   calls, it's something which is very difficult to verify and test and
> >>   could lead to once-in-a-blue-moon head scratchy kind of failures.
> >
> > Exactly right!  Excellent point.  Perhaps this gets down to
> > philosophy, and what is the nature of a bug.  :-) In some cases, we
> > have encountered this issue.  Our solution was either to refuse to
> > checkpoint within certain system calls, or to check the return value
> > and if there was an -EINTR, then we would re-execute the system
> > call.  This works again, because we are using wrappers around many
> > (but not all) of the system calls.
> 
> I'm probably missing something but can't you stop the application
> using PTRACE_ATTACH?  You wouldn't need to hijack a signal or worry

Wouldn't checkpoint and gdb interfere then since the kernel only allows
one task to attach? So if DMTCP is checkpointing something and uses this
solution then you can't debug it. If a user is debugging their process then
DMTCP can't checkpoint it.

> about -EINTR failures (there are some exceptions but nothing really to
> worry about).  Also, unless the manager thread needs to be always
> online, you can inject manager thread by manipulating the target
> process states while taking a snapshot.

Ugh. Frankly it sounds like we're being asked to pin our hopes on
a house of cards -- weird userspace hacks involving extra
processes, hodge-podge combinations of ptrace, LD_PRELOAD, signal
hijacking, brk hacks, scanning passes in /proc (possibly at numerous
times which begs for races), etc.

When all is said and done, my suspicion is all of it will be a mess
that shows races which none of the [added] kernel interfaces can fix.

In contrast, kernel-based cr is rather straight forward when you bother
to read the patches. It doesn't require using combinations of obscure
userspace interfaces to intercept and emulate those very same interfaces.
It doesn't add a scattered set of new ABIs. And any races would be in a
a syscall where they could likely be fixed without adding yet-more ABIs
all over the place.

> > But since you ask :-), there is one thing on our wish list.  We
> > handle address space randomization, vdso, vsyscall, and so on quite
> > well.  We do not turn off address space randomization (although on
> > restart, we map user segments back to their original addresses).
> > Probably the randomized value of brk (end-of-data or end of heap) is
> > the thing that gave us the most troubles and that's where the code
> > is the most hairy.
> 
> Can you please elaborate a bit?  What do you want to see changed?
> 
> > The implementation is reasonably modularized.  In the rush to
> > address bugs or feature requirements of users, we sometimes cut
> > corners.  We intend to go back and fix those things.  Roughly, the
> > architecture of DMTCP is to do things in two layers: MTCP handles a
> > single multi-threaded process.  There is a separate library mtcp.so.
> > The higher layer (redundantly again called DMTCP) is implemented in
> > dmtcphijack.so.  In a _very_ rough kind of way, MTCP does a lot of
> > what would be done within kernel C/R.  But the higher DMTCP layer
> > takes on some of those responsibilities in places.  For example,
> > DMTCP does part of analyzing the pseudo-ttys, since it's not always
> > easy to ensure that it's the controlling terminal of some process
> > that can checkpoint things in the MTCP layer.
> >
> > Beyond that, the wrappers around system calls are essentially
> > perfectly modular.  Some system calls go together to support a
> > single kernel feature, and those wrappers are kept in a common file.
> 
> I see.  I just thought that it would be helpful to have the core part
> - which does per-process checkpointing and restoring and corresponds
> to the features implemented by in-kernel CR - as a separate thing.  It
> already sounds like that is mostly the case.
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
> 
> I think this is why userland CR implementation makes much more sense.

One forseeable future is nested containers. How will this house of cards
work if we wish to checkpoint a container that is itself performing a
checkpoint? We've thought about the nested container case and designed
our interfaces so that they won't change for that case.

What happens if any of these new interfaces get used for non-checkpoint
purposes and then we wish to checkpoint those tasks? Will we need any
more interfaces for that? We definitely don't want two wind up with an
ABI that looks like a Russian Doll.

> Most of states visible to a userland process are rather rigidly
> defined by standards and, ultimately, ABI and the kernel exports most
> of those information to userland one way or the other.  Given the
> right set of needed features, most of which are probabaly already
> implemented, a userland implementation should have access to most
> information necessary to checkpoint without resorting to too messy

So you agree it will be a mess (Just not "too messy"). I have no
idea what you think "too messy" is, but given all the stuff proposed
so far I'd say you've reached that point already.

> methods and then there inevitably needs to be some workarounds to make
> CR'd processes behave properly w.r.t. other states on the system, so
> userland workarounds are inevitable anyway unless it resorts to
> preemtive separation using namespaces and containers, which I frankly

Huh? I am not sure what you mean by "preemptive separation using
namespaces and containers".

Cheers,
	-Matt Helsley
