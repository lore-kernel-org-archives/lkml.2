Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966000Ab0CPDwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 23:52:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:35886 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937432Ab0CPDv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 23:51:57 -0400
Message-ID: <4B9EFFB3.3080403@kernel.org>
Date: Tue, 16 Mar 2010 12:49:07 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Daniel.Taylor@wdc.com, jeff@garzik.org, kernel@teksavvy.com,
       tytso@mit.edu, hpa@zytor.com, hirofumi@mail.parknet.co.jp,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, matthew@wil.cx,
       aschnell@suse.de, knikanth@suse.de, jdelvare@suse.de,
       greg.freemyer@gmail.com, martin.petersen@oracle.com, swmike@swm.pp.se,
       James.Bottomley@suse.de, gombasg@digikabel.hu, js@sig21.net,
       ctpm@ist.utl.pt, damian@tvk.rwth-aachen.de, gene.heskett@verizon.net,
       snitzer@redhat.com, hch@infradead.org, kzak@redhat.com, mjt@tls.msk.ru,
       david@fromorbit.com, hmh@hmh.eng.br, mrmazda@earthlink.net,
       soltys@ziu.info, arnd@arndb.de, david@lang.hm, bzolnier@gmail.com
Subject: ATA 4 KiB sector issues, 3rd draft
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Mar 2010 03:49:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is the third draft mostly updated with the information gathered
from the last discussion thread.  The biggest changes are 1. Windows
XP is generally fine with any alignment 2. upstream tools have already
been updated to do proper aligning.  So, the situation seems much
better than I originally feared and as long as new distro releases
ship with properly updated tools, everything should work.

4KiB logical sector size support and whether any tool would have
problem with >32bit LBAs (>2TiB w/ 512 byte logical sector size) is
still unclear to me.  If you know, please let me know.

I'll update the wiki page accordingly soonish.

  http://ata.wiki.kernel.org/index.php/ATA_4_KiB_sector_issues

Thank you.


Background
==========

Up until recently, all ATA hard drives have been organized in 512byte
sectors.  For example, my 500GB or 477GiB hard drive is organized of
976773168 512 byte sectors numbered from 0 to 976773167.  This is how
a drive communicates with the driver.  When the operating system wants
to read 32 KiB of data at 1MiB position, the driver asks the drive to
read 64 sectors from LBA (Logical block address, sector number) 2048.

Because each sector should be addressable, readable and writable
individually, the physical medium also is organized in the same sized
sectors.  In addition to the area to store the actual data, each
sector requires extra space for book keeping - inter-sector space to
enable locating and addressing each sector and ECC data to detect and
correct inevitable raw data errors.

As the densities and capacities of hard drives keep growing, stronger
ECC becomes necessary to guarantee acceptable level of data integrity
increasing the space overhead.  In addition, in most applications,
hard drives are now accessed in units of at least 8 sectors or 4096
bytes and maintaining 512 byte granularity has become somewhat
meaningless.

This reached a point where enlarging the sector size to 4096 bytes
would yield measurably more usable space given the same raw data
storage size and hard drive manufacturers are transitioning to 4KiB
sectors.

Anandtech has a good article which illustrates the background and
issues with pretty diagrams[1].


Physical vs. Logical
====================

Because the 512 byte sector size has been around for a very long time
and upto ATA/ATAPI-7 the sector size was fixed at 512 bytes, the
sector size assumption is scattered across all the layers -
controllers or bridge chips snooping commands, BIOSs, boot codes,
drivers, partitioners and system utilities, which makes it very
difficult to change the sector size from 512 byte without breaking
backward compatibility massively.

As a workaround, the concept of logical sector size was introduced.
The physical medium is organized in 4KiB sectors but the firmware on
the drive will present it as if the drive is composed of 512 byte
sectors thus making the drive behave as before, so if the driver asks
the hard drive to read 64 sectors from LBA 2048, the firmware will
translate it and read 8 4KiB sectors from hardware sector 256.  As a
result, the hard drive now has two sector sizes - the physical one
which the physical media is actually organized in, and the logical one
which the firmware presents to the outside world.

A straight forward example mapping between physical sector and LBA
would be

  LBA = 8 * phys_sect


Alignment problem on 4KiB physical / 512 logical drives
=======================================================

This workaround keeps older hardware and software working while
allowing the drive to use larger sector size internally.  However, the
discrepancy between physical and logical sector sizes creates an
alignment issue.  For example, if the driver wants to read 7 sectors
from LBA 2047, the firmware has to read hardware sector 255 and 256
and trim leading 7*512 bytes and tailing 512 bytes.

For reads, this isn't an issue as drives read in larger chunks anyway
but for writes, the drive has to do read-modify-write to achieve the
requested action.  It has to first read hardware sector 255 and 256,
update requested parts and then write back those sectors which can
cause significant performance degradation[2].

The problem is aggravated by the way DOS partitions[3] have been laid
out traditionally.  For reasons dating back more than two decades,
they are laid out considering something called disk geometry which
nowadays are arbitrary values with a number of restrictions for
backward compatibility accumulated over the years.  The end result is
that until recently (most Linux variants and upto Windows XP) the
first partition ends up on sector 63 and later ones on cylinder
boundaries where each cylinder usually is composed of 255 * 63
sectors.

Most modern filesystems generate 4KiB aligned accesses from the
partition it is in.  If a drive maps 4KiB physical sectors to 512 byte
logical sectors from LBA0, the filesystem in the first partition will
always be misaligned and filesystems in later partitions are likely to
be misaligned too.


Solving the alignment problem on 4KiB physical / 512 logical drives
===================================================================

There are multiple ways which attempt to solve the problem.

S-1. Yet another workaround from the firmware - offset-by-one.

  Yet another workaround which can be done by the firmware is to
  offset physical to logical mapping by one logical sector such that
  LBA 63 ends up on physical sector boundary, which aligns the first
  partition to physical sectors without requiring any software update.
  The example mapping between phys_sector and LBA becomes

    LBA = 8 * phys_sect - 1

  The leading 512 bytes from phys_sect 0 is not used and LBA 0 starts
  from after that point.  phys_sect 1 maps to LBA 7 and phys_sect 8 to
  63, making LBA 63 aligned on hardware sector.

  Although this aligns only the first partition, for many use cases,
  especially the ones involving older software, this workaround was
  deemed useful and some recent drives with 4KiB physical sectors are
  equipped with a dip switch to turn on or off offset-by-one mapping.

S-2. The proper solution.

  Correct alignments for all partitions can't be achieved by the
  firmware alone.  The system utilities should be informed about the
  alignment requirements and align partitions accordingly.

  The above firmware workaround complicates the situation because the
  two different configurations require different offsets to achieve
  the correct alignments.  ATA/ATAPI-8 specifies a way for a drive to
  export the physical and logical sector sizes and the LBA offset
  which is aligned to the physical sectors.

  In Linux, these parameters are exported via the following sysfs
  nodes.

    physical sector size	: /sys/block/sdX/queue/physical_block_size
    logical sector size		: /sys/block/sdX/queue/logical_block_size
    alignment offset		: /sys/block/sdX/alignment_offset

  Let the physical sector size be PSS, logical sector size LSS and
  alignment offset AOFF.  The system software should place partitions
  such that the starting LBAs of all partitions are aligned on

    (n * PSS + AOFF) / LSS

  For 4KiB physical sector offset-by-one drives, PSS is 4096, LSS 512
  and AOFF 3584 and with n of 7 the above becomes,

    (7 * 4096 + 3584) / 512 == 63

  making sector 63 an aligned LBA where the first partition can be
  put, but without the offset-by-one mapping, AOFF is zero and LBA 63
  is not aligned.

  With the above new alignment requirement in place, it becomes
  difficult to honor the legacy one - first partition on sector 63 and
  all other partitions on cylinder boundary (255 * 63 sectors) - as
  the two alignment requirements contradict each other.  This might be
  worked around by adjusting how LBA and CHS addresses are mapped but
  the disk geometry parameters are hard coded in some places and there
  is no reliable way to communicate custom geometry parameters.


Complications
=============

Unfortunately, there are complications.

C-1. The standard is not and won't be followed as-is.

  Some of the existing BIOSs and/or drivers can't cope with drives
  which report 4KiB physical sector size.  To work around this, some
  drive models lie that its physical sector size is 512 bytes when the
  actual configuration is 4KiB without offsetting.

  This nullifies the provisions for alignment in the ATA standard but
  results in the correct alignment for Windows Vista and 7.  OS
  behaviors will be described further later.

  For these drives, which are likely to continue to be shipped for the
  foreseeable future, traditional LBA 63 and cylinder based aligning
  results in misalignment.

C-2. The 2TiB barrier and the possibility for 4KiB logical sector size.

  The DOS partition format uses 32 bit for the starting LBA and the
  number of sectors and, reportedly, 32 bit Windows XP shares the
  limitation.  With 32 bit addressing and 512 byte logical sector
  size, the maximum addressable sector + 1 is at

    2^32 * 2^9 == 2^41 == 2TiB

  The DOS partition format allows a partition to reach beyond 2TiB as
  long as the starting LBA is under 2TiB; however, both Windows XP and
  and the Linux kernel (at least upto v2.6.33) refuse such partition
  configurations.

  With the right combination of host controller, BIOS and driver, this
  barrier can be overcome by enlarging the logical sector size to
  4KiB, which will push the barrier out to 16TiB.  On the right
  configuration, Windows XP is reportedly able to address beyond the
  2TiB barrier with a DOS partition and 4KiB logical sector size.
  Linux kernel upto v2.6.33 doesn't work under such configurations but
  a patch to make it work is pending[4].

  This might also be somewhat beneficial for operating systems which
  don't suffer from this limitation.  A different partition format -
  GPT[5] - should be used beyond 2^32 sectors, which could harm
  compatibility with other operating systems which don't recognize the
  new format.

  As mentioned previously, 512 byte sector assumption has existed for
  a very long time and changing it is might cause various
  compatibility problems at different layers.  It has been suggested
  that 4KiB logical sector size might be primarily useful for external
  (USB or otherwise) drives.


Windows
=======

As hard drive vendors aim for performance and compatibility in modern
Windows environments, it is worthwhile to investigate how Windows
behaves and partitions with different alignment requirements.

Although there seem to be some issues with certain BIOS settings[6],
any releases after and including Windows XP do not depend on
traditional partition alignment and can boot from partitions with any
alignment.  The reported problem seems to be caused by BIOS trying to
guess geometry by reading from the partition table instead of using
the de-facto geometry of 255 * 63 and can be worked around by either
changing BIOS configuration or applying a hotfix.

It is reported that Windows 2000 depends on the traditional partition
layout and will not work properly on partitions aligned differently.
When partitioning for Windows 2000, it will be necessary to follow
traditional partition layout; however, given the largely diminished
Windows 2000 user-base, this won't be a big problem.  Having a way to
manually choose traditional alignment should be enough.

When asked to partition hard drives, up until Windows XP, Windows
followed the traditional layout - the first partition on LBA 63 and
the others on cylinder boundaries where a cylinder is defined as 255
tracks with 63 sectors each.  Windows Vista and 7 align partitions
differently.  As the two behave similarly, only 7's behavior is shown
here.  These partition tables are created by Windows 7 RC installer on
blank disks.

W-1. 512 byte physical and logical sector drive.

  ST FIRST  T  LAST   LBA      NBLKS
  80 202100 07 df130c 00080000 00200300
  00 df140c 07 feffff 00280300 00689e12
  00 000000 00 000000 00000000 00000000
  00 000000 00 000000 00000000 00000000

  Part0:	FIRST	C    0	H   32	S   33	: 2048		(63 sec/trk)
		LAST	C   12	H  223	S   19	: 206847	(255 heads/cyl)
		LBA	2048 + 204800 = 206848

  Part1:	FIRST	C   12	H  223	S   20	: 206848
		LAST	C 1023	H  254	S   63	: E
		LBA	206848 + 312371200 = 312578048

  Both aligned at (2048 * n).  Part 1 not aligned to cylinder.

W-2. 4KiB physical and 512 byte logical sector drive without offset-by-one.

  ST FIRST  T  LAST   LBA      NBLKS
  80 202100 07 df130c 00080000 00200300
  00 df140c 07 feffff 00280300 00b83f25
  00 000000 00 000000 00000000 00000000
  00 000000 00 000000 00000000 00000000

  Part0:	FIRST	C    0	H   32	S   33	: 2048		(63 sec/trk)
		LAST	C   12	H  223	S   19	: 206847	(255 heads/cyl)
		LBA	2048 + 204800 = 206848

  Part1:	FIRST	C   12	H  223	S   20	: 206848
		LAST	C 1023	H  254	S   63	: E
		LBA	206848 + 624932864 = 625139712

  Both aligned at (2048 * n).  Part 1 not aligned to cylinder.

W-3. 4KiB physical and 512 byte logical sector drive with offset-by-one.

  ST FIRST  T  LAST   LBA      NBLKS
  80 202800 07 df130c 07080000 f91f0300
  00 df1b0c 07 feffff 07280300 f9376d74
  00 000000 00 000000 00000000 00000000
  00 000000 00 000000 00000000 00000000

  Part0:	FIRST	C    0	H   32	S   40	: 2055		(63 sec/trk)
		LAST	C   12	H  223	S   19	: 206847	(255 heads/cyl)
		LBA	2055 + 204793 = 206848

  Part1:	FIRST	C   12	H  223	S   27	: 206855
		LAST	C 1023	H  254	S   63	: E
		LBA	206855 + 1953314809 = 1953521664

  Both aligned at (2048 * n + 7).  Part 1 not aligned to cylinder.

The partitioner seems to be using 1M as the basic alignment unit and
offsetting from there if explicitly requested by the drive and there
is no difference between handling of 512 byte and 4KiB drives, which
explains why C-1 works for hard drive vendors.

In all cases, the partitioner ignores both the first partition on LBA
63 and the others on cylinder boundary requirements while still using
the same 255 * 63 cylinder size.  Also, note that in W-3, both part 0
and 1 end up with odd number of sectors.  It seems that they simply
decided to completely break away from the traditional layout, which is
understandable given that there really isn't one good solution which
can cover all the cases and that the default larger alignment benefits
earlier SSDs.

Windows Vista basically shows the same behavior.  Vista was tested by
creating two partitions using the management tool.  Test data is
available at [7].

  *-alignment_offset	: alignment_offset reported by Linux kernel
  *-fdisk		: fdisk -l output
  *-fdisk-u		: fdisk -lu output
  *-hdparm		: hdparm -I output
  *-mbr			: dump of mbr
  *-part		: decoded partition table from mbr

Please note that hdparm is misreporting the alignment offset.  It
should be reporting 512 instead of 256 for offset-by-one drives.  This
problem is fixed by version 9.28.


Where Linux stands
==================

Considering all the factors, the best workable solution seems to be
doing what Windows is doing.  Hard drive and SSD vendors are focusing
on compatibility and performance on recent Windows releases and are
happy to do things which break the standard defined mechanism as shown
by C-1, so parting away from what Windows does would be unnecessarily
painful.  Other than giving an option to use traditional layout for
Windows releases <= 2000, always using larger alignment will achieve
properly aligned partitions and acceptable compatibility.

Most of information in this section comes from the discussion thread
reviewing an early draft of this document[8] and the following two
documents.

 I/O Limits: block sizes, alignment and I/O hints - Mike Snitzer [9]
 Linux & Advanced Storage Interfaces - Martin K. Petersen [10]

L-1. Kernel support

Various storage parameters including physical and logical sector sizes
and alignment requirements are exported via IO limits and storage
topology support.  The kernel gathers all the relevant parameters,
combine them according to storage organization and export them to
userspace.  As of v2.6.33, the support covers most of Linux I/O stacks
including but not limited to ATA and any mass storage device driven by
the SCSI disk driver and complex devices composed using MD, DM and
LVM.  IO topology support is being extended to cover virtualized
storage devices.

As of v2.6.33, Linux ATA drivers do not support drives with 4KiB
logical sector size although there is a development branch containing
experimental support[11].  For ATA drives connected via bridges to
different buses - USB and IEEE 1394, as long as the bridges support
4KiB logical sector size correctly, the SCSI disk driver can handle
them.

There currently is a limitation in DOS partition handling which
prevents DOS partitions to grow over 2TiB even with 4KiB sector size
but this is being worked on[4].

L-2. Userspace tools status (thanks to Karel Zak[12])

* libblkid provides unified API to topology information, it supports:
  * ioctls (kernel >= 2.6.32)
  * sysfs (kernel >= 2.6.31)
  * stripe chunk size and stripe width for DM, MD. LVM and evms on old
    kernels

* libparted and fdisk are linked against libblkid

* fdisk supports 4KiB logical sector size (util-linux-ng >= 2.15
* fdisk supports 4KiB physical sector size (util-linux-ng >= 2.17)
* fdisk uses 1MiB alignment (or more if optimal I/O size is bigger)
  and alignment_offset for all partitions in non-DOS mode
  (util-linux-ng >= 2.17.1)

* parted supports 4KiB physical sector size
* parted uses 1MiB alignment for disks with unknown topology, disks
  with topology information are aligned to optimal (or minimum) I/O
  size (parted >= 2.1)
* The latest news on parted status can be found here[13]
 
* EFI GPT code in the kernel has been updated to works properly with
  4KiB sectors (kernel >= 2.6.33)

* mkfs.{ext,xfs,gfs2,ocfs2} have been updated to work properly with
  topology information, mkfs.{ext,xfs} are linked against libblkid for
  compatibility with old kernel (for stripe chunk size / width)

* Fedora-13/RHEL6 installer uses libparted with 4KiB support

* alignment_offset & 4KiB support is planned for LUKS (cryptsetup)

Overall, distributions being released after Spring of 2010 with the
updated tools shouldn't have much problem aligning and dealing with
4KiB physical sector drives.  If you are working on or testing a
distro, please make sure all storage related tools are up-to-date and
aligning disks properly.

L-3. Booting and boot loaders

On traditional PC configurations, Linux booting is done in several
stages.  The BIOS should be able to probe and access the drive.  It
reads the MBR off the drive and pass control to it.  MBR contains
initial chunk of bootloader and reads more data (often off the same
drive) necessary for booting - usually further stages of boot loader.
This process repeats as necessary until the kernel and module images
are loaded and control is passed to it.  There can be different issues
at various layers.

At the BIOS level, the following problems have been reported or are
suspected.

* Some reportedly have issues accessing drives which report hardware
  sector size which is larger than 512 bytes even if the logical
  sector size remains 512 bytes (see C-1).

* INT13h EDD uses 64bit LBA but some BIOSs might have problems with
  accessing drives which have higher capacity than 2TiB (32 bit
  limit).

* Depending on the BIOS configuration, some read the partition table
  and solve CHS/LBA equations to figure out the geometry used during
  partitioning which seems to cause compatibility problems with
  partitions which don't consider geometry alignment at all[6].

* It's reasonable to suspect that some (or rather, many) BIOSs
  wouldn't be able to access or boot off ATA drives with 4KiB logical
  sector size.

Despite the various problems, in general, all a BIOS needs to boot
from a hard drive is reading the MBR off it and as long as logical
block size remains at 512 bytes, most BIOSs should be able to boot off
large and/or differently aligned drives.

On top of working BIOS access to the drives, boot loaders may have
additional dependencies.  For example, GRUB needs to understand the
partition table format and the filesystem itself to retrieve the
kernel image and modules, while LILO hard codes LBAs of needed blocks
and thus doesn't care about how the blocks are logically organized.

* As long as the BIOS can access the hard drive, LILO should be able
  to boot regardless of partition table format or alignment.  However,
  it is yet unknown whether there would be hidden issues with >2TiB
  hard drives or 4KiB logical sector size (if you know or have tested,
  please let me know).

* GRUB is not affected by partition alignment.  According to GRUB2
  wiki Current Status page, it supports GPT and presumably >2TiB
  disks.  It is unclear how 4KiB logical sector size would work
  (please let me know).  Support status for GRUB legacy (0.9.x) is
  rather unclear but seems to require a patch to make GPT work.  >2TiB
  support status is unclear (again...).

* H. Peter Anvin reports that syslinux should work fine with any
  alignment and GPT with gptmbr.bin installed[14].  4KiB logical
  sector support has bit-rotted but he intends to update it[15].
  >2TiB support status is unclear (plz let me know).


Random thoughts and comments (mostly for distros)
=================================================

* All upstream partitioning tools have been updated properly regarding
  alignment.  They either already default to larger alignment or are
  scheduled to switch to it.  For new releases, please make sure all
  the tools are up-to-date and larger alignment rules are in effect.

  Windows >= XP wouldn't have any problem sharing or booting from
  partition prepared with larger alignment, so compatibility
  implications will not be major.  Providing a mechanism to force
  legacy cylinder alignment or describing a way to manually create
  partitions with legacy layout should be enough.

* In newer releases of fdisk (util-linux-ng >= 2.17.1), traditional
  cylinder based alignment can be requested by turning on DOS
  Compatibility flag (the 'c' command).

* In case INT13h EDD has problems accessing sectors beyond 2TiB, it
  would be better to put data necessary for booting inside a boot
  partition which is contained inside 2TiB limit.

* GPT is unavoidable for 512 byte logical sector drives which is
  larger than 2TiB and there are clear advantages of GPT such as
  better protection against corruption, lack of artificial
  distinctions between primary and extended/logical partitions.  When
  compatibility with older software is not an issue, it could be
  better to default to GPT.

* Drives >2TiB and 4KiB logical sector size support status seems
  unclear.  It will be great if we can get proper prototype hardware
  into upstream developers' hands and make sure software side is ready
  before the actual products hit the market.


Document history
================

* Mar 04 2010	Tejun Heo <tj@kernel.org>
	Initial draft.

* Mar 08 2010	Tejun Heo <tj@kernel.org>
	Updated according to comments from Daniel Taylor
	<Daniel.Taylor@wdc.com>.  Other minor updates.

* Mar 15 2010	Tejun Heo <tj@kernel.org>
	Updated according to various comments from discussions[8] on
	LKML and linux-ide.


References
==========

 [1] http://www.anandtech.com/storage/showdoc.aspx?i=3691
 [2] http://www.osnews.com/story/22872/Linux_Not_Fully_Prepared_for_4096-Byte_Sector_Hard_Drives
 [3] http://en.wikipedia.org/wiki/Master_boot_record
 [4] http://thread.gmane.org/gmane.linux.kernel/953981
 [5] http://en.wikipedia.org/wiki/GUID_Partition_Table
 [6] http://support.microsoft.com/kb/931760
 [7] http://userweb.kernel.org/~tj/partalign/
 [8] http://thread.gmane.org/gmane.linux.ide/45211
 [9] http://people.redhat.com/msnitzer/docs/io-limits.txt
[10] http://oss.oracle.com/~mkp/docs/linux-advanced-storage.pdf
[11] git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git sectsize
[12] http://article.gmane.org/gmane.linux.ide/45228
[13] http://git.debian.org/?p=parted/parted.git;a=blob;f=NEWS
[14] http://article.gmane.org/gmane.linux.ide/45293
[15] http://article.gmane.org/gmane.linux.ide/45214
