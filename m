Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab1GFAOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 20:14:36 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33414 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab1GFAOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 20:14:35 -0400
MIME-Version: 1.0
From: Roland Dreier <roland@kernel.org>
Date: Tue, 5 Jul 2011 17:14:15 -0700
X-Google-Sender-Auth: vivBStJ-7Jg0AkJB9vyWlddR888
Message-ID: <CAG4TOxP1eTY_R_t57U1Ux=RTFa=3BWWL9yzL-p9sC+YWrpZmYQ@mail.gmail.com>
Subject: warning because of race between userspace and add_disk()?
To: Jens Axboe <axboe@kernel.dk>
Cc: open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens!

I'm seeing the warning below (with 3.0-rc5) when I hot-add a disk.
The system has a JBOD with 4 SAS paths, so we get 4 /dev/sdXX for the
disk (I don't think this is strictly required to trigger this, but I
think it makes the race bigger).

What I _think_ is happening is that add_disk() exposes the /dev/sdXX
device to userspace before it does disk_add_events(), and the
multipath daemon immediately tries to open the device.  This means
that blkdev_get() (called from blkdev_open()) races with
disk_add_events() and so the first call to disk_block_events() returns
immediately because of

	struct disk_events *ev = disk->ev;
	if (!ev)
		return;

but then on the way out, disk_unblock_events() finds that disk->ev has
been set and so hits the warning.

I guess the fix would be to be more careful about the order we expose
things when registering disks?

    sdcr: unknown partition table
   ------------[ cut here ]------------
   WARNING: at block/genhd.c:1466 __disk_unblock_events+0xf5/0x110()
   Modules linked in: kvm_intel kvm serio_raw i7core_edac ioatdma dca
edac_core pci_stub ses enclosure usbhid usb_storage uas hid mpt2sas
qla2xxx ahci libahci e1000e scsi_transport_fc scsi_transport_sas
mlx4_core raid_class scsi_tgt
   Pid: 12870, comm: multipath Not tainted 3.0.0-rc5+ #1
   Call Trace:
    [<ffffffff8104bd9f>] warn_slowpath_common+0x7f/0xc0
    [<ffffffff8104bdfa>] warn_slowpath_null+0x1a/0x20
    [<ffffffff81241a45>] __disk_unblock_events+0xf5/0x110
    [<ffffffff8124302a>] disk_unblock_events+0x1a/0x20
    [<ffffffff81179d10>] __blkdev_get+0x1b0/0x430
    [<ffffffff8117a2d0>] ? blkdev_get+0x340/0x340
    [<ffffffff81179fe3>] blkdev_get+0x53/0x340
    [<ffffffff8117a2d0>] ? blkdev_get+0x340/0x340
    [<ffffffff8117a335>] blkdev_open+0x65/0x80
    [<ffffffff81144f4e>] __dentry_open+0x12e/0x300
    [<ffffffff81152dab>] ? do_lookup+0x4b/0x310
    [<ffffffff81146321>] nameidata_to_filp+0x71/0x80
    [<ffffffff81153f06>] do_last.clone.18+0xb6/0x7f0
    [<ffffffff81155864>] path_openat+0xc4/0x3a0
    [<ffffffff81154f8b>] ? user_path_at+0x6b/0xb0
    [<ffffffff81155b82>] do_filp_open+0x42/0xa0
    [<ffffffff81161a2f>] ? alloc_fd+0x4f/0x150
    [<ffffffff81146431>] do_sys_open+0x101/0x1e0
    [<ffffffff81146530>] sys_open+0x20/0x30
    [<ffffffff814e5942>] system_call_fastpath+0x16/0x1b
   ---[ end trace c6b59cca96c2a3cb ]---
   sd 11:0:47:0: [sdcr] Attached SCSI disk
