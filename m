Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab0KFWmD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 18:42:03 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:63174 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab0KFWmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 18:42:01 -0400
Message-ID: <4CD5D99A.8000402@cs.columbia.edu>
Date: Sat, 06 Nov 2010 18:41:30 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Gene Cooperman <gene@ccs.neu.edu>
CC: Matt Helsley <matthltc@us.ibm.com>, Tejun Heo <tj@kernel.org>,
        Kapil Arya <kapil@ccs.neu.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu> <4CD08419.5050803@kernel.org> <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com> <4CD26948.7050009@kernel.org> <20101104164401.GC10656@sundance.ccs.neu.edu> <4CD3CE29.2010105@kernel.org> <20101106053204.GB12449@count0.beaverton.ibm.com> <20101106204008.GA31077@sundance.ccs.neu.edu>
In-Reply-To: <20101106204008.GA31077@sundance.ccs.neu.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/06/2010 04:40 PM, Gene Cooperman wrote:
> By the way, Oren, Kapil and I are hoping to find time in the next few
> days to talk offline.  Apparently the Linux C/R and DMTCP had continued

That was my understanding too. However, I also felt that I'd better
clarify a key point first.

> for some years unaware of each other.  We appreciate that a huge amount
> of work has gone into both of the approaches, and so we'd like to reap
> the benefit of the experiences of the two approaches.  We're still learning
> more about each others' approaches.  Below, I'll try to answer as best
> I can the questions that Matt brings up.  Since Matt brings up _lots_
> of questions, and I add my own topics, I thought it best to add a table
> of contents to this e-mail.  For each topic, you'll see a discussion
> inline below.

[snip]

> 2.  Directly checkpointing a single X11 app
>   [ Our own preferred approach, as opposed to checkpinting an entire desktop;
>     This is easy, but we just haven't had the time lately.  I estimate
>     the time to do it is about one person working straight out for two weeks
>     or so.  But who has that much spare time.  :-)  ]

Hmmm... that sounds pretty fast .. given that you will need to
save and reconstruct an arbitrary state kept by the X server...

More importantly, this line of thought was brought up in this
thread multiple times, yet in a very misleading way.

The question is _not_ whether one can do c/r of a single apps
without their surrounding environment. The answer for that is
simple: it _is_ possible either using proper (and more likely
per-app) wrappers, or by adapting the apps to tolerate that.

The above is entirely orthogonal to whether the c/r is in kernel
or in userspace.

So for terminal based apps, one can use 'screen'. For individual X
apps, one can use a light VNC server with proper embedding in the
desktop (e.g. metavnc). Or you could use screen-for-X like 'xpra'.
Or you can write wrappers (messy or hairy or not) that will try to
do that, or you could modify the apps. IIUC, dmtcp chose the way
of the wrappers.

But that is independent of where you do c/r !  The issue on the
table is whether the _core_ c/r should go in kernel or userspace.
Those wrappers of dmtcp are great and will be useful with either
approach.

So let us please _not_ argue that only one approach can c/r apps
or processes out of their context. That is inaccurate and misleading.

And while one may argue that one use-case is more important than
another, let us also _not_ dismiss such use cases (as was argued
by others in this thread). For example, c/r of a full desktop
session in VNC, or a VPS, is a perfectly valid and useful case.

[snip]

> 4. inotify and NSCD
>   [ We try to virtualize a single app, instead of also checkpointing
>     inotify and NSCD themselves.  It would have been interesting to consider
>     checkpointing them in userland, but that would require root privilege,
>     and one core design principle we have, is that all of our C/R is
>     completely unprivileged.  So, we would see distributing DMTCP as
>     a package in a distro, and letting individual users decide for
>     what computation they might want to use it. ]

FYI, inotify() is a syscall and does not require root privileges. It's
a kernel API used to get notifications of changes to file system inodes.
for instance, it's commonly used by file managers (e.g. nautilus).

> 
> 5. Checkpointing DRM state and other graphics chip state
>   [ It comes down to virtualization around a single app versus checkpointing
>     _all_ of X. --- Two different approaches. ]
> 
> 6. kernel c/r of input devices might be alot easier
>   [ We agree with you.  By virtualizing around a single app, we hope
>     to avoid this issue. ]

Back to the point argued above, "virtualization around a single app"
are the wrappers that allow to take an app out of context and sort of
implant it in another context. It's a very desirable feature, but
orthogonal to the c/r technique.

> 
> 7. C/R for link/open/rm/open/write/read puzzle
> 
> 8.  What happens if the DMTCP coordinator ( checkpoint control process) dies?
>   [ The same thing that happens if a user process dies.  We kill the whole
>     computation, and restart.  At restart, we use a new coordinator.
>     Coordinators are stateless. ]
> 
> 9. We try to hide the reserved signal (SIGUSR2 by default) ...
>   [ Matt says this is a mess, but we note that glibc does this too. ]
> 
> 10. checkpoint, gdb and PTRACE_ATTACH
>   [ DMTCP does not use PTRACE_ATTACH in its implementation.  So, we can
>     and do fully support user processes that use PTRACE_ATTACH. ]

Hmm... can you really c/r from userspace a process that was, at
checkpoint time, in a ptrace-stopped state at an arbitrary kernel
ptrace-hook ?  I strongly suspect the answer is "no", definitely
not unless you also virtualize and replicate the entire in-kernel
ptrace functionality in userspace,

> 
> 11. DMTCP, ABIs, can there be a race condition between the ckpt thread and
>   user threads of an app?
>   [ DMTCP doesn't introduce any new ABIs.  There may be a misconception here.
>     If we can talk at length off-line, I could explain more about
>     the DMTCP design.  Inline, I explain why race conditions should
>     not be an issue. ]

I beg to differ. Virtualization that relies on a "black box" (in
the sense that it works around an API but not integrated into the
API, like dmtcp does) has been shown time and again to be racy. The
common term is TOCTTOU races. See "Traps and Pitfalls: Practical
Problems in System Call Interposition Based Security Tools" for
example (http://www.stanford.edu/~talg/papers/traps/abstract.html),
and many others that cite (or not) this work.

I believe the way dmtcp virtualizes the pid-namespace makes no
exception to this rule.

[snip]

> 
> I think we would need to elaborate with individual cases.  But as I wrote
> above, DMTCP and Linux C/R started with two different philosophies.
> I'm not sure if you fully understood the DMTCP goals and philosophy yet,
> but I hope my comments above help clarify it.

Yes, let's look into the goals:

dmtcp aims to provide c/r for a certain class of applications and
envrionments. For this dmtcp offers:
(1) userspace c/r engine and c/r-oriented virtualization, and
(2) userspace (often per-application or per-environment) wrappers.

linux-cr provides (3) generic, transparent  kernel-based c/r engine
(yes, transparent! without userspace virtualization, LD_PRELOAD
tricks, or collaboration of the developer/application/user).

So let's compare apples to apples - let's compare (3) to (1).
All of the work related to item (2) applies to and benefits
from either.

(Now looking forward to discuss more details with dmtcp team on
Tuesday and on :)

Thanks,

Oren.
