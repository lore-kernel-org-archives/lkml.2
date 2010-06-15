Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074Ab0FOA4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 20:56:25 -0400
Received: from THUNK.ORG ([69.25.196.29]:41984 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060Ab0FOA4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 20:56:23 -0400
Date: Mon, 14 Jun 2010 20:56:19 -0400
From: tytso@mit.edu
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Salman <sqazi@google.com>, mingo@elte.hu, linux-kernel@vger.kernel.org,
       peterz@infradead.org, tytso@google.com, torvalds@linux-foundation.org,
       walken@google.com, Chen Liqin <liqin.chen@sunplusct.com>,
       Lennox Wu <lennox.wu@gmail.com>
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be
 reused immediately.
Message-ID: <20100615005619.GI6666@thunk.org>
Mail-Followup-To: tytso@mit.edu, Andrew Morton <akpm@linux-foundation.org>,
	Salman <sqazi@google.com>, mingo@elte.hu,
	linux-kernel@vger.kernel.org, peterz@infradead.org,
	tytso@google.com, torvalds@linux-foundation.org, walken@google.com,
	Chen Liqin <liqin.chen@sunplusct.com>,
	Lennox Wu <lennox.wu@gmail.com>
References: <AANLkTinlnb-HsDia4X2qgRjkTL_Z5CfVKYHRFwREoyIn@mail.gmail.com>
 <20100611224902.5039.60134.stgit@bumblebee1.mtv.corp.google.com>
 <20100614165851.6bdfe485.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614165851.6bdfe485.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 04:58:51PM -0700, Andrew Morton wrote:
> Using
> 
> 	grep -r '[ 	]cmpxchg[^_]' . | grep -v /arch/
> 
> I can't see any cmpxchg() callers in truly generic code.  lockdep and
> kernel/trace/ring_buffer.c aren't used on the more remote
> architectures, I think.

What about:

drivers/gpu/drm/drm_lock.c:             prev = cmpxchg(lock, old, new);
kernel/lockdep.c:               n = cmpxchg(&nr_chain_hlocks, cn, cn + chain->de
kernel/sched_clock.c:   if (cmpxchg64(&scd->clock, old_clock, clock) != old_cloc
fs/btrfs/inode.c:       if (cmpxchg(&root->orphan_cleanup_state, 0, ORPHAN_CLEAN
fs/ext4/inode.c:        } while (cmpxchg(&ei->i_flags, old_fl, new_fl) != old_fl

The last is quite new --- I had just recently done a similar set of
research as you did before accepting the patch that added cmpxchg into
ext4 (during the last merge window), and I thought cmpxchg() had
entered the "supported by all architectures" category.  It looked like
it had only recently reached state, but I had reached the conclusion
that it was safe to use.

						- Ted
