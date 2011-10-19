Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab1JSSWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 14:22:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59089 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab1JSSWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 14:22:36 -0400
Date: Wed, 19 Oct 2011 11:22:28 -0700
From: Tejun Heo <tj@kernel.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrey Vagin <avagin@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [patch 5/5] elf: Add support for loading ET_CKPT files
Message-ID: <20111019182228.GJ25124@google.com>
References: <20111014110416.552685686@openvz.org>
 <20111014110511.670174429@openvz.org>
 <20111014171033.GC4294@google.com>
 <20111014173304.GD4294@google.com>
 <4E9E9255.7090601@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9E9255.7090601@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Pavel.

On Wed, Oct 19, 2011 at 01:03:17PM +0400, Pavel Emelyanov wrote:
> > I don't think this is a good idea.  We already have most of interface
> > necessary for restoring task state and there's no need to put it into
> > the kernel as one piece.  If there's something which can't be done
> > from userland using existing interfaces, let's please discuss what
> > they are and whether they can be resolved differently first.
> 
> The rest API we will require will look too special-purpose (like Cyrill
> mentioned the ability to set the mm's fields such as start_code, etc).

I find that quite difficult to agree with.  We're talking about some
minor additions to prctl against updating exec path to do something it
was never designed to do + new binary format.

> Besides, putting a parasite code to restore the memory state will drive
> us into certain limitations. E.g. - what address range in the target task
> address space should the parasite occupy? What if we fail in finding one,
> how should we act next?

How is that different from snapshotting time?  Unless the address is
completely packed, I can't see how that can be a problem.  In the
worst case, you can use the parasite to map what's not overlapping and
then let the ptracer restore the overlapping areas after parasite is
done.

> > The exec path is very intricate as it is and it would be very easy to
> > introduce security or other bugs by altering its basic behavior.  
> 
> Can you elaborate a bit more on this? "Other" bugs can be introduced by
> any piece of code injected into the kernel, but what about security?

exec is a pretty important security boundary.  A lot of resources (fd,
VMAs, credentails) have security-sensitive policies forced across exec
boundary and there are enough places which depends on the all
resetting property of exec (e.g. no other user of thread-group wide
resources).

> > exec presumes destruction of (most of) the current process and all its
> > other threads and replacing them w/ fresh states from an executable.
> 
> This is *exactly* what is expected from the restoration process.

Umm.... so why does the patch skip zapping?  And if you are gonna be
zapping, how are you gonna do multiple threads?

> > I see that you removed zapping to allow restoring multi-threaded
> > process, which seems quite scary to me.  It might be okay, I don't
> > know, but IMHO it just isn't a very good idea to introduce such
> > variation to basic exec behavior for this rather narrow use case.
> 
> Why? Can you describe your thought on this more, maybe I'm really missing
> smth important.

Because it breaks one of the very basic assumptions - there are no
other tasks in the thread group and thus resources usually shared
among threadgroup can be assumed to be exclusive.

> > In addition, leaving it alone doesn't really solve multi-threaded
> > restoring, does it?  
> 
> So your main concern is about multy-threaded tasks, right? I think we can
> prepare the exec handler capable to show how this can look like.

I'm strongly against that direction regardless of implementation
details.

> > The current code doesn't seem to be doing anything but if you're gonna add
> > it later, how are you gonna synchronize other threads?
> 
> Synchronize what? If we're providing to a userspace a way to put things right
> it's up to userspace to use it correctly. Like we saw this wit pid namespaces -
> there's are plenty of ways how to kill the app with CLONE_NEWPID clone flag, but
> the intention of one is not the be 100% fool-proof, but to provide an ability
> to do what userspace need.

To shared kernel data structures.

> One of the abilities to restore multy-threaded task can be - clone threads from
> the userspace, then wait for them to prepare themselves the way they need it,
> then the threads go to sleep and the leader one calls execve. Thus the userspace
> state consistency is OK.

If you're gonna let userspace do it, why bother with in-kernel thing
at all?

> > * It's still calling exec_mmap(), so the exec'ing thread will be on
> >   the new mm while other threads would still be on the old one.
> 
> Why do you think it's a problem?

Ummm.... they aren't on the same address space?  How can that be okay?
It's not only wrong from CR POV.  The kernel disallows
CLONE_THREAD/SIGHAND w/o CLONE_VM and depend on that assumption,
you're breaking that.

> > * There are operations which assume that the calling task is
> >   de-threaded and thus has exclusive access to data structures which
> >   can be shared among the thread group (e.g. signal struct).  How are
> >   accesses to them synchronized?
> 
> If we're talking about keeping the userspace state solid, then stopping the
> other threads solves this.

Again, there are kernel exclusivity assumptions.

> That's a pity. As I stated above, we'll try to demonstrate the exec handler
> capable to restore the multy-threaded APP and send the 2nd RFC. Can you answer
> my questions above so we keep your concerns in mind while doing this, please.

IMHO, this is a fundamentally broken approach which isn't even
necessary.  So, FWIW, NACK.

Thank you.

-- 
tejun
