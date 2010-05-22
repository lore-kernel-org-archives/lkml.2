Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791Ab0EVAbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 20:31:43 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:36542 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932767Ab0EVAbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 20:31:42 -0400
Date: Sat, 22 May 2010 10:31:38 +1000
From: Dave Chinner <david@fromorbit.com>
To: Josef Bacik <josef@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       hch@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] new ->perform_write fop
Message-ID: <20100522003138.GB8120@dastard>
References: <20100514083821.GL13617@dastard>
 <20100518063647.GD2516@laptop>
 <20100518080503.GF2150@dastard>
 <20100518104351.GF2516@laptop>
 <20100518122714.GG2150@dastard>
 <20100518150912.GI2516@laptop>
 <20100519235054.GS8120@dastard>
 <20100520201232.GP3395@quack.suse.cz>
 <20100520230524.GU8120@dastard>
 <20100521135054.GN32248@dhcp231-156.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100521135054.GN32248@dhcp231-156.rdu.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 09:50:54AM -0400, Josef Bacik wrote:
> On Fri, May 21, 2010 at 09:05:24AM +1000, Dave Chinner wrote:
> > On Thu, May 20, 2010 at 10:12:32PM +0200, Jan Kara wrote:
> > > On Thu 20-05-10 09:50:54, Dave Chinner wrote:
> > >   b) E.g. ext4 can do even without hole punching. It can allocate extent
> > >      as 'unwritten' and when something during the write fails, it just
> > >      leaves the extent allocated and the 'unwritten' flag makes sure that
> > >      any read will see zeros. I suppose that other filesystems that care
> > >      about multipage writes are able to do similar things (e.g. btrfs can
> > >      do the same as far as I remember, I'm not sure about gfs2).
> > 
> > Allocating multipage writes as unwritten extents turns off delayed
> > allocation and hence we'd lose all the benefits that this gives...
> >
> 
> I just realized we have another problem, the mmap_sem/page_lock deadlock.
> Currently BTRFS is susceptible to this, since we don't prefault any of the pages
> in yet.  If we're going to do multi-page writes we're going to need to have a
> way to fault in all of the iovec's at once, so when we do the
> pagefault_disable() copy pagefault_enable() we don't just end up copying the
> first iovec.  Nick have you done something like this already?

I have patches that already do this, but the big issue is that it is
inhernetly racy. The prefaulting does not guarantee that by the time
we disable page faults that the prefaulted page has not already been
reclaimed. Basically we have to design for EFAULT occurring because
even pre-faultig does not prevent it from occurring.

> If not I assume
> I can just loop through all the iovec's and call fault_in_pages_readable on all
> of them and be good to go right?  Thanks,

That's effectively what I've done, but it's still no guarantee.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
