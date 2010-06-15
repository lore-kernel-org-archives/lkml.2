Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab0FOOgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 10:36:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:48810 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab0FOOgf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 10:36:35 -0400
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be
 reused immediately.
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tytso@mit.edu, Salman <sqazi@google.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tytso@google.com,
       torvalds@linux-foundation.org, walken@google.com,
       Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>
In-Reply-To: <20100614185556.afdc5304.akpm@linux-foundation.org>
References: <AANLkTinlnb-HsDia4X2qgRjkTL_Z5CfVKYHRFwREoyIn@mail.gmail.com>
	 <20100611224902.5039.60134.stgit@bumblebee1.mtv.corp.google.com>
	 <20100614165851.6bdfe485.akpm@linux-foundation.org>
	 <20100615005619.GI6666@thunk.org>
	 <20100614185556.afdc5304.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 15 Jun 2010 16:35:52 +0200
Message-ID: <1276612552.2077.7725.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-14 at 18:55 -0700, Andrew Morton wrote:
> > kernel/sched_clock.c:   if (cmpxchg64(&scd->clock, old_clock, clock) != old_cloc
> 
> I guess that'll flush out any stragglers.

cmpxchg64() is special, at the time i386 didn't handle the 8 byte
cmpxchg(), although we could easily make it do today.

> I suspect sched_clock.c might be generating fair amounts of code which
> UP builds don't need. 

Only sched_clock_remote() and its caller, something like the below, not
much code..

UP machines can still have utterly sucky TSC, although the
inter-cpu-drift thing isn't much of an issue ;-)

---
 kernel/sched_clock.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index 52f1a14..7ff5b56 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -170,6 +170,7 @@ again:
 	return clock;
 }
 
+#ifdef CONFIG_SMP
 static u64 sched_clock_remote(struct sched_clock_data *scd)
 {
 	struct sched_clock_data *my_scd = this_scd();
@@ -205,6 +206,7 @@ again:
 
 	return val;
 }
+#endif
 
 /*
  * Similar to cpu_clock(), but requires local IRQs to be disabled.
@@ -226,9 +228,11 @@ u64 sched_clock_cpu(int cpu)
 
 	scd = cpu_sdc(cpu);
 
+#ifdef CONFIG_SMP
 	if (cpu != smp_processor_id())
 		clock = sched_clock_remote(scd);
 	else
+#endif
 		clock = sched_clock_local(scd);
 
 	return clock;

