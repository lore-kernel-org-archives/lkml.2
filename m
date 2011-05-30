Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab1E3KHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 06:07:25 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:53224 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755565Ab1E3KHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 06:07:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnMDAEFq4015LCoegWdsb2JhbABVpigVAQEWJiWIcbxhDoYQBJ97
Date: Mon, 30 May 2011 20:07:19 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [regression, 3.0-rc1] dentry cache growth during unlinks, XFS
 performance way down
Message-ID: <20110530100719.GE561@dastard>
References: <20110530020604.GC561@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110530020604.GC561@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 12:06:04PM +1000, Dave Chinner wrote:
.....
> Performance is now a very regular peak/trough patten with a period
> of about 20s, where the peak is about 80k unlinks/s, and the trough
> is around 20k unlinks/s. The runtime of the 50m inode delete has
> gone from around 10m on 2.6.39, to:
> 
> 11.71user 470.08system 15:07.91elapsed 53%CPU (0avgtext+0avgdata 133184maxresident)k
> 0inputs+0outputs (30major+497228minor)pagefaults 0swaps
> 11.50user 468.30system 15:14.35elapsed 52%CPU (0avgtext+0avgdata 133168maxresident)k
> 0inputs+0outputs (42major+497268minor)pagefaults 0swaps
> 11.34user 466.66system 15:26.04elapsed 51%CPU (0avgtext+0avgdata 133216maxresident)k
> 0inputs+0outputs (18major+497121minor)pagefaults 0swaps
> 12.14user 470.46system 15:26.60elapsed 52%CPU (0avgtext+0avgdata 133216maxresident)k
> 0inputs+0outputs (44major+497309minor)pagefaults 0swaps
> 12.06user 463.74system 15:28.84elapsed 51%CPU (0avgtext+0avgdata 133232maxresident)k
> 0inputs+0outputs (25major+497046minor)pagefaults 0swaps
> 11.37user 468.18system 15:29.07elapsed 51%CPU (0avgtext+0avgdata 133184maxresident)k
> 0inputs+0outputs (55major+497056minor)pagefaults 0swaps
> 11.69user 474.46system 15:47.45elapsed 51%CPU (0avgtext+0avgdata 133232maxresident)k
> 0inputs+0outputs (61major+497284minor)pagefaults 0swaps
> 11.32user 476.93system 16:05.14elapsed 50%CPU (0avgtext+0avgdata 133184maxresident)k
> 0inputs+0outputs (30major+497225minor)pagefaults 0swaps
> 
> About 16 minutes. I'm not sure yet whether this change of cache
> behaviour is the cause of the entire performance regression, but
> it's a good chance that it is a contributing factor.

I'm not sure about this one, now. I suspect I've got a repeat of a
recent "scrambled RAID controller" problem where it decided to
silently change the BBWC mode on all the LUNS. I've re-run the tests
on 2.6.39-rc4 where I know everything was running fine, and I'm
getting the same results as above and not what I was getting a month
ago.

[ one cold reset of the server and disk array later ]

Yeah, that appears to be the problem.

> Christoph, it appears that there is a significant increase in log
> forces during this unlink workload compared to 2.6.39, and that's
> possibly where the performance degradation is coming from. I'm going
> to have to bisect, I think.
> 
> The 8-way create rate for the 50m inodes is down by 10% as well, but I
> don't think that has anything to do with dentry cache behaviour -
> log write throughput is up by a factor of 3x over 2.6.39. Christoph,
> I think that this is once again due to an increase in log forces,
> but I need to do more analysis to be sure...

The increase in log forces was only a side effect of the slower IO
subsystem resulting in the AIL tail pushing hitting more pinned
buffers and issuing more log forces. Pretty much back to the same
level as previously with the reset raid array. False alarm.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
