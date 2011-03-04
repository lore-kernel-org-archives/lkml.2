Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618Ab1CDMw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 07:52:58 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52617 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759400Ab1CDMw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 07:52:56 -0500
Date: Fri, 4 Mar 2011 07:52:20 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Anton Altaparmakov <aia21@cam.ac.uk>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        George Spelvin <linux@horizon.com>
Subject: Re: a major regression in recent kernels? - was: Re: Null pointer
 OOPS in sync_inodes_sb+0xa9/0x104
Message-ID: <20110304125220.GA6740@infradead.org>
References: <20110302034417.4954.qmail@science.horizon.com>
 <023AB542-CCF0-4436-8594-51132FEA8070@cam.ac.uk>
 <AANLkTi=eWdUjgTB2iWOB7YxOtm9f9a9Ux2uCghR=KTgN@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=eWdUjgTB2iWOB7YxOtm9f9a9Ux2uCghR=KTgN@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 10:31:15AM -0800, Linus Torvalds wrote:
> The whole "backing_dev_info" has been a total disaster. The thing is
> crap. It violates all the normal kernel memory management rules ("Thou
> shalt use reference counts and free only when it goes to zero") and
> the whole thing has been a constant source of "oh, that driver didn't
> set it, but we changed all the code to require it to be correct".
> 
> And the reason we set it to NULL when the device goes away is exactly
> that it's not ref-counted correctly, so we really _have_ to set it to
> NULL, because it's not going to be around.
> 
> (And the reverse of that is why all kernel data structures should use
> refcounts, and not some external lifetime notion)

Yes.  But the bdi is even worse than that, as it conflates things with
different lifetime into a single object.  We have the "old school" bdi
which mostly contained various bits of tuning for the VM and read-ahead
algorithms.  This one is required to stay around even with no fs mounted
on block devices because people expect it to stay around with no fs
mounted.  And then we have the writeback context entangled into it,
which only makes sense with an active filesystem (or block device node)
on it to make it special fun.  Even more fun is that we have a pointer
from the superblock, and one from the inode, and the latter might point
to lala land if this is say a /dev/mem node which has a different bdi
for the "old-school" MM usage.

I had various stages of prototypes for separating the two into:

 1) the old bdi.  Life time rules are: allocated and reference counted
    with the containing device.  That is gendisk for block devices,
    server context for remote devices, static at module init time for
    /dev/zero and similar.
 2) writeback context.  Only exists if a user is there, and thus
    refcounted by itself. For non-blockdevice filesystem instances it's
    trivially always allocated with the superblock, and goes away with it.
    For block-device instances we need to keep a pointer to it from
    struct block_device and properly look it up on mount, or opening of
    the block device nodes.

I guess I need to get back to it, but kept it off for now as the code
had reached relative stability and really fear touching it again.

It's for sure not .38 material, though.
