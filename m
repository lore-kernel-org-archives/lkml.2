Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676Ab1C3Oo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 10:44:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44623 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab1C3Ooz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 10:44:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=HglVP+CsGPm1p44Bxd/lJpMrrku3IkjM8/nDc++wYbbRcC+H++gPnZWnx9aIzWswSu
         /gR8sh3aUzPExipbwUHgO6Lhryem6hQ5XLXqmzbch/sCjO0KcEG/XVU7UMdH2rcZU4dj
         J60gGvcCdwPBLorBlUmnjmIIQWXDcCa5j35lY=
MIME-Version: 1.0
In-Reply-To: <201103301620.50263.arnd@arndb.de>
References: <20110328103431.GA22323@july>
	<201103301522.18836.arnd@arndb.de>
	<alpine.LFD.2.00.1103301538580.3418@dhcp-27-109.brq.redhat.com>
	<201103301620.50263.arnd@arndb.de>
Date: Wed, 30 Mar 2011 23:44:53 +0900
X-Google-Sender-Auth: 4-eYJgKoT6er-Rvvs0gukqreTLQ
Message-ID: <AANLkTi=QVe0UK3Q_xKG17_aHH7g4Y=miWu7UT7ogisyP@mail.gmail.com>
Subject: Re: [PATCH v6] fat: Batched discard support for fat
From: Kyungmin Park <kmpark@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lukas Czerner <lczerner@redhat.com>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 11:20 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 30 March 2011, Lukas Czerner wrote:
>> On Wed, 30 Mar 2011, Arnd Bergmann wrote:
>> > Sorry for joining the discussion late, but shouldn't you also pass
>> > the alignment of the discards?
>> >
>> > FAT is typically used on cheap media that have very limited support
>> > for garbage-collection, such as eMMC or SD cards.
>> >
>> > On most SDHC cards, you only ever want to issue discard on full erase
>> > blocks (allocation units per spec), typically sized 4 MB.
>>
>> I was not aware of the fact that SD cards (etc..) does have garbage
>> collection of some sort, or that they even have support discard, since I
>> thought that we have only TRIM,UNAMP/WRITE_SAME comands for SATA or SCSI
>> drives.
>>
>> Or is there some sort of kernel mechanism doing garbage collection such
>> is this for the cheap media ?
>
> The garbage collection is what happens on the device internally. Each
> card has only a small number of erase blocks that it can write to
> at a time (between 1 and ten, typically). When you "open" a new erase
> block by writing to it, the card will "close" another erase block
> by garbage-collecting the data, i.e. it copies the data that has been
> recently written together with the data that was in the erase block
> previously and has not been touched since the last GC into a single
> erase block, and then erases ones that has been freed up.
>
> I've explained this in more detail a few weeks ago in an article, see
> https://lwn.net/Articles/428584/.
>
> Discarding full erase blocks makes the wear levelling more efficient,
> since there is a larger number of unused erase blocks to choose from.
>
> The SD card standard does not specify what happens when you erase
> less than an erase block, other than that the data will be in a
> known state (all-ones or all-zeros). On cheap cards that might
> require actually writing that data, while better ones use a sector
> remapping inside of an erase block that makes is possible mark
> sectors or pages as unused, which can speed up future garbage
> collection on the erase block.
>
>> > If you just pass the minimum length, the file system could end up
>> > erasing a 4 MB section that spans two half erase blocks, or it
>> > could span a few clusters of the following erase block, both of
>> > which is not desirable from a performance point of view.
>>
>> Does those cards export such information correctly ?
>
> Most of the time, they export the erase block size correctly, but
> sometimes they lie. In fact, all of the cards I've seen report
> 4 MB erase blocks, but some cards in fact use 1.5 MB, 2 MB or 8 MB
> instead. I'm sure we will see 3 MB, 6 MB, 12 MB and 16 MB soon.
>
> SD cards do not export the page size, but most of them today use
> 16 KB. See my list at
>
> https://wiki.linaro.org/WorkingGroups/KernelConsolidation/Projects/FlashCardSurvey

Thank you for your effort. but think it the original purpose of
batched discard feature.
Do you want to run the batched discard for SD card. I mean usually in
our environment SD card is optional.
and my goal is used for eMMC. and you know, eMMC and SD card internal
algorithm is different.
The goal of SD card is performance but eMMC is different. it should
consider the reliability also. e.g., Sudden Power Off Recovery.

>
>> > On other media, you have the same problem inside an erase block:
>> > These might be able to discard parts of an erase block efficiently,
>> > but normally not less than a flash page (typically 8 to 32 KB).
>>
>> Well I have tested several SSD's and thinly provisioned devices, but I
>> have not seen any strange behaviour, other than it was terribly
>> unefficient to do so. See my results here:
>>
>> http://people.redhat.com/lczerner/discard/test_discard.html
>>
>> the fact is that I have not tried discard size smaller than 4K, since
>> this is the most usual block size for the filesystem.
>
> Good SSDs can deal with remapping 4k blocks, while cheap ones
> (SD cards, USB sticks, or low-end ATA SSDs) can only do operations
> on full blocks.
It really depends on devices. To increase the performance we have to
increase the channel and the way unit at internally.
Most NAND devices are similar there's no way except increase the
interleaving unit. and it affects the price.

That's reason I like the batched discard. it's not easy to guess the
erase block at system level. so it's helpful scan the unused blocks
and *try* to trim at once.

Please remember that the discard is just hint. If we write the flash
sequentially then we maybe don't need to trim it.

Thank you,
Kyungmin Park
>
>> > Again, you don't want to discard partial pages in this case, and
>> > that is much more important than discarding a large number of pages
>> > because it would result in an immediate copy-on-write operation.
>> >
>> > Further, when you erase some pages inside of an erase block, you
>> > probably should not span multiple erase blocks but instead issue
>> > separate requests for each set of pages in one erase block.
>>
>> Does it mean that we should not issue bigger discards that erase block ?
>> That does not sound good given my test results. Or maybe I misunderstood
>> your point ?
>
> I think ideally you want to have multiples of full erase blocks, but I
> would not combine discards of a partial erase block with any other
> discard.
>
>        Arnd
>
