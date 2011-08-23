Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab1HWWQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:16:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:32946 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712Ab1HWWQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:16:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fs / ext3: Always unlock updates in ext3_freeze()
Date: Wed, 24 Aug 2011 00:18:32 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <201108112329.23043.rjw@sisk.pl> <20110822130045.GC11264@atrey.karlin.mff.cuni.cz> <20110822231348.GS3162@dastard>
In-Reply-To: <20110822231348.GS3162@dastard>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108240018.32189.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 23, 2011, Dave Chinner wrote:
> On Mon, Aug 22, 2011 at 03:00:45PM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > >   What's exactly the problem? Memory preallocation enters direct reclaim
> > > > and that deadlocks in the filesystem?
> > > 
> > > Well, that's one possible manifestation. The problem is that the
> > > current hibernate code still assumes that sys_sync() results in an
> > > idle filesystem that will not change after the call if nothing is
> > > dirty.
> > > 
> > > The result is that when the large memory allocation occurs for the
> > > hibernate image (after the sys_sync() call) then the shrink_slab()
> > > tends to be called. The XFS shrinkers are capable of dirtying inodes
> > > and the backing buffers of inodes that are in the reclaimable state.
> > > But those buffers cannot be flushed to disk because hibernate has
> > > already frozen the xfsbufd threads, so the shrinker doing inode
> > > reclaim hangs up on locks waiting for the buffers to be written.
> > > This either leads to deadlock or hibernate image allocation failure.
> > > 
> > > Far worse, IMO, is the case where is -doesn't- deadlock, because the
> > > filesystem state can still changing after the allocation has
> > > finished due to async metadata IO completions. That has the
> > > potential to cause filesystem corruption as after resume the on-disk
> > > state may not match what is written from memory to the hibernate
> > > image.
> > > 
> > > The problem really isn't XFS specific, nor is it new - the fact is
> > > that any filesystem that has registered a shrinker or can do async
> > > work in the background post-sync is vulnerable to this problem. It's
> > 
> > Should we avoid calling shrinkers while hibernating?
> 
> If you like getting random OOM problems when hibernating, then go
> for it.  Besides, shrinkers are used for more than just filesystems,
> so you might find you screw entire classes of users by doing this
> (eg everyone using intel graphics and 3D).
> 
> > Or put BUG_ON()s into filesystem shrinkers so that this can not
> > happen?
> 
> Definitely not. If your concern is filesystem shrinkers and you want
> a large hammer to hit the problem with then do your hibernate
> image allocation wih GFP_NOFS and the filesystem shrinkers will
> abort without doing anything.

I think we can do that, actually.

Thanks,
Rafael
