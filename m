Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab1IMFRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 01:17:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36645 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab1IMFRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 01:17:21 -0400
Date: Tue, 13 Sep 2011 06:17:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Lockdep and rw_semaphores
Message-ID: <20110913051714.GC2203@ZenIV.linux.org.uk>
References: <4E6C1016.8030703@vlnb.net>
 <20110911023840.GZ2203@ZenIV.linux.org.uk>
 <4E6EBDA8.2040401@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E6EBDA8.2040401@vlnb.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 10:19:20PM -0400, Vladislav Bolkhovitin wrote:

> Sure, if nested write locking is involved, lockdep should loudly complain, but on
> the first nested write, not read, because what's the point to complain on nested
> reads? I may not have nested write locking at all (and don't have).

_What_ nested write locking?  For that to happen it's enough to have
unrelated threads try to grab these suckers exclusive at the wrong time.
One thread for each lock.  Separately.  No nesting involved.

And if you never grab these locks exclusive (again, not nested - anything
grabbing them exclusive will suffice), why the fsck do you have them at
all?  rwsem that is never grabbed exclusive is rather pointless, isn't it?

> Plus, the deadlock scenario lockdep described for me
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(QQ1_sem);
>                                lock(QQ_sem);
>                                lock(QQ1_sem);
>   lock(QQ_sem);
> 
>  *** DEADLOCK ***
> 
> is simply wrong. Such deadlock can never happen, correct?

Sigh...  OK, let's spell it out:

thread 1:
	down_read(&A); /* got it */
thread 2:
	down_read(&B); /* got it */
thread 3:
	down_write(&A);	/* blocked until thread 1 releases A */
thread 4:
	down_write(&B);	/* blocked until thread 2 releases B */
thread 1:
	down_read(&B);	/* blocked until thread 4 gets and releases B */
thread 2:
	down_read(&A);	/* blocked until thread 3 gets and released A */

and we have a deadlock.  Note that thread 3 and thread 4 are just doing
solitary down_write(), no other locks held.  And if they happen to come
a bit later, we won't get stuck.

Again, if your code does that kind of out-of-order down_read(), it is broken.
Period.  Either there's literally nothing that would ever do down_write()
(in which case you can remove the useless rwsem completely), or you can get
a full-blown deadlock there.  It's harder to hit (you need 4 tasks instead
if 2, as you would with mutex_lock() out of order), but it's still quite
triggerable.

What you seem to be missing is that rwsems are fair to writers.  I.e.
down_read() blocks not only when there's a writer already holding the lock;
it blocks when there's a writer blocked trying to acquire the lock.  That's
what makes this kind of out-of-order down_read() unsafe; unrelated thread
doing a solitary down_write() is able to wedge the whole thing stuck.  Without
having acquired *any* locks - just waiting for readers to go away so it could
get the damn thing exclusive.
