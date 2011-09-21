Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab1IUJTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:19:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53776 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab1IUJTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:19:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, rdunlap@xenotime.net, axboe@kernel.dk,
        akpm@linux-foundation.org, neilb@suse.de
Subject: Re: [GIT] Bcache version 12
Date: Wed, 21 Sep 2011 11:19:04 +0200
Message-ID: <3275384.xWAcDU4Ykv@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.0.0-rc1nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <20110921034416.GC5521@moria>
References: <20110910064531.GA32536@moria> <201109201737.05515.arnd@arndb.de> <20110921034416.GC5521@moria>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:loLPfVaxICR4vr3S1p8WLJOjr0fD294y+ZXthTqrrrT
 qymmVtYODwE2mirOTm4D5Qws0O+edAtmUjsdKN7FKWt53OGTTQ
 U2tqKeVitVkAvBiqLxdnYXD+FqnpQvxf+wXUh3+10N4nPlx1qh
 hrEd3C6nvkZbyqu6rP/zDjXPrVKh5G5cpn26HsYWimgjqQF2JJ
 mOBx+ptOXEmHMCAxWuiTzQTvSJYoOI7PcbPZsMX8Uc1b6XooNq
 dJBXEfVluxIN5FQ83kHSwUeMcokj3hZThHQR6wETcG5hAoqfVu
 dIRhRGTPAMRVdhwtK3/WJqT47hdnxggDmqE7DcdGKW5cHrL9xs
 vxj4e9GZybG3Oyu3D/kI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 September 2011 20:44:16 Kent Overstreet wrote:
> On Tue, Sep 20, 2011 at 05:37:05PM +0200, Arnd Bergmann wrote:
> > On Saturday 10 September 2011, Kent Overstreet wrote:
> > > Short overview:
> > > Bcache does both writethrough and writeback caching. It presents itself
> > > as a new block device, a bit like say md. You can cache an arbitrary
> > > number of block devices with a single cache device, and attach and
> > > detach things at runtime - it's quite flexible.
> > > 
> > > It's very fast. It uses a b+ tree for the index, along with a journal to
> > > coalesce index updates, and a bunch of other cool tricks like auxiliary
> > > binary search trees with software floating point keys to avoid a bunch
> > > of random memory accesses when doing binary searches in the btree. It
> > > does over 50k iops doing 4k random writes without breaking a sweat,
> > > and would do many times that if I had faster hardware.
> > > 
> > > It (configurably) tracks and skips sequential IO, so as to efficiently
> > > cache random IO. It's got more cool features than I can remember at this
> > > point. It's resilient, handling IO errors from the SSD when possible up
> > > to a configurable threshhold, then detaches the cache from the backing
> > > device even while you're still using it.
> > 
> > Hi Kent,
> > 
> > What kind of SSD hardware do you target here? I roughly categorize them
> > into two classes, the low-end (USB, SDHC, CF, cheap ATA SSD) and the
> > high-end (SAS, PCIe, NAS, expensive ATA SSD), which have extremely
> > different characteristics. 
> 
> All of the above.
> 
> > I'm mainly interested in the first category, and a brief look at your
> > code suggests that this is what you are indeed targetting. If that is
> > true, can you name the specific hardware characteristics you require
> > as a minimum? I.e. what erase block (bucket) sizes do you support
> > (maximum size, non-power-of-two), how many buckets do you have
> > open at the same time, and do you guarantee that each bucket is written
> > in consecutive order?
> 
> Bucket size is set when you format your cache device. It is restricted
> to powers of two (though the only reason for that restriction is to
> avoid dividing by bucket size all over the place; if there was a
> legitimate need we could easily see what the performance hit would be).

Note that odd erase block sizes are getting very common now, since TLC
flash is being used for many consumer grade devices and these tend to
have erase blocks of three times the equivalent SLC flash. That means you
have to support bucket sizes of 1.5/3/6/12 MB eventually. I've seen
a few devices that use very odd sizes like 4128KiB or 992KiB, or that
misalign the erase blocks to the drive's sector number (i.e. the first
erase block is smaller than the others). I would not recommend trying to
support those.

> And it has to be >= PAGE_SIZE; come to think of it I don't think there's
> a hard upper bound. Performance should be reasonable for bucket sizes
> anywhere between 64k and around 2 mb; somewhere around 64k your btree
> will have a depth of 2 and that and the increased operations on non leaf
> nodes are going to hurt performance. Above around 2 mb and performance
> will start to drop as btree nodes get bigger, but the hit won't be
> enormous.

2MB is rather small for devices made in 2011, the most common you'll 
see now are 4MB and 8MB, and it's rising every year. Devices that use
more channels in parallel like the Sandisk pSSD-P2 already use 16 MB
erase blocks and performance drops sharply if you get it wrong there.

> For data buckets, we currently keep 16 open, 8 for clean data and 8 for
> dirty data. That's hard coded, but there's no reason it has to be. Btree
> nodes are in normal operation mostly not full and thus could be
> considered open buckets - it's always one btree node per bucket. IO to
> the btree is typically < 1% of total IO, though.
>
> Most metadata IO is to the journal; the journal uses a list of buckets
> and writes to them all sequentially, so one open bucket for the journal.
> 
> The one exception is the superblock, but that doesn't get written to in
> normal operation. I am eventually going to switch to using another
> journal for the superblock, as part of bcache FTL.
> 
> We do guarantee that buckets are allways written to sequentially (save
> the superblock). If discards are on, bcache will always issue a discard
> before it starts writing to a bucket again (except for the journal, that
> part's unfinished).

I'd say that 16 (+1) open buckets is pushing it, *very* few devices can
actually sustain that. Maybe you don't normally use all of them but instead
have some buckets that see most of the incoming writes? I can't see how
you'd avoid constant thrashing on cheap drives otherwise.

In the data I've collected at
https://wiki.linaro.org/WorkingGroups/Kernel/Projects/FlashCardSurvey you
can see that the median is 5 open erase blocks in current devices, so
that's probably what you should aim for in the low end. It's not hard
to measure during a format operation that you might already be doing,
so if you can make the number configurable, you should be able to get
more out of the low end without regressing on the real SSDs.

Some SD cards support only one open erase block (plus journal/FAT),
and it's probably not worth spending much thought about supporting
those. This affects all Kingston branded SDHC cards and their OEM
partners (some patriot, extrememory, danelec, emtec, integral --
however as these don't produce the cards themselves, the next shipment
could be better).

Fortunately, the number of open erase blocks in a device is increasing
over time, as manufacturers have to work around growing erase block sizes,
so this problem may become less significant in a few years.

> > On a different note, we had discussed at the last storage/fs summit about
> > using an SSD cache either without a backing store or having the backing
> > store on the same drive as the cache in order to optimize traditional
> > file system on low-end flash media. Have you considered these scenarios?
> > How hard would it be to support this in a meaningful way? My hope is that
> > by sacrificing some 10% of the drive size, you would get significantly
> > improved performance because you can avoid many internal GC cycles within
> > the drive.
> 
> Yeah, so... what you really want there is to move the FTL into the
> kernel, so you can have an FTL that doesn't suck. Bcache is already
> about 90% of the way to being a full blown high performance FTL...
> 
> Besides the metadata stuff that I sort of covered above, the other thing
> that'd have to be done to use bcache as an FTL and not a cache is we'd
> just need a moving garbage collector - so when a bucket is mostly
> empty but has data we need to keep we can move it somewhere else. But
> this is pretty similar to what background writeback does now, so it'll
> be easy and straightforward.
> 
> So yeah, it can be done :)

Ok, sounds great! I'll probably come back to this point once you
have made it upstream. Right now I would not add more features in
order to keep the code reasonably simple for review.

> Further off, what I really want to do is extend bcache somewhat to turn
> it into the bottom half of a filesystem...
> 
> It sounds kind of crazy at first, but - well, bcache already has an
> index, allocation and garbage collection. Right now the index is
> device:sector -> cache device:phys sector. If we just switch to
> inode:sector -> ... we can map files in the filesystem with the exact
> same index we're using for the cache. Not just the same code, the same
> index.
> 
> Then the rough plan is that layer above bcache - the filesystem proper -
> will store all the inodes in a file (say file 0); then when bcache is
> doing garbage collection it has to be able to ask the fs "How big is
> file n supposed to be?". It gives us a very nice separation between
> layers.

Have you thought about combining bcache with exofs? Your description sounds
like what you have is basically an object based storage, so if you provide
an interface that exofs can use, you don't need to worry about all the
complicated VFS interactions.

> There's a ton of other details - bcache then needs to handle allocation
> for rotating disks and not just SSDs, and you want to do that somewhat
> differently as fragmentation matters. But the idea seems to have legs.
> 
> Also, bcache is gaining some nifty functionality that'd be nice to have
> available in the filesystem proper - we're working on full data
> checksumming right now, in particular. We might be able to pull off all
> the features of ZFS and then some, and beat ZFS on performance (maybe
> even with a smaller codebase!).
> 
> If you don't think I'm completely insane and want to hear more, let me
> know :)

My impression is that you are on the right track for the cache, and that
it would be good to combine this with a file system, but that it would
be counterproductive to also want to support rotating disks or merging
the high-level FS code into what you have now. The amount of research
that has gone into these things is something you won't be able to
match without having to sacrifice the stuff that you already do well.

	Arnd
