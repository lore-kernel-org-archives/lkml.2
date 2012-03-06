Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab2CFIS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 03:18:57 -0500
Received: from www.linutronix.de ([62.245.132.108]:56722 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab2CFIS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 03:18:56 -0500
Date: Tue, 6 Mar 2012 09:18:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Clark Williams <clark@redhat.com>, John Kacur <jkacur@redhat.com>,
        Carsten Emde <cbe@osadl.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RT] seqlock/rt: Prevent livelocks with seqlocks in RT
In-Reply-To: <1331006584.25686.362.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.02.1203060911000.2742@ionos>
References: <1331006584.25686.362.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2012, Steven Rostedt wrote:

> Thomas,
> 
> I was running my cpu hotplug stress test along with a kernel compile and
> after about 40 minutes of running it locked up. It happened in the
> read_seqcount_begin() that is called by d_lookup().
> 
> ksoftirqd was caught here:
> 
> static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
> {
> 	unsigned ret;
> 
> repeat:
> 	ret = ACCESS_ONCE(sl->sequence);
> 	if (unlikely(ret & 1)) {
> 		cpu_relax();
> 		goto repeat;
> 	}
> 	smp_rmb();
> 
> 	return ret;
> }
> 
> It preempted the holder of the seqlock that was held for write, and as
> that holder had migrate disabled, it couldn't be scheduled. Then
> ksoftirqd went into this infinite loop and the system locked up.
> 
> This patch fixes the issue by grabbing and releasing the write lock when
> it detects contention. It only works with seqlocks and not seqcounts
> that have their own locking. But we could add an api to include those
> too if needed.

Errm. rt15 has 

/*
 * Starvation safe read side for RT
 */
static inline unsigned read_seqbegin(seqlock_t *sl)
{
        unsigned ret;

repeat:
        ret = sl->seqcount.sequence;
        if (unlikely(ret & 1)) {
                /*
                 * Take the lock and let the writer proceed (i.e. evtl
                 * boost it), otherwise we could loop here forever.
                 */
                spin_lock(&sl->lock);
                spin_unlock(&sl->lock);
                goto repeat;
        }
        return ret;
}
#endif

> Because read_seqlocks are used in the VDSO area, a raw_read_seqcount_begin()
> was created to allow userspace tasks to access read_seqcount().
> As the grabbing of the write_lock() is not allowed in VDSO, nor
> is even referencing it.

This is completely bogus. The VDSO update write side runs with
interrupts disabled, so it cannot be preempted at all.

> Note, a live lock can still happen if the userspace task that
> does the read_seqlock is of higher priority than a user doing
> the write_lock, so userspace needs to be careful.

What the hell are you smoking?
 
Thanks,

	tglx
