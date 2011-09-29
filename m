Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab1I2Xi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 19:38:56 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41286 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab1I2Xix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 19:38:53 -0400
MIME-Version: 1.0
In-Reply-To: <20110921025408.GA5521@moria>
References: <20110910064531.GA32536@moria>
	<20110911081854.2958fdc8@notabene.brown>
	<20110911192259.GA3743@moria>
	<FD294A0B-7127-4ED1-89B8-3E3ADA796360@dilger.ca>
	<20110912014407.GA5171@moria>
	<CAA9_cmeqevWoK=9WMD9c+csc8SbaYq0aK9j1qWr_0FEa6jWZEw@mail.gmail.com>
	<CAC7rs0t_J+foaLZSuuw5BhpUAYfr-KY1iegFOxEBPCpbrkk1Dg@mail.gmail.com>
	<20110919171606.3640c102@notabene.brown>
	<20110921025408.GA5521@moria>
Date: Thu, 29 Sep 2011 16:38:52 -0700
X-Google-Sender-Auth: S2MC1qDionCeTVc-eKv9KFIAlvg
Message-ID: <CAA9_cmfOdv4ozkz7bd2QsbL5_VtAraMZMXoo0AAV0eCgNQr62Q@mail.gmail.com>
Subject: Re: [GIT] Bcache version 12
From: Dan Williams <dan.j.williams@intel.com>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: NeilBrown <neilb@suse.de>, Andreas Dilger <adilger@dilger.ca>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 7:54 PM, Kent Overstreet
<kent.overstreet@gmail.com> wrote:
>> Does not each block device have a unique superblock (created by make-bcache)
>> on it?  That should define a clear 1-to-1 mapping....
>
> There is (for now) a 1:1 mapping of backing devices to block devices.

Is that "(for now)" where you see md not being able to model this in the future?

> Cache devices have a basically identical superblock as backing devices
> though, and some of the registration code is shared, but cache devices
> don't correspond to any block devices.

Just like a raid0 is a virtual creation from two block devices?  Or
some other meaning of "don't correspond"?

>> It isn't clear from the documentation what a 'cache set' is.  I think it is a
>> set of related cache devices.  But how do they relate to backing devices?
>> Is it one backing device per cache set?  Or can it be several backing devices
>> are all cached by one cache-set??
>
> Many backing devices per cache set, yes.
>
> A cache set is a set of cache devices - i.e. SSDs. The primary
> motivitation for cache sets (as distinct from just caches) is to have
> the ability to mirror only dirty data, and not clean data.
>
> i.e. if you're doing writeback caching of a raid6, your ssd is now a
> single point of failure. You could use raid1 SSDs, but most of the data
> in the cache is clean, so you don't need to mirror that... just the
> dirty data.

...but you only incur that "mirror clean data" penalty once, and then
it's just a normal raid1 mirroring writes, right?

> Multiple cache device support isn't quite finished yet (there's not a
> lot of work to do, just lots of higher priorities). It looks like it's
> also going to be a useful abstraction for bcache FTL, too - we can treat
> multiple channels of an SSD as different devices for allocation
> purposes, we just won't expose it to the user in that case.

See, if these things were just md devices multiple cache device would
already be "done", or at least on its way by just stacking md devices.
 Where "done" is probably an oversimplification.

>> In any case it certainly could be modelled in md - and if the modelling were
>> not elegant (e.g. even device numbers for backing devices, odd device numbers
>> for cache devices) we could "fix" md to make it more elegant.
>
> But we've no reason to create block devices for caches or have a 1:1
> mapping - that'd be a serious step backwards in functionality.

I don't follow that...  there's nothing that prevents having multiple
superblocks per cache array.

A couple reasons I'm probing the md angle.

1/ Since the backing devices are md devices it would be nice if all
the user space assembly logic that has seeped into udev and dracut
could be re-used for assembling bcache devices.  As it stands it seems
bcache relies on in-kernel auto-assembly, which md has discouraged
with the v1 superblock.  We even have nascent GUI support in
gnome-disk-utility it would be nice to harness some of that enabling
momentum for this.

2/ md supports multiple superblock formats and if you Google "ssd
caching" you'll see that there may be other superblock formats that
the Linux block-caching driver could be asked to support down the
road.  And wouldn't it be nice if bcache had at least the option to
support the on-disk format of whatever dm-cache is doing?

>> (Not that I'm necessarily advocating an md interface, but if I can understand
>> why you don't think md can work, then I might understand bcache better ....
>> or you might get to understand md better).
>
> And I still would like to have some generic infrastructure, if only I
> had the time to work on such things :)
>
> The way I see it md is more or less conflating two different things -
> things that consume block devices

...did the interwebs chomp the last part of that thought?

[..]
>> Also I don't think the code belongs in /block.  The CRC64 code should go
>> in /lib and the rest should either be in /drivers/block or
>> possible /drivers/md (as it makes a single device out of 'multiple devices'.
>> Obviously that isn't urgent, but should be fixed before it can be considered
>> to be ready.
>
> Yeah, moving it into drivers/block/bcache/ and splitting it up into
> different files is on the todo list (for some reason, one of the other
> guys working on bcache thinks a 9k line .c file is excessive :)

Not unheard of
$ cat drivers/scsi/ipr.c | wc -l
9237

> Pulling code out of bcache_util.[ch] and sending them as separate
> patches is also on the todo list - certainly the crc code and the rb
> tree code.
>
>> Is there some documentation on the format of the cache and the cache
>> replacement policy?  I couldn't easily find anything on your wiki.
>> Having that would make it much easier to review the code and to understand
>> pessimal workloads.
>
> Format of the cache - not sure what you mean, on disk format?
>
> Cache replacement policy is currently straight LRU. Someone else is
> supposed to start looking at more intelligent cache replacement policy
> soon, though I tend to think with most workloads and skipping sequential
> IO LRU is actually going to do pretty well.
>
>> Thanks,
>> NeilBrown
>
> Thanks for your time! I'll have new code and benchmarks up just as soon
> as I can, it really has been busy lately. Are there any benchmarks you'd
> be interested in in particular?
>

Side question, what are the "Change Id:" lines referring to in the git
commit messages?
