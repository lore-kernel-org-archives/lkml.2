Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0C0Agc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 20:36:32 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:48893 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab0C0Agb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 20:36:31 -0400
Date: Fri, 26 Mar 2010 19:36:07 -0500
From: David Fries <david@fries.net>
To: Jeff Garzik <jeff@garzik.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.34-rc2 breaks via82cxxx Host Protected Area
Message-ID: <20100327003607.GC2559@spacedout.fries.net>
References: <20100326232104.GA10769@spacedout.fries.net> <4BAD4D6A.3010004@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAD4D6A.3010004@garzik.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 26 Mar 2010 19:36:10 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 08:12:26PM -0400, Jeff Garzik wrote:
> On 03/26/2010 07:21 PM, David Fries wrote:
>> The kernel fails to see the entire disk with 2.6.34-rc2 with VIA
>> vt82c586b chipset.  I tracked it down to commit
>> f931a5d5785d7b7c44871bd7ad2762e29dfddf29 "via82cxxx: workaround h/w
>> bugs" and reverting just that one solves the problem, or just
>> commenting out just one outb write in that change.
>>
>> via82cxxx 0000:00:07.1: VIA vt82c586b (rev 41) IDE UDMA33
>> via82cxxx 0000:00:07.1: IDE controller (0x1106:0x0571 rev 0x06)
>> via82cxxx 0000:00:07.1: not 100% native mode: will probe irqs later
>>
>> Note the kernel panic is intentional as I'm given the test kernel an
>> invalid root device, so that I can suspend to disk, try a kernel,
>> resume and pick up where I left off.  It does have a side benefit of
>> dumping the size of all partitions.
>>
>> 2.6.34-rc2 unmodified, fails and sees 30985416 KiB for the last
>> partition.
>> ide-gd driver 1.18
>> hda: max request size: 128KiB
>> hda: 66055248 sectors (33820 MB) w/7936KiB Cache, CHS=65531/16/63
>> hda: cache flushes supported
>>   hda: hda1 hda2 hda3
>> hda: p3 size 236037312 exceeds device capacity, enabling native capacity
>> hda: p3 size 236037312 exceeds device capacity, limited to end of disk
>> ide-cd driver 5.00
>> ...
>> Please append a correct "root=" boot option; here are the available partitions:
>> 0300        33027624 hda driver: ide-gd
>>    0301           49391 hda1
>>    0302         1992816 hda2
>>    0303        30985416 hda3
>> Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(22,2)
>>
>> 2.6.34-rc2 with patch revered, correct size 118018656
>> ide-gd driver 1.18
>> hda: max request size: 128KiB
>> hda: Host Protected Area detected.
>>          current capacity is 66055248 sectors (33820 MB)
>>          native  capacity is 240121728 sectors (122942 MB)
>> hda: 66055248 sectors (33820 MB) w/7936KiB Cache, CHS=65531/16/63
>> hda: cache flushes supported
>>   hda: hda1 hda2 hda3
>> hda: p3 size 236037312 exceeds device capacity, enabling native capacity
>> hda: detected capacity change from 33820286976 to 122942324736
>> ide-cd driver 5.00
>> 0300       120060864 hda driver: ide-gd
>>    0301           49391 hda1
>>    0302         1992816 hda2
>>    0303       118018656 hda3
>> Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(22,2)
>>
>> Here are two debug patches, the first adds debug prints and the second
>> disables the problematic write, I  have the output of both included.
>>
>>> From dac7d14ce1f227d8a084c3ec218ea1430bffdc57 Mon Sep 17 00:00:00 2001
>> From: David Fries<david@fries.net>
>> Date: Thu, 25 Mar 2010 19:51:31 -0500
>> Subject: [PATCH 1/2] fails: add print messages
>>
>> add print messages for debugging
>> ---
>>   drivers/ide/via82cxxx.c |    5 +++++
>>   1 files changed, 5 insertions(+), 0 deletions(-)
>
> Does libata + pata_via work, if you pass ignore_hpa=1 module option to  
> libata?
>
> 	Jeff

No, here is the output with ignore_hpa=1 on the command line.  I also
don't see any difference with it not on the command line.

scsi0 : pata_via
scsi1 : pata_via
ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0xe400 irq 14
ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0xe408 irq 15
ata1.00: HPA detected: current 66055248, native 240121728
ata1.00: ATA-7: Maxtor 6Y120P0, YAR41BW0, max UDMA/133
ata1.00: 66055248 sectors, multi 16: LBA 
ata1.00: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6Y120P0   YAR4 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 66055248 512-byte logical blocks: (33.8 GB/31.4 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sda: p3 size 236037312 exceeds device capacity, limited to end of disk
sd 0:0:0:0: [sda] Attached SCSI disk
ata2.01: ATAPI: PLEXTOR CD-R   PX-W4012A, 1.06, max UDMA/33
ata2.01: configured for UDMA/33
scsi 1:0:1:0: CD-ROM            PLEXTOR  CD-R   PX-W4012A 1.06 PQ: 0 ANSI: 5
...
VFS: Cannot open root device "1602" or unknown-block(22,2)
Please append a correct "root=" boot option; here are the available partitions:
0800        33027624 sda driver: sd
  0801           49391 sda1
  0802         1992816 sda2
  0803        30985416 sda3
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(22,2)

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
