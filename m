Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab0HBIYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 04:24:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38357 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab0HBIYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 04:24:32 -0400
Date: Mon, 2 Aug 2010 04:24:28 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.35
Message-ID: <20100802082428.GA23135@infradead.org>
References: <AANLkTim8FALeVG+NPLNLEQChu=dPD=GHSpnxmZHYgsNx@mail.gmail.com>
 <20100802023322.GA19164@dastard>
 <AANLkTint_s6h_EC7mDiPsyxr=C0GSrnrgJYkCCU7JEtN@mail.gmail.com>
 <20100802055834.GB19164@dastard>
 <20100802075537.GC7841@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802075537.GC7841@amd>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 05:55:37PM +1000, Nick Piggin wrote:
> I hate to say but I would like to see it mature for another release. It
> should also clash a bit with Al's recent inode work that he'll want to
> push.
> 
> What I can do is send some of the ground work patches this time around,
> put the tree into linux-next, and put reviewers on notice.
> 
> I think it is all conceptually sound, but it will inevitably have some
> bugs left to shake out, and things to be fixed on the review side. I
> don't anticipate a problem that could not be fixed in the release cycle,
> but I think aiming for post 2.6.36 is a bit fairer for vfs guys,
> honestly. LSF is next week too, so most of them will be busy with travel
> and such. But I do hope to discuss the vfs-scale patches there.

What I'm most concerned bit merging everything in one go.  It's a huge
series and I'd rather see it start going in in batches over multiple
kernel releases.

Things like the fs_struct spinlock and some other preparatory patches
should be ver easily to do for 2.6.36.  Scaling the files and vfsmount
locks should also be easily doable, but we need to sort out the struct
file growth in the later.  We really can't grow struct file by two
pointers as that would have devasting effects on various workloads.

What follows after that is the dcache_lock scaling which to seems the
most immature bit of the series, and the one that showed by far the
most problems in -RT.  I'm very much dead set against merging that in
.36.  I'd much rather see the inode_lock scaling or the lockless path
walk going in before, but I haven't checked how complicated the
reordering would be.  The lockless path walk also is only rather
theoretically useful until we do ACL checks lockless as we're having
ACLs enabled pretty much everywhere at least in the distros.

The per-zone shrinkers are another thing that's not directly related,
I think they need a lot more discussion with the VM folks, and
integrating with Dave's work in that area.



