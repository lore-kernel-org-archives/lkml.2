Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab1HAA0j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 20:26:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752756Ab1HAA0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 20:26:32 -0400
MIME-Version: 1.0
In-Reply-To: <20110731234749.GQ5404@dastard>
References: <20110728164105.GA18258@infradead.org> <20110729142121.GA21149@localhost>
 <20110730134422.GA1884@infradead.org> <20110731151014.GA23106@localhost> <20110731234749.GQ5404@dastard>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 31 Jul 2011 14:25:27 -1000
Message-ID: <CA+55aFzkb58Gtzgpd3oQgXekpg4APN6jDLNCh=CAMQ0zwyE4kg@mail.gmail.com>
Subject: Re: xfstests 073 regression
To: Dave Chinner <david@fromorbit.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 31, 2011 at 1:47 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> Yes, I already have, a couple of hours before you sent this:
>
> http://www.spinics.net/lists/linux-fsdevel/msg47357.html
>
> We haven't found the root cause of the problem, and writeback cannot
> hold off grab_super_passive() because writeback only holds read
> locks on s_umount, just like grab_super_passive.

With read-write semaphores, even read-vs-read recursion is a deadlock
possibility.

Why? Because if a writer comes in on another thread, while the read
lock is initially held, then the writer will now block. And due to
fairness, now a subsequent reader will *also* block.

So no, nesting readers is *not* allowed for rw_semaphores even if
naively you'd think it should work.

So if xfstests 073 does mount/umount testing, then it is entirely
possible that a reader blocks another reader due to a pending writer.

NOTE! The rwlock *spinlocks* are designed to be unfair to writers, and
by design allow recursive readers. That's important and very much by
design: it is ok to take a rwlock for reading without disabling
interrupts even if there may be *interrupts* that also need it for
reading.

With the spinning rwlock, there is also much less chance of starvation
due to this unfairness. In contrast, the rw_semaphores really can be
starved pretty easily if you are excessively unfair to writers.

                          Linus
