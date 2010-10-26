Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161Ab0JZM4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 08:56:15 -0400
Received: from static-ip-62-75-137-225.inaddr.intergenia.de ([62.75.137.225]:56720
	"EHLO vs137225.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464Ab0JZM4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 08:56:14 -0400
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Oct 2010 08:56:13 EDT
Subject: Re: [Xen-devel] Re: linux-next regression: IO errors in with ext4
 and xen-blkfront
From: Daniel Stodden <daniel.stodden@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>
In-Reply-To: <20101025190510.GA6452@dumpdata.com>
References: <4CBF83A0.8090802@goop.org> <4CBF84C9.6050606@goop.org>
	 <4CC148E5.2030605@kernel.dk> <20101022082916.GA14070@infradead.org>
	 <20101025182630.GA6036@dumpdata.com> <20101025184756.GA26230@infradead.org>
	 <20101025190510.GA6452@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix VMD
Date: Tue, 26 Oct 2010 05:49:06 -0700
Message-ID: <1288097346.2221.328.camel@ramone>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 15:05 -0400, Konrad Rzeszutek Wilk wrote:
> On Mon, Oct 25, 2010 at 02:47:56PM -0400, Christoph Hellwig wrote:
> > On Mon, Oct 25, 2010 at 02:26:30PM -0400, Konrad Rzeszutek Wilk wrote:
> > > I think we just blindly assume that we would pass the request
> > > to the backend. And if the backend is running under an ancient
> > > version (2.6.18), the behavior would be quite different.
> > 
> > I don't think this has much to do with the backend.  Xen never
> > implemented empty barriers correctly.  This has been a bug since day
> > one, although before no one noticed because the cruft in the old
> > barrier code made them look like they succeed without them actually
> > succeeding.  With the new barrier code you do get an error back for
> > them - and you do get them more often because cache flushes aka
> > empty barriers are the only thing we send now.
> > 
> > The right fix is to add a cache flush command to the protocol which
> > will do the right things for all guests.  In fact I read on a netbsd
> > lists they had to do exactly that command to get their cache flushes
> > to work, so it must exist for some versions of the backends.
> 
> Ok, thank you for the pointer.
> 
> Daniel, you are the resident expert, what do you say?
> 
> Jens, for 2.6.37 is the patch for disabling write barrier support
> by the xen-blkfront the way to do it?

This thread is not just about a single command, it's two entirely
different models.

Let's try like approach it like this: I don't see the point in adding a
dedicated command for the above. You want the backend to issue a cache
flush. As far as the current ring model is concerned, you can express
this as an empty barrier write, or you can add a dedicated op (which is
an empty request with a fancier name). That's fairly boring.

Bugginess in how Linux drivers / kernel versions realize this, whether
in front- or backend, aside.

Next, go on and make discussions more entertaining by redefining your
use of the term 'barrier' to mean 'cache flush' now. I think that marked
the end of the previous thread. I've seen discussions like this. That
is, you remove the ordering constraint, which is what differentiates
barriers from mere cache flushes.

The crux is moving to a model where an ordered write requires a queue
drain by the guest. That's somewhat more low-level and for many disks
more realistic, but it's also awkward for a virtualization layer,
compared to ordered/durable writes. 

One things that it gets you is more latency by stalling the request
stream, then extra events to kick things off again (ok, not that the
difference is huge).

The more general reason why I'd be reluctant to move from barriers to a
caching/flushing/non-ordering disk model are questions like: Why would a
frontend even want to know if a disk is cached, or have to assume so?
Letting the backend alone deal with it is less overhead across different
guest systems, gets enforced in the right place, and avoids a rathole
full of compat headaches later on.

The barrier model is relatively straightforward to implement, even when
it doesn't map to the backend queue anymore. The backend will need to
translate to queue draining and cache flushes as needed by the device
then. That's a state machine, but a small one, and not exactly a new
idea.

Furthermore: If the backend ever gets to start dealing with that entire
cache write durability thing *properly*, we need synchronization across
backend groups sharing a common physical layer anyway, to schedule and
merge barrier points etc. That's a bigger state machine, but derives
from the one above. From there on, any effort spent on trying to
'simplify' things by imposing explicit drain/flush on frontends will
look rather embarrassing.

Unless Xen is just a fancy way to run Linux on Linux on a flat
partition, I'd rather like to see the barrier model stay, blkback fixed,
frontend cache flushes mapped to empty barriers. In the long run, the
simpler model is the least expensive one.

Daniel

> Or if we came up with a patch now would it potentially make it in
> 2.6.37-rcX (I don't know if the fix for this would qualify as a bug
> or regression since it looks to be adding a new command)? And what
> Christoph suggest that this has been in v2.6.36, v2.6.35, etc. so that
> would definitly but it outside the regression definition.


