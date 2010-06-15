Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab0FOB6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 21:58:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751394Ab0FOB6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 21:58:21 -0400
Date: Mon, 14 Jun 2010 18:55:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: tytso@mit.edu
Cc: Salman <sqazi@google.com>, mingo@elte.hu, linux-kernel@vger.kernel.org,
       peterz@infradead.org, tytso@google.com, torvalds@linux-foundation.org,
       walken@google.com, Chen Liqin <liqin.chen@sunplusct.com>,
       Lennox Wu <lennox.wu@gmail.com>
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be
 reused immediately.
Message-Id: <20100614185556.afdc5304.akpm@linux-foundation.org>
In-Reply-To: <20100615005619.GI6666@thunk.org>
References: <AANLkTinlnb-HsDia4X2qgRjkTL_Z5CfVKYHRFwREoyIn@mail.gmail.com>
	<20100611224902.5039.60134.stgit@bumblebee1.mtv.corp.google.com>
	<20100614165851.6bdfe485.akpm@linux-foundation.org>
	<20100615005619.GI6666@thunk.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010 20:56:19 -0400 tytso@mit.edu wrote:

> On Mon, Jun 14, 2010 at 04:58:51PM -0700, Andrew Morton wrote:
> > Using
> > 
> > 	grep -r '[ 	]cmpxchg[^_]' . | grep -v /arch/
> > 
> > I can't see any cmpxchg() callers in truly generic code.  lockdep and
> > kernel/trace/ring_buffer.c aren't used on the more remote
> > architectures, I think.
> 
> What about:
> 
> drivers/gpu/drm/drm_lock.c:             prev = cmpxchg(lock, old, new);
> kernel/lockdep.c:               n = cmpxchg(&nr_chain_hlocks, cn, cn + chain->de

I put these in the not-used-on-weird-architectures bucket.

> kernel/sched_clock.c:   if (cmpxchg64(&scd->clock, old_clock, clock) != old_cloc

I guess that'll flush out any stragglers.

I suspect sched_clock.c might be generating fair amounts of code which
UP builds don't need.

> fs/btrfs/inode.c:       if (cmpxchg(&root->orphan_cleanup_state, 0, ORPHAN_CLEAN
> fs/ext4/inode.c:        } while (cmpxchg(&ei->i_flags, old_fl, new_fl) != old_fl
> 
> The last is quite new --- I had just recently done a similar set of
> research as you did before accepting the patch that added cmpxchg into
> ext4 (during the last merge window), and I thought cmpxchg() had
> entered the "supported by all architectures" category.  It looked like
> it had only recently reached state, but I had reached the conclusion
> that it was safe to use.

I think you're probably right, as long as one sticks with 4-byte
scalars.  The cmpxchg-is-now-generic change snuck in under the radar
(mine, at least).

