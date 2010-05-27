Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab0E0XBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 19:01:18 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:60045 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757137Ab0E0XBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 19:01:16 -0400
Date: Fri, 28 May 2010 09:01:04 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, xfs@oss.sgi.com
Subject: Re: [PATCH 3/5] superblock: introduce per-sb cache shrinker
 infrastructure
Message-ID: <20100527230104.GQ12087@dastard>
References: <1274777588-21494-1-git-send-email-david@fromorbit.com>
 <1274777588-21494-4-git-send-email-david@fromorbit.com>
 <20100527133234.e0814239.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527133234.e0814239.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 01:32:34PM -0700, Andrew Morton wrote:
> On Tue, 25 May 2010 18:53:06 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > With context based shrinkers, we can implement a per-superblock
> > shrinker that shrinks the caches attached to the superblock. We
> > currently have global shrinkers for the inode and dentry caches that
> > split up into per-superblock operations via a coarse proportioning
> > method that does not batch very well.  The global shrinkers also
> > have a dependency - dentries pin inodes - so we have to be very
> > careful about how we register the global shrinkers so that the
> > implicit call order is always correct.
> > 
> > With a per-sb shrinker callout, we can encode this dependency
> > directly into the per-sb shrinker, hence avoiding the need for
> > strictly ordering shrinker registrations. We also have no need for
> > any proportioning code for the shrinker subsystem already provides
> > this functionality across all shrinkers. Allowing the shrinker to
> > operate on a single superblock at a time means that we do less
> > superblock list traversals and locking and reclaim should batch more
> > effectively. This should result in less CPU overhead for reclaim and
> > potentially faster reclaim of items from each filesystem.
> > 
> 
> I go all tingly when a changelog contains the word "should".
> 
> OK, it _should_ do X.  But _does_ it actually do X?

As i said to Nick - the tests I ran showed an average improvement of
5% but the accuracy of the benchmark was +/-10%. Hence it's hard to
draw any conclusive results from that. It appears to be slightly
faster on an otherwise idle system, but...

As it is, the XFS shrinker that gets integrated into this structure
in a later patch peaks at a higher rate - 150k inodes/s vs 90k
inodes/s with the current shrinker - but still it's hard to quantify
qualitatively. I'm going to run more benchmarks to try to get better
numbers.

> >  fs/super.c         |   53 +++++++++++++++++++++
> >  include/linux/fs.h |    7 +++
> >  4 files changed, 88 insertions(+), 214 deletions(-)
> > 
> > diff --git a/fs/dcache.c b/fs/dcache.c
> > index dba6b6d..d7bd781 100644
> > --- a/fs/dcache.c
> > +++ b/fs/dcache.c
> > @@ -456,21 +456,16 @@ static void prune_one_dentry(struct dentry * dentry)
> >   * which flags are set. This means we don't need to maintain multiple
> >   * similar copies of this loop.
> >   */
> > -static void __shrink_dcache_sb(struct super_block *sb, int *count, int flags)
> > +static void __shrink_dcache_sb(struct super_block *sb, int count, int flags)
> 
> Forgot to update the kerneldoc description of `count'.

Will fix.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
