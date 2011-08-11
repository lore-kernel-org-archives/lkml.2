Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab1HKPQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 11:16:20 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54588 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752238Ab1HKPQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 11:16:18 -0400
Date: Thu, 11 Aug 2011 11:16:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, <jaxboe@fusionio.com>,
        <roland@purestorage.com>, <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [BUG] Oops when SCSI device under multipath is removed
In-Reply-To: <1313075131.4166.10.camel@mulgrave>
Message-ID: <Pine.LNX.4.44L0.1108111112280.1958-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Aug 2011, James Bottomley wrote:

> > > Well, it's just hiding the problem.  The essential problem is that only
> > > block has the correctly refcounted knowledge to know the last release of
> > > the queue reference.  Until that time, the holder of the reference can
> > > use the queue regardless of whether blk_cleanup_queue() has been called.
> > > This is the race you complain about since use of the queue involves the
> > > lock which should be guarded by QUEUE_DEAD checks.
> > > 
> > > This is essentially unfixable with function calls.  The only way to fix
> > > it is to have a callback model for freeing the external lock.
> > 
> > Assuming the queue is associated with a device, the queue could take a
> > reference to the device, dropping that reference when the queue is
> > freed.  Then the lock could safely be freed at the same time as the 
> > device.
> 
> If that assumption is correct, there's no point refcounting the queue at
> all because its use is entirely subordinated to the lifecycle of the
> associated device.

That's true.  Why wasn't it done that way originally?  Are there queues 
that aren't associated with devices?

>  Plus all the wittering about my previous patch is
> pointless, because blk_cleanup_queue() has to do the final put of the
> queue in the lock free path (otherwise the assumption is violated).
> 
> However, much as I'd like to accept this rosy view, the original oops
> that started all of this in 2.6.38 was someone caught something with a
> reference to a SCSI queue after the device release function had been
> called.

Not according to your commit log.  You wrote that the reference was
taken after scsi_remove_device() had been called -- but the device
release function is scsi_device_dev_release_usercontext().

Alan Stern

