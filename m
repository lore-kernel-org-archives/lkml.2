Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab0JWM5a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 08:57:30 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46243 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682Ab0JWM52 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 08:57:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=eSGawLIt0FPef8gzjwnkBJW5/Bc5mxSCHOT0/XZqdeDUvUr4xFve29UYXHfqOpGHzY
         tdV0EvAeYobyJO6wM6s9hS9BDgfUZmosx9gK6MROtymD30fSVU9CH5FXASlhuXauts+h
         4RbsdEZ7XzeJwsgWc9oVsWgG+CfFoaOXA+Udk=
MIME-Version: 1.0
In-Reply-To: <4CC24186.1040001@teksavvy.com>
References: <AANLkTik02CcVyzn+fMH+VxuUmwwNLZq9qM0MPz81E+1h@mail.gmail.com>
	<4CC24186.1040001@teksavvy.com>
Date: Sat, 23 Oct 2010 13:57:26 +0100
Message-ID: <AANLkTi=s9R-OEJAPRpoxoSkFY8MWhc22Pn_gcwCzxY=H@mail.gmail.com>
Subject: Re: sata_mv and Highpoint RocketRAID 230x, corruption?
From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
To: Mark Lord <kernel@teksavvy.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the clarification. Since I've (stupidly enough) partitioned
the drives from 1MB until the end, I'm most likely affected by this
stupid RAID BIOS.
That might explain why I'm getting this error (full dmesg at
http://pastebin.ca/1970873 ):

ata2.00: status: { DRDY }
ata2: hard resetting link
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: configured for UDMA/133
ata2.00: device reported invalid CHS sector 0
sd 1:0:0:0: [sdb]  Result: hostbyte=0x00 driverbyte=0x08
sd 1:0:0:0: [sdb]  Sense Key : 0xb [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
        00 00 00 00
sd 1:0:0:0: [sdb]  ASC=0x0 ASCQ=0x0
sd 1:0:0:0: [sdb] CDB: cdb[0]=0x28: 28 00 e7 70 c8 e8 00 05 40 00
end_request: I/O error, dev sdb, sector 3882928360
md/raid:md0: read error not correctable (sector 3882926312 on sdb1).
md/raid:md0: Disk failure on sdb1, disabling device.
<1>md/raid:md0: Operation continuing on 2 devices.
md/raid:md0: read error not correctable (sector 3882926320 on sdb1).
md/raid:md0: read error not correctable (sector 3882926328 on sdb1).
md/raid:md0: read error not correctable (sector 3882926336 on sdb1).
md/raid:md0: read error not correctable (sector 3882926344 on sdb1).
md/raid:md0: read error not correctable (sector 3882926352 on sdb1).
md/raid:md0: read error not correctable (sector 3882926360 on sdb1).
md/raid:md0: read error not correctable (sector 3882926368 on sdb1).
md/raid:md0: read error not correctable (sector 3882926376 on sdb1).
md/raid:md0: read error not correctable (sector 3882926384 on sdb1).

And:

[root@ion ~]# fdisk -l /dev/sdb

Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes
81 heads, 63 sectors/track, 765633 cylinders, total 3907029168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x73ad1b41

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048  3907029167  1953513560   fd  Linux raid autodetect
[root@ion ~]#

So the sectors are the last ones of the drive, the raid controllers
BIOS corrupted my data... my mdadm RAID5 array is forever broken, I
can't rebuild it!

The only option that is left is to assemble the array with --force and
save all the data, repartition the drives (1MB until (capacity -
2GB)), and build the array from scratch?

Now, where to store 6 terabytes of data while rebuilding everything. :-/

Cheers


On 23 October 2010 02:59, Mark Lord <kernel@teksavvy.com> wrote:
> On 10-10-20 04:03 PM, Mathias Burén wrote:
> ..
>>
>> I'm currently not using the BIOS of the raid controller for anything
>> else then staggered disk spinup. The HDD partitions start at sector
>> 2048 (to get a 1MB alignment since they're 4k sector drives, WD20EARS)
>> and end at the last sector.
>> What I'm worried about is the corruption mentioned in dmesg, is this
>> explained somewhere in more detail? Google didn't reveal much. Am I in
>> danger?
>
> Yes.  Just repartition the drives to avoid the final 2GB of each drive,
> and then you'll be safe.
>
> The RocketRaid BIOS that I examined here a couple of years ago,
> liked to write "metadata" over top of whatever was in certain sectors
> near the end of the drive.  EVEN FOR NON-RAID DRIVES.
>
> I think it was the last even (power-of-two) multiple of 1GB or something,
> so if you leave the final 2GB untouched, you're guaranteed to avoid it.
>
> Thus the recommendation.
>
> Cheers
>
