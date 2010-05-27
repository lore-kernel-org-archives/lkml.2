Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab0E0CTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 22:19:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:35508 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801Ab0E0CTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 22:19:19 -0400
Date: Thu, 27 May 2010 12:19:05 +1000
From: Nick Piggin <npiggin@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, xfs@oss.sgi.com
Subject: Re: [PATCH 3/5] superblock: introduce per-sb cache shrinker
 infrastructure
Message-ID: <20100527021905.GG22536@laptop>
References: <1274777588-21494-1-git-send-email-david@fromorbit.com>
 <1274777588-21494-4-git-send-email-david@fromorbit.com>
 <20100526164116.GD22536@laptop>
 <20100526231214.GB1395@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100526231214.GB1395@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 09:12:14AM +1000, Dave Chinner wrote:
> On Thu, May 27, 2010 at 02:41:16AM +1000, Nick Piggin wrote:
> > On Tue, May 25, 2010 at 06:53:06PM +1000, Dave Chinner wrote:
> > > @@ -456,21 +456,16 @@ static void prune_one_dentry(struct dentry * dentry)
> > > +	/*
> > > +	 * if we can't get the umount lock, then there's no point having the
> > > +	 * shrinker try again because the sb is being torn down.
> > > +	 */
> > > +	if (!down_read_trylock(&sb->s_umount))
> > > +		return -1;
> > 
> > Would you just elaborate on the lock order problem somewhere? (the
> > comment makes it look like we *could* take the mutex if we wanted
> > to).
> 
> The shrinker is unregistered in deactivate_locked_super() which is
> just before ->kill_sb is called. The sb->s_umount lock is held at
> this point. hence is the shrinker is operating, we will deadlock if
> we try to lock it like this:
> 
> 	unmount:			shrinker:
> 					down_read(&shrinker_lock);
> 	down_write(&sb->s_umount)
> 	unregister_shrinker()
> 	down_write(&shrinker_lock)
> 					prune_super()
> 					  down_read(&sb->s_umount);
> 					  (deadlock)
> 
> hence if we can't get the sb->s_umount lock in prune_super(), then
> the superblock must be being unmounted and the shrinker should abort
> as the ->kill_sb method will clean up everything after the shrinker
> is unregistered. Hence the down_read_trylock().

You added it to the comment in your updated patch, that was the main
thing I wanted. Thanks.


> > > +	if (!sb->s_root) {
> > > +		up_read(&sb->s_umount);
> > > +		return -1;
> > > +	}
> > > +
> > > +	if (nr_to_scan) {
> > > +		/* proportion the scan between the two cacheѕ */
> > > +		int total;
> > > +
> > > +		total = sb->s_nr_dentry_unused + sb->s_nr_inodes_unused + 1;
> > > +		count = (nr_to_scan * sb->s_nr_dentry_unused) / total;
> > > +
> > > +		/* prune dcache first as icache is pinned by it */
> > > +		prune_dcache_sb(sb, count);
> > > +		prune_icache_sb(sb, nr_to_scan - count);
> > > +	}
> > > +
> > > +	count = ((sb->s_nr_dentry_unused + sb->s_nr_inodes_unused) / 100)
> > > +						* sysctl_vfs_cache_pressure;
> > 
> > Do you think truncating in the divisions is at all a problem? It
> > probably doesn't matter much I suppose.
> 
> Same code as currently exists. IIRC, the reasoning is that if we've
> got less that 100 objects to reclaim, then we're unlikely to be able
> to free up any memory from the caches, anyway.

Yeah, which is why I stop short of saying you should change it in
this patch.

But I think we should ensure things can get reclaimed eventually.
100 objects could be 100 slabs, which could be anything from
half a meg to half a dozen. Multiplied by each of the caches.
Could be significant in small systems.
