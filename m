Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab0JSWd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 18:33:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52003 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112Ab0JSWd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:33:26 -0400
Date: Wed, 20 Oct 2010 09:33:16 +1100
From: Neil Brown <neilb@suse.de>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org, jaxboe@fusionio.com,
        Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: Re: i_size misuses
Message-ID: <20101020093316.346926c4@notabene>
In-Reply-To: <Pine.LNX.4.64.1010191450240.9738@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1009080833180.16126@hs20-bc2-1.build.redhat.com>
	<20100912080543.34650074@notabene>
	<Pine.LNX.4.64.1010191450240.9738@hs20-bc2-1.build.redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 14:55:31 -0400 (EDT)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Sun, 12 Sep 2010, Neil Brown wrote:
> 
> > On Wed, 8 Sep 2010 09:32:13 -0400 (EDT)
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > > Hi
> > > 
> > > when reviewing some i_size problem, I searched the kernel for i_size usage 
> > > (the variable should really be written with i_size_write and read with 
> > > i_size_read).
> > > 
> > > Properly locked direct use of "i_size" inside memory management or 
> > > filesystems may not be a problem, but there are many problems in general 
> > > code outside mm.
> > > 
> > > The misuses are:
> > > SOUND/SOUND_FIRMWARE.C:l = filp->f_path.dentry->d_inode->i_size;
> > > KERNEL/RELAY.C:buf->dentry->d_inode->i_size = buf->early_bytes;
> > > KERNEL/RELAY.C:buf->dentry->d_inode->i_size += buf->chan->subbuf_size 
> > > -buf->padding[old_subbuf];
> > > DRIVERS/USB/CORE/INODE.C:dev->usbfs_dentry->d_inode->i_size = i_size;
> > > DRIVERS/MTD/DEVICES/BLOCK2MTD.C:dev->mtd.size = 
> > > dev->blkdev->bd_inode->i_size & PAGE_MASK;
> > > DRIVERS/MD/MD.C: many reads of i_size 
> > > DRIVERS/BLOCK/NBD.C: many writes to i_size without i_size_write
> > > DRIVERS/BLOCK/DRBD/DRBD_INT.H: return bdev ? bdev->bd_inode->i_size >> 9 : 0;
> > > DRIVERS/BLOCK/DRBD/DRBD_WRAPPERS.H: mdev->this_bdev->bd_inode->i_size = 
> > > (loff_t)size << 9;
> > > BLOCK/BLK-CORE.C:printk(KERN_INFO "%s: rw=%ld, want=%Lu, limit=%Lu\n",
> > >                 bdevname(bio->bi_bdev, b),
> > >                 bio->bi_rw,
> > >                 (unsigned long long)bio->bi_sector + bio_sectors(bio),
> > >                 (long long)(bio->bi_bdev->bd_inode->i_size >> 9));
> > > maxsector = bio->bi_bdev->bd_inode->i_size >> 9;
> > > BLOCK/COMPAT_IOCTL.C: size = bdev->bd_inode->i_size;
> > > return compat_put_u64(arg, bdev->bd_inode->i_size);
> > > BLOCK/IOCTL.C: if (start + len > (bdev->bd_inode->i_size >> 9))
> > > size = bdev->bd_inode->i_size;
> > > return put_u64(arg, bdev->bd_inode->i_size);
> > > 
> > > The problem with this code is that if you read i_size without i_size_read 
> > > and the size wraps around 32 bits, for example from 0xffffffff to 
> > > 0x100000000 , there is a possibility on 32-bit machines to read an invalid 
> > > value (either 0 or 0x1ffffffff). Similarly, if you write i_size without 
> > > i_size_write, the readers can see intermediate invalid values.
> > > 
> > > 
> > > The original problem that caused this investigation is the question, how a 
> > > block device driver can change the size of its device. Normal method (used 
> > > in a few drivers, including dm), consists of
> > > mutex_lock(&inode->i_mutex);
> > > i_size_write(inode, new_size);
> > > mutex_unlock(&inode->i_mutex);
> > 
> > Don't you just do
> > 
> >   set_capacity(gendisk, sectors);
> >   revalidate(gendisk);
> > 
> > ??
> > 
> > NeilBrown
> 
> revalidate_disk() has still the problem that it changes i_size without 
> holding i_mutex and other kernel parts (for example generic_file_llseek) 
> assume that if we hold the lock, i_size_can't be changed.

generic_file_llseek is not used for block devices.  They use block_llseek
which uses i_size_read, so I think it is safe.

> 
> The rules for accessing i_size must be specified and followed.

I agree.  However the rules can be different for different file systems and
file types.
A filesystem that used the generic_* function would need to only change
i_size under i_mutex as you say.
For block devices it appears that the rule is that it can only be changed
under bd_mutex.
For 'relay' (which you mentioned above), it seem the relevant mutex is the
global relay_channels_mutex, though I didn't read the code thoroughly to be
sure.

It still would probably be useful to review all the i_size related code to
ensure that it is safe, but you should not assume that everything follows the
same rules.  So first you need to work out the rule for a given subsystem,
then audit it against that rule (and maybe document that rule if it isn't
already documented!)

NeilBrown


> 
> Mikulas

