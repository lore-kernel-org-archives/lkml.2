Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab2LKWbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:31:13 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:43416 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753570Ab2LKWbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:31:12 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmMOAPayx1B5LO66/2dsb2JhbABFhU6ycYYQF3OCHgEBBScTHDMIAxQELhQlAyEBEogQu24UjDaDYmEDlgaQSYMH
Date: Wed, 12 Dec 2012 09:31:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: 3.7 XFS lockdep trace
Message-ID: <20121211223109.GD16353@dastard>
References: <20121211154207.GA12771@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121211154207.GA12771@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 10:42:07AM -0500, Dave Jones wrote:
> This says rc8+, but it's just missing the Makefile change, so it's still there in 3.7
> Curious that firefox was the process mentioned here, as ~/.mozilla isn't on xfs.
> My only xfs partition is /data holding a kernel source tree & .ccache

The fs freeze lockdep annotations have caused some ....  interesting
lockdep reports.....

> [30557.776326] 3 locks on stack by firefox/17386:
> [30557.776571]  #0: blocked:  (&mm->mmap_sem){++++++}, instance: ffff8800a823c308, at: [<ffffffff816ac2b3>] __do_page_fault+0x103/0x4f0
> [30557.777276]  #1: blocked:  (shrinker_rwsem){++++..}, instance: ffffffff81c49de0, at: [<ffffffff81169ccc>] shrink_slab+0x3c/0x510
> [30557.777962]  #2: blocked:  (&type->s_umount_key#42){.+.+.+}, instance: ffff8800c4ed5730, at: [<ffffffff811c24c4>] grab_super_passive+0x44/0x90

There's no filesystem specific locks here, and it indicates that
the shrinkers are involved, so firefox can indeed touch the XFS
filesystem directly this way...

> [30557.789160]     RECLAIM_FS-ON-W at:
> [30557.789362]                          [<ffffffff810c8042>] mark_held_locks+0xb2/0x130
> [30557.789792]                          [<ffffffff810c8795>] lockdep_trace_alloc+0x75/0xd0
> [30557.790241]                          [<ffffffff811af81a>] kmem_cache_alloc_node_trace+0x3a/0x2e0
> [30557.790740]                          [<ffffffff81192242>] vm_map_ram+0x2a2/0x7f0
> [30557.791161]                          [<ffffffffa052a4c3>] _xfs_buf_map_pages+0x73/0x130 [xfs]
> [30557.791646]                          [<ffffffffa052baeb>] xfs_buf_get_map+0x15b/0x270 [xfs]
> [30557.792114]                          [<ffffffffa05ada19>] xfs_trans_get_buf_map+0x1d9/0x3b0 [xfs]
> [30557.792615]                          [<ffffffffa0589f04>] xfs_ialloc_inode_init+0xe4/0x1f0 [xfs]

Oh, that's already fixed in the 3.8- queue.

$ gl -n 1 7c4cebe
commit 7c4cebe8e02dd0b0e655605442bbe9268db9ed4f
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Nov 23 14:24:23 2012 +1100

    xfs: inode allocation should use unmapped buffers.
    
    Inode buffers do not need to be mapped as inodes are read or written
    directly from/to the pages underlying the buffer. This fixes a
    regression introduced by commit 611c994 ("xfs: make XBF_MAPPED the
    default behaviour").
....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
