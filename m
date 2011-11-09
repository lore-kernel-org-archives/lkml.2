Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691Ab1KITQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 14:16:06 -0500
Received: from balrog.mythic-beasts.com ([93.93.130.6]:45571 "EHLO
	balrog.mythic-beasts.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab1KITQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 14:16:05 -0500
Date: Wed, 9 Nov 2011 19:11:55 +0000
From: Luis Henriques <henrix@camandro.org>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, stable@vger.kernel.org
Subject: Re: Linus GIT - INFO: possible circular locking dependency detected
Message-ID: <20111109191155.GB2490@hades>
References: <CAHFgRy8S0xLfhZxTUOEH5A0PL_Fb79-0-gmbQ=9h2D-xMqt1hA@mail.gmail.com>
 <20111103204930.GA3599@hades>
 <20111105093146.GA14338@albatros>
 <20111108155716.33c04ce1.akpm@linux-foundation.org>
 <20111109001723.GA26225@kroah.com>
 <20111109004013.GA30562@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111109004013.GA30562@kroah.com>
X-BlackCat-Spam-Score: -13
X-Mythic-Debug: Threshold =  On = 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Nov 08, 2011 at 04:40:13PM -0800, Greg KH wrote:
> > It's just me.  And my script-bots, but they are all controlled by me in
> > the end.  Hopefully....
> > 
> > > that aa6afca5bca ("proc:
> > > fix races against execve() of /proc/PID/fd**") is known to cause a
> > > regression.
> > 
> > Ok, I'll go delete it from the stable queues for now.
> 
> Now removed.

I finally took another look at this, and although I'm far from being an
expert on these areas, I believe the trace information from lockdep may
actually be incorrect.  Here's what I'm getting:

[   12.948038] exe/36 is trying to acquire lock:
[   12.948038]  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff811b301e>] lock_trace+0x2e/0x80
[   12.948038] 
[   12.948038] but task is already holding lock:
[   12.948038]  (&sb->s_type->i_mutex_key#6){+.+.+.}, at: [<ffffffff8115f8b8>] vfs_readdir+0x78/0xd0
[   12.948038] 
[   12.948038] which lock already depends on the new lock.

So, sig->cred_guard_mutex is acquired (in lock_trace) after
sb->s_type->i_mutex_key (in vfs_readdir).  Now, take a look at the traces:

[   12.948038] -> #1 (&sb->s_type->i_mutex_key#6){+.+.+.}:
[   12.948038]        [<ffffffff81092e4f>] lock_acquire+0xaf/0x1f0
[   12.948038]        [<ffffffff8135b2a5>] __mutex_lock_common+0x65/0x4d0
[   12.948038]        [<ffffffff8135b72b>] mutex_lock_nested+0x1b/0x20
[   12.948038]        [<ffffffff81158c0a>] do_lookup+0x28a/0x3b0
[   12.948038]        [<ffffffff8115929f>] link_path_walk+0x12f/0x870
[   12.948038]        [<ffffffff8115b0ab>] path_openat+0xbb/0x380
[   12.948038]        [<ffffffff8115b3b2>] do_filp_open+0x42/0xa0
[   12.948038]        [<ffffffff81152cb2>] open_exec+0x32/0xf0
[   12.948038]        [<ffffffff81153dd7>] do_execve_common.clone.32+0x137/0x330
[   12.948038]        [<ffffffff81153feb>] do_execve+0x1b/0x20
[   12.948038]        [<ffffffff8100c78a>] sys_execve+0x4a/0x80
[   12.948038]        [<ffffffff8135ed1c>] stub_execve+0x6c/0xc0
[   12.948038] 
[   12.948038] -> #0 (&sig->cred_guard_mutex){+.+.+.}:
[   12.948038]        [<ffffffff8108ff9f>] __lock_acquire+0x17bf/0x2020
[   12.948038]        [<ffffffff81092e4f>] lock_acquire+0xaf/0x1f0
[   12.948038]        [<ffffffff8135b2a5>] __mutex_lock_common+0x65/0x4d0
[   12.948038]        [<ffffffff8135b76b>] mutex_lock_killable_nested+0x1b/0x20
[   12.948038]        [<ffffffff811b301e>] lock_trace+0x2e/0x80
[   12.948038]        [<ffffffff811b73ab>] proc_readfd_common+0x5b/0x4b0
[   12.948038]        [<ffffffff811b7835>] proc_readfd+0x15/0x20
[   12.948038]        [<ffffffff8115f8f0>] vfs_readdir+0xb0/0xd0
[   12.948038]        [<ffffffff8115fa09>] sys_getdents+0x89/0x100
[   12.948038]        [<ffffffff8135e8c2>] system_call_fastpath+0x16/0x1b

sb->s_type->i_mutex_key is shown as being acquired in the execve path,
which seems to be wrong -- it was acquired in the vfs_readdir (on the 2nd
trace).

This means that the initial analysis from Vasiliy is incorrect, as he
assumed the execve path.  Or Am I interpreting this log incorrectly?
(Probably I am...).

Anyway, if my analysis is correct, replacing the lock_trace by a simple
ptrace_may_access() should be enough.  Something like:

-       if (lock_trace(p))
+       if (!ptrace_may_access(p, PTRACE_MODE_ATTACH))
                goto out;

Obviously, the unlock_trace() should be removed as well... But I may be
missing other cases where the lock_trace is actually required.

BTW, I get this log simply by running:

# ls /proc/1/fd

Just my 2 cents...

Cheers,
--
Luis Henriques
