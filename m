Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab0EXBTM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 21:19:12 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:45236 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751835Ab0EXBTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 21:19:11 -0400
Date: Mon, 24 May 2010 11:19:07 +1000
From: Dave Chinner <david@fromorbit.com>
To: Roman Kononov <roman@binarylife.net>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: WARNING in xfs_lwr.c, xfs_write()
Message-ID: <20100524011907.GC12087@dastard>
References: <20100523002023.41f5a5c8@aaa.pulp.binarylife.net>
 <20100523101856.GL2150@dastard>
 <20100523092344.0fcaab42@aaa.pulp.binarylife.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100523092344.0fcaab42@aaa.pulp.binarylife.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 23, 2010 at 09:23:44AM -0500, Roman Kononov wrote:
> On 2010-05-23, 20:18:56 +1000, Dave Chinner <david@fromorbit.com> wrote:
> > You've got some workload that is mixing direct IO writes with some
> > form of buffered or mmap IO on the same file and they are racing.
> > Mixing different types of IO on the one inode is also known as A
> > Really Bad Idea because there is no guarantee of coherency between
> > them....
> > 
> > Can you find out what the application is triggering this?
> 
> This is severely modified Postgresql, which does mix direct IO with
> buffered one.

I hope you keep plenty of backups, then...

> You say "they are racing". Do you mean that this can cause file system
> corruption?

... because it's Not filesystem corruption you need to be worried
about, it's *silent data corruption* that these races can cause.

> Doest it simply warn that direct user data races with
> buffered user data and one of them wins?

Yes, that's right. No guarantee of who wins is given, though.

> This warning "taints" the kernel.

Yup, the application is doing something dangerous, and this warning
is there to let us know that the data corruption is the user's
fault, not the filesystem...

> Should it be safe to do different types of IOs on different
> non-overlapping 4-KiB-aligned regions of the same file (I am unsure
> if this is what the application really does)?

Yes, it should be safe, but the kernel code can't know whether this
is true or not - there are no specific interlocks with direct IO to
prevent concurrent buffered IO to the same region while a direct IO
is in progress. XFS does best effort attempts to maintain coherency
does not provide any guarantees, hence the warning when known race
conditions are tripped.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
