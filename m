Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968Ab1FQTlz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 15:41:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:50590 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339Ab1FQTlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 15:41:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,382,1304319600"; 
   d="scan'208";a="19582494"
Date: Fri, 17 Jun 2011 12:40:29 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        "Luck, Tony" <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@kernel.dk>,
        Namhyung Kim <namhyung@gmail.com>, "Shi, Alex" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: REGRESSION: Performance regressions from switching
 anon_vma->lock to mutex
Message-ID: <20110617194029.GA28954@tassilo.jf.intel.com>
References: <1308173849.15315.91.camel@twins>
 <BANLkTim5TPKQ9RdLYRxy=mphOVKw5EXvTA@mail.gmail.com>
 <1308255972.17300.450.camel@schen9-DESK>
 <BANLkTinptaydNvK4ZvGvy0KVLnRmmza7tA@mail.gmail.com>
 <BANLkTi=GPtwjQ-bYDNUYCwzW5h--y86Law@mail.gmail.com>
 <BANLkTim-dBjva9w7AajqggKT3iUVYG2euQ@mail.gmail.com>
 <BANLkTimLV8aCZ7snXT_Do+f4vRY0EkoS4A@mail.gmail.com>
 <BANLkTinUBTYWxrF5TCuDSQuFUAyivXJXjQ@mail.gmail.com>
 <1308310080.2355.19.camel@twins>
 <BANLkTin3onK+43LxODfbu-sdm-pFut0TKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin3onK+43LxODfbu-sdm-pFut0TKw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 09:46:00AM -0700, Linus Torvalds wrote:
> On Fri, Jun 17, 2011 at 4:28 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> > Something like so? Compiles and runs the benchmark in question.
> 
> Oh, and can you do this with a commit log and sign-off, and I'll put
> it in my "anon_vma-locking" branch that I have. I'm not going to
> actually merge that branch into mainline until I've seen a few more
> acks or more testing by Tim.
> 
> But if Tim's numbers hold up (-32% to +15% performance by just the
> first one, and +15% isn't actually an improvement since tmpfs
> read-ahead should have gotten us to +66%), I think we have to do this
> just to avoid the performance regression.

You could also add the mutex "optimize caching protocol" 
patch I posted earlier to that branch.

It didn't actually improve Tim's throughput number, but it made the CPU 
consumption of the mutex go down. 

-Andi

---
>From 34d4c1e579b3dfbc9a01967185835f5829bd52f0 Mon Sep 17 00:00:00 2001
From: Andi Kleen <ak@linux.intel.com>
Date: Tue, 14 Jun 2011 16:27:54 -0700
Subject: [PATCH] mutex: while spinning read count before attempting cmpxchg

Under heavy contention it's better to read first before trying
to do an atomic operation on the interconnect.

This gives a few percent improvement for the mutex CPU time
under heavy contention and likely saves some power too.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/kernel/mutex.c b/kernel/mutex.c
index d607ed5..1abffa9 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -170,7 +170,8 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		if (owner && !mutex_spin_on_owner(lock, owner))
 			break;
 
-		if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
+		if (atomic_read(&lock->count) == 1 && 
+		    atomic_cmpxchg(&lock->count, 1, 0) == 1) {
 			lock_acquired(&lock->dep_map, ip);
 			mutex_set_owner(lock);
 			preempt_enable();



-- 
ak@linux.intel.com -- Speaking for myself only
