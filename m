Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab0E1Aax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 20:30:53 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:49784 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751905Ab0E1Aaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 20:30:52 -0400
Date: Fri, 28 May 2010 10:30:41 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, xfs@oss.sgi.com
Subject: Re: [PATCH 0/5] Per superblock shrinkers V2
Message-ID: <20100528003041.GR12087@dastard>
References: <1274777588-21494-1-git-send-email-david@fromorbit.com>
 <20100527133223.efa4740a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100527133223.efa4740a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 01:32:23PM -0700, Andrew Morton wrote:
> On Tue, 25 May 2010 18:53:03 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > This series reworks the filesystem shrinkers. We currently have a
> > set of issues with the current filesystem shrinkers:
> > 
> >         1. There is an dependency between dentry and inode cache
> >            shrinking that is only implicitly defined by the order of
> >            shrinker registration.
> >         2. The shrinkers need to walk the superblock list and pin
> >            the superblock to avoid unmount races with the sb going
> >            away.
> >         3. The dentry cache uses per-superblock LRUs and proportions
> >            reclaim between all the superblocks which means we are
> >            doing breadth based reclaim. This means we touch every
> >            superblock for every shrinker call, and may only reclaim
> >            a single dentry at a time from a given superblock.
> >         4. The inode cache has a global LRU, so it has different
> >            reclaim patterns to the dentry cache, despite the fact
> >            that the dentry cache is generally the only thing that
> >            pins inodes in memory.
> >         5. Filesystems need to register their own shrinkers for
> >            caches and can't co-ordinate them with the dentry and
> >            inode cache shrinkers.
> 
> Nice description, but...  it never actually told us what the benefit of
> the changes are. 

The first patch I wrote was a small patch to introduce context to
the shrinker callback and a per­XFS filesystem shrinker to solve OOM
probelms introduced by background reclaim of XFS inodes.  It was
simple, it worked but Nick refused to allow it because of #1 listed
above. He wanted some <handwaves> guarantee that context based
shrinkers would not break the implicit registration dependency
between the dentry and inode cache shrinkers.

We needed a fix for 2.6.34 for XFS, so I was forced to write a
global shrinker which is what introduced all the lockdep problems.
XFS does not have global inode caches, and the lock required to
manage the list of XFs mounts were what caused all the new lockdep
problems.  There's also other lockdep false positive problems w/ XFS
and shrinkers (e.g. iprune_sem and the unmount path) that need to be
fixed.

That's what this patchset tries to address. It results in simpler
code, less code, removal of implicit, undocumented dependencies,
less locking shenanegans, no superblock list traversals, provides
filesystems with hooks for cache reclaim without needing shrinker
registration and fixes all the all the false positive lockdep
problems XFS has with the current shrinker infrastructure.

If this is all too much, then I'm quite happy to go back to just the
context based shrinker patch and leave everything else alone - the
context based shrinkers are the change we *really* need.  Everything
else in this set of changes is just trying to address objections
raised (that I still don't really understand) against that simple
change.

> Presumably some undescribed workload had some
> undescribed user-visible problem.

$ find . -inum 11111

on a filesystem with more inodes in it than can be held in memory
caused OOM panics.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
