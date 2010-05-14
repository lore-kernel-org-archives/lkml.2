Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701Ab0ENHdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 03:33:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:43481 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757443Ab0ENHd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 03:33:29 -0400
Date: Fri, 14 May 2010 17:33:24 +1000
From: Nick Piggin <npiggin@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] new ->perform_write fop
Message-ID: <20100514073324.GD4706@laptop>
References: <20100512212403.GE3597@localhost.localdomain>
 <20100513013926.GD27011@dhcp231-156.rdu.redhat.com>
 <20100514010042.GI13617@dastard>
 <20100514033057.GL27011@dhcp231-156.rdu.redhat.com>
 <20100514055054.GA4706@laptop>
 <20100514072055.GK13617@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100514072055.GK13617@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 05:20:55PM +1000, Dave Chinner wrote:
> On Fri, May 14, 2010 at 03:50:54PM +1000, Nick Piggin wrote:
> > Now is there really a good reason to go this way and add more to the
> > write_begin/write_end paths?  Rather than having filesystems just
> > implement their own write file_operations in order to do multi-block
> > operations?
> 
> Well, if we've got xfs, btrfs, gfs2, ext4, and others all wanting to
> do multipage writes, shouldn't we be trying doing in a generic way?

If it makes sense, definitely.


> Fuse doesn't have to deal with allocation of blocks in
> fuse_perform_write()

I just can't see how the generic code can really help out with that
problem of error handling in various parts of the operation allocation.


> > From what I can see, the generic code is not going to be able to be
> > much help with error handling etc. so I would prefer to keep it as
> > simple as possible. I think it is still adequate for most cases.
> > 
> > Take a look at how fuse does multi-page write operations. It is about
> > the simplest case you can get, but it still requires all the generic
> > checks etc.
> 
> fuse_perform_write() doesn't do allocation, and so can easily abort
> at the first error and just complete the writes that did succeed.
> Hence it don't think it's a model that a filesystem that has to
> handle space allocation can use.

No but it does all the _generic_ vfs checks required, which sounded
like what the btrfs folk were concerned about duplicating. My point
was just that there isn't very much duplication really.


> > and it is quite neat -- I don't see a big issue with
> > duplicating generic code?
> 
> When a large number of filesystems end up duplicating the same code,
> then we should be looking at how to implement that functionality
> generically, right?

Yes if it captures a good chunk of common code without unduely
complicating things. I'll be interested to see if that can be
made the case.

