Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab0IOSUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 14:20:30 -0400
Received: from cobra.newdream.net ([66.33.216.30]:39835 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab0IOSU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 14:20:28 -0400
Date: Wed, 15 Sep 2010 11:22:01 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Arnd Bergmann <arnd@arndb.de>
cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@lst.de>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, gregf@hq.newdream.net
Subject: Re: [PATCH] Remove BKL from fs/locks.c
In-Reply-To: <201009151917.25589.arnd@arndb.de>
Message-ID: <Pine.LNX.4.64.1009151121080.16996@cobra.newdream.net>
References: <201009142206.54130.arnd@arndb.de> <201009151830.43470.arnd@arndb.de>
 <Pine.LNX.4.64.1009150948190.24081@cobra.newdream.net> <201009151917.25589.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010, Arnd Bergmann wrote:

> On Wednesday 15 September 2010, Sage Weil wrote:
> > > @@ -2362,7 +2362,7 @@ static int encode_caps_cb(struct inode *inode, struct ceph_cap *cap,
> > >       if (recon_state->flock) {
> > >               int num_fcntl_locks, num_flock_locks;
> > >  
> > > -             lock_kernel();
> > > +             lock_flocks();
> > >               ceph_count_locks(inode, &num_fcntl_locks, &num_flock_locks);
> > >               rec.v2.flock_len = (2*sizeof(u32) +
> > >                                   (num_fcntl_locks+num_flock_locks) *
> > > @@ -2373,7 +2373,7 @@ static int encode_caps_cb(struct inode *inode, struct ceph_cap *cap,
> > >                       err = ceph_encode_locks(inode, pagelist,
> > >                                               num_fcntl_locks,
> > >                                               num_flock_locks);
> > > -             unlock_kernel();
> > > +             unlock_flocks();
> > >       }
> > 
> > The Ceph code won't currently behave with lock_flocks() taking a spinlock.  
> > We're preparing a patch to fix that now.  As long as there is a window 
> > between lock_flocks() being defined and the spinlock conversion, I can 
> > send the fix upstream then and avoid any breakage.  Or send the patches 
> > your way to include in your tree, whatever you prefer!
> 
> I'd be happy to just integrate the fix in this patch, or as a separate patch
> in the series.
> 
> I certainly don't want to break any file system in the middle of the series,
> I'm sure we can find a way to do it right.
> 
> What is the problem? I just saw ceph_pagelist_addpage potentially sleeping,
> is that what you are thinking of?

Yeah.  The pagelist code needs to be adjusted to handle preallocation of 
potentially multiple pages.  We'll send the fix your way shortly.

Thanks!
sage


> 
> > > +void unlock_flocks(void)
> > > +{
> > > +     unlock_kernel();
> > > +}
> > 
> > EXPORT_SYMBOL(unlock_flocks); ?
> 
> Right, thanks!
> 
> 	Arnd
> 
> 
