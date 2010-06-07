Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab0FGBGR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 21:06:17 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:50407 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751450Ab0FGBGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 21:06:15 -0400
Date: Mon, 7 Jun 2010 11:05:42 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jeffrey Merkey <jeffmerkey@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       josef@redhat.com, viro@zeniv.linux.org.uk
Subject: Re: 2.6.34 echo j > /proc/sysrq-trigger causes inifnite
 unfreeze/Thaw event
Message-ID: <20100607010542.GB27325@dastard>
References: <AANLkTim74SREZDq7VQhq6Z1hKXZLINoq0t8rkyQecmM1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim74SREZDq7VQhq6Z1hKXZLINoq0t8rkyQecmM1@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 11:30:30PM -0600, Jeffrey Merkey wrote:
> causes the FS Thaw stuff in fs/buffer.c to enter an infinite loop
> filling the /var/log/messages with junk and causing the hard drive to
> crank away endlessly.

Hmmm, looks pretty obvious what the 2.6.34 bug is:

        while (sb->s_bdev && !thaw_bdev(sb->s_bdev, sb))
                printk(KERN_WARNING "Emergency Thaw on %s\n",
                       bdevname(sb->s_bdev, b));

thaw_bdev() returns 0 on success or not frozen, and returns non-zero
only if the unfreeze failed. Looks like it was broken from the start
to me.

Fixing that endless loop shows some other problems on 2.6.35,
though: the emergency unfreeze is not unfreezing frozen XFS
filesystems.  This appears to be caused by
18e9e5104fcd9a973ffe3eed3816c87f2a1b6cd2 ("Introduce freeze_super
and thaw_super for the fsfreeze ioctl").

It appears that this introduces a significant mismatch between the
bdev freeze/thaw and the super freze/thaw. That is, if you freeze
with the sb method, you can only unfreeze via the sb method.
however, if you freeze via the bdev method, you can unfreeze by
either the bdev or sb method.  This breaks the nesting of the
freeze/thaw operations between dm and userspace, which can lead to
premature thawing of the filesystem.

Then there is this deadlock:

iterate_supers(do_thaw_one) does:

	down_read(&sb->s_umount);
	do_thaw_one(sb)
	  thaw_bdev(sb->s_bdev, sb))
	    thaw_super(sb)
	      down_write(&sb->s_umount);

Which is an instant deadlock.

These problems were hidden by the fact that the emergency thaw code
was not getting past the thaw_bdev guards and so not triggering
this deadlock.

Al, Josef, what's the best way to fix this mess?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
