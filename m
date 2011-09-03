Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab1ICKKP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 06:10:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:55277 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab1ICKKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 06:10:12 -0400
Date: Sat, 3 Sep 2011 12:09:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Shan Hai <haishan.bai@gmail.com>, eric.dumazet@gmail.com,
        vapier@gentoo.org, asharma@fb.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Subject: Re: [PATCH V3 1/1] lib/atomic64 using raw_spin_lock_irq[save|resotre]
 for atomicity
In-Reply-To: <20110902155748.55b0dd1a.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.02.1109031159450.2723@ionos>
References: <1314925851-28163-1-git-send-email-haishan.bai@gmail.com> <1314925851-28163-2-git-send-email-haishan.bai@gmail.com> <20110902155748.55b0dd1a.akpm@linux-foundation.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Sep 2011, Andrew Morton wrote:
> On Fri,  2 Sep 2011 09:10:51 +0800
> Shan Hai <haishan.bai@gmail.com> wrote:
> : [eb459b90] [c068b1e0] rt_spin_lock_slowlock+0x40/0x3a8 (unreliable)
> : [eb459c20] [c068bdb0] rt_spin_lock+0x40/0x98
> : [eb459c40] [c03d2a14] atomic64_read+0x48/0x84
> : [eb459c60] [c001aaf4] perf_event_interrupt+0xec/0x28c
> : [eb459d10] [c0010138] performance_monitor_exception+0x7c/0x150
> : [eb459d30] [c0014170] ret_from_except_full+0x0/0x4c
> 
> But I don't think the patch is applicable to mainline anyway, is it?

It is not necessary for mainline, but we have already quite a lot of
these raw_spinlock conversions in tree. That helps us to keep the size
and intrusiveness of RT lower.

> What's actually going on here?  A spin_lock_irq() which doesn't disable
> interrupts sounds fairly moronic.  Is it the case that preempt-rt
> converts interrupt code to thread context, so spin_lock_irq() only
> needs to lock against other thread-context code?

Right, as RT enforces threaded interrupts for almost everything we can
convert the spinlocks (not the raw_ variant) to "sleeping spinlocks",
i.e. rtmutex.

Now some interrupts cannot be threaded for various reasons and there
we need to look at the locking and convert those locks to
raw_spinlocks.
 
> If so, what's special about the ppc performance counter interrupt? 
> Shouldn't that be covnerted to thread context as well?

No, we can't. We need to read out stuff when the interrupt happens and
not at some random point afterwards. Also perf interrupts can come
with high frequency when used for profiling.

> If that isn't possible, does this mean that all locking/atomic code
> which runs in the perf counter interrupt needs to be converted to use
> raw_irq_foo()?

Pretty much. The perf code itself already uses the raw variants, we
just missed this atomic64 emulation muck.

> > @@ -29,7 +29,7 @@
> >  * Ensure each lock is in a separate cacheline.
> >  */
> > static union {
> > -	spinlock_t lock;
> > +	raw_spinlock_t lock;
> >  	char pad[L1_CACHE_BYTES];
> >  } atomic64_lock[NR_LOCKS] __cacheline_aligned_in_smp;
> 
> There is no way on this little green earth that a reader of this code
> will be able to work out that a raw_spinlock_t was used because of
> something to do with ppc performance counter interrupts!
> 
> Therefore a code comment is needed.

There is another reason why it makes sense to convert this to a raw
spinlock. The protected code sections are just a few instructions, so
making it a sleeping lock would be overkill - even if it wouldnt be
used in the ppc performance counter interrupt .

Thanks,

	tglx
