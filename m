Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab2ITALt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 20:11:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051Ab2ITALr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 20:11:47 -0400
Date: Wed, 19 Sep 2012 20:11:40 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
cc: Richard Kennedy <richard@rsk.demon.co.uk>, jaxboe@fusionio.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] block: make struct block_device cacheline_aligned
In-Reply-To: <x49r4py6jze.fsf@segfault.boston.devel.redhat.com>
Message-ID: <Pine.LNX.4.64.1209192008160.14029@file.rdu.redhat.com>
References: <x49lig686kv.fsf@segfault.boston.devel.redhat.com>
 <x498vc683eq.fsf@segfault.boston.devel.redhat.com>
 <Pine.LNX.4.64.1209191116240.30172@file.rdu.redhat.com>
 <x494nmu828c.fsf@segfault.boston.devel.redhat.com>
 <Pine.LNX.4.64.1209191148170.30172@file.rdu.redhat.com>
 <x49r4py6jze.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 Sep 2012, Jeff Moyer wrote:

> Mikulas Patocka <mpatocka@redhat.com> writes:
> 
> > On Wed, 19 Sep 2012, Jeff Moyer wrote:
> >
> >> Mikulas Patocka <mpatocka@redhat.com> writes:
> >> 
> >> > On Wed, 19 Sep 2012, Jeff Moyer wrote:
> >> >
> >> >> Jeff Moyer <jmoyer@redhat.com> writes:
> >> >> 
> >> >> > Hi,
> >> >> >
> >> >> > When testing against a pcie ssd or a ramdisk, making the block device
> >> >> > structure cacheline_aligned provided a significant increase in
> >> >> > performance:
> >> >> 
> >> >> Self-NACK on this one.  This results in a ton of warnings:
> >> >> 
> >> >> include/linux/fs.h:727: warning: ???__section__??? attribute does not
> >> >> apply to types
> >> >> In file included from include/linux/debugfs.h:18,
> >> >>                  from kernel/trace/trace_probe.h:28,
> >> >>                  from kernel/trace/trace_kprobe.c:23:
> >> >> include/linux/fs.h:727: warning: ???__section__??? attribute does not
> >> >> apply to types
> >> >> 
> >> >> And that leaves me with the task of figuring out if/why this actually
> >> >> helps.
> >> >> 
> >> >> Cheers,
> >> >> Jeff
> >> >
> >> > Hi
> >> >
> >> > Use ____cacheline_aligned instead of __cacheline_aligned
> >> 
> >> struct block_device is allocated as part of the bdev_inode:
> >> 
> >> struct bdev_inode {
> >>         struct block_device bdev;
> >>         struct inode vfs_inode;
> >> };
> >> 
> >> The bdev_inode is allocated from the bdev_cachep, which uses
> >> SLAB_HWCACHE_ALIGN.  So, in theory, this should already be aligned.
> >> 
> >> -Jeff
> >
> > The purpose here is to align vfs_inode.
> 
> I'm not sure I understand what you're saying.  When you say, "The
> purpose here," do you mean the purpose in the existing code or the
> purpose of our changes?  The existing code seems to want to align the
> struct block_device, so I assume you mean we should instead align the
> vfs_inode.
> 
> > If you add alignment to bdev, vfs_inode would be aligned (because bdev
> > size would be aligned to cacheline boundary).
> 
> ITYM because the bdev size *is* aligned to a cacheline boundary (the
> size is 256 in my kernel, and the cache line alignment for this cpu is
> 64).  But, since the entire structure is already aligned by the slab
> allocator, I don't see how adding ____cacheline_aligned would change
> anything.
> 
> > Or you can add the alignment to vfs_inode, it would have the same
> > effect.
> 
> Well, I tried the suggestion by Richard to swap the fields in the
> bdev_inode, and it did not result in a huge performance gain:
> 
>                                    %diff
>           	        READ                WRITE                 CPU          
>   Job Name	     BW   IOPS  msec      BW   IOPS  msec   usr  sys   csw
>     write1	      0      0     0       9      9    -8 0.00 0.00 -17.18
>      read1	      6      6    -6       0      0     0 5.87 0.00 -19.20
> randwrite1	      0      0     0       0      0     0 0.00 0.00 -15.46
>  randread1	      5      5    -5       0      0     0 0.00 0.00 -13.69
> readwrite1	      0      0     0       0      0     0 0.00 0.00   7.83
>    randrw1	      5      5    -5       5      5    -5 0.00 0.00 -12.29
> 
> I can try adding the ____cacheline_aligned to the vfs_inode inside of
> the bdev_inode if you like.  Any other ideas?
> 
> Cheers,
> Jeff

I added ____cacheline_aligned - the results are this:
3.5.4 (without ____cacheline_aligned):	60.0630s, stdev 0.9087
3.5.4, ____cacheline_aligned:		43.1266s, stdev 0.8916
3.5.4, ____cacheline_aligned, patch 1:	42.7746s, stdev 0.3491
3.5.4, ____cacheline_aligned, patch 2:	45.1152s, stdev 0.8554
3.5.4, ____cacheline_aligned, patch 3:	43.2462s, stdev 0.1946
3.5.4, ____cacheline_aligned, patch 4:	42.8494s, stdev 0.2387

--- so, cacheline_aligned makes the results consistent. Patch 4 looks 
slighly better than patch 3. What are your results with cacheline_aligned?

Mikulas
