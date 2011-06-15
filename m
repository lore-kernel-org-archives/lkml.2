Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab1FOAhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 20:37:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:15846 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666Ab1FOAhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 20:37:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,368,1304319600"; 
   d="scan'208";a="13595240"
Date: Tue, 14 Jun 2011 17:36:00 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Tony Luck <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@kernel.dk>,
        Namhyung Kim <namhyung@gmail.com>, shaohua.li@intel.com,
        alex.shi@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: REGRESSION: Performance regressions from switching
 anon_vma->lock to mutex
Message-ID: <20110615003600.GA9602@tassilo.jf.intel.com>
References: <1308097798.17300.142.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308097798.17300.142.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 2.6.39, the contention of anon_vma->lock occupies 3.25% of cpu.
> However, after the switch of the lock to mutex on 3.0-rc2, the mutex
> acquisition jumps to 18.6% of cpu.  This seems to be the main cause of
> the 52% throughput regression.
> 
This patch makes the mutex in Tim's workload take a bit less CPU time
(4% down) but it doesn't really fix the regression. When spinning for a 
value it's always better to read it first before attempting to write it.
This saves expensive operations on the interconnect.

So it's not really a fix for this, but may be a slight improvement for 
other workloads.

-Andi

>From 34d4c1e579b3dfbc9a01967185835f5829bd52f0 Mon Sep 17 00:00:00 2001
From: Andi Kleen <ak@linux.intel.com>
Date: Tue, 14 Jun 2011 16:27:54 -0700
Subject: [PATCH] mutex: while spinning read count before attempting cmpxchg

Under heavy contention it's better to read first before trying
to do an atomic operation on the interconnect.

This gives a few percent improvement for the mutex CPU time
under heavy contention and likely saves some power too.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/mutex.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

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
1.7.4.4

