Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab0LIEi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 23:38:57 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:25440 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753302Ab0LIEiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 23:38:55 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAPfr/0x5LdBk/2dsb2JhbACjaHnAJ4VJBJAL
Date: Thu, 9 Dec 2010 15:38:42 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Nick Piggin <npiggin@suse.de>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/46] Revert "fs: use RCU read side protection in
  d_validate"
Message-ID: <20101209043842.GB3139@amd>
References: <cover.1290852958.git.npiggin@kernel.dk>
 <2d1d8ffc4acea8b6c4e5b58bb1653b3f0e7071e2.1290852958.git.npiggin@kernel.dk>
 <20101208011656.GD29333@dastard>
 <20101208093824.GA3151@amd>
 <20101209004413.GB32766@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101209004413.GB32766@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 11:44:13AM +1100, Dave Chinner wrote:
> On Wed, Dec 08, 2010 at 08:38:24PM +1100, Nick Piggin wrote:
> > On Wed, Dec 08, 2010 at 12:16:56PM +1100, Dave Chinner wrote:
> > > On Sat, Nov 27, 2010 at 08:56:03PM +1100, Nick Piggin wrote:
> > > > This reverts commit 3825bdb7ed920845961f32f364454bee5f469abb.
> > > > 
> > > > Patch is broken, you can't dget() without holding any locks!
> > > 
> > > I believe you can - for the same reasons we can take a reference to
> > > an inode without holding the inode_lock. That is, as long as the
> > > caller already holds an active reference to the dentry,
> > > dget() can be used to take another reference without needing the
> > > dcache_lock.
> > > 
> > > Such usage appears to be described in the comment above dget() and
> > > there's a BUG_ON() in dget() to catch callers that don't already
> > > have an active reference. An example of a valid unlocked dget():
> > > d_alloc() does an unlocked dget() to take a reference to the parent
> > > dentry whichn we already are guaranteed to have a reference to.
> > 
> > Of course you can dget if you already have a reference :)
> 
> Right, so the commit message is wrong. Can you update it to tell us why
> dget() can't be used there - the commit message from the second
> patch explained it far better....

I suppose if you're not reading it in the context of d_validate,
then yes. And as an historical record, I'll clarify.

Obviously if we do have a reference, then we can take another,
and if we don't, then we need more than RCU because RCU only
provides persistence guarantee for the memory, not any persistence
or validity guarantee for the object.

 
> > > As to d_validate() - it depends on the caller behaviour as to
> > > whether the unlocked dget() is valid or not.  From a cursory check
> > > of the NCP and SMB readdir caches, both appear to hold an active
> > > reference to the dentry it is passing to d_validate().
> > 
> > I don't see where? Can you point to where the refcount is taken?
> > AFAIKS it drops the reference 3 lines after it puts the pointer
> > into cache.
> 
> Yeah, you're right, I missed that one - I spent more tiem checking
> the validation part of the code than the initial insertion. Hence
> my request:

Yes, I'm pretty sure it doesn't have any references.

 
> > > If that is
> > > the case then there is nothing wrong with the way d_validate uses
> > > dget(). Can someone with more SMB/NCP expertise than me validate the
> > > use of cached dentries?
> > 
> > Then why would it have to use d_validate if it has a reference?
> > That is supposed to be for an "untrusted" pointer (which is why
> > it had all the crazy checks that it's in kmem and in the right
> > slab etc).
> 
> Code changes. It may not be doing what it was originally
> needed/intended to be doing - I don't need to waste time on code
> archeology and second guessing when there are others around that can
> tell me this off the top oftheir head. ;)

Well the d_validate API is meant to provide that, so it's broken
whether or not its callers use it correctly. It's also exported
to external modules...

Yes we should remove smbfs and rip the cache out of ncpfs and
remove d_validate entirely when possible (or, provide a more
reasonable API and caching library entirely in the dcache code
that a filesystem might use). But this is the right first step.


