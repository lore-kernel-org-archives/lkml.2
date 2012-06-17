Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab2FQV7F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 17:59:05 -0400
Received: from elasmtp-curtail.atl.sa.earthlink.net ([209.86.89.64]:54721 "EHLO
	elasmtp-curtail.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757239Ab2FQV7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 17:59:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=J3bSiufIvklmIhj2Ky0uGCBoUyltQWMeIkizcmnmKi9g5iQ2mYuqBaX+RG+GXXzZ;
  h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4FDE5320.8070702@earthlink.net>
Date: Sun, 17 Jun 2012 14:58:56 -0700
From: jdow <jdow@earthlink.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-m68k@vger.kernel.org
Subject: Re: Partitions: Amiga RDB partition on 2 TB disk way too big, while
 OK in AmigaOS 4.1
References: <201206170841.20222.Martin@lichtvoll.de> <201206171458.58462.Martin@lichtvoll.de> <CAMuHMdWY7=2nJDUjQFGPhdOAFGYeUsnvgPcaEvB2Gxf7P=E+Ug@mail.gmail.com> (sfid-20120617_225443_752860_DC66624F) <201206172306.03202.Martin@lichtvoll.de>
In-Reply-To: <201206172306.03202.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: bb89ecdb26a8f9f24d2b10475b571120841c09a80b8d9eb66c6b39023c8c3bf79708455b0263bb86350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 208.127.11.14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2012/06/17 14:06, Martin Steigerwald wrote:
> Am Sonntag, 17. Juni 2012 schrieb Geert Uytterhoeven:
>> On Sun, Jun 17, 2012 at 2:58 PM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
>>> Am Sonntag, 17. Juni 2012 schrieb jdow:
>>> | JXFS 64 bit file system
>>> |
>>> | With AmigaOS 4.x a new file system has been introduced called JXFS.
>>> | It is a totally new 64 bit file system that supports partitions up
>>> | to 16 TB in size. It is a modern journalling file system, which
>>> | means that it reduces data loss if data writes to the disk are
>>> | interrupted. It is the fastest and most reliable file system ever
>>> | created for AmigaOS.
>>>
>>> http://www.amigaos.net/content/1/features
>>>
>>> Well I asked AmigaOS 4 developers about this issue as well. Lets see
>>> what they say about 2 TB limits.
>>
>> 16 TB = 2 TB * 8. Perhaps they increased the block size from 512 to
>> 4096?
>
> I hope to get anything back from the AmigaOS 4 developers.
>
>> block/partitions/amiga.c reads the block size from
>> RigidDiskBlock.rdb_BlockBytes,
>> but after conversion to 512-byte blocks, all further calculations are
>> done on "int", so it will overflow for disks larger than 2 TiB.
>>
>> Note that in your profile-binary.img, the field is 0x200, i.e. 512
>> bytes per block,
>> so I'll have to get a deeper look into your RDB first...
>
> Okay, thanks!
>
> I did not get any information regarding the current size limit yet.
>
> Strangely on AmigaOS 4.1 all values seem to be fine except for the total
> sectors value.
>
> And on Linux begin and end cylinders are correct, only size is off:

Ah, you DO know that "cylinders, surfaces, and tracks" are polite
fictions in AmigaOS, don't you? Start and End blocks are all that
matter on a real Amiga. The fictions arose because at first it was
thought they could be used to optimize disk accesses. Once drives
were notched these values became meaningless. So they're created on
the fly picking values out of the nose or something. (RDPrep tries
to find reasonable size factors for the total block counts.)

> merkaba:~> amiga-fdisk -l /dev/sdb

Are you sure "amiga-fdisk" is not broken?

> Disk /dev/sdb: 3 heads, 16 sectors, 81396441 cylinders, RDB: 0
> Logical Cylinders from 43 to 81396440, 24576  bytes/Cylinder
>
> Device     Boot Mount   Begin      End     Size   Pri  BBlks    System
> /dev/sdb1       *        43   65536043   1572864024     0      0  Linux native
> /dev/sdb2       *    65536044   78643244   314572824     0      0  [unknown]
> /dev/sdb3       *    78643245   81396440   66076704     0      0  Amiga FFS Int.
>
> But not only from the first, also of the second and third one it seems.
>
> 65536043 - 43 = 65536000

So the size in bytes is 24 times the byte offset of the start of the
next partition. Fascinating. Let's see. You are working in 512 byte blocks
it looks like. With RDBs in blocks that means you can get up to
1099511627776 bytes, 2147483648 blocks, or 44739242. So you are already
WAY over what can be expressed in the 32 bit values in the RDBs. So the
software that prepared your partitioning needs some repair work of some
sort or something other than traditional Amiga FFS format disks.

The first thing on the agenda is "fixing" the partitioning software. Is
the version of Amiga FFS you are using cognizant of 64 bit values? If not
you will have to go to block sizes larger than 512 bytes. It looks like
1k is suitable for this instance. Given the way Amiga FFS stores data on
the disk I'd go for 4k or 8k block sizes unless you have lots of very
small files.

> 78643244 - 65536044 = 13107200
>
> 81396440 - 78643245 = 2753195
>
> I would think that if there is a overflow it would already be in the cylinder
> numbers.
>
> Ciao,

The RDB reading software may not be at fault. I'll have to check. Your
partitioning tool let you down. It looks like you've overflowed the 31
(useful) bit values in your RDBs. So not much can recover from this.
Play with signed arithmetic and treat the final value as unsigned and
see if you get the size noted.

{^_^}
