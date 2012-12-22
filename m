Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab2LVDtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 22:49:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13601 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab2LVDtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 22:49:12 -0500
X-Authority-Analysis: v=2.0 cv=O9a7TWBW c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wom5GMh1gUkA:10 a=LbxuPOGo2iIA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KHWtOVqwwCMA:10 a=smjgYRus_AsYoMcq7e0A:9 a=CjuIK1q_8ugA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Date: Fri, 21 Dec 2012 22:49:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Rik van Riel <riel@redhat.com>
Cc: David Daney <ddaney.cavm@gmail.com>, linux-kernel@vger.kernel.org,
        aquini@redhat.com, walken@google.com, lwoodman@redhat.com,
        jeremy@goop.org, Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 3/3] x86,smp: auto tune spinlock backoff delay factor
Message-ID: <20121222034910.GG27621@home.goodmis.org>
References: <20121221184940.103c31ad@annuminas.surriel.com>
 <20121221185147.4ae48ab5@annuminas.surriel.com>
 <50D5033A.2070309@gmail.com>
 <50D52037.60602@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50D52037.60602@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 09:51:35PM -0500, Rik van Riel wrote:
> On 12/21/2012 07:47 PM, David Daney wrote:
> 
> >>+#define MIN_SPINLOCK_DELAY 1
> >>+#define MAX_SPINLOCK_DELAY 1000
> >>+DEFINE_PER_CPU(int, spinlock_delay) = { MIN_SPINLOCK_DELAY };
> >
> >
> >This gives the same delay for all locks in the system, but the amount of
> >work done under each lock is different.  So, for any given lock, the
> >delay is not optimal.
> >
> >This is an untested idea that came to me after looking at this:
> >
> >o Assume that for any given lock, the optimal delay is the same for all
> >CPUs in the system.
> >
> >o Store a per-lock delay value in arch_spinlock_t.

This can bloat the data structures. I would like to avoid that.

> >
> >o Once a CPU owns the lock it can update the delay as you do for the
> >per_cpu version.  Tuning the delay on fewer of the locking operations
> >reduces bus traffic, but makes it converge more slowly.
> >
> >o Bonus points if you can update the delay as part of the releasing store.
> 
> It would absolutely have to be part of the same load and
> store cycle, otherwise we would increase bus traffic and
> defeat the purpose.
> 
> However, since spinlock contention should not be the
> usual state, and all a scalable lock does is make sure
> that N+1 CPUs does not perform worse than N CPUs, using
> scalable locks is a stop-gap measure.
> 
> I believe a stop-gap measure should be kept as simple as
> we can. I am willing to consider moving to a per-lock
> delay factor if we can figure out an easy way to do it,
> but I would like to avoid too much extra complexity...

Rik,

I like your solution. It's rather simple and simple solutions tend to
end up being the closest to optimal. The more complex a solution gets,
the more it starts chasing fireflies.

Locks that are not likely to be contended will most likely not hit this
code, as it only gets triggered when contended. Now, really the wait
will be the size of the critical section. If quick locks gets hit a lot,
the auto delay will shink. If long critical sections start getting
contention, the auto delay will grow. But the general delay should
become a balance in the system that should be ideal. Kind of like the
NUMA balancing ;-)

Anyway, I'd like to see this code tested, and more benchmarks run
against it.

Thanks,

-- Steve


