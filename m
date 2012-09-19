Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab2ISPvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:51:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756487Ab2ISPvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:51:01 -0400
Date: Wed, 19 Sep 2012 11:50:59 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
cc: jaxboe@fusionio.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] block: make struct block_device cacheline_aligned
In-Reply-To: <x494nmu828c.fsf@segfault.boston.devel.redhat.com>
Message-ID: <Pine.LNX.4.64.1209191148170.30172@file.rdu.redhat.com>
References: <x49lig686kv.fsf@segfault.boston.devel.redhat.com>
 <x498vc683eq.fsf@segfault.boston.devel.redhat.com>
 <Pine.LNX.4.64.1209191116240.30172@file.rdu.redhat.com>
 <x494nmu828c.fsf@segfault.boston.devel.redhat.com>
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
> >> Jeff Moyer <jmoyer@redhat.com> writes:
> >> 
> >> > Hi,
> >> >
> >> > When testing against a pcie ssd or a ramdisk, making the block device
> >> > structure cacheline_aligned provided a significant increase in
> >> > performance:
> >> 
> >> Self-NACK on this one.  This results in a ton of warnings:
> >> 
> >> include/linux/fs.h:727: warning: ???__section__??? attribute does not
> >> apply to types
> >> In file included from include/linux/debugfs.h:18,
> >>                  from kernel/trace/trace_probe.h:28,
> >>                  from kernel/trace/trace_kprobe.c:23:
> >> include/linux/fs.h:727: warning: ???__section__??? attribute does not
> >> apply to types
> >> 
> >> And that leaves me with the task of figuring out if/why this actually
> >> helps.
> >> 
> >> Cheers,
> >> Jeff
> >
> > Hi
> >
> > Use ____cacheline_aligned instead of __cacheline_aligned
> 
> struct block_device is allocated as part of the bdev_inode:
> 
> struct bdev_inode {
>         struct block_device bdev;
>         struct inode vfs_inode;
> };
> 
> The bdev_inode is allocated from the bdev_cachep, which uses
> SLAB_HWCACHE_ALIGN.  So, in theory, this should already be aligned.
> 
> -Jeff

The purpose here is to align vfs_inode. If you add alignment to bdev, 
vfs_inode would be aligned (because bdev size would be aligned to 
cacheline boundary). Or you can add the alignment to vfs_inode, it would 
have the same effect.

Mikulas
