Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab0HBHzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:55:47 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:15150 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753719Ab0HBHzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:55:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALIWVkx5LclT/2dsb2JhbACgEHK+foU5BIQ9
Date: Mon, 2 Aug 2010 17:55:37 +1000
From: Nick Piggin <npiggin@suse.de>
To: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.35
Message-ID: <20100802075537.GC7841@amd>
References: <AANLkTim8FALeVG+NPLNLEQChu=dPD=GHSpnxmZHYgsNx@mail.gmail.com>
 <20100802023322.GA19164@dastard>
 <AANLkTint_s6h_EC7mDiPsyxr=C0GSrnrgJYkCCU7JEtN@mail.gmail.com>
 <20100802055834.GB19164@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100802055834.GB19164@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 03:58:34PM +1000, Dave Chinner wrote:
> On Sun, Aug 01, 2010 at 07:50:02PM -0700, Linus Torvalds wrote:
> > On Sun, Aug 1, 2010 at 7:33 PM, Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > There hasn't been nearly enough review or testing of this patch
> > > series yet.  Before a merge, it needs to be split up in smaller,
> > > more digestable chunks for more comprehensive review, regression
> > > testing and behavioural analysis.

BTW. it has in fact had quite a bit of testing in earlier form in the
-rt tree for a long time, and several fixes come from there. And good
performance results there too.


> > I dunno. We merge _way_ scarier things in the VM and the block layer,
> > for much less actual upside, and with less review.
> 
> Scary stuff outside of direct VFS/FS interfaces is generally hidden
> from me by my +6 Blinkers of Blissful Ignorance. I make the
> assumption that the experts involved know the risks and have weighed
> them up appropriately. ;)
> 
> > The RCU pathname lookup has some rather impressive performance
> > upsides, and I agree that it would be good to get a lot of review and
> > testing, but the latter isn't going to happen without it being
> > mainlined, and the former is sadly lacking. The person I'd like most
> > to review it is Al,
> 
> Most definitely.

I hate to say but I would like to see it mature for another release. It
should also clash a bit with Al's recent inode work that he'll want to
push.

What I can do is send some of the ground work patches this time around,
put the tree into linux-next, and put reviewers on notice.

I think it is all conceptually sound, but it will inevitably have some
bugs left to shake out, and things to be fixed on the review side. I
don't anticipate a problem that could not be fixed in the release cycle,
but I think aiming for post 2.6.36 is a bit fairer for vfs guys,
honestly. LSF is next week too, so most of them will be busy with travel
and such. But I do hope to discuss the vfs-scale patches there.


> > but anybody in the filesystem world should
> > basically see it as a #1 priority,
> 
> Agreed - I've actually looked at every patch, commented on some
> of the more questionable things, got quoted by LWN for saying that
> it "fell off the locking cliff", have run benchmarks on it and sent
> patches fixing bugs back to Nick.
> 
> It's just really hard to digest it all in one lump and core VFS
> changes on this scale scare me....

For filesystems developers, the dcache and inode locking changes
should be more or less just following simple steps as shown in the
patch series. If they're not abusing dcache_lock (and most except
autofs4 are not), then it should not be a big deal.

There are a couple of locking constraints changed at the API level,
but I didn't run into any problems there yet. It should be all
documented in Documentation/filesystems/* although I need to run a
few more passes over the series to ensure I caught everything.


> > because unlike all the masturbatory
> > patches like xstat() that add new functionality that nobody will
> > likely ever use, Nick's patchseries improves on the thing that
> > everybody uses heavily every day without even thinking about it.
> > 
> > Is it tough to review? Yes. It's core code, not just some random
> > addition that adds a new feature and doesn't impact any old code. But
> > that's also the thing that makes it meaningful, and makes me think it
> > should get merged _much_ more eagerly than most code we ever see.
> 
> I agree with you for the pure locking changes.
> 
> But for the bits that change writeback, LRU ordering and reclaim
> calculations the benefits are not quite so obvious, nor is the
> correctness of the code/behaviour quite so provably correct.  Maybe
> I'm being a bit too paranoid, but generally it pays to be a bit
> conservative as a filesystem developer because the cost of screwing
> up can be pretty high...

Writeback shouldn't be changed. LRU ordering is changed for 2
reasons. Firstly, to make things per-zone instead of global. This
basically fits our whole reclaim model much better, although it
will inevitably cause some random little changes but I think it
is agreed this is a good thing (memory shortage in one zone or
node does not require global shrinkings, NUMA level parallelism
of reclaim.)

The other thing is converting the last few dcache refcounting, and
all of inode refcounting over to this "lazy LRU" model. This can
have a bigger impact, but it really reduces locking on the per-zone
lists, so it definitely helps speed and scalability of non-reclaim
fastpaths. I'm up for changing this if numbers show it hurts, it
would be rather easy to do, but in comparison to the overall
patchset, it would rate as a minor tweak :)


