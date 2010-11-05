Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab0KEDz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:55:27 -0400
Received: from amber.ccs.neu.edu ([129.10.116.51]:38035 "EHLO
	amber.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab0KEDzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:55:25 -0400
MIME-Version: 1.0
In-Reply-To: <4CD23087.30900@cs.columbia.edu>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>
 <4CD08419.5050803@kernel.org> <4CD23087.30900@cs.columbia.edu>
From: Kapil Arya <kapil@ccs.neu.edu>
Date: Thu, 4 Nov 2010 23:55:02 -0400
Message-ID: <AANLkTikgPKeZUih6_12JWSNy=Vsz2UP9HR7wHOz4q6ST@mail.gmail.com>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Tejun Heo <tj@kernel.org>, ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Gene Cooperman <gene@ccs.neu.edu>,
        Kapil Arya <kapil@ccs.neu.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry for the length of this email, we are excited about being able
to discuss technical details.)

This is wonderful to have this exchange of techniques and visions.  Oren, we
are guessing that you are at Columbia. If so, we would love to have you come up
here and give a talk in Boston. Alternatively, if you prefer, we would be happy
to go to Columbia and give a talk there.

In comparing functionality, one recent bug we had to overcome was with screen
with a hardstatus line and a scroll region for the terminal. We eventually
solved it in a subtle way by sending SIGWINCH, and then lying to screen about
changing the kernel window size, and then sending screen another SIGWINCH while
telling it the true window size. We were pleased to see that Linux C/R also
supports screen and we are curious how it handles this issue of restoring the
scroll region in the X11 terminal window. Thanks.

Oren noted that sometimes it's important to stop the process only for a few
miliseconds while one checkpoints. In DMTCP, we do that by configuring with
--enable-forked-checkpointing. This causes us to fork a child process taking
advantage of copy-on-write and then checkpoint the memory pages of the child
while the parent continues to execute.

> So a checkpoint will typically capture the state of e.g. a VNC server (X
> session) and the applications (xterm, win-manager etc), and the dbus daemon,
> and all their open files, and sockets etc.

This is a good example of distinct approaches when starting from Kernel C/R or
user-space C/R. We currently checkpoint VNC servers in a way similar to Linux
C/R. However, in the next few months, we want to directly checkpoint a single
X-windows application without the X11-server. The approach is easily understood
by analogy. Currently libc.so talks to the kernel. At checkpoint time, we
interrogate the kernel state and then "break" the connection to the kernel and
checkpoint. Similarly, libX11.so (or libX11-xcb.so) talks to the X11-server. At
checkpoint time, we will interrogate the state of the X11-server and then break
the connection and checkpoint.

> DMTCP is indeed a very cool project. ...  It is not my intention to bash
> their great work, but it's important to understand its limitations, so just a
> few examples:

Thanks very much for bringing up these implementation questions. Its wonderful
to have someone interested in the low level technology to talk to. We would
like to share with you our current solutions and our plans for the future. We
will also add some of our question about Linux C/R inline. Thanks for the
answers in advance.

> required to link against their library, or modify the binary;

We currently use LD_PRELOAD to transparently preload our library. The user
doesn't see this. If the application is statically linked, then this doesn't
work. Until now, we haven't seen user requests to support statically linked
applications. If we do, there are other techniques to modify the call sites or
entry points for libc routines within the user binary.

> They overload some signals (so the application can't use them)

By default, DMTCP uses SIGUSR2. At process startup, the user can specify:
dmtcp_checkpoint --mtcp-checkpoint-signal <signum> a.out to change the DMTCP
signal. In an additional point we have found interesting, libc has a similar
policy of using several hardwired signal:
    #define SIGCANCEL	__SIGRTMIN
    #define SIGTIMER	SIGCANCEL
    #define SIGSETXID	(__SIGRTMIN + 1)
So there is a precedent for this approach.

> Completeness: many real resources are not supported, e.g. eventpoll, ipc,
> pending signals, etc.

IPC and pending signals are supported. We know how to do eventpoll but haven't
encountered a use case from our userbase and so haven't added it yet.

> * Complexity: they technically implement a virtual pid-namespace in userspace
> by intercepting calls to clone(). I wonder if they consider e.g. pid's saved
> on file owners or in afunix creds ? I'll just say it's nearly impossible with
> their 20K lines of code - I know because I did it in a kernel module ...

We do wrap clone and create a table from original PID/TID to current PID/TID
just as you say. To our knowledge, we have wrappers for all system calls
involving a PID/TID except fcntl. We are guessing that either Linux C/R also
keeps a translation table or else restores the original PID/TID. Which do you
do? In the latter case what do you do if a PID/TID is already used by another
process/thread?

> * Efficiency: from userspace it can't tell which mapped pages are dirty and
> which aren't, not to mention doing incremental checkpoints.

One of the DMTCP team, Artem Polyakov, has developed incremental checkpointing
for DMTCP and for BLCR. We are still evaluating it. It's at:
    http://sourceforge.net/projects/hbict

> * Usefulness: can they live-migrate mysql server between two hosts prior to a
> kernel upgrade ?

We have not experimented with live-migration. Live-migration in user space is an
interesting topic but will take us into deep discussion outside of the current
scope. Of course VMware and others already do it. We would enjoy talking further
with you offline. It's certainly a cool use case.

> can they checkpoint stopped processes which cannot cooperate ?

We haven't had a user request for checkpointing stopped processes so far.
However one can use PTRACE (similar to doing gdb attach on stopped process) to
achieve this.

> can they checkpoint/restart postgresql ?

We don't know. We have succeeded on MySQL. We never tried postgresql. What are
the special issues there?

> In contrast, the kernel C/R is:
> ...
> * entirely transparent to applications (does not need their cooperation, can
> even do debugged tasks)

We are not sure what you are referring to by cooperation and debugged tasks. If
it helps, we can say that DMTCP can checkpoint an entire gdb session or just the
process being debugged by the gdb, according to the requirements. Our support
for PTRACE is in the unstable branch.

> * is easier to maintain in the long run (because you don't need to cheat
> applications by intercepting their kernel calls from userspace!)

We have to agree to disagree on this one. We see almost no new bugs or issues
with kernel upgrades. The most recent case was the need to add the wrapper for
pipe2 (2.6.27) and accept4 (2.6.28) and each wrapper was about 20 new lines of
code.

> * flexible to allow smart userspace to also be c/r aware, if they so wish

DMTCP also has a dmtcpaware facility by which applications can request
checkpoints for themselves or other processes. It also support user hook
functions for checkpoint, resume, and restart.

> * can provide a guarantee that a checkpoint is self-contained and can be
> later restarted

Could you tell us more about what do you mean by gurantee and self-contained?

> In fact, DMTCP will be much more useful if it builds on linux-cr as its
> chekcpoint-restart engine ;)

Your suggestion is an interesting one. One of our team members, Jason Ansel, has
made the same suggestion with respect to BLCR. This would be a great experiment
to try and we would be glad to work with you to get an initial version of DMTCP
on top of Linux C/R. DMTCP has a higher layer dmtcphijack.so and a lower layer
libmtcp.so (MTCP) which can be replaced by a modified single process
checkpointer with hooks for dmtcphijack.so. Unfortunately, our group
doesn't have
the resources to maintain and develop two branches: DMTCP/MTCP and
DMTCP/Linux C/R. Nevertheless, if you were interested in going forward on the
DMTCP/Linux C/R branch, we could share code and ideas.

> Actually, because of the huge optimization potential that exists only in
> kernel based C/R, the HPC applications are likely to benefit tremendously too
> from it. Think about things like incremental checkpoint, pre-copy to minimize
> downtime (like live-migration), using COW to defer disk IO until after the
> application can resume execution, and more. None of these is possible with
> userspace C/R.

BLCR is a kernel-based C/R package, and appears to be the current standard for
HPC. Are you saying that BLCR should be replaced by Linux C/R, if so, why?

Concerning user space C/R, please see our comments above.

> I know of several places that do not use C/R because they can't stop their
> long running processes for longer than a few milliseconds.  I know how to
> solve their problems with linux-cr. I doubt if any userspace mechanism can
> get there.

DMTCP supports forked checkpointing as a configure option. A child is forked
using COW and it writes its memory to disk at leisure.


                                                 Thanks,
                                                 Gene Cooperman and Kapil Arya
