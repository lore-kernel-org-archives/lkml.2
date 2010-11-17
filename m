Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab0KQF4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 00:56:40 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:42908 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750698Ab0KQF4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 00:56:39 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq0DAIv84kx5LdurgWdsb2JhbACiQhYBARYiIsAfhUsE
Date: Wed, 17 Nov 2010 16:56:33 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, Nick Piggin <npiggin@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/6] fs: icache RCU free inodes
Message-ID: <20101117055633.GA3861@amd>
References: <1289319698.2774.16.camel@edumazet-laptop>
 <AANLkTimJCgsPqB9ihbScr1RdZ+XGk2tq7LZNfh109Skv@mail.gmail.com>
 <20101109220506.GE3246@amd>
 <AANLkTi=H5ZZ3b5F=Z-PM6FX84FJNzdSh4_HbeeU666ts@mail.gmail.com>
 <20101115010027.GC22876@dastard>
 <20101115042059.GB3320@amd>
 <20101116030242.GI22876@dastard>
 <20101116034906.GA4596@amd>
 <20101117011254.GJ22876@dastard>
 <20101117041812.GD3302@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117041812.GD3302@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 03:18:12PM +1100, Nick Piggin wrote:
> On Wed, Nov 17, 2010 at 12:12:54PM +1100, Dave Chinner wrote:
> > On Tue, Nov 16, 2010 at 02:49:06PM +1100, Nick Piggin wrote:
> > > On Tue, Nov 16, 2010 at 02:02:43PM +1100, Dave Chinner wrote:
> > > > On Mon, Nov 15, 2010 at 03:21:00PM +1100, Nick Piggin wrote:
> > > > > This is 30K inodes per second per CPU, versus nearly 800K per second
> > > > > number that I measured the 12% slowdown with. About 25x slower.
> > > > 
> > > > Hi Nick, the ramfs (800k/12%) numbers are not the context I was
> > > > responding to - you're comparing apples to oranges. I was responding to
> > > > the "XFS [on a ramdisk] is about 4.9% slower" result.
> > > 
> > > Well xfs on ramdisk was (85k/4.9%).
> > 
> > How many threads? On a 2.26GHz nehalem-class Xeon CPU, I'm seeing:
> > 
> > threads		files/s
> >  1		 45k
> >  2		 70k
> >  4		130k
> >  8		230k
> > 
> > With scalability mainly limited by the dcache_lock. I'm not sure
> > what you 85k number relates to in the above chart. Is it a single
> 
> Yes, a single thread. 86385 inodes created and destroyed per second.
> upstream kernel.

92K actually, with delaylog. Still a long way off ext4, which itself is
a very long way off ramfs. Do you have lots of people migrating off xfs
to ext4 because it is so much quicker? I doubt it because xfs I'm sure
is often as good or better at what people are actually doing.

Yes it's great if it can avoid hitting the disk and runing from cache,
but my point was that real workloads are not going to follow the busy
loop create/destroy pattern, in the slightest. And real IO actually will
get in the way quite often.

So you are going to be a long way off even the 4-5% theoretical worst
case. Every time a creat is followed by something other than an unlink
(eg. another creat, a lock, some IO, some calculation, a write), will
see that gap reduced.

So the closest creat/unlink intensive benchmark I have found was fs_mark
with 0 file size, and no syncs. It's basically just inode create and
destroy in something slightly better than a busy loop.

I ran that on ramdisk, on xfs with delaylog. 100 times.

Average files/s:
vanilla - 39648.76
rcu     - 39916.66

Ie. RCU actually had a slightly higher mean, but assuming a normal
distribution, there was no significant difference at 95% confidence.

Mind you, this is still 40k files/s -- so it's still on the high side
compared to anything doing _real_ work, doing real IO, anything non
trivial with the damn things.

So there. I re state my case. I have put up the numbers, and I have
shown that even worst cases is not the end of the world. I don't know
why I've had to repeat it so many times, but honestly at this point I've
done enough. The case is closed until any *actual* significant numbers
to the contrary turn up.

I've been much more dilligent than most people at examining worst cases
and doing benchmarks, and we really don't hold up kernel development
beyond that, without a basis on actual numbers.

Thanks,
Nick

