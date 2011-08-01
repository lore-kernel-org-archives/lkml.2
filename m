Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab1HAB2l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 21:28:41 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:54623 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753229Ab1HAB2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 21:28:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhADAEoANk55LCkBgWdsb2JhbABBp2EVAQEWJiWBOQcBAQEBAgEBAjccIwULCAMYLhQUEQMhE4dsBL8FDoY0BJBvkwI
Date: Mon, 1 Aug 2011 11:28:13 +1000
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: xfstests 073 regression
Message-ID: <20110801012813.GR5404@dastard>
References: <20110728164105.GA18258@infradead.org>
 <20110729142121.GA21149@localhost>
 <20110730134422.GA1884@infradead.org>
 <20110731151014.GA23106@localhost>
 <20110731234749.GQ5404@dastard>
 <CA+55aFzkb58Gtzgpd3oQgXekpg4APN6jDLNCh=CAMQ0zwyE4kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzkb58Gtzgpd3oQgXekpg4APN6jDLNCh=CAMQ0zwyE4kg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 31, 2011 at 02:25:27PM -1000, Linus Torvalds wrote:
> On Sun, Jul 31, 2011 at 1:47 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > Yes, I already have, a couple of hours before you sent this:
> >
> > http://www.spinics.net/lists/linux-fsdevel/msg47357.html
> >
> > We haven't found the root cause of the problem, and writeback cannot
> > hold off grab_super_passive() because writeback only holds read
> > locks on s_umount, just like grab_super_passive.
> 
> With read-write semaphores, even read-vs-read recursion is a deadlock
> possibility.
> 
> Why? Because if a writer comes in on another thread, while the read
> lock is initially held, then the writer will now block. And due to
> fairness, now a subsequent reader will *also* block.

Yes, I know.

> So no, nesting readers is *not* allowed for rw_semaphores even if
> naively you'd think it should work.

Right, hence my question of where the deadlock was. I can see how we
get a temporary holdoff due to background flushing holding the
s_umount lock (and hence why this change prevents that holdoff) but
that should not deadlock even if there is a pending write lock.

> So if xfstests 073 does mount/umount testing, then it is entirely
> possible that a reader blocks another reader due to a pending writer.

And I know that remount,ro will take the lock in write mode, hence
cause such a holdoff to occur. Test 073 does this, and it is likely
to be the cause of the problem.

However, if we can't grab the superblock, it implies it that there
is something major happening on the superblock. It's likely to be
going away, or in the case of a remount, something significant is
changing.  In both cases, writeback of dirty data is going to be
handled by the umount/remount process, and so whatever writeback
that is currently in progress is just getting in the way of
executing the higher level, more important operation.

AFAICT, there's a bunch of non-trivial ways that we can get
read-write-read deadlocks that the bdi-flusher "avoids" by ignoring
inodes when it can't get the superblock. However, if it can't get
the superblock reference, why shouldn't we just abort whatever
writeback that is going through writeback_inodes_wb? That writeback
is guaranteed to be unable to complete until the reference to
s_umount is dropped, so why do we continue to try one inode at a
time?

IOWs, what I'm asking is whether this "just move the inodes one at a
time to a different queue" is just a bandaid for a particular
symptom of a deeper problem we haven't realised existed....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
