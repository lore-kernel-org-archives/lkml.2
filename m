Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab1JTP4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 11:56:55 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58766 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710Ab1JTP4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 11:56:52 -0400
Date: Thu, 20 Oct 2011 08:56:45 -0700
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
Message-ID: <20111020155645.GV25124@google.com>
References: <20111014110416.552685686@openvz.org>
 <20111014110511.670174429@openvz.org>
 <20111014171033.GC4294@google.com>
 <20111014173304.GD4294@google.com>
 <4E9E9255.7090601@parallels.com>
 <20111019182228.GJ25124@google.com>
 <4E9FDCEF.5050008@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9FDCEF.5050008@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Oct 20, 2011 at 12:33:51PM +0400, Pavel Emelyanov wrote:
> > To shared kernel data structures.
> 
> Yet again - keeping shared stuctres self-consistent from which point of view? From
> the kernel's one - already handled with in-kernel locks. From the userspace one -
> every single kernel API provides a *way* to do things right, but doesn't provide
> the fool protection.

Sigh, no, in exec and related paths, the fact that all other threads
have been zapped are depended upon and the exec'ing task assumes
exclusive access to resources which in usual cases would require other
forms of exclusion.  Maybe there are not too many of them and things
can definitely be audited and updated but it is pretty intricate down
there and I just don't see good enough justification here.

> >> One of the abilities to restore multy-threaded task can be - clone threads from
> >> the userspace, then wait for them to prepare themselves the way they need it,
> >> then the threads go to sleep and the leader one calls execve. Thus the userspace
> >> state consistency is OK.
> > 
> > If you're gonna let userspace do it, why bother with in-kernel thing
> > at all?
> 
> Because userspace cannot just flush itself memory and registers and switch to new
> ones. Someone's help is required anyway. Did I misunderstood your question?

ptrace?

> >>> * It's still calling exec_mmap(), so the exec'ing thread will be on
> >>>   the new mm while other threads would still be on the old one.
> >>
> >> Why do you think it's a problem?
> > 
> > Ummm.... they aren't on the same address space?  How can that be okay?
> 
> The similar (but mirrored) thing with vfork - two tasks are on the same address space,
> but the child is supposed not to kill the parent's one. And this is OK for most of the
> apps using it.

I really don't know what to say here.  This is a clear bug.  You
should be switching mm's of other threads too if you want to go this
way.  vfork has have nothing to do with this.

> > It's not only wrong from CR POV.  The kernel disallows
> > CLONE_THREAD/SIGHAND w/o CLONE_VM and depend on that assumption,
> > you're breaking that.
> 
> OK, if this is the only problem we can keep the mm_struct itself just unmapping the
> vmas with unmap(0, 0xff...f) and repopulating one.

Yeah, and change another basic assumption without proper audit or
consideration for a feature which is borderline unnecessary?

> > IMHO, this is a fundamentally broken approach which isn't even
> > necessary.  So, FWIW, NACK.
> 
> It's a pity :( Anyway, as I stated above, we'll try to compare two
> real implementations, not abstract assumptions.

Given the state of this thread, I'm pretty skeptical this one can
survive but, hey, who knows?

Thank you.

-- 
tejun
