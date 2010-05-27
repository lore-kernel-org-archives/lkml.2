Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933499Ab0E0EXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 00:23:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35041 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab0E0EXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 00:23:37 -0400
Date: Thu, 27 May 2010 14:23:32 +1000
From: Nick Piggin <npiggin@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, xfs@oss.sgi.com
Subject: Re: [PATCH 1/5] inode: Make unused inode LRU per superblock
Message-ID: <20100527042332.GH22536@laptop>
References: <1274777588-21494-1-git-send-email-david@fromorbit.com>
 <1274777588-21494-2-git-send-email-david@fromorbit.com>
 <20100526161732.GC22536@laptop>
 <20100526230129.GA1395@dastard>
 <20100527020445.GF22536@laptop>
 <20100527040210.GI12087@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100527040210.GI12087@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 02:02:10PM +1000, Dave Chinner wrote:
> On Thu, May 27, 2010 at 12:04:45PM +1000, Nick Piggin wrote:
> > On Thu, May 27, 2010 at 09:01:29AM +1000, Dave Chinner wrote:
> > > On Thu, May 27, 2010 at 02:17:33AM +1000, Nick Piggin wrote:
> > > > On Tue, May 25, 2010 at 06:53:04PM +1000, Dave Chinner wrote:
> > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > 
> > > > > The inode unused list is currently a global LRU. This does not match
> > > > > the other global filesystem cache - the dentry cache - which uses
> > > > > per-superblock LRU lists. Hence we have related filesystem object
> > > > > types using different LRU reclaimatin schemes.
> > > > 
> > > > Is this an improvement I wonder? The dcache is using per sb lists
> > > > because it specifically requires sb traversal.
> > > 
> > > Right - I originally implemented the per-sb dentry lists for
> > > scalability purposes. i.e. to avoid monopolising the dentry_lock
> > > during unmount looking for dentries on a specific sb and hanging the
> > > system for several minutes.
> > > 
> > > However, the reason for doing this to the inode cache is not for
> > > scalability, it's because we have a tight relationship between the
> > > dentry and inode cacheѕ. That is, reclaim from the dentry LRU grows
> > > the inode LRU.  Like the registration of the shrinkers, this is kind
> > > of an implicit, undocumented behavour of the current shrinker
> > > implemenation.
> > 
> > Right, that's why I wonder whether it is an improvement. It would
> > be interesting to see some tests (showing at least parity).
> 
> I've done some testing showing parity. They've been along the lines
> of:
> 	- populate cache with 1m dentries + inodes
> 	- run 'time echo 2 > /proc/sys/vm/drop_caches'
> 
> I've used different methods of populating the caches to have them
> non-sequential in the LRU (i.e. trigger fragmentation), have dirty
> backing inodes (e.g. the VFS inode clean, the xfs inode dirty
> because transactions haven't completed), etc.
> 
> The variation on the test is around +-10%, with the per-sb shrinkers
> averaging about 5% lower time to reclaim. This is within the error
> margin of the test, so it's not really a conclusive win, but it is
> certainly shows that it does not slow anything down. If you've got a
> better way to test it, then I'm all ears....

I guess the problem is that inode LRU cache isn't very useful as
long as there are dentries in the way (which is most of the time,
isn't it?). I think nfsd will exercise them better? Dont know of
any other cases.


> > Right, it just makes it harder to do. By much harder, I did mostly mean
> > the extra memory overhead.
> 
> You've still got to allocate that extra memory on the per-sb dentry
> LRUs so it's not really a valid argument.

Well it would be per-zone, per-sb list, but I don't think that
makes it an ivalid point.


> IOWs, if it's too much
> memory for per-sb inode LRUs, then it's too much memory for the
> per-sb dentry LRUs as well...

Not about how much is too much, it's about more cost or memory
usage for what benefit? I guess it isn't a lot more memory though.

 
> > If there is *no* benefit from doing per-sb
> > icache then I would question whether we should.
> 
> The same vague questions wondering about the benefit of per-sb
> dentry LRUs were raised when I first proposed them years ago, and
> look where we are now.

To be fair that is because there were specific needs to do per-sb
pruning. This isn't the case with icache.


>  Besides, focussing on whether this one patch
> is a benefit or not is really missing the point because it's the
> benefits of this patchset as a whole that need to be considered....

I would indeed like to focus on the benefits of the patchset as a
whole. Leaving aside the xfs changes, it would be interesting to
have at least a few numbers for dcache/icache heavy workloads.


