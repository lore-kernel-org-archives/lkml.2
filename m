Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab2FRU6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 16:58:22 -0400
Received: from elasmtp-masked.atl.sa.earthlink.net ([209.86.89.68]:48108 "EHLO
	elasmtp-masked.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752556Ab2FRU6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 16:58:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=NpG+FTVz0EC/QpdRTFAh7eCPvXfWEYlhArA8wG4YyEdJbCbcuo35KGQ3G8l1udI5;
  h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4FDF9663.4050408@earthlink.net>
Date: Mon, 18 Jun 2012 13:58:11 -0700
From: jdow <jdow@earthlink.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-m68k@vger.kernel.org
Subject: Re: Partitions: Amiga RDB partition on 2 TB disk way too big, while
 OK in AmigaOS 4.1
References: <201206170841.20222.Martin@lichtvoll.de> <201206171458.58462.Martin@lichtvoll.de> <CAMuHMdWY7=2nJDUjQFGPhdOAFGYeUsnvgPcaEvB2Gxf7P=E+Ug@mail.gmail.com> (sfid-20120617_225443_752860_DC66624F) <201206182239.26647.Martin@lichtvoll.de>
In-Reply-To: <201206182239.26647.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-ELNK-Trace: bb89ecdb26a8f9f24d2b10475b5711208bbc48ecbc97b8c7d23cd4481fe8d599cad7108b5ca2c91a350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 208.127.11.14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/06/18 13:39, Martin Steigerwald wrote:
> Am Sonntag, 17. Juni 2012 schrieb Geert Uytterhoeven:
>> On Sun, Jun 17, 2012 at 2:58 PM, Martin Steigerwald
>> <Martin@lichtvoll.de> wrote:
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
>>
>> block/partitions/amiga.c reads the block size from
>> RigidDiskBlock.rdb_BlockBytes,
>> but after conversion to 512-byte blocks, all further calculations are
>> done on "int", so it will overflow for disks larger than 2 TiB.
>
> Meanwhile I got a response from a AmigaOS 4 developer.
>
> I documented the stuff as I understood it in the AmigaOS wiki:
>
> | Disk size
> |
> | The RDB has a quite high limit on the maximum device size, but note that
> | currently each filesystem interprets the partition layout by itself.
>
> | The raw, theoretical limit on the maximum device capacity is about 2^105
> | bytes:
> |
> | 32 bit rdb_Cylinders * 32 bit rdb_Heads * 32 bit rdb_Sectors * 512
> | bytes/sector for the HD size in struct RigidDiskBlock
> |
> | It's even much more if the sector size (rdb_BlockBytes and de_SizeBlock)
> | is larger than 512 bytes, but AmigaOS 4.1 doesn't support anything but
> | 512 bytes/sector HDs yet.
> |
> | Partition size
> |
> | For the partitions the maximum size is:
> | 32 bit (de_HighCyl + 1 - de_LowCyl) (to get the partition size) * 32 bit
> | de_Surfaces * 32 bit de_SectorsPerTrack * 512 bytes/sector in struct
> | DosEnvec (=pb_Environment[]) in struct PartitionBlock.
> |
> | That's from the physical drive part, the actual disk size limit for the
> | partitions may be much smaller depending on the partitioning software,
> | if it's only using the logical sizes instead, which is likely the case,
> | it's only 8 ZiB with 512 bytes/sector: 32 bit rdb_HiCylinder * 32 bit
> | rdb_CylBlocks * 512 bytes/sector = 2^73 bytes. For using the logical
> | sizes using simple uint64 calculations (with some overflow checks) should
> | be enough, for more a math library with support for larger integers
> | needs to be used which probably no partitioning software does.
> |
> | But note: Nothing in struct RigiDiskBlock is used by the file systems for
> | mounting the partitions, they only get the information from the struct
> | PartitionBlock blocks, it's only a problem for the partitioning software
> | creating the partitions correctly - as soon as there are HDs larger than
> | 8 ZB while still using 512 bytes/sector if that ever happens.
>
> http://wiki.amigaos.net/index.php/RDB

He's in the right ballpark but he missed something in the RDISK block:
     __u32   rdb_LoCylinder;	// 88	0x2b		Ayup - checks
     __u32   rdb_HiCylinder;	// 8C   0x04da02d8	Whole disk used.
     __u32   rdb_CylBlocks;	// 90	0x30		checks

So he has two 32 bit unsigned integers not three to multiply together.
If he ignores that detail he can, indeed, go out to three ULONGS for the
total disk logical block count. Then he has two more ULONGs for physical
block size and number of physical blocks per filesystem blocks. So the
size could, in theory, go past 2^100 bytes.

The filesystem is still likely limited to 2 TB or so unless there is a
64 bit version now.

> Please note that the documentation there might be updated or corrected in
> the future. But thats the current state.
>
>> Note that in your profile-binary.img, the field is 0x200, i.e. 512
>> bytes per block,
>> so I'll have to get a deeper look into your RDB first...
>
> I am a bit overwhelmed by Joanne´s analysis. I didn´t yet take time to
> completely read and try to understand it. I first wanted to get this
> information out.

When you can please recompile a kernel with that one change to it. It
MIGHT turn the trick. It changes an int to a sector_t (unsigned long long)
so the math does not go funkity going into the "put_partition" function,
which has disk blocks as sector_t values. (I think, but can't be sure,
that the put_partition call used int when I "committed" that sin way back
when. I've not yet compared that code with the code I submitted many years
ago to see if all the right stuff is still there.)

{^_^}
