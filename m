Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab2LDLyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 06:54:00 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44139
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752248Ab2LDLx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 06:53:58 -0500
Message-ID: <50BDE44F.9070001@kernel.dk>
Date: Tue, 04 Dec 2012 12:53:51 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Meelis Roos <mroos@linux.ee>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression in 3.7-rc8: block device size
References: <alpine.SOC.1.00.1212041126440.20927@math.ut.ee>
In-Reply-To: <alpine.SOC.1.00.1212041126440.20927@math.ut.ee>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-04 10:40, Meelis Roos wrote:
> This is on a couple of different Sun sparc64 machines with pata_ali IDE 
> controller. These machines work with no warnings in 3.7-rc7 and the same 
> userspace. On 3.7-rc8, I get warning about trying to access beyond end 
> of device:
> 
> [   65.219323] scsi0 : pata_ali
> [   65.258060] scsi1 : pata_ali
> [   65.296641] ata1: PATA max UDMA/66 cmd 0x1fe02010200 ctl 0x1fe02010218 bmdma 0x1fe02010220 irq 12
> [   65.413331] ata2: PATA max UDMA/66 cmd 0x1fe02010210 ctl 0x1fe02010208 bmdma 0x1fe02010228 irq 12
> [   66.136974] ata1.00: ATA-7: SAMSUNG SP1213N, TL100-30, max UDMA/100
> [   66.219314] ata1.00: 234493056 sectors, multi 0: LBA48
> [   66.647130] ata1.00: configured for UDMA/66
> [   66.702603] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG SP1213N  TL10 PQ: 0 ANSI: 5
> [   66.972381] sd 0:0:0:0: [sda] 234493056 512-byte logical blocks: (120 GB/111 GiB)
> [   67.127131] sd 0:0:0:0: [sda] Write Protect is off
> [   67.190117] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [   67.485709] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   67.611785]  sda: sda1 sda2 sda3 sda4 sda5
> [   67.668594] sd 0:0:0:0: [sda] Attached SCSI disk
> [   67.734334] EXT4-fs (sda2): couldn't mount as ext3 due to feature incompatibilities
> [   67.835795] EXT4-fs (sda2): couldn't mount as ext2 due to feature incompatibilities
> [   67.964315] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
> [   68.065081] VFS: Mounted root (ext4 filesystem) readonly on device 8:2.
> [...]
> [   75.320809] attempt to access beyond end of device
> [   75.383861] sda2: rw=0, want=13671320, limit=13671315
> [   75.450195] Buffer I/O error on device sda2, logical block 1708914
> [   75.531464] attempt to access beyond end of device
> [   75.594407] sda2: rw=0, want=13671320, limit=13671315
> [   75.660803] Buffer I/O error on device sda2, logical block 1708914
> [   75.783562] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
> [   75.870019] attempt to access beyond end of device
> [   75.933268] sda2: rw=0, want=13671320, limit=13671315
> [   75.999781] Buffer I/O error on device sda2, logical block 1708914
> [   77.293658] attempt to access beyond end of device
> [   77.356616] sda2: rw=0, want=13671320, limit=13671315
> [   77.422961] Buffer I/O error on device sda2, logical block 1708914
> [   77.504996] attempt to access beyond end of device
> [   77.567930] sda2: rw=0, want=13671320, limit=13671315
> [   77.634301] Buffer I/O error on device sda2, logical block 1708914
> [   77.860569] Adding 2996112k swap on /dev/sda4.  Priority:-1 extents:1 across:2996112k 
> [   78.074418] EXT4-fs (sda2): re-mounted. Opts: (null)
> [   78.230229] attempt to access beyond end of device
> [   78.308838] sda2: rw=0, want=13671320, limit=13671315
> [   78.388768] Buffer I/O error on device sda2, logical block 1708914
> [   78.470746] attempt to access beyond end of device
> [   78.533750] sda2: rw=0, want=13671320, limit=13671315
> [   78.600115] Buffer I/O error on device sda2, logical block 1708914
> [   78.876369] attempt to access beyond end of device
> [   78.939416] sda4: rw=0, want=5992256, limit=5992245
> [   79.003499] Buffer I/O error on device sda4, logical block 374515
> [   79.083598] attempt to access beyond end of device
> [   79.146554] sda4: rw=0, want=5992256, limit=5992245
> [   79.210662] Buffer I/O error on device sda4, logical block 374515
> [   79.292698] attempt to access beyond end of device
> [   79.355660] sda4: rw=0, want=5992256, limit=5992245
> [   79.419737] Buffer I/O error on device sda4, logical block 374515
> [   79.722303] attempt to access beyond end of device
> [   79.801691] sda2: rw=0, want=13671320, limit=13671315
> [   79.972342] EXT4-fs (sda2): re-mounted. Opts: errors=remount-ro
> [   80.063157] attempt to access beyond end of device
> [   80.131517] sda2: rw=0, want=13671320, limit=13671315
> [   80.708525] loop: module loaded
> [   81.326513] attempt to access beyond end of device
> [   81.389538] sda2: rw=0, want=13671320, limit=13671315
> [   81.455878] quiet_error: 2 callbacks suppressed
> [   81.515428] Buffer I/O error on device sda2, logical block 1708914
> [   81.598819] attempt to access beyond end of device
> [   81.661757] sda2: rw=0, want=13671320, limit=13671315
> [   81.728126] Buffer I/O error on device sda2, logical block 1708914
> [   82.284008] attempt to access beyond end of device
> [   82.347038] sda2: rw=0, want=13671320, limit=13671315
> [   82.413380] Buffer I/O error on device sda2, logical block 1708914
> [   82.495397] attempt to access beyond end of device
> [   82.558343] sda2: rw=0, want=13671320, limit=13671315
> [   82.624737] Buffer I/O error on device sda2, logical block 1708914
> [   84.200365] attempt to access beyond end of device
> [   84.276102] sda4: rw=0, want=5992256, limit=5992245
> [   84.353729] Buffer I/O error on device sda4, logical block 374515
> [   84.434697] attempt to access beyond end of device
> [   84.497668] sda4: rw=0, want=5992256, limit=5992245
> [   84.561752] Buffer I/O error on device sda4, logical block 374515
> [   84.761591] attempt to access beyond end of device
> [   84.832304] sda2: rw=0, want=13671320, limit=13671315
> [   84.915381] Buffer I/O error on device sda2, logical block 1708914
> [   85.015487] attempt to access beyond end of device
> [   85.081636] sda2: rw=0, want=13671320, limit=13671315
> [   85.147988] Buffer I/O error on device sda2, logical block 1708914
> [   85.460680] attempt to access beyond end of device
> [   85.523664] sda4: rw=0, want=5992256, limit=5992245
> [   85.587723] Buffer I/O error on device sda4, logical block 374515
> [   85.668724] attempt to access beyond end of device
> [   85.731670] sda4: rw=0, want=5992256, limit=5992245
> [   85.795739] Buffer I/O error on device sda4, logical block 374515
> [   86.184531] fsck.ext4 (1430) used greatest stack depth: 8 bytes left
> [   87.078019] EXT4-fs (sda1): mounting ext3 file system using the ext4 subsystem
> [   87.186438] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
> [   87.457451] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
> [   87.754566] attempt to access beyond end of device
> [   87.828241] sda4: rw=0, want=5992256, limit=5992245
> [   87.903798] Buffer I/O error on device sda4, logical block 374515
> [   87.984630] attempt to access beyond end of device
> [   88.047618] sda4: rw=0, want=5992256, limit=5992245
> [   88.111711] Buffer I/O error on device sda4, logical block 374515
> [   88.306119] attempt to access beyond end of device
> [   88.369160] sda2: rw=0, want=13671320, limit=13671315
> [   88.435490] Buffer I/O error on device sda2, logical block 1708914
> [   88.520033] attempt to access beyond end of device
> [   88.583073] sda2: rw=0, want=13671320, limit=13671315
> [   88.649427] Buffer I/O error on device sda2, logical block 1708914
> 
> 
> /proc/partitions contains this in bot 3.7-rc7 and 3.7-rc8:
> 
> major minor  #blocks  name
> 
>    8        0  117246528 sda
>    8        1      96390 sda1
>    8        2    6835657 sda2
>    8        3  117242370 sda3
>    8        4    2996122 sda4
>    8        5  107314200 sda5

Most likely Linus' shuffle of code in there. For ease of debugging, can
you a bisect of fs/ between rc7 and rc8? Just do;

$ git bisect start fs/
$ git bisect good v3.7-rc7
$ git bisect bad v3.7-rc8

should be no more than 3-4 revisions to test.

-- 
Jens Axboe

