Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab0FADog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 23:44:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33163 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968Ab0FADof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 23:44:35 -0400
Date: Tue, 1 Jun 2010 13:44:25 +1000
From: Neil Brown <neilb@suse.de>
To: Pozsar Balazs <pozsy@uhulinux.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: device mapper wierdness
Message-ID: <20100601134425.610237e2@notabene.brown>
In-Reply-To: <20100528145533.GE13853@ojjektum.uhulinux.hu>
References: <20100528145533.GE13853@ojjektum.uhulinux.hu>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 May 2010 16:55:33 +0200
Pozsar Balazs <pozsy@uhulinux.hu> wrote:

> 
> Hi all,
> 
> I found a wierd caching problem, and would like to ask if this is a bug, 
> and how to avoid this behaviour properly.
> 
> First of all, I have a lvm device:
> 
> root:~# ls -l /dev/dm-2 /dev/bela/gazsi
> lrwxrwxrwx 1 root root       7 2010-05-28 16:17 /dev/bela/gazsi -> ../dm-2
> brw-rw---- 1 root media 254, 2 2010-05-28 16:17 /dev/dm-2
> root:~# dmsetup info bela-gazsi
> Name:              bela-gazsi
> State:             ACTIVE
> Read Ahead:        256
> Tables present:    LIVE
> Open count:        1
> Event number:      0
> Major, minor:      254, 2
> Number of targets: 1
> UUID: 
> LVM-LrFvCCU7QzeyBsiXl2RC2VMnWvxGdS4n7xugPDcPzx1vD6SVElPELv0a8vf4mzH0
> 
> root:~# dmsetup table bela-gazsi
> 0 15114240 linear 8:4 384
> 
> 
> Above that, I have another device mapper device, just a simple linear 
> one:
> 
> brw-rw---- 1 root media 254, 1 2010-05-28 16:27 /dev/dm-1
> root:~# ls -l /dev/dm-1 /dev/mapper/live
> brw-rw---- 1 root media 254, 1 2010-05-28 16:27 /dev/dm-1
> lrwxrwxrwx 1 root root       7 2010-05-28 16:17 /dev/mapper/live -> ../dm-1
> root:~# dmsetup info live
> Name:              live
> State:             ACTIVE
> Read Ahead:        256
> Tables present:    LIVE
> Open count:        1
> Event number:      0
> Major, minor:      254, 1
> Number of targets: 1
> 
> root:~# dmsetup table live
> 0 15114240 linear 254:2 0
> 
> 
> Because of the linear mapping, we can see the fs uuid is the same on the 
> two
> dm devices:
> root:~# blkid /dev/mapper/live /dev/bela/gazsi
> /dev/mapper/live: LABEL="UHU" UUID="3452e43d-d40a-4c13-b24d-07d4b1793e9b" TYPE="ext4"
> /dev/bela/gazsi: LABEL="UHU" UUID="3452e43d-d40a-4c13-b24d-07d4b1793e9b" TYPE="ext4"
> 
> 
> Now if I change the uuid of the filesystem with tune2fs, I cannot see 
> this change on the /dev/bela/gazsi device, even if I do a sync:
> root:~# tune2fs -U random /dev/mapper/live
> tune2fs 1.41.11 (14-Mar-2010)
> root:~# blkid /dev/mapper/live /dev/bela/gazsi
> /dev/mapper/live: LABEL="UHU" UUID="f3fad2d6-451a-4ef6-98f8-5fcf51571b07" TYPE="ext4"
> /dev/bela/gazsi: LABEL="UHU" UUID="3452e43d-d40a-4c13-b24d-07d4b1793e9b" TYPE="ext4"
> root:~# sync
> root:~# blkid /dev/mapper/live /dev/bela/gazsi
> /dev/mapper/live: LABEL="UHU" UUID="f3fad2d6-451a-4ef6-98f8-5fcf51571b07" TYPE="ext4"
> /dev/bela/gazsi: LABEL="UHU" UUID="3452e43d-d40a-4c13-b24d-07d4b1793e9b" TYPE="ext4"
> 
> 
> But if drop caches, it gets into the proper state:
> root:~# echo 1 >/proc/sys/vm/drop_caches
> root:~# blkid /dev/mapper/live /dev/bela/gazsi
> /dev/mapper/live: LABEL="UHU" UUID="f3fad2d6-451a-4ef6-98f8-5fcf51571b07" TYPE="ext4"
> /dev/bela/gazsi: LABEL="UHU" UUID="f3fad2d6-451a-4ef6-98f8-5fcf51571b07" TYPE="ext4"
> 
> 
> I fail to see why a sync is not enough and how this drop cache operation
> helps. Could anyone enlighten me please?

You have two block devices: dm-1 and dm-2.
Each block device has a data cache above some storage (or storage access
method).
I/O through /dev/dm-X goes through this cache.

When you create dm-1 as a mapping over dm-2, access to dm-1 are mapped
directly to the storage (or storage-access) of dm-2 completely bypassing the
cache.  This is done for performance reasons - a second cache in the IO path
would bring no gain and significant cost.

So when you read from dm-2, the block containing the UUID is cached in the
dm-2 cache.
When you write to dm-1, the block goes to the storage without touching the
dm-2 cache (the dm-1 cache is changed of course).

'sync' doesn't flush caches, it just pushes any dirty cached data out.  The
data in the dm-2 cache isn't dirty, so nothing happens to it.

You shouldn't really access dm-2 directly when dm-1 is mapped over it.
A number of access attempts will fail.  e.g. if you try to mount it directly,
or open it with O_EXCL it won't work, as dm has claimed exclusive access of
dm-2.
But Linux, being based on Unix, gives you enough rope to shoot yourself in
the foot.  You can access dm-2 if you really want to, and you can even write
to it.  But doing so is not advised and may cause saw feet.

To ensure you get current data when reading dm-2, you can us the
'drop_caches' hack, though a better approach is
   blockdev --flushbufs /dev/dm-2

which will flush all the buffers out of the dm-2 cache.

Hopefully you are now enlightened :-)

NeilBrown


> 
> 
> I am using kernel 2.6.33.3.
> 
> Thanks,
> Balazs Pozsar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

