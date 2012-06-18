Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab2FRUjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 16:39:33 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:59227 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab2FRUj2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 16:39:28 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: Partitions: Amiga RDB partition on 2 TB disk way too big, while OK in AmigaOS 4.1
Date: Mon, 18 Jun 2012 22:39:26 +0200
User-Agent: KMail/1.13.7 (Linux/3.4-trunk-amd64; KDE/4.8.3; x86_64; ; )
Cc: jdow <jdow@earthlink.net>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-m68k@vger.kernel.org
References: <201206170841.20222.Martin@lichtvoll.de> <201206171458.58462.Martin@lichtvoll.de> <CAMuHMdWY7=2nJDUjQFGPhdOAFGYeUsnvgPcaEvB2Gxf7P=E+Ug@mail.gmail.com> (sfid-20120617_225443_752860_DC66624F)
In-Reply-To: <CAMuHMdWY7=2nJDUjQFGPhdOAFGYeUsnvgPcaEvB2Gxf7P=E+Ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201206182239.26647.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 17. Juni 2012 schrieb Geert Uytterhoeven:
> On Sun, Jun 17, 2012 at 2:58 PM, Martin Steigerwald 
> <Martin@lichtvoll.de> wrote:
> > Am Sonntag, 17. Juni 2012 schrieb jdow:
> > | JXFS 64 bit file system
> > | 
> > | With AmigaOS 4.x a new file system has been introduced called JXFS.
> > | It is a totally new 64 bit file system that supports partitions up
> > | to 16 TB in size. It is a modern journalling file system, which
> > | means that it reduces data loss if data writes to the disk are
> > | interrupted. It is the fastest and most reliable file system ever
> > | created for AmigaOS.
> > 
> > http://www.amigaos.net/content/1/features
> > 
> > Well I asked AmigaOS 4 developers about this issue as well. Lets see
> > what they say about 2 TB limits.
> 
> 16 TB = 2 TB * 8. Perhaps they increased the block size from 512 to
> 4096?
> 
> block/partitions/amiga.c reads the block size from
> RigidDiskBlock.rdb_BlockBytes,
> but after conversion to 512-byte blocks, all further calculations are
> done on "int", so it will overflow for disks larger than 2 TiB.

Meanwhile I got a response from a AmigaOS 4 developer.

I documented the stuff as I understood it in the AmigaOS wiki:

| Disk size
|
| The RDB has a quite high limit on the maximum device size, but note that 
| currently each filesystem interprets the partition layout by itself.

| The raw, theoretical limit on the maximum device capacity is about 2^105 
| bytes:
|
| 32 bit rdb_Cylinders * 32 bit rdb_Heads * 32 bit rdb_Sectors * 512 
| bytes/sector for the HD size in struct RigidDiskBlock
|
| It's even much more if the sector size (rdb_BlockBytes and de_SizeBlock) 
| is larger than 512 bytes, but AmigaOS 4.1 doesn't support anything but 
| 512 bytes/sector HDs yet.
|
| Partition size
|
| For the partitions the maximum size is:
| 32 bit (de_HighCyl + 1 - de_LowCyl) (to get the partition size) * 32 bit 
| de_Surfaces * 32 bit de_SectorsPerTrack * 512 bytes/sector in struct 
| DosEnvec (=pb_Environment[]) in struct PartitionBlock.
|
| That's from the physical drive part, the actual disk size limit for the 
| partitions may be much smaller depending on the partitioning software, 
| if it's only using the logical sizes instead, which is likely the case, 
| it's only 8 ZiB with 512 bytes/sector: 32 bit rdb_HiCylinder * 32 bit 
| rdb_CylBlocks * 512 bytes/sector = 2^73 bytes. For using the logical 
| sizes using simple uint64 calculations (with some overflow checks) should 
| be enough, for more a math library with support for larger integers 
| needs to be used which probably no partitioning software does.
|
| But note: Nothing in struct RigiDiskBlock is used by the file systems for 
| mounting the partitions, they only get the information from the struct 
| PartitionBlock blocks, it's only a problem for the partitioning software 
| creating the partitions correctly - as soon as there are HDs larger than 
| 8 ZB while still using 512 bytes/sector if that ever happens.

http://wiki.amigaos.net/index.php/RDB

Please note that the documentation there might be updated or corrected in 
the future. But thats the current state.

> Note that in your profile-binary.img, the field is 0x200, i.e. 512
> bytes per block,
> so I'll have to get a deeper look into your RDB first...

I am a bit overwhelmed by Joanne´s analysis. I didn´t yet take time to 
completely read and try to understand it. I first wanted to get this 
information out.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
