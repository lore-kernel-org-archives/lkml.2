Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab0FPJKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 05:10:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:48050 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab0FPJKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 05:10:09 -0400
Date: Wed, 16 Jun 2010 19:10:04 +1000
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <eric.dumazet@gmail.com>, Mike Galbraith <efault@gmx.de>,
       "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Really lazy fpu
Message-ID: <20100616091003.GU6138@laptop>
References: <1276441427-31514-1-git-send-email-avi@redhat.com>
 <4C187C22.2080505@redhat.com>
 <4C187DF1.9030007@zytor.com>
 <4C188527.9040305@redhat.com>
 <20100616083941.GA27151@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616083941.GA27151@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 10:39:41AM +0200, Ingo Molnar wrote:
> 
> (Cc:-ed various performance/optimization folks)
> 
> * Avi Kivity <avi@redhat.com> wrote:
> 
> > On 06/16/2010 10:32 AM, H. Peter Anvin wrote:
> > >On 06/16/2010 12:24 AM, Avi Kivity wrote:
> > >>Ingo, Peter, any feedback on this?
> > > Conceptually, this makes sense to me.  However, I have a concern what
> > > happens when a task is scheduled on another CPU, while its FPU state is
> > > still in registers in the original CPU.  That would seem to require
> > > expensive IPIs to spill the state in order for the rescheduling to
> > > proceed, and this could really damage performance.
> > 
> > Right, this optimization isn't free.
> > 
> > I think the tradeoff is favourable since task migrations are much
> > less frequent than context switches within the same cpu, can the
> > scheduler experts comment?
> 
> This cannot be stated categorically without precise measurements of 
> known-good, known-bad, average FPU usage and average CPU usage scenarios. All 
> these workloads have different characteristics.
> 
> I can imagine bad effects across all sorts of workloads: tcpbench, AIM7, 
> various lmbench components, X benchmarks, tiobench - you name it. Combined 
> with the fact that most micro-benchmarks wont be using the FPU, while in the 
> long run most processes will be using the FPU due to SIMM instructions. So 
> even a positive result might be skewed in practice. Has to be measured 
> carefully IMO - and i havent seen a _single_ performance measurement in the 
> submission mail. This is really essential.

It can be nice to code an absolute worst-case microbenchmark too.

Task migration can actually be very important to the point of being
almost a fastpath in some workloads where threads are oversubscribed to
CPUs and blocking on some contented resource (IO or mutex or whatever).
I suspect the main issues in that case is the actual context switching
and contention, but it would be nice to see just how much slower it
could get.

