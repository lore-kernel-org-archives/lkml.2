Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934007Ab0JSMi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 08:38:57 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:59854 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932693Ab0JSMi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 08:38:56 -0400
Date: Tue, 19 Oct 2010 23:38:52 +1100
From: Dave Chinner <david@fromorbit.com>
To: npiggin@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 31/35] fs: icache per-zone inode LRU
Message-ID: <20101019123852.GA12506@dastard>
References: <20101019034216.319085068@kernel.dk>
 <20101019034658.744504135@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101019034658.744504135@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 02:42:47PM +1100, npiggin@kernel.dk wrote:
> Per-zone LRUs and shrinkers for inode cache.

Regardless of whether this is the right way to scale or not, I don't
like the fact that this moves the cache LRUs into the memory
management structures, and expands the use of MM specific structures
throughout the code. It ties the cache implementation to the current
VM implementation. That, IMO, goes against all the principle of
modularisation at the source code level, and it means we have to tie
all shrinker implemenations to the current internal implementation
of the VM. I don't think that is wise thing to do because of the
dependencies and impedance mismatches it introduces.

As an example: XFS inodes to be reclaimed are simply tagged in a
radix tree so the shrinker can reclaim inodes in optimal IO order
rather strict LRU order. It simply does not match a zone-based
shrinker implementation in any way, shape or form, nor does it's
inherent parallelism match that of the way shrinkers are called.

Any change in shrinker infrastructure needs to be able to handle
these sorts of impedance mismatches between the VM and the cache
subsystem. The current API doesn't handle this very well, either,
so it's something that we need to fix so that scalability is easy
for everyone.

Anyway, my main point is that tying the LRU and shrinker scaling to
the implementation of the VM is a one-off solution that doesn't work
for generic infrastructure. Other subsystems need the same
large-machine scaling treatment, and there's no way we should be
tying them all into the struct zone. It needs further abstraction.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
