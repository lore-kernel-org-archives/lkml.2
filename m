Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab1D0C1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 22:27:00 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:24390 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755458Ab1D0C07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 22:26:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvcDAO18t015LHHJgWdsb2JhbAAvpToVAQEWJiXFfA6FaASdAg
Date: Wed, 27 Apr 2011 12:26:55 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
Message-ID: <20110427022655.GE12436@dastard>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org>
 <20110424234655.GC12436@dastard>
 <alpine.DEB.2.01.1104242245090.18728@trent.utfs.org>
 <alpine.DEB.2.01.1104250015480.18728@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1104250015480.18728@trent.utfs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 12:19:24AM -0700, Christian Kujau wrote:
> On Mon, 25 Apr 2011 at 09:46, Dave Chinner wrote:
> > I'd say they are not being reclaimmmed because the VFS hasn't let go
> > of them yet. Can you also dump /proc/sys/fs/{dentry,inode}-state so
> > we can see if the VFS has released the inodes such that they can be
> > reclaimed by XFS?
> 
> Please see http://nerdbynature.de/bits/2.6.39-rc4/oom/
> 
>  - slabinfo-4.txt.bz2, contains /proc/sys/fs/{dentry,inode}-state and

Ok, so looking at slabinfo-5.txt.bz2, this is the pattern of dentry,
VFS inode and XFS inode use patterns:

http://userweb.kernel.org/~dgc/slab-usage.png

What this shows is that VFS inode cache memory usage increases until
about the 550 sample mark before the VM starts to reclaim it with
extreme prejudice. At that point, I'd expect the XFS inode cache to
then shrink, and it doesn't. I've got no idea why the either the
shrinker or background reclaim is not reclaiming and freeing inodes,
but it is the reason why the system OOMs.

Can you check if there are any blocked tasks nearing OOM (i.e. "echo
w > /proc/sysrq-trigger") so we can see if XFS inode reclaim is
stuck somewhere?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
