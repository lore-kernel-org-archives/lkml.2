Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab0HCJ2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 05:28:30 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:1658 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754313Ab0HCJ22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 05:28:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEADx+V0x5LcpI/2dsb2JhbACgCXLBeIU5BA
Date: Tue, 3 Aug 2010 19:28:23 +1000
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        npiggin@suse.de
Subject: Re: Linux 2.6.35
Message-ID: <20100803092823.GA5324@amd>
References: <AANLkTim8FALeVG+NPLNLEQChu=dPD=GHSpnxmZHYgsNx@mail.gmail.com>
 <20100802023322.GA19164@dastard>
 <87tyncds89.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tyncds89.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 10:18:30AM +0200, Andi Kleen wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> > On Sun, Aug 01, 2010 at 04:52:42PM -0700, Linus Torvalds wrote:
> >> On a slightly happier note: one thing I do hope we can merge in the
> >> upcoming merge window is Nick Piggin's cool VFS scalability series.
> >> I've been using it on my own machine, and gone through all the commits
> >> (not that I shouldn't go through some of them some more), and am
> >> personally really excited about it. It's seldom we see major
> >> performance improvements in core code that are quite that noticeable,
> >> and Nick's whole RCU pathname lookup in particular just tickles me
> >> pink.
> >
> > There hasn't been nearly enough review or testing of this patch
> > series yet.  Before a merge, it needs to be split up in smaller,
> > more digestable chunks for more comprehensive review, regression
> > testing and behavioural analysis.
> 
> We started some testing of the VFS series on larger systems and so
> far it looks all very good and the performance improvements are impressive
> (but of course new bottlenecks are being exposed then)
> 
> The only snag found so far was that an ACL enabled file system
> disables all the nice path walk improvements, so right now you
> need to remount with noacl. I'm hoping this can be fixed
> before a mainline release, otherwise I suspect it would disable
> the improvements for lots of people (common distributions default
> to acl on)

OK, vfs-scale-working branch now has commits to enable rcu-walk aware
d_revalidate, permission, and check_acl in the filesystems, and
implements a basic rcu-walk aware scheme for generic/posix acls and
implements that for tmpfs, ext2, btrfs. It just drops out of rcu-walk
if there is an ACL on a directory, or if it is not cached. I think
that's enough to be production ready now. Pushing rcu-walk awareness
down into acl checking code would not be hard.

I was under the impression that ACLs on directories are not that common,
so maybe this is as far as we need to go for now anyway.

It does need more commenting of the new methods and explaining how they
can and can't be used by filesystems. The tree is also getting messy
with incremental changes -- I'm avoiding rebasing it so people following
it can see response to reviews and issues that arise. Obviously it will
all get cleaned up and rebased properly onto a new branch before
anything is merged.

