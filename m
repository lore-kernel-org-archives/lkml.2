Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750932Ab1GFEEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 00:04:10 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:7749 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750735Ab1GFEEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 00:04:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjsFAJPbE055LCkB/2dsb2JhbABTg31Fo0t4iHqyTpEFDoEdg3+BDASifg
Date: Wed, 6 Jul 2011 14:04:03 +1000
From: Dave Chinner <david@fromorbit.com>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: XFS internal error (memory corruption)
Message-ID: <20110706040403.GW1026@dastard>
References: <4E12A927.9020102@gmail.com>
 <20110705130932.GF1026@dastard>
 <4E1313C1.6020309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E1313C1.6020309@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 04:38:09PM +0300, Török Edwin wrote:
> On 07/05/2011 04:09 PM, Dave Chinner wrote:
> > On Tue, Jul 05, 2011 at 09:03:19AM +0300, Török Edwin wrote:
> >> Hi,
> >>
> >> Yesterday when running 'shutdown -Pfh now', it hung using 99% CPU in sys [*]
> >> Looking at the console there was a message about XFS "Corruption of in-memory data detected", and about XFS_WANT_CORRUPTED_GOTO.
> > 
> > So you had a btree corruption.
> > 
> >> Had to shutdown the machine via SysRQ u + o.
> >>
> >> Today when I booted I got this message:
> >> [    9.786494] XFS (md1p2): Mounting Filesystem
> >> [    9.927590] XFS (md1p2): Starting recovery (logdev: /dev/disk/by-id/scsi-SATA_WDC_WD740ADFD-0_WD-WMARF1007797-part5)
> >> [   10.385941] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1638 of file fs/xfs/xfs_alloc.c.  Caller 0xffffffff8122b80e
> >> [   10.385943]
> >> [   10.386007] Pid: 1990, comm: mount Not tainted 3.0.0-rc5 #155
> >> [   10.386009] Call Trace:
> >> [   10.386014]  [<ffffffff812551ca>] xfs_error_report+0x3a/0x40
> >> [   10.386017]  [<ffffffff8122b80e>] ? xfs_free_extent+0xce/0x120
> >> [   10.386019]  [<ffffffff81227e06>] ? xfs_alloc_lookup_eq+0x16/0x20
> >> [   10.386021]  [<ffffffff81228f4a>] xfs_free_ag_extent+0x6aa/0x780
> >> [   10.386023]  [<ffffffff8122b80e>] xfs_free_extent+0xce/0x120
> >> [   10.386026]  [<ffffffff8127b0ff>] ? kmem_zone_alloc+0x5f/0xe0
> >> [   10.386029]  [<ffffffff81268e9f>] xlog_recover_process_efi+0x15f/0x1a0
> >> [   10.386031]  [<ffffffff8126ab26>] xlog_recover_process_efis.isra.4+0x76/0xc0
> >> [   10.386033]  [<ffffffff8126de62>] xlog_recover_finish+0x22/0xc0
> >> [   10.386035]  [<ffffffff81265aa4>] xfs_log_mount_finish+0x24/0x30
> >> [   10.386038]  [<ffffffff81270aab>] xfs_mountfs+0x45b/0x720
> >> [   10.386040]  [<ffffffff81288741>] xfs_fs_fill_super+0x1f1/0x2e0
> >> [   10.386042]  [<ffffffff811573aa>] mount_bdev+0x1aa/0x1f0
> >> [   10.386044]  [<ffffffff81288550>] ? xfs_parseargs+0xb90/0xb90
> >> [   10.386046]  [<ffffffff812866b0>] xfs_fs_mount+0x10/0x20
> >> [   10.386048]  [<ffffffff81157c3e>] mount_fs+0x3e/0x1b0
> >> [   10.386051]  [<ffffffff81171807>] vfs_kern_mount+0x57/0xa0
> >> [   10.386052]  [<ffffffff81171c4f>] do_kern_mount+0x4f/0x100
> >> [   10.386054]  [<ffffffff811732dc>] do_mount+0x19c/0x840
> >> [   10.386057]  [<ffffffff8110fa12>] ? __get_free_pages+0x12/0x50
> >> [   10.386059]  [<ffffffff81172fc5>] ? copy_mount_options+0x35/0x170
> >> [   10.386061]  [<ffffffff81173d0b>] sys_mount+0x8b/0xe0
> >> [   10.386064]  [<ffffffff814c19fb>] system_call_fastpath+0x16/0x1b
> >> [   10.386071] XFS (md1p2): Failed to recover EFIs
> >> [   10.386097] XFS (md1p2): log mount finish failed
> >> [   10.428562] XFS (md1p3): Mounting Filesystem
> >> [   10.609949] XFS (md1p3): Ending clean mount
> >>
> >> FWIW I got a message about EFIs yesterday too, but everything else worked:
> >> Jul  4 09:42:54 debian kernel: [   11.439861] XFS (md1p2): Mounting Filesystem
> >> Jul  4 09:42:54 debian kernel: [   11.599815] XFS (md1p2): Starting recovery (logdev: /dev/disk/by-id/scsi-SATA_WDC_WD740ADFD-0_WD-WMARF1007797-part5)
> >> Jul  4 09:42:54 debian kernel: [   11.787980] XFS (md1p2): I/O error occurred: meta-data dev md1p2 block 0x117925a8       ("xfs_trans_read_buf") error 5 buf c
> >> ount 4096
> >> Jul  4 09:42:54 debian kernel: [   11.788044] XFS (md1p2): Failed to recover EFIs
> >> Jul  4 09:42:54 debian kernel: [   11.788065] XFS (md1p2): log mount finish failed
> >> Jul  4 09:42:54 debian kernel: [   11.831077] XFS (md1p3): Mounting Filesystem
> >> Jul  4 09:42:54 debian kernel: [   12.009647] XFS (md1p3): Ending clean mount
> > 
> > Looks like you might have a dying disk. That's a IO error on read
> > that has been reported back to XFS, and it warned that bad things
> > happened. Maybe XFS should have shut down, though.
> 
> Ah I had /dev/sdd kicked out of the RAID array, and a lot of SATA EH resets.
> Those were apparently caused by a loose SATA cable:
> https://lkml.org/lkml/2011/7/5/22
> Those errors were for /dev/sdd though, not /dev/sdi (the XFS log disk).

Still, IO errors in the filesystem are important to report when
you've got a corruption occurring.

> Once I re-plugged all the SATA cables, and re-added /dev/sdd to the RAID array, all seemed well:
> 
> Jul  4 09:59:22 debian kernel: [   11.613073] XFS (md1p2): Mounting Filesystem
> Jul  4 09:59:22 debian kernel: [   11.782051] XFS (md1p2): Starting recovery (logdev: /dev/disk/by-id/scsi-SATA_WDC_WD740ADFD-0_WD-WMARF1007797-part5)
> Jul  4 09:59:22 debian kernel: [   12.020766] XFS (md1p2): Ending recovery (logdev: /dev/disk/by-id/scsi-SATA_WDC_WD740ADFD-0_WD-WMARF1007797-part5)
> Jul  4 09:59:22 debian kernel: [   12.031038] XFS (md1p3): Mounting Filesystem
> Jul  4 09:59:22 debian kernel: [   12.196238] XFS (md1p3): Ending clean mount
> 
> But when I shutdown the system later that day I got that log corruption error.
> Could it be that the log  / some data on the disk was still corrupted (despite the successful mount, and RAID resync), which caused the
> log error later?

Most likely the free space btree was corrupted by whatever RAID
problem you had. i.e. it didn't recover cleanly.

> The log is not on the RAID array though, it is on a separate disk,
> and that disk is indeed older than all the other disks.

Lose the log, corrupt your filesystem. i.e. the external log needs
to have たhe same redundancy as the rest of the filesystem...

> Still
> SMART doesn't show any errors, and I've run a SMART short
> self-test, and conveyance self-test, and those didn't log any
> errors either.

SMART isn't very smart about reporting errors. And it can't report
errors caused by bad cables....

> > Obviously - you've got corrupted free space btrees thanks to the IO
> > error during recovery and the later operations that were done on it.
> > Now log recovery can't complete without hitting those corruptions.
> 
> Is the corruption in the log, or in the FS itself?
> The FS itself could've been damaged when kicked out of the RAID.

The FS itself.

> Although is there supposed to be a performance benefit from having
> a separate log disk with XFS?

There used to be. Now everyone just uses delayed logging, which is
far faster and more scalable that even using an external log.

> IIRC it has a disadvantage that you can't use barriers properly.

That mostly works now (recent kernels), but you take a hit in
journal IO waiting synchronously for the data device caches to be
flushed before writing to the log device.

> But if I'd move the log to be stored with the FS (on the RAID10
> array), will XFS be able to use barriers there, or RAID still
> prevents barriers from working?

RAID does not prevent barriers from working any more. They are just
really slow on software RAID5/6....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
