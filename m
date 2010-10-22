Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab0JVFBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 01:01:16 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:8500 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751065Ab0JVFBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 01:01:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHa3wEx5Ldx0/2dsb2JhbAChX3K+SYVKBA
Date: Fri, 22 Oct 2010 16:01:12 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Inode Lock Scalability V7 (was V6)
Message-ID: <20101022050112.GA7201@amd>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
 <20101021050422.GP32255@dastard>
 <20101021132034.GB13620@amd>
 <20101021235227.GI12506@dastard>
 <20101022004540.GA5920@amd>
 <20101022022010.GG19804@ZenIV.linux.org.uk>
 <20101022023444.GA6573@amd>
 <20101022030728.GH19804@ZenIV.linux.org.uk>
 <20101022044657.GA6899@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101022044657.GA6899@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 03:46:57PM +1100, Nick Piggin wrote:
> The difficulty with inode_lock breaking is not the data structures.
> We know how to lock and modify them. The hardest part is verifying
> that a particular inode has no new, unhandled concurrency introduced
> to it (eg. the particular concurrency you pointed out in Dave's patch
> just now). Agree?
> 
> So in that case, I think it is much more natural to be able to take
> an inode and with i_lock, cover it from all icache state concurrency.
> I object to it being called over engineering -- it's actually just a
> big hammer on the inode, compared with fiddling with more complex
> rules.

And yes, being a big hammer, it is actually ugly and clunky for
the first pass.

The intention is always that we can start steps to streamline it
now. I had been looking at switching lock orders around, reducing
i_lock coverage etc, but I found that with RCU, things got a lot
cleaner without reducing i_lock coverage. With RCU the important
part of the locking shifts back, from the read side, to the write
side. Not surprisingly, this made my lock more natural, wheras it
does nothing for a lock ordering which is the other way around.

And I think you give too little credit to i_lock being used to
protect all i_state. Sure it's not strictly needed, and we could
start breaking bits and pieces. But it works really nicely, and
is maintainable and easier to convince yourself of correctness.

Have an inode? Want to do something to it? Take i_lock. You're
done. We don't _need_ to ever think about concurrent modifications.
Really, this is the "big dumb" approach IMO. Breaking things out
finer than per-inode basis is premature optimisation at this point.
Note that my series never precluded such incremental changes, in
fact it makes them easier.


