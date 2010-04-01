Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab0DAOGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 10:06:23 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:28280 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab0DAOGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 10:06:17 -0400
Date: Thu, 1 Apr 2010 10:04:00 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: "lkml, " <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Peter Morreale <pmorreale@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: RFC: Ideal Adaptive Spinning Conditions
Message-ID: <20100401140400.GD13190@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Darren Hart <dvhltc@us.ibm.com>,
	"lkml, " <linux-kernel@vger.kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Gregory Haskins <ghaskins@novell.com>,
	Sven-Thorsten Dietrich <sdietrich@novell.com>,
	Peter Morreale <pmorreale@novell.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	Eric Dumazet <eric.dumazet@gmail.com>
References: <4BB3D90C.3030108@us.ibm.com>
 <4BB400AA.7090408@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB400AA.7090408@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4BB4A835.00BB:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 07:10:50PM -0700, Darren Hart wrote:
> CC'ing the right Chris this time.
> 
> Darren Hart wrote:
> >I'm looking at some adaptive spinning with futexes as a way to
> >help reduce the dependence on sched_yield() to implement userspace
> >spinlocks. Chris, I included you in the CC after reading your
> >comments regarding sched_yield() at kernel summit and I thought
> >you might be interested.
> >
> >I have an experimental patchset that implements FUTEX_LOCK and
> >FUTEX_LOCK_ADAPTIVE in the kernel and use something akin to
> >mutex_spin_on_owner() for the first waiter to spin. What I'm
> >finding is that adaptive spinning actually hurts my particular
> >test case, so I was hoping to poll people for context regarding
> >the existing adaptive spinning implementations in the kernel as to
> >where we see benefit. Under which conditions does adaptive
> >spinning help?
> >
> >I presume locks with a short average hold time stand to gain the
> >most as the longer the lock is held the more likely the spinner
> >will expire its timeslice or that the scheduling gain becomes
> >noise in the acquisition time. My test case simple calls
> >"lock();unlock()" for a fixed number of iterations and reports the
> >iterations per second at the end of the run. It can run with an
> >arbitrary number of threads as well. I typically run with 256
> >threads for 10M iterations.
> >
> >         futex_lock: Result: 635 Kiter/s
> >futex_lock_adaptive: Result: 542 Kiter/s
> >
> >I've limited the number of spinners to 1 but feel that perhaps
> >this should be configurable as locks with very short hold times
> >could benefit from up to NR_CPUS-1 spinners.

We tried something similar in the original adaptive mutex
implementation.  I just went back and reread the threads and the biggest
boost in performance came when we:

1) didn't limit the number of spinners
2) didn't try to be fair to waiters

So, lets say we've spun for a while and given up and tossed a process
onto a wait queue.  One of the mutex iterations would see the process on
the wait queue and nicely hop on behind it.

We ended up changing things to spin regardless of what other processes
were doing, and that made a big difference.  The spinning loops have
cond_resched() sprinkled in important places to make sure we don't keep
the CPU away from the process that actually owns the mutex.

> >
> >I'd really appreciate any data, just general insight, you may have
> >acquired while implementing adaptive spinning for rt-mutexes and
> >mutexes. Open questions for me regarding conditions where adaptive
> >spinning helps are:
> >
> >o What type of lock hold times do we expect to benefit?
> >o How much contention is a good match for adaptive spinning?
> >  - this is related to the number of threads to run in the test
> >o How many spinners should be allowed?
> >

The btrfs benchmarks I was doing on the mutexes had 50 processes on a 4
CPU system, and no limits on the number of spinning processes.  The
locks they were hitting were btree locks that were heavily contended for
each operation.

Most of the time, btrfs is able to take the mutex, do a short operation
and release the mutex without scheduling.

-chris

