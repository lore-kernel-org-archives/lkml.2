Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510Ab1HYNuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 09:50:09 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49995 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab1HYNuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 09:50:07 -0400
Date: Thu, 25 Aug 2011 15:49:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs / ext3: Always unlock updates in ext3_freeze()
Message-ID: <20110825134956.GA10476@ucw.cz>
References: <201108112329.23043.rjw@sisk.pl>
 <20110822130045.GC11264@atrey.karlin.mff.cuni.cz>
 <20110822231348.GS3162@dastard>
 <201108240018.32189.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108240018.32189.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > The problem really isn't XFS specific, nor is it new - the fact is
> > > > that any filesystem that has registered a shrinker or can do async
> > > > work in the background post-sync is vulnerable to this problem. It's
> > > 
> > > Should we avoid calling shrinkers while hibernating?
> > 
> > If you like getting random OOM problems when hibernating, then go
> > for it.  Besides, shrinkers are used for more than just filesystems,
> > so you might find you screw entire classes of users by doing this
> > (eg everyone using intel graphics and 3D).
> > 
> > > Or put BUG_ON()s into filesystem shrinkers so that this can not
> > > happen?
> > 
> > Definitely not. If your concern is filesystem shrinkers and you want
> > a large hammer to hit the problem with then do your hibernate
> > image allocation wih GFP_NOFS and the filesystem shrinkers will
> > abort without doing anything.
> 
> I think we can do that, actually.

I believe we should, yes. Question is if it helps much, because
various drivers (and userspace in case uswsusp?) will still trigger
GFP_KERNEL allocations.

Something like this?

--- snapshot.c.ofic	2011-08-25 15:48:41.000000000 +0200
+++ snapshot.c	2011-08-25 15:49:07.000000000 +0200
@@ -1107,7 +1107,7 @@
 
 /* Helper functions used for the shrinking of memory. */
 
-#define GFP_IMAGE	(GFP_KERNEL | __GFP_NOWARN)
+#define GFP_IMAGE	(GFP_NODS | __GFP_NOWARN)
 
 /**
  * preallocate_image_pages - Allocate a number of pages for hibernation image


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
