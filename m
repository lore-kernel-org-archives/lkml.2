Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035Ab2FUOZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 10:25:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42125 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756981Ab2FUOZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 10:25:03 -0400
Date: Thu, 21 Jun 2012 10:25:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dave Chinner <david@fromorbit.com>
cc: Dima Tisnek <dimaqq@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, USB list <linux-usb@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: mount stuck, khubd blocked
In-Reply-To: <20120621013457.GQ30705@dastard>
Message-ID: <Pine.LNX.4.44L0.1206211020450.1164-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2012, Dave Chinner wrote:

> > > As it is, I think that invalidate_partition() is doing something
> > > somewhat insane for a block device that has been removed - you can't
> > > write to it so fsync_bdev() is useless.
> > 
> > That depends.  If by "removed" you mean physically disconnected from
> > the computer, then yes.  But if "removed" means merely unregistered
> > from the device core then writes can still succeed.  
> > invalidate_partition() doesn't know which has happened.
> 
> Which means the lower layers probably need to pass that distinction
> up to the invalidation function.

I don't think that information is passed anywhere in the kernel.  And 
in any case, it's not really important.  When a device is unregistered, 
the upper layers shouldn't care about the reason why.

> > > And another question - why doesn't having an active filesystem on a
> > > block device (i.e. an active reference to the gendisk) prevent the
> > > block device from being removed from underneath it?
> > 
> > References prevent data structures from being deallocated, not from 
> > being unregistered (or as James Bottomley likes to call it, "removed 
> > from visibility").
> 
> Except the unregister path appears to assume that a valid block
> device available when it is unregistered.

It may very well be available during the unregistration procedure.  
There's nothing wrong with assuming it is -- if it isn't, I/O attempts 
will simply fail.

> That seems to me like
> there is a bad assumption being made in this error handling path...

No; a bad assumption would be if the code assumed the device was 
available _after_ the unregistration call had completed.

Alan Stern

