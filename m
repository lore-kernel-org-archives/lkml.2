Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab1C3N6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 09:58:50 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63530 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab1C3N6t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 09:58:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RM413u5imAAtoYdXYy/MqQj31QffeDTXln6iOJYXUjln89E8jbJhekGb8AFg8FdUrD
         CWdWz2aA9DBMmO7kYNJAWvF+yyKmzZq5cOW5cxwUCCHkH5SGkp96aJPW0kPOi5BvBX2P
         ONWW9JvLu0mWPO3iGw/R1dUfbH4qzlsfDfZV4=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1103301538580.3418@dhcp-27-109.brq.redhat.com>
References: <20110328103431.GA22323@july>
	<201103301522.18836.arnd@arndb.de>
	<alpine.LFD.2.00.1103301538580.3418@dhcp-27-109.brq.redhat.com>
Date: Wed, 30 Mar 2011 22:58:47 +0900
X-Google-Sender-Auth: tGy7Nze9wS_lLlBHOAvXQDN0_9M
Message-ID: <AANLkTimA7tmaaw=8XZjaxs9qVOZMjYFCL=UnkJoKXqT=@mail.gmail.com>
Subject: Re: [PATCH v6] fat: Batched discard support for fat
From: Kyungmin Park <kmpark@infradead.org>
To: Lukas Czerner <lczerner@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 10:50 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> On Wed, 30 Mar 2011, Arnd Bergmann wrote:
>
>> On Monday 28 March 2011, Kyungmin Park wrote:
>> > So you will go through (blocks, bytes...) 0 -> 20
>> >
>> >   OOOO==O===OO===OOOOO==O===O===OOOOOOO===
>> >   ^                   ^
>> >   0                   20
>> >
>> > So, you will call discard on extents:
>> >
>> > 0-3
>> > You'll skip 6 because is smaller than minlen
>> > 10-11
>> > 15-19
>> >
>> > instead of
>> >
>> > 0-3
>> > 10-11
>> > 15-19
>> > 30-36
>>
>> Sorry for joining the discussion late, but shouldn't you also pass
>> the alignment of the discards?
>>
>> FAT is typically used on cheap media that have very limited support
>> for garbage-collection, such as eMMC or SD cards.
>>
>> On most SDHC cards, you only ever want to issue discard on full erase
>> blocks (allocation units per spec), typically sized 4 MB.
>
> I was not aware of the fact that SD cards (etc..) does have garbage
> collection of some sort, or that they even have support discard, since I
> thought that we have only TRIM,UNAMP/WRITE_SAME comands for SATA or SCSI
> drives.
>
> Or is there some sort of kernel mechanism doing garbage collection such
> is this for the cheap media ?
>
>>
>> If you just pass the minimum length, the file system could end up
>> erasing a 4 MB section that spans two half erase blocks, or it
>> could span a few clusters of the following erase block, both of
>> which is not desirable from a performance point of view.
>
> Does those cards export such information correctly ?

Each chip vendor knows it exactly and usually can't tell it outside officially.
but it's not big as you think. also if the request size is under trim
size, then it's discarded internally.
I mean do nothing at firmware level.

Thank you,
Kyungmin Park

>
>>
>> On other media, you have the same problem inside an erase block:
>> These might be able to discard parts of an erase block efficiently,
>> but normally not less than a flash page (typically 8 to 32 KB).
>
> Well I have tested several SSD's and thinly provisioned devices, but I
> have not seen any strange behaviour, other than it was terribly
> unefficient to do so. See my results here:
>
> http://people.redhat.com/lczerner/discard/test_discard.html
>
> the fact is that I have not tried discard size smaller than 4K, since
> this is the most usual block size for the filesystem.
>
>>
>> Again, you don't want to discard partial pages in this case, and
>> that is much more important than discarding a large number of pages
>> because it would result in an immediate copy-on-write operation.
>>
>> Further, when you erase some pages inside of an erase block, you
>> probably should not span multiple erase blocks but instead issue
>> separate requests for each set of pages in one erase block.
>
> Does it mean that we should not issue bigger discards that erase block ?
> That does not sound good given my test results. Or maybe I misunderstood
> your point ?
>
>>
>>       Arnd
>>
>>       Arnd
>>
>
> Thanks!
> -Lukas
>
