Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab2FTObk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 10:31:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36942 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756515Ab2FTObi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 10:31:38 -0400
Date: Wed, 20 Jun 2012 10:31:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dave Chinner <david@fromorbit.com>
cc: Dima Tisnek <dimaqq@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, USB list <linux-usb@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: mount stuck, khubd blocked
In-Reply-To: <20120619214130.GO25389@dastard>
Message-ID: <Pine.LNX.4.44L0.1206201020450.1804-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2012, Dave Chinner wrote:

> On Tue, Jun 19, 2012 at 10:45:10AM -0400, Alan Stern wrote:
> > On Tue, 19 Jun 2012, Dima Tisnek wrote:
> > 
> > > I made a microsd flash with 2 partitions, sdb1 is data partition, and
> > > sdb2 is a sentinel partition, 1 block in size.
> > > 
> > > I attached the usb-microsd reader with that card in it and by mistake
> > > tried to mount the sentinel partition, I ran:
> > > mount /dev/sdb2 /mnt/flash/
> > > 
> > > mount got stuck, I was not able to kill or strace it, I pulled the usb
> > > reader from the port, mount was still stuck, here's the dmesg log:
> 
> So where is the mount process stuck? It's holding the lock that
> khubd is stuck on....

Yes, that's most likely the right explanation.

> > > [65464.536212] usb 4-1.2: new high-speed USB device number 3 using ehci_hcd
> > > [65464.700933] usbcore: registered new interface driver uas
> > > [65464.703478] Initializing USB Mass Storage driver...
> > > [65464.703762] scsi8 : usb-storage 4-1.2:1.0
> > > [65464.703852] usbcore: registered new interface driver usb-storage
> > > [65464.703854] USB Mass Storage support registered.
> > > [65465.706479] scsi 8:0:0:0: Direct-Access     Generic- Card Reader
> > >   1.00 PQ: 0 ANSI: 0 CCS
> > > [65466.389664] sd 8:0:0:0: [sdb] 3862528 512-byte logical blocks:
> > > (1.97 GB/1.84 GiB)
> > > [65466.390493] sd 8:0:0:0: [sdb] Write Protect is off
> > > [65466.390497] sd 8:0:0:0: [sdb] Mode Sense: 03 00 00 00
> > > [65466.391263] sd 8:0:0:0: [sdb] No Caching mode page present
> > > [65466.391267] sd 8:0:0:0: [sdb] Assuming drive cache: write through
> > > [65466.394723] sd 8:0:0:0: [sdb] No Caching mode page present
> > > [65466.394727] sd 8:0:0:0: [sdb] Assuming drive cache: write through
> > > [65466.397500]  sdb: sdb1 sdb2
> > > [65466.400468] sd 8:0:0:0: [sdb] No Caching mode page present
> > > [65466.400471] sd 8:0:0:0: [sdb] Assuming drive cache: write through
> > > [65466.400474] sd 8:0:0:0: [sdb] Attached SCSI removable disk
> > > [66159.793752] usb 4-1.2: USB disconnect, device number 3
> > > [66291.567080] INFO: task khubd:90 blocked for more than 120 seconds.
> > > [66291.567083] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > > disables this message.
> > > [66291.567086] khubd           D 0000000000000001     0    90      2 0x00000000
> > > [66291.567090]  ffff880230313948 0000000000000046 ffff88023233e000
> > > ffff880230313fd8
> > > [66291.567095]  ffff880230313fd8 ffff880230313fd8 ffff880194f8b000
> > > ffff88023233e000
> > > [66291.567099]  ffffffff81244c85 ffff880194f8b048 0000000000000046
> > > ffff8802303138c0
> > > [66291.567104] Call Trace:
> > > [66291.567112]  [<ffffffff81244c85>] ? number.isra.2+0x315/0x350
> > > [66291.567117]  [<ffffffff811b091b>] ? ep_poll_callback+0xeb/0x120
> > > [66291.567121]  [<ffffffff81244cfe>] ? string.isra.4+0x3e/0xd0
> > > [66291.567125]  [<ffffffff8145e50f>] schedule+0x3f/0x60
> > > [66291.567129]  [<ffffffff8145ef35>] rwsem_down_failed_common+0xc5/0x160
> > > [66291.567133]  [<ffffffff81185f49>] ? find_inode+0xa9/0xb0
> > > [66291.567136]  [<ffffffff8145f005>] rwsem_down_read_failed+0x15/0x17
> > > [66291.567139]  [<ffffffff81248434>] call_rwsem_down_read_failed+0x14/0x30
> > > [66291.567143]  [<ffffffff8145d3d7>] ? down_read+0x17/0x20
> > > [66291.567146]  [<ffffffff8116ebdf>] get_super+0x9f/0xe0
> > > [66291.567149]  [<ffffffff811a4d9d>] fsync_bdev+0x1d/0x60
> > > [66291.567152]  [<ffffffff81227a2d>] invalidate_partition+0x2d/0x60
> > > [66291.567155]  [<ffffffff81228920>] del_gendisk+0x90/0x250
> > 
> > As can be seen from the stack entries above, this problem lies in the 
> > block or filesystem layer and not in USB or SCSI.
> 
> Don't blame the higher layers as the cause of the problem simply
> because they are the ones that show the visible symptoms ;)

Okay, point taken.  It's always good to have a new point of view when 
tackling a tough problem.

> The problem lies in the fact that the error handling callback that
> is run when the device is removed triggers IO to the block device
> that was just removed.  If all outstanding IOs have been error'd out
> correctly, and all new IOs return errors, then there is no reason
> for the fsync to block here. i.e. the mount process should have
> received an error.
> 
> However, the mount could have hung because underlying device has not
> been cleaned up properly before the device disconnect has proceeded.
> i.e. that it is possible that the cause is a SCSI or USB issue, not a
> filesystem issue. :)

But the mount got stuck _before_ the device was unplugged.  Hence
failure to clean up cannot be the underlying cause.

> So, what other blocked tasks are there in the system (echo w >
> /proc/sysrq-trigger)?
> 
> As it is, I think that invalidate_partition() is doing something
> somewhat insane for a block device that has been removed - you can't
> write to it so fsync_bdev() is useless.

That depends.  If by "removed" you mean physically disconnected from
the computer, then yes.  But if "removed" means merely unregistered
from the device core then writes can still succeed.  
invalidate_partition() doesn't know which has happened.

>  And cleaning up the dentry
> and inode caches is something that should be done when unmounting
> the filesystem, not when the block device goes away as they can
> trigger more IO and potentially deadlock with other operations that
> have not handled the IO errors properly. Yes, shut a filesystem down
> that has had it's block device removed, but filesystem level cleanup
> should be left to the filesystem, not this error handling path.
> 
> And another question - why doesn't having an active filesystem on a
> block device (i.e. an active reference to the gendisk) prevent the
> block device from being removed from underneath it?

References prevent data structures from being deallocated, not from 
being unregistered (or as James Bottomley likes to call it, "removed 
from visibility").

Alan Stern

