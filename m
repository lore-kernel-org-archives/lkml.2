Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab0EXD3t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 23:29:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:33672 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755933Ab0EXD3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 23:29:47 -0400
Date: Mon, 24 May 2010 13:29:42 +1000
From: Nick Piggin <npiggin@suse.de>
To: Josef Bacik <josef@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       hch@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] new ->perform_write fop
Message-ID: <20100524032942.GR2516@laptop>
References: <20100518080503.GF2150@dastard>
 <20100518104351.GF2516@laptop>
 <20100518122714.GG2150@dastard>
 <20100518150912.GI2516@laptop>
 <20100519235054.GS8120@dastard>
 <20100520201232.GP3395@quack.suse.cz>
 <20100520230524.GU8120@dastard>
 <20100521135054.GN32248@dhcp231-156.rdu.redhat.com>
 <20100521142354.GO2516@laptop>
 <20100521151921.GO32248@dhcp231-156.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100521151921.GO32248@dhcp231-156.rdu.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 11:19:22AM -0400, Josef Bacik wrote:
> On Sat, May 22, 2010 at 12:23:54AM +1000, Nick Piggin wrote:
> > On Fri, May 21, 2010 at 09:50:54AM -0400, Josef Bacik wrote:
> > > On Fri, May 21, 2010 at 09:05:24AM +1000, Dave Chinner wrote:
> > > > Allocating multipage writes as unwritten extents turns off delayed
> > > > allocation and hence we'd lose all the benefits that this gives...
> > > >
> > > 
> > > I just realized we have another problem, the mmap_sem/page_lock deadlock.
> > > Currently BTRFS is susceptible to this, since we don't prefault any of the pages
> > > in yet.  If we're going to do multi-page writes we're going to need to have a
> > > way to fault in all of the iovec's at once, so when we do the
> > > pagefault_disable() copy pagefault_enable() we don't just end up copying the
> > > first iovec.  Nick have you done something like this already?  If not I assume
> > > I can just loop through all the iovec's and call fault_in_pages_readable on all
> > > of them and be good to go right?  Thanks,
> > 
> > Yes, well it's a different issue. With multi-page writes, even a single
> > iovec may not be faulted in properly. And with multiple iovecs, we are
> > already suboptimal with faulting.
> > 
> > faulting in multiple iovecs may already be a good idea. I didn't add
> > that code, I had hoped for a test case first, but perhaps we can just
> > go and add it.
> > 
> > With multipage writes, we would want to fault in multiple source pages
> > at once if the design was to lock multiple pages at once and do the
> > copy. I still think we might be able to just lock and copy one page at
> > a time, but I could be wrong.
> > 
> 
> I was thinking about this possibility, it seems this is what FUSE does already.
> It would probably be easier to deal with this fault problem, just do all the fs
> stuff to prepare for the total amount, do the copy one page at a time, and then
> if something goes wrong we can cleanup properly.

Yep. The fewer pages we have to copy to/from at once, the more robust
it should be.

 
> > Oh wow, btrfs is deadlocky there. Firstly, fault_in_pages_readable does
> > not guarantee success (race can always unmap the page in the meantime).
> > Secondly, calling it inside the page lock section just means it will
> > cause the deadlock rather than the copy_from_user.
> > 
> > Quick workaround to reduce probability is to do fault_in_pages_readable
> > calls before locking the pages.
> > 
> > But you really need to handle the short-copy case. From the error
> > handling there, it seems like you can just free_reserved_data_space and
> > retry the copy?
> > 
> 
> Well no, if theres a short copy we just exit.  If we do the
> fault_in_pages_readable before we do the prepare_pages we could deal with a
> short-copy then.  Thanks,

Take a look at the code in generic buffered write. It's not hard, but it
is easy to get the error case wrong.

You need to fault in the source pages before holding page lock. If this
fails, then you may exit. After locking the pages, you need to do a
pagefault_disable() and atomic kmaps/usercopies. If this copy comes up
short, you need to unlock and retry faulting in the source pages.

The reason for this is that the source page may be unmapped but there is
still a valid memory mapping at the point of the usercopy. So you must
not fail that.

And, if some bytes have been copied into pagecache, and if that pagecache
page is marked as uptodate, then you must treat it as a partial write.

