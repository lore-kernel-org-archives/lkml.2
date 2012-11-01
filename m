Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762453Ab2KAWci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 18:32:38 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:57637 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762214Ab2KAWcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 18:32:36 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhoYAKX3klB5LGX0/2dsb2JhbABEhS64EIRwAoEEgQmCHgEBBScTHCMQCAMOCi4UJQMhE4gFDL0hFItnJ4FhhDMDlXeBHI8ogwOBSQ
Date: Fri, 2 Nov 2012 09:32:33 +1100
From: Dave Chinner <david@fromorbit.com>
To: Ben Myers <bpm@sgi.com>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: Hang in XFS reclaim on 3.7.0-rc3
Message-ID: <20121101223233.GR29378@dastard>
References: <CAPVoSvSM9=hictqwT2rzZA-fU_XSwd-_FRzW_J+HQYj7iohTWQ@mail.gmail.com>
 <20121029222613.GU29378@dastard>
 <20121101213010.GD9783@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121101213010.GD9783@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 04:30:10PM -0500, Ben Myers wrote:
> Hi Dave,
> 
> On Tue, Oct 30, 2012 at 09:26:13AM +1100, Dave Chinner wrote:
> > On Mon, Oct 29, 2012 at 09:03:15PM +0100, Torsten Kaiser wrote:
> > > After experiencing a hang of all IO yesterday (
> > > http://marc.info/?l=linux-kernel&m=135142236520624&w=2 ), I turned on
> > > LOCKDEP after upgrading to -rc3.
> > > 
> > > I then tried to replicate the load that hung yesterday and got the
> > > following lockdep report, implicating XFS instead of by stacking swap
> > > onto dm-crypt and md.
> > > 
> > > [ 2844.971913]
> > > [ 2844.971920] =================================
> > > [ 2844.971921] [ INFO: inconsistent lock state ]
> > > [ 2844.971924] 3.7.0-rc3 #1 Not tainted
> > > [ 2844.971925] ---------------------------------
> > > [ 2844.971927] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
> > > [ 2844.971929] kswapd0/725 [HC0[0]:SC0[0]:HE1:SE1] takes:
> > > [ 2844.971931] (&(&ip->i_lock)->mr_lock){++++?.}, at: [<ffffffff811e7ef4>] xfs_ilock+0x84/0xb0
> > > [ 2844.971941] {RECLAIM_FS-ON-W} state was registered at:
> > > [ 2844.971942]   [<ffffffff8108137e>] mark_held_locks+0x7e/0x130
> > > [ 2844.971947]   [<ffffffff81081a63>] lockdep_trace_alloc+0x63/0xc0
> > > [ 2844.971949]   [<ffffffff810e9dd5>] kmem_cache_alloc+0x35/0xe0
> > > [ 2844.971952]   [<ffffffff810dba31>] vm_map_ram+0x271/0x770
> > > [ 2844.971955]   [<ffffffff811e10a6>] _xfs_buf_map_pages+0x46/0xe0
.....
> > We shouldn't be mapping pages there. See if the patch below fixes
> > it.
> > 
> > Fundamentally, though, the lockdep warning has come about because
> > vm_map_ram is doing a GFP_KERNEL allocation when we need it to be
> > doing GFP_NOFS - we are within a transaction here, so memory reclaim
> > is not allowed to recurse back into the filesystem.
> > 
> > mm-folk: can we please get this vmalloc/gfp_flags passing API
> > fixed once and for all? This is the fourth time in the last month or
> > so that I've seen XFS bug reports with silent hangs and associated
> > lockdep output that implicate GFP_KERNEL allocations from vm_map_ram
> > in GFP_NOFS conditions as the potential cause....
> > 
> > xfs: don't vmap inode cluster buffers during free
> 
> Could you write up a little more background for the commit message?

Sure, that was just a test patch and often I don't bother putting a
detailed description in them until I know they fix the problem. My
current tree has:

xfs: don't vmap inode cluster buffers during free

Inode buffers do not need to be mapped as inodes are read or written
directly from/to the pages underlying the buffer. This fixes a
regression introduced by commit 611c994 ("xfs: make XBF_MAPPED the
default behaviour").

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
