Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab1JAP3B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 11:29:01 -0400
Received: from mail.plaintext.sk ([81.0.124.6]:55554 "EHLO shiva.plaintext.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157Ab1JAP24 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 11:28:56 -0400
X-Greylist: delayed 531 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Oct 2011 11:28:55 EDT
Date: Sat, 1 Oct 2011 16:19:57 +0100 (GMT+01:00)
From: LuVar <luvar@plaintext.sk>
To: Dan J Williams <dan.j.williams@intel.com>
Cc: NeilBrown <neilb@suse.de>, Andreas Dilger <adilger@dilger.ca>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, rdunlap@xenotime.net, axboe@kernel.dk,
        akpm@linux-foundation.org, Kent Overstreet <kent.overstreet@gmail.com>
Message-ID: <199017497.12051317482397832.JavaMail.root@shiva>
In-Reply-To: <1280519620.12031317482084581.JavaMail.root@shiva>
Subject: Re: [GIT] Bcache version 12
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Mailer: Zimbra 5.0.16_GA_2921.UBUNTU8_64 (ZimbraWebClient - FF3.0 (Win)/5.0.16_GA_2921.UBUNTU8_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi here.

----- "Dan J Williams" <dan.j.williams@intel.com> wrote:

> On Fri, Sep 30, 2011 at 12:14 AM, Kent Overstreet
> <kent.overstreet@gmail.com> wrote:
> >> > Cache devices have a basically identical superblock as backing
> devices
> >> > though, and some of the registration code is shared, but cache
> devices
> >> > don't correspond to any block devices.
> >>
> >> Just like a raid0 is a virtual creation from two block devices?
>  Or
> >> some other meaning of "don't correspond"?
> >
> > No.
> >
> > Remember, you can hang multiple backing devices off a cache.
> >
> > Each backing device shows up as as a new block device - i.e. if
> you're
> > caching /dev/sdb, you now use it as /dev/bcache0.
> >
> > But the SSD doesn't belong to any of those /dev/bcacheN devices.
> 
> So to clarify I read that as "it belongs to all of them".  The ssd
> (/dev/sda, for example) can cache the contents of N block devices,
> and
> to get to the cached version of each of those you go through
> /dev/bcache[0..N].  The problem you perceive is that an md device
> requires a 1:1 mapping of member devices to md devices.  So if we had
> /dev/sda and /dev/sdb in a cache configuration (/dev/md0) your
> concern
> is that if we simultaneously wanted a /dev/md1 that caches /dev/sda
> and /dev/sdc that md would not be able to handle it.
> 
> Is that the right interpretation?
> 
> I assume /dev/sda in the example would have some bcache-logical
> partitions to delineate the /dev/sdb and /dev/sdc cache data?  Which
> sounds similar to the logical partitions md handles now for external
> metadata.  I'm not proposing that cache-state metadata could be
> handled in userspace it's too integral to the i/o path, just pointing
> out that having /dev/sda be a member of both /dev/md0 and /dev/md1 is
> possible.
> 
> >> > A cache set is a set of cache devices - i.e. SSDs. The primary
> >> > motivitation for cache sets (as distinct from just caches) is to
> have
> >> > the ability to mirror only dirty data, and not clean data.
> >> >
> >> > i.e. if you're doing writeback caching of a raid6, your ssd is
> now a
> >> > single point of failure. You could use raid1 SSDs, but most of
> the data
> >> > in the cache is clean, so you don't need to mirror that... just
> the
> >> > dirty data.
> >>
> >> ...but you only incur that "mirror clean data" penalty once, and
> then
> >> it's just a normal raid1 mirroring writes, right?
> >
> > No idea what you mean...
> 
> /dev/md1 is a slow raid5 and /dev/md0 is a raid1 of two ssds.  Once
> /dev/md0 is synced the only mirror traffic is for incoming
> cache-dirtying writes and cache-clean read allocations.  We agree
> about incoming dirty-data, but you are saying you don't want to
> mirror
> read allocations?

Just one visualization of my understand of bcache set with mirroring only dirty data: http://147.175.167.212/~luvar/bcache/bcacheSSDset.png . If I am not wrong, read alocations are for example green and blue data. Dirty allocations is red one and it should be mirrored across all ssds in mirror set to provide ssd fail security.

On the other hand, greed, blue... data are backed up on raid6 and it is nod needed to mirror them across ssd set. They should be only on one ssd to provide read speedup.

Hmmm (sci-fi), if read allocations (not dirty data) will be mirrored in ssds set, they could be used to improve cache read speed, sacrificing some ssd space. It would be great if cache algorithm can mark really hot data to be mirrored for speed reading...

> 
> >> See, if these things were just md devices multiple cache device
> would
> >> already be "done", or at least on its way by just stacking md
> devices.
> >>  Where "done" is probably an oversimplification.
> >
> > No, it really wouldn't save us anything. If all we wanted to do was
> > mirror everything, there'd be no point in implementing multiple
> cache
> > device support, and you'd just use bcache on top of md. We're
> > implementing something completely new!
> >
> > You read what I said about only mirroring dirty data... right?
> 
> I did but I guess I did not fully grok it.
> 
> >> >> In any case it certainly could be modelled in md - and if the
> modelling were
> >> >> not elegant (e.g. even device numbers for backing devices, odd
> device numbers
> >> >> for cache devices) we could "fix" md to make it more elegant.
> >> >
> >> > But we've no reason to create block devices for caches or have a
> 1:1
> >> > mapping - that'd be a serious step backwards in functionality.
> >>
> >> I don't follow that...  there's nothing that prevents having
> multiple
> >> superblocks per cache array.
> >
> > Multiple... superblocks? Do you mean partitioning up the cache, or
> do
> > you mean creating multiple block devices for a cache? Either way
> it's a
> > silly hack.
> >
> >> A couple reasons I'm probing the md angle.
> >>
> >> 1/ Since the backing devices are md devices it would be nice if
> all
> >> the user space assembly logic that has seeped into udev and dracut
> >> could be re-used for assembling bcache devices.  As it stands it
> seems
> >> bcache relies on in-kernel auto-assembly, which md has discouraged
> >> with the v1 superblock.
> >
> > md was doing in kernel probing, which bcache does not do. What
> bcache is
> > doing is centralizing all the code that touches the on disk
> > superblock/metadata. You want to change something in the superblock
> -
> > you just have to tell the kernel to do it for you. Otherwise not
> only
> > would there be duplication of code, it'd be impossible to do safely
> > without races or the userspace code screwing something up; only the
> > kernel knows and controls the state of everything.
> 
> Makes sense but there is a difference between the metadata that
> specifies the configuration and the metadata that tracks the state of
> the cache.  If that distinction is made then userspace can tell the
> kernel to run a block cache of blockdevA and blockdevB and the kernel
> only needs to handle the cache state metadata.
> 
> > Or do you expect the ext4 superblock to be managed in normal
> operation
> > by userspace tools?
> 
> No.
> 
> >> We even have nascent GUI support in
> >> gnome-disk-utility it would be nice to harness some of that
> enabling
> >> momentum for this.
> >
> > I've got nothing against standardizing the userspace interfaces to
> make
> > life easier for things like gnome-disk-utility. Tell me what you
> want
> > and if it's sane I'll see about implementing it.
> 
> That's the point, userspace has some knowledge of how to interrogate
> and manage md devices.  A bcache device is brand new... maybe for
> good
> reason but that's what I'm trying to understand.
> 
> >> 2/ md supports multiple superblock formats and if you Google "ssd
> >> caching" you'll see that there may be other superblock formats
> that
> >> the Linux block-caching driver could be asked to support down the
> >> road.  And wouldn't it be nice if bcache had at least the option
> to
> >> support the on-disk format of whatever dm-cache is doing?
> >
> > That's pure fantasy. That's like expecting the ext4 code to mount a
> ntfs
> > filesystem!
> 
> No, there's portions of what bcache does that are similar to what md
> does.  Do we need to invent new multiple-device handling
> infrastructure for a block device driver?  But we are quickly
> approaching the "show me the code" portion of this discussion, so I
> need to go do more reading of bcache.
> 
> > There's a lot more to bcache's metadata than a superblock, there's
> a
> > journal and a full b-tree. A cache is going to need an index of
> some
> > kind.
> 
> Yes, but that can be independent of the configuration metadata.
> 
> --
> Dan
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
