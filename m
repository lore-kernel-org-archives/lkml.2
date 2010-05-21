Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249Ab0EUPLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 11:11:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756157Ab0EUPLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 11:11:34 -0400
Date: Fri, 21 May 2010 11:19:22 -0400
From: Josef Bacik <josef@redhat.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Josef Bacik <josef@redhat.com>, Dave Chinner <david@fromorbit.com>,
       Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] new ->perform_write fop
Message-ID: <20100521151921.GO32248@dhcp231-156.rdu.redhat.com>
References: <20100518063647.GD2516@laptop> <20100518080503.GF2150@dastard> <20100518104351.GF2516@laptop> <20100518122714.GG2150@dastard> <20100518150912.GI2516@laptop> <20100519235054.GS8120@dastard> <20100520201232.GP3395@quack.suse.cz> <20100520230524.GU8120@dastard> <20100521135054.GN32248@dhcp231-156.rdu.redhat.com> <20100521142354.GO2516@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100521142354.GO2516@laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 22, 2010 at 12:23:54AM +1000, Nick Piggin wrote:
> On Fri, May 21, 2010 at 09:50:54AM -0400, Josef Bacik wrote:
> > On Fri, May 21, 2010 at 09:05:24AM +1000, Dave Chinner wrote:
> > > Allocating multipage writes as unwritten extents turns off delayed
> > > allocation and hence we'd lose all the benefits that this gives...
> > >
> > 
> > I just realized we have another problem, the mmap_sem/page_lock deadlock.
> > Currently BTRFS is susceptible to this, since we don't prefault any of the pages
> > in yet.  If we're going to do multi-page writes we're going to need to have a
> > way to fault in all of the iovec's at once, so when we do the
> > pagefault_disable() copy pagefault_enable() we don't just end up copying the
> > first iovec.  Nick have you done something like this already?  If not I assume
> > I can just loop through all the iovec's and call fault_in_pages_readable on all
> > of them and be good to go right?  Thanks,
> 
> Yes, well it's a different issue. With multi-page writes, even a single
> iovec may not be faulted in properly. And with multiple iovecs, we are
> already suboptimal with faulting.
> 
> faulting in multiple iovecs may already be a good idea. I didn't add
> that code, I had hoped for a test case first, but perhaps we can just
> go and add it.
> 
> With multipage writes, we would want to fault in multiple source pages
> at once if the design was to lock multiple pages at once and do the
> copy. I still think we might be able to just lock and copy one page at
> a time, but I could be wrong.
> 

I was thinking about this possibility, it seems this is what FUSE does already.
It would probably be easier to deal with this fault problem, just do all the fs
stuff to prepare for the total amount, do the copy one page at a time, and then
if something goes wrong we can cleanup properly.

> Oh wow, btrfs is deadlocky there. Firstly, fault_in_pages_readable does
> not guarantee success (race can always unmap the page in the meantime).
> Secondly, calling it inside the page lock section just means it will
> cause the deadlock rather than the copy_from_user.
> 
> Quick workaround to reduce probability is to do fault_in_pages_readable
> calls before locking the pages.
> 
> But you really need to handle the short-copy case. From the error
> handling there, it seems like you can just free_reserved_data_space and
> retry the copy?
> 

Well no, if theres a short copy we just exit.  If we do the
fault_in_pages_readable before we do the prepare_pages we could deal with a
short-copy then.  Thanks,

Josef
