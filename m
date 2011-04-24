Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab1DXXrH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 19:47:07 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:12381 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757852Ab1DXXrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 19:47:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At4DAAmztE15LHHJgWdsb2JhbAClNhUBARYmJcNHDoVoBA
Date: Mon, 25 Apr 2011 09:46:55 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
Message-ID: <20110424234655.GC12436@dastard>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 06:57:16PM -0700, Christian Kujau wrote:
> Hi,
> 
> after the block layer regression[0] seemed to be fixed, the machine 
> appeared to be running fine. But after putting some disk I/O to the system 
> (PowerBook G4) it became unresponsive, I/O wait went up high and I could 
> see that the OOM killer was killing processes. Logging in via SSH was 
> sometimes possible, but the each session was killed shortly after, so I 
> could not do much.
> 
> The box finally rebooted itself, the logfile recorded something xfs 
> related in the first backtrace, hence I'm cc'ing the xfs list too:
> 
> du invoked oom-killer: gfp_mask=0x842d0, order=0, oom_adj=0, oom_score_adj=0
> Call Trace:
> [c0009ce4] show_stack+0x70/0x1bc (unreliable)
> [c008f508] T.528+0x74/0x1cc
> [c008f734] T.526+0xd4/0x2a0
> [c008fb7c] out_of_memory+0x27c/0x360
> [c0093b3c] __alloc_pages_nodemask+0x6f8/0x708
> [c00c00b4] new_slab+0x244/0x27c
> [c00c0620] T.879+0x1cc/0x37c
> [c00c08d0] kmem_cache_alloc+0x100/0x108
> [c01cb2b8] kmem_zone_alloc+0xa4/0x114
> [c01a7d58] xfs_inode_alloc+0x40/0x13c
> [c01a8218] xfs_iget+0x258/0x5a0
> [c01c922c] xfs_lookup+0xf8/0x114
> [c01d70b0] xfs_vn_lookup+0x5c/0xb0
> [c00d14c8] d_alloc_and_lookup+0x54/0x90
> [c00d1d4c] do_lookup+0x248/0x2bc
> [c00d33cc] path_lookupat+0xfc/0x8f4
> [c00d3bf8] do_path_lookup+0x34/0xac
> [c00d53e0] user_path_at+0x64/0xb4
> [c00ca638] vfs_fstatat+0x58/0xbc
> [c00ca6c0] sys_fstatat64+0x24/0x50
> [c00124f4] ret_from_syscall+0x0/0x38
>  --- Exception: c01 at 0xff4b050
>    LR = 0x10008cf8
> 
> 
> This is wih today's git (91e8549bde...); full log & .config on: 
> 
>   http://nerdbynature.de/bits/2.6.39-rc4/oom/

You memory is full of xfs inodes, and it doesn't appear that memory
reclaim has kicked in at all to free any - the numbers just keep
growing at 1-2000 inodes/s.

I'd say they are not being reclaimmmed because the VFS hasn't let go
of them yet. Can you also dump /proc/sys/fs/{dentry,inode}-state so
we can see if the VFS has released the inodes such that they can be
reclaimed by XFS?

BTW, what are your mount options? If it is the problem I suspect it
is, then using noatime with stop it from occurring....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
