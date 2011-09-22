Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751193Ab1IVEHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 00:07:54 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49974 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab1IVEHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 00:07:52 -0400
Date: Wed, 21 Sep 2011 21:07:37 -0700
From: Kent Overstreet <kent.overstreet@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, rdunlap@xenotime.net, axboe@kernel.dk,
        akpm@linux-foundation.org, neilb@suse.de
Subject: Re: [GIT] Bcache version 12
Message-ID: <20110922040737.GB29599@moria>
References: <20110910064531.GA32536@moria>
 <201109201737.05515.arnd@arndb.de>
 <20110921034416.GC5521@moria>
 <3275384.xWAcDU4Ykv@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3275384.xWAcDU4Ykv@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 11:19:04AM +0200, Arnd Bergmann wrote:
> On Tuesday 20 September 2011 20:44:16 Kent Overstreet wrote:
> > On Tue, Sep 20, 2011 at 05:37:05PM +0200, Arnd Bergmann wrote:
> > > On Saturday 10 September 2011, Kent Overstreet wrote:
> > > > Short overview:
> > > > Bcache does both writethrough and writeback caching. It presents itself
> > > > as a new block device, a bit like say md. You can cache an arbitrary
> > > > number of block devices with a single cache device, and attach and
> > > > detach things at runtime - it's quite flexible.
> > > > 
> > > > It's very fast. It uses a b+ tree for the index, along with a journal to
> > > > coalesce index updates, and a bunch of other cool tricks like auxiliary
> > > > binary search trees with software floating point keys to avoid a bunch
> > > > of random memory accesses when doing binary searches in the btree. It
> > > > does over 50k iops doing 4k random writes without breaking a sweat,
> > > > and would do many times that if I had faster hardware.
> > > > 
> > > > It (configurably) tracks and skips sequential IO, so as to efficiently
> > > > cache random IO. It's got more cool features than I can remember at this
> > > > point. It's resilient, handling IO errors from the SSD when possible up
> > > > to a configurable threshhold, then detaches the cache from the backing
> > > > device even while you're still using it.
> > > 
> > > Hi Kent,
> > > 
> > > What kind of SSD hardware do you target here? I roughly categorize them
> > > into two classes, the low-end (USB, SDHC, CF, cheap ATA SSD) and the
> > > high-end (SAS, PCIe, NAS, expensive ATA SSD), which have extremely
> > > different characteristics. 
> > 
> > All of the above.
> > 
> > > I'm mainly interested in the first category, and a brief look at your
> > > code suggests that this is what you are indeed targetting. If that is
> > > true, can you name the specific hardware characteristics you require
> > > as a minimum? I.e. what erase block (bucket) sizes do you support
> > > (maximum size, non-power-of-two), how many buckets do you have
> > > open at the same time, and do you guarantee that each bucket is written
> > > in consecutive order?
> > 
> > Bucket size is set when you format your cache device. It is restricted
> > to powers of two (though the only reason for that restriction is to
> > avoid dividing by bucket size all over the place; if there was a
> > legitimate need we could easily see what the performance hit would be).
> 
> Note that odd erase block sizes are getting very common now, since TLC
> flash is being used for many consumer grade devices and these tend to
> have erase blocks of three times the equivalent SLC flash. That means you
> have to support bucket sizes of 1.5/3/6/12 MB eventually. I've seen
> a few devices that use very odd sizes like 4128KiB or 992KiB, or that
> misalign the erase blocks to the drive's sector number (i.e. the first
> erase block is smaller than the others). I would not recommend trying to
> support those.

Eesh. I hadn't heard that before, that's rather annoying. If 3x a power
of two is the norm though, I suppose I can just have sector_to_bucket()
do two shifts instead of one..

> 2MB is rather small for devices made in 2011, the most common you'll 
> see now are 4MB and 8MB, and it's rising every year. Devices that use
> more channels in parallel like the Sandisk pSSD-P2 already use 16 MB
> erase blocks and performance drops sharply if you get it wrong there.

Yeah, I'm aware of the trend, it's annoying though. Bcache really wants
to know more about the internal topology of the SSD, if the SSD could
present a couple channels and not stripe them together bcache could
retain the benefits of striping by doing it itself (within reason; if
stripe size has to be too small that inflates the btree size) and get
the benefits of smaller buckets/erase blocks.

If you're ok with the internal fragmentation on disk in the btree nodes,
that should be the only serious drawback of 4-8 mb erase blocks. I'd
really hate to have to rework things to be able to store multiple btree
nodes in a bucket though, that would be painful.

We'd want the moving garbage collector for that too so we can get good
cache utilization; only trouble with that on a real SSD is you really
don't want to be moving data around at the same time the FTL is.

> I'd say that 16 (+1) open buckets is pushing it, *very* few devices can
> actually sustain that. Maybe you don't normally use all of them but instead
> have some buckets that see most of the incoming writes? I can't see how
> you'd avoid constant thrashing on cheap drives otherwise.

That's good to know. It's certainly true that in practice we don't
normally use them all, but it sounds like it'd be worth tweaking that.

> Ok, sounds great! I'll probably come back to this point once you
> have made it upstream. Right now I would not add more features in
> order to keep the code reasonably simple for review.

Right now, the only high priority feature is full data checksumming,
there's real demand for that.

Don't suppose you'd care to help review it so we can get it merged? ;)

> Have you thought about combining bcache with exofs? Your description sounds
> like what you have is basically an object based storage, so if you provide
> an interface that exofs can use, you don't need to worry about all the
> complicated VFS interactions.

I hadn't thought of exofs, that's a great idea. We'd have to fork it but
it looks like a great starting point, simple and roughly what we want.

> My impression is that you are on the right track for the cache, and that
> it would be good to combine this with a file system, but that it would
> be counterproductive to also want to support rotating disks or merging
> the high-level FS code into what you have now. The amount of research
> that has gone into these things is something you won't be able to
> match without having to sacrifice the stuff that you already do well.

A filesystem is certainly a ways down the road. I do think there's a lot
of potential though; I'm really happy with how the design of bcache has
evolved and there's a lot of elegance to the filesystem ideas.

Got to ship what we've got first, though :)
