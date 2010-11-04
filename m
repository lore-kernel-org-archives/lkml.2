Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab0KDQoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 12:44:13 -0400
Received: from amber.ccs.neu.edu ([129.10.116.51]:43227 "EHLO
	amber.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab0KDQoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 12:44:10 -0400
Date: Thu, 4 Nov 2010 12:44:01 -0400
From: Gene Cooperman <gene@ccs.neu.edu>
To: Tejun Heo <tj@kernel.org>
Cc: Kapil Arya <kapil@ccs.neu.edu>, Oren Laadan <orenl@cs.columbia.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Gene Cooperman <gene@ccs.neu.edu>,
        hch@lst.de
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
Message-ID: <20101104164401.GC10656@sundance.ccs.neu.edu>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>
 <4CD08419.5050803@kernel.org>
 <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com>
 <4CD26948.7050009@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD26948.7050009@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your comments.  We apologize for the top-post.  It was accidental.

> > In our personal view, a key difference between in-kernel and userland
> > approaches is the issue of security.
> That's an interesting point but I don't think it's a dealbreaker.
> ... but it's not like CR is gonna be deployed on
> majority of desktops and servers (if so, let's talk about it then).
This is a good point to clarify some issues.  C/R has several good
targets.  For example, BLCR has targeted HPC batch facilities, and
does it well.
    DMTCP started life on the desktop, and it's still a primary focus of DMTCP.
We worked to support screen on this release precisely so that advanced
desktop users have the option of putting their whole screen session
under checkpoint control.  It complements the core goal of screen:
If you walk away from a terminal, you can get back the session elsewhere.
If your session crashes, you can get back the session elsewhere
(depending on where you save the checkpoint files, of course :-) ).

> * As Oren pointed out in another message, there are somethings which
>   could seem a bit too visible to the target application.  Like the
>   manager thread (is it visible to the application or is it hidden by
>   the libc wrapper?) and reserved signal.  Also, while it's true that
>   all programs should be ready to handle -EINTR failure from system
>   calls, it's something which is very difficult to verify and test and
>   could lead to once-in-a-blue-moon head scratchy kind of failures.
These are also some excellent points for discussion!  The manager thread
is visible.  For example, if you run a gdb session under checkpoint
control (only available in our unstable branch, currently), then
the gdb session will indeed see the checkpoint manager thread.
So, yes.  We are not totally transparent, and a skilled user must
account for this.  There are analogies (the manager thread in the
original LinuxThreads, the rare misfortune of gdb to lose
track of the stack frames).
    We try to hid the reserved signal (SIGUSR2 by default, but the user can
configure it to anything else).  We put wrappers around system calls
that might see our signal handler, but I'm sure there are cases where
we might not succeed --- and so a skilled user would have to configure
to use a different signal handler.  And of course, there is the rare
application that repeatedly resets _every_ signal.  We encountered
this in an earlier version of Maple, and the Maple developers worked
with us to open up a hole so that we could checkpoint Maple in future versions.
>   [while] all programs should be ready to handle -EINTR failure from system
>   calls, it's something which is very difficult to verify and test and
>   could lead to once-in-a-blue-moon head scratchy kind of failures.
Exactly right!  Excellent point.  Perhaps this gets down to philosophy,
and what is the nature of a bug.  :-)  In some cases, we have encountered
this issue.  Our solution was either to refuse to checkpoint within
certain system calls, or to check the return value and if there was
an -EINTR, then we would re-execute the system call.  This works again,
because we are using wrappers around many (but not all) of the system calls.

>   Do you guys have things on mind which the
>   kernel can do to make these things more transparent or safer?
For the most part, we've always found a way to work within the current
design of the kernel.  We consider this a tribute to the Linux kernel
design.  They provided hooks in cases that userland C/R needs, even though
the hooks were there simply on general design principles.
    But since you ask :-), there is one thing on our wish list.  We
handle address space randomization, vdso, vsyscall, and so on quite well.
We do not turn off address space randomization (although on restart, we
map user segments back to their original addresses).  Probably the
randomized value of brk (end-of-data or end of heap) is the thing that
gave us the most troubles and that's where the code is the most hairy.

> * The feats dmtcp achieves with its set of workarounds are impressive
>   but at the same time look quite hairy.  Christoph said that having a
>   standard userland C-R implementation would be quite useful and IMHO
>   it would be helpful in that direction if the implementation is
>   modularized enough so that the core functionality and the set of
>   workarounds can be easily separated.  Is it already so?
The implementation is reasonably modularized.  In the rush to address
bugs or feature requirements of users, we sometimes cut corners.  We
intend to go back and fix those things.  Roughly, the architecture of
DMTCP is to do things in two layers:  MTCP handles a single
multi-threaded process.  There is a separate library mtcp.so.
The higher layer (redundantly again called DMTCP) is implemented
in dmtcphijack.so.  In a _very_ rough kind of way, MTCP does a lot
of what would be done within kernel C/R.  But the higher DMTCP layer
takes on some of those responsibilities in places.  For example,
DMTCP does part of analyzing the pseudo-ttys, since it's not always
easy to ensure that it's the controlling terminal of some process
that can checkpoint things in the MTCP layer.
    Beyond that, the wrappers around system calls are essentially
perfectly modular.  Some system calls go together to support a single
kernel feature, and those wrappers are kept in a common file.
    There are some very few program-specific workarounds.  If you look
at the main routine of dmtcp_checkpoint.cpp, you'll find most of them.
For example, if it's a setuid process, since we don't have root privilege,
we can't preload our dmtcphijack.so.  So, we copy the setuid process
to our own /tmp, and execute it there without setuid.  In the case
of screen, it wants to use /var/... (forgot the directory).  But screen
has an option to use a different directory.
    Similarly, if the distro is running an NSCD daemon, then gethostname
and similar calls go the NSCD daemon.  On restart, we have to re-initialize
communication with the NSCD daemon.

I have to run to do some other things.  But I'll check back on the
remaining (and any new) posts on this list later today.  Thanks very
much for the interesting discussion.  We've felt too isolated for too long.
But we didn't think we had something important enough before to disturb
the kernel developers with a discussion.  I hope DMTCP is starting to become
mature enough that this discussion can now benefit everybody.  We certainly
hope to learn a lot from it.  Thanks again.
							- Gene

====

On Thu, Nov 04, 2010 at 09:05:28AM +0100, Tejun Heo wrote:
> Hello,
> 
> On 11/04/2010 04:40 AM, Kapil Arya wrote:
> > (Sorry for resending the message; the last message contained some html
> > tags and was rejected by server)
> 
> And please also don't top-post.  Being the antisocial egomaniacs we
> are, people on lkml prefer to dissect the messages we're replying to,
> insert insulting comments right where they would be most effective and
> remove the passages which can't yield effective insults.  :-)
> 
> > In our personal view, a key difference between in-kernel and userland
> > approaches is the issue of security.  The Linux C/R developers state
> > the issue very well in their FAQ (question number 7):
> >> https://ckpt.wiki.kernel.org/index.php/Faq :
> >> 7. Can non-root users checkpoint/restart an application ?
> >>
> >> For now, only users with CAP_SYSADMIN privileges can C/R an
> >> application. This is to ensure that the checkpoint image has not been
> >> tampered with and will be treated like a loadable kernel-module.
> 
> That's an interesting point but I don't think it's a dealbreaker.
> Kernel CR is gonna require userland agent anyway and access control
> can be done there.  Being able to snapshot w/o root privieldge
> definitely is a plust but it's not like CR is gonna be deployed on
> majority of desktops and servers (if so, let's talk about it then).
> 
> > Strategies like these are easily handled in userspace.  We suspect
> > that while one may begin with a pure kernel approach, eventually,
> > one will still want to add a userland component to achieve this kind
> > of flexibility, just as BLCR has already done.
> 
> Yeap, agreed.  There gotta be user agents which can monitor and
> manipulate userland states.  It's a fundamentally nasty job, that of
> collecting and applying application-specific workarounds.  I've only
> glanced the dmtcp paper so my understanding is pretty superficial.
> With that in mind, can you please answer some of my curiosities?
> 
> * As Oren pointed out in another message, there are somethings which
>   could seem a bit too visible to the target application.  Like the
>   manager thread (is it visible to the application or is it hidden by
>   the libc wrapper?) and reserved signal.  Also, while it's true that
>   all programs should be ready to handle -EINTR failure from system
>   calls, it's something which is very difficult to verify and test and
>   could lead to once-in-a-blue-moon head scratchy kind of failures.
> 
>   I think most of those issues can be tackled with minor narrow-scoped
>   changes to the kernel.  Do you guys have things on mind which the
>   kernel can do to make these things more transparent or safer?
> 
> * The feats dmtcp achieves with its set of workarounds are impressive
>   but at the same time look quite hairy.  Christoph said that having a
>   standard userland C-R implementation would be quite useful and IMHO
>   it would be helpful in that direction if the implementation is
>   modularized enough so that the core functionality and the set of
>   workarounds can be easily separated.  Is it already so?
> 
> Thanks.
> 
> -- 
> tejun
