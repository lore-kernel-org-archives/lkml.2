Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab1EDWEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 18:04:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:35762 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab1EDWEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 18:04:47 -0400
Date: Thu, 5 May 2011 00:04:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Kleikamp <dkleikamp@gmail.com>
cc: Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: idle issues running sembench on 128 cpus
In-Reply-To: <4DC1C95B.4040706@gmail.com>
Message-ID: <alpine.LFD.2.02.1105042348350.3005@ionos>
References: <4DC1C95B.4040706@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

On Wed, 4 May 2011, Dave Kleikamp wrote:

> Thomas,
> I've been looking at performance running sembench on a 128-cpu system and I'm
> running into some issues in the idle loop.
> 
> Initially, I was seeing a lot of contention on the clockevents_lock in
> clockevents_notify(). Assuming it is only protecting clockevents_chain, and
> not the handlers themselves, I changed this to an rwlock (with thoughts of
> using rcu if successful).
> 
> This didn't help, but exposed an underlying problem with high contention on
> tick_broadcast_lock in tick_broadcast_oneshot_control(). I think with this
> many cpus, tick_handle_oneshot_broadcast() is holding that lock a long time,
> causing the idle cpus to spin on the lock.
> 
> I am able to avoid this problem with either kernel parameter, "idle=mwait" or
> "processor.max_cstate=1". Similarly, defining CONFIG_INTEL_IDLE=y and using
> the kernel parameter intel_idle.max_cstate=1 exposes a different spinlock,
> pm_qos_lock, but I found this patch which fixes that contention:
> https://lists.linux-foundation.org/pipermail/linux-pm/2011-February/030266.html
> https://patchwork.kernel.org/patch/550721/
> 
> Of course, we'd like to find a way to reduce the spinlock contention and not
> resort to prohibiting the cpus from entering C3 state at all. I don't see a
> simple fix, and want to know if you've seen anything like this before and
> given it any thought.
> 
> I also don't know if it makes sense to be able to tune the cpuidle governors
> to add more resistance to enter the C3 state, or even being able to switch to
> a performance governor at runtime, similar to cpufreq.
> 
> I'd like to hear your thoughts before I dive any deeper into this.

Tick broadcasting for more than a few CPU's simply does not scale and
never will.

There is no real way to avoid the global lock if all what you have is
_ONE_ global working event device and N cpus which try to work around
their f*cked up local apics when deeper C-States are entered.

The same problem is with the TSC which stops in deeper C-States. You
just don't see lock contention because we rely on the HW serialization
of HPET or PM_TIMER which is a huge bottleneck when you try to do
timekeeping related stuff high frequency on more than a handful of
cores at the same time. Just benchmark a tight loop of gettimeofday()
or clock_gettime() on such a machine with and without max_cstate=1 on
the kernel command line.

We could perhaps get away w/o the locking for the NOHZ=n and HIGHRES=n
case, but I doubt that you want to have that given that you don't want
to restrict C-States either. C-states do not make much sense without
NOHZ=y at least.

We tried to beat sense into unnamed HW manufacturers for years and it
took just a little bit more than a decade that they started to act on
it :(

Thanks,

	tglx
