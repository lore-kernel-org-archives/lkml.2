Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab0LHDcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 22:32:19 -0500
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:33593 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753395Ab0LHDcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 22:32:18 -0500
Date: Wed, 8 Dec 2010 14:32:12 +1100
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/46] rcu-walk and dcache scaling
Message-ID: <20101208033212.GF29333@dastard>
References: <cover.1290852958.git.npiggin@kernel.dk>
 <20101207215653.GA25864@dastard>
 <AANLkTinwDr7Xga_gk4vjZ2MgGYGXhxka2JvOAVwfvKQ8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinwDr7Xga_gk4vjZ2MgGYGXhxka2JvOAVwfvKQ8@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 12:47:42PM +1100, Nick Piggin wrote:
> On Wed, Dec 8, 2010 at 8:56 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Sat, Nov 27, 2010 at 09:15:58PM +1100, Nick Piggin wrote:
> >>
> >> git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git vfs-scale-working
> >>
> >> Here is an new set of vfs patches for review, not that there was much interest
> >> last time they were posted. It is structured like:
> >>
> >> * preparation patches
> >> * introduce new locks to take over dcache_lock, then remove it
> >> * cleaning up and reworking things for new locks
> >> * rcu-walk path walking
> >> * start on some fine grained locking steps
> >
> > Stress test doing:
> >
> >        single thread 50M inode create
> >        single thread rm -rf
> >        2-way 50M inode create
> >        2-way rm -rf
> >        4-way 50M inode create
> >        4-way rm -rf
> >        8-way 50M inode create
> >        8-way rm -rf
> >        8-way 250M inode create
> >        8-way rm -rf
> >
> > Failed about 5 minutes into the "4-way rm -rf" (~3 hours into the test)
> > with a CPU stuck spinning on here:
> >
> > [37372.084012] NMI backtrace for cpu 5
> > [37372.084012] CPU 5
> > [37372.084012] Modules linked in:
> > [37372.084012]
> > [37372.084012] Pid: 15214, comm: rm Not tainted 2.6.37-rc4-dgc+ #797 /Bochs
> > [37372.084012] RIP: 0010:[<ffffffff810643c4>]  [<ffffffff810643c4>] __ticket_spin_lock+0x14/0x20
> > [37372.084012] RSP: 0018:ffff880114643c98  EFLAGS: 00000213
> > [37372.084012] RAX: 0000000000008801 RBX: ffff8800687be6c0 RCX: ffff8800c4eb2688
> > [37372.084012] RDX: ffff880114643d38 RSI: ffff8800dfd4ea80 RDI: ffff880114643d14
> > [37372.084012] RBP: ffff880114643c98 R08: 0000000000000003 R09: 0000000000000000
> > [37372.084012] R10: 0000000000000000 R11: dead000000200200 R12: ffff880114643d14
> > [37372.084012] R13: ffff880114643cb8 R14: ffff880114643d38 R15: ffff8800687be71c
> > [37372.084012] FS:  00007fd6d7c93700(0000) GS:ffff8800dfd40000(0000) knlGS:0000000000000000
> > [37372.084012] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [37372.084012] CR2: 0000000000bbd108 CR3: 0000000107146000 CR4: 00000000000006e0
> > [37372.084012] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [37372.084012] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > [37372.084012] Process rm (pid: 15214, threadinfo ffff880114642000, task ffff88011b16f890)
> > [37372.084012] Stack:
> > [37372.084012]  ffff880114643ca8 ffffffff81ad044e ffff880114643cf8 ffffffff81167ae7
> > [37372.084012]  0000000000000000 ffff880114643d38 000000000000000e ffff88011901d800
> > [37372.084012]  ffff8800cdb7cf5c ffff88011901d8e0 0000000000000000 0000000000000000
> > [37372.084012] Call Trace:
> > [37372.084012]  [<ffffffff81ad044e>] _raw_spin_lock+0xe/0x20
> > [37372.084012]  [<ffffffff81167ae7>] shrink_dentry_list+0x47/0x370
> > [37372.084012]  [<ffffffff81167f5e>] __shrink_dcache_sb+0x14e/0x1e0
> > [37372.084012]  [<ffffffff81168456>] shrink_dcache_parent+0x276/0x2d0
> > [37372.084012]  [<ffffffff81ad044e>] ? _raw_spin_lock+0xe/0x20
> > [37372.084012]  [<ffffffff8115daa2>] dentry_unhash+0x42/0x80
> > [37372.084012]  [<ffffffff8115db48>] vfs_rmdir+0x68/0x100
> > [37372.084012]  [<ffffffff8115fd93>] do_rmdir+0x113/0x130
> > [37372.084012]  [<ffffffff8114f5ad>] ? filp_close+0x5d/0x90
> > [37372.084012]  [<ffffffff8115fde5>] sys_unlinkat+0x35/0x40
> > [37372.084012]  [<ffffffff8103a002>] system_call_fastpath+0x16/0x1b
> 
> OK good, with any luck, that's the same bug.
> 
> Is this XFS?

Yes.

> Is there any concurrent activity happening on the same dentries?

Not from an application perspective.

> Ie. are the rm -rf threads running on the same directories,

No, each thread operating on a different directory.

> or is there any reclaim happening in the background?

IIRC, kswapd was consuming about 5-10% of a CPU during parallel
unlink tests. Mainly reclaiming XFS inodes, I think, but there may
be dentry cache reclaim going as well.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
