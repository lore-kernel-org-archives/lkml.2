Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab2FRB2z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 21:28:55 -0400
Received: from elasmtp-banded.atl.sa.earthlink.net ([209.86.89.70]:51281 "EHLO
	elasmtp-banded.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751852Ab2FRB2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 21:28:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=UDfKBg/D9I8M9gLjcYb6nz0BQaO1DxzEvMlCg643dbRRHhZzj3CVNeck9dDQTMw2;
  h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4FDE8450.6090907@earthlink.net>
Date: Sun, 17 Jun 2012 18:28:48 -0700
From: jdow <jdow@earthlink.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-m68k@vger.kernel.org
Subject: Re: Partitions: Amiga RDB partition on 2 TB disk way too big, while
 OK in AmigaOS 4.1
References: <201206170841.20222.Martin@lichtvoll.de> <CAMuHMdWY7=2nJDUjQFGPhdOAFGYeUsnvgPcaEvB2Gxf7P=E+Ug@mail.gmail.com> <4FDE46E4.7020009@earthlink.net> (sfid-20120617_231310_643468_CCA19A89) <201206172320.10272.Martin@lichtvoll.de>
In-Reply-To: <201206172320.10272.Martin@lichtvoll.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-ELNK-Trace: bb89ecdb26a8f9f24d2b10475b571120841c09a80b8d9eb65eb78d41e22e4f02404f858e97376b17350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 208.127.11.14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/06/17 14:20, Martin Steigerwald wrote:
> Am Sonntag, 17. Juni 2012 schrieb jdow:
>> On 2012/06/17 09:36, Geert Uytterhoeven wrote:
>>> On Sun, Jun 17, 2012 at 2:58 PM, Martin Steigerwald
> <Martin@lichtvoll.de> wrote:
>>>> Am Sonntag, 17. Juni 2012 schrieb jdow:
>>>> | JXFS 64 bit file system
>>>> |
>>>> | With AmigaOS 4.x a new file system has been introduced called
>>>> | JXFS. It is a totally new 64 bit file system that supports
>>>> | partitions up to 16 TB in size. It is a modern journalling file
>>>> | system, which means that it reduces data loss if data writes to
>>>> | the disk are interrupted. It is the fastest and most reliable
>>>> | file system ever created for AmigaOS.
>>>>
>>>> http://www.amigaos.net/content/1/features
>>>>
>>>> Well I asked AmigaOS 4 developers about this issue as well. Lets see
>>>> what they say about 2 TB limits.
>>>
>>> 16 TB = 2 TB * 8. Perhaps they increased the block size from 512 to
>>> 4096?
>>>
>>> block/partitions/amiga.c reads the block size from
>>> RigidDiskBlock.rdb_BlockBytes,
>>> but after conversion to 512-byte blocks, all further calculations are
>>> done on "int", so it will overflow for disks larger than 2 TiB.
>>>
>>> Note that in your profile-binary.img, the field is 0x200, i.e. 512
>>> bytes per block,
>>> so I'll have to get a deeper look into your RDB first...
> […]
>> Note that the work I did on the Linux RDB code eons ago took full
>> cognizance of the physical and virtual block sizes.
> […]
>> I've asked Martin for a digital copy of his RDBs and what he thinks the
>> partition(s) should look like. I should also be told whether the disk
>> is supposed to be solely Amiga OSs or not. I gather it's not.
>
> Its all in the bug report. profile-binary.img should be it.
>
> Its small so I attach it.
>
> Meanwhile I try to get the currently supported maximum disk size out from
> the OS 4 developers. Maybe JXFS is playing tricks that other filesystems do
> not play or simply has a different implementation.
>
> Thanks,

I've sent Jens a proposed fix changing these lines in amiga.c.
===8<--- was
         struct PartitionBlock *pb;
         int start_sect, nr_sects, blk, part, res = 0;
         int blksize = 1;        /* Multiplier for disk block size */
===8<--- becomes changing line 338 into lines 338-339
         struct PartitionBlock *pb;
         sector_t start_sect, nr_sects;
         int blk, part, res = 0;
         int blksize = 1;        /* Multiplier for disk block size */
===8<---

(I'm working without proper tools at the moment or I'd make a real diff.
Sorry.)

This fix may not be complete. The RDBs contain provisions for describing
the physical disk block size and how many physical blocks are used in a
file system's logical blocks. This MAY not work quite right large physical
block sizes.

{^_^}   Joanne Dow
