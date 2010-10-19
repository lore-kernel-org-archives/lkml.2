Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab0JSSzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 14:55:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968Ab0JSSzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 14:55:42 -0400
Date: Tue, 19 Oct 2010 14:55:31 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Neil Brown <neilb@suse.de>
cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org, jaxboe@fusionio.com,
        Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: Re: i_size misuses
In-Reply-To: <20100912080543.34650074@notabene>
Message-ID: <Pine.LNX.4.64.1010191450240.9738@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1009080833180.16126@hs20-bc2-1.build.redhat.com>
 <20100912080543.34650074@notabene>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 12 Sep 2010, Neil Brown wrote:

> On Wed, 8 Sep 2010 09:32:13 -0400 (EDT)
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > Hi
> > 
> > when reviewing some i_size problem, I searched the kernel for i_size usage 
> > (the variable should really be written with i_size_write and read with 
> > i_size_read).
> > 
> > Properly locked direct use of "i_size" inside memory management or 
> > filesystems may not be a problem, but there are many problems in general 
> > code outside mm.
> > 
> > The misuses are:
> > SOUND/SOUND_FIRMWARE.C:l = filp->f_path.dentry->d_inode->i_size;
> > KERNEL/RELAY.C:buf->dentry->d_inode->i_size = buf->early_bytes;
> > KERNEL/RELAY.C:buf->dentry->d_inode->i_size += buf->chan->subbuf_size 
> > -buf->padding[old_subbuf];
> > DRIVERS/USB/CORE/INODE.C:dev->usbfs_dentry->d_inode->i_size = i_size;
> > DRIVERS/MTD/DEVICES/BLOCK2MTD.C:dev->mtd.size = 
> > dev->blkdev->bd_inode->i_size & PAGE_MASK;
> > DRIVERS/MD/MD.C: many reads of i_size 
> > DRIVERS/BLOCK/NBD.C: many writes to i_size without i_size_write
> > DRIVERS/BLOCK/DRBD/DRBD_INT.H: return bdev ? bdev->bd_inode->i_size >> 9 : 0;
> > DRIVERS/BLOCK/DRBD/DRBD_WRAPPERS.H: mdev->this_bdev->bd_inode->i_size = 
> > (loff_t)size << 9;
> > BLOCK/BLK-CORE.C:printk(KERN_INFO "%s: rw=%ld, want=%Lu, limit=%Lu\n",
> >                 bdevname(bio->bi_bdev, b),
> >                 bio->bi_rw,
> >                 (unsigned long long)bio->bi_sector + bio_sectors(bio),
> >                 (long long)(bio->bi_bdev->bd_inode->i_size >> 9));
> > maxsector = bio->bi_bdev->bd_inode->i_size >> 9;
> > BLOCK/COMPAT_IOCTL.C: size = bdev->bd_inode->i_size;
> > return compat_put_u64(arg, bdev->bd_inode->i_size);
> > BLOCK/IOCTL.C: if (start + len > (bdev->bd_inode->i_size >> 9))
> > size = bdev->bd_inode->i_size;
> > return put_u64(arg, bdev->bd_inode->i_size);
> > 
> > The problem with this code is that if you read i_size without i_size_read 
> > and the size wraps around 32 bits, for example from 0xffffffff to 
> > 0x100000000 , there is a possibility on 32-bit machines to read an invalid 
> > value (either 0 or 0x1ffffffff). Similarly, if you write i_size without 
> > i_size_write, the readers can see intermediate invalid values.
> > 
> > 
> > The original problem that caused this investigation is the question, how a 
> > block device driver can change the size of its device. Normal method (used 
> > in a few drivers, including dm), consists of
> > mutex_lock(&inode->i_mutex);
> > i_size_write(inode, new_size);
> > mutex_unlock(&inode->i_mutex);
> 
> Don't you just do
> 
>   set_capacity(gendisk, sectors);
>   revalidate(gendisk);
> 
> ??
> 
> NeilBrown

revalidate_disk() has still the problem that it changes i_size without 
holding i_mutex and other kernel parts (for example generic_file_llseek) 
assume that if we hold the lock, i_size_can't be changed.

The rules for accessing i_size must be specified and followed.

Mikulas
