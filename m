Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab2FSTqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 15:46:15 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:48583 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2FSTqO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 15:46:14 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: jdow <jdow@earthlink.net>
Subject: Re: Partitions: Amiga RDB partition on 2 TB disk way too big, while OK in AmigaOS 4.1
Date: Tue, 19 Jun 2012 21:46:09 +0200
User-Agent: KMail/1.13.7 (Linux/3.5.0-rc3-fix-bug-43511+; KDE/4.8.3; x86_64; ; )
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-m68k@vger.kernel.org
References: <201206170841.20222.Martin@lichtvoll.de> <201206172320.10272.Martin@lichtvoll.de> <4FDE8450.6090907@earthlink.net> (sfid-20120618_100053_593503_16694734)
In-Reply-To: <4FDE8450.6090907@earthlink.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Message-Id: <201206192146.09327.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 18. Juni 2012 schrieb jdow:
> On 2012/06/17 14:20, Martin Steigerwald wrote:
> > Am Sonntag, 17. Juni 2012 schrieb jdow:
> >> On 2012/06/17 09:36, Geert Uytterhoeven wrote:
> >>> On Sun, Jun 17, 2012 at 2:58 PM, Martin Steigerwald
> > 
> > <Martin@lichtvoll.de> wrote:
> >>>> Am Sonntag, 17. Juni 2012 schrieb jdow:
> >>>> | JXFS 64 bit file system
> >>>> | 
> >>>> | With AmigaOS 4.x a new file system has been introduced called
> >>>> | JXFS. It is a totally new 64 bit file system that supports
> >>>> | partitions up to 16 TB in size. It is a modern journalling file
> >>>> | system, which means that it reduces data loss if data writes to
> >>>> | the disk are interrupted. It is the fastest and most reliable
> >>>> | file system ever created for AmigaOS.
> >>>> 
> >>>> http://www.amigaos.net/content/1/features
> >>>> 
> >>>> Well I asked AmigaOS 4 developers about this issue as well. Lets
> >>>> see what they say about 2 TB limits.
> >>> 
> >>> 16 TB = 2 TB * 8. Perhaps they increased the block size from 512 to
> >>> 4096?
> >>> 
> >>> block/partitions/amiga.c reads the block size from
> >>> RigidDiskBlock.rdb_BlockBytes,
> >>> but after conversion to 512-byte blocks, all further calculations
> >>> are done on "int", so it will overflow for disks larger than 2
> >>> TiB.
> >>> 
> >>> Note that in your profile-binary.img, the field is 0x200, i.e. 512
> >>> bytes per block,
> >>> so I'll have to get a deeper look into your RDB first...
> > 
> > […]
> > 
> >> Note that the work I did on the Linux RDB code eons ago took full
> >> cognizance of the physical and virtual block sizes.
> > 
> > […]
> > 
> >> I've asked Martin for a digital copy of his RDBs and what he thinks
> >> the partition(s) should look like. I should also be told whether
> >> the disk is supposed to be solely Amiga OSs or not. I gather it's
> >> not.
> > 
> > Its all in the bug report. profile-binary.img should be it.
> > 
> > Its small so I attach it.
> > 
> > Meanwhile I try to get the currently supported maximum disk size out
> > from the OS 4 developers. Maybe JXFS is playing tricks that other
> > filesystems do not play or simply has a different implementation.
> > 
> > Thanks,
> 
> I've sent Jens a proposed fix changing these lines in amiga.c.
> ===8<--- was
>          struct PartitionBlock *pb;
>          int start_sect, nr_sects, blk, part, res = 0;
>          int blksize = 1;        /* Multiplier for disk block size */
> ===8<--- becomes changing line 338 into lines 338-339
>          struct PartitionBlock *pb;
>          sector_t start_sect, nr_sects;
>          int blk, part, res = 0;
>          int blksize = 1;        /* Multiplier for disk block size */
> ===8<---
> 
> (I'm working without proper tools at the moment or I'd make a real
> diff. Sorry.)
> 
> This fix may not be complete. The RDBs contain provisions for
> describing the physical disk block size and how many physical blocks
> are used in a file system's logical blocks. This MAY not work quite
> right large physical block sizes.

Way better:

dmesg:

Jun 19 21:19:09 merkaba kernel: [ 7891.819552] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
Jun 19 21:19:09 merkaba kernel: [ 7891.821306] ata8.00: ATA-8: Hitachi HDS5C3020ALA632, ML6OA580, max UDMA/133
Jun 19 21:19:09 merkaba kernel: [ 7891.821315] ata8.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
Jun 19 21:19:09 merkaba kernel: [ 7891.823252] ata8.00: configured for UDMA/100
Jun 19 21:19:09 merkaba kernel: [ 7891.823589] scsi 7:0:0:0: Direct-Access     ATA      Hitachi HDS5C302 ML6O PQ: 0 ANSI: 5
Jun 19 21:19:09 merkaba kernel: [ 7891.824126] sd 7:0:0:0: [sdb] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
Jun 19 21:19:09 merkaba kernel: [ 7891.824440] sd 7:0:0:0: [sdb] Write Protect is off
Jun 19 21:19:09 merkaba kernel: [ 7891.824452] sd 7:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Jun 19 21:19:09 merkaba kernel: [ 7891.824531] sd 7:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jun 19 21:19:09 merkaba kernel: [ 7891.843284]  sdb: RDSK (512) sdb1 (LNX^@)(res 2 spb 1) sdb2 (JXF^D)(res 2 spb 1) sdb3 (DOS^C)
(res 2 spb 4)
Jun 19 21:19:09 merkaba kernel: [ 7891.844055] sd 7:0:0:0: [sdb] Attached SCSI disk


cat /proc/partitions:
major minor  #blocks  name
[…]
   8       16 1953514584 sdb
   8       17 1572864024 sdb1
   8       18  314572824 sdb2
   8       19   66076704 sdb3

1572864024 + 314572824 + 66076704 = 1953513552 which is below the complete
size of the disk.


Partition start analysis:

merkaba:~> file -sk /dev/sdb1
/dev/sdb1: sticky LVM2 PV (Linux Logical Volume Manager), UUID: ZXMECC-JAir-lX8Q-rLhS-W1cS-quwz-b3FXWp, size: 2000397877248
merkaba:~> file -sk /dev/sdb2
/dev/sdb2: sticky data
merkaba:~> file -sk /dev/sdb3
/dev/sdb3: sticky Amiga Inter FFS disk

merkaba:~> hd /dev/sdb2 | head
00000000  4a 58 46 04 11 1a 0f 0c  00 00 00 00 00 00 00 00  |JXF.............|
00000010  00 00 00 00 00 11 00 00  3e db 3d 54 40 00 00 00  |........>.=T@...|
00000020  00 00 00 00 00 00 00 00  00 00 01 77 00 10 80 00  |...........w....|
00000030  00 00 01 c2 00 10 e0 00  25 80 00 30 00 00 02 00  |........%..0....|
00000040  00 00 00 30 00 00 00 00  00 00 00 00 00 00 00 00  |...0............|
00000050  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000060  00 00 00 00 00 00 00 00  00 00 08 00 00 00 00 00  |................|
00000070  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000200  54 52 4f 4b ab ad b0 b1  00 00 00 01 00 00 00 00  |TROK............|

I don´t know the on-disk format for JXFS, but this could be it. JFX/04
pretty much looks like the DOS type for JXFS. Yes, thats it. JXF/04 is
the DOS type in use for JXFS as I verified by looking at a JFXS partition
with Media Toolbox.


amiga-fdisk looks the same as before:

merkaba:~> amiga-fdisk -l /dev/sdb
Disk /dev/sdb: 3 heads, 16 sectors, 81396441 cylinders, RDB: 0
Logical Cylinders from 43 to 81396440, 24576  bytes/Cylinder 

Device     Boot Mount   Begin      End     Size   Pri  BBlks    System
/dev/sdb1       *        43   65536043   1572864024     0      0  Linux native
/dev/sdb2       *    65536044   78643244   314572824     0      0  [unknown]
/dev/sdb3       *    78643245   81396440   66076704     0      0  Amiga FFS Int.

But obviously its right anyway: It seems to display the size in blocks,
not in cylinders.


Media Toolbox says:

LVM aka sdc1: 1500 GByte, 43 to 65536043 cyl, size 65536001 Zylinder
BAK aka sdc2: 300 GByte, 65536044 to 78643244 cyl, size 13107201 Zylinder
TAUSCH2 aka sdc3: 63,016 GByte, 78643245 to  81396440 cyl, didn´t note the size
here, but as far as I remember was okay as well

with

Blocks per cylinder: 48
Cylinders: 81396441

So thats:

65536001 * 48 / 2 = 1572864024

13107201 * 48 / 2 = 314572824

( 81396440 - 78643245 ) * 48 / 2 = 66076680

(I verified from a windowshot I made that 81396440 - 78643245 = 2753195
is indeed displayed by Media Toolbox as size of the partition)



So this is looking pretty good.

Many thanks, Joanne for your detective work and the fix.

Tested with:

martin@merkaba:~> cat /proc/version
Linux version 3.5.0-rc3-fix-bug-43511+ (martin@merkaba) (gcc version 4.7.0 (Debian 4.7.1-1) ) #1 SMP Tue Jun 19 14:31:56 CEST 2012


Tested-By: Martin Steigerwald <martin@lichtvoll.de>
Reviewed-By: Martin Steigerwald <martin@lichtvoll.de>


Patch from Joanne in diff format:

martin@merkaba:~/Computer/Merkaba/Kernel/linux-2.6> git diff HEAD~ | cat
diff --git a/block/partitions/amiga.c b/block/partitions/amiga.c
index 70cbf44..42d36f9 100644
--- a/block/partitions/amiga.c
+++ b/block/partitions/amiga.c
@@ -29,7 +29,8 @@ int amiga_partition(struct parsed_partitions *state)
        unsigned char *data;
        struct RigidDiskBlock *rdb;
        struct PartitionBlock *pb;
-       int start_sect, nr_sects, blk, part, res = 0;
+       sector_t start_sect, nr_sects;
+       int blk, part, res = 0;
        int blksize = 1;        /* Multiplier for disk block size */
        int slot = 1;
        char b[BDEVNAME_SIZE];


Jens, please take that patch. If you want I can prepare it further with above
testing report and some explaination as changelog and a From Joanne Dow
line ;). But it might be easier if you just take it as is and attribute it
to her. Feel free to use as much of my test report as you want for in
commit message. But I will copy this into the bug report anyway.

If you taken it, please tell me the commit id. I think this should go to
stable kernel since its a potential data loss issue and an isolated
overflow fix.


Only LVM is unhappy now, but thats to be expected since /dev/sdb1
that it used is now smaller than the whole disk as it was before with
the overflowing and truncating Amiga RDB code without Joanne´s fix.

merkaba:~> vgscan
  Reading all physical volumes.  This may take a while...
  /dev/sdb1: lseek 2000396746752 failed: Das Argument ist ungültig
  /dev/sdb1: lseek 2000396746752 failed: Das Argument ist ungültig
  /dev/sdb1: lseek 2000396746752 failed: Das Argument ist ungültig
  WARNING: Inconsistent metadata found for VG steigerwald - updating to use version 7
  /dev/sdb1: lseek 2000396746752 failed: Das Argument ist ungültig
  Automatic metadata correction failed
  Recovery of volume group "steigerwald" failed.
  Found volume group "merkaba" using metadata type lvm2


So I will now format the disk as GPT and use it only for Linux for now,
as I now have a different backup disk for the Amiga anyway.

So I have to recreate backups once again. Oh well, I possibly could
still boot an older kernel to access the LVM again.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
