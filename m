Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab0LITZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 14:25:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44851 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755872Ab0LITZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 14:25:52 -0500
Date: Thu, 9 Dec 2010 11:20:50 -0800
From: Greg KH <gregkh@suse.de>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu,
        sandeen@redhat.com, adilger.kernel@dilger.ca, hch@infradead.org,
        axboe@kernel.dk
Subject: Re: [RFC PATCH 0/2 v1] Ioctl for reading block queue information
Message-ID: <20101209192050.GA26457@suse.de>
References: <1291908337-18805-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291908337-18805-1-git-send-email-lczerner@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 04:25:35PM +0100, Lukas Czerner wrote:
> Hi all,
> 
> For a long time it has been pretty painful to retrieve informations from
> /sys/block/*/queue for particular block device. Not only it is painful
> to retrieve informations within C tool, parsing strings, etc, but one
> have to run into problem even finding the proper path in sysfs.

What's wrong with using libudev?  That should give you all of this
information easily using a .c program without any need to change the
kernel at all.

> This patch set adds new block ioctl BLKGETQUEUEINFO, which is designed to
> retrieve particular block queue attributes. I have tried to not to
> create completely new interface, but since we already have those
> information within block queue sysfs kobjects, rather retrieve it from
> there.

Ick, no, please just use the sysfs files, don't create a new ioctl, they
are horrid.


> 
> So it binds enum blkq_info_type in include/linux/fs.h with
> default_attrs[] definition within block/blk-sysfs.c for ordering
> purposes, so the userspace has reliable way to address specific
> block queue attribute.
> 
> In order to avoid string parsing (given that 99% of block queue sysfs
> attributes are of unsigned long type) I have introduced new sysfs_ops
> member *get which may be used to pass pointer to any type of data (unsigned
> long in this case). Then this get method is used to withdraw information
> through kobject->ktype->sysfs_ops.
> 
> Although there are some downsides of this approach I would like to discuss:
> 
>  1. In current state BLKGETQUEUEINFO and the whole infrastructure allow to
>     retrieve only numeric values (no text), this means we are no able to
>     retrieve schedule information.
> 
>  2. Adding new *get member into sysfs_ops. I see this as the most painful
>     downside, however, when we have more subsystems adding ioctls like this,
>     they can easily use this method, the same way I am using it now.

Nope, don't do this, just use sysfs how it is supposed to be used, from
userspace.

sorry,

greg k-h
