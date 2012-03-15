Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761813Ab2COM2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 08:28:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:39959 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760982Ab2COM2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 08:28:05 -0400
Date: Thu, 15 Mar 2012 13:28:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: [patch 0/5] seqlock consolidation
In-Reply-To: <20120315122112.GB8943@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.02.1203151322020.2466@ionos>
References: <20120314170736.617746873@linutronix.de> <20120315122112.GB8943@ZenIV.linux.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2012, Al Viro wrote:

> On Thu, Mar 15, 2012 at 11:44:22AM -0000, Thomas Gleixner wrote:
> 
> > Aside of that replacing open coded constructs with proper functions is
> > a worthwhile cleanup by itself.
> 
> Provided that those are proper primitives to start with...  I don't like
> it - most of ->d_lock uses are _not_ related to ->d_seq, to start with
> and then we get an interesting mix of functions that do and do not assume
> the lock already taken, etc.
> 
> Could you describe RT patch problems in more details?  I really don't like
> this solution - interface is overcomplicated and doesn't fit well...

On RT the spinlock sections (except the raw_spinlock) ones are
becoming preemtible as we replace the spinlocks by "sleeping
spinlock", a PI aware rtmutex.

So now assume the following:

 spin_lock(d->d_lock);
 ....
 d->d_seq++;

 -> Preemption
    read_seqcount_begin()

     repeat:
        ret = ACCESS_ONCE(sl->sequence);
        if (unlikely(ret & 1)) {
                cpu_relax();
                goto repeat;
        }
        smp_rmb();

Now when the preempting task has higher prioriy, the thing loops
forever. Fail ....

The only way out is to lock d->d_lock which is contended, so the
reader side boosts the writer and waits for the lock to be
released. Though with the open coded seqlock we have no idea which
lock we need to take.

Any better ideas ?

Thanks,

	tglx
