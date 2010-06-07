Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab0FGVgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 17:36:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab0FGVgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 17:36:46 -0400
Date: Mon, 7 Jun 2010 17:36:31 -0400
From: Josef Bacik <josef@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Jeffrey Merkey <jeffmerkey@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, josef@redhat.com,
       viro@zeniv.linux.org.uk
Subject: Re: 2.6.34 echo j > /proc/sysrq-trigger causes inifnite
	unfreeze/Thaw event
Message-ID: <20100607213631.GE2336@localhost.localdomain>
References: <AANLkTim74SREZDq7VQhq6Z1hKXZLINoq0t8rkyQecmM1@mail.gmail.com> <20100607010542.GB27325@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100607010542.GB27325@dastard>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 11:05:42AM +1000, Dave Chinner wrote:
> On Thu, Jun 03, 2010 at 11:30:30PM -0600, Jeffrey Merkey wrote:
> > causes the FS Thaw stuff in fs/buffer.c to enter an infinite loop
> > filling the /var/log/messages with junk and causing the hard drive to
> > crank away endlessly.
> 
> Hmmm, looks pretty obvious what the 2.6.34 bug is:
> 
>         while (sb->s_bdev && !thaw_bdev(sb->s_bdev, sb))
>                 printk(KERN_WARNING "Emergency Thaw on %s\n",
>                        bdevname(sb->s_bdev, b));
> 
> thaw_bdev() returns 0 on success or not frozen, and returns non-zero
> only if the unfreeze failed. Looks like it was broken from the start
> to me.
> 
> Fixing that endless loop shows some other problems on 2.6.35,
> though: the emergency unfreeze is not unfreezing frozen XFS
> filesystems.  This appears to be caused by
> 18e9e5104fcd9a973ffe3eed3816c87f2a1b6cd2 ("Introduce freeze_super
> and thaw_super for the fsfreeze ioctl").
> 
> It appears that this introduces a significant mismatch between the
> bdev freeze/thaw and the super freze/thaw. That is, if you freeze
> with the sb method, you can only unfreeze via the sb method.
> however, if you freeze via the bdev method, you can unfreeze by
> either the bdev or sb method.  This breaks the nesting of the
> freeze/thaw operations between dm and userspace, which can lead to
> premature thawing of the filesystem.
> 
> Then there is this deadlock:
> 
> iterate_supers(do_thaw_one) does:
> 
> 	down_read(&sb->s_umount);
> 	do_thaw_one(sb)
> 	  thaw_bdev(sb->s_bdev, sb))
> 	    thaw_super(sb)
> 	      down_write(&sb->s_umount);
> 
> Which is an instant deadlock.
> 
> These problems were hidden by the fact that the emergency thaw code
> was not getting past the thaw_bdev guards and so not triggering
> this deadlock.
> 
> Al, Josef, what's the best way to fix this mess?
> 

Well we can do something like the following

1) Make a __thaw_super() that just does all the work currently in thaw_super(),
just without taking the s_umount semaphore.
2) Make an thaw_bdev_force or something like that that just sets
bd_fsfreeze_count to 0 and calls __thaw_super().  The original intent was to
make us call thaw until the thaw actually occured, so might as well just make it
quick and painless.
3) Make do_thaw_one() call __thaw_super if sb->s_bdev doesn't exist.  I'm not
sure if this happens currently, but it's nice just in case.

This takes care of the s_umount problem and makes sure that do_thaw_one does
actually thaw the device.  Does this sound kosher to everybody?  Thanks,

Josef
