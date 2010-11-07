Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab0KGStj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 13:49:39 -0500
Received: from amber.ccs.neu.edu ([129.10.116.51]:52374 "EHLO
	amber.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab0KGSti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 13:49:38 -0500
Date: Sun, 7 Nov 2010 13:49:27 -0500
From: Gene Cooperman <gene@ccs.neu.edu>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Gene Cooperman <gene@ccs.neu.edu>, Matt Helsley <matthltc@us.ibm.com>,
        Tejun Heo <tj@kernel.org>, Kapil Arya <kapil@ccs.neu.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
Message-ID: <20101107184927.GF31077@sundance.ccs.neu.edu>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>
 <4CD08419.5050803@kernel.org>
 <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com>
 <4CD26948.7050009@kernel.org>
 <20101104164401.GC10656@sundance.ccs.neu.edu>
 <4CD3CE29.2010105@kernel.org>
 <20101106053204.GB12449@count0.beaverton.ibm.com>
 <20101106204008.GA31077@sundance.ccs.neu.edu>
 <4CD5D99A.8000402@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD5D99A.8000402@cs.columbia.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 2.  Directly checkpointing a single X11 app
> >   [ Our own preferred approach, as opposed to checkpinting an entire desktop;
> >     This is easy, but we just haven't had the time lately.  I estimate
> >     the time to do it is about one person working straight out for two weeks
> >     or so.  But who has that much spare time.  :-)  ]
> 
> Hmmm... that sounds pretty fast .. given that you will need to
> save and reconstruct an arbitrary state kept by the X server...
> 
> More importantly, this line of thought was brought up in this
> thread multiple times, yet in a very misleading way.
> 
> The question is _not_ whether one can do c/r of a single apps
> without their surrounding environment. The answer for that is
> simple: it _is_ possible either using proper (and more likely
> per-app) wrappers, or by adapting the apps to tolerate that.
> 
> The above is entirely orthogonal to whether the c/r is in kernel
> or in userspace.

These are all good points by Oren.  It's not about in-kernel _or_ userland.
There are opportunities to use both -- each where it is strongest,
and I'm looking forward to that discussion with Oren.  I do think
that reconstructing the state of the X server is not as hard as Oren
paints it, but let's talk about that in the discussion.

> But that is independent of where you do c/r !  The issue on the
> table is whether the _core_ c/r should go in kernel or userspace.
> Those wrappers of dmtcp are great and will be useful with either
> approach.
> 
> So let us please _not_ argue that only one approach can c/r apps
> or processes out of their context. That is inaccurate and misleading.
> 
> And while one may argue that one use-case is more important than
> another, let us also _not_ dismiss such use cases (as was argued
> by others in this thread). For example, c/r of a full desktop
> session in VNC, or a VPS, is a perfectly valid and useful case.

I agree.  I apologize if I was too argumentative in the previous post.

> FYI, inotify() is a syscall and does not require root privileges. It's
> a kernel API used to get notifications of changes to file system inodes.
> for instance, it's commonly used by file managers (e.g. nautilus).

Yes, I know.  I was writing too fast in trying to respond to all the points.
Matt had asked how we would handle inotify(), but I was getting swamped
by all the questions.  There is a virtualization approach to inotify in which
one puts wrappers around inotify_add_watch(), inotify_rm_watch() and
friends in the same way as we wrap open() and could wrap close().
One would then need to wrap read() (which we don't like to do, just
in case it could add significant overhead).  But if we consider kernel
and userland virtualization together, then something similar to  TIOCSTI
for ioctl would allow us to avoid wrapping read().

> Back to the point argued above, "virtualization around a single app"
> are the wrappers that allow to take an app out of context and sort of
> implant it in another context. It's a very desirable feature, but
> orthogonal to the c/r technique.

I agree.  I look forward to the discussion where we can put all this
into a single perspective.

> Hmm... can you really c/r from userspace a process that was, at
> checkpoint time, in a ptrace-stopped state at an arbitrary kernel
> ptrace-hook ?  I strongly suspect the answer is "no", definitely
> not unless you also virtualize and replicate the entire in-kernel
> ptrace functionality in userspace,

Let's try it and see.  If you write a program, we'll try it out in
DMTCP (unstable branch) and see.  So far, checkpointing gdb sessions
has worked well for us.  If there is something we don't cover, it will
be helpful to both of us to find it, and analyze that case.

> I beg to differ. Virtualization that relies on a "black box" (in
> the sense that it works around an API but not integrated into the
> API, like dmtcp does) has been shown time and again to be racy. The
> common term is TOCTTOU races. See "Traps and Pitfalls: Practical
> Problems in System Call Interposition Based Security Tools" for
> example (http://www.stanford.edu/~talg/papers/traps/abstract.html),
> and many others that cite (or not) this work.
> 
> I believe the way dmtcp virtualizes the pid-namespace makes no
> exception to this rule.

Another excellent topic for discussion.  I look forward to the discussion.
Thanks for the advance pointer for us to take a look at.

> Yes, let's look into the goals:
> 
> dmtcp aims to provide c/r for a certain class of applications and
> envrionments. For this dmtcp offers:
> (1) userspace c/r engine and c/r-oriented virtualization, and
> (2) userspace (often per-application or per-environment) wrappers.
> 
> linux-cr provides (3) generic, transparent  kernel-based c/r engine
> (yes, transparent! without userspace virtualization, LD_PRELOAD
> tricks, or collaboration of the developer/application/user).
> 
> So let's compare apples to apples - let's compare (3) to (1).
> All of the work related to item (2) applies to and benefits
> from either.
> 
> (Now looking forward to discuss more details with dmtcp team on
> Tuesday and on :)

Also a very good point above, and I agree.  The offline discussion should
be a better forum for putting this all into perspective.

Thanks again for your thoughtful response,
- Gene
