Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571Ab1C3OVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 10:21:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60153 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932545Ab1C3OVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 10:21:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v6] fat: Batched discard support for fat
Date: Wed, 30 Mar 2011 16:20:49 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Kyungmin Park <kmpark@infradead.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20110328103431.GA22323@july> <201103301522.18836.arnd@arndb.de> <alpine.LFD.2.00.1103301538580.3418@dhcp-27-109.brq.redhat.com>
In-Reply-To: <alpine.LFD.2.00.1103301538580.3418@dhcp-27-109.brq.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103301620.50263.arnd@arndb.de>
X-Provags-ID: V02:K0:nUK1/uBKuzlYFyd6xMXJ8oFro4WY4jvVkLG8JHi+H0N
 7he8MMsjNXnW5fho5ANprd6EQYullr8QzMowY3W4e5mrr9qw43
 Eb7Mpw31IBRQQeoiUbi1If8SBBVN2VWIv+9Nh+6OjRPOkNJZq3
 srviHFe4s02Cv8AWaJ29o8B2yKhvNWZ0pINWBF2QrxJbsFMR5N
 1wQEBOJp2/8SVZVhR0taw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 March 2011, Lukas Czerner wrote:
> On Wed, 30 Mar 2011, Arnd Bergmann wrote:
> > Sorry for joining the discussion late, but shouldn't you also pass
> > the alignment of the discards?
> > 
> > FAT is typically used on cheap media that have very limited support
> > for garbage-collection, such as eMMC or SD cards.
> > 
> > On most SDHC cards, you only ever want to issue discard on full erase
> > blocks (allocation units per spec), typically sized 4 MB.
> 
> I was not aware of the fact that SD cards (etc..) does have garbage
> collection of some sort, or that they even have support discard, since I
> thought that we have only TRIM,UNAMP/WRITE_SAME comands for SATA or SCSI
> drives.
> 
> Or is there some sort of kernel mechanism doing garbage collection such
> is this for the cheap media ?

The garbage collection is what happens on the device internally. Each
card has only a small number of erase blocks that it can write to
at a time (between 1 and ten, typically). When you "open" a new erase
block by writing to it, the card will "close" another erase block
by garbage-collecting the data, i.e. it copies the data that has been
recently written together with the data that was in the erase block
previously and has not been touched since the last GC into a single
erase block, and then erases ones that has been freed up.

I've explained this in more detail a few weeks ago in an article, see
https://lwn.net/Articles/428584/.

Discarding full erase blocks makes the wear levelling more efficient,
since there is a larger number of unused erase blocks to choose from.

The SD card standard does not specify what happens when you erase
less than an erase block, other than that the data will be in a
known state (all-ones or all-zeros). On cheap cards that might
require actually writing that data, while better ones use a sector
remapping inside of an erase block that makes is possible mark
sectors or pages as unused, which can speed up future garbage
collection on the erase block.

> > If you just pass the minimum length, the file system could end up
> > erasing a 4 MB section that spans two half erase blocks, or it
> > could span a few clusters of the following erase block, both of
> > which is not desirable from a performance point of view.
> 
> Does those cards export such information correctly ?

Most of the time, they export the erase block size correctly, but
sometimes they lie. In fact, all of the cards I've seen report
4 MB erase blocks, but some cards in fact use 1.5 MB, 2 MB or 8 MB
instead. I'm sure we will see 3 MB, 6 MB, 12 MB and 16 MB soon.

SD cards do not export the page size, but most of them today use
16 KB. See my list at

https://wiki.linaro.org/WorkingGroups/KernelConsolidation/Projects/FlashCardSurvey

> > On other media, you have the same problem inside an erase block:
> > These might be able to discard parts of an erase block efficiently,
> > but normally not less than a flash page (typically 8 to 32 KB).
> 
> Well I have tested several SSD's and thinly provisioned devices, but I
> have not seen any strange behaviour, other than it was terribly
> unefficient to do so. See my results here:
> 
> http://people.redhat.com/lczerner/discard/test_discard.html 
> 
> the fact is that I have not tried discard size smaller than 4K, since
> this is the most usual block size for the filesystem.

Good SSDs can deal with remapping 4k blocks, while cheap ones
(SD cards, USB sticks, or low-end ATA SSDs) can only do operations
on full blocks.

> > Again, you don't want to discard partial pages in this case, and
> > that is much more important than discarding a large number of pages
> > because it would result in an immediate copy-on-write operation.
> > 
> > Further, when you erase some pages inside of an erase block, you
> > probably should not span multiple erase blocks but instead issue
> > separate requests for each set of pages in one erase block.
> 
> Does it mean that we should not issue bigger discards that erase block ?
> That does not sound good given my test results. Or maybe I misunderstood
> your point ?

I think ideally you want to have multiples of full erase blocks, but I
would not combine discards of a partial erase block with any other
discard.

	Arnd
