Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302Ab0KPDtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 22:49:16 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:33722 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756134Ab0KPDtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 22:49:13 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAPqN4Ux5Ldur/2dsb2JhbACiWnK/W4VKBA
Date: Tue, 16 Nov 2010 14:49:06 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Nick Piggin <npiggin@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/6] fs: icache RCU free inodes
Message-ID: <20101116034906.GA4596@amd>
References: <20101109124610.GB11477@amd>
 <AANLkTi=b3dEmoTgrJ2xMTUzgM-mUQNNx6J9jeLq2=mtf@mail.gmail.com>
 <1289319698.2774.16.camel@edumazet-laptop>
 <AANLkTimJCgsPqB9ihbScr1RdZ+XGk2tq7LZNfh109Skv@mail.gmail.com>
 <20101109220506.GE3246@amd>
 <AANLkTi=H5ZZ3b5F=Z-PM6FX84FJNzdSh4_HbeeU666ts@mail.gmail.com>
 <20101115010027.GC22876@dastard>
 <20101115042059.GB3320@amd>
 <20101116030242.GI22876@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116030242.GI22876@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 02:02:43PM +1100, Dave Chinner wrote:
> On Mon, Nov 15, 2010 at 03:21:00PM +1100, Nick Piggin wrote:
> > This is 30K inodes per second per CPU, versus nearly 800K per second
> > number that I measured the 12% slowdown with. About 25x slower.
> 
> Hi Nick, the ramfs (800k/12%) numbers are not the context I was
> responding to - you're comparing apples to oranges. I was responding to
> the "XFS [on a ramdisk] is about 4.9% slower" result.

Well xfs on ramdisk was (85k/4.9%). A a lower number, like 30k, I would
expect that should be around 1-2% perhaps. And when in the context of a
real workload that is not 100% CPU bound on creating and destroying a
single inode, I expect that to be well under 1%.

Like I said, I never disputed a potential regression, but I have looked
for workloads that have a detectable regression and have not found any.
And I have extrapolated microbenchmark numbers to show that it's not
going to be a _big_ problem even in a worst case scenario.

Based on that, and the fact that complexity of rcu-walk goes up quite a
bit with SLAB_DESTROY_BY_RCU, I explained why I want to go with RCU
first. I am much more worried about complexity and review coverage and
maintainability than a small worst case regression in some rare
(non-existant) workloads.

I say non existant because if anybody actaully has a workload that tries
to create and destroy inodes fast, they would have been yelling at the
top of their lungs already because the vfs was totally unscalable for
them, let alone most filesystems. Ie. we have quite strong empirical
evidence that people are _not_ hitting this terribly hard.

The first real complaint was really not long ago by google, and that was
due to sockets workload, not files.

I think that is quite a reasonable position. I would definitely like to
see and hear of any numbers or workloads that you can suggest I try, but
really I still want to merge rcu-walk first and then do an incremental
SLAB RCU patch on top of that as my preferred approach to merging it.

Thanks,
Nick

