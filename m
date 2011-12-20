Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab1LTR76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 12:59:58 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51190 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab1LTR7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 12:59:51 -0500
Date: Tue, 20 Dec 2011 17:59:19 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: mc@linux.vnet.ibm.com, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, david@fromorbit.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than
 online CPUs
Message-ID: <20111220175919.GE23916@ZenIV.linux.org.uk>
References: <20111219205251.GK2203@ZenIV.linux.org.uk>
 <4EF01565.2000700@linux.vnet.ibm.com>
 <20111220062710.GC23916@ZenIV.linux.org.uk>
 <4EF03915.60902@linux.vnet.ibm.com>
 <1324373854.21588.16.camel@mengcong>
 <4EF0654B.4060904@linux.vnet.ibm.com>
 <4EF06C9B.4010703@linux.vnet.ibm.com>
 <4EF084A4.3000106@linux.vnet.ibm.com>
 <20111220140628.GD23916@ZenIV.linux.org.uk>
 <4EF09D34.1060607@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF09D34.1060607@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 08:05:32PM +0530, Srivatsa S. Bhat wrote:

> Sorry but I didn't quite get your point...
> No two cpu hotplug operations can race because of the cpu_hotplug lock they
> use. Hence, if a cpu online operation begins, it has to succeed or fail
> eventually. No other cpu hotplug operation can intervene. Ditto for cpu offline
> operations.
> 
> Hence a CPU_UP_PREPARE event *will* be followed by a corresponding
> CPU_UP_CANCELED or CPU_ONLINE event for the same cpu. (And we ignore the
> CPU_STARTING event that comes in between, on purpose, so as to avoid the race
> with cpu_online_mask). Similar is the story for offline operation.
> 
> And if the notifier grabs the spinlock and keeps it locked between these 2
> points of a cpu hotplug operation, it ensures that our br locks will spin,
> instead of block till the cpu hotplug operation is complete. Isn't this what
> we desired all along? "A non-blocking way to sync br locks with cpu hotplug"?
> 
> Or am I missing something?

The standard reason why losing the timeslice while holding a spinlock means
deadlocks?
CPU1: grabs spinlock
CPU[2..n]: tries to grab the same spinlock, spins
CPU1: does something blocking, process loses timeslice
CPU1: whatever got scheduled there happens to to try and grab the same
spinlock and you are stuck.  At that point *all* CPUs are spinning on
that spinlock and your code that would eventually unlock it has no chance
to get any CPU to run on.

Having the callback grab and release a spinlock is fine (as long as you
don't do anything blocking between these spin_lock/spin_unlock).  Having
it leave with spinlock held, though, means that the area where you can't
block has expanded a whole lot.  As I said, brittle...

A quick grep through the actual callbacks immediately shows e.g.
del_timer_sync() done on CPU_DOWN_PREPARE.  And sysfs_remove_group(),
which leads to outright mutex_lock().  And sysfs_remove_link() (ditto).
And via_cputemp_device_remove() (again, mutex_lock()).  And free_irq().
And perf_event_exit_cpu() (mutex_lock()).  And...

IOW, there are shitloads of deadlocks right there.  If your callback's
position in the chain is earlier than any of those, you are screwed.

No, what I had in mind was different - use the callbacks to maintain a
bitmap that would contain
	a) all CPUs that were online at the moment
	b) ... and not too much else
Updates protected by spinlock; in all cases it gets dropped before the
callback returns.  br_write_lock() grabs that spinlock and iterates over
the set; it *does* leave the spinlock grabbed - that's OK, since all
code between br_write_lock() and br_write_unlock() must be non-blocking
anyway.  br_write_unlock() iterates over the same bitmap (unchanged since
br_write_lock()) and finally drops the spinlock.

AFAICS, what we want in callback is
	CPU_DEAD, CPU_DEAD_FROZEN, CPU_UP_CANCELLED, CPU_UP_CANCELLED_FROZEN:
		grab spinlock
		remove cpu from bitmap
		drop spinlock
	CPU_UP_PREPARE, CPU_UP_PREPARE_FROZEN
		grab spinlock
		add cpu to bitmap
		drop spinlock
That ought to keep bitmap close to cpu_online_mask, which is enough for
our purposes.
