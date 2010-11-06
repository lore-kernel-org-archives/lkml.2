Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab0KFUkY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 16:40:24 -0400
Received: from amber.ccs.neu.edu ([129.10.116.51]:52077 "EHLO
	amber.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab0KFUkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 16:40:23 -0400
Date: Sat, 6 Nov 2010 16:40:08 -0400
From: Gene Cooperman <gene@ccs.neu.edu>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, Gene Cooperman <gene@ccs.neu.edu>,
        Kapil Arya <kapil@ccs.neu.edu>, Oren Laadan <orenl@cs.columbia.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
Message-ID: <20101106204008.GA31077@sundance.ccs.neu.edu>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>
 <4CD08419.5050803@kernel.org>
 <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com>
 <4CD26948.7050009@kernel.org>
 <20101104164401.GC10656@sundance.ccs.neu.edu>
 <4CD3CE29.2010105@kernel.org>
 <20101106053204.GB12449@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101106053204.GB12449@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the way, Oren, Kapil and I are hoping to find time in the next few
days to talk offline.  Apparently the Linux C/R and DMTCP had continued
for some years unaware of each other.  We appreciate that a huge amount
of work has gone into both of the approaches, and so we'd like to reap
the benefit of the experiences of the two approaches.  We're still learning
more about each others' approaches.  Below, I'll try to answer as best
I can the questions that Matt brings up.  Since Matt brings up _lots_
of questions, and I add my own topics, I thought it best to add a table
of contents to this e-mail.  For each topic, you'll see a discussion
inline below.

1.  Distros, checkpointing a desktop, KDE/Gnome, X
  [ Trying to answer Matt's question ]

2.  Directly checkpointing a single X11 app
  [ Our own preferred approach, as opposed to checkpinting an entire desktop;
    This is easy, but we just haven't had the time lately.  I estimate
    the time to do it is about one person working straight out for two weeks
    or so.  But who has that much spare time.  :-)  ]

3. OpenGL
  [ Checpointing OpenGL would be a really big win.  We don't know the
    right way, but we're looking.  Do you have some thoughts on that?  Thanks.]

4. inotify and NSCD
  [ We try to virtualize a single app, instead of also checkpointing
    inotify and NSCD themselves.  It would have been interesting to consider
    checkpointing them in userland, but that would require root privilege,
    and one core design principle we have, is that all of our C/R is
    completely unprivileged.  So, we would see distributing DMTCP as
    a package in a distro, and letting individual users decide for
    what computation they might want to use it. ]

5. Checkpointing DRM state and other graphics chip state
  [ It comes down to virtualization around a single app versus checkpointing
    _all_ of X. --- Two different approaches. ]

6. kernel c/r of input devices might be alot easier
  [ We agree with you.  By virtualizing around a single app, we hope
    to avoid this issue. ]

7. C/R for link/open/rm/open/write/read puzzle

8.  What happens if the DMTCP coordinator ( checkpoint control process) dies?
  [ The same thing that happens if a user process dies.  We kill the whole
    computation, and restart.  At restart, we use a new coordinator.
    Coordinators are stateless. ]

9. We try to hide the reserved signal (SIGUSR2 by default) ...
  [ Matt says this is a mess, but we note that glibc does this too. ]

10. checkpoint, gdb and PTRACE_ATTACH
  [ DMTCP does not use PTRACE_ATTACH in its implementation.  So, we can
    and do fully support user processes that use PTRACE_ATTACH. ]

11. DMTCP, ABIs, can there be a race condition between the ckpt thread and
  user threads of an app?
  [ DMTCP doesn't introduce any new ABIs.  There may be a misconception here.
    If we can talk at length off-line, I could explain more about
    the DMTCP design.  Inline, I explain why race conditions should
    not be an issue. ]

12.  nested containers, ABIs, etc.
  [ see inline comment ]

13.  a userland implementation should have access to most
    information necessary to checkpoint without resorting to too messy
  [ In fact, the primary ABIs that we use outside of system calls
    are /proc/*/maps and /proc/*/fd.  Even here, we would have workarounds
    if someone took those ABIs away. ]

The full range of comments is inline below.  Sorry that this e-mail
is getting so long.  There are many things to talk about.  I hope to
later take advantage of the higher bandwidth with Oren (by phone)
to thrash out some of these things together.

Thanks,
- Gene

On Fri, Nov 05, 2010 at 10:32:04PM -0700, Matt Helsley wrote:
> On Fri, Nov 05, 2010 at 10:28:09AM +0100, Tejun Heo wrote:
> > Hello,
> > 
> > On 11/04/2010 05:44 PM, Gene Cooperman wrote:
> > >>> In our personal view, a key difference between in-kernel and userland
> > >>> approaches is the issue of security.
> > >>
> > >> That's an interesting point but I don't think it's a dealbreaker.
> > >> ... but it's not like CR is gonna be deployed on
> > >> majority of desktops and servers (if so, let's talk about it then).
> > >
> > > This is a good point to clarify some issues.  C/R has several good
> > > targets.  For example, BLCR has targeted HPC batch facilities, and
> > > does it well.
> > >
> > > DMTCP started life on the desktop, and it's still a primary focus of
> > > DMTCP.  We worked to support screen on this release precisely so
> > > that advanced desktop users have the option of putting their whole
> > > screen session under checkpoint control.  It complements the core
> > > goal of screen: If you walk away from a terminal, you can get back
> > > the session elsewhere.  If your session crashes, you can get back
> > > the session elsewhere (depending on where you save the checkpoint
> > > files, of course :-) ).
> > 
> > Call me skeptical but I still don't see, yet, it being a mainstream
> > thing (for average sysadmin John and proverbial aunt Tilly).  It
> > definitely is useful for many different use cases tho.  Hey, but let's
> > see.
> 
> Rightly so. It hasn't been widely proven as something that distros
> would be willing to integrate into a normal desktop session. We've got
> some demos of it working with VNC, twm, and vim. Oren has his own VNC,
> twm, etc demos too. We haven't looked very closely at more advanced
> desktop sessions like (in no particular order) KDE or Gnome. Nor have
> we yet looked at working with any portions of X that were meant to provide
> this but were never popular enough to do so (XSMP iirc).
> 
> Does DMTCP handle KDE/Gnome sessions? X too?

1.  Distros, checkpointing a desktop, KDE/Gnome, X

DMTCP does checkpoint VNC sessions with a desktop, KDE/Gnome, and X.
We were doing that in some joint work with SCIRun:
    http://www.sci.utah.edu/cibc/software/106-scirun.html
SCIRun only works under X, and so it was an absolute prerequisite.
SCIRun optionally also likes to use OpenGL (3-D graphics).  We had hacked
up something for OpenGL 1.5, and I write more on that, below.

However, we agree with you that a distro would probably not want to run
C/R under their regular X session.  If anything minor fails, it hurts their
reputation, which is everything for them.  So, think that's a non-starter.

The other possibility is to use C/R on a VNC session for an X desktop.
We also think that most users would not care for the extra complication
of having two desktops (one under checkpoint control, and the main one).

One can run an individual X11 application under VNC and checkpoint
the VNC.  We can and _do_ do that.  But it's still unsatisfying for us.
The heaviness and added complexity of checkpointing a VNC server makes
us nervous. 

2.  Directly checkpointing a single X11 app

So, as I said in a different post, we're planning to virtualize directly
around libX11.so and libxcb.so.  Then we'll checkpoint the X11 graphic
application and _only_ the X11 graphic application.  

We think that a really cool advantage of this approach is that
if you checkpoint the X11 app under Gnome, then you can bring it back
to life under KDE, and it will now have the look-and-feel of KDE.

Another advantage of this approach is that there's a single desktop
shared by all applications.  If the X11 application wishes to use
dbus, a window manager, or whatever, to communicate with other X11 apps,
it can continue to do so.  Our virtualization approach should work
well when interaction goes through a small enough library around
which we can place wrappers.  The library can be libc.so, libX11.so,
or any of many other libraries.

This also seems more modular to us.  A VNC server has to worry about
_lots_ of things, and we only need the connect/disconnect portion of
the VNC server.  It's not hard to implement that directly in a small
library.  Also, if we checkpoint fewer processes, the time to write to
disk is smaller.

3. OpenGL

We had hacked up something for OpenGL 1.5 with the intention of supporting
SCIRun.  It was based on the work of:
     http://andres.lagarcavilla.com/publications/LagarCavillaVEE07.pdf
     http://andres.lagarcavilla.com/vmgl/index.html
The problem was that OpenGL is growing and adding system calls
faster than one can virtualize them.  :-)  We didn't want to always
be chasing around to support the newest addition to OpenGL.

Have you also looked at checkpointing OpenGL?  It's an interesting
question.  Unfortunately, I doubt that the vendors will support C/R
in their video drivers, and so we're forced to look for a different
solution (or give up, and we don't like giving up :-) ).

> On the kernel side of things for the desktop, right now we think our
> biggest obstacle is inotify. I've been working on kernel patches for
> kernel-cr to do that and it seems fairly do-able. Does DMTCP handle
> restarting inotify watches without dropping events that were present
> during checkpoint?

4. inotify and NSCD

We have run into inotify.  We don't try to checkpoint inotify itself. 
Instead, as with X11 apps, our larger interest is in checkpointing
a single computation that might have been interacting with inotify,
and then be able to restart the single app and resume talking
with inotify.  The situation is similar to that with NSCD (Network
Services Caching Daemon).

If you wish to checkpoint a single application, and if it was talking
to the Network Services Caching Daemon, how do you handle that?
Is it that you always checkpoint both the app and the NSCD at the
same time?
    If so, perhaps this is a key difference in the two approaches:
virtualize around a single app; or checkpoint _every_ process that
is interacting with the process of interest.  But I'm just speculating,
and I need to talk more with you all to understand better.

> The other problem for kernel c/r of X is likely to be DRM. Since the
> different graphics chipsets vary so widely there's nothing we can do
> to migrate DRM state of an NVIDIA chipset to DRM state of an ATI chipset
> as far as I know. Perhaps if that would help hybrid graphics systems
> then it's something that could be common between DRM and
> checkpoint/restart but it's very much pie-in-the-sky at the moment.

5. Checkpointing DRM state and other graphics chip state

Again, this may come down to virtualization around a single
application versus checkpointing everything.  We would try to avoid
the necessity of checkpointing graphics drivers, DRM issues, etc.,
through virtualization.  As I wrote above, though, we don't yet have
a good virtualization solution when it comes to OpenGL.  So, we're very
interested in any thoughts you have about handling OpenGL.

> kernel c/r of input devices might be alot easier. We just simulate
> hot [un]plug of the devices and rely on X responding. We can even
> checkpoint the events X would have missed and deliver them prior to hot
> unplug.

6. kernel c/r of input devices might be alot easier

I think I would agree.  As indicated above, our philosphy is to virtualize
the single app, instead of "checkpointing the world", as one of
our team, Jason Ansel, used to like to say.  :-)  But this is not
to say that checkpointing the entire X with input devices isn't also
interesting.  The two works are complementary.

> Also, how does DMTCP handle unlinked files? They are important because
> lots of process open a file in /tmp and then unlink it. And that's not
> even the most difficult case to deal with. How does DMTCP handle:
> 
> link a to b
> open a (stays open)
> rm a
> <checkpoint and restart>
> open b
> write to b
> read from a (the write must appear)
> 
> ?

7. C/R for link/open/rm/open/write/read puzzle

We did have some similar issues ing like this in some of the apps we
looked at.  For example, if my memory is right, in an app that works with
the NSCD daemon, it mmaps a shared file, and then unlinks the file so that
the file will be deleted when the app exits.  Just to make sure that
everything is precise, would you mind writing a short app like that
and sending it to us?  For example, I'm guessing the link is a symbolic
link, but the actual code will make it all precise.  We'll directly perform
the experiment you propose and tell you the result.
    I think the short story will be that we have a command-line option
by which the user specifies if they would like to checkpoint open
files.  We also have heuristics to try to do the right thing when the
user didn't give us specific instructions on the command line.
    The short answer is that we're driven by the use cases we encounter,
and we think of application coverage.  You may be right that we don't
currently cover this, but I would like to try it first, and verify.
If you have an important use case for this scenario, we will definitely
add coverage for it.
    Maybe this is another difference in philosophy.  Oren talked about
full transparency --- meaning that the kernel will always present the
illusion of continuity to an app.  Because we know the design of DMTCP,
we know of ways that a userland app could create weird cases where
the wrong things happen.  When we discover an app that needs the weird
case, we expand our coverage through additional virtualization.

> > > These are also some excellent points for discussion!  The manager thread
> > > is visible.  For example, if you run a gdb session under checkpoint
> > > control (only available in our unstable branch, currently), then
> > > the gdb session will indeed see the checkpoint manager thread.
> > 
> > I don't think gdb seeing it is a big deal as long as it's hidden from
> > the application itself.
> 
> Is the checkpoint control process hidden from the application? What
> happens if it gets killed or dies in the middle of checkpoint? Can
> a malicious task being checkpointed (perhaps for later analysis)
> kill it? Or perhaps it runs as root or a user with special capabilities?

8.  What happens if the DMTCP coordinator ( checkpoint control process) dies

If the checkpoint control process dies, then the checkpoint manager thread
in the user app never hears from the coordinator again.  The application
continues anyway without failing.  But, it's no longer possible to
checkpoint that application.  Again, I think it's a difference in
philosophy.  We want to checkpoint a single app or computation.
If that computation loses _any_ of its processes (whether it's the
DMTCP coordinator process or one of the application processes itself),
then it's best to kill the compuation and restart from the last
checkpoint image.  Our DMTCP coordinator is stateless, and so it's
no problem to create a new DMTCP coordinator at the time of restart.

> > > We try to hid the reserved signal (SIGUSR2 by default, but the user
> Mess.

9. We try to hide the reserved signal (SIGUSR2 by default

Beauty is in the eye of the beholder.  :-)  I remind you that libc
reserves SIGRTMIN and SIGRTMIN + 1 for thread cancellation and
for setxid, respectively.  If reserving a signal is bad, then
libc.so is also a "Mess".  In the glibc source, look at:
./nptl/pthreadP.h: #define SIGCANCEL	__SIGRTMIN
./nptl/pthreadP.h: #define SIGSETXID	(__SIGRTMIN + 1)
Probably glibc is even worse than us.  They use the signal, and they
_don't_ hide it from the user.  Userland is a messy place.  :-) 

> > > can configure it to anything else).  We put wrappers around system
> > > calls that might see our signal handler, but I'm sure there are
> > > cases where we might not succeed --- and so a skilled user would
> > > have to configure to use a different signal handler.  And of course,
> > > there is the rare application that repeatedly resets _every_ signal.
> > > We encountered this in an earlier version of Maple, and the Maple
> > > developers worked with us to open up a hole so that we could
> > > checkpoint Maple in future versions.
> > >
> > >>   [while] all programs should be ready to handle -EINTR failure from system
> > >>   calls, it's something which is very difficult to verify and test and
> > >>   could lead to once-in-a-blue-moon head scratchy kind of failures.
> > >
> > > Exactly right!  Excellent point.  Perhaps this gets down to
> > > philosophy, and what is the nature of a bug.  :-) In some cases, we
> > > have encountered this issue.  Our solution was either to refuse to
> > > checkpoint within certain system calls, or to check the return value
> > > and if there was an -EINTR, then we would re-execute the system
> > > call.  This works again, because we are using wrappers around many
> > > (but not all) of the system calls.
> > 
> > I'm probably missing something but can't you stop the application
> > using PTRACE_ATTACH?  You wouldn't need to hijack a signal or worry
> 
> Wouldn't checkpoint and gdb interfere then since the kernel only allows
> one task to attach? So if DMTCP is checkpointing something and uses this
> solution then you can't debug it. If a user is debugging their process then
> DMTCP can't checkpoint it.

10. checkpoint, gdb and PTRACE_ATTACH

As a design decision, DMTCP never traces a process.  We did this so we
could easily checkpoint a gdb session without worrying about gdb and
DMTCP both trying to trace the gdb target process.

> > about -EINTR failures (there are some exceptions but nothing really to
> > worry about).  Also, unless the manager thread needs to be always
> > online, you can inject manager thread by manipulating the target
> > process states while taking a snapshot.
> 
> Ugh. Frankly it sounds like we're being asked to pin our hopes on
> a house of cards -- weird userspace hacks involving extra
> processes, hodge-podge combinations of ptrace, LD_PRELOAD, signal
> hijacking, brk hacks, scanning passes in /proc (possibly at numerous
> times which begs for races), etc.
> 
> When all is said and done, my suspicion is all of it will be a mess
> that shows races which none of the [added] kernel interfaces can fix.
> 
> In contrast, kernel-based cr is rather straight forward when you bother
> to read the patches. It doesn't require using combinations of obscure
> userspace interfaces to intercept and emulate those very same interfaces.
> It doesn't add a scattered set of new ABIs. And any races would be in a
> a syscall where they could likely be fixed without adding yet-more ABIs
> all over the place.

11. DMTCP, ABIs, can there be a race condition between the ckpt thread and
  user threads of an app?

DMTCP does not add any new ABIs.  But maybe I misunderstood your point.
The only potential races I can see are between the checkpoint thread
and the user threads.  But the checkpoint thread does nothing except
listen for a command from the coordinator.  When the command comes,
it first quiesces the user threads, before doing anything.

All of those wrappers for virtualization that we refer to are executed
by the ordinary _user_ threads.  The checkpoint thread is in a select
system call during that entire time.

> > > But since you ask :-), there is one thing on our wish list.  We
> > > handle address space randomization, vdso, vsyscall, and so on quite
> > > well.  We do not turn off address space randomization (although on
> > > restart, we map user segments back to their original addresses).
> > > Probably the randomized value of brk (end-of-data or end of heap) is
> > > the thing that gave us the most troubles and that's where the code
> > > is the most hairy.
> > 
> > Can you please elaborate a bit?  What do you want to see changed?
> > 
> > > The implementation is reasonably modularized.  In the rush to
> > > address bugs or feature requirements of users, we sometimes cut
> > > corners.  We intend to go back and fix those things.  Roughly, the
> > > architecture of DMTCP is to do things in two layers: MTCP handles a
> > > single multi-threaded process.  There is a separate library mtcp.so.
> > > The higher layer (redundantly again called DMTCP) is implemented in
> > > dmtcphijack.so.  In a _very_ rough kind of way, MTCP does a lot of
> > > what would be done within kernel C/R.  But the higher DMTCP layer
> > > takes on some of those responsibilities in places.  For example,
> > > DMTCP does part of analyzing the pseudo-ttys, since it's not always
> > > easy to ensure that it's the controlling terminal of some process
> > > that can checkpoint things in the MTCP layer.
> > >
> > > Beyond that, the wrappers around system calls are essentially
> > > perfectly modular.  Some system calls go together to support a
> > > single kernel feature, and those wrappers are kept in a common file.
> > 
> > I see.  I just thought that it would be helpful to have the core part
> > - which does per-process checkpointing and restoring and corresponds
> > to the features implemented by in-kernel CR - as a separate thing.  It
> > already sounds like that is mostly the case.
> > 
> > I don't have much idea about the scope of the whole thing, so please
> > feel free to hammer senses into me if I go off track.  From what I
> > read, it seems like once the target process is stopped, dmtcp is able
> > to get most information necessary from kernel via /proc and other
> > methods but the paper says that it needs to intercept socket related
> > calls to gather enough information to recreate them later.  I'm
> > curious what's missing from the current /proc.  You can map socket to
> > inode from /proc/*/fd which can be matched to an entry in
> > /proc/*/net/PROTO to find out the addresses and most socket options
> > should be readable via getsockopt.  Am I missing something?
> > 
> > I think this is why userland CR implementation makes much more sense.
> 
> One forseeable future is nested containers. How will this house of cards
> work if we wish to checkpoint a container that is itself performing a
> checkpoint? We've thought about the nested container case and designed
> our interfaces so that they won't change for that case.
> 
> What happens if any of these new interfaces get used for non-checkpoint
> purposes and then we wish to checkpoint those tasks? Will we need any
> more interfaces for that? We definitely don't want two wind up with an
> ABI that looks like a Russian Doll.

12.  nested containers, ABIs, etc.

I think we would need to elaborate with individual cases.  But as I wrote
above, DMTCP and Linux C/R started with two different philosophies.
I'm not sure if you fully understood the DMTCP goals and philosophy yet,
but I hope my comments above help clarify it.
 
> > Most of states visible to a userland process are rather rigidly
> > defined by standards and, ultimately, ABI and the kernel exports most
> > of those information to userland one way or the other.  Given the
> > right set of needed features, most of which are probabaly already
> > implemented, a userland implementation should have access to most
> > information necessary to checkpoint without resorting to too messy
> 
> So you agree it will be a mess (Just not "too messy"). I have no
> idea what you think "too messy" is, but given all the stuff proposed
> so far I'd say you've reached that point already.

13.  a userland implementation should have access to most
    information necessary to checkpoint without resorting to too messy

If it helps, DMTCP began with Linux 2.6.3, and we continue to support
Linux 2.6.9.  In fact, DMTCP seems to uncover a bug in Linux 2.6.9
and maybe in Linux 2.6.18, or perhaps in the NFS implementation on top
of it.  We've experience some reproducible O/S instability when doing C/R
in certain of those environments.  :-)   But we mostly use newer kernels
now, where the reliability is truly excellent.

Anyway, I suspect most of these ABIs and kernel exports that you mention
did not exist in Linux 2.6.9.  We don't depend on them.  The ABIs
that we use outside of system calls are:  /proc/*/maps  /proc/*/fd
If those ABIs were taken away, we have other ways to virtualize
and get the information that we need.

> > methods and then there inevitably needs to be some workarounds to make
> > CR'd processes behave properly w.r.t. other states on the system, so
> > userland workarounds are inevitable anyway unless it resorts to
> > preemtive separation using namespaces and containers, which I frankly
> 
> Huh? I am not sure what you mean by "preemptive separation using
> namespaces and containers".
> 
> Cheers,
> 	-Matt Helsley
