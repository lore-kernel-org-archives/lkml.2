Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab0KFAgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 20:36:52 -0400
Received: from amber.ccs.neu.edu ([129.10.116.51]:39008 "EHLO
	amber.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab0KFAgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 20:36:50 -0400
MIME-Version: 1.0
In-Reply-To: <4CD3CE29.2010105@kernel.org>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>
 <4CD08419.5050803@kernel.org> <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com>
 <4CD26948.7050009@kernel.org> <20101104164401.GC10656@sundance.ccs.neu.edu> <4CD3CE29.2010105@kernel.org>
From: Kapil Arya <kapil@ccs.neu.edu>
Date: Fri, 5 Nov 2010 20:36:27 -0400
Message-ID: <AANLkTimDXKsBCxbsEOfgkYV2R8FK=bhFdmx9UQow5hqp@mail.gmail.com>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
To: Tejun Heo <tj@kernel.org>
Cc: Gene Cooperman <gene@ccs.neu.edu>, Oren Laadan <orenl@cs.columbia.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, hch@lst.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm probably missing something but can't you stop the application
> using PTRACE_ATTACH?  You wouldn't need to hijack a signal or worry
> about -EINTR failures (there are some exceptions but nothing really to
> worry about).  Also, unless the manager thread needs to be always
> online, you can inject manager thread by manipulating the target
> process states while taking a snapshot.

In fact CryoPid uses exactly the same approach and has been around for around 5
years. Not as much development effort has gone into CryoPid as DMTCP and so its
application coverage is not as broad. But the larger issue for using PTRACE is
that you can not have two superiors tracing the same inferior process. So if you
want to checkpoint a gdb session or valgrind or tmux or strace, then you can not
directly control and quiesce the inferior process being traced.

Beyond that, we also have a vision (not yet implemented) of process
virtualization by which one can change the behavior of a program. For example,
if a distributed computation runs over infiniband, can we migrate to a TCP/IP
cluster. For this, one needs the flexibility of wrappers around system calls.
This vision of process virtualization also motivates why our own research
project has steered away from in-kernel C/R.

> > But since you ask :-), there is one thing on our wish list.  We
> > handle address space randomization, vdso, vsyscall, and so on quite
> > well.  We do not turn off address space randomization (although on
> > restart, we map user segments back to their original addresses).
> > Probably the randomized value of brk (end-of-data or end of heap) is
> > the thing that gave us the most troubles and that's where the code
> > is the most hairy.
>
> Can you please elaborate a bit?  What do you want to see changed?

Yes, we would love to elaborate :-). We began DMTCP with Linux kernel 2.6.3.
When Address Space Layout Randomization was added, we were forced to add some
hacks concerning VDSO location and end-of-data. end-of-data is the uglier part.
On restart, we directly map each memory segment into the original address at
checkpoint time. The issue comes in mapping heap back to its original location.
We call sbrk() to reset the end-of-data to the end of the original heap. This
fails if the randomized beginning-of-data/end-of-data given to us by the kernel
for the restarted process is too far away from where we want to remap the heap.
To get around this, we play games with legacy layout, other personality
parameters, and RLIMIT_STACK (since the kernel uses RLIMIT_STACK in choosing the
appropriate memory layout).

For our wish list, we would like a way of telling the kernel, where to set
beginning-of-data/end-of-data. Curiously enough, at the time at which Linux
started randomizing address space, there was discussion of offering exactly this
facility for the sake of legacy programs, but it turned out not to be needed.

Similarly, it would be nice to tell the kernel where we want the VDSO page.
Currently, we get around this by keeping two VDSO pages, the old one which we
restore and the new one specified to us by the kernel when the restart process
is created. This works well for, and so controlling the address of the VDSO page
is less important for us.

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

The design of DMTCP was decided upon roughly during the period from Linux 2.6.3
through Linux 2.6.18. At that time, /proc/*/net did not exist. You are right
that this can provide much better design for DMTCP and eliminate some of our
wrappers. Thanks very much for pointing this out. We are now egar to implement a
new design based on /proc/*/net in the near future.

Since /proc/*/net provides a simpler design for sockets, we started wondering
what other simplifications may be possible. Here is one possibility, in the case
of shared file descriptors, DMTCP goes through two barriers in order to decide
which process will be responsible for checkpointing which shared-file
descriptor. It works and the overhead is reasonable, but if you have additional
suggestion for this case, we would be very interested.

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
> preemtive separation using namespaces and containers, which I frankly
> think isn't much of value already and more so going forward.

Its a very good point and we agree completely. Here are some examples where we
believe, a userland component is inevitable even if one begins with in-kernel
C/R:
1. NSCD deamon -- in calls to libc::gethostname() etc. libc arranges for
   communication by sharing a memory segment with application process. Our code
   recognized this shared memory because it starts with /var/*/nscd.
2. syslogd -- Application using syslog have a socket open to the syslog deamon.
   DMTCP makes a system call to turnoff logging at checkpoint time.
3. X-windows terminals -- xterm/gnome-terminal/konsole all emulate ANSI
   terminals. They support various ANSI features such as setting up scrolling
   region above status line. GNU screen uses the scrolling region feature. On
   restart, we have to convince GNU screen and similar programs to re-initialize
   their ANSI terminal. We do this successfully by sending a SIGWINCH on
   restart, since it has to re-initialize the ANSI terminal whenever the window
   size changes. In fact we send one SIGWINCH and when the application calls
   ioctl(), to get the window size, we lie and say that the window size changed,
   and we then send another SIGWINCH from within the wrapper to force the
   application to recheck the window size and discover that the window is back
   to its original size.
4. X11 apps -- The current approach to checkpointing X-windows application is to
   checkpoint them within a VNC server. We plan to add wrappers around calls to
   libX11.so so that we can discover the state of an X11 window at checkpoint
   time and then restart just the single X11 application. This avoids the need
   to also checkpoint the X11 server which minimized the size of the the
   checkpoint image that needs to be written to the disk.
5. GNU Screen -- DMTCP sets SCREEN_DIR to a temp directory in order to avoid the
   issue that occurs when the setsuid screen process tries to across
   /var/run/uscreen. Otherwise we would have difficulty at restart time when the
   checkpoint image has no setsuid privilege. We don't know if there are similar
   issues with an in-kernel C/R.

We really enjoyed this discussion. If you are interested, we would be happy to
talk further by phone in order to take advantage of the higher bandwidth.

Best,
-Gene and Kapil
