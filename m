Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933350Ab0JRVYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 17:24:12 -0400
Received: from cobra.newdream.net ([66.33.216.30]:34484 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab0JRVYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 17:24:10 -0400
Date: Mon, 18 Oct 2010 14:27:02 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Dave Chinner <david@fromorbit.com>
cc: Nick Piggin <npiggin@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/19] fs: Reduce inode I_FREEING and factor inode disposal
In-Reply-To: <20101017065245.GE29677@dastard>
Message-ID: <Pine.LNX.4.64.1010181419200.15249@cobra.newdream.net>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
 <1287216853-17634-18-git-send-email-david@fromorbit.com>
 <20101017013047.GA4394@infradead.org> <20101017024923.GA6453@amd>
 <20101017041313.GJ32255@dastard> <20101017043514.GA21802@amd>
 <20101017051310.GA22060@amd> <20101017065245.GE29677@dastard>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I'm a bit late the party, but:

On Sun, 17 Oct 2010, Dave Chinner wrote:
> On Sun, Oct 17, 2010 at 04:13:10PM +1100, Nick Piggin wrote:
> > On Sun, Oct 17, 2010 at 03:35:14PM +1100, Nick Piggin wrote:
> > > On Sun, Oct 17, 2010 at 03:13:13PM +1100, Dave Chinner wrote:
> > > > On Sun, Oct 17, 2010 at 01:49:23PM +1100, Nick Piggin wrote:
> > > > > On Sat, Oct 16, 2010 at 09:30:47PM -0400, Christoph Hellwig wrote:
> > > > > > >   * inode->i_lock is *always* the innermost lock.
> > > > > > >   *
> > > > > > > + * inode->i_lock is *always* the innermost lock.
> > > > > > > + *
> > > > > > 
> > > > > > No need to repeat, we got it..
> > > > > 
> > > > > Except that I didn't see where you fixed all the places where it is
> > > > > *not* the innermost lock. Like for example places that take dcache_lock
> > > > > inside i_lock.
> > > > 
> > > > I can't find any code outside of ceph where the dcache_lock is used
> > > > within 200 lines of code of the inode->i_lock. The ceph code is not
> > > > nesting them, though.
> > > 
> > > You mustn't have looked very hard? From ceph:
> > > 
> > >        spin_unlock(&dcache_lock);
> > >        spin_unlock(&inode->i_lock);
> > > 
> > > (and yes, acquisition side does go in i_lock->dcache_lock order)
> 
> Sorry, easy to miss with a quick grep when the locks are taken in
> different functions.
> 
> Anyway, this one looks difficult to fix without knowing something
> about Ceph and wtf it is doing there. It's one to punt to the
> maintainer to solve as it's not critical to this patch set.

I took a look at this code and was able to remove the i_lock -> 
dcache_lock nesting.  To be honest, I'm not sure why I did it that way in 
the first place.  The only point (now) where i_lock is used/needed is 
while checking the ceph inode flags, and that's done without holding 
dcache_lock (presumably soon to be d_lock).

The patch is 622386be in the for-next branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git

Anyway, hope this helps!  
sage
