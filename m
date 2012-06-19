Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab2FSOpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 10:45:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50592 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750976Ab2FSOpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 10:45:11 -0400
Date: Tue, 19 Jun 2012 10:45:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dima Tisnek <dimaqq@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>
cc: USB list <linux-usb@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: mount stuck, khubd blocked
In-Reply-To: <CAGGBzX+uGFOXb0WMD-bkDSL8nq=rD4ZFiV=xwAJyqNx=rZ20sw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1206191035340.1814-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2012, Dima Tisnek wrote:

> I made a microsd flash with 2 partitions, sdb1 is data partition, and
> sdb2 is a sentinel partition, 1 block in size.
> 
> I attached the usb-microsd reader with that card in it and by mistake
> tried to mount the sentinel partition, I ran:
> mount /dev/sdb2 /mnt/flash/
> 
> mount got stuck, I was not able to kill or strace it, I pulled the usb
> reader from the port, mount was still stuck, here's the dmesg log:
> 
> [65464.536212] usb 4-1.2: new high-speed USB device number 3 using ehci_hcd
> [65464.700933] usbcore: registered new interface driver uas
> [65464.703478] Initializing USB Mass Storage driver...
> [65464.703762] scsi8 : usb-storage 4-1.2:1.0
> [65464.703852] usbcore: registered new interface driver usb-storage
> [65464.703854] USB Mass Storage support registered.
> [65465.706479] scsi 8:0:0:0: Direct-Access     Generic- Card Reader
>   1.00 PQ: 0 ANSI: 0 CCS
> [65466.389664] sd 8:0:0:0: [sdb] 3862528 512-byte logical blocks:
> (1.97 GB/1.84 GiB)
> [65466.390493] sd 8:0:0:0: [sdb] Write Protect is off
> [65466.390497] sd 8:0:0:0: [sdb] Mode Sense: 03 00 00 00
> [65466.391263] sd 8:0:0:0: [sdb] No Caching mode page present
> [65466.391267] sd 8:0:0:0: [sdb] Assuming drive cache: write through
> [65466.394723] sd 8:0:0:0: [sdb] No Caching mode page present
> [65466.394727] sd 8:0:0:0: [sdb] Assuming drive cache: write through
> [65466.397500]  sdb: sdb1 sdb2
> [65466.400468] sd 8:0:0:0: [sdb] No Caching mode page present
> [65466.400471] sd 8:0:0:0: [sdb] Assuming drive cache: write through
> [65466.400474] sd 8:0:0:0: [sdb] Attached SCSI removable disk
> [66159.793752] usb 4-1.2: USB disconnect, device number 3
> [66291.567080] INFO: task khubd:90 blocked for more than 120 seconds.
> [66291.567083] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [66291.567086] khubd           D 0000000000000001     0    90      2 0x00000000
> [66291.567090]  ffff880230313948 0000000000000046 ffff88023233e000
> ffff880230313fd8
> [66291.567095]  ffff880230313fd8 ffff880230313fd8 ffff880194f8b000
> ffff88023233e000
> [66291.567099]  ffffffff81244c85 ffff880194f8b048 0000000000000046
> ffff8802303138c0
> [66291.567104] Call Trace:
> [66291.567112]  [<ffffffff81244c85>] ? number.isra.2+0x315/0x350
> [66291.567117]  [<ffffffff811b091b>] ? ep_poll_callback+0xeb/0x120
> [66291.567121]  [<ffffffff81244cfe>] ? string.isra.4+0x3e/0xd0
> [66291.567125]  [<ffffffff8145e50f>] schedule+0x3f/0x60
> [66291.567129]  [<ffffffff8145ef35>] rwsem_down_failed_common+0xc5/0x160
> [66291.567133]  [<ffffffff81185f49>] ? find_inode+0xa9/0xb0
> [66291.567136]  [<ffffffff8145f005>] rwsem_down_read_failed+0x15/0x17
> [66291.567139]  [<ffffffff81248434>] call_rwsem_down_read_failed+0x14/0x30
> [66291.567143]  [<ffffffff8145d3d7>] ? down_read+0x17/0x20
> [66291.567146]  [<ffffffff8116ebdf>] get_super+0x9f/0xe0
> [66291.567149]  [<ffffffff811a4d9d>] fsync_bdev+0x1d/0x60
> [66291.567152]  [<ffffffff81227a2d>] invalidate_partition+0x2d/0x60
> [66291.567155]  [<ffffffff81228920>] del_gendisk+0x90/0x250

As can be seen from the stack entries above, this problem lies in the 
block or filesystem layer and not in USB or SCSI.

> [66291.567170]  [<ffffffffa01004ed>] sd_remove+0x6d/0xb0 [sd_mod]
> [66291.567177]  [<ffffffff8130ae0c>] __device_release_driver+0x7c/0xe0
> [66291.567181]  [<ffffffff8130ae9c>] device_release_driver+0x2c/0x40
> [66291.567185]  [<ffffffff8130a931>] bus_remove_device+0xe1/0x120
> [66291.567188]  [<ffffffff8130848a>] device_del+0x12a/0x1b0
> [66291.567195]  [<ffffffffa01211f5>] __scsi_remove_device+0xc5/0xd0 [scsi_mod]
> [66291.567202]  [<ffffffffa011fb54>] scsi_forget_host+0x64/0x70 [scsi_mod]
> [66291.567209]  [<ffffffffa01165cf>] scsi_remove_host+0x6f/0x120 [scsi_mod]
> [66291.567213]  [<ffffffffa04d26e3>] usb_stor_disconnect+0x63/0xd0 [usb_storage]
> [66291.567221]  [<ffffffffa0154240>] usb_unbind_interface+0x50/0x180 [usbcore]
> [66291.567226]  [<ffffffff8130ae0c>] __device_release_driver+0x7c/0xe0
> [66291.567229]  [<ffffffff8130ae9c>] device_release_driver+0x2c/0x40
> [66291.567233]  [<ffffffff8130a931>] bus_remove_device+0xe1/0x120
> [66291.567236]  [<ffffffff8130848a>] device_del+0x12a/0x1b0
> [66291.567243]  [<ffffffffa0151fef>] usb_disable_device+0xaf/0x1f0 [usbcore]
> [66291.567250]  [<ffffffffa014a427>] usb_disconnect+0x87/0x120 [usbcore]
> [66291.567256]  [<ffffffffa014be1b>] hub_thread+0x54b/0x12a0 [usbcore]
> [66291.567261]  [<ffffffff81072540>] ? abort_exclusive_wait+0xb0/0xb0
> [66291.567268]  [<ffffffffa014b8d0>] ? usb_remote_wakeup+0x40/0x40 [usbcore]
> [66291.567272]  [<ffffffff81071bc3>] kthread+0x93/0xa0
> [66291.567275]  [<ffffffff81461664>] kernel_thread_helper+0x4/0x10
>
> subsequent to this, another khubd and systemd-udevd are reported
> blocked in terms.
>
> kernel  3.3.8-1-ARCH #1 x86_64
>
> I think I will have to reboot to get usb running again
>
> Tell if there's something I can do to narrow down this issue as I see
> it is rather vague as it is now.

See also Bugzilla #43269:

	https://bugzilla.kernel.org/show_bug.cgi?id=43269

It looks like the same problem.

Alan Stern

