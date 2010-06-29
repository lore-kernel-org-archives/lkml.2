Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab0F2C2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 22:28:36 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:47704 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751630Ab0F2C2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 22:28:35 -0400
Date: Tue, 29 Jun 2010 12:27:57 +1000
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com,
       Tao Ma <tao.ma@oracle.com>, Dave Chinner <dchinner@redhat.com>,
       Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH] Revert "writeback: limit write_cache_pages integrity
 scanning to current EOF"
Message-ID: <20100629022757.GA6590@dastard>
References: <20100628173529.GA10573@mail.oracle.com>
 <20100629002421.GY6590@dastard>
 <20100629005403.GC24343@mail.oracle.com>
 <20100629015615.GZ6590@dastard>
 <20100629020420.GE24343@mail.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100629020420.GE24343@mail.oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 07:04:20PM -0700, Joel Becker wrote:
> On Tue, Jun 29, 2010 at 11:56:15AM +1000, Dave Chinner wrote:
> > > 	Regarding XFS, how do you handle catching the tail of an
> > > allocation with an lseek(2)'d write?  That is, your current allocation
> > > has a few blocks outside of i_size, then I lseek(2) a gigabyte past EOF
> > > and write there.  The code has to recognize to zero around old_i_size
> > > before moving out to new_i_size, right?  I think that's where our old
> > > approaches had problems.
> > 
> > xfs_file_aio_write() handles both those cases for us via
> > xfs_zero_eof().  What it does is map the region from the old EOF to
> > the start of the new write and zeroes any allocated blocks that are
> > not marked unwritten that lie within the range. It does this via the
> > internal mapping interface because we hide allocated blocks past EOF
> > from the page cache and higher layers.
> 
> 	Makes sense as an approach.  We deliberately do this through the
> page cache to take advantage of its I/O patterns and tie in with JBD2.
> Also, we don't feel like maintaining an entire shadow page cache ;-)

Just to clarify any possible misunderstanding here, xfs_zero_eof()
also does it's IO through the page cache for similar reasons.  It's
just the mappings are found via the internal interfaces before the
zeroing is done via the anonymous pagecache_write_begin()/
pagecache_write_end() functions (in xfs_iozero()) rather than using
the generic block functions.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
