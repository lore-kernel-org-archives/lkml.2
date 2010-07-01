Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab0GAIGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 04:06:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42626 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177Ab0GAIGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 04:06:31 -0400
Date: Thu, 1 Jul 2010 18:06:28 +1000
From: Nick Piggin <npiggin@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 52/52] fs: icache less I_FREEING time
Message-ID: <20100701080628.GF22976@laptop>
References: <20100624030212.676457061@suse.de>
 <20100624030734.042332166@suse.de>
 <20100630101354.GK24712@dastard>
 <20100630121452.GG21358@laptop>
 <20100701033342.GT24712@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701033342.GT24712@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 01:33:42PM +1000, Dave Chinner wrote:
> On Wed, Jun 30, 2010 at 10:14:52PM +1000, Nick Piggin wrote:
> > On Wed, Jun 30, 2010 at 08:13:54PM +1000, Dave Chinner wrote:
> > > On Thu, Jun 24, 2010 at 01:03:04PM +1000, npiggin@suse.de wrote:
> > > > Problem with inode reclaim is that it puts inodes into I_FREEING state
> > > > and then continues to gather more, during which it may iput,
> > > > invalidate_mapping_pages, be preempted, etc. Holding these inodes in
> > > > I_FREEING can cause pauses.
> > > 
> > > What sort of pauses? I can't see how holding a few inodes in
> > > I_FREEING state would cause any serious sort of holdoff...
> > 
> > Well if the inode is accessed again, it has to wait for potentially
> > hundreds of inodes to be found from the LRU, pagecache invalidated,
> > and destroyed.
> 
> So it's a theoretical concern you have, not something that's
> actually been demonstrated as a problem?

Yes it causes holdoffs. I actually started visibly seeing the problem
badly in my parallel git diff workload as I started experimenting with
increasing batch size.

But even smaller batches could have a problem if the wrong inode is hit.
I didn't add instrumentation in there, but I just didn't see such a
benefit from batching after the lock breakups, so I prefer to go the
other way and add back batching and its downsides IF that proves to be
an improvement.

Is this of any consequence for the filesystem?

 
> As it is, If the inode is accessed immediately after teardown has
> started, then we failed to hold on to the inode at a higher level
> for long enough.

Or simply didn't anticpate userspace access pattern.


> Changing the I_FREEING behaviour is trying to
> address the issue at the wrong level...

Reclaim should of course be as good as possible. But it is inherntly
going to have problems. You need to design everything around reclaim
thinking about the possibility that it will go wrong. Because it will,
in unreproducable ways, on a customer's machine.

