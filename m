Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab0GCCFM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 22:05:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752594Ab0GCCFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 22:05:08 -0400
Date: Fri, 2 Jul 2010 19:03:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 29/52] fs: icache lock i_count
Message-Id: <20100702190355.2b3fe6d2.akpm@linux-foundation.org>
In-Reply-To: <20100630120502.GB21358@laptop>
References: <20100624030212.676457061@suse.de>
	<20100624030730.245992858@suse.de>
	<20100630072702.GF24712@dastard>
	<20100630120502.GB21358@laptop>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010 22:05:02 +1000 Nick Piggin <npiggin@suse.de> wrote:

> On Wed, Jun 30, 2010 at 05:27:02PM +1000, Dave Chinner wrote:
> > On Thu, Jun 24, 2010 at 01:02:41PM +1000, npiggin@suse.de wrote:
> > > Protect inode->i_count with i_lock, rather than having it atomic.
> > > Next step should also be to move things together (eg. the refcount increment
> > > into d_instantiate, which will remove a lock/unlock cycle on i_lock).
> > .....
> > > Index: linux-2.6/fs/inode.c
> > > ===================================================================
> > > --- linux-2.6.orig/fs/inode.c
> > > +++ linux-2.6/fs/inode.c
> > > @@ -33,14 +33,13 @@
> > >   * inode_hash_lock protects:
> > >   *   inode hash table, i_hash
> > >   * inode->i_lock protects:
> > > - *   i_state
> > > + *   i_state, i_count
> > >   *
> > >   * Ordering:
> > >   * inode_lock
> > >   *   sb_inode_list_lock
> > >   *     inode->i_lock
> > > - * inode_lock
> > > - *   inode_hash_lock
> > > + *       inode_hash_lock
> > >   */
> > 
> > I thought that the rule governing the use of inode->i_lock was that
> > it can be used anywhere as long as it is the innermost lock.
> > 
> > Hmmm, no references in the code or documentation. Google gives a
> > pretty good reference:
> > 
> > http://www.mail-archive.com/linux-ext4@vger.kernel.org/msg02584.html
> > 
> > Perhaps a different/new lock needs to be used here?
> 
> Well I just changed the order (and documented it to boot :)). It's
> pretty easy to verify that LOR is no problem. inode hash is only
> taken in a very few places so other code outside inode.c is fine to
> use i_lock as an innermost lock.

um, nesting a kernel-wide singleton lock inside a per-inode lock is
plain nutty.

