Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab0IHNcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:32:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab0IHNcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:32:21 -0400
Date: Wed, 8 Sep 2010 09:32:13 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org, jaxboe@fusionio.com
cc: Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: i_size misuses
Message-ID: <Pine.LNX.4.64.1009080833180.16126@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

when reviewing some i_size problem, I searched the kernel for i_size usage 
(the variable should really be written with i_size_write and read with 
i_size_read).

Properly locked direct use of "i_size" inside memory management or 
filesystems may not be a problem, but there are many problems in general 
code outside mm.

The misuses are:
SOUND/SOUND_FIRMWARE.C:l = filp->f_path.dentry->d_inode->i_size;
KERNEL/RELAY.C:buf->dentry->d_inode->i_size = buf->early_bytes;
KERNEL/RELAY.C:buf->dentry->d_inode->i_size += buf->chan->subbuf_size 
-buf->padding[old_subbuf];
DRIVERS/USB/CORE/INODE.C:dev->usbfs_dentry->d_inode->i_size = i_size;
DRIVERS/MTD/DEVICES/BLOCK2MTD.C:dev->mtd.size = 
dev->blkdev->bd_inode->i_size & PAGE_MASK;
DRIVERS/MD/MD.C: many reads of i_size 
DRIVERS/BLOCK/NBD.C: many writes to i_size without i_size_write
DRIVERS/BLOCK/DRBD/DRBD_INT.H: return bdev ? bdev->bd_inode->i_size >> 9 : 0;
DRIVERS/BLOCK/DRBD/DRBD_WRAPPERS.H: mdev->this_bdev->bd_inode->i_size = 
(loff_t)size << 9;
BLOCK/BLK-CORE.C:printk(KERN_INFO "%s: rw=%ld, want=%Lu, limit=%Lu\n",
                bdevname(bio->bi_bdev, b),
                bio->bi_rw,
                (unsigned long long)bio->bi_sector + bio_sectors(bio),
                (long long)(bio->bi_bdev->bd_inode->i_size >> 9));
maxsector = bio->bi_bdev->bd_inode->i_size >> 9;
BLOCK/COMPAT_IOCTL.C: size = bdev->bd_inode->i_size;
return compat_put_u64(arg, bdev->bd_inode->i_size);
BLOCK/IOCTL.C: if (start + len > (bdev->bd_inode->i_size >> 9))
size = bdev->bd_inode->i_size;
return put_u64(arg, bdev->bd_inode->i_size);

The problem with this code is that if you read i_size without i_size_read 
and the size wraps around 32 bits, for example from 0xffffffff to 
0x100000000 , there is a possibility on 32-bit machines to read an invalid 
value (either 0 or 0x1ffffffff). Similarly, if you write i_size without 
i_size_write, the readers can see intermediate invalid values.


The original problem that caused this investigation is the question, how a 
block device driver can change the size of its device. Normal method (used 
in a few drivers, including dm), consists of
mutex_lock(&inode->i_mutex);
i_size_write(inode, new_size);
mutex_unlock(&inode->i_mutex);

This is deadlock-prone, because i_mutex is also held on fsync path. 
Therefore, this deadlock happens: fsync takes i_mutex and issues I/Os, 
block device driver wants to change its size, so it waits on i_mutex, 
the I/Os wait until the device driver did its internal maintenance and 
changed the inode size. The driver doesn't change the size until fsync 
finished.

Jens, as a block maintainer, please think about it and propose some 
specification how to clean this up. Also a clean verifiable rule regarding 
i_size should be specified and the code should be fixed to conform to the 
rule: maybe we could rename i_size to __i_size and ban its using.

Mikulas
