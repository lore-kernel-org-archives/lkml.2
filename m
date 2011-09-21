Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab1IUCy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 22:54:28 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46793 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab1IUCy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 22:54:26 -0400
Date: Tue, 20 Sep 2011 19:54:08 -0700
From: Kent Overstreet <kent.overstreet@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: Dan Williams <dan.j.williams@gmail.com>,
        Andreas Dilger <adilger@dilger.ca>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [GIT] Bcache version 12
Message-ID: <20110921025408.GA5521@moria>
References: <20110910064531.GA32536@moria>
 <20110911081854.2958fdc8@notabene.brown>
 <20110911192259.GA3743@moria>
 <FD294A0B-7127-4ED1-89B8-3E3ADA796360@dilger.ca>
 <20110912014407.GA5171@moria>
 <CAA9_cmeqevWoK=9WMD9c+csc8SbaYq0aK9j1qWr_0FEa6jWZEw@mail.gmail.com>
 <CAC7rs0t_J+foaLZSuuw5BhpUAYfr-KY1iegFOxEBPCpbrkk1Dg@mail.gmail.com>
 <20110919171606.3640c102@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110919171606.3640c102@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delayed response, 

On Mon, Sep 19, 2011 at 05:16:06PM +1000, NeilBrown wrote:
> On Thu, 15 Sep 2011 14:33:36 -0700 Kent Overstreet
> > Damn, nope. I still think a module parameter is even uglier than a
> > sysfs file, though.
> 
> Beauty is in the eye of the beholder I guess.

I certainly don't find either beautiful for this purpose :p

> 
> > 
> > As far as I can tell, the linux kernel is really lacking any sort of
> > coherent vision for how to make arbitrary interfaces available from
> > the filesystem.
> 
> Cannot disagree with that.  Coherent vision isn't something that the kernel
> community really values.
> 
> I think the best approach is always to find out how someone else already
> achieved a similar goal.  Then either:
>  1/ copy that
>  2/ make a convincing argument why is it bad, and produce a better
>     implementation which meets your needs and theirs.
> 
> i.e. perfect is not an option, better is good when convincing, but not-worse
> is always acceptable.

Yeah, if I knew of anything else that I felt was at least acceptable we
could at least get consistency. 

> 
> 
> > 
> > We all seem to agree that it's a worthwhile thing to do - nobody likes
> > ioctls, /proc/sys has been around for ages; something visible and
> > discoverable beats an ioctl or a weird special purpose system call any
> > day.
> > 
> > But until people can agree on - hell, even come up with a decent plan
> > - for the right way to put interfaces in the filesystem, I'm not going
> > to lose much sleep over it.
> > 
> > >> I looked into that many months ago, spent quite a bit of time fighting
> > >> with the dm code trying to get it to do what I wanted and... no. Never
> > >> again
> > >
> > > Did you do a similar analysis of md?  I had a pet caching project that
> > > had it's own sysfs interface registration system, and came to the
> > > conclusion that it would have been better to have started with an MD
> > > personality.  Especially when one of the legs of the cache is a
> > > md-raid array it helps to keep all that assembly logic using the same
> > > interface.
> > 
> > I did spend some time looking at md, I don't really remember if I gave
> > it a fair chance or if I found a critical flaw.
> > 
> > I agree that an md personality ought to be a good fit but I don't
> > think the current md code is ideal for what bcache wants to do. Much
> > saner than dm, but I think it still suffers from the assumption that
> > there's some easy mapping from superblocks to block devices, with
> > bcache they really can't be tied together.
> 
> I don't understand what you mean there, even after reading bcache.txt.
> 
> Does not each block device have a unique superblock (created by make-bcache)
> on it?  That should define a clear 1-to-1 mapping....

There is (for now) a 1:1 mapping of backing devices to block devices.
Cache devices have a basically identical superblock as backing devices
though, and some of the registration code is shared, but cache devices
don't correspond to any block devices.

> It isn't clear from the documentation what a 'cache set' is.  I think it is a
> set of related cache devices.  But how do they relate to backing devices?
> Is it one backing device per cache set?  Or can it be several backing devices
> are all cached by one cache-set??

Many backing devices per cache set, yes.

A cache set is a set of cache devices - i.e. SSDs. The primary
motivitation for cache sets (as distinct from just caches) is to have
the ability to mirror only dirty data, and not clean data.

i.e. if you're doing writeback caching of a raid6, your ssd is now a
single point of failure. You could use raid1 SSDs, but most of the data
in the cache is clean, so you don't need to mirror that... just the
dirty data.

Multiple cache device support isn't quite finished yet (there's not a
lot of work to do, just lots of higher priorities). It looks like it's
also going to be a useful abstraction for bcache FTL, too - we can treat
multiple channels of an SSD as different devices for allocation
purposes, we just won't expose it to the user in that case.

> In any case it certainly could be modelled in md - and if the modelling were
> not elegant (e.g. even device numbers for backing devices, odd device numbers
> for cache devices) we could "fix" md to make it more elegant.

But we've no reason to create block devices for caches or have a 1:1
mapping - that'd be a serious step backwards in functionality.

> (Not that I'm necessarily advocating an md interface, but if I can understand
> why you don't think md can work, then I might understand bcache better ....
> or you might get to understand md better).

And I still would like to have some generic infrastructure, if only I
had the time to work on such things :)

The way I see it md is more or less conflating two different things -
things that consume block devices 

> 
> 
> Do you have any benchmark numbers showing how wonderful this feature is in
> practice?  Preferably some artificial workloads that show fantastic
> improvement, some that show the worst result you can, and something that is
> actually realistic (best case, worst case, real case).  Graphs are nice.

Well, I went to rerun my favorite benchmark the other day - 4k O_DIRECT
random writes with fio - and discovered a new performance bug
(something weird is going on in allocation leading to huge CPU
utilization). Maybe by next week I'll be able to post some real numbers...

Prior to that bug turning up though - on that benchmark with an SSD
using a Sandforce controller (consumer grade MLC), I was consistently
getting 35k iops. It definitely can go a lot faster on faster hardware,
but those are just the numbers I'm familiar with. Latency is also good
though I couldn't tell you how good offhand; throughput was topping out
with 32 IOs in flight or a bit less.

Basically, if 4k random writes are fast across the board performance is
at least going to be pretty good, because writes don't get completed
until the cache's index is updated and the index update is written to
disk - if the index performance is weak it'll be the bottleneck. But on
that benchmark we're bottlenecked by the SSD (the numbers are similar to
running the same benchmark on the raw SSD).

So the basic story is - bcache is pretty close in performance to either
the raw SSD or raw disk, depending on where the data is for reads and
writethrough vs. writeback caching for writes.

> ... I just checked http://bcache.evilpiepirate.org/ and there is one graph
> there which does seem nice, but it doesn't tell me much (I don't know what a
> Corsair Nova is).  And while bonnie certainly has some value, it mainly shows
> you how fast bonnie can run.  Reporting the file size used and splitting out
> the sequential and random, read and write speeds would help a lot.

Heh, those numbers are over a year old anyways. I really, really need to
update the wiki. When I do post new numbers it'll be well documented
fio benchmarks.

> Also I don't think the code belongs in /block.  The CRC64 code should go
> in /lib and the rest should either be in /drivers/block or
> possible /drivers/md (as it makes a single device out of 'multiple devices'.
> Obviously that isn't urgent, but should be fixed before it can be considered
> to be ready.

Yeah, moving it into drivers/block/bcache/ and splitting it up into
different files is on the todo list (for some reason, one of the other
guys working on bcache thinks a 9k line .c file is excessive :)

Pulling code out of bcache_util.[ch] and sending them as separate
patches is also on the todo list - certainly the crc code and the rb
tree code.

> Is there some documentation on the format of the cache and the cache
> replacement policy?  I couldn't easily find anything on your wiki.
> Having that would make it much easier to review the code and to understand
> pessimal workloads.

Format of the cache - not sure what you mean, on disk format?

Cache replacement policy is currently straight LRU. Someone else is
supposed to start looking at more intelligent cache replacement policy
soon, though I tend to think with most workloads and skipping sequential
IO LRU is actually going to do pretty well.

> Thanks,
> NeilBrown

Thanks for your time! I'll have new code and benchmarks up just as soon
as I can, it really has been busy lately. Are there any benchmarks you'd
be interested in in particular?
